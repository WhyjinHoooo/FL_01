<%@page import="java.io.BufferedReader"%>
<%@page import="org.json.simple.JSONValue"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@ include file="../mydbcon.jsp" %>

<%
    // 클라이언트로부터 받은 데이터를 읽습니다.
    BufferedReader reader = request.getReader();
    StringBuilder sb = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
        sb.append(line);
    }
    String jsonData = sb.toString();

    // JSON 문자열을 JSONObject로 변환합니다.
    JSONObject dataToSend = (JSONObject) JSONValue.parse(jsonData);

    // 출력할 키의 순서를 지정합니다.
    String[] keys = {
        "OrderNum", "OIN", "MatCode", "MatDes", "MatType", "OrderCount", 
        "OrderUnit", "Oriprice", "PriUnit", "OrdPrice", "MonUnit", "Date", "SlocaCode", "plantCode",
    };

    // 데이터를 콘솔에 출력합니다.
    System.out.println("Received Data:");
    for (String key : keys) {
        System.out.println(key + ": " + dataToSend.get(key));
    }

    // 데이터베이스 연결을 설정합니다.
    String sql = "INSERT INTO ordertable(Mmpo, ItemNo, Material, MatDes, Type, Count, BuyUnit, OriPrice, PriUnit, Price, money, Hope, Warehouse, Plant) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; 
    PreparedStatement pstmt = conn.prepareStatement(sql);
    /*쿼리문 중 ItemNo, Count에 입력되는 데이터는 int고 OriPrice,Price에 입력되는 데이터는 double이여야 한다.  */

    try {
        // 파라미터를 설정합니다.
        for (int i = 0; i < keys.length; i++) {
            String key = keys[i];
            String value = dataToSend.get(key).toString();
            
            if (key.equals("ItemNo") || key.equals("Count")) {
                pstmt.setInt(i + 1, Integer.parseInt(value));
            } else if (key.equals("Oriprice") || key.equals("OrdPrice")) {
                pstmt.setDouble(i + 1, Double.parseDouble(value));
            } else {
                pstmt.setString(i + 1, value);
            }
        }

        // SQL 쿼리를 실행합니다.
        pstmt.executeUpdate();
        
        // 성공적으로 쿼리가 실행되면, 받은 데이터를 그대로 반환합니다.
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(dataToSend.toJSONString());
    } catch (SQLException e) {
        e.printStackTrace();
    } finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	conn.close();
%>

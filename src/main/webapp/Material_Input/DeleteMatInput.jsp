<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jsonResponse = new JSONObject();  // response를 jsonResponse로 이름 변경
    String jsonData = request.getParameter("List");
    JSONParser parser = new JSONParser();
    try {
        // 파라미터로 받은 JSON 데이터를 파싱
        JSONArray deletedItems = (JSONArray) parser.parse(jsonData);
        
        // MySQL 연결
        Statement st = conn.createStatement();
        
        String MatCode = null;
        String PoCode = null;
        int Count = 0;
        // 삭제된 항목들에 대해 반복
        for (int i = 0; i < deletedItems.size(); i++) {
            JSONObject item = (JSONObject) deletedItems.get(i);
            String LotName = (String) item.get("LotName");
            
            MatCode = (String) item.get("MatCode");
            PoCode = (String) item.get("PoNum");
            Count = Integer.parseInt((String) item.get("Count"));
            
            if(item == null ) {
                System.out.println(item + "에는 데이터가 존제하지 않습니다.");
                continue;
            }

            System.out.println("삭제할 LotName: " + LotName);  // log 추가
            System.out.println("삭제할MatCode: " + MatCode);  // log 추가
            System.out.println("삭제할PoCode: " + PoCode);  // log 추가
            System.out.println("삭제할Count: " + Count);  // log 추가
            
            // 해당 항목을 DB에서 삭제
            String sql = "DELETE FROM temtable WHERE LotName='" + LotName + "'";
            int result = st.executeUpdate(sql);
           
            
           
            if (result > 0) {
                // 삭제 성공
                jsonResponse.put("result", true);  // jsonResponse 사용
            } else {
                // 삭제 실패
                jsonResponse.put("result", false);  // jsonResponse 사용
                jsonResponse.put("message", "해당 항목이 데이터베이스에 존재하지 않습니다.");  // jsonResponse 사용
            }
        }
        
        String SelectSQL = "SELECT * FROM pochild WHERE MMPO = ? AND MatCode = ?";
        PreparedStatement pstmt = conn.prepareStatement(SelectSQL);
        pstmt.setString(1, PoCode);
        pstmt.setString(2, MatCode);
        ResultSet rs = pstmt.executeQuery();
        
        String ModifiedSQL = "UPDATE pochild SET Count = ?, PO_Rem = ? WHERE MMPO = ? AND MatCode = ?";
        PreparedStatement Mpstmt = conn.prepareStatement(ModifiedSQL);
        
        
        if(rs.next()){
        	int ModifiedCount = Integer.parseInt(rs.getString("Count")) - Count;
        	int ModifiedPoRem = Integer.parseInt(rs.getString("PO_Rem")) + Count;
        	System.out.println("====================================");
        	System.out.println("삭제할 ModifiedCount: " + ModifiedCount);
        	System.out.println("삭제할 ModifiedPoRem: " + ModifiedPoRem);
        	System.out.println("====================================");
        	
        	Mpstmt.setInt(1, ModifiedCount);
        	Mpstmt.setInt(2, ModifiedPoRem);
        	Mpstmt.setString(3, PoCode);
        	Mpstmt.setString(4, MatCode);
        	
        	Mpstmt.executeUpdate();
        }
        
        String ResetSQL = "SET @row_number = 0";
        String SortSQL = "UPDATE temtable SET ItemNum = LPAD(@row_number:=@row_number+1, 4, '0') ORDER BY Seq";
        PreparedStatement ResetPSTMT = conn.prepareStatement(ResetSQL);
        PreparedStatement SortPSTMT = conn.prepareStatement(SortSQL);
        ResetPSTMT.executeUpdate();
        SortPSTMT.executeUpdate();
        ResetPSTMT.executeUpdate();
        
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse.put("result", false);  // jsonResponse 사용
        jsonResponse.put("message", e.getMessage());  // jsonResponse 사용
    }
    response.setContentType("application/json");  // response 객체의 setContentType 메서드 사용
    response.setCharacterEncoding("UTF-8");  // response 객체의 setCharacterEncoding 메서드 사용
    response.getWriter().write(jsonResponse.toString());  // response 객체의 getWriter 메서
%>

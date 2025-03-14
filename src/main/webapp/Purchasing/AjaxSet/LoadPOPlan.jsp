<%@ page import ="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@page import="org.json.simple.JSONValue"%>
<%@ page import ="org.json.JSONObject" %> 
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>  

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
		JSONObject dataToSend = new JSONObject(jsonString.toString());
		System.out.println(dataToSend);
		String Sql = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		switch(dataToSend.getString("UnitSum")){
		case"Solo":
			Sql = "SELECT * FROM request_rvw WHERE Plant = ? AND Vendor = ?";
			pstmt = conn.prepareStatement(Sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0,5));
			pstmt.setString(2, dataToSend.getString("PlantCode").substring(0,8));
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("", rs.getString("")); // 자재코드
				// 자재이름
				// 재고유형
				// 발줄계획수량
				// 단위
				// 공급업체
				// 공급업체이름
				// 구매단가
				// 거래통화
				// 납품요청일자
				// 납품장소
				// 발주계획번호
			}
			break;
		case "Sum":
			break;
		}
// 	    response.setContentType("application/json");
// 	    response.setCharacterEncoding("UTF-8");
// 	    response.getWriter().write(jsonArray.toString());
	} catch(Exception e){
		e.printStackTrace();
	}
%>


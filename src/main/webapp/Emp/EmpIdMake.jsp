<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String DateForNo = request.getParameter("DateId").replace("-", ""); // 정표 입력 일자 202406
	String firstId = DateForNo + "0001";
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM emp ORDER BY EMPLOYEE_ID DESC";
	pstmt = conn.prepareStatement(sql);
	/* pstmt.setString(1, firstId); */
	
	rs = pstmt.executeQuery();
	
	if(!rs.next()) {
		// 데이터가 없다면
		firstId = firstId;
	} else {
		// 데이터가 있다면 가장 최근에 등록된 데이터에 1을 더하여 저장
		/* System.out.println("Data found. Saving the incremented value of the most recent one."); */
		String recentData = rs.getString("EMPLOYEE_ID"); // 2024060001
		String numberPart = recentData.substring(6, 10); // PURO20240420S00001일 경우, 00001이 출력
		int incrementedValue = Integer.parseInt(numberPart) + 1;
		firstId = firstId.substring(0, 6) + String.format("%04d", incrementedValue);
		System.out.println("firstId: " + firstId);
	}
	out.print(firstId.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


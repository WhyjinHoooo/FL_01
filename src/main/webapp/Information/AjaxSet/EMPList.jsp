<%@page import="java.io.BufferedReader"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
	JSONObject saveListData = new JSONObject(jsonString.toString());
	
	String S_Word01 = saveListData.getString("Belong");
	String S_Word02 = saveListData.getString("CoCtSelect");
	String S_Word03 = saveListData.getString("Employee_ID");
	
	String EMP_Sql = "SELECT * FROM emp WHERE EMPLOYEE_ID = ? AND COMCODE = ? AND COCT = ?";
	PreparedStatement pstmt = conn.prepareStatement(EMP_Sql);
	pstmt.setString(1, S_Word03);
	pstmt.setString(2, S_Word01);
	pstmt.setString(3, S_Word02);
	ResultSet rs = pstmt.executeQuery();
	JSONObject Result = new JSONObject();
	if(!rs.next()){
		Result.put("status", "Fail");
	} else{
		 Result.put("status", "Success");
		 Result.put("UserInfoList", saveListData);
	}

	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	response.getWriter().write(Result.toString());
}catch(SQLException e){
	e.printStackTrace();
}
%>

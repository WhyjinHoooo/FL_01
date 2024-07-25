<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String userId = request.getParameter("I");
	String userName = request.getParameter("N");

	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM membership WHERE UserName = ? AND Id = ?";
	
	pstmt = conn.prepareStatement(sql);
	
	JSONObject message = new JSONObject();
	pstmt.setString(1, userName);
	pstmt.setString(2, userId);
	rs = pstmt.executeQuery();
	if(rs.next()){
		String AfPass = "0000";
		String ResetSql = "UPDATE membership SET PW = ? WHERE Id = ? AND UserName = ?";
		PreparedStatement ResetPstmt = conn.prepareStatement(ResetSql);
		ResetPstmt.setString(1, AfPass);
		ResetPstmt.setString(2, userId);
		ResetPstmt.setString(3, userName);
		ResetPstmt.executeUpdate();
		System.out.println("업데이트 성공");
		message.put("Pass", AfPass);
	} else{
		message.put("fail", "fail");
	}
	response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(message.toString());
}catch(SQLException e){
	e.printStackTrace();
}
%>
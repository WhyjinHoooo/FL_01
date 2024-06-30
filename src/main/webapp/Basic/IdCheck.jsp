<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Id = request.getParameter("CheckId");
	
	System.out.println("전달받은 검사할 아이디 : " + Id);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	
	String sql = "SELECT * FROM membership WHERE Id = ?";
	
	pstmt = conn.prepareStatement(sql);
	
	JSONObject message = new JSONObject();
	pstmt.setString(1, Id);
	rs = pstmt.executeQuery();
		if(!rs.next()){
			message.put("result", "good");
		} else{
			message.put("result", "bad");
		}
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(message.toString());
} catch(SQLException e){
	e.printStackTrace();
}
%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Name = request.getParameter("N");
	String Email = request.getParameter("E");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	
	String sql = "SELECT * FROM membership WHERE UserName = ? AND Email = ?";
	
	pstmt = conn.prepareStatement(sql);
	
	JSONObject message = new JSONObject();
	pstmt.setString(1, Name);
	pstmt.setString(2, Email);
	rs = pstmt.executeQuery();
		if(rs.next()){
			message.put("Id", rs.getString("Id"));
		} else{
			message.put("fail", "bad");
		}
		response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(message.toString());
} catch(SQLException e){
	e.printStackTrace();
}
%>


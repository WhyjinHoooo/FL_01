<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
JSONObject obj = new JSONObject();

try{
	String MovCode = request.getParameter("movcode").substring(0, 2);
	// System.out.println("전달받은 Movement Code : " + MovCode);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM totalmaterial_head";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	
	if(!rs.next() && (MovCode.equals("GI") || MovCode.equals("IR"))){
		obj.put("result", "fail");
		obj.put("message", "먼저 입고를 해주세요");		
	} else {
		obj.put("result", "success");
	}
	response.setContentType("application/json");
	out.print(obj);
	out.flush();
	
} catch(SQLException e){
	e.printStackTrace();
}
%>


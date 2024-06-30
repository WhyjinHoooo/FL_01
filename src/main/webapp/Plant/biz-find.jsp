<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String ComCode = request.getParameter("ComCode");
	System.out.println("ComCode : " + ComCode);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT BIZ_AREA FROM bizarea WHERE Com_Code = ?";
	pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1, ComCode);
	
	rs = pstmt.executeQuery();
	
	JSONArray bizArray = new JSONArray();
	
	while(rs.next()){
		bizArray.add(rs.getString("BIZ_AREA"));
	}
	JSONObject responseObj = new JSONObject();
	responseObj.put("BIZ", bizArray);
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(responseObj.toJSONString());
} catch(SQLException e){
	e.printStackTrace();
}
%>
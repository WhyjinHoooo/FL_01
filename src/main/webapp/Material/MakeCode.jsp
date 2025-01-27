<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String first = request.getParameter("first");
	System.out.println("first : " + first);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM matmaster WHERE SUBSTRING(Material_code, 1, 6) = ? ORDER BY Material_code DESC";
	pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1, first);
	
	rs = pstmt.executeQuery();
	
	if(!rs.next()) {
		first = first + "-0001";
	} else {
		String recentData = rs.getString("Material_code");
		String[] splitData = recentData.split("-");
		int incrementedValue = Integer.parseInt(splitData[1]) + 1;
		first = splitData[0] + "-" + String.format("%04d", incrementedValue);
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>

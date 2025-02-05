<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String first = request.getParameter("first") + "-0001";
	System.out.println("first : " + first);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM matmaster WHERE Material_code = ? ORDER BY Material_code DESC";
	pstmt = conn.prepareStatement(sql);
	
	boolean idFound = false;
	while(!idFound){
		pstmt.setString(1, first);
		rs = pstmt.executeQuery();
		
		if(!rs.next()) {
			idFound = true;
		} else {
			String recentData = rs.getString("Material_code");
			String[] splitData = recentData.split("-");
			int incrementedValue = Integer.parseInt(splitData[1]) + 1;
			first = splitData[0] + "-" + String.format("%04d", incrementedValue);
		}
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>

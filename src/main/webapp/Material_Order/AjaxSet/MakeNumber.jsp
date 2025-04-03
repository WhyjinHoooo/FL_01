<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Type = request.getParameter("Type");
	String Today = request.getParameter("Date"); 
	String Date = request.getParameter("Date").replace("-", ""); 
	System.out.println("1. Type : " + Type + ", Date : " + Date);
	String first = Type + Date + "S00001";
	System.out.println("1. first : " + first);
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM request_ord WHERE ActNumPO = ? ORDER BY ActNumPO DESC";
	pstmt = conn.prepareStatement(sql);
	
	boolean OrdNumChk = false;
	while(!OrdNumChk){
		pstmt.setString(1, first);		

		rs = pstmt.executeQuery();
		if(!rs.next()){
			OrdNumChk = true;
		}else{
			String recentData = rs.getString("ActNumPO");
			String numberPart = recentData.substring(13, 18);
			int incrementedValue = Integer.parseInt(numberPart) + 1;
			first = first.substring(0, 13) + String.format("%05d", incrementedValue);
		}
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
	System.out.println("SQL Exception: " + e.getMessage());
}
%>


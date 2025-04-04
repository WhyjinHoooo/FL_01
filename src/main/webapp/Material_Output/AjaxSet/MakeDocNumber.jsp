<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Code = request.getParameter("movCode");
	String Two_Code = Code.substring(0,2);
	String Date = request.getParameter("Outdate").replace("-", "");
	String first = "M" + Two_Code + Date + "S00001";
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT MatDocNum FROM storehead WHERE MatDocNum = ? ORDER BY MatDocNum DESC";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, first);
	rs = pstmt.executeQuery();
	
	pstmt = conn.prepareStatement(sql);
	boolean DupCheck = false;
	while(!DupCheck){
		pstmt.setString(1, first);
		rs = pstmt.executeQuery();
		if(!rs.next()){
			DupCheck = true;
		} else{
			String recentData = rs.getString("MatDocNum");
			String numberPart = 	recentData.substring(15);
			int incrementedValue = Integer.parseInt(numberPart) + 1;
			first = first.substring(0, 13) + String.format("%04d", incrementedValue);
		}
	}
	System.out.println(first.trim());
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


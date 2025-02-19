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
	String three = first.substring(0, 3);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT MatDocNum FROM storehead WHERE SUBSTRING(MatDocNum, 1, 3) = ? ORDER BY MatDocNum DESC";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, three);
	rs = pstmt.executeQuery();
	
	pstmt = conn.prepareStatement(sql);
	boolean DupCheck = false;
	while(!DupCheck){
		pstmt.setString(1, three);
		rs = pstmt.executeQuery();
		if(!rs.next()){
			DupCheck = true;
		} else{
			String recentData = rs.getString("MatDocNum");
			String numberPart = recentData.substring(15);
			int incrementedValue = Integer.parseInt(numberPart) + 1;
			first = first.substring(0, 13) + String.format("%05d", incrementedValue);
		}
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


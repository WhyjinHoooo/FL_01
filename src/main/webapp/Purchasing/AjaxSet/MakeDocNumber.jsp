<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Date = request.getParameter("Date").replace("-", "");
	String first = "PXRO" + Date + "S00001";
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	/* PREO20250310S00001 */
	String sql = "SELECT * FROM request_rvw WHERE PlanNumPO = ? ORDER BY PlanNumPO DESC";
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
			String numberPart = recentData.substring(14);
			int incrementedValue = Integer.parseInt(numberPart) + 1;
			first = first.substring(0, 13) + String.format("%05d", incrementedValue);
		}
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


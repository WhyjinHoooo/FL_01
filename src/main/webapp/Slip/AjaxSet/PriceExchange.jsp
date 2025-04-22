<%@page import="java.text.NumberFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String LedCurrency = request.getParameter("currencyCode"); // 장부통화
	int Price = Integer.parseInt(request.getParameter("dealPrice")); // 거래금액
	String DealCurrency = request.getParameter("DealCurrency"); // 거래통화
	Double ExRate = 0.0; 
	Double total = 0.0;
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	String sql = "SELECT * FROM exchangerate WHERE FrCurrency = ? AND ToCurrency = ? ORDER BY LocalDateTime DESC";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, LedCurrency);
	pstmt.setString(2, DealCurrency);
	
	rs = pstmt.executeQuery();
	
	if(rs.next()) {
		String exchangeRateString = rs.getString("ExchRate").replace(",", "");
		ExRate = Double.parseDouble(exchangeRateString);
		total = Math.round((Price / ExRate)*100)/100.0;
	} 
	out.print(total);
} catch(SQLException e){
	e.printStackTrace();
}
%>


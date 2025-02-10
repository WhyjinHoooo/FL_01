<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Type = request.getParameter("type"); // PURO
	String Today = request.getParameter("date"); // 오늘 날짜 예:2024-03-21
	String Date = request.getParameter("date").replace("-", ""); // 20240421
	System.out.println("Type : " + Type + " Date : " + Date);
	String first = Type + Date + "S00001";
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//String sql = "SELECT * FROM poheader WHERE SUBSTRING(Mmpo, 1, 4) = ? AND OrderDate = ? ORDER BY Mmpo DESC";
	String sql = "SELECT * FROM poheader WHERE Mmpo = ? ORDER BY Mmpo DESC";
	pstmt = conn.prepareStatement(sql);
	
	boolean OrdNumChk = false;
	while(!OrdNumChk){
// 		pstmt.setString(1, Type);
// 		pstmt.setString(2, Today);
		pstmt.setString(1, first);		

		rs = pstmt.executeQuery();
		if(!rs.next()){
			OrdNumChk = true;
		}else{
			String recentData = rs.getString("Mmpo");
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


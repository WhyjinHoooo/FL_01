<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
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
	
	/* String sql = "SELECT * FROM ordertable WHERE SUBSTRING(Mmpo, 1, 18) = ? ORDER BY Seq ASC"; */
	String sql = "SELECT * FROM poheader WHERE SUBSTRING(Mmpo, 1, 4) = ? AND OrderDate = ? ORDER BY Mmpo DESC";
	/* String sql = "SELECT * FROM ordertable ORDER BY Seq DESC"; */
	pstmt = conn.prepareStatement(sql);
	
	/* pstmt.setString(1, first); */
	pstmt.setString(1, Type);
	pstmt.setString(2, Today);
	
	rs = pstmt.executeQuery();
	
	if(!rs.next()) {
		// 데이터가 없다면
		first = first;
	} else {
		// 데이터가 있다면 가장 최근에 등록된 데이터에 1을 더하여 저장
		/* System.out.println("Data found. Saving the incremented value of the most recent one."); */
		String recentData = rs.getString("Mmpo");
		String numberPart = recentData.substring(13, 18);
		int incrementedValue = Integer.parseInt(numberPart) + 1;
		first = first.substring(0, 13) + String.format("%05d", incrementedValue);
		
		System.out.println("Recent Data: " + recentData);
		System.out.println("Number Part: " + numberPart);
		System.out.println("Incremented Value: " + incrementedValue);
		System.out.println("first: " + first);
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


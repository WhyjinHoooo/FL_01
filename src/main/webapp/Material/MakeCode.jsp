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
		// 데이터가 없다면
		/* System.out.println("No data found. Appending '-00001' to the initial value."); */
		first = first + "-00001";
	} else {
		// 데이터가 있다면 가장 최근에 등록된 데이터에 1을 더하여 저장
		/* System.out.println("Data found. Saving the incremented value of the most recent one."); */
		String recentData = rs.getString("Material_code");
		String[] splitData = recentData.split("-");
		int incrementedValue = Integer.parseInt(splitData[1]) + 1;
		first = splitData[0] + "-" + String.format("%05d", incrementedValue);
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>

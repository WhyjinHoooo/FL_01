<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String ComCode = request.getParameter("Com"); // 회사코드
	String first = null;
	String Curr = null;
	System.out.println("전달 받은 회사 코드: " + ComCode);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	/* String sql = "SELECT * FROM ordertable WHERE SUBSTRING(Mmpo, 1, 18) = ? ORDER BY Seq ASC"; */
	String sql = "SELECT * FROM company WHERE Com_Cd = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, ComCode);
	
	rs = pstmt.executeQuery();
	
/* 	System.out.println(sql + ", " + NowDocNum); */

	if(rs.next()) {
		Curr = rs.getString("Local_Currency");
		System.out.println("해당 기업의 통화: " + Curr);
	} 
	out.print(Curr.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


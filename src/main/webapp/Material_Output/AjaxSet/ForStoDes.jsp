<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
String Code = request.getParameter("SLoCode");
String Des = null;
try{
	String sql = "SELECT * FROM storage WHERE STORAGR_ID = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, Code);
	ResultSet rs = pstmt.executeQuery();
	if(rs.next()){
		Des = rs.getString("STORAGR_NAME");
	}	
	out.print(Des);
}catch(SQLException e){
	e.printStackTrace();
}
%>

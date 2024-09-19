<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Word = request.getParameter("User_Id");
	String sql = "SELECT * FROM membership WHERE Id = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, S_Word);
	ResultSet rs = pstmt.executeQuery();
	String UserRight = null;
	try{
		if(!rs.next()){
			UserRight = "NOPE";
		} else {
			UserRight = rs.getString("UserRight");
		}
		out.print(UserRight);
}catch(SQLException e){
	e.printStackTrace();
}finally {
    if(rs != null) try { rs.close(); } catch(SQLException e) {}
    if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
}
%>

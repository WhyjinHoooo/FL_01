<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Word = request.getParameter("SendWord");
	String sql = "SELECT * FROM dept WHERE ComCode LIKE ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, "%"+S_Word+"%");
	ResultSet rs = pstmt.executeQuery();
	try{
		if(!rs.next()){
%>
	<option>없음</option>
<%
		} else {
		do{
%>
	<option value='<%= rs.getString("COCT")%>'>(<%= rs.getString("COCT")%>)<%= rs.getString("COCT_NAME")%></option>
<%
		}while(rs.next());
	}
}catch(SQLException e){
	e.printStackTrace();
}finally {
    if(rs != null) try { rs.close(); } catch(SQLException e) {}
    if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
}
%>

<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String pass = null;
	
	String S_Word01 = request.getParameter("S_ComCode");
	String EMP_Sql = "SELECT * FROM taxarea WHERE ComCode = ? AND MAIN_SUB = ?";
	PreparedStatement pstmt = conn.prepareStatement(EMP_Sql);
	pstmt.setString(1, S_Word01);
	pstmt.setString(2, "1");
	ResultSet rs = pstmt.executeQuery();
	try{
		if(rs.next()){
			pass = "No"; // 중복되는 데이터가 있는 경우
		} else{
			pass = "Yes"; // 중복되는 데이터가 없는 경우
		}
		out.print(pass);
}catch(SQLException e){
	e.printStackTrace();
}finally {
    if(rs != null) try { rs.close(); } catch(SQLException e) {}
    if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
}
%>

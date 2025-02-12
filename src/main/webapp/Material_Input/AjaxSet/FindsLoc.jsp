<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@page import="java.sql.SQLException"%>  

<%
try{
	String SLOCCode = request.getParameter("sloccode");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM storage WHERE STORAGR_ID = ?";
	pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1, SLOCCode);
	
	rs = pstmt.executeQuery();

	String SLOC_name = null;
	if(rs.next()){
		SLOC_name = rs.getString("STORAGR_NAME");
		System.out.println("Storage Name : " + SLOC_name);
	}
	
	out.println(SLOC_name);
} catch(SQLException e){
	e.printStackTrace();
}
%>


<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
try{
	String UserId = request.getParameter("Id");
	String SearchSql = "SELECT * FROM project.dataadminkeytemptable WHERE UseriD = ?";
	PreparedStatement SearchPStmt = conn.prepareStatement(SearchSql);
	SearchPStmt.setString(1, UserId);
	ResultSet SearchRs = SearchPStmt.executeQuery();
	if(SearchRs.next()){
		System.out.println("성공");
		String ApplicationSql = "INSERT INTO dataadminkeytable ("
			    + "UseriD, EmployeeNAME, RnRCode, RnRDescp, UiNumber, UiDescrip, AuthorityBA, UiAuthority, COCD, CreateDate, Creator, DataAdminKey, ApprovalDate, ApproPerson, ValidDateFrom, ValidDateTo"
			    + ") "
			    + "SELECT "
			    + "UseriD, EmployeeNAME, RnRCode, RnRDescp, UiNumber, UiDescrip, AuthorityBA, UiAuthority, COCD, CreateDate, Creator, DataAdminKey, "
			    + "NULL AS ApprovalDate, "  
			    + "NULL AS ApproPerson, "     
			    + "NULL AS ValidDateFrom, "     
			    + "NULL AS ValidDateTo " 
			    + "FROM dataadminkeytemptable";
		PreparedStatement ApplicationPstmt = conn.prepareStatement(ApplicationSql);
		ApplicationPstmt.executeUpdate();
		
		String ResetSql = "DELETE FROM dataadminkeytemptable";
		PreparedStatement ResetPstmt = conn.prepareStatement(ResetSql);
		ResetPstmt.executeUpdate();
		
		String UpdateSql = "UPDATE membership SET UserRight = ? WHERE Id = ?";
		PreparedStatement UpdatePstmt = conn.prepareStatement(UpdateSql);
		UpdatePstmt.setString(1, "Ongoing");
		UpdatePstmt.setString(2, UserId);
		UpdatePstmt.executeUpdate();
		
		out.print("Success");
	}
	
}catch(SQLException e){
	e.printStackTrace();
}
%>
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
	
	String AnalySql = "SELECT * FROM project.dataadminkeytable WHERE UseriD = ?";
	PreparedStatement AnalyPStmt = conn.prepareStatement(AnalySql);
	AnalyPStmt.setString(1, UserId);
	ResultSet AnalyRs = AnalyPStmt.executeQuery();
	while(AnalyRs.next()){
		String Analy_UiNumber = AnalyRs.getString("UiNumber");
		String AnalySql_02 = "SELECT * FROM project.dataadminkeytemptable WHERE UseriD = ? AND UiNumber = ?";
		PreparedStatement AnalyPStmt_02 = conn.prepareStatement(AnalySql_02);
		AnalyPStmt_02.setString(1, UserId);
		AnalyPStmt_02.setString(2, Analy_UiNumber);
		ResultSet AnalyRs_02 = AnalyPStmt_02.executeQuery();
		if(!AnalyRs_02.next()){
			String Wipe_Sql = "DELETE FROM dataadminkeytable WHERE UseriD = ? AND UiNumber = ?";
			PreparedStatement Wipe_Pstmt = conn.prepareStatement(Wipe_Sql);
			Wipe_Pstmt.setString(1, UserId);
			Wipe_Pstmt.setString(2, Analy_UiNumber);
			Wipe_Pstmt.executeUpdate();
		}
	}
	
	while(SearchRs.next()){
		if(SearchRs.getString("Sort") == "TempVer"){
			System.out.println("TempVer");
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
		} else{
			String E_UiNumber = SearchRs.getString("UiNumber");
			String E_UiAuthority = SearchRs.getString("UiAuthority");
			String E_Sql = "SELECT * FROM dataadminkeytable WHERE UiNumber = ? AND UseriD = ?";
			
			PreparedStatement E_Pstmt = conn.prepareStatement(E_Sql);
			E_Pstmt.setString(1, E_UiNumber);
			E_Pstmt.setString(2, UserId);
			ResultSet E_Rs = E_Pstmt.executeQuery();
			
			String CheckSql = E_Pstmt.toString();
			System.out.println("E_UiNumber : " + E_UiNumber);
			System.out.println("E_UiAuthority : " + E_UiAuthority);
			System.out.println("CheckSql : " + CheckSql);
			if(E_Rs.next()){
				if(!E_UiAuthority.equals(E_Rs.getString("UiAuthority"))){
					String U_Sql = "UPDATE dataadminkeytable SET UiAuthority = ? WHERE UseriD = ? AND UiNumber = ?";
					
					PreparedStatement U_Pstmt = conn.prepareStatement(U_Sql);
					U_Pstmt.setString(1, E_UiAuthority);
					U_Pstmt.setString(2, UserId);
					U_Pstmt.setString(3, E_UiNumber);
					
					String SQLCHECK = U_Pstmt.toString();
					System.out.println("SQLCHECK : " + SQLCHECK);
					U_Pstmt.executeUpdate();
					
					String D_Sql = "DELETE FROM dataadminkeytemptable WHERE UseriD = ? AND UiNumber = ?";
					PreparedStatement D_Pstmt = conn.prepareStatement(D_Sql);
					D_Pstmt.setString(1, UserId);
					D_Pstmt.setString(2, E_UiNumber);
					D_Pstmt.executeUpdate();
				} else{
					String D_Sql = "DELETE FROM dataadminkeytemptable WHERE UseriD = ? AND UiNumber = ?";
					PreparedStatement D_Pstmt = conn.prepareStatement(D_Sql);
					D_Pstmt.setString(1, UserId);
					D_Pstmt.setString(2, E_UiNumber);
					D_Pstmt.executeUpdate();
				}
			}else{
				String ApplicationSql = "INSERT INTO dataadminkeytable ("
					    + "UseriD, EmployeeNAME, RnRCode, RnRDescp, UiNumber, UiDescrip, AuthorityBA, UiAuthority, COCD, CreateDate, Creator, DataAdminKey, ApprovalDate, ApproPerson, ValidDateFrom, ValidDateTo"
					    + ") "
					    + "SELECT "
					    + "UseriD, EmployeeNAME, RnRCode, RnRDescp, UiNumber, UiDescrip, AuthorityBA, UiAuthority, COCD, CreateDate, Creator, DataAdminKey, "
					    + "NULL AS ApprovalDate, "  
					    + "NULL AS ApproPerson, "     
					    + "NULL AS ValidDateFrom, "     
					    + "NULL AS ValidDateTo " 
					    + "FROM dataadminkeytemptable "
					    + "WHERE UiNumber = ? AND UseriD = ?";
				PreparedStatement ApplicationPstmt = conn.prepareStatement(ApplicationSql);
				ApplicationPstmt.setString(1, E_UiNumber);
				ApplicationPstmt.setString(2, UserId);
				ApplicationPstmt.executeUpdate();
				
				String D_Sql = "DELETE FROM dataadminkeytemptable WHERE UseriD = ? AND UiNumber = ?";
				PreparedStatement D_Pstmt = conn.prepareStatement(D_Sql);
				D_Pstmt.setString(1, UserId);
				D_Pstmt.setString(2, E_UiNumber);
				D_Pstmt.executeUpdate();
			}
		}
		
	}
	System.out.println("Success");
	out.print("Success");
}catch(SQLException e){
	e.printStackTrace();
}
%>
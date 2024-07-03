<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	
	try{

		String SearchHead = "SELECT * FROM tmpaccfldochead";
		PreparedStatement SH_Pstmt = conn.prepareStatement(SearchHead);
		ResultSet SH_rs =SH_Pstmt.executeQuery();
		
		String SearchChild = "SELECT * FROM tmpaccfldocline";
		PreparedStatement SC_Pstmt = conn.prepareStatement(SearchChild);
		ResultSet SC_rs =SC_Pstmt.executeQuery();
		
		String SearchLine = "SELECT * FROM tmpaccfidoclineinform";
		PreparedStatement SL_Pstmt = conn.prepareStatement(SearchLine);
		ResultSet SL_rs =SL_Pstmt.executeQuery();
		
		while(SH_rs.next()){
			String CopyHead = "INSERT INTO fldochead SELECT * FROM tmpaccfldochead";
			PreparedStatement CH_pstmt = conn.prepareStatement(CopyHead);
			CH_pstmt.executeUpdate();
			
			String DelHead = "DELETE FROM tmpaccfldochead";
			PreparedStatement DH_pstmt = conn.prepareStatement(DelHead);
			DH_pstmt.executeUpdate();
		} 
		while(SC_rs.next()){
			String CopyChild = "INSERT IGNORE INTO fldocline (DocNum, DocLineItem, Original, GLAccount, AcctDescrip, DebCre, TCurr, TAmount, LCurr, LAmount, UsingDepart, UscingDepDesc, UsingBA, DocDescrip, PostingDate, ComCode, InputPerson) " +
	                   "SELECT DocNum, DocLineItem, Original, GLAccount, AcctDescrip, DebCre, TCurr, TAmount, LCurr, LAmount, UsingDepart, UscingDepDesc, UsingBA, DocDescrip, PostingDate, ComCode, InputPerson " +
	                   "FROM tmpaccfldocline";
			PreparedStatement CC_pstmt = conn.prepareStatement(CopyChild);
			CC_pstmt.executeUpdate();
			
			String DelChild = "DELETE FROM tmpaccfldocline";
			PreparedStatement DC_pstmt = conn.prepareStatement(DelChild);
			DC_pstmt.executeUpdate();
		}
		while(SL_rs.next()){
			String CopyLineItem = "INSERT INTO fidoclineinform SELECT * FROM tmpaccfidoclineinform";
			PreparedStatement CL_pstmt = conn.prepareStatement(CopyLineItem);
			CL_pstmt.executeUpdate();
			
			String DelLine = "DELETE FROM tmpaccfidoclineinform";
			PreparedStatement DL_pstmt = conn.prepareStatement(DelLine);
			DL_pstmt.executeUpdate();
		}
		out.println("데이터 처리가 완료되었습니다.");
	}catch(SQLException e){
		e.printStackTrace();
		out.println("데이터 처리 중 오류가 발생했습니다: " + e.getMessage());
	}
%>
</body>
</html>
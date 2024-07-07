<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<title>Success</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	
	LocalDateTime now = LocalDateTime.now();
	String formattedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

	String Tac = request.getParameter("TAC");
	String Des = request.getParameter("Des");
	
	String ComCode = request.getParameter("Com-code");
	String NaCode = request.getParameter("Na-Code");
	
	String PosCode = request.getParameter("Pos-code");
	
	String Addr1 = request.getParameter("Addr1");
	String Addr2 = request.getParameter("Addr2");
	
	String Select = request.getParameter("Select_MS");
	String MainTa = null; 
	
	if(Select.equals("1")){
		MainTa = request.getParameter("main-TA-Code");
	} else{
		MainTa = request.getParameter("main-TA-Code");
	}
	
	String Use = request.getParameter("Use-Useless");
	
	int ID1 = 12345;
	int ID2 = 56789;

	String sql = "INSERT INTO taxarea VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	try{
		if(MainTa == null || MainTa.equals("")) {
			MainTa = ComCode;
		}
		pstmt.setString(1, Tac);
		pstmt.setString(2, Des);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, NaCode);
		pstmt.setString(5, PosCode);
		pstmt.setString(6, Addr1);
		pstmt.setString(7, Addr2);
		pstmt.setString(8, Select);
		pstmt.setString(9, MainTa);
		pstmt.setString(10, Use);
		pstmt.setString(11, formattedNow);
		pstmt.setInt(12, ID1);
		pstmt.setString(13, formattedNow);
		pstmt.setInt(14, ID2);
		
		pstmt.executeUpdate();
		
		out.println("<script>window.location.href='Tax-Regist.jsp';</script>");
	} catch(SQLException e){
		e.printStackTrace();
	} finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
		} catch(SQLException e){
			e.printStackTrace();
		}
	}
	conn.close();
%>
</body>
</html>
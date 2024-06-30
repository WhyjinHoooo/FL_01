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
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	LocalDateTime now = LocalDateTime.now();
	String formattedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	
	String ccg = request.getParameter("CCG");
	String Des = request.getParameter("Des");
	
	String ComCode = request.getParameter("Com-Code");
	String tccg = request.getParameter("tccg");
	
	int level = Integer.parseInt(request.getParameter("CCT-level"));
	String Upper = request.getParameter("Upper-CCT-Group");
	
	boolean Use = Boolean.parseBoolean(request.getParameter("Use-Useless"));
	
	int Id1 = 17011381;
	int Id2 = 76019202;
	
	String sql = "INSERT INTO coct VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	try{
		pstmt.setString(1, ccg);
		pstmt.setString(2, Des);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, tccg);
		pstmt.setInt(5, level);
		pstmt.setString(6, Upper);
		pstmt.setBoolean(7, Use);
		pstmt.setString(8, formattedNow);
		pstmt.setInt(9, Id1);
		pstmt.setString(10, formattedNow);
		pstmt.setInt(11, Id2);
		
		pstmt.executeUpdate();
	}catch(SQLException e){
		e.printStackTrace();
	} finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
		} catch(Exception e){
			e.printStackTrace();
		}
	}
	conn.close();
	
	System.out.println("Formatted Date: " + formattedNow);
	System.out.println("CCG: " + ccg);
	System.out.println("Des: " + Des);
	System.out.println("ComCode: " + ComCode);
	System.out.println("TCCG: " + tccg);
	System.out.println("Level: " + level);
	System.out.println("Upper: " + Upper);
	System.out.println("Use: " + Use);
%>
<script>
	alert("Complete");
	window.location.href="CCG-Regist.jsp";
</script>
</body>
</html>
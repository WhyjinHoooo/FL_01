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
	
	String Plant_id = request.getParameter("plant_code");
	String Plant_Des = request.getParameter("Des");
	
	String ComCode = request.getParameter("Com_Des");
	
	String Biz_Area = request.getParameter("Biz_Des");
	
	String Post_Code = request.getParameter("PosCode");
	
	String Addr1 = request.getParameter("PlantAddr1");
	String Addr2 = request.getParameter("PlantAddr2");
	
	String LocalCurr = request.getParameter("money");
	String Lang = request.getParameter("lang");
	
	String Start = request.getParameter("today");
	String End = request.getParameter("future"); 
	
	boolean Yn = Boolean.parseBoolean(request.getParameter("Use-Useless"));
	
	int id1 = 17011381;
	int id2 = 76019020;
	
	String sql = "INSERT INTO plant VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	try{
		pstmt.setString(1,Plant_id);
		pstmt.setString(2,Plant_Des);
		pstmt.setString(3,ComCode);
		pstmt.setString(4,Biz_Area);
		pstmt.setString(5,Post_Code);
		pstmt.setString(6,Addr1);
		pstmt.setString(7,Addr2);
		pstmt.setString(8,LocalCurr);
		pstmt.setString(9,Lang);
		pstmt.setString(10,Start);
		pstmt.setString(11,End);
		pstmt.setBoolean(12,Yn);
		pstmt.setString(13,formattedNow);
		pstmt.setInt(14,id1);
		pstmt.setString(15,formattedNow);
		pstmt.setInt(16,id2);
		
		pstmt.executeUpdate();
	}catch(SQLException e){
		e.printStackTrace();
	} finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	conn.close();
	
	System.out.println("Plant_id: " + Plant_id);
	System.out.println("Plant_Des: " + Plant_Des);
	System.out.println("ComCode: " + ComCode);
	System.out.println("Biz_Area: " + Biz_Area);
	System.out.println("Post_Code: " + Post_Code);
	System.out.println("Addr1: " + Addr1);
	System.out.println("Addr2: " + Addr2);
	System.out.println("LocalCurr: " + LocalCurr);
	System.out.println("Lang: " + Lang);
	System.out.println("Start: " + Start);
	System.out.println("End: " + End);
	System.out.println("Yn: " + Yn);
	System.out.println("Formatted Now: " + formattedNow);
	System.out.println("id1: " + id1);
	System.out.println("id2: " + id2);
%>
</body>
</html>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
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
	
	String CC_code = request.getParameter("cost_code");
	String CC_Des = request.getParameter("Des");
	
	String COM_code = request.getParameter("Com_Des");
	String BIZ_Des = request.getParameter("Biz_Code_Des");
	
	String POS_code = request.getParameter("PoCd");
	
	String Addr1 = request.getParameter("addr1");
	String Addr2 = request.getParameter("addr2");
	
	String Money = request.getParameter("Local_Cur");
	String Lan = request.getParameter("Lang");
	
	String Start = request.getParameter("start_date");
	String End = request.getParameter("end_date");
	
	String CCG_Des = request.getParameter("CCG_Des");
	String CCT_Des = request.getParameter("cct");
	
	String person = request.getParameter("RPescon_Dese"); //아직 없음
	
	boolean yes_no = Boolean.parseBoolean(request.getParameter("Use-Useless"));  
	
	int id1 = 17011381;
	int id2 = 17011382;
			
	String sql = "INSERT INTO dept VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	try{
		pstmt.setString(1, CC_code);
		pstmt.setString(2, CC_Des);
		pstmt.setString(3, COM_code);
		pstmt.setString(4, BIZ_Des);
		pstmt.setString(5, POS_code);
		pstmt.setString(6, Addr1);
		pstmt.setString(7, Addr2);
		pstmt.setString(8, Money);
		pstmt.setString(9, Lan);
		pstmt.setString(10, Start);
		pstmt.setString(11, End);
		pstmt.setString(12, CCG_Des);
		pstmt.setString(13, CCT_Des);
		pstmt.setString(14, person);
		pstmt.setBoolean(15, yes_no);
		pstmt.setString(16, formattedNow);
		pstmt.setInt(17, id1);
		pstmt.setString(18, formattedNow);
		pstmt.setInt(19, id2);

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
	
	System.out.println("Formatted Now: " + formattedNow);
	System.out.println("CC_code: " + CC_code);
	System.out.println("CC_Des: " + CC_Des);
	System.out.println("COM_code: " + COM_code);
	System.out.println("BIZ_Des: " + BIZ_Des);
	System.out.println("POS_code: " + POS_code);
	System.out.println("Addr1: " + Addr1);
	System.out.println("Addr2: " + Addr2);
	System.out.println("Money: " + Money);
	System.out.println("Lan: " + Lan);
	System.out.println("Start: " + Start);
	System.out.println("End: " + End);
	System.out.println("CCG_Des: " + CCG_Des);
	System.out.println("CCT_Des: " + CCT_Des);
	System.out.println("Person: " + person);
	System.out.println("Yes_No: " + yes_no);
	System.out.println("ID1: " + id1);
	System.out.println("ID2: " + id2);
%>
<script>
	alert("Complete");
	window.location.href="CC_regist.jsp";
</script>
</body>
</html>
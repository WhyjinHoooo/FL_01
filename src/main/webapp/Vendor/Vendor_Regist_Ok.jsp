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
	/* LocalDateTime now = LocalDateTime.now();
	String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")); */
	
	String ComCode = request.getParameter("ComCode");
	String VenCode = request.getParameter("vendorInput");
	String Des = request.getParameter("vendorDes");
	
	String NaCode = request.getParameter("NationCode");
	String NaDes = request.getParameter("NationDes");
	
	String PostalCode = request.getParameter("AddrCode");
	
	String Addr1 = request.getParameter("Addr");
	String Addr2 = request.getParameter("AddrDetail");
	
	String RepPhone = request.getParameter("RepPhone");
	String RepName = request.getParameter("RepName");
	
	boolean Deal = Boolean.parseBoolean(request.getParameter("Deal"));
	
	String IndusNum = request.getParameter("PhoneNum");
	
	String UpCode = request.getParameter("UptaCode");
	String BusinessCode = request.getParameter("BusinessCode");
	
	String sql = "INSERT INTO vendor VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	try{
		pstmt.setString(1,ComCode);
		pstmt.setString(2,VenCode);
		pstmt.setString(3,Des);
		pstmt.setString(4,NaCode);
		pstmt.setString(5,NaDes);
		pstmt.setString(6,PostalCode);
		pstmt.setString(7,Addr1);
		pstmt.setString(8,Addr2);
		pstmt.setString(9,RepPhone);
		pstmt.setString(10,RepName);
		pstmt.setBoolean(11,Deal);
		pstmt.setString(12,IndusNum);
		pstmt.setString(13,UpCode);
		pstmt.setString(14,BusinessCode);
		
		pstmt.executeUpdate();
		
		response.sendRedirect("Vendor_Regist.jsp");
	}catch(SQLException e){
		e.printStackTrace();
		
		response.sendRedirect(request.getHeader("referer"));
	}finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	conn.close();
%>
</body>
</html>
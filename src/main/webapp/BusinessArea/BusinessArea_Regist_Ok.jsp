<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>    
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
    String formattedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

    String BaCd = request.getParameter("BAC");
    String Des = request.getParameter("Des");

    String ComCode = request.getParameter("Com-code");

    String NaCode = request.getParameter("Na-Code");
    String NaName = request.getParameter("Na-Des");

    String PostCode = request.getParameter("Pos-code");
    String Addr1 = request.getParameter("Addr1");
    String Addr2 = request.getParameter("Addr2");

    String MoUnit = request.getParameter("money");
    String Lan = request.getParameter("lang");

    String Tax = request.getParameter("TA-code");
    String Biz = request.getParameter("BAG-code");
    
    boolean Use = Boolean.parseBoolean(request.getParameter("Use-Useless"));
	
    int ID1 = 17011381;
    int ID2 = 76019202;
    
    String sql = "INSERT INTO bizarea VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    PreparedStatement pstmt = conn.prepareStatement(sql);
    
    try{
    	pstmt.setString(1, BaCd);
    	pstmt.setString(2, Des);
    	pstmt.setString(3, ComCode);
    	pstmt.setString(4, NaCode);
    	pstmt.setString(5, NaName);
    	pstmt.setString(6, PostCode);
    	pstmt.setString(7, Addr1);
    	pstmt.setString(8, Addr2);
    	pstmt.setString(9, MoUnit);
    	pstmt.setString(10, Lan);
    	pstmt.setString(11, Tax);
    	pstmt.setString(12, Biz);
    	pstmt.setBoolean(13, Use);
    	pstmt.setString(14, formattedNow);
    	pstmt.setInt(15, ID1);
    	pstmt.setString(16, formattedNow);
    	pstmt.setInt(17, ID2);
    	
    	pstmt.executeUpdate();    	
    }catch(SQLException e){
    	e.printStackTrace();
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
    
    System.out.println("BAC: " + BaCd);
    System.out.println("Des: " + Des);
    System.out.println("Com-code: " + ComCode);
    System.out.println("Na-Code: " + NaCode);
    System.out.println("Na-Des: " + NaName);
    System.out.println("Pos-code: " + PostCode);
    System.out.println("Addr1: " + Addr1);
    System.out.println("Addr2: " + Addr2);
    System.out.println("money: " + MoUnit);
    System.out.println("lang: " + Lan);
    System.out.println("TA-code: " + Tax);
    System.out.println("BAG-code: " + Biz); 
%>
<script>
	alert("Complete");
	window.location.href="BusinessArea_Regist.jsp";
</script>
</body>
</html>

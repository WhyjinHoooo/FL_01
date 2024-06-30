<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
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
	LocalDateTime now = LocalDateTime.now();
	String formattedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	/*main-info*/
	String Bag = request.getParameter("bag"); // Business Area Group 
	String Name = request.getParameter("bag-des"); //Description
	/*sub-info*/
	String ComCode = request.getParameter("Com-code"); // Company Code
	String Tbag = request.getParameter("ComName_input"); // Top Biz.Area Group
	int level = Integer.parseInt(request.getParameter("Biz-level")); // Level
	String Biz_level = request.getParameter("Upper-Biz-level"); //Upper Biz,Group
	boolean Use = Boolean.parseBoolean(request.getParameter("Use-Useless")); //사용 여부
	
	int test2 = 1;
	int test4 = 2;
	
	String sql = "INSERT INTO bizareagroup VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	try{
		pstmt.setString(1, Bag);
		pstmt.setString(2, Name);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, Tbag);
		pstmt.setInt(5, level);
		pstmt.setString(6, Biz_level);
		pstmt.setBoolean(7, Use);
		
		pstmt.setString(8, formattedNow);
		pstmt.setInt(9, test2);
		pstmt.setString(10, formattedNow);
		pstmt.setInt(11, test4);
		
		pstmt.executeUpdate();
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

    System.out.println("Bag: " + Bag);
    System.out.println("Name: " + Name);
    System.out.println("ComCode: " + ComCode);
    System.out.println("Tbag: " + Tbag);
    System.out.println("level: " + level);
    System.out.println("Biz_level: " + Biz_level);
    System.out.println("Use: " + Use);

%>
<script>
	alert("Complete");
	window.location.href="business-AGroup-Regist.jsp";
</script>
</body>
</html>
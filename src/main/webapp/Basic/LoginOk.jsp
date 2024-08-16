<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp"%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String UserId = request.getParameter("UserId");
	String UserPW = request.getParameter("UserPw");
	String UserBelong = request.getParameter("ComChoice");
	
	System.out.println("UserId : " + UserId);
	System.out.println("UserPW : " + UserPW);
	System.out.println("UserBelong : " + UserBelong);
	
	String sql = "SELECT * FROM membership WHERE Id = ? AND PW = ? AND Belong = ?";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, UserId);
	pstmt.setString(2, UserPW);
	pstmt.setString(3, UserBelong);
	ResultSet rs = pstmt.executeQuery();
	if(rs.next()){
		session.setAttribute("id", UserId);
		session.setAttribute("depart", UserBelong);
		session.setAttribute("name", rs.getString("UserName"));
		session.setAttribute("UserCode", rs.getString("Id"));
%>
	<script>
		alert('로그인에 성공했습니다.');
		window.location.href="../main.jsp";
	</script>
<%
	} else{
%>
	<script>
		alert('비밀번호와 아이디를 다시 입력해주세요.');
		history.back();
	</script>
<%
	}
%>
</body>
</html>
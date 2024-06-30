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

	String UserName = request.getParameter("UserName"); //사용자 이름
	String Id = request.getParameter("UserId"); //아이디
	String Password = request.getParameter("UserPw1"); // 비번
	String UserIdCard = request.getParameter("UserIdCard1") + "-" + request.getParameter("UserIdCard2");// 주민등록번호
	String Email = request.getParameter("UserEm") + "@" + request.getParameter("UserDom_txt");
	String Birth = request.getParameter("UserY") + "-" + request.getParameter("UserM") + "-" + request.getParameter("UserD"); // 생일
	String AddressNum = request.getParameter("ZipCd"); // 도로명주소
	String Address = request.getParameter("Addr") + "," +  request.getParameter("AddrRefer"); // 집주소
	String gender = request.getParameter("gender"); // 성별
	String Digit = request.getParameter("Ph_F") + "-" + request.getParameter("Ph_M") + "-" + request.getParameter("Ph_E"); // 전화번호
	String Belong = request.getParameter("Belong"); // 소속(부서)

	String sql = "INSERT INTO membership VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	try{
		pstmt.setString(1, UserName);
		pstmt.setString(2, Id);
		pstmt.setString(3, Password);
		pstmt.setString(4, UserIdCard);
		pstmt.setString(5, Email);
		pstmt.setString(6, Birth);
		pstmt.setString(7, AddressNum);
		pstmt.setString(8, Address);
		pstmt.setString(9, gender);
		pstmt.setString(10, Digit);
		pstmt.setString(11, Belong);
		pstmt.executeUpdate();
	}catch(SQLException e){
		e.printStackTrace();
	} finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	
%>
<script>
	alert("가입되었습니다. 로그인 페이지로 이동합니다.");
	window.location.href="Login.jsp";
</script>
</body>
</html>
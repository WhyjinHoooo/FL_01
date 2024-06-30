<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page session="true"%>    
<%@ include file="../mydbcon.jsp" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정 완</title>
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
	String Address = request.getParameter("Addr") + "," + request.getParameter("AddrDetail") + "," +  request.getParameter("AddrRefer"); // 집주소
	String gender = request.getParameter("gender"); // 성별
	String Digit = request.getParameter("Ph_F") + "-" + request.getParameter("Ph_M") + "-" + request.getParameter("Ph_E"); // 전화번호
	String Belong = request.getParameter("Belong"); // 소속(부서)
	
	String sql = "UPDATE membership SET UserName = '" + UserName +"', Id = '" + Id +"', PW = '" + Password  
				+ "', IdCard = '" + UserIdCard +"', Email = '" + Email +"',  Birth = '" + Birth +"',  AddressNumber = '" + AddressNum
				+"', Address = '" + Address +"', Gender = '" + gender +"', Phone = '" + Digit +"', Belong = '" + Belong +"' WHERE Id = '"+ Id +"'";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	try{
		pstmt.executeUpdate();
	} catch(SQLException e){
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
		alert("회원정보가 수정되었습니다.");
		window.location.href='../main.jsp';
	</script>
</body>
</html>
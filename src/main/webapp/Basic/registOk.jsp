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
	LocalDateTime now = LocalDateTime.now();
	String CreateDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	String FromDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	
	LocalDateTime sixMonthsLater = now.plusMonths(6);
    String ValidDateFrom = sixMonthsLater.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    
	request.setCharacterEncoding("UTF-8");

	String UserName = request.getParameter("UserName"); //사용자 이름
	String Id = request.getParameter("UserId"); //아이디
	String Password = request.getParameter("UserPw1"); // 비번
	String UserIdCard = request.getParameter("UserIdCard1") + "-" + request.getParameter("UserIdCard2");// 주민등록번호
	String Email = request.getParameter("UserEm") + "@" + request.getParameter("UserDom_txt");
	String Birth = request.getParameter("UserY") + "-" + request.getParameter("UserM") + "-" + request.getParameter("UserD"); // 생일
	String AddressNum = request.getParameter("ZipCd"); // 도로명주소
	String Address = request.getParameter("Addr") + "," +  request.getParameter("AddrDetail"); // 집주소
	String gender = request.getParameter("gender"); // 성별
	String Digit = request.getParameter("Ph_F") + "-" + request.getParameter("Ph_M") + "-" + request.getParameter("Ph_E"); // 전화번호
	String Belong = request.getParameter("Belong"); // 기업
	String CoCt = request.getParameter("CoCtSelect"); // 부소 
	String EmpId = request.getParameter("Employee_ID");
	
	String YN_Sql = "SELECT * FROM emp WHERE EMPLOYEE_NAME = ?";
	PreparedStatement YN_pstmt = conn.prepareStatement(YN_Sql);
	YN_pstmt.setString(1, UserName);
	ResultSet YN_rs = YN_pstmt.executeQuery();
	
	String sql = "INSERT INTO membership VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	try{
		pstmt.setString(1, UserName); // 사용자 이름
		pstmt.setString(2, Id); // 아이디
		pstmt.setString(3, Password); // 비밀번호
		pstmt.setString(4, EmpId); // 사원번호
		pstmt.setString(5, UserIdCard); // 사원번호
		pstmt.setString(6, Email);
		pstmt.setString(7, Birth);
		pstmt.setString(8, AddressNum);
		pstmt.setString(9, Address);
		pstmt.setString(10, gender);
		pstmt.setString(11, Digit);
		pstmt.setString(12, Belong);
		pstmt.setString(13, CoCt);
		if(YN_rs.next()){
			pstmt.setString(14, "Y");
		} else{
			pstmt.setString(14, "N");
		}
		pstmt.setString(15, CreateDate);
		pstmt.setString(16, FromDate);
		pstmt.setString(17, ValidDateFrom);
		pstmt.setString(18, "NOPE");
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
	window.location.href="Login.jsp";
</script>
</body>
</html>
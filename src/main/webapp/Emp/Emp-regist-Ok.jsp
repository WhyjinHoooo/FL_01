<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../mydbcon.jsp" %>
</head>
<body>
<%! 
    // 메서드 정의는 JSP 선언문 내에서 수행
    public String generateRandomString() {
        int length = 8; // 문자열 길이 8로 고정
        String characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder result = new StringBuilder(length);
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(characters.length());
            result.append(characters.charAt(index));
        }
        return result.toString();
    }
%>

<%
	request.setCharacterEncoding("UTF-8");
	LocalDateTime now = LocalDateTime.now();
	String Time = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	
	String ID = request.getParameter("Emp_id");
	String Id_Des = request.getParameter("Des");
	
	String ComCode = request.getParameter("ComCode");
	String ComName = request.getParameter("Com_Name");
	
	String CCCode = request.getParameter("CC_Code");
	String CCName = request.getParameter("CC_Name");
	
	String P_Code = request.getParameter("AddrCode");
	
	String AddrDetail = request.getParameter("Addr") + "," + request.getParameter("AddrDetail");
	
	String Birth = request.getParameter("Birth");
	
	int Jumin_1st = Integer.parseInt(request.getParameter("Jumin_1st"));
	int Jumin_2nd = Integer.parseInt(request.getParameter("Jumin_2nd"));
	
	String gender = null;
	switch((Jumin_2nd / 1000000) % 2){
		case 1:
			gender = "male";
			break;
		case 0:
			gender = "female";
			break;
		default:
			break;
	}
	
	String randomEmail = generateRandomString() + "@naver.com";
	
	String Join = request.getParameter("join");
	String Retire = request.getParameter("retire");
	
	if (Retire == null || Retire.trim().isEmpty()) {
		Retire = null;
	}
	
	String Duty = request.getParameter("duty_Des");
	String Duty_Start = request.getParameter("duty_Start");
	
	String Title = request.getParameter("title_Des");
	String Title_Start = request.getParameter("promot");
	
	String UserDuty = request.getParameter("UserDutyCode");
// 	System.out.println(UserDutylist);
// 	String[] UserDuty = null;
// 	if(UserDutylist != null && !UserDutylist.isEmpty()){
// 		UserDuty = UserDutylist.split(",");
// 	}
	
	int id1 = 17011381;
	int id2 = 76019202;
	
	String sql = "INSERT INTO emp VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
/* 	String OW_Reg_Sql = "INSERT INTO membership VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement OW_Reg_Pstmt = conn.prepareStatement(OW_Reg_Sql); */
	
	try{
		pstmt.setString(1, ID);
		pstmt.setString(2, Id_Des);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, ComName);
		pstmt.setString(5, CCCode);
		pstmt.setString(6, CCName);
		pstmt.setString(7, P_Code);
		pstmt.setString(8, AddrDetail);
		pstmt.setString(9, UserDuty);
		pstmt.setString(10, Birth);
		pstmt.setInt(11, Jumin_1st);
		pstmt.setInt(12, Jumin_2nd);
		pstmt.setString(13, Join);
		pstmt.setString(14, Retire);
		pstmt.setString(15, Duty);
		pstmt.setString(16, Duty_Start);
		pstmt.setString(17, Title);
		pstmt.setString(18, Title_Start);
		pstmt.setString(19, Time);
		pstmt.setInt(20, id1);
		pstmt.setString(21, Time);
		pstmt.setInt(22, id2);
		pstmt.executeUpdate();
		
		response.sendRedirect("Emp-regist.jsp");
	}catch(SQLException e){
		e.printStackTrace();
        out.println("<script>");
        out.println("alert('등록에 실패하였습니다. 다시 시도해주세요.');");
        out.println("history.back();");
        out.println("</script>");
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
%>
</body>
</html>
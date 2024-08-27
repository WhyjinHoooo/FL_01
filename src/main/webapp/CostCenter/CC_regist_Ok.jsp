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
	String BIZ_Des = request.getParameter("Biz_Code");
	
	String POS_code = request.getParameter("AddrCode");
	
	String Addr1 = request.getParameter("Addr");
	String Addr2 = request.getParameter("AddrDetail");
	
	String Money = request.getParameter("money");
	String Lan = request.getParameter("lang");
	
	String Start = request.getParameter("start_date");
	String End = request.getParameter("end_date");
	
	String CCG_Des = request.getParameter("ccc");
	String CCT_Des = request.getParameter("cct");
	
	String person = request.getParameter("RPescon_Dese"); //아직 없음
	
	boolean yes_no = Boolean.parseBoolean(request.getParameter("Use-Useless"));  
	
	int id1 = 17011381;
	int id2 = 17011382;
			
	// INSERT 쿼리 수정: 19번째 컬럼 REST_PERSON을 제외하고, 명시적으로 모든 컬럼을 나열합니다.
	String sql = "INSERT INTO dept (COCT, COCT_NAME, ComCode, BIZ_AREA, POST_ID, COCT_ADD1, COCT_ADD2, LO_CURRENCY, LANGUAGE, VALID_FR, VALID_TO, COCT_GROUP, COCT_TYPE, USEYN, CreateDate, CreateID, ChangeDate, ChangerID) "
	           + "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	PreparedStatement pstmt = conn.prepareStatement(sql);

	try {
	    pstmt.setString(1, CC_code);       // COCT
	    pstmt.setString(2, CC_Des);        // COCT_NAME
	    pstmt.setString(3, COM_code);      // ComCode
	    pstmt.setString(4, BIZ_Des);       // BIZ_AREA
	    pstmt.setString(5, POS_code);      // POST_ID
	    pstmt.setString(6, Addr1);         // COCT_ADD1
	    pstmt.setString(7, Addr2);         // COCT_ADD2
	    pstmt.setString(8, Money);         // LO_CURRENCY
	    pstmt.setString(9, Lan);           // LANGUAGE
	    pstmt.setString(10, Start);        // VALID_FR
	    pstmt.setString(11, End);          // VALID_TO
	    pstmt.setString(12, CCG_Des);      // COCT_GROUP
	    pstmt.setString(13, CCT_Des);      // COCT_TYPE
	    pstmt.setBoolean(14, yes_no);      // USEYN
	    pstmt.setString(15, formattedNow); // CreateDate
	    pstmt.setInt(16, id1);             // CreateID
	    pstmt.setString(17, formattedNow); // ChangeDate
	    pstmt.setInt(18, id2);             // ChangerID

	    pstmt.executeUpdate();
	} catch (SQLException e) {
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
%>
<script>
	alert("Complete");
	window.location.href="CC_regist.jsp";
</script>
</body>
</html>
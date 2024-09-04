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
<title>Input</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");

	request.setCharacterEncoding("UTF-8");
	LocalDateTime now = LocalDateTime.now();
	String formattedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

	String cocd = request.getParameter("Com_code");
	String Des = request.getParameter("Des");
	
	String NaCode = request.getParameter("NationCode");
	String NaName = request.getParameter("NationName_input");
	
	String PtCd = request.getParameter("AddrCode");
	
	String Addr = request.getParameter("Addr");
	String AddrDetail = request.getParameter("AddrDetail");
	
	String money = request.getParameter("money");
	String lang = request.getParameter("lang");
	
	
	boolean BA = Boolean.parseBoolean(request.getParameter("BA_use"));
	boolean TA = Boolean.parseBoolean(request.getParameter("TA_use"));
	
	String TB = request.getParameter("TB_use");
	String FSRL = request.getParameter("FSRL");
	
	int init_ID = 17011381;
	int init_lv = 0;
	/*-----------------*/
	String sql = "INSERT INTO company VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
	String sql2 = "INSERT INTO bizareagroup VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	String sql3 = "INSERT INTO coct VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	PreparedStatement pstmt2 = conn.prepareStatement(sql2);
	PreparedStatement pstmt3 = conn.prepareStatement(sql3);
	
	try{
		pstmt.setString(1, cocd);
		pstmt.setString(2, Des);
		pstmt.setString(3, NaCode);
		pstmt.setString(4, NaName);
		pstmt.setString(5, PtCd);
		pstmt.setString(6, Addr);
		pstmt.setString(7, AddrDetail);
		pstmt.setString(8, money);
		pstmt.setString(9, lang);
		pstmt.setBoolean(10, BA);
		pstmt.setBoolean(11, TA);
		pstmt.setString(12, TB);
		pstmt.setString(13, FSRL);
		pstmt.executeUpdate();
		
		/* bizareagroup insert 쿼리문 */
		pstmt2.setString(1, cocd);
		pstmt2.setString(2, cocd);
		pstmt2.setString(3, cocd);
		pstmt2.setString(4, cocd);
		pstmt2.setInt(5,init_lv);
		pstmt2.setString(6, cocd);
		pstmt2.setBoolean(7,true);
		pstmt2.setString(8, formattedNow);
		pstmt2.setInt(9,init_ID);
		pstmt2.setString(10, formattedNow);
		pstmt2.setInt(11,init_ID);
		pstmt2.executeUpdate();
		
		/* coct insert 쿼리문 */
		pstmt3.setString(1, cocd);
		pstmt3.setString(2, cocd);
		pstmt3.setString(3, cocd);
		pstmt3.setString(4, cocd);
		pstmt3.setInt(5,init_lv);
		pstmt3.setString(6, cocd);
		pstmt3.setBoolean(7,true);
		pstmt3.setString(8, formattedNow);
		pstmt3.setInt(9,init_ID);
		pstmt3.setString(10, formattedNow);
		pstmt3.setInt(11,init_ID);
		pstmt3.executeUpdate();
		
		out.println("<script>alert('등록 완료');</script>");
		out.println("<script>window.location.href='Company_Regist.jsp';</script>");
		
	} catch(SQLException e){
		e.printStackTrace();
		out.println("<script>alert('등록 실패');</script>");
	} finally{
		try{
			if(pstmt != null && !pstmt.isClosed()){
				pstmt.close();
			}
			if (pstmt2 != null && !pstmt2.isClosed()) {
				pstmt2.close();
			}
			if (pstmt3 != null && !pstmt3.isClosed()) {
				pstmt3.close();
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
	}
	conn.close();
%>
<script>
console.log("Company Code: " + '<%= cocd %>');
console.log("Description: " + '<%= Des %>');
console.log("NaCode: " + '<%= NaCode %>');
console.log("Nationality Name: " + '<%= NaName %>');
console.log("Postal Code: " + '<%= PtCd %>');
console.log("Address 1: " + '<%= Addr %>');
console.log("Address 2: " + '<%= AddrDetail %>');
console.log("Local Currency: " + '<%= money %>');
console.log("Language: " + '<%= lang %>');
console.log("Business Area 사용: " + '<%= BA %>');
console.log("Tax Area 사용: " + '<%= TA %>');
console.log("TaxArea vs BizArea: " + '<%= TB %>');
console.log("Financial Statement Reporting Level: " + '<%= FSRL %>');
</script>

</body>
</html>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String pass = null;
	
	String S_Word01 = request.getParameter("SendCom"); // 기업코드
	String S_Word02 = request.getParameter("SendCoCt"); // 부서(CoCt, Cost Center)
	String S_Word03 = request.getParameter("SendID"); // 사용자 사원번호
	String EMP_Sql = "SELECT * FROM emp WHERE EMPLOYEE_ID = ? AND COMCODE = ? AND COCT = ?";
	PreparedStatement pstmt = conn.prepareStatement(EMP_Sql);
	pstmt.setString(1, S_Word03);
	pstmt.setString(2, S_Word01);
	pstmt.setString(3, S_Word02);
	ResultSet rs = pstmt.executeQuery();
	try{
		if(!rs.next()){
			pass = "No"; // 중복되는 데이터가 없는 경우 -> 직원의 정보가 없다
		} else{
			pass = "Yes"; // 중복되는 데이터가 있는 경우 -> 직원의 정보가 있다.
		}
		out.print(pass);
}catch(SQLException e){
	e.printStackTrace();
}finally {
    if(rs != null) try { rs.close(); } catch(SQLException e) {}
    if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
}
%>

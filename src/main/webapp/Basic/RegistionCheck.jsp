<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String EmpNumber = request.getParameter("EmpCode"); // 사원 코드
	String Coment = null;
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs2 = null;
	
	String sql = "SELECT * FROM emp WHERE EMPLOYEE_ID = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, EmpNumber);
	rs = pstmt.executeQuery();
	
	String sql2 = "SELECT * FROM membership WHERE Id = ?";
	pstmt2 = conn.prepareStatement(sql2);
	pstmt2.setString(1, EmpNumber);
	rs2 = pstmt2.executeQuery();
	if(!rs.next()) {
		// emp에 사원 번호가 없는 경우
		Coment = "No";
	} else {
		// emp에 사원 번호가 있는 경우
		if(rs2.next()){	
			// membership에도 사원 번호가 있는 경우
			Coment = "Yes";
		}
	}
	out.print(Coment.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


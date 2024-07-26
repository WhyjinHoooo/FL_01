<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%@ include file="../../mydbcon.jsp" %>  

<%
try{
	String UserNumCode = request.getParameter("id");
	
	/* 찾아야 할 정보 
		사용자의 costCenter와 Des
		사용자의 biaArea
	*/
	String UserDept = null;
	String UserDeptDes = null;
	String UserBA = null;
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM emp WHERE EMPLOYEE_ID = ?";
	pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1, UserNumCode);
	rs = pstmt.executeQuery();
	
	JSONArray jsonArray = new JSONArray();
	
	if(rs.next()){
		UserDept = rs.getString("COCT");
		
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		String sql2 = "SELECT * FROM dept WHERE COCT = ?";
		pstmt2 = conn.prepareStatement(sql2);
		pstmt2.setString(1, UserDept);
		
		rs2 = pstmt2.executeQuery();
		
		JSONObject jsonObject = new JSONObject();
		while(rs2.next()){
			jsonObject.put("UserBA", rs2.getString("BIZ_AREA"));
			jsonObject.put("UserCoct", UserDept);
			
			jsonArray.add(jsonObject);
		}
	}
	
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonArray.toString());
    
} catch(SQLException e){
	e.printStackTrace();
}
%>


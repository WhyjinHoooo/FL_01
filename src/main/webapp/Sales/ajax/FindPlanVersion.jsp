<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Word = request.getParameter("PV"); // 검색할 계획버전 코드
	String PlantStart = null;
	String PlantEnd = null;
	String UserBizArea = null;
	String UserBizDes = null;
	try{
		String sql01 = "SELECT * FROM sales_planversion WHERE PlanVer = ?";
		PreparedStatement pstmt01 = conn.prepareStatement(sql01);
		pstmt01.setString(1, S_Word);
		ResultSet rs01 = pstmt01.executeQuery();		
		if(rs01.next()){
			PlantStart = rs01.getString("PlanStart");
			PlantEnd = rs01.getString("PlanEndPeriod");
		}
		out.println(PlantStart +',' + PlantEnd);
}catch(SQLException e){
	e.printStackTrace();
}
%>

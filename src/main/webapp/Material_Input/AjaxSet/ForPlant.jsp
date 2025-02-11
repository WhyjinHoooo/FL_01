<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
String UserId = request.getParameter("id");

String EmpNo = null;
String Coct = null;
String BizArea = null;
String BizAreaName = null;
String PlantCode = null;
String PlantDes = null;
try{
	EmpNo = UserId;
	String sql02 = "SELECT * FROM emp WHERE EMPLOYEE_ID = ?";
	PreparedStatement pstmt02 = conn.prepareStatement(sql02);
	pstmt02.setString(1, EmpNo);
	ResultSet rs02 = pstmt02.executeQuery();
	if(rs02.next()){
		Coct = rs02.getString("COCT");
		String sql03 = "SELECT * FROM dept WHERE COCT = ?";
		PreparedStatement pstmt03 = conn.prepareStatement(sql03);
		pstmt03.setString(1, Coct);
		ResultSet rs03 = pstmt03.executeQuery();
		if(rs03.next()){
			BizArea = rs03.getString("BIZ_AREA");
			String sql04 = "SELECT * FROM bizarea WHERE BIZ_AREA = ?";
			PreparedStatement pstmt04 = conn.prepareStatement(sql04);
			pstmt04.setString(1, BizArea);
			ResultSet rs04 = pstmt04.executeQuery();
			if(rs04.next()){
				BizAreaName = rs04.getString("BA_Name");
				String sql05 = "SELECT * FROM plant WHERE BIZ_AREA = ?";
				PreparedStatement pstmt05 = conn.prepareStatement(sql05);
				pstmt05.setString(1, BizAreaName);
				ResultSet rs05 = pstmt05.executeQuery();
				if(rs05.next()){
					PlantCode = rs05.getString("PLANT_ID");
					PlantDes = rs05.getString("PLANT_NAME");
				}
			}
		}
	}	
	out.print(PlantCode + "-" + PlantDes);
}catch(SQLException e){
	e.printStackTrace();
}
%>

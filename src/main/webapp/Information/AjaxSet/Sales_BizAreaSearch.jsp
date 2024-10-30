<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Word = request.getParameter("Id"); // 사용자의 아이디
	String UserRight = null;
	String UserCoCt = null;
	String UserBizArea = null;
	String UserBizDes = null;
	try{
		String sql01 = "SELECT * FROM membership WHERE Id = ?";
		PreparedStatement pstmt01 = conn.prepareStatement(sql01);
		pstmt01.setString(1, S_Word);
		ResultSet rs01 = pstmt01.executeQuery();		
		if(rs01.next()){
			UserCoCt = rs01.getString("CoCt");
			String sql02 = "SELECT * FROM project.dept WHERE COCT = ?";
			PreparedStatement pstm02 = conn.prepareStatement(sql02);
			pstm02.setString(1, UserCoCt);
			ResultSet rs02 = pstm02.executeQuery();
			if(rs02.next()){
				UserBizArea = rs02.getString("BIZ_AREA");
				String sql03 = "SELECT * FROM project.bizarea WHERE BIZ_AREA = ?";
				PreparedStatement pstm03 = conn.prepareStatement(sql03);
				pstm03.setString(1, UserBizArea);
				ResultSet rs03 = pstm03.executeQuery();
				if(rs03.next()){
					UserBizDes = rs03.getString("BA_Name");
				}
			}
		}
		out.print(UserBizArea + ',' + UserBizDes);
}catch(SQLException e){
	e.printStackTrace();
}
%>

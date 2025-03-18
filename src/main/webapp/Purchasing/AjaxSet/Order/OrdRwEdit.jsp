<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>
<%
	try{
		String DocCode = request.getParameter("OrdCode");
		String ReqCode = request.getParameter("ReqCode");
		System.out.println("DocCode : " + DocCode);
		System.out.println("ReqCode : " + ReqCode);
		String SearSql = "UPDATE request_doc SET PlanNumPO = ?, StatusPR = ? WHERE DocNumPR = ?";
		PreparedStatement SearPstmt = conn.prepareStatement(SearSql);
		SearPstmt.setString(1, ReqCode);
		SearPstmt.setString(2, "B 발주준비");
		SearPstmt.setString(3, DocCode);
		
 		SearPstmt.executeUpdate();
 		out.print("Success");
	}catch(Exception e){
		out.print("Fail");
		e.printStackTrace();
	}
%>
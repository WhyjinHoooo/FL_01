<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
	System.out.println("성공");
	String SearchSql = "SELECT * FROM dataadminkeytemptable";
	PreparedStatement SearchPStmt = conn.prepareStatement(SearchSql);
	ResultSet SearchRs = SearchPStmt.executeQuery();
	while(SearchRs.next()){
		
	}
%>
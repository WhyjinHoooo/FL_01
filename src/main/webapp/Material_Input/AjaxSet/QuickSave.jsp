<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../mydbcon.jsp" %>
<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
	JSONObject dataToSend = new JSONObject(jsonString.toString());
	System.out.println(dataToSend);
// 	String QucikSQL = "INSERT INTO temtable VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
// 	PreparedStatement QuickPstmt = conn.prepareStatement(QucikSQL);
// 	QuickPstmt.setString(1, dataToSend.getString(""));
// 	QuickPstmt.setString(2, dataToSend.getString(""));
// 	QuickPstmt.setString(3, dataToSend.getString(""));
// 	QuickPstmt.setString(4, dataToSend.getString(""));
// 	QuickPstmt.setString(5, dataToSend.getString(""));
// 	QuickPstmt.setString(6, dataToSend.getString(""));
// 	QuickPstmt.setString(7, dataToSend.getString(""));
// 	QuickPstmt.setString(8, dataToSend.getString(""));
// 	QuickPstmt.setString(9, dataToSend.getString(""));
// 	QuickPstmt.setString(10, dataToSend.getString(""));
// 	QuickPstmt.setString(11, dataToSend.getString(""));
// 	QuickPstmt.setString(12, dataToSend.getString(""));
// 	QuickPstmt.setString(13, dataToSend.getString(""));
// 	QuickPstmt.setString(14, dataToSend.getString(""));
// 	QuickPstmt.setString(15, dataToSend.getString(""));
// 	QuickPstmt.setString(16, dataToSend.getString(""));
// 	QuickPstmt.setString(17, dataToSend.getString(""));
// 	QuickPstmt.setString(18, dataToSend.getString(""));
// 	QuickPstmt.setString(19, dataToSend.getString(""));
// 	QuickPstmt.setString(20, dataToSend.getString(""));
// 	QuickPstmt.executeUpdate();
	}catch(Exception e){
		e.printStackTrace();
	}
%>
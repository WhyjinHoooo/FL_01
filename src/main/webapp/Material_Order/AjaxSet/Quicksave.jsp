<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="org.json.simple.JSONValue"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
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

    String sql = "INSERT INTO ordertable VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; 
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, dataToSend.getString("OrderNum"));
    pstmt.setString(2, dataToSend.getString("OIN"));
    pstmt.setString(3, dataToSend.getString("MatCode"));
    pstmt.setString(4, dataToSend.getString("MatDes"));
    pstmt.setString(5, dataToSend.getString("MatType"));
    pstmt.setString(6, dataToSend.getString("OrderCount"));
    pstmt.setString(7, dataToSend.getString("OrderUnit"));
    pstmt.setString(8, dataToSend.getString("Oriprice"));
    pstmt.setString(9, dataToSend.getString("PriUnit"));
    pstmt.setString(10, dataToSend.getString("OrdPrice"));
    pstmt.setString(11, dataToSend.getString("MonUnit"));
    pstmt.setString(12, dataToSend.getString("DeliHopeDate"));
    pstmt.setString(13, dataToSend.getString("SlocaCode"));
    pstmt.setString(14, dataToSend.getString("PlantCode"));
    pstmt.setString(15, dataToSend.getString("OrderNum") + '-' + dataToSend.getString("OIN"));
    
	pstmt.executeUpdate();
    
    JSONObject Result = new JSONObject();
	Result.put("status", "Success");
	Result.put("DataList", dataToSend);
    response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	response.getWriter().write(Result.toString());
	}catch(SQLException e){
	JSONObject Result = new JSONObject();
	Result.put("status", "Fail");
	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	response.getWriter().write(Result.toString());
	e.printStackTrace();
	}
%>

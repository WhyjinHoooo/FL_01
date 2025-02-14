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
		String QucikSQL = "INSERT INTO temtable VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement QuickPstmt = conn.prepareStatement(QucikSQL);
		QuickPstmt.setString(1, dataToSend.getString("MatNum"));
		QuickPstmt.setString(2, dataToSend.getString("ItemNum"));
		QuickPstmt.setString(3, dataToSend.getString("PurOrdNo"));
		QuickPstmt.setString(4, dataToSend.getString("MovType"));
		QuickPstmt.setString(5, dataToSend.getString("MatType"));
		QuickPstmt.setString(6, dataToSend.getString("MatCode"));
		QuickPstmt.setString(7, dataToSend.getString("MatDes"));
		QuickPstmt.setString(8, dataToSend.getString("MatPlant"));
		QuickPstmt.setString(9, dataToSend.getString("VendorCode"));
		QuickPstmt.setString(10, dataToSend.getString("SLocCode"));
		QuickPstmt.setString(11, dataToSend.getString("Bin"));
		QuickPstmt.setString(12, dataToSend.getString("InputCount"));
		QuickPstmt.setString(13, dataToSend.getString("LotName"));
		QuickPstmt.setString(14, dataToSend.getString("BuyUnit"));
		QuickPstmt.setString(15, dataToSend.getString("MadeDate"));
		QuickPstmt.setString(16, dataToSend.getString("MadeDate"));
		QuickPstmt.setString(17, dataToSend.getString("PlusMinus"));
		QuickPstmt.setString(18, dataToSend.getString("DealCurrency"));
		QuickPstmt.setString(19, dataToSend.getString("ComCode"));
		QuickPstmt.setString(20, dataToSend.getString("MatNum") + "-" + dataToSend.getString("ItemNum"));
		QuickPstmt.executeUpdate();
		
		JSONObject Result = new JSONObject();
		Result.put("status", "Success");
		Result.put("DataList", dataToSend);
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
	}catch(Exception e){
		JSONObject Result = new JSONObject();
		Result.put("status", "Fail");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
		e.printStackTrace();
	}
%>
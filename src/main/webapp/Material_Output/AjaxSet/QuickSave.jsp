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
		//System.out.println(dataToSend);
		String QucikSQL = "INSERT INTO output_temtable VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement QuickPstmt = conn.prepareStatement(QucikSQL);
		QuickPstmt.setString(1, dataToSend.getString("Doc_Num"));
		QuickPstmt.setString(2, dataToSend.getString("GINo"));
		QuickPstmt.setString(3, dataToSend.getString("movCode"));
		QuickPstmt.setString(4, dataToSend.getString("PlusMinus"));
		QuickPstmt.setString(5, dataToSend.getString("MatCode"));
		QuickPstmt.setString(6, dataToSend.getString("MatDes"));
		QuickPstmt.setString(7, dataToSend.getString("PlantCode"));
		QuickPstmt.setString(8, dataToSend.getString("StorageCode"));
		QuickPstmt.setString(9, dataToSend.getString("UseDepart"));
		QuickPstmt.setString(10, dataToSend.getString("OutCount"));
		QuickPstmt.setString(11, dataToSend.getString("MatLotNo"));
		QuickPstmt.setString(12, dataToSend.getString("OrderUnit"));
		QuickPstmt.setString(13, dataToSend.getString("MakeDate"));
		QuickPstmt.setString(14, dataToSend.getString("DeadDete"));
		QuickPstmt.setString(15, dataToSend.getString("LotNumber"));
		QuickPstmt.setString(16, dataToSend.getString("InputStorage"));
		QuickPstmt.setString(17, dataToSend.getString("Out_date"));
		QuickPstmt.setString(18, dataToSend.getString("UserID"));
		QuickPstmt.setString(19, dataToSend.getString("ComCode"));
		QuickPstmt.setString(20, dataToSend.getString("Doc_Num") + "-" + dataToSend.getString("GINo"));
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
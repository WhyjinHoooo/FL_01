<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../../mydbcon.jsp" %>
<%

	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
		LocalDateTime today = LocalDateTime.now();
		DateTimeFormatter DateFormat= DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String PODate = today.format(DateFormat);
		JSONObject dataToSend = new JSONObject(jsonString.toString());
		System.out.println(dataToSend);
		String InsertSql = "INSERT INTO purprice VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement InsertPstmt = conn.prepareStatement(InsertSql);
		InsertPstmt.setString(1, dataToSend.getString("NewMaterialCode"));
		InsertPstmt.setString(2, dataToSend.getString("NewMaterialCodeDes"));
		InsertPstmt.setString(3, "RAWM");
		InsertPstmt.setString(4, dataToSend.getString("Entry_VCode").split("\\(")[0]);
		InsertPstmt.setString(5, dataToSend.getString("Entry_VCode").split("\\(")[1].replace(")",""));
		InsertPstmt.setString(6, dataToSend.getString("DealCondition"));
		InsertPstmt.setString(7, dataToSend.getString("PricePerCount"));
		InsertPstmt.setString(8, dataToSend.getString("NewMaterialInvUnit"));
		InsertPstmt.setString(9, dataToSend.getString("NewMaterialPrice"));
		InsertPstmt.setString(10, String.format("%.4f", dataToSend.getDouble("NewMaterialPrice") / dataToSend.getDouble("PricePerCount")));
		InsertPstmt.setString(11, dataToSend.getString("Currency"));
		InsertPstmt.setString(12, dataToSend.getString("NewMaterialFDate"));
		InsertPstmt.setString(13, dataToSend.getString("NewMaterialEDate"));
		InsertPstmt.setString(14, null);
		InsertPstmt.setString(15, null);
		InsertPstmt.setString(16, dataToSend.getString("RegistedDate"));
		InsertPstmt.setString(17, dataToSend.getString("RegistedId"));
		InsertPstmt.setString(18, dataToSend.getString("PlantCode").split("\\(")[0]);
		InsertPstmt.setString(19, dataToSend.getString("ComCode"));
		InsertPstmt.setString(20, dataToSend.getString("NewMaterialCode") + dataToSend.getString("Entry_VCode").split("\\(")[0] + dataToSend.getString("DealCondition") + dataToSend.getString("NewMaterialFDate") + dataToSend.getString("PlantCode").split("\\(")[0]);
		InsertPstmt.executeUpdate();

		String MatBasicSql = "INSERT INTO purchase_basicdata VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement MatBasicPstmt = conn.prepareStatement(MatBasicSql);
		MatBasicPstmt.setString(1, dataToSend.getString("NewMaterialCode"));
		MatBasicPstmt.setString(2, dataToSend.getString("NewMaterialCodeDes"));
		MatBasicPstmt.setString(3, dataToSend.getString("Entry_VCode").split("\\(")[0]);
		MatBasicPstmt.setString(4, dataToSend.getString("Entry_VCode").split("\\(")[1].replace(")",""));
		MatBasicPstmt.setString(5, dataToSend.getString("IQC"));
		MatBasicPstmt.setString(6, null);
		MatBasicPstmt.setString(7, dataToSend.getString("NewMaterialWrapUnit"));
		MatBasicPstmt.setString(8, dataToSend.getString("PricePerCount"));
		MatBasicPstmt.setString(9, dataToSend.getString("NewMaterialInvUnit"));
		MatBasicPstmt.setString(10, null);
		MatBasicPstmt.setString(11, dataToSend.getString("NewMaterialCode"));
		MatBasicPstmt.setString(12, null);
		MatBasicPstmt.setString(13, null);
		MatBasicPstmt.setString(14, null);
		MatBasicPstmt.setString(15, null);
		MatBasicPstmt.setString(16, dataToSend.getString("PlantCode").split("\\(")[0]);
		MatBasicPstmt.setString(17, dataToSend.getString("ComCode"));
		MatBasicPstmt.setString(18, dataToSend.getString("RegistedDate"));
		MatBasicPstmt.setString(19, dataToSend.getString("RegistedId"));
		MatBasicPstmt.setString(20, dataToSend.getString("NewMaterialCode") + dataToSend.getString("Entry_VCode").split("\\(")[0]);
		MatBasicPstmt.executeUpdate();
		
		JSONObject Result = new JSONObject();
		Result.put("status", "Success");
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
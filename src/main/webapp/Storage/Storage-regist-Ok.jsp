<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
		JSONObject saveListData = new JSONObject(jsonString.toString());
		LocalDateTime now = LocalDateTime.now();
		String Time = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		
		String Id = saveListData.getString("Storage_Id");
		String Des = saveListData.getString("Des");
		
		String ComCode = saveListData.getString("ComCode");
		String ComName = saveListData.getString("Com_Name");
		
		String PlantCode = saveListData.getString("Plant_Select");
		String PlantName = saveListData.getString("Plant_Name");
		
		String LocaType = saveListData.getString("Stor_Code");
		String LocaName = saveListData.getString("Stor_Des"); 
		
		Boolean Rack = Boolean.parseBoolean(saveListData.getString("Rack_YN"));
		
		Boolean Bin = Boolean.parseBoolean(saveListData.getString("Bin_YN"));
		
		Boolean UseYN = Boolean.parseBoolean(saveListData.getString("Code_YN"));
		
		int id1 = 17011381;
		int id2 = 76019202;
		
		String sql = "INSERT INTO storage VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		PreparedStatement pstmt = conn.prepareStatement(sql);
	

		pstmt.setString(1, Id);
		pstmt.setString(2, Des);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, ComName);
		pstmt.setString(5, PlantCode);
		pstmt.setString(6, PlantName);
		pstmt.setString(7, LocaType);
		pstmt.setString(8, LocaName);
		pstmt.setBoolean(9, Rack);
		pstmt.setBoolean(10, Bin);
		pstmt.setBoolean(11, UseYN);
		pstmt.setString(12, Time);
		pstmt.setInt(13, id1);
		pstmt.setString(14, Time);
		pstmt.setInt(15, id2);
		
		pstmt.executeUpdate();
		JSONObject Result = new JSONObject();
		Result.put("status", "Success");
		
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
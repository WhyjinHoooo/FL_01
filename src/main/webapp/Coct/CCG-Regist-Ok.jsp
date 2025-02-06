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
	String formattedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	
	String ccg = saveListData.getString("CCG");
	String Des = saveListData.getString("Des");
	
	String ComCode = saveListData.getString("ComCode");
	String tccg = saveListData.getString("Com_Name");
	
	int level = Integer.parseInt(saveListData.getString("CCTR-level"));
	String Upper = saveListData.getString("Upper-CCT-Group");
	
	boolean Use = Boolean.parseBoolean(saveListData.getString("Use-Useless"));
	
	int Id1 = 17011381;
	int Id2 = 76019202;
	
	String sql = "INSERT INTO coct VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	

		pstmt.setString(1, ccg);
		pstmt.setString(2, Des);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, tccg);
		pstmt.setInt(5, level);
		pstmt.setString(6, Upper);
		pstmt.setBoolean(7, Use);
		pstmt.setString(8, formattedNow);
		pstmt.setInt(9, Id1);
		pstmt.setString(10, formattedNow);
		pstmt.setInt(11, Id2);
		
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
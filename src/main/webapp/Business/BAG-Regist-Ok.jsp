<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
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
	/*main-info*/
	String Bag = saveListData.getString("bag");
	String Name = saveListData.getString("bag-des");
	/*sub-info*/
	String ComCode = saveListData.getString("ComCode");
	String Tbag = saveListData.getString("Com_Name");
	int level = Integer.parseInt(saveListData.getString("Biz-level"));
	String Biz_level = saveListData.getString("Upper-Biz-level");
	boolean Use = Boolean.parseBoolean(saveListData.getString("Use-Useless"));
	
	int test2 = 1;
	int test4 = 2;
	
	String sql = "INSERT INTO bizareagroup VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	
		pstmt.setString(1, Bag);
		pstmt.setString(2, Name);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, Tbag);
		pstmt.setInt(5, level);
		pstmt.setString(6, Biz_level);
		pstmt.setBoolean(7, Use);
		
		pstmt.setString(8, formattedNow);
		pstmt.setInt(9, test2);
		pstmt.setString(10, formattedNow);
		pstmt.setInt(11, test4);
		
		pstmt.executeUpdate();
		JSONObject Result = new JSONObject();
		Result.put("status", "Success");
		
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
	} catch(SQLException e){
		e.printStackTrace();
	}
%>

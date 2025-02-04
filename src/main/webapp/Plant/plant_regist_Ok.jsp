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
	try {	
	JSONObject saveListData = new JSONObject(jsonString.toString());
	LocalDateTime now = LocalDateTime.now();
	String CreateDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	String ChangedDate = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	
	String Plant_id = saveListData.getString("plant_code");
	String Plant_Des = saveListData.getString("Des");
	
	String ComCode = saveListData.getString("ComCode");
	
	String Biz_Area = saveListData.getString("BizSelect");
	
	String Post_Code = saveListData.getString("AddrCode");
	
	String Addr1 = saveListData.getString("Addr");
	String Addr2 = saveListData.getString("AddrDetail");
	
	String LocalCurr = saveListData.getString("money");
	String Lang = saveListData.getString("lang");
	
	String Start = saveListData.getString("today");
	String End = saveListData.getString("future");
	
	boolean Yn = Boolean.parseBoolean(saveListData.getString("Use-Useless"));
	
	int id1 = 17011381;
	int id2 = 76019020;
	
	String sql = "INSERT INTO plant VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	
	pstmt.setString(1,Plant_id);
	pstmt.setString(2,Plant_Des);
	pstmt.setString(3,ComCode);
	pstmt.setString(4,Biz_Area);
	pstmt.setString(5,Post_Code);
	pstmt.setString(6,Addr1);
	pstmt.setString(7,Addr2);
	pstmt.setString(8,LocalCurr);
	pstmt.setString(9,Lang);
	pstmt.setString(10,Start);
	pstmt.setString(11,End);
	pstmt.setBoolean(12,Yn);
	pstmt.setString(13,CreateDate);
	pstmt.setInt(14,id1);
	pstmt.setString(15,ChangedDate);
	pstmt.setInt(16,id2);
	
// 	pstmt.executeUpdate();
	
	JSONObject Result = new JSONObject();
	Result.put("status", "Success");	
	
	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");	
	response.getWriter().write(Result.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
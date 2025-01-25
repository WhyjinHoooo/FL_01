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
		String formattedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	
		String Tac = saveListData.getString("TAC");
		String Des = saveListData.getString("Des");
		
		String ComCode = saveListData.getString("ComCode");
		String NaCode = saveListData.getString("Na-Code");
		
		String PosCode = saveListData.getString("AddrCode");
		
		String Addr1 = saveListData.getString("Addr");
		String Addr2 = saveListData.getString("AddrDetail");
		
		String Select = saveListData.getString("Select_MS");
		String MainTa = saveListData.getString("main-TA-Code");
		
		String Use = saveListData.getString("Use-Useless");
		
		int ID1 = 12345;
		int ID2 = 56789;
	
		String sql = "INSERT INTO taxarea VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		PreparedStatement pstmt = conn.prepareStatement(sql);

		if(MainTa == null || MainTa.equals("")) {
			MainTa = ComCode;
		}
		pstmt.setString(1, Tac);
		pstmt.setString(2, Des);
		pstmt.setString(3, ComCode);
		pstmt.setString(4, NaCode);
		pstmt.setString(5, PosCode);
		pstmt.setString(6, Addr1);
		pstmt.setString(7, Addr2);
		pstmt.setString(8, Select);
		pstmt.setString(9, MainTa);
		pstmt.setString(10, Use);
		pstmt.setString(11, formattedNow);
		pstmt.setInt(12, ID1);
		pstmt.setString(13, formattedNow);
		pstmt.setInt(14, ID2);
		
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
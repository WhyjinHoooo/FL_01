<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.YearMonth"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	
	// 변수모음
	String UserId = (String)session.getAttribute("id");
	String firstValue = null;
	boolean allSame = true; // 모든 값이 같은지 확인할 변수
	LocalDateTime today = LocalDateTime.now();
	
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
	DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("yyyyMMdd");
	String Time = today.format(formatter);
	String DateSplit = today.format(formatter2);
	
	try (BufferedReader reader = request.getReader()) {
        while ((line = reader.readLine()) != null) {
            jsonString.append(line);
        }
    }

	JSONArray saveListData = new JSONArray(jsonString.toString());
	JSONObject DataList = null;

	System.out.println(Time);
	try{
		
		String HeadUp_Sql = "UPDATE sales_delrequestcmdheader SET DelivConfirmDate = ? WHERE KeyValue = ?";
		String LineUp_Sql = "UPDATE sales_delrequestcmdline SET DelivConfirmDate = ? WHERE KeyValue = ?";
		
		PreparedStatement Head_Pstmt = conn.prepareStatement(HeadUp_Sql);
		PreparedStatement Line_Pstmt = conn.prepareStatement(LineUp_Sql);

		Head_Pstmt.setString(1, saveListData.getJSONArray(1).getString(0) + " " +  Time); // 반출일자
		Head_Pstmt.setString(2, saveListData.getJSONArray(1).getString(1) + saveListData.getJSONArray(1).getString(2)); // 납품번호
		System.out.println(saveListData.getJSONArray(1).getString(0) + Time);
		System.out.println(saveListData.getJSONArray(1).getString(1) + saveListData.getJSONArray(1).getString(2));
		
		for(int i = 0 ; i < saveListData.getJSONArray(0).length() ; i++){
			Line_Pstmt.setString(1, saveListData.getJSONArray(1).getString(0)); // 항번
			Line_Pstmt.setString(2, saveListData.getJSONArray(0).getString(i)); // 품번
				
			System.out.println(saveListData.getJSONArray(1).getString(0));
			System.out.println(saveListData.getJSONArray(0).getString(i));
			
  			Line_Pstmt.executeUpdate();
		}
		Head_Pstmt.executeUpdate();
	response.setContentType("application/json; charset=UTF-8");
	response.getWriter().write("{\"status\": \"Success\"}");
	}catch(SQLException e){
		e.printStackTrace();
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"Error\"}");
	}
%>

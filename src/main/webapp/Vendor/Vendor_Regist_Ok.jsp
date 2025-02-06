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
	
	String ComCode = saveListData.getString("ComCode");
	String VenCode = saveListData.getString("vendorInput");
	String Des = saveListData.getString("vendorDes");
	
	String NaCode = saveListData.getString("NationCode");
	String NaDes = saveListData.getString("NationDes");
	
	String PostalCode = saveListData.getString("AddrCode");
	
	String Addr1 = saveListData.getString("Addr");
	String Addr2 = saveListData.getString("AddrDetail");
	
	String RepPhone = saveListData.getString("RepPhone");
	String RepName = saveListData.getString("RepName");
	
	boolean Deal = Boolean.parseBoolean(saveListData.getString("Deal"));
	
	String IndusNum = saveListData.getString("PhoneNum");
	
	String UpCode = saveListData.getString("UptaCode");
	String BusinessCode = saveListData.getString("BusinessCode");
	
	String sql = "INSERT INTO vendor VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1,ComCode);
	pstmt.setString(2,VenCode);
	pstmt.setString(3,Des);
	pstmt.setString(4,NaCode);
	pstmt.setString(5,NaDes);
	pstmt.setString(6,PostalCode);
	pstmt.setString(7,Addr1);
	pstmt.setString(8,Addr2);
	pstmt.setString(9,RepPhone);
	pstmt.setString(10,RepName);
	pstmt.setBoolean(11,Deal);
	pstmt.setString(12,IndusNum);
	pstmt.setString(13,UpCode);
	pstmt.setString(14,BusinessCode);
	
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
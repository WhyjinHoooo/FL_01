<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
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
	
	    String BaCd = saveListData.getString("BAC");
	    String Des = saveListData.getString("Des");
	
	    String ComCode = saveListData.getString("ComCode");
	
	    String NaCode = saveListData.getString("Na-Code");
	    String NaName = saveListData.getString("Na-Des");
	
	    String PostCode = saveListData.getString("AddrCode");
	    String Addr1 = saveListData.getString("Addr");
	    String Addr2 = saveListData.getString("AddrDetail");
	
	    String MoUnit = saveListData.getString("money");
	    String Lan = saveListData.getString("lang");
	
	    String Tax = saveListData.getString("TA-code");
	    String Biz = saveListData.getString("BAG-code");
	    
	    boolean Use = Boolean.parseBoolean( saveListData.getString("Use-Useless"));
		
	    int ID1 = 17011381;
	    int ID2 = 76019202;
	    
	    String sql = "INSERT INTO bizarea VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	    
	    PreparedStatement pstmt = conn.prepareStatement(sql);
    
	    pstmt.setString(1, BaCd);
	    pstmt.setString(2, Des);
	    pstmt.setString(3, ComCode);
	    pstmt.setString(4, NaCode);
	    pstmt.setString(5, NaName);
	    pstmt.setString(6, PostCode);
	    pstmt.setString(7, Addr1);
	    pstmt.setString(8, Addr2);
	    pstmt.setString(9, MoUnit);
	    pstmt.setString(10, Lan);
	    pstmt.setString(11, Tax);
	    pstmt.setString(12, Biz);
	    pstmt.setBoolean(13, Use);
	    pstmt.setString(14, formattedNow);
	    pstmt.setInt(15, ID1);
	    pstmt.setString(16, formattedNow);
	    pstmt.setInt(17, ID2);
	    
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


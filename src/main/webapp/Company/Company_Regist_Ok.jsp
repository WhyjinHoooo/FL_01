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

	String cocd = saveListData.getString("Com_code");
	String Des = saveListData.getString("Des");
	
	String NaCode = saveListData.getString("NationCode");
	String NaName = saveListData.getString("NationName_input");
	
	String PtCd = saveListData.getString("AddrCode");
	
	String Addr = saveListData.getString("AddrCode");
	String AddrDetail = saveListData.getString("AddrDetail");
	
	String money = saveListData.getString("money");
	String lang = saveListData.getString("lang");
	
	
	boolean BA = Boolean.parseBoolean(saveListData.getString("BA_use"));
	boolean TA = Boolean.parseBoolean(saveListData.getString("FSRL"));
	
	String TB = saveListData.getString("TB_use");
	String FSRL = saveListData.getString("Des");
	
	int init_ID = 17011381;
	int init_lv = 0;
	/*-----------------*/
	String sql = "INSERT INTO company VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
	String sql2 = "INSERT INTO bizareagroup VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	String sql3 = "INSERT INTO coct VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	PreparedStatement pstmt2 = conn.prepareStatement(sql2);
	PreparedStatement pstmt3 = conn.prepareStatement(sql3);
	
	
		pstmt.setString(1, cocd);
		pstmt.setString(2, Des);
		pstmt.setString(3, NaCode);
		pstmt.setString(4, NaName);
		pstmt.setString(5, PtCd);
		pstmt.setString(6, Addr);
		pstmt.setString(7, AddrDetail);
		pstmt.setString(8, money);
		pstmt.setString(9, lang);
		pstmt.setBoolean(10, BA);
		pstmt.setBoolean(11, TA);
		pstmt.setString(12, TB);
		pstmt.setString(13, FSRL);
		pstmt.executeUpdate();
		
		/* bizareagroup insert 쿼리문 */
		pstmt2.setString(1, cocd);
		pstmt2.setString(2, cocd);
		pstmt2.setString(3, cocd);
		pstmt2.setString(4, cocd);
		pstmt2.setInt(5,init_lv);
		pstmt2.setString(6, cocd);
		pstmt2.setBoolean(7,true);
		pstmt2.setString(8, formattedNow);
		pstmt2.setInt(9,init_ID);
		pstmt2.setString(10, formattedNow);
		pstmt2.setInt(11,init_ID);
		pstmt2.executeUpdate();
		
		/* coct insert 쿼리문 */
		pstmt3.setString(1, cocd);
		pstmt3.setString(2, cocd);
		pstmt3.setString(3, cocd);
		pstmt3.setString(4, cocd);
		pstmt3.setInt(5,init_lv);
		pstmt3.setString(6, cocd);
		pstmt3.setBoolean(7,true);
		pstmt3.setString(8, formattedNow);
		pstmt3.setInt(9,init_ID);
		pstmt3.setString(10, formattedNow);
		pstmt3.setInt(11,init_ID);
		pstmt3.executeUpdate();
		
		JSONObject Result = new JSONObject();
		Result.put("status", "Success");
	    Result.put("message", "로그인 성공");
	    
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
	} catch(SQLException e){
		e.printStackTrace();
		
	}
%>

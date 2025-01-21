<%@page import="java.util.Iterator"%>
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
<%@ include file="../mydbcon.jsp"%>   
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
	Iterator<String> keys = saveListData.keys();
	
	String UserId = null;
	String UserPW = null;
	String UserBelong = null;
	
	while(keys.hasNext()){
		String key = keys.next();
		System.out.println(key + " : " + saveListData.get(key));
		switch(key){
		case "UserPw":
			UserPW = saveListData.getString(key);
		break;
		case "UserId":
			UserId = saveListData.getString(key);
			break;
		case "ComChoice":
			UserBelong = saveListData.getString(key);
			break;
		}
	}
	String sql = "SELECT * FROM membership WHERE Id = ? AND PW = ? AND Belong = ?";
	String pass = null;
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, UserId);
	pstmt.setString(2, UserPW);
	pstmt.setString(3, UserBelong);
	ResultSet rs = pstmt.executeQuery();
	
	JSONObject Result = new JSONObject();
	if(rs.next()){
		session.setAttribute("id", UserId);
		session.setAttribute("depart", UserBelong);
		session.setAttribute("name", rs.getString("UserName"));
		session.setAttribute("UserCode", rs.getString("Id"));
	    Result.put("status", "Success");
	    Result.put("message", "로그인 성공");
	}else{
		Result.put("status", "Fail");
		Result.put("message", "로그인 실패");
	}
    response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	response.getWriter().write(Result.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>

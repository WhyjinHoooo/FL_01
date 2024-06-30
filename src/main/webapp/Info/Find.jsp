<%@page import="org.apache.catalina.valves.JsonErrorReportValve"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../mydbcon.jsp" %>
<%
	String Search = request.getParameter("sql");
	String Category = request.getParameter("type");
	/* System.out.println("전달받은 회사코드, 카테고리 : "  + Search + ", " + Category); */
	
	String sql = "";
	
	switch(Category){
		case "Com_Code" : 
			sql = Search;
			break;
		case "Plant" : 
			sql = Search;
			break;
		case "StorLoc" : 
			sql = Search;
			break;
	}
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery();
	JSONArray list = new JSONArray();
	
	if(!rs.next()){
		list.put(new JSONObject().put("error", "정보가 없습니다."));
	} else if(Category.equals("Com_Code")){ 
		do{
			JSONObject record = new JSONObject();
			record.put("코드", rs.getString("Com_Cd"));
			record.put("이름", rs.getString("Com_Des"));
			list.put(record);
		} while(rs.next());
	} else if(Category.equals("Plant")){ 
		do{
			JSONObject record = new JSONObject();
			record.put("코드", rs.getString("PLANT_ID"));
			record.put("이름", rs.getString("PLANT_NAME"));
			list.put(record);
		} while(rs.next());
	} else if(Category.equals("StorLoc")){ 
		do{
			JSONObject record = new JSONObject();
			record.put("코드", rs.getString("STORAGR_ID"));
			record.put("이름", rs.getString("STORAGR_NAME"));
			list.put(record);
		} while(rs.next());
	}
	
	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	response.getWriter().write(list.toString());
%>
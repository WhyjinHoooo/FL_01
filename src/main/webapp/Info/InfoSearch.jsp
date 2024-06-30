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
	String Search = request.getParameter("Find");
	String Category = request.getParameter("Condi");
	System.out.println("전달받은 회사코드, 카테고리 : "  + Search + ", " + Category);
	
	String sql = "";
	
	switch(Category){
		case "Com_Code" : 
			sql = "SELECT * FROM totalMaterial_child WHERE Com_Code = ?";
			break;
		case "Plant" : 
			sql = "SELECT * FROM totalMaterial_child WHERE Plant = ?";
			break;
		case "StorLoc" : 
			sql = "SELECT * FROM totalMaterial_child WHERE StorLoc = ?";
			break;
	}
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, Search);
	ResultSet rs = pstmt.executeQuery();
	JSONArray list = new JSONArray();
	String Lot = "*";
	
	if(!rs.next()){
		list.put(new JSONObject().put("error", "Find에 저장된 데이터에 대한 정보가 없습니다."));
	} else{ 
		do{
			JSONObject record = new JSONObject();
			record.put("년월", rs.getString("YYMM"));
			record.put("회사", rs.getString("Com_Code"));
			record.put("재료", rs.getString("Material"));
			record.put("단위", rs.getString("InvUnit"));
			record.put("공장", rs.getString("Plant"));
			record.put("창고", rs.getString("StorLoc"));
			record.put("기초수량", rs.getInt("Initial_Qty"));
			record.put("기초금액", rs.getInt("Initial_Amt"));
			record.put("입고수량", rs.getInt("Purchase_In"));
			record.put("입고금액", rs.getInt("Purchase_Amt"));
			record.put("입출수량", rs.getInt("Transfer_InOut"));
			record.put("입출금액", rs.getInt("Transfer_Amt"));
			record.put("출고수량", rs.getInt("Material_Out"));
			record.put("출고금액", rs.getInt("Material_Amt"));
			record.put("재고수량", rs.getInt("Inventory_Qty"));
			record.put("재고금액", rs.getInt("Inventory_Amt"));
			record.put("재고단가", String.format("%.3f",Double.valueOf(rs.getInt("Inventory_UnitPrice"))));
			record.put("Lot", Lot);
			list.put(record);
			System.out.println(list.toString());
		} while(rs.next());
	}
	
	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	response.getWriter().write(list.toString());
%>
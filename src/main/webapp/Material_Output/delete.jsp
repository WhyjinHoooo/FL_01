<%@page import="org.json.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="org.json.simple.parser.*"%>
<%@page import="org.json.simple.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	JSONArray DeleteListData = new JSONArray(jsonString.toString());

	String DocCode = DeleteListData.getString(0); // Mat. 출고 문서번호
	String MatCode = DeleteListData.getString(2); // 자재코드
	String ComCode = DeleteListData.getString(3); // 회사코드
	String StorageCode = DeleteListData.getString(4); // 창고코드
	String PlantCode = DeleteListData.getString(5); // 공장코드
	String Date4Y1M = DeleteListData.getString(6); // 날짜
	int Count = Integer.parseInt(DeleteListData.getString(7));
	System.out.println(MatCode);
	try{
		String SearchSql_H = "SELECT * FROM totalmaterial_head WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
		PreparedStatement SearchPstmt_H = conn.prepareStatement(SearchSql_H);
		SearchPstmt_H.setString(1, Date4Y1M);
		SearchPstmt_H.setString(2, ComCode);
		SearchPstmt_H.setString(3, MatCode);
		ResultSet SearchRs_H = SearchPstmt_H.executeQuery();
		
		String SearchSql_C = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
		PreparedStatement SearchPstmt_C = conn.prepareStatement(SearchSql_C);
		SearchPstmt_C.setString(1, Date4Y1M);
		SearchPstmt_C.setString(2, ComCode);
		SearchPstmt_C.setString(3, MatCode);
		SearchPstmt_C.setString(4, PlantCode);
		SearchPstmt_C.setString(5, StorageCode);
		ResultSet SearchRs_C = SearchPstmt_C.executeQuery();
		if(SearchRs_H.next() && SearchRs_C.next()){
			double unitPrice = Double.parseDouble(SearchRs_H.getString("Inventory_UnitPrice")); // 
			int NewPrice = (int)Math.round(Count * unitPrice);
			/* 1 */
			int Be_H_Material_Out = Integer.parseInt(SearchRs_H.getString("Material_Out"));
			int Be_H_Material_Amt = Integer.parseInt(SearchRs_H.getString("Material_Amt"));
			int Be_H_Inventory_Qty = Integer.parseInt(SearchRs_H.getString("Inventory_Qty"));
			int Be_H_Inventory_Amt = Integer.parseInt(SearchRs_H.getString("Inventory_Amt"));
			
			int New_H_Material_Out = Be_H_Material_Out - Count;
			int New_H_Material_Amt = Be_H_Material_Amt - NewPrice;
			int New_H_Inventory_Qty = Be_H_Inventory_Qty + Count;
			int New_H_Inventory_Amt = Be_H_Inventory_Amt + NewPrice;
			/* 2 */
			int Be_C_Material_Out = Integer.parseInt(SearchRs_C.getString("Material_Out"));
			int Be_C_Material_Amt = Integer.parseInt(SearchRs_C.getString("Material_Amt"));
			int Be_C_Inventory_Qty = Integer.parseInt(SearchRs_C.getString("Inventory_Qty"));
			int Be_C_Inventory_Amt = Integer.parseInt(SearchRs_C.getString("Inventory_Amt"));
			
			int New_C_Material_Out = Be_C_Material_Out - Count;
			int New_C_Material_Amt = Be_C_Material_Amt - NewPrice;
			int New_C_Inventory_Qty = Be_C_Inventory_Qty + Count;
			int New_C_Inventory_Amt = Be_C_Inventory_Amt + NewPrice;
			
			String Up_H_sql = "UPDATE totalMaterial_head SET "+ 
							  "Material_Out = ?, Material_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ? "+
							  "WHERE Material = ? AND YYMM = ? AND Com_Code = ?";
			String Up_C_sql = "UPDATE totalmaterial_child SET "+ 
							  "Material_Out = ?, Material_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ? "+
							  "WHERE StorLoc = ? AND Material = ? AND Com_Code = ? AND YYMM = ? AND Plant = ?";
			PreparedStatement H_pstmt = conn.prepareStatement(Up_H_sql);
			H_pstmt.setInt(1, New_H_Material_Out);
			H_pstmt.setInt(2, New_H_Material_Amt);
			H_pstmt.setInt(3, New_H_Inventory_Qty);
			H_pstmt.setInt(4, New_H_Inventory_Amt);
			H_pstmt.setString(5, MatCode);
			H_pstmt.setString(6, Date4Y1M);
			H_pstmt.setString(7, ComCode);
			H_pstmt.executeUpdate();
			
			PreparedStatement C_pstmt = conn.prepareStatement(Up_C_sql);
			C_pstmt.setInt(1, New_C_Material_Out);
			C_pstmt.setInt(2, New_C_Material_Amt);
			C_pstmt.setInt(3, New_C_Inventory_Qty);
			C_pstmt.setInt(4, New_C_Inventory_Amt);
			C_pstmt.setString(5, StorageCode);
			C_pstmt.setString(6, MatCode);
			C_pstmt.setString(7, ComCode);
			C_pstmt.setString(8, Date4Y1M);
			C_pstmt.setString(9, PlantCode);
			C_pstmt.executeUpdate();
		}
		JSONObject jsonResponse = new JSONObject();
		jsonResponse.put("status", "success");
		jsonResponse.put("message", "Data updated successfully");
			    
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jsonResponse.toString());
	}catch(Exception e){
		e.printStackTrace();
		JSONObject jsonResponse = new JSONObject();
		jsonResponse.put("status", "error");
		jsonResponse.put("message", e.getMessage());
		    
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(jsonResponse.toString());		
	}
%>
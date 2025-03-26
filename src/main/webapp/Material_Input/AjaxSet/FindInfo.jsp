<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String PlantCode = request.getParameter("plant");
	String VendorCode = request.getParameter("vendor");
	PreparedStatement Head_pstmt = null;
	ResultSet Head_rs = null;
	String Head_sql = null;;
	if(VendorCode == null || VendorCode.isEmpty()){
		System.out.println("1");
		Head_sql = "SELECT * FROM request_ord WHERE Plant = ? AND NOT RegidQty IN (0)";
		Head_pstmt = conn.prepareStatement(Head_sql);
		Head_pstmt.setString(1, PlantCode);
	}else{
		System.out.println("2");
		Head_sql = "SELECT * FROM request_ord WHERE Plant = ? AND Vendor = ? AND NOT RegidQty IN (0)";
		Head_pstmt = conn.prepareStatement(Head_sql);
		Head_pstmt.setString(1, PlantCode);
		Head_pstmt.setString(2, VendorCode);
	}
	
	Head_rs = Head_pstmt.executeQuery();
	JSONArray jsonArray = new JSONArray();
	while(Head_rs.next()) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("Vendor", Head_rs.getString("Vendor"));
		jsonObject.put("VenderDesc", Head_rs.getString("VenderDesc"));
		jsonObject.put("ActNumPO", Head_rs.getString("ActNumPO"));
		jsonObject.put("ItemNo", Head_rs.getString("ItemNo"));
		jsonObject.put("MatCode", Head_rs.getString("MatCode"));
		jsonObject.put("MatDesc", Head_rs.getString("MatDesc"));
		jsonObject.put("MatType", Head_rs.getString("MatType"));
		jsonObject.put("QtyPO", Head_rs.getString("QtyPO"));
		jsonObject.put("Unit", Head_rs.getString("Unit"));
		
		String ChkSql = "SELECT * FROM input_temtable WHERE PurOrdNo = ?";
		PreparedStatement ChkPstmt = conn.prepareStatement(ChkSql);
		ChkPstmt.setString(1, Head_rs.getString("ActNumPO"));
		ResultSet ChkRs = ChkPstmt.executeQuery();
		if(ChkRs.next()){
		    do {
		        int count = ChkRs.getInt("Count");
		        jsonObject.put("RecSumQty", Head_rs.getInt("RecSumQty") + count);
		        jsonObject.put("RegidQty", Head_rs.getInt("RegidQty") - count);
		    } while(ChkRs.next());
		} else {
		    jsonObject.put("RecSumQty", Head_rs.getInt("RecSumQty"));
		    jsonObject.put("RegidQty", Head_rs.getInt("RegidQty"));
		}
		
		jsonObject.put("TCur", Head_rs.getString("TCur"));
		jsonObject.put("RequestDate", Head_rs.getString("RequestDate"));
		jsonObject.put("StorLoca", Head_rs.getString("StorLoca") + "(" + Head_rs.getString("StorLocaDesc") +")");
		jsonObject.put("Plant", Head_rs.getString("Plant"));
		jsonArray.add(jsonObject);
	}
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonArray.toString());
} catch(SQLException e){
	e.printStackTrace();
}
%>


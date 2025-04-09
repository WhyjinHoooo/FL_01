<%@page import="java.io.BufferedReader"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  
<%
try{
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	JSONObject dataToSend = new JSONObject(jsonString.toString());
	System.out.println(dataToSend);
	String State = null;
	String InfoSql = null;
	PreparedStatement InfoPstmt = null;
	ResultSet InfoRs = null;
	
	if(dataToSend.getString("MatData") == null || dataToSend.getString("MatData").isEmpty()){
		InfoSql = "SELECT * FROM storechild WHERE DocDate >= ? AND DocDate <= ? AND Plant = ? AND LEFT(MovType, 2) IN (? , ?) AND MatType = ? ORDER BY RIGHT(MovType, 3) ASC";
		InfoPstmt = conn.prepareStatement(InfoSql);
		InfoPstmt.setString(1, dataToSend.getString("FromDate"));
		InfoPstmt.setString(2, dataToSend.getString("EndDate"));
		InfoPstmt.setString(3, dataToSend.getString("PlantData"));
		InfoPstmt.setString(4, dataToSend.getString("MovIn"));
		InfoPstmt.setString(5, dataToSend.getString("MovOut"));
		InfoPstmt.setString(6, dataToSend.getString("MatType"));
	}else{
		InfoSql = "SELECT * FROM storechild WHERE DocDate >= ? AND DocDate <= ? AND Plant = ? AND LEFT(MovType, 2) IN (? , ?) AND MatType = ? AND Material = ? ORDER BY RIGHT(MovType, 3) ASC";
		InfoPstmt = conn.prepareStatement(InfoSql);
		InfoPstmt.setString(1, dataToSend.getString("FromDate"));
		InfoPstmt.setString(2, dataToSend.getString("EndDate"));
		InfoPstmt.setString(3, dataToSend.getString("PlantData"));
		InfoPstmt.setString(4, dataToSend.getString("MovIn"));
		InfoPstmt.setString(5, dataToSend.getString("MovOut"));
		InfoPstmt.setString(6, dataToSend.getString("MatType"));
		InfoPstmt.setString(7, dataToSend.getString("MatData"));
	}
	InfoRs = InfoPstmt.executeQuery();
	JSONArray jsonArray = new JSONArray();
	while(InfoRs.next()) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("DocDate", InfoRs.getString("DocDate"));
		jsonObject.put("MatDocNum", InfoRs.getString("MatDocNum"));
		jsonObject.put("ItemNum", InfoRs.getString("ItemNum"));
		jsonObject.put("Material", InfoRs.getString("Material"));
		jsonObject.put("MaterialDescription", InfoRs.getString("MaterialDescription"));
		jsonObject.put("InvUnit", InfoRs.getString("InvUnit"));
		jsonObject.put("MovType", InfoRs.getString("MovType"));
		
		String FindUnit = "SELECT * FROM movetype WHERE MoveType = ?";
		PreparedStatement FU_Pstmt = conn.prepareStatement(FindUnit);
		FU_Pstmt.setString(1, InfoRs.getString("MovType"));
		ResultSet rs = FU_Pstmt.executeQuery();
		if(rs.next()){
			jsonObject.put("MoveTypeDes", rs.getString("MoveTypeDes"));
		}
		jsonObject.put("Quantity", InfoRs.getString("Quantity"));
		jsonObject.put("StoLoca", InfoRs.getString("StoLoca"));
		
		String FindSlo = "SELECT STORAGR_NAME FROM storage WHERE STORAGR_ID = ?";
		PreparedStatement FS_Pstmt = conn.prepareStatement(FindSlo);
		FS_Pstmt.setString(1, InfoRs.getString("StoLoca"));
		ResultSet FS_Rs = FS_Pstmt.executeQuery();  // FU_Pstmt → FS_Pstmt 수정
		if (FS_Rs.next()) {
		    jsonObject.put("STORAGR_NAME", FS_Rs.getString("STORAGR_NAME"));
		}
		jsonObject.put("OrderNum", InfoRs.getString("OrderNum"));
		jsonObject.put("CostObject", JSONObject.NULL); // COST OBJECT
		jsonObject.put("Plant", InfoRs.getString("Plant"));
		jsonObject.put("InputPerson", InfoRs.getString("InputPerson"));
		jsonArray.add(jsonObject);
	}
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonArray.toString());
} catch(Exception e){
	e.printStackTrace();
}
%>


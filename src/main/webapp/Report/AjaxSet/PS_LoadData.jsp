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
	String State = null;
	String InfoSql = null;
	PreparedStatement InfoPstmt = null;
	ResultSet InfoRs = null;
	
	State = dataToSend.getString("value");
	switch(State){
	case "2":
		if(dataToSend.getString("MatData") == null || dataToSend.getString("MatData").isEmpty()){
			InfoSql = "SELECT * FROM totalmaterial_child WHERE YYMM >= ? AND YYMM <= ? AND Com_Code = ? AND Plant = ?";
			InfoPstmt = conn.prepareStatement(InfoSql);
			InfoPstmt.setString(1, dataToSend.getString("FromDate").substring(0, 7));
			InfoPstmt.setString(2, dataToSend.getString("EndDate").substring(0, 7));
			InfoPstmt.setString(3, dataToSend.getString("ComData"));
			InfoPstmt.setString(4, dataToSend.getString("PlantData"));
		}else{
			InfoSql = "SELECT * FROM totalmaterial_child WHERE YYMM >= ? AND YYMM <= ? AND Com_Code = ? AND Plant = ? AND Material = ?";
			InfoPstmt = conn.prepareStatement(InfoSql);
			InfoPstmt.setString(1, dataToSend.getString("FromDate").substring(0, 7));
			InfoPstmt.setString(2, dataToSend.getString("EndDate").substring(0, 7));
			InfoPstmt.setString(3, dataToSend.getString("ComData"));
			InfoPstmt.setString(4, dataToSend.getString("PlantData"));
			InfoPstmt.setString(5, dataToSend.getString("MatData"));
		}
		break;
	case "3":
		if(dataToSend.getString("MatData") == null || dataToSend.getString("MatData").isEmpty()){
			InfoSql = "SELECT * FROM totalmaterial_child WHERE YYMM >= ? AND YYMM <= ? AND Com_Code = ? AND Plant = ? AND StorLoc = ?";
			InfoPstmt = conn.prepareStatement(InfoSql);
			InfoPstmt.setString(1, dataToSend.getString("FromDate").substring(0, 7));
			InfoPstmt.setString(2, dataToSend.getString("EndDate").substring(0, 7));
			InfoPstmt.setString(3, dataToSend.getString("ComData"));
			InfoPstmt.setString(4, dataToSend.getString("PlantData"));
			InfoPstmt.setString(5, dataToSend.getString("SLoData"));
		}else{
			InfoSql = "SELECT * FROM totalmaterial_child WHERE YYMM >= ? AND YYMM <= ? AND Com_Code = ? AND Plant = ? AND StorLoc = ? AND Material = ?";
			InfoPstmt = conn.prepareStatement(InfoSql);
			InfoPstmt.setString(1, dataToSend.getString("FromDate").substring(0, 7));
			InfoPstmt.setString(2, dataToSend.getString("EndDate").substring(0, 7));
			InfoPstmt.setString(3, dataToSend.getString("ComData"));
			InfoPstmt.setString(4, dataToSend.getString("PlantData"));
			InfoPstmt.setString(5, dataToSend.getString("SLoData"));
			InfoPstmt.setString(6, dataToSend.getString("MatData"));
		}
		break;
	}
	InfoRs = InfoPstmt.executeQuery();
	JSONArray jsonArray = new JSONArray();
	while(InfoRs.next()) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("ComCode", dataToSend.getString("ComData"));
		jsonObject.put("Plant", InfoRs.getString("Plant"));
		jsonObject.put("StorLoc", InfoRs.getString("StorLoc"));
		jsonObject.put("Material", InfoRs.getString("Material"));
		jsonObject.put("MaterialDes", InfoRs.getString("MaterialDes"));
		String FindUnit = "SELECT * FROM matmaster  WHERE Material_code = ?";
		PreparedStatement FU_Pstmt = conn.prepareStatement(FindUnit);
		FU_Pstmt.setString(1, InfoRs.getString("Material"));
		ResultSet rs = FU_Pstmt.executeQuery();
		if(rs.next()){
			jsonObject.put("Unit", rs.getString("InvUnit") + "(" + rs.getString("Standard") + ")");
		}
		jsonObject.put("Initial_Qty", InfoRs.getString("Initial_Qty"));
		jsonObject.put("Initial_Amt", InfoRs.getString("Initial_Amt"));
		jsonObject.put("Purchase_In", InfoRs.getString("Purchase_In"));
		jsonObject.put("Purchase_Amt", InfoRs.getString("Purchase_Amt"));
		jsonObject.put("Material_Out", InfoRs.getString("Material_Out"));
		jsonObject.put("Material_Amt", InfoRs.getString("Material_Amt"));
		jsonObject.put("Transfer_InOut", InfoRs.getString("Transfer_InOut"));
		jsonObject.put("Transfer_Amt", InfoRs.getString("Transfer_Amt"));
		jsonObject.put("Inventory_Qty", InfoRs.getString("Inventory_Qty"));
		jsonObject.put("Inventory_Amt", InfoRs.getString("Inventory_Amt"));
		jsonArray.add(jsonObject);
	}
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonArray.toString());
} catch(Exception e){
	e.printStackTrace();
}
%>


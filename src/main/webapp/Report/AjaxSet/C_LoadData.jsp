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
	PreparedStatement Head_pstmt = null;
	ResultSet Head_rs = null;
	String Head_sql = null;;
	if(dataToSend.getString("MatData") == null || dataToSend.getString("MatData").isEmpty()){
		System.out.println("1");
		Head_sql = "SELECT * FROM totalmaterial_head WHERE YYMM >= ? AND YYMM <= ? AND Com_Code = ?";
		Head_pstmt = conn.prepareStatement(Head_sql);
		Head_pstmt.setString(1, dataToSend.getString("FromDate").substring(0, 7));
		Head_pstmt.setString(2, dataToSend.getString("EndDate").substring(0, 7));
		Head_pstmt.setString(3, dataToSend.getString("ComData"));
	}else{
		System.out.println("2");
		Head_sql = "SELECT * FROM totalmaterial_head WHERE Material = ? AND YYMM >= ? AND YYMM <= ? AND Com_Code = ?";
		Head_pstmt = conn.prepareStatement(Head_sql);
		Head_pstmt.setString(1, dataToSend.getString("MatData"));
		Head_pstmt.setString(2, dataToSend.getString("FromDate").substring(0, 7));
		Head_pstmt.setString(3, dataToSend.getString("EndDate").substring(0, 7));
		Head_pstmt.setString(4, dataToSend.getString("ComData"));
	}
	
	Head_rs = Head_pstmt.executeQuery();
	JSONArray jsonArray = new JSONArray();
	while(Head_rs.next()) {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("ComCode", dataToSend.getString("ComData"));
		jsonObject.put("Material", Head_rs.getString("Material"));
		jsonObject.put("MaterialDes", Head_rs.getString("MaterialDes"));
		String FindUnit = "SELECT * FROM matmaster  WHERE Material_code = ?";
		PreparedStatement FU_Pstmt = conn.prepareStatement(FindUnit);
		FU_Pstmt.setString(1, Head_rs.getString("Material"));
		ResultSet rs = FU_Pstmt.executeQuery();
		if(rs.next()){
			jsonObject.put("Unit", rs.getString("InvUnit") + "(" + rs.getString("Standard") + ")");
		}
		jsonObject.put("Initial_Qty", Head_rs.getString("Initial_Qty"));
		jsonObject.put("Initial_Amt", Head_rs.getString("Initial_Amt"));
		jsonObject.put("Purchase_In", Head_rs.getString("Purchase_In"));
		jsonObject.put("Purchase_Amt", Head_rs.getString("Purchase_Amt"));
		jsonObject.put("Material_Out", Head_rs.getString("Material_Out"));
		jsonObject.put("Material_Amt", Head_rs.getString("Material_Amt"));
		jsonObject.put("Transfer_InOut", Head_rs.getString("Transfer_InOut"));
		jsonObject.put("Transfer_Amt", Head_rs.getString("Transfer_Amt"));
		jsonObject.put("Inventory_Qty", Head_rs.getString("Inventory_Qty"));
		jsonObject.put("Inventory_Amt", Head_rs.getString("Inventory_Amt"));
		jsonArray.add(jsonObject);
	}
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonArray.toString());
} catch(SQLException e){
	e.printStackTrace();
}
%>


<%@ page import ="org.json.simple.JSONArray" %>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>
<%@page import="org.json.simple.JSONValue"%>
<%@ page import ="org.json.JSONObject" %> 
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>  

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
		JSONObject dataToSend = new JSONObject(jsonString.toString());
		System.out.println(dataToSend);
		System.out.println(dataToSend.getString("ComCode"));
		int Page = 0;
		String sql = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		if(dataToSend.getString("MatTypeCode").isEmpty() && dataToSend.getString("VendorCode").isEmpty()){
			Page = 3;
		}else if(dataToSend.getString("VendorCode").isEmpty()){
			Page = 2;
		} else if(dataToSend.getString("MatTypeCode").isEmpty()){
			Page = 1;
		}else{
			Page = 0;
		}
		switch(Page){
		case 3:
			sql = "SELECT * FROM purprice WHERE Plant = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0, 5));
			break;
		case 2:
			sql = "SELECT * FROM purprice WHERE Plant = ? AND MatType = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0, 5));
			pstmt.setString(2, dataToSend.getString("MatTypeCode").substring(0, 4));
			break;
		case 1:
			sql = "SELECT * FROM purprice WHERE Plant = ? AND VendCode= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0, 5));
			pstmt.setString(2, dataToSend.getString("VendorCode").substring(0, 8));
			break;
		default:
			sql = "SELECT * FROM purprice WHERE Plant = ? AND VendCode= ? AND MatType = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0, 5));
			pstmt.setString(2, dataToSend.getString("VendorCode").substring(0, 8));
			pstmt.setString(3, dataToSend.getString("MatTypeCode").substring(0, 4));
		}
		rs = pstmt.executeQuery();
		JSONArray SavedDataArray = new JSONArray();
		while(rs.next()){
			JSONObject DataList = new JSONObject();
			DataList.put("MatCode", rs.getString("MatCode"));
			DataList.put("MatDesc", rs.getString("MatDesc"));
			DataList.put("VendCode", rs.getString("VendCode"));
			DataList.put("VendDes", rs.getString("VendDes"));
			DataList.put("Incoterms", rs.getString("Incoterms"));
			DataList.put("PriceBaseQty", rs.getString("PriceBaseQty"));
			DataList.put("PurUnit", rs.getString("PurUnit"));
			DataList.put("PurPrices", rs.getString("PurPrices"));
			DataList.put("UnitPrice", String.format("%.2f", rs.getDouble("PurPrices") / rs.getDouble("PriceBaseQty")));
			DataList.put("PurCurr", rs.getString("PurCurr"));
			DataList.put("ValidFrom", rs.getString("ValidFrom"));
			DataList.put("ValidTo", rs.getString("ValidTo"));
			DataList.put("ApproveDate", rs.getString("AppDate"));
			DataList.put("ApprovPerson", rs.getString("ApproPerson"));
			DataList.put("RegisDate", rs.getString("RegisDate"));
			DataList.put("RegisPerson", rs.getString("RegisPerson"));
			DataList.put("Plant", rs.getString("Plant"));
			DataList.put("ComCode", rs.getString("ComCode"));
			SavedDataArray.add(DataList);
		}
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(SavedDataArray.toString());
	} catch(Exception e){
		e.printStackTrace();
	}
%>


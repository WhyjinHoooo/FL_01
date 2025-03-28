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
			sql = "SELECT * FROM purchase_basicdata WHERE Plant = ? AND ComCode = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0, 5));
			pstmt.setString(2, dataToSend.getString("ComCode"));
			break;
		case 2:
			sql = "SELECT * FROM purchase_basicdata WHERE Plant = ? AND ComCode = ? AND MatType = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0, 5));
			pstmt.setString(2, dataToSend.getString("ComCode"));
			pstmt.setString(3, dataToSend.getString("MatTypeCode").substring(0, 4));
			break;
		case 1:
			sql = "SELECT * FROM purchase_basicdata WHERE Plant = ? AND ComCode = ? AND VendCode= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0, 5));
			pstmt.setString(2, dataToSend.getString("ComCode"));
			pstmt.setString(3, dataToSend.getString("VendorCode").substring(0, 8));
			break;
		default:
			sql = "SELECT * FROM purchase_basicdata WHERE Plant = ? AND ComCode = ? AND VendCode= ? AND MatType = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dataToSend.getString("PlantCode").substring(0, 5));
			pstmt.setString(2, dataToSend.getString("ComCode"));
			pstmt.setString(3, dataToSend.getString("VendorCode").substring(0, 8));
			pstmt.setString(4, dataToSend.getString("MatTypeCode").substring(0, 4));
		}
		rs = pstmt.executeQuery();
		JSONArray SavedDataArray = new JSONArray();
		while(rs.next()){
			JSONObject DataList = new JSONObject();
			DataList.put("MatNum", rs.getString("MatNum"));
			DataList.put("MatDesc", rs.getString("MatDesc"));
			DataList.put("Vendor", rs.getString("Vendor"));
			DataList.put("VendorDesc", rs.getString("VendorDesc"));
			switch(rs.getString("IQCYN")){
			case "1":
				DataList.put("IQCYN", "Y");
				break;
			default:
				DataList.put("IQCYN", "N");
			}
			DataList.put("PurchPerson", rs.getString("PurchPerson")); // 구매담당자
			DataList.put("PackingUInit", rs.getString("PackingUInit"));
			DataList.put("QtyPerPacking", rs.getString("QtyPerPacking"));
			DataList.put("Qtyunit", rs.getString("Qtyunit"));
			DataList.put("VenBarCode", rs.getString("VenBarCode")); // 거래처라벨
			DataList.put("IncoTerms", rs.getString("IncoTerms"));
			DataList.put("PayTerms", rs.getString("PayTerms")); // 지급조건
			DataList.put("Ltinbound", rs.getString("Ltinbound")); // 조달기간
			DataList.put("PeriUnit", rs.getString("PeriUnit")); // 기간단위
			DataList.put("Plant", rs.getString("Plant"));
			DataList.put("ComCode", rs.getString("ComCode"));
			DataList.put("RegistDate", rs.getString("RegistDate"));
			DataList.put("Registperson", rs.getString("Registperson"));
			SavedDataArray.add(DataList);
		}
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(SavedDataArray.toString());
	} catch(Exception e){
		e.printStackTrace();
	}
%>


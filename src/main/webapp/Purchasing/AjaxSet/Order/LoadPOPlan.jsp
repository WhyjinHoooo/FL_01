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
		String Sql = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		System.out.println(dataToSend);
		switch(dataToSend.getString("UnitSum")){
		case"Solo":
			if(dataToSend.getString("MatCode") == ""){
				System.out.println("1.1");
				Sql = "SELECT * FROM request_rvw WHERE Plant = ? AND Vendor = ? AND RequestDate >= ? AND RequestDate <= ? AND PueOrdNum IS NULL";
				pstmt = conn.prepareStatement(Sql);
				pstmt.setString(1, dataToSend.getString("PlantCode").substring(0,5));
				pstmt.setString(2, dataToSend.getString("VendorCode").substring(0,8));
				pstmt.setString(3, dataToSend.getString("FromDate"));
				pstmt.setString(4, dataToSend.getString("ToDate"));
			}else{
				System.out.println("1.2");
				Sql = "SELECT * FROM request_rvw WHERE Plant = ? AND Vendor = ? AND MatCode = ? AND RequestDate >= ? AND RequestDate <= ? AND PueOrdNum IS NULL";
				pstmt = conn.prepareStatement(Sql);
				pstmt.setString(1, dataToSend.getString("PlantCode").substring(0,5));
				pstmt.setString(2, dataToSend.getString("VendorCode").substring(0,8));
				pstmt.setString(3, dataToSend.getString("MatCode"));
				pstmt.setString(4, dataToSend.getString("FromDate"));
				pstmt.setString(5, dataToSend.getString("ToDate"));
			}
			rs = pstmt.executeQuery();
			while(rs.next()){
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("MatCode", rs.getString("MatCode")); // 자재코드
				jsonObject.put("MatDesc", rs.getString("MatDesc")); // 자재이름
				jsonObject.put("MatType", rs.getString("MatType")); // 재고유형
				jsonObject.put("PlanPOQty", rs.getString("PlanPOQty")); // 발줄계획수량
				jsonObject.put("Unit", rs.getString("Unit")); // 단위
				jsonObject.put("Vendor", rs.getString("Vendor")); // 공급업체
				jsonObject.put("VenderDesc", rs.getString("VenderDesc")); // 공급업체이름
				jsonObject.put("PricePerUnit", rs.getString("PricePerUnit")); // 구매단가
				jsonObject.put("TCur", rs.getString("TCur")); // 거래통화
				jsonObject.put("RequestDate", rs.getString("RequestDate")); // 납품요청일자
				jsonObject.put("StorLoca", rs.getString("StorLoca") + "(" + rs.getString("StorLocaDesc") + ")"); // 납품장소
				jsonObject.put("PlanNumPO", rs.getString("PlanNumPO")); // 발주계획번호
				jsonArray.add(jsonObject);
			}
			break;
		case "Sum":
			if(dataToSend.getString("MatCode") == ""){
				System.out.println("2.1");
				Sql = "SELECT MatCode, MatDesc, MatType, SUM(PlanPOQty) as TotalCount, Unit, " +
					      "PricePerUnit, TCur, Vendor, VenderDesc " +
					      "FROM request_rvw " +
					      "WHERE Plant = ? AND Vendor = ? AND RequestDate >= ? AND RequestDate <= ? AND PueOrdNum IS NULL GROUP BY MatCode";
				pstmt = conn.prepareStatement(Sql);
				pstmt.setString(1, dataToSend.getString("PlantCode").substring(0,5));
				pstmt.setString(2, dataToSend.getString("VendorCode").substring(0,8));
				pstmt.setString(3, dataToSend.getString("FromDate"));
				pstmt.setString(4, dataToSend.getString("ToDate"));
			}else{
				System.out.println("2.2");
				Sql = "SELECT MatCode, MatDesc, MatType, SUM(PlanPOQty) as TotalCount, Unit, " +
					      "PricePerUnit, TCur, Vendor, VenderDesc " +
					      "FROM request_rvw " +
					      "WHERE Plant = ? AND Vendor = ? AND MatCode = ? AND RequestDate >= ? AND RequestDate <= ? AND PueOrdNum IS NULL GROUP BY MatCode";
				pstmt = conn.prepareStatement(Sql);
				pstmt.setString(1, dataToSend.getString("PlantCode").substring(0,5));
				pstmt.setString(2, dataToSend.getString("VendorCode").substring(0,8));
				pstmt.setString(3, dataToSend.getString("MatCode"));
				pstmt.setString(4, dataToSend.getString("FromDate"));
				pstmt.setString(5, dataToSend.getString("ToDate"));
			}
			rs = pstmt.executeQuery();
			int TotalQuantity = 0;
			while(rs.next()){
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("MatCode", rs.getString("MatCode")); // 자재코드
				jsonObject.put("MatDesc", rs.getString("MatDesc")); // 자재이름
				jsonObject.put("MatType", rs.getString("MatType")); // 재고유형
				jsonObject.put("PlanPOQty", rs.getString("TotalCount")); // 발줄계획수량
				jsonObject.put("Unit", rs.getString("Unit")); // 단위
				jsonObject.put("Vendor", rs.getString("Vendor")); // 공급업체
				jsonObject.put("VenderDesc", rs.getString("VenderDesc")); // 공급업체이름
				jsonObject.put("PricePerUnit", rs.getString("PricePerUnit")); // 구매단가
				jsonObject.put("TCur", rs.getString("TCur")); // 거래통화
				jsonObject.put("RequestDate", "N/A"); // 납품요청일자
				jsonObject.put("StorLoca", "N/A"); // 납품장소
				jsonObject.put("PlanNumPO", "N/A"); // 발주계획번호
				jsonArray.add(jsonObject);
			}
			break;
		}
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(jsonArray.toString());
	} catch(Exception e){
		e.printStackTrace();
	}
%>


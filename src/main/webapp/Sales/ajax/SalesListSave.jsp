<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	
	try (BufferedReader reader = request.getReader()) {
        while ((line = reader.readLine()) != null) {
            jsonString.append(line);
        }
    }
	
	JSONObject saveListData = new JSONObject(jsonString.toString());
    
	System.out.println(saveListData);
	System.out.println(saveListData.length());
	System.out.println(saveListData.keySet());
	for(String key : saveListData.keySet()){
		System.out.println("key : " + key);
		JSONArray rowData = saveListData.getJSONArray(key);
		System.out.println("rowData : " + rowData);
		System.out.println("rowData(0) : " + rowData.getString(0));
		
		String ProductInfo = rowData.getString(0);
		String[] ProductInfoList = ProductInfo.split(",");
		System.out.println("ProductInfoList : " + ProductInfoList[3]);
		/* for(String info : ProductInfoList){
			System.out.println("info : " + info);
			
		} */
		
		/* String SaveSql = "INSERT INTO sales_sddata ("
			    + "PlanVer, PlanYear, PlanMonth, TradingPartner, MatCode, MatDesc, "
			    + "ExpArrivDate, SalesQty, QtyUnit, TranSalesAmt, SalesUnitPrice, TranCurr, "
			    + "PlanExRate, LocalSalesAmt, LocalCurr, BizArea, ComCode, CreatPerson, "
			    + "CreatDate, LastPerson, LastAdjustDate, KeyValue) "
			    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		PreparedStatement Sava_Pstmt = conn.prepareStatement(SaveSql);
		
		String Info_Sql01 = "SELECT * FROM sales_trandingproduct WHERE PlanVer = ? AND MatCode = ? AND TradingPartner = ? AND TranCurr = ?";
		PreparedStatement Info_Pstmt01 = conn.prepareStatement(Info_Sql01);
		Info_Pstmt01.setString(1, rowData.getString(1));
		Info_Pstmt01.setString(2, ProductInfoList[0]);
		Info_Pstmt01.setString(3, rowData.getString(2));
		Info_Pstmt01.setString(4, ProductInfoList[3]);
		ResultSet Info_Rs = Info_Pstmt01.executeQuery();
		while(Info_Rs.next()){
			System.out.println("asd : " + Info_Rs.getString("SalesUnitPrice"));
		} */
		System.out.println("1 : " + rowData.getString(1));
		System.out.println("1 : " + ProductInfoList[0]);
		System.out.println("1 : " + rowData.getString(2));
		System.out.println("1 : " + ProductInfoList[3]);
		
	}
%>

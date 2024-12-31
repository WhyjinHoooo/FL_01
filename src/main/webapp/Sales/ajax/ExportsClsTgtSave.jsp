<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.YearMonth"%>
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
	
	// 변수모음
	String UserId = (String)session.getAttribute("id");
	
	String firstValue = null;
	boolean allSame = true; // 모든 값이 같은지 확인할 변수
	LocalDateTime today = LocalDateTime.now();
	
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("yyyyMMdd");
	String todayDate = today.format(formatter);
	String DateSplit = today.format(formatter2);
	//
	
	try (BufferedReader reader = request.getReader()) {
        while ((line = reader.readLine()) != null) {
            jsonString.append(line);
        }
    }
	JSONObject saveListData = new JSONObject(jsonString.toString());
	JSONArray DataList = null;
	
	String[] Category = {
			"Month", "DealCom", "OrderNum", "Seq", "MatCode", "MatCodeDes", "DelivOrdQty", "QtyUnit", "SalesUnitPrice",
			"TranCurr", "X_TranSalesAmt", "ExRateType", "ExRate", "X_LocalSalesAmt", "LocalCurr", "X_TotalAmt", 
			"Channel", "BizArea", "KeyValue", "TaxInvoiceDate"
			};
	try{
		String Export_Sql = "INSERT INTO sales_exsalesclosing (" +
			    "ClosingMonth, CustCode, DelivNoteNum, DelivNoteSeq, " +
			    "MatCode, MatDesc, DelivOrdQty, QtyUnit, SalesUnitPrice, TranCurr, " +
			    "TranSalesAmt, ExRateType, ExRate, LocalSalesAmt, LocalCurr, " +
			    "TotalAmt, SalesChannel, BizArea, KeyValue" +
			    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		String UpdateSql = "UPDATE sales_delrequestcmdline SET ClosingMonth = ?, SalesConfirmDate = ? WHERE DelivNoteNum = ? AND MatCode = ?";
		
		PreparedStatement Export_Pstmt = conn.prepareStatement(Export_Sql);
		PreparedStatement Up_Pstmt = conn.prepareStatement(UpdateSql);
		
		HashSet<String>Group = new HashSet<>();
		HashMap<String, Integer> SequenceTracker = new HashMap<>();
		
		for (String key : saveListData.keySet()) {
		    DataList = saveListData.getJSONArray(key);
		    System.out.println("Key: " + key + " - " + DataList.getJSONObject(0));
		    if(!Group.contains(key)){
				Group.add(key);
				SequenceTracker.put(key, 1);
			}
		    for(int i = 0 ; i < 20 ; i++){
		    	int DelivOrdQty = 0;
		    	Double SalesUnitPrice = 0.0;
		    	Double ExRate = 0.0;
		    	switch(i){
			    	case 10:
			    		System.out.println("10.1");
			    		DelivOrdQty = Integer.parseInt(DataList.getJSONObject(0).getString(Category[6]).replace(",",""));
			    		SalesUnitPrice = Double.parseDouble(DataList.getJSONObject(0).getString(Category[8]).replace(",",""));
			    		Export_Pstmt.setDouble(i + 1, DelivOrdQty * SalesUnitPrice);
			    		break;
			    	case 13:
			    		System.out.println("13.1");
			    		DelivOrdQty = Integer.parseInt(DataList.getJSONObject(0).getString(Category[6]).replace(",",""));
			    		SalesUnitPrice = Double.parseDouble(DataList.getJSONObject(0).getString(Category[8]).replace(",",""));
			    		ExRate = Double.parseDouble(DataList.getJSONObject(0).getString(Category[12]).replace(",",""));
			    		Export_Pstmt.setDouble(i + 1, DelivOrdQty * SalesUnitPrice * ExRate);
			    		break;
			    	case 15:
			    		System.out.println("15.1");
			    		DelivOrdQty = Integer.parseInt(DataList.getJSONObject(0).getString(Category[6]).replace(",",""));
			    		SalesUnitPrice = Double.parseDouble(DataList.getJSONObject(0).getString(Category[8]).replace(",",""));
			    		ExRate = Double.parseDouble(DataList.getJSONObject(0).getString(Category[12]).replace(",",""));
			    		Export_Pstmt.setDouble(i + 1, DelivOrdQty * SalesUnitPrice * ExRate);
			    		break;
			    	case 19:
			    		System.out.println("19.1");
			    		Up_Pstmt.setString(1, DataList.getJSONObject(0).getString(Category[0]));
			    		Up_Pstmt.setString(2, DataList.getJSONObject(0).getString(Category[19]));
			    		Up_Pstmt.setString(3, DataList.getJSONObject(0).getString(Category[2]));
			    		Up_Pstmt.setString(4, DataList.getJSONObject(0).getString(Category[4]));
			    		break;	
			    	default:
			    		System.out.println(i + ".1");
			    		Export_Pstmt.setString(i + 1, DataList.getJSONObject(0).getString(Category[i]));
			    		break;
		    	}
		    }
		    Up_Pstmt.executeUpdate();
		    Export_Pstmt.executeUpdate();
		}
	response.setContentType("application/json; charset=UTF-8");
	response.getWriter().write("{\"status\": \"Success\"}");
	}catch(Exception e){
		e.printStackTrace();
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"Error\"}");
	}
%>

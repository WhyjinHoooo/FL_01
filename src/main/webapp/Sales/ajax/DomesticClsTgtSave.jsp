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
			"LocalCurr", "X_TranSalesAmt", "ExRateType", "ExRate", "X_LocalSalesAmt", "X_LocalCurr", "TaxCode",
			"X_VAT", "X_TotalAmt","TaxInvoiceDate", "SalesChannel", "BizArea", "UserCom", "SalesClsOrder"
			};
	
	try{
		String Domestic_Sql = "INSERT INTO sales_dosalesclosing (" +
			    "ClosingMonth, TradingPartner, DelivNoteNum, DelivNoteSeq, " +
			    "MatCode, MatDesc, DelivOrdQty, QtyUnit, SalesUnitPrice, TranCurr, " +
			    "TranSalesAmt, ExRateType, ExRate, LocalSalesAmt, LocalCurr, TaxCode, " +
			    "VAT, TotalAmt, TaxInvoiceDate, SalesChannel, " +
			    "BizArea, ComCode, CreatPerson, CreatDate, KeyValue" +
			    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		String UpdateSql = "UPDATE sales_delrequestcmdline SET ClosingMonth = ?, ClosingNum = ?, SalesConfirmDate = ? WHERE DelivNoteNum = ? AND MatCode = ?";
		
		PreparedStatement Domestic_Pstmt = conn.prepareStatement(Domestic_Sql);
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
		    for(int i = 0 ; i < 26 ; i++){
		    	switch(i){
			    	case 8:
			    		Domestic_Pstmt.setDouble(i + 1, Double.parseDouble(DataList.getJSONObject(0).getString(Category[8]).replace(",","")));
			    		break;
			    	case 10:
			    		int DelivOrdQty = Integer.parseInt(DataList.getJSONObject(0).getString(Category[6]));
			    		double SalesUnitPrice = Double.parseDouble(DataList.getJSONObject(0).getString(Category[8]).replace(",",""));
			    		int TranSalesAmt = (int)Math.round(DelivOrdQty*SalesUnitPrice);
			    		Domestic_Pstmt.setInt(i + 1, TranSalesAmt);
			    		break;
			    	case 12:
			    		Domestic_Pstmt.setInt(i + 1, DataList.getJSONObject(0).getInt(Category[i]));
			    		break;
			    	case 13:
			    		DelivOrdQty = Integer.parseInt(DataList.getJSONObject(0).getString(Category[6]));
			    		SalesUnitPrice = Double.parseDouble(DataList.getJSONObject(0).getString(Category[8]).replace(",",""));
			    		TranSalesAmt = (int)Math.round(DelivOrdQty*SalesUnitPrice);
			    		int ExRate = DataList.getJSONObject(0).getInt(Category[12]);
			    		int LocalSalesAmt = TranSalesAmt* ExRate;
			    		Domestic_Pstmt.setInt(i + 1, LocalSalesAmt);
			    		break;
			    	case 14:
			    		Domestic_Pstmt.setString(i + 1, DataList.getJSONObject(0).getString(Category[9]));
			    		break;
			    	case 16:
			    		DelivOrdQty = Integer.parseInt(DataList.getJSONObject(0).getString(Category[6]));
			    		SalesUnitPrice = Double.parseDouble(DataList.getJSONObject(0).getString(Category[8]).replace(",",""));
			    		TranSalesAmt = (int)Math.round(DelivOrdQty*SalesUnitPrice);
			    		ExRate = DataList.getJSONObject(0).getInt(Category[12]);
			    		LocalSalesAmt = TranSalesAmt* ExRate;
			    		int VAT = (int)Math.round(LocalSalesAmt*0.1);
			    		Domestic_Pstmt.setInt(i + 1, VAT);
			    		break;
			    	case 17:
			    		DelivOrdQty = Integer.parseInt(DataList.getJSONObject(0).getString(Category[6]));
			    		SalesUnitPrice = Double.parseDouble(DataList.getJSONObject(0).getString(Category[8]).replace(",",""));
			    		TranSalesAmt = (int)Math.round(DelivOrdQty*SalesUnitPrice);
			    		ExRate = DataList.getJSONObject(0).getInt(Category[12]);
			    		LocalSalesAmt = TranSalesAmt* ExRate;
			    		VAT = (int)Math.round(LocalSalesAmt*0.1);
			    		Domestic_Pstmt.setInt(i + 1, LocalSalesAmt + VAT);
			    		break;
			    	case 22:
			    		Domestic_Pstmt.setString(i + 1, UserId);
			    		break;
			    	case 23:
			    		Domestic_Pstmt.setString(i + 1, todayDate);
			    		break;
			    	case 24:
			    		Domestic_Pstmt.setString(i + 1, key);
			    		break;
			    	case 25: /* 특수한 경우 */
			    		Up_Pstmt.setString(1, DataList.getJSONObject(0).getString(Category[0])+"월");
			    		Up_Pstmt.setInt(2, Integer.parseInt(DataList.getJSONObject(0).getString(Category[22])));
			    		Up_Pstmt.setString(3, DataList.getJSONObject(0).getString(Category[18]));
			    		Up_Pstmt.setString(4, DataList.getJSONObject(0).getString(Category[2]));
			    		Up_Pstmt.setString(5, DataList.getJSONObject(0).getString(Category[4]));
			    		break;
			    	default:
			    		Domestic_Pstmt.setString(i + 1, DataList.getJSONObject(0).getString(Category[i]));
			    		break;
		    	}
		    }
		    Up_Pstmt.executeUpdate();
	    	Domestic_Pstmt.executeUpdate();
		}
	response.setContentType("application/json; charset=UTF-8");
	response.getWriter().write("{\"status\": \"Success\"}");
	}catch(Exception e){
		e.printStackTrace();
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"Error\"}");
	}
%>

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
	Double SalePrice = 0.0; //판매단가
	int CounUnit = 0; // 수량 입력 단위
	int month = 0;
	String Formattedmonth = null;
	Double FXRate = 0.0;
	String LocCur = null;
	//
	
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
		System.out.println("rowData 길이 : " + rowData.length());
		//System.out.println("rowData(0) : " + rowData.getString(0));
		
		String ProductInfo = rowData.getString(0);
		String[] ProductInfoList = ProductInfo.split(",");
		//System.out.println("ProductInfoList : " + ProductInfoList[3]);
		for(String info : ProductInfoList){
			System.out.println("info : " + info);
			
		}
		
		String SaveSql = "INSERT INTO sales_sddata ("
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
			System.out.println("판매단가 : " + Info_Rs.getString("SalesUnitPrice")); // 판매 단가 - String 타입
			SalePrice = Double.parseDouble(Info_Rs.getString("SalesUnitPrice")); // 판매 단가 - Double 타입
			CounUnit = Integer.parseInt(rowData.getString(3)); // 수량 입력 단위
			
			for(int i = 6 ; i < rowData.length() ; i++){
				if(!rowData.getString(i).equals("") || rowData.getString(i) != null){
					month = i - 5;
					if(month < 10){
						Formattedmonth = String.format("%02d", month);
					} else{
						Formattedmonth = Integer.toString(month);
					}
					String Info_Sql02 = "SELECT * " +
						    "FROM project.sales_planexrate " +
						    "WHERE PlanVer = ? " +
						    "  AND TranCurr = ? " +
						    "  AND LEFT(PlanVer, 2) IN (?) " +
						    "  AND RIGHT(YearMonth, 2) IN (?) " +
						    "ORDER BY TranCurr DESC, YearMonth ASC";
					PreparedStatement Info_Pstmt02 = conn.prepareStatement(Info_Sql02);
					Info_Pstmt02.setString(1, rowData.getString(1));
					Info_Pstmt02.setString(2, ProductInfoList[3]);
					Info_Pstmt02.setString(3, rowData.getString(1).substring(0,2));
					Info_Pstmt02.setString(4, Formattedmonth);
					ResultSet Info_Rs02 = Info_Pstmt02.executeQuery();
					if(Info_Rs02.next()){
						FXRate = Double.parseDouble(Info_Rs02.getString("ExRate")); // 환율
						LocCur = Info_Rs02.getString("LocalCurr"); // 장부 통화
						
						Sava_Pstmt.setString(1, rowData.getString(1));
						Sava_Pstmt.setString(2, Formattedmonth);
						Sava_Pstmt.setString(3, rowData.getString(1));
						Sava_Pstmt.setString(4, rowData.getString(1));
						Sava_Pstmt.setString(5, rowData.getString(1));
						Sava_Pstmt.setString(6, rowData.getString(1));
						Sava_Pstmt.setString(7, rowData.getString(1));
						Sava_Pstmt.setString(8, rowData.getString(1));
						Sava_Pstmt.setString(9, rowData.getString(1));
						Sava_Pstmt.setString(10, rowData.getString(1));
						Sava_Pstmt.setString(11, rowData.getString(1));
						Sava_Pstmt.setString(12, rowData.getString(1));
						Sava_Pstmt.setString(13, rowData.getString(1));
						Sava_Pstmt.setString(14, rowData.getString(1));
						Sava_Pstmt.setString(15, rowData.getString(1));
						Sava_Pstmt.setString(16, rowData.getString(1));
						Sava_Pstmt.setString(17, rowData.getString(1));
						Sava_Pstmt.setString(18, rowData.getString(1));
						Sava_Pstmt.setString(19, rowData.getString(1));
						Sava_Pstmt.setString(20, rowData.getString(1));
						Sava_Pstmt.setString(21, rowData.getString(1));
						Sava_Pstmt.setString(22, rowData.getString(1));
						
						
					}
				}
			}
		}
		/* System.out.println("1 : " + rowData.getString(1));
		System.out.println("1 : " + ProductInfoList[0]);
		System.out.println("1 : " + rowData.getString(2));
		System.out.println("1 : " + ProductInfoList[3]); */
		
	}
%>

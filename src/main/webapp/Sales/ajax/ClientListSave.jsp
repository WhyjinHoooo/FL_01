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
	Double SalePrice = 0.0; //판매단가
	int CounUnit = 0; // 수량 입력 단위
	int month = 0;
	String Formattedmonth = null;
	Double FXRate = 0.0;
	String LocCur = null;
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
    
	System.out.println(saveListData);
	System.out.println(saveListData.length());
	System.out.println(saveListData.keySet());
	try{
		String PlanVersion = null;
	for(String key : saveListData.keySet()){
		System.out.println("key : " + key);
		JSONArray rowData = saveListData.getJSONArray(key);
		System.out.println("rowData : " + rowData);
		System.out.println("rowData 길이 : " + rowData.length());
		PlanVersion = rowData.getString(1);
		//System.out.println("rowData(0) : " + rowData.getString(0));
		
		String ProductInfo = rowData.getString(0);
		String[] ProductInfoList = ProductInfo.split(",");
		//System.out.println("ProductInfoList : " + ProductInfoList[3]);
		for(String info : ProductInfoList){
			System.out.println("info : " + info);
			
		}
		
		String SOS_Sql/* Sales OrderStasus Sql */ = "INSERT INTO sales_ordstatus (" +
                "TradingPartner, CustOrdNum, OrditemSeq,OrdReceiptDate, MatCode, MatDesc, " +
                "QtyUnit, SalesOrdQty, PlanDelivSumQty, DelivOrdSumQty, OrdQtyAdjust, " +
                "SalesResidQty, ExpectArrivDate, ArrivCustPlace, BizArea, ComCode, " +
                "CreatPerson, CreatDate, LastPerson, LastAdjustDate, KeyValue" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		PreparedStatement SOS_Pstmt = conn.prepareStatement(SOS_Sql);

		
		String SaveSql = "INSERT INTO sales_clientorder (" +
			    "OrdReceiptDate, CustOrdNum, OrditemSeq, TradingPartner, MatCode, MatDesc, " +
			    "QtyUnit, SalesOrdQty, ExpArrivDate, ArrivCustPlace, SalesOrdYN, TranSalesAmt, " +
			    "SalesUnitPrice, TranCurr, PlanExRate, LocalSalesAmt, LocalCurr, BizArea, " +
			    "ComCode, CreatPerson, CreatDate, LastPerson, LastAdjustDate, KeyValue" +
			    ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

 		PreparedStatement Sava_Pstmt = conn.prepareStatement(SaveSql);
		
		String Info_Sql01 = "SELECT * FROM sales_realprice WHERE MatCode = ? AND CustCode = ? AND SalesCurr = ?";
		PreparedStatement Info_Pstmt01 = conn.prepareStatement(Info_Sql01);
		Info_Pstmt01.setString(1, ProductInfoList[0]);
		Info_Pstmt01.setString(2, rowData.getString(2));
		Info_Pstmt01.setString(3, "USD");
		ResultSet Info_Rs = Info_Pstmt01.executeQuery();
		while(Info_Rs.next()){
				System.out.println("판매단가 : " + Info_Rs.getString("SalesUnitPrice")); // 판매 단가 - String 타입
				SalePrice = Double.parseDouble(Info_Rs.getString("SalesUnitPrice")); // 판매 단가 - Double 타입
				CounUnit = Integer.parseInt(rowData.getString(3)); // 수량 입력 단위
				System.out.println("판매단가 : " + SalePrice + ", 수량 입력 단위 : " + CounUnit);
						
				FXRate = 1350.0; // 환율
				LocCur = "KOR"; // 장부 통화
							
				Sava_Pstmt.setString(1, rowData.getString(1)); // 수주접수일자
				Sava_Pstmt.setString(2, rowData.getString(6)); // 고객주문번호
				Sava_Pstmt.setString(3, rowData.getString(7)); // 항번
				Sava_Pstmt.setString(4, rowData.getString(2)); // 거래처
				Sava_Pstmt.setString(5, ProductInfoList[0]); // 품번
				Sava_Pstmt.setString(6, ProductInfoList[1]); // 품명 
				Sava_Pstmt.setString(7, ProductInfoList[2]); // 수량단위
				
				int TotalCount = Integer.parseInt(rowData.getString(9)) * Integer.parseInt(rowData.getString(3));
				Sava_Pstmt.setInt(8, TotalCount); // 주문수량
				Sava_Pstmt.setString(9, rowData.getString(11)); // 회망도착일자
				Sava_Pstmt.setString(10, rowData.getString(10)); // 납품장소
				Sava_Pstmt.setString(11, "N"); // 납품계획수립여부
				Sava_Pstmt.setDouble(12, Math.round(SalePrice * TotalCount)); // 거래통화매출금액
				Sava_Pstmt.setDouble(13, SalePrice); // 판매단가
				Sava_Pstmt.setString(14, ProductInfoList[3]); // 거래통화
				Sava_Pstmt.setDouble(15, FXRate); // 계획환율
				Sava_Pstmt.setDouble(16, FXRate * Math.round(SalePrice * TotalCount)); // 장부통화매출금액
				Sava_Pstmt.setString(17, LocCur); // 장부통화
				Sava_Pstmt.setString(18, rowData.getString(5)); // 회계단위
				Sava_Pstmt.setString(19, rowData.getString(4)); // 회사
				Sava_Pstmt.setString(20, UserId); // 작성자
				Sava_Pstmt.setString(21, todayDate); // 생성일자
				Sava_Pstmt.setString(22, "아무개"); // 최종수정자
				Sava_Pstmt.setString(23, "0000-00-00"); // 최정수정일자
				Sava_Pstmt.setString(24, rowData.getString(6)+rowData.getString(2)+ProductInfoList[0]+rowData.getString(10)+rowData.getString(11).replace("-","")+rowData.getString(5)+rowData.getString(4)); // Key값
				Sava_Pstmt.executeUpdate();
							
				SOS_Pstmt.setString(1, rowData.getString(2)); // 거래처
				SOS_Pstmt.setString(2, rowData.getString(6)); // 고객주문번호
				SOS_Pstmt.setString(3, rowData.getString(7)); // 항번
 				SOS_Pstmt.setString(4, rowData.getString(1)); // 주문접수일자
				SOS_Pstmt.setString(5, ProductInfoList[0]); // 품번
				SOS_Pstmt.setString(6, ProductInfoList[1]); // 품명
				SOS_Pstmt.setString(7, ProductInfoList[2]); // 수량단위
				SOS_Pstmt.setInt(8, TotalCount); // 주문수량
				SOS_Pstmt.setInt(9, 0); // 납품계획수량
				SOS_Pstmt.setInt(10, 0); // 납품완료수량
				SOS_Pstmt.setInt(11, 0); // 주문수량조정
				SOS_Pstmt.setInt(12, TotalCount); // 주문잔량
				SOS_Pstmt.setString(13, rowData.getString(11)); // 납품희망일자
				SOS_Pstmt.setString(14, rowData.getString(10)); // 납품장소
				SOS_Pstmt.setString(15, rowData.getString(5)); // 회계단위
				SOS_Pstmt.setString(16, rowData.getString(4)); // 회사
				SOS_Pstmt.setString(17, UserId); // 작성자
				SOS_Pstmt.setString(18, todayDate); // 생성일자
				SOS_Pstmt.setString(19, "아무개"); // 최종수정자
				SOS_Pstmt.setString(20, "0000-00-00"); // 최종수정일자
				SOS_Pstmt.setString(21, rowData.getString(2)+rowData.getString(6)+rowData.getString(7)+rowData.getString(4)); // 키값
				SOS_Pstmt.executeUpdate();
			}
		}
	
	response.setContentType("application/json; charset=UTF-8");
    response.getWriter().write("{\"status\": \"Success\"}");
	}catch(Exception e){
		e.printStackTrace();
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"Error\"}");
	}
%>

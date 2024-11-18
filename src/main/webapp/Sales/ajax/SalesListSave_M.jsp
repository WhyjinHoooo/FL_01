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
	int day = 0;
	String FormattedDay = null;
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
	System.out.println("MM");
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
			
			for(int i = 8 ; i < rowData.length() ; i++){
				if(rowData.getString(i) != null && !rowData.getString(i).trim().isEmpty()){
					day = i - 7;
					if(day < 10){
						FormattedDay = String.format("%02d", day);
					} else{
						FormattedDay = Integer.toString(day);
					}					
					String Info_Sql02 = "SELECT * " +
						    "FROM project.sales_planexrate " +
						    "WHERE PlanVer = ? " +
						    "  AND TranCurr = ? " +
						    "  AND LEFT(PlanVer, 2) IN (?) " +
						    "  AND YearMonth = ? " +
						    "ORDER BY TranCurr DESC, YearMonth ASC";
					PreparedStatement Info_Pstmt02 = conn.prepareStatement(Info_Sql02);
					Info_Pstmt02.setString(1, rowData.getString(1));
					Info_Pstmt02.setString(2, ProductInfoList[3]);
					Info_Pstmt02.setString(3, rowData.getString(1).substring(0,2));
					Info_Pstmt02.setString(4, rowData.getString(4).replace("월",""));
					ResultSet Info_Rs02 = Info_Pstmt02.executeQuery();
					if(Info_Rs02.next()){
						FXRate = Double.parseDouble(Info_Rs02.getString("ExRate")); // 환율
						LocCur = Info_Rs02.getString("LocalCurr"); // 장부 통화
						
						Sava_Pstmt.setString(1, rowData.getString(1)); // 계획버전
						Sava_Pstmt.setString(2, rowData.getString(4).substring(0,5)); // 계획년도
						Sava_Pstmt.setString(3, rowData.getString(4).substring(5,7)); // 계획월
						Sava_Pstmt.setString(4, rowData.getString(2)); // 거래처
						Sava_Pstmt.setString(5, ProductInfoList[0]); // 품번
						Sava_Pstmt.setString(6, ProductInfoList[1]); // 품명 
						
						String ArriveDate = rowData.getString(4).replace('.','-').replace('월','-')+"-" + FormattedDay;
						
						Sava_Pstmt.setString(7, ArriveDate); // 회망도착일자
						
						int TotalCount = Integer.parseInt(rowData.getString(i)) * Integer.parseInt(rowData.getString(3));
						Sava_Pstmt.setInt(8, TotalCount); // 매출수량
						Sava_Pstmt.setString(9, ProductInfoList[2]); // 단위
						Sava_Pstmt.setDouble(10, Math.round(SalePrice * TotalCount)); // 거래통화매출금액
						Sava_Pstmt.setDouble(11, SalePrice); // 판매단가
						Sava_Pstmt.setString(12, ProductInfoList[3]); // 거래통화
						Sava_Pstmt.setDouble(13, FXRate); // 계획환율
						Sava_Pstmt.setDouble(14, Math.round(FXRate * SalePrice * TotalCount)); // 장부통화매출금액
						Sava_Pstmt.setString(15, LocCur); // 장부통화
						Sava_Pstmt.setString(16, rowData.getString(5)); // 회계단위
						Sava_Pstmt.setString(17, rowData.getString(6)); // 회사
						Sava_Pstmt.setString(18, UserId); // 입력자
						Sava_Pstmt.setString(19, todayDate); // 입력일자
						Sava_Pstmt.setString(20, "EMPTY"); // 최종수정자
						Sava_Pstmt.setString(21, "0000-00-00"); // 최종수정일자
						Sava_Pstmt.setString(22, rowData.getString(1)+rowData.getString(4).substring(0,5)+rowData.getString(4).substring(5,7)+rowData.getString(2)+ProductInfoList[0]+ArriveDate.replace("-","")+rowData.getString(5)+rowData.getString(6)); // Key값
						Sava_Pstmt.executeUpdate();
					}
				}
			}
		}
	}
	
// 	String UpDateSql = "UPDATE sales_planversion SET XO = ? WHERE PlanVer = ?";
// 	PreparedStatement UpDatePstmt = conn.prepareStatement(UpDateSql);
// 	UpDatePstmt.setString(1, "O");
// 	UpDatePstmt.setString(2, PlanVersion);
// 	UpDatePstmt.executeUpdate();
	
	response.setContentType("application/json; charset=UTF-8");
    response.getWriter().write("{\"status\": \"Success\"}");
	}catch(SQLException e){
		e.printStackTrace();
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"Error\"}");
	}
%>

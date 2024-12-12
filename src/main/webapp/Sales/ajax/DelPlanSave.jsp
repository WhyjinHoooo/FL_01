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
	JSONObject DataList = null;
	System.out.println("saveListData : " + saveListData);
	System.out.println("saveListData.length() : " + saveListData.length());
	System.out.println("saveListData.keySet() : " + saveListData.keySet());
	try{
		for(String key : saveListData.keySet()){
			System.out.println("key : " + key);
			DataList = saveListData.getJSONObject(key);
			System.out.println("DataList : " + DataList);
		}
		JSONArray headDataList = DataList.getJSONArray("HeadDataList");
		JSONArray childList = DataList.getJSONArray("ChildList");
		System.out.println("HeadDataList: " + headDataList);
		System.out.println("childList.getJSONArray(0): " + childList.length());
		System.out.println("childList.getJSONArray(0): " + childList.getJSONArray(0));
		System.out.println("childList.getJSONArray(1): " + childList.getJSONArray(1));
		
		String CenterInfoSearch_Sql = "SELECT * FROM sales_ordstatus WHERE TradingPartner = ? AND CustOrdNum = ? AND MatCode = ?";
		PreparedStatement CenterInfoSearch_Pstmt = conn.prepareStatement(CenterInfoSearch_Sql);
		ResultSet CenterInfoSearch_Rs = null;
		
		String UpdateSql = null;
		PreparedStatement UpdatePstmt = null;;
		
		String HeadSave_Sql = "INSERT INTO sales_delplanheader (" +
                "SalesOrdNum, TradingPartner, DelivPlanDate, MatitemNum, SalesOrdSumQty, " +
                "ArrivCustPlace, BizArea, ComCode, KeyValue" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		String LineSave_Sql = "INSERT INTO sales_delplanline (" +
                "DelivPlanDate, SalesOrdNum, SalesOrdSeq, MatCode, MatDesc, " +
                "QtyUnit, SalesOrdQty, SalesChannel, TradingPartner, CustOrdNum, " +
                "ArrivCustPlace, BizArea, ComCode, CreatPerson, CreatDate, " +
                "LastPerson, LastAdjustDate, KeyValue" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		String SearchSql = "SELECT * FROM sales_delplanheader WHERE SalesOrdNum = ?";
		PreparedStatement Search_Pstmt = conn.prepareStatement(SearchSql);
		Search_Pstmt.setString(1, headDataList.getString(0));
		ResultSet rs = Search_Pstmt.executeQuery();
		
		PreparedStatement Head_Pstmt = conn.prepareStatement(HeadSave_Sql);
		PreparedStatement Line_Pstmt = conn.prepareStatement(LineSave_Sql);
		
		if(!rs.next()){
			Head_Pstmt.setString(1, headDataList.getString(0)); // 납품계획번호
 			Head_Pstmt.setString(2, headDataList.getString(1)); // 거래처
 			Head_Pstmt.setString(3, headDataList.getString(2)); // 반출예정일자
			Head_Pstmt.setInt(4, headDataList.getInt(3)); // 품번갯수
			Head_Pstmt.setString(7, headDataList.getString(4)); // 회계단위
 			Head_Pstmt.setString(8, headDataList.getString(5)); // 회사
 			Head_Pstmt.setString(9, headDataList.getString(0) + headDataList.getString(5)); // Key값
			
 			int TotalCount = 0;
		
			for(int i = 0 ; i < childList.length() ; i++){
				
				String ArrivePlace = childList.getJSONArray(i).getString(5);
				if(i == 0){
					firstValue = ArrivePlace;
				} else{
					if(!ArrivePlace.equals(firstValue)){
						allSame = false;
					}
				}
				
				Line_Pstmt.setString(1, headDataList.getString(2)); // 반출예정일자
 				Line_Pstmt.setString(2, headDataList.getString(0)); // 납품계획번호
				Line_Pstmt.setString(3, String.format("%02d", Integer.parseInt(childList.getJSONArray(i).getString(0)))); // 항번
 				Line_Pstmt.setString(4, childList.getJSONArray(i).getString(2)); // 품번
 				Line_Pstmt.setString(5, childList.getJSONArray(i).getString(3)); // 품명
 				Line_Pstmt.setString(6, childList.getJSONArray(i).getString(4)); // 수량단위
 				Line_Pstmt.setString(7, childList.getJSONArray(i).getString(6)); // 납품계획수량
				
 				TotalCount += Integer.parseInt(childList.getJSONArray(i).getString(6));
				
 				Line_Pstmt.setString(8, childList.getJSONArray(i).getString(7).substring(0, 3)); // 판매경로
 				Line_Pstmt.setString(9, headDataList.getString(1)); // 거래처
 				Line_Pstmt.setString(10, childList.getJSONArray(i).getString(1)); // 고객주문번호
 				Line_Pstmt.setString(11, childList.getJSONArray(i).getString(5)); // 납품장소 
 				Line_Pstmt.setString(12, headDataList.getString(4)); // 회계단위
 				Line_Pstmt.setString(13, headDataList.getString(5)); // 회사
 				Line_Pstmt.setString(14, UserId); // 작성자
 				Line_Pstmt.setString(15, todayDate); // 생성일자
 				Line_Pstmt.setString(16, "아무개"); // 최종수정자
 				Line_Pstmt.setString(17, "9999-12-31"); // 최종수정일자
 				Line_Pstmt.setString(18, headDataList.getString(0) + String.format("%02d", Integer.parseInt(childList.getJSONArray(i).getString(0))) + headDataList.getString(5)); // Key값
 				Line_Pstmt.executeUpdate();
 				
 				CenterInfoSearch_Pstmt.setString(1, headDataList.getString(1));
 				CenterInfoSearch_Pstmt.setString(2, childList.getJSONArray(i).getString(1));
 				CenterInfoSearch_Pstmt.setString(3, childList.getJSONArray(i).getString(2));
 				CenterInfoSearch_Rs = CenterInfoSearch_Pstmt.executeQuery();
 				if(CenterInfoSearch_Rs.next()){
 					int SavedValue = Integer.parseInt(CenterInfoSearch_Rs.getString("PlanDelivSumQty"));
 					int OriginalValue = Integer.parseInt(CenterInfoSearch_Rs.getString("SalesOrdQty"));
 					if(SavedValue > 0){
 						SavedValue += Integer.parseInt(childList.getJSONArray(i).getString(6));
 						OriginalValue -= SavedValue;
 						UpdateSql = "UPDATE sales_ordstatus SET PlanDelivSumQty = ?, SalesResidQty = ? WHERE TradingPartner = ? AND CustOrdNum = ? AND MatCode = ?";
 						UpdatePstmt = conn.prepareStatement(UpdateSql);
 						UpdatePstmt.setInt(1, SavedValue);
 						UpdatePstmt.setInt(2, OriginalValue);
 						UpdatePstmt.setString(3, headDataList.getString(1));
 						UpdatePstmt.setString(4, childList.getJSONArray(i).getString(1));
 						UpdatePstmt.setString(5, childList.getJSONArray(i).getString(2));
 					} else{
 						SavedValue = Integer.parseInt(childList.getJSONArray(i).getString(6));
 						OriginalValue -= SavedValue;
 						UpdateSql = "UPDATE sales_ordstatus SET PlanDelivSumQty = ?, SalesResidQty = ? WHERE TradingPartner = ? AND CustOrdNum = ? AND MatCode = ?";
 						UpdatePstmt = conn.prepareStatement(UpdateSql);
 						UpdatePstmt.setInt(1, SavedValue);
 						UpdatePstmt.setInt(2, OriginalValue);
 						UpdatePstmt.setString(3, headDataList.getString(1));
 						UpdatePstmt.setString(4, childList.getJSONArray(i).getString(1));
 						UpdatePstmt.setString(5, childList.getJSONArray(i).getString(2));
 					}
 					UpdatePstmt.executeUpdate();
 				}
			}
			Head_Pstmt.setInt(5, TotalCount);
			if(allSame){
	  			Head_Pstmt.setString(6, firstValue); // 납품장소
			} else{
				Head_Pstmt.setString(6, "다름"); // 납품장소
			}
			Head_Pstmt.executeUpdate();
		}
	response.setContentType("application/json; charset=UTF-8");
	response.getWriter().write("{\"status\": \"Success\"}");
	}catch(SQLException e){
		e.printStackTrace();
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"Error\"}");
	}
%>

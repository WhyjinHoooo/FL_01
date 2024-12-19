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
	JSONObject DataList = null;
	try{
		for(String key : saveListData.keySet()){
			DataList = saveListData.getJSONObject(key);
		}
		JSONArray headDataList = DataList.getJSONArray("HeadDataList");
		JSONArray childList = DataList.getJSONArray("ChildList");
		
		HashSet<String>Group = new HashSet<>();
		 HashMap<String, Integer> SequenceTracker = new HashMap<>();
		
		for(int i = 0 ; i < childList.length() ; i++){
			String key = childList.getJSONArray(i).getString(3);
			System.out.println("key : " + key);
			if(!Group.contains(key)){
				Group.add(key);
				SequenceTracker.put(key, 1);
			}
		}
		System.out.println(Group);
		
		String UpdateSql = null;
		PreparedStatement UpdatePstmt = null;;
		
		String HeadSave_Sql = "INSERT INTO sales_delrequestcmdheader (" +
                "DelivNoteNum, DispatureDate, TradingPartner, MatitemNum, DelivOrdSumQty, " +
                "BizArea, ComCode, KeyValue" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		
		String LineSave_Sql = "INSERT INTO sales_delrequestcmdline (" +
                "DispatureDate, DelivNoteNum, DelivNoteSeq, MatCode, MatDesc, " +
                "DelivOrdQty, QtyUnit, TransMean, DelivPlace, ArrivCustPlace, TradingPartner, " +
                "SalesOrdNum, SalesChannel, BizArea, ComCode, CreatPerson," +
                "CreatDate, LastPerson, LastAdjustDate, KeyValue" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		PreparedStatement Head_Pstmt = conn.prepareStatement(HeadSave_Sql);
		PreparedStatement Line_Pstmt = conn.prepareStatement(LineSave_Sql);
		
		Head_Pstmt.setString(1, headDataList.getString(0)); // 납품번호
 		Head_Pstmt.setString(2, headDataList.getString(1)); // 반출일자
 		Head_Pstmt.setString(3, headDataList.getString(2)); // 거래처
		Head_Pstmt.setInt(4, Group.size()); // 품번갯수
		Head_Pstmt.setInt(5, headDataList.getInt(4)); // 납품총수량
 		Head_Pstmt.setString(6, headDataList.getString(5)); // 회계단위
 		Head_Pstmt.setString(7, headDataList.getString(6)); // 회사
 		Head_Pstmt.setString(8, headDataList.getString(7)); // 키값
		
		for(int i = 0 ; i < childList.length() ; i++){
			String key = childList.getJSONArray(i).getString(3);
			int Seq = SequenceTracker.get(key);
			SequenceTracker.put(key, Seq+1);
			
			Line_Pstmt.setString(1, childList.getJSONArray(i).getString(0)); // 반출일자
 			Line_Pstmt.setString(2, childList.getJSONArray(i).getString(1)); // 납품번호
			Line_Pstmt.setString(3, /* Seq */childList.getJSONArray(i).getString(2)); // 항번
 			Line_Pstmt.setString(4, childList.getJSONArray(i).getString(3)); // 품번
 			Line_Pstmt.setString(5, childList.getJSONArray(i).getString(4)); // 품명
 			Line_Pstmt.setString(6, childList.getJSONArray(i).getString(5)); // 납품수량
 			Line_Pstmt.setString(7, childList.getJSONArray(i).getString(6)); // 수량단위
 			Line_Pstmt.setString(8, childList.getJSONArray(i).getString(7)); // 운송수단
 			Line_Pstmt.setString(9, childList.getJSONArray(i).getString(8)); // 인도장소
 			Line_Pstmt.setString(10, childList.getJSONArray(i).getString(12)); // 납품장소
 			Line_Pstmt.setString(11, childList.getJSONArray(i).getString(9)); // 거래처
 			Line_Pstmt.setString(12, childList.getJSONArray(i).getString(10)); // 납품계획번호 
 			Line_Pstmt.setString(13, childList.getJSONArray(i).getString(11)); // 판매경로
 			
 			Line_Pstmt.setString(14, childList.getJSONArray(i).getString(13)); // 회계단위
 			Line_Pstmt.setString(15, childList.getJSONArray(i).getString(14)); // 회사
 			Line_Pstmt.setString(16, UserId); // 작성자
 			Line_Pstmt.setString(17, todayDate); // 생성일자
 			Line_Pstmt.setString(18, "아무개"); // 최종수정자
 			Line_Pstmt.setString(19, "0000-00-00"); // 최종수정일자
 			Line_Pstmt.setString(20, childList.getJSONArray(i).getString(1) + String.format("%02d", Integer.parseInt(childList.getJSONArray(i).getString(2))) + childList.getJSONArray(i).getString(14)); // 키값
 			Line_Pstmt.executeUpdate();
		}
		Head_Pstmt.executeUpdate();
	response.setContentType("application/json; charset=UTF-8");
	response.getWriter().write("{\"status\": \"Success\"}");
	}catch(SQLException e){
		e.printStackTrace();
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"Error\"}");
	}
%>

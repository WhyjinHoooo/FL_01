<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../mydbcon.jsp" %>
<%

	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
		LocalDateTime today = LocalDateTime.now();
		DateTimeFormatter DateFormat= DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String PODate = today.format(DateFormat);
		JSONArray dataToSend = new JSONArray(jsonString.toString());
		System.out.println(dataToSend);
		System.out.println(dataToSend.length());
		for (int i = 1; i < dataToSend.length(); i++) {
		    JSONArray DataList = dataToSend.getJSONArray(i);
		    JSONArray HeaderList = dataToSend.getJSONArray(0);

		    String POsql = "INSERT INTO request_ord VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		    PreparedStatement POpstmt = conn.prepareStatement(POsql);

		    // 데이터 매핑
		    POpstmt.setString(1, DataList.getString(0));  // 발주번호
		    POpstmt.setString(2, DataList.getString(1));  // PO항번
		    POpstmt.setString(3, DataList.getString(2));  // Material
		    POpstmt.setString(4, DataList.getString(3));  // Material Description
		    POpstmt.setString(5, DataList.getString(4));  // 재고유형
		    POpstmt.setString(6, DataList.getString(5));  // 발주수량
		    POpstmt.setString(7, DataList.getString(6));  // 단위
		    POpstmt.setString(8, DataList.getString(7));  // 단위당단가
		    POpstmt.setString(9, DataList.getString(8));  // 구매금액
		    POpstmt.setString(10, DataList.getString(9)); // 거래통화
		    POpstmt.setString(11, DataList.getString(10).substring(0,8)); // 거래처
		    POpstmt.setString(12, DataList.getString(10).substring(9,13)); // 거래처명 (데이터에 없음)
		    POpstmt.setString(13, DataList.getString(11)); // 납품요청일자
		    POpstmt.setString(14, DataList.getString(12).substring(0,5)); // 납품창고
		    POpstmt.setString(15, DataList.getString(12).substring(6,14)); // 납품창고명 (데이터에 없음)
		    POpstmt.setString(16, "Y"); // IQC여부 (요청에 따라 'Y'로 설정)
		    POpstmt.setString(17, "0"); // 납품차수 (요청에 따라 '0'으로 설정)
		    POpstmt.setString(18, "0"); // 납품총수량 (요청에 따라 '0'으로 설정)
		    POpstmt.setString(19, DataList.getString(5)); // PO잔량 (발주수량과 동일)
		    POpstmt.setString(20, HeaderList.getString(3)); // 구매그룹
		    POpstmt.setString(21, HeaderList.getString(4)); // 구매담당자
		    POpstmt.setString(22, HeaderList.getString(1).split("\\(")[0]); // 공장
		    POpstmt.setString(23, HeaderList.getString(0)); // 회사
		    POpstmt.setString(24, DataList.getString(0).substring(2, 10)); // 발주일자
		    POpstmt.setString(25, HeaderList.getString(4)); // 등록자
		    POpstmt.setString(26, DataList.getString(0) + DataList.getString(1) + HeaderList.getString(1).split("\\(")[0]);
		    POpstmt.executeUpdate();
		}

		JSONObject Result = new JSONObject();
		Result.put("status", "Success");
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
	}catch(Exception e){
		JSONObject Result = new JSONObject();
		Result.put("status", "Fail");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(Result.toString());
		e.printStackTrace();
	}
%>
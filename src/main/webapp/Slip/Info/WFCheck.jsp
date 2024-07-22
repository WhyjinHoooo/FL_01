<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../mydbcon.jsp" %>
<%
	BufferedReader reader = request.getReader();
	StringBuilder sb = new StringBuilder();
	String line;
	JSONObject jsonResponse = new JSONObject();
	while((line = reader.readLine()) != null){
		sb.append(line);
	}
	JSONObject obj = new JSONObject();
	/* 
	ajax에서 전달한 데이터를 BufferedReader reader에 받아온다.
	그리고 reader.readLine()을 한 줄씩 읽으면서 line변수에 저장해서, 해당 값이 null인지 점검
	그렇게 해서, null값이 아니면 StringBuilder sb에 한 줄씩 저장
	*/
	String jsonData = sb.toString();
	JSONParser parser = new JSONParser();
	JSONObject ApprovalData = (JSONObject) parser.parse(jsonData); // DecPatPath.jsp에서 받은 list IntegratedList
	
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy MM dd HH:mm:ss");
	String todayDate = today.format(formatter);

	String SlipCode = (String)ApprovalData.get("SlipNo");
	String SlipType = SlipCode.substring(0, 3);
	String UserId = (String)ApprovalData.get("User");
	String UserBizArea = (String)ApprovalData.get("UserBizArea");
	String USerCoCt = (String)ApprovalData.get("TargetDepartCd");
	String UserComCode = (String)ApprovalData.get("UserDepart");
	String briefs = (String)ApprovalData.get("briefs");
	String TableKeyIndex = UserComCode + SlipCode;
	
	System.out.println(SlipCode);
	System.out.println(SlipType);
	System.out.println(UserId);
	System.out.println(UserBizArea);
	System.out.println(USerCoCt);
	System.out.println(UserComCode);
	System.out.println(briefs);
	/* 
	1st Success
	FIG20240718S0001 : 전표번호
	FIG : 전표유형
	2024060002 :전표 입력자
	BA101 : 전표입력 BA
	A1001 : 전표입력 부서
	E1000 : 회사
	asdasdasdasd : 적요
	*/
	try{
		String WFCH_Sql = "SELECT * FROM workflow WHERE DocNum =   ? AND DocType = ? AND BizArea = ? AND DocInputDepart = ? AND InputPerson = ? AND ComCode = ?";
		PreparedStatement WFCH_Pstmt = conn.prepareStatement(WFCH_Sql);
		WFCH_Pstmt.setString(1, SlipCode); 
        WFCH_Pstmt.setString(2, SlipType); 
        WFCH_Pstmt.setString(3, UserBizArea); 
        WFCH_Pstmt.setString(4, USerCoCt); 
        WFCH_Pstmt.setString(5, UserId); 
        WFCH_Pstmt.setString(6, UserComCode); 
		
		ResultSet WFCH_Rs = WFCH_Pstmt.executeQuery();
		
		if (WFCH_Rs.next()) { // 커서를 이동
	        System.out.println("Success");
	        obj.put("result", "Success");
	    } else {
	        System.out.println("Fail");
	        obj.put("result", "Fail");
	    }
		response.setContentType("application/json");
		PrintWriter output = response.getWriter();
		output.write(obj.toString());
		output.flush();
		output.close();
		
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
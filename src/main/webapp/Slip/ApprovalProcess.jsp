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
	
	String SlipCode = null;
	String UserId = null;
	String UserBizArea = null;
	String USerCoCt = null;
	String UserComCode = null;
	String SlipType = null;
	String briefs = null;
	String TableKeyIndex = null;
	try{
	if(ApprovalData != null){
		System.out.println("1st Success");

		SlipCode = (String)ApprovalData.get("SlipNo");
		SlipType = SlipCode.substring(0, 3);
		UserId = (String)ApprovalData.get("User");
		UserBizArea = (String)ApprovalData.get("UserBizArea");
		USerCoCt = (String)ApprovalData.get("TargetDepartCd");
		UserComCode = (String)ApprovalData.get("UserDepart");
		briefs = (String)ApprovalData.get("briefs");
		TableKeyIndex = UserComCode + SlipCode;
		
		/* 
		System.out.println(SlipCode);
		System.out.println(SlipType);
		System.out.println(UserId);
		System.out.println(UserBizArea);
		System.out.println(USerCoCt);
		System.out.println(UserComCode);
		System.out.println(briefs);
		1st Success
		FIG20240718S0001 : 전펴번호
		FIG : 전표유형
		2024060002 :전표 입력자
		BA101 : 전표입력 BA
		A1001 : 전표입력 부서
		E1000 : 회사
		asdasdasdasd : 적요
		*/
		
		String WFCH_Sql = "SELECT COUNT(ResponsePerson) as Total FROM workflow WHERE DocNum = ? AND DocType = ? AND BizArea = ? AND DocInputDepart = ? AND InputPerson = ? AND ComCode = ?";
		PreparedStatement WFCH_Pstmt = conn.prepareStatement(WFCH_Sql);
		WFCH_Pstmt.setString(1, "SlipCode");
		WFCH_Pstmt.setString(2, "SlipType");
		WFCH_Pstmt.setString(3, "UserBizArea");
		WFCH_Pstmt.setString(4, "USerCoCt");
		WFCH_Pstmt.setString(5, "UserId");
		WFCH_Pstmt.setString(6, "UserComCode");
		
		ResultSet WFCH_Rs = WFCH_Pstmt.executeQuery();
		int TotalPerson = WFCH_Rs.getInt("Total");
		System.out.println("WorkFlow 개수 : " + TotalPerson);
		if(TotalPerson > 0){
			String DWFH_In_Sql = "INSERT INTO docworkflowhead ("
				+ "`DocNum`,"
				+ "`DocType`,"
				+ "`BizArea`,"
				+ "`DocInputDepart`,"
				+ "`InputPerson`,"
				+ "`DocDescrip`,"
				+ "`SubmitTime`,"
				+ "`CompleteTime`,"
				+ "`WFStatus`,"
				+ "`WFStep`,"
				+ "`ElapsedHour`,"
				+ "`ComCode`,"
				+ "`TableKeyIndex`"
				+ ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement DWFH_In_Pstmt = conn.prepareStatement(DWFH_In_Sql);
			DWFH_In_Pstmt.setString(1, "SlipCode");
			DWFH_In_Pstmt.setString(2, "SlipType");
			DWFH_In_Pstmt.setString(3, "UserBizArea");
			DWFH_In_Pstmt.setString(4, "USerCoCt");
			DWFH_In_Pstmt.setString(5, "UserId");
			DWFH_In_Pstmt.setString(6, "briefs");
			DWFH_In_Pstmt.setString(7, "todayDate");
			DWFH_In_Pstmt.setString(8, "");
			DWFH_In_Pstmt.setString(9, "B");
			DWFH_In_Pstmt.setInt(10, 1);
			DWFH_In_Pstmt.setInt(11, 0);
			DWFH_In_Pstmt.setString(12, "UserComCode");
			DWFH_In_Pstmt.setString(13, "TableKeyIndex");
			
			DWFH_In_Pstmt.executeUpdate();
			
			for(int i = 0 ; i < TotalPerson ; i++){
				
			}
			String DWFL_Sql = "INSERT INTO docworkflowline ("
					+ "`DocNum`,"
					+ "`WFStep`,"
					+ "`WFType`,"
					+ "`ResponsePerson`,"
					+ "`RespPersonName`,"
					+ "`RespOffice`,"
					+ "`RepsDepart`,"
					+ "`WFResult`,"
					+ "`DocReviewOpinion`,"
					+ "`ReviewTime`,"
					+ "`ElapsedHour1`,"
					+ "`ComCode`,"
					+ "`Index`"
					+ ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement DWFL_In_Pstmt = conn.prepareStatement(DWFL_Sql);
		}
	}
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
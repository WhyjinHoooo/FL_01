<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../mydbcon.jsp" %>
<%
	BufferedReader reader = null;
	StringBuilder sb = new StringBuilder();
	try{
		reader = request.getReader();
		String line;
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
		JSONObject OptionData = (JSONObject) parser.parse(jsonData);
		
		String OP_ComCode = (String)OptionData.get("UserComCode");
		String OP_BA = (String)OptionData.get("UserBizArea"); // 공백, 전표입룍 BA
		String OP_COCT = (String)OptionData.get("UserDepartCd"); // 공백, 전표입력부서
		String OP_Inputer = (String)OptionData.get("InputerId"); // 공백, 전표 입력자
		
		String OP_Approver = (String)OptionData.get("ApproverId"); // 공백, 결재 합의자
		
		String OP_From = (String)OptionData.get("TimeStamp From"); // 오늘 날짜
		String OP_End = (String)OptionData.get("TimeStamp To"); // 오늘 날짜
		String OP_State = (String)OptionData.get("UnSlipState"); // A
		
		String sql = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String DocNum = null;
		int C_Sum = 0;
		int D_Sum = 0;
		
		JSONObject josnobject = new JSONObject();
		
		 if (OP_Approver != null && !OP_Approver.isEmpty()) {
			String DocSearch_Sql = "SELECT * FROM docworkflowline WHERE ResponsePerson = '" + OP_Approver + "'";
			PreparedStatement DocSearch_Pstmt = conn.prepareStatement(DocSearch_Sql);
			ResultSet DocSearch_Rs = DocSearch_Pstmt.executeQuery();
			while(DocSearch_Rs.next()){
				DocNum = DocSearch_Rs.getString("DocNum");
				
				String SqlVer01 = "SELECT " +
					      "    DATE(SubmitTime) AS DateOnly, " +
					      "    DocNum, " +
					      "    BizArea, " +
					      "    DocInputDepart, " +
					      "    InputPerson, " +
					      "    DocDescrip, " +
					      "    WFStatus, " +
					      "    WFStep, " +
					      "    ElapsedHour, " +
					      "    DocType " +
					      "FROM " +
					      "    docworkflowhead " +
					      "WHERE " +
					      "    DocNum = '" + DocNum + "' " +
					      "    AND DATE(SubmitTime) >= '" + OP_From + "' " +
					      "    AND DATE(SubmitTime) <= '" + OP_End + "' " +
					      "    AND WFStatus = '" + OP_State + "'";

				PreparedStatement PstmtVer01 = conn.prepareStatement(SqlVer01);
				ResultSet RsVer01 = PstmtVer01.executeQuery();
				
				while(RsVer01.next()){
					josnobject.put("Date", rs.getString("DateOnly"));
					josnobject.put("DocCode", rs.getString("DocNum"));
					josnobject.put("Script", rs.getString("DocDescrip"));
					josnobject.put("BA", rs.getString("BizArea"));
					josnobject.put("CoCt", rs.getString("DocInputDepart"));
					josnobject.put("Inputer", rs.getString("InputPerson"));
					josnobject.put("Status", rs.getString("WFStatus"));
					josnobject.put("Step", rs.getString("WFStep"));
					josnobject.put("Time", rs.getString("ElapsedHour"));
					josnobject.put("Type", rs.getString("DocType"));
					
				}
			}
			
		}
		
		
	}catch(Exception e){
		e.printStackTrace();
	}
%>
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
		String OP_BA = (String)OptionData.get("UserBizArea");
		String OP_COCT = (String)OptionData.get("UserDepartCd");
		String OP_Inputer = (String)OptionData.get("InputerId");
		String OP_Approver = (String)OptionData.get("ApproverId");
		String OP_From = (String)OptionData.get("TimeStamp From");
		String OP_End = (String)OptionData.get("TimeStamp To");
		String OP_State = (String)OptionData.get("UnSlipState");
		String OP_Type = (String)OptionData.get("SlipType");
		
	}catch(Exception e){
		e.printStackTrace();
	}
	
	
	
	
	
%>
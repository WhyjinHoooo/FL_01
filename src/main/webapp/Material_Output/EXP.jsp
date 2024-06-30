<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../mydbcon.jsp" %>
<%
	String Count = request.getParameter("count"); // 새로 저장하는 출고 수량 1
	String Material = request.getParameter("matCode"); // 출고하는 자재 코드 010101-00001
	String Storage = request.getParameter("Storage"); // 출고 창고 testmk1
	String InputStorage = request.getParameter("Input"); // IR일 때, 입고 창고
	String movType = request.getParameter("giir").substring(0, 2); // Movement Type 종류 GI
	String ComCode = request.getParameter("ComPany"); // E2000
	String PlantCode = request.getParameter("Plant"); // 입고할 plant 코드
	String OutPlant = request.getParameter("OutPlantCd");
	String InputComCode = request.getParameter("InputComCd");
	
	LocalDateTime now = LocalDateTime.now();
	String YYMM = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
	
	System.out.println("YYMM : " + YYMM);
	System.out.println("전달받은 수량 : " + Count);
	System.out.println("자재코드 : " + Material);
	System.out.println("MoveCode : " + movType);
	System.out.println("출고 Plant 코드 : " + OutPlant);
	System.out.println("출고 Plant의 Company 코드 : " + ComCode);
	System.out.println("출고 창고 코드 : " + Storage);
	System.out.println("------------------------------------");
	System.out.println("입고 Plant 코드 : " + PlantCode);
	System.out.println("입고할 창고의 Company 코드 : " + InputComCode);
	System.out.println("입고할 창고 코드 : " + InputStorage);
	
%>
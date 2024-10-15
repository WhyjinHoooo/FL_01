<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../mydbcon.jsp" %>
<%
	BufferedReader reader = request.getReader();
	StringBuilder sb = new StringBuilder();
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
	JSONArray CombinedData = (JSONArray) parser.parse(jsonData);
	
	System.out.println(CombinedData.size());
	String TempSaveSql = "INSERT INTO `dataadminkeytemptable` (" +
		    "`UseriD`, " +
		    "`EmployeeNAME`, " +
		    "`RnRCode`, " +
		    "`RnRDescp`, " +
		    "`UiNumber`, " +
		    "`UiDescrip`, " +
		    "`AuthorityBA`, " +
		    "`UiAuthority`, " +
		    "`COCD`, " +
		    "`CreateDate`, " +
		    "`Creator`, " +
		    "`DataAdminKey` " +
		    ") VALUES " +
		    "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
	PreparedStatement TempSavePstmt = conn.prepareStatement(TempSaveSql);
	try{
		for(int i = 0 ; i < CombinedData.size() ; i++){
			if(i == 0){
				JSONArray UserData = (JSONArray) CombinedData.get(i);
				TempSavePstmt.setString(1, (String) UserData.get(0));
				TempSavePstmt.setString(2, (String) UserData.get(1));
				TempSavePstmt.setString(9, (String) UserData.get(2));
			}
		}
	}catch(SQLException e){
		e.printStackTrace();
	} 
%>
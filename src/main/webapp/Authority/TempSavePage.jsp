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
	
	System.out.println(CombinedData);
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
		    "`DataAdminKey`, " +
		    "`Sort` " +
		    ") VALUES " +
		    "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
	PreparedStatement TempSavePstmt = conn.prepareStatement(TempSaveSql);
	try{
		JSONArray UserData = (JSONArray) CombinedData.get(0);
		TempSavePstmt.setString(1, (String) UserData.get(0));
		TempSavePstmt.setString(2, (String) UserData.get(1));
		TempSavePstmt.setString(9, (String) UserData.get(2));
		if((String)UserData.get(3) == "1"){
			TempSavePstmt.setString(13, "TempVer");
		} else {
			TempSavePstmt.setString(13, "EditVer");
		}
		for(int i = 1 ; i < CombinedData.size() ; i++){
			JSONArray DuteDate = (JSONArray) CombinedData.get(i);
			
			String DupCheckSql = "SELECT * FROM dataadminkeytemptable WHERE UiNumber = ?";
			PreparedStatement DupCheckPstmt = conn.prepareStatement(DupCheckSql);
			DupCheckPstmt.setString(1, (String) DuteDate.get(4));
			ResultSet DupCheckRs = DupCheckPstmt.executeQuery();
			System.out.println((String) DuteDate.get(4));
			if(!DupCheckRs.next()){
				System.out.println(UserData);
				TempSavePstmt.setString(7, (String) DuteDate.get(0));
				TempSavePstmt.setString(3, (String) DuteDate.get(1));
				TempSavePstmt.setString(4, (String) DuteDate.get(2));
				TempSavePstmt.setString(5, (String) DuteDate.get(4));
				switch((String) DuteDate.get(3)){
					case "입력/수정/조회":
						TempSavePstmt.setInt(8, 1);
						break;
					case "수정/조회":
						TempSavePstmt.setInt(8, 2);
						break;
					case "조회":
						TempSavePstmt.setInt(8, 3);
						break;
					default:
						TempSavePstmt.setInt(8, 4);
						break;
						
				}
				TempSavePstmt.setString(6, (String) DuteDate.get(5));
				
				String CreateDateSql = "SELECT * FROM sys_uinum WHERE UiNumber = ?";
				PreparedStatement CreateDatePstmt = conn.prepareStatement(CreateDateSql);
				CreateDatePstmt.setString(1, (String) DuteDate.get(4));
				ResultSet rs = CreateDatePstmt.executeQuery();
				if(rs.next()){
					TempSavePstmt.setString(10, rs.getString("CreateDate"));
					TempSavePstmt.setString(11, rs.getString("Creator"));
				}
				TempSavePstmt.setString(12, 
						(String) UserData.get(2) + (String) UserData.get(0) + (String) DuteDate.get(1) + (String) DuteDate.get(4) + (String) DuteDate.get(0)
						);
				
				TempSavePstmt.executeUpdate();
			}
		}
		response.setContentType("application/json; charset=utf-8");
		JSONObject jsonResponse = new JSONObject();
		jsonResponse.put("status", "success");
		out.print(jsonResponse.toJSONString());
		
	}catch(SQLException e){
		e.printStackTrace();
	}
%>
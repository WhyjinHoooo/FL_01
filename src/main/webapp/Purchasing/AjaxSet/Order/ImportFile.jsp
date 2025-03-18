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
<%@ include file="../../../mydbcon.jsp" %>

<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
        while ((line = reader.readLine()) != null) {
            jsonString.append(line);
        }
    }
	JSONArray saveListData = new JSONArray(jsonString.toString());
	System.out.println(saveListData);
	
    String ComCode = saveListData.getString(0); // Basic
    String PlantCode = saveListData.getString(1).substring(0,5); // Basic
    String MatCode = saveListData.getString(2);
    String FromDate = saveListData.getString(3); // Basic
    String EndDate = saveListData.getString(4); // Basic
    String User = saveListData.getString(5); // Basic
    
    String pass = "Fail";
    if(MatCode != "" || !MatCode.equals("")){
    	pass = "Success";
    };
	try{
    String sql = "";
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray ResultArray = new JSONArray();
    switch(pass){
    case "Success":
    	System.out.println("Success");
    	sql = "SELECT * FROM request_doc WHERE ComCode = ? AND Plant = ? " + 
    		  "AND MatCode = ? AND RegistDate >= ? AND RegistDate <= ? " +
    		  "AND PurPerson = ?";
    	pstmt = conn.prepareStatement(sql);
    	pstmt.setString(1, ComCode);
    	pstmt.setString(2, PlantCode);
    	pstmt.setString(3, MatCode);
    	pstmt.setString(4, FromDate);
    	pstmt.setString(5, EndDate);
    	pstmt.setString(6, User);
    	rs = pstmt.executeQuery();
    	while(rs.next()){
    		JSONObject ResultObject = new JSONObject();
    		ResultObject.put("DocNumPR", rs.getString("DocNumPR"));
    		ResultObject.put("MatCode", rs.getString("MatCode"));
    		ResultObject.put("MatDesc", rs.getString("MatDesc"));
    		ResultObject.put("MatType", rs.getString("MatType"));
    		ResultObject.put("QtyPR", rs.getString("QtyPR"));
    		ResultObject.put("Unit", rs.getString("Unit"));
    		ResultObject.put("RequestDate", rs.getString("RequestDate"));
    		
    		ResultObject.put("StorLoca", rs.getString("StorLoca"));
    		ResultObject.put("StorLocaDesc", rs.getString("StorLocaDesc"));
    		
    		ResultObject.put("Reference", rs.getString("Reference"));
    		ResultObject.put("StatusPR", rs.getString("StatusPR"));
    		ResultObject.put("PueOrdNum", rs.getString("PueOrdNum"));
    		ResultObject.put("ReqPerson", rs.getString("ReqPerson"));
    		
    		ResultArray.put(ResultObject);
    	}
    	break;
    case "Fail":
    	System.out.println("Fail");
    	sql = "SELECT * FROM request_doc WHERE ComCode = ? AND Plant = ? " + 
      		  "AND RegistDate >= ? AND RegistDate <= ? " +
      		  "AND PurPerson = ?";
      	pstmt = conn.prepareStatement(sql);
      	pstmt.setString(1, ComCode);
      	pstmt.setString(2, PlantCode);
      	pstmt.setString(3, FromDate);
      	pstmt.setString(4, EndDate);
      	pstmt.setString(5, User);
      	rs = pstmt.executeQuery();
      	while(rs.next()){
      		System.out.println("asd");
      		JSONObject ResultObject = new JSONObject();
      		ResultObject.put("DocNumPR", rs.getString("DocNumPR"));
      		ResultObject.put("MatCode", rs.getString("MatCode"));
      		ResultObject.put("MatDesc", rs.getString("MatDesc"));
      		ResultObject.put("MatType", rs.getString("MatType"));
      		ResultObject.put("QtyPR", rs.getString("QtyPR"));
      		ResultObject.put("Unit", rs.getString("Unit"));
      		ResultObject.put("RequestDate", rs.getString("RequestDate"));
      		
      		ResultObject.put("StorLoca", rs.getString("StorLoca"));
      		ResultObject.put("StorLocaDesc", rs.getString("StorLocaDesc"));
      		
      		ResultObject.put("Reference", rs.getString("Reference"));
      		ResultObject.put("StatusPR", rs.getString("StatusPR"));
      		ResultObject.put("PueOrdNum", rs.getString("PueOrdNum"));
      		ResultObject.put("ReqPerson", rs.getString("ReqPerson"));
      		
      		ResultArray.put(ResultObject);
      	}
    	break;
    }
	
	    response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(ResultArray.toString());
	}catch(SQLException e){
		e.printStackTrace();
	}
%>

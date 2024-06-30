<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="org.json.simple.parser.*"%>
<%@page import="org.json.simple.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
	JSONObject jsonResponse = new JSONObject();
	String jsonData = request.getParameter("data");
	JSONParser parser = new JSONParser();
	try{
		JSONArray deletedItems = (JSONArray) parser.parse(jsonData);
		Statement st = conn.createStatement();
		
		for(int i = 0 ; i < deletedItems.size() ; i++){
			JSONObject item = (JSONObject) deletedItems.get(i);
			String orderNumber = (String)item.get("doc_num");
			String GINO = (String) item.get("GINO");
			
			if(orderNumber == null || GINO == null){
				System.out.println("orderNum or GINO is null. Skipping this item.");
				continue;
			}
			System.out.println("삭제 예정인 문서번호 : " + orderNumber);
			System.out.println("삭제 예정인 품목번호 : " + GINO);
			
			String sql = "DELETE FROM placetable WHERE DocName = '" + orderNumber  +"' AND ItemNO = '" + GINO + "'";
			int result = st.executeUpdate(sql);
			
			if(result > 0){
				jsonResponse.put("result", true);
				jsonResponse.put("deletedGINO", GINO); // 삭제된 GINO를 응답으로 보냄
			} else{
				jsonResponse.put("result", false);
				jsonResponse.put("message", "해당 항목이 데이터베이스에 존재하지 않습니다.");
			}
			
			String sqlCheck = "SELECT * FROM placetable WHERE DocName = '" + orderNumber + "'";
	        ResultSet rs = st.executeQuery(sqlCheck);

	        if(!rs.next()){
	            // placetable에서 DocName이 orderNumber와 같은 데이터가 없으면 storehead에서 MatDocNum가 orderNumber와 같은 데이터를 삭제
	            String sqlDelete = "DELETE FROM storehead WHERE MatDocNum = '" + orderNumber + "'";
	            int resultDelete = st.executeUpdate(sqlDelete);

	            if(resultDelete > 0){
	                jsonResponse.put("result", true);
	            } else{
	                jsonResponse.put("result", false);
	                jsonResponse.put("message", "storehead 테이블에서 해당 항목을 삭제하지 못했습니다.");
	            }
	        }

		}
		conn.close();
	}catch(Exception e){
		e.printStackTrace();
		jsonResponse.put("result", false);
		jsonResponse.put("message", e.getMessage());
	}
	response.setContentType("application/json");  // response 객체의 setContentType 메서드 사용
    response.setCharacterEncoding("UTF-8");  // response 객체의 setCharacterEncoding 메서드 사용
    response.getWriter().write(jsonResponse.toString());  // response 객체의 getWriter 메서
%>
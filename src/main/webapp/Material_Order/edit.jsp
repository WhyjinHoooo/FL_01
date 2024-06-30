<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    JSONObject jsonResponse = new JSONObject();  // response를 jsonResponse로 이름 변경
    String jsonData = request.getParameter("data");
    JSONParser parser = new JSONParser();
    try {
        // 파라미터로 받은 JSON 데이터를 파싱
        JSONArray deletedItems = (JSONArray) parser.parse(jsonData);
        
        // MySQL 연결
        Statement st = conn.createStatement();
        
        // 삭제된 항목들에 대해 반복
        for (int i = 0; i < deletedItems.size(); i++) {
            JSONObject item = (JSONObject) deletedItems.get(i);
            String orderNum = (String) item.get("OrderNum");
            String OIN = (String) item.get("OIN");
            
            if(orderNum == null || OIN == null) {
                System.out.println("orderNum or OIN is null. Skipping this item.");
                continue;
            }

            System.out.println("orderNum: " + orderNum);  // log 추가
            System.out.println("OIN: " + OIN);  // log 추가
            
            // 해당 항목을 DB에서 삭제
            String sql = "DELETE FROM ordertable WHERE Mmpo='" + orderNum + "' AND ItemNo='" + OIN + "'";
            int result = st.executeUpdate(sql);
            
            if (result > 0) {
                // 삭제 성공
                jsonResponse.put("result", true);  // jsonResponse 사용
            } else {
                // 삭제 실패
                jsonResponse.put("result", false);  // jsonResponse 사용
                jsonResponse.put("message", "해당 항목이 데이터베이스에 존재하지 않습니다.");  // jsonResponse 사용
            }
        }
        
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        jsonResponse.put("result", false);  // jsonResponse 사용
        jsonResponse.put("message", e.getMessage());  // jsonResponse 사용
    }
    response.setContentType("application/json");  // response 객체의 setContentType 메서드 사용
    response.setCharacterEncoding("UTF-8");  // response 객체의 setCharacterEncoding 메서드 사용
    response.getWriter().write(jsonResponse.toString());  // response 객체의 getWriter 메서
%>

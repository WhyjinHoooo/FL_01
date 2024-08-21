<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%
    response.setContentType("application/json");
    JSONObject jsonResponse = new JSONObject();

    try {
        String SlipCode = request.getParameter("SlipCode");
        String Opinion = request.getParameter("Opinion");
        String Name = (String)session.getAttribute("name"); // 전표입력자/사용자의 이름
        String UserCode = (String)session.getAttribute("UserCode");
        
        String Text_Lv = null;
        int Num_Lv = 0;
        String BeforeDate = null;
        boolean aaa = true;
       
		String SlipFind_Sql = "SELECT * FROM docworkflowline WHERE DocNum = ? AND ResponsePerson = ?";
		PreparedStatement SlipFind_Pstmt = conn.prepareStatement(SlipFind_Sql);
		SlipFind_Pstmt.setString(1, SlipCode);
		SlipFind_Pstmt.setString(2, UserCode);
		ResultSet SlipFind_Rs = SlipFind_Pstmt.executeQuery();
		
		if(SlipFind_Rs.next()){
			Num_Lv = Integer.parseInt(SlipFind_Rs.getString("WFStep")) - 1; // 결재자의 레벨
			Text_Lv = Integer.toString(Num_Lv);
		}
        
		String Before_Sql = "SELECT * FROM docworkflowline WHERE DocNum = ? AND WFStep = ?";
		PreparedStatement Before_Pstmt = conn.prepareStatement(Before_Sql);
		Before_Pstmt.setString(1, SlipCode);
		Before_Pstmt.setString(2, Text_Lv);
		ResultSet Before_Rs = Before_Pstmt.executeQuery();
		
		if(Before_Rs.next()){
			BeforeDate = Before_Rs.getString("ReviewTime");
		}
        
        if(aaa){
        	jsonResponse.put("status", "success");
        }else{
        	jsonResponse.put("status", "success");
        }
    } catch (SQLException e) {
        jsonResponse.put("status", "error");
        jsonResponse.put("message", e.getMessage());
        e.printStackTrace();
    }

    out.print(jsonResponse.toString());
%>

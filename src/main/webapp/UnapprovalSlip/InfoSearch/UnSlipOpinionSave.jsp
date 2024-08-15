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
        String Name = (String)session.getAttribute("name");
        int level = 1;
        String ApprovalStatus = "B";
        LocalDateTime Date = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String SubmitDate = Date.format(formatter);
        
        String SearchSql = "SELECT * FROM workflow WHERE DocNum = '" + SlipCode + "'";
        PreparedStatement SearchPstmt = conn.prepareStatement(SearchSql);
        ResultSet SearchRs = SearchPstmt.executeQuery();
        if(SearchRs.next()){
        	String Head_Up_Sql = "UPDATE docworkflowhead SET SubmitTime = ?, WFStatus = ?, WFStep = ? WHERE DocNum = ?";
        	PreparedStatement Head_Up_Pstmt = conn.prepareStatement(Head_Up_Sql);
        	Head_Up_Pstmt.setString(1, SubmitDate);
        	Head_Up_Pstmt.setString(2, ApprovalStatus);
        	Head_Up_Pstmt.setInt(3, level);
        	Head_Up_Pstmt.setString(4, SlipCode);
        	Head_Up_Pstmt.executeUpdate();
        	
        }
        /* 
        docworkflowline에 품의 의견을 등록하는 코드 작성
        1번째줄에는 전표입력에 대한 정보
        2번째부터는 결재합의자들에 대한 정보
        */

        
        
    } catch (SQLException e) {
        jsonResponse.put("status", "error");
        jsonResponse.put("message", e.getMessage());
        e.printStackTrace();
    }

    out.print(jsonResponse.toString());
%>

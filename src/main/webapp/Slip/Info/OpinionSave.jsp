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
        String Level = "0";
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM docworkflowline WHERE DocNum = ? AND RespPersonName = ? AND WFStep = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, SlipCode);
        pstmt.setString(2, Name);
        pstmt.setString(3, Level);
        rs = pstmt.executeQuery();
            
        if (rs.next()) {
            String Up_sql = "UPDATE docworkflowline SET DocReviewOpinion = ? WHERE DocNum = ? AND RespPersonName = ? AND WFStep = ?";
            PreparedStatement Up_Pstmt = conn.prepareStatement(Up_sql);
            Up_Pstmt.setString(1, Opinion);
            Up_Pstmt.setString(2, SlipCode);
            Up_Pstmt.setString(3, Name);
            Up_Pstmt.setString(4, Level);
            Up_Pstmt.executeUpdate();
            jsonResponse.put("status", "success");
        } else {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "No matching record found.");
        }
    } catch (SQLException e) {
        jsonResponse.put("status", "error");
        jsonResponse.put("message", e.getMessage());
        e.printStackTrace();
    }

    out.print(jsonResponse.toString());
%>

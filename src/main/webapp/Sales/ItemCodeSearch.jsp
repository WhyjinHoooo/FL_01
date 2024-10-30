<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ include file="../../mydbcon.jsp" %>
<%
    JSONArray jsonArray = new JSONArray();

    try {
        String sql = "SELECT ProductCode, ProductName, ProductUnit FROM Project.ItemCode"; // SQL 쿼리
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery(sql);

        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("ProductCode", rs.getString("ProductCode"));
            jsonObject.put("ProductName", rs.getString("ProductName"));
            jsonObject.put("ProductUnit", rs.getString("ProductUnit"));
            jsonArray.put(jsonObject);
        }

        response.setContentType("application/json");
        response.getWriter().write(jsonArray.toString()); // JSON 응답
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ include file="../../mydbcon.jsp" %>
<%
    JSONArray jsonArray = new JSONArray();

    try {
    	String TradeCoCd = request.getParameter("DealCom");
    	System.out.println(TradeCoCd);
        String sql = "SELECT * FROM sales_trandingproduct WHERE TradingPartner = ?"; // SQL 쿼리
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, TradeCoCd);
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("ProductCode", rs.getString("MatCode"));
            jsonObject.put("ProductName", rs.getString("MatDesc"));
            jsonObject.put("ProductUnit", rs.getString("QtyUnit"));
            jsonArray.put(jsonObject);
        }
        response.setContentType("application/json");
        response.getWriter().write(jsonArray.toString()); // JSON 응답
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

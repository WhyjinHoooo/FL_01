<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>
<%@ include file="../../mydbcon.jsp" %>
<%
    JSONArray jsonArray = new JSONArray();

    try {
    	String TradeCoCd = request.getParameter("DealCom");
    	String PlanVer = request.getParameter("PlanVer");
    	System.out.println(TradeCoCd);
        String sql = "SELECT * FROM sales_trandingproduct WHERE TradingPartner = ? AND PlanVer = ?"; // SQL 쿼리
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, TradeCoCd);
        pstmt.setString(2, PlanVer);
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("ProductCode", rs.getString("MatCode"));
            jsonObject.put("ProductName", rs.getString("MatDesc"));
            jsonObject.put("ProductUnit", rs.getString("QtyUnit"));
            jsonObject.put("DealRate", rs.getString("TranCurr"));
            jsonArray.put(jsonObject);
        }
        response.setContentType("application/json");
        response.getWriter().write(jsonArray.toString()); // JSON 응답
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>


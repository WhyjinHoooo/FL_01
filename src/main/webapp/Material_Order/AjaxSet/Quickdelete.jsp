<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%
try {
	String KeyCode = request.getParameter("key");
	String MatCode = request.getParameter("mat");
	System.out.println(KeyCode);
	System.out.println(MatCode);
	
	String sql = "DELETE FROM ordertable WHERE KeyValue = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, KeyCode);
	
	int affectedRows = pstmt.executeUpdate();
    if (affectedRows > 0) {
        out.print("Success");
    } else {
        out.print("Fail");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.print("Fail");
}
%>

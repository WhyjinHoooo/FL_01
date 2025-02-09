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
	
	String SetUpSql01 = "SET @CNT = 0";
	String SetUpSql02 = "UPDATE ordertable SET ordertable.ItemNo = @CNT:=@CNT+1;";
	PreparedStatement SU_Pstmt01 = conn.prepareStatement(SetUpSql01);
	PreparedStatement SU_Pstmt02 = conn.prepareStatement(SetUpSql02);
	
	int affectedRows = pstmt.executeUpdate();
    if (affectedRows > 0) {
        out.print("Success");
        SU_Pstmt01.executeUpdate();
        SU_Pstmt02.executeUpdate();
    } else {
        out.print("Fail");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.print("Fail");
}
%>

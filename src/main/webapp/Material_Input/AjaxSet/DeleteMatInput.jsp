<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%

    try {
    	String DocCode = request.getParameter("DMatNum");
    	
    	String DelSql = "DELETE FROM temtable WHERE KeyValue = ?";
    	PreparedStatement DelPstmt = conn.prepareStatement(DelSql);
    	DelPstmt.setString(1, DocCode);
    	
    	String SetUpSql01 = "SET @CNT = 0";
    	String SetUpSql02 = "UPDATE temtable SET temtable.ItemNum = @CNT:=@CNT+1;";
    	PreparedStatement SU_Pstmt01 = conn.prepareStatement(SetUpSql01);
    	PreparedStatement SU_Pstmt02 = conn.prepareStatement(SetUpSql02);
    	
    	int affectedRows = DelPstmt.executeUpdate();
    	if (affectedRows > 0) {
            out.print("Success");
            SU_Pstmt01.executeUpdate();
            SU_Pstmt02.executeUpdate();
        } else {
            out.print("Fail");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.print("NoAnwser");
    }
%>

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@page import="org.json.simple.parser.*"%>
<%@page import="org.json.simple.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%
	try{
		String KeyValue = request.getParameter("KeyValue");
		String DelSql = "DELETE FROM output_temtable WHERE KeyValue = ?";
		PreparedStatement DelPstmt = conn.prepareStatement(DelSql);
		DelPstmt.setString(1, KeyValue);
		
		String SetUpSql01 = "SET @CNT = 0";
		String SetUpSql02 = "UPDATE output_temtable SET output_temtable.GINo = @CNT:=@CNT+1;";
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
	}catch(Exception e){
        e.printStackTrace();
        out.print("NoAnwser");		
	}
%>
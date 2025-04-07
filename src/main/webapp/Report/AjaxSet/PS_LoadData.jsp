<%@page import="java.io.BufferedReader"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  
<%
try{
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	JSONObject dataToSend = new JSONObject(jsonString.toString());
	System.out.println(dataToSend);
} catch(Exception e){
	e.printStackTrace();
}
%>


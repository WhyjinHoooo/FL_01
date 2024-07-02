<%@page import="java.text.NumberFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Credit = "C"; // 대변
	String Debit = "D"; // 차변
	
	int CreTotal = 0;
	int DeTotal = 0;
	
	PreparedStatement Cpstmt = null;
	ResultSet Crs = null;

	PreparedStatement Dpstmt = null;
	ResultSet Drs = null;
	
	String Csql = "SELECT * FROM tmpaccfldocline WHERE DebCre = ?";
	Cpstmt = conn.prepareStatement(Csql);
	Cpstmt.setString(1, Credit);
	
	String Dsql = "SELECT * FROM tmpaccfldocline WHERE DebCre = ?";
	Dpstmt = conn.prepareStatement(Dsql);
	Dpstmt.setString(1, Debit);
	
	Crs = Cpstmt.executeQuery();
	Drs = Dpstmt.executeQuery();
	
	while(Crs.next()) {
		CreTotal += Integer.parseInt(Crs.getString("TAmount"));
	} 
	while(Drs.next()){
		DeTotal += Integer.parseInt(Drs.getString("TAmount"));
	}
	JSONObject jsonresponse = new JSONObject();
	jsonresponse.put("CreTotal", CreTotal);
	jsonresponse.put("DeTotal", DeTotal);
	
	out.print(jsonresponse);
} catch(SQLException e){
	e.printStackTrace();
}
%>


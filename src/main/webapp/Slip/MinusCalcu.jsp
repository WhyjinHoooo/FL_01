<%@page import="java.text.NumberFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String DocCode = request.getParameter("DocCode"); // CRE20240621S0001
	String DocCodeNumber = request.getParameter("DocCodeNumber"); // CRE20240621S0001의 ItemNumber, 0001...
	
	int CreTotal = Integer.parseInt(request.getParameter("Cre"));
	int DeTotal = Integer.parseInt(request.getParameter("De"));
	
	int CreOut = 0; // 대변에서 삭제한 항목의 값
	int DeOut = 0; // 차변에서 삭제한 항목의 값
	
	String Credit = "C"; // 대변
	String Debit = "D"; // 차변
	
	PreparedStatement Cpstmt = null;
	ResultSet Crs = null;

	PreparedStatement Dpstmt = null;
	ResultSet Drs = null;
	
	String Csql = "SELECT * FROM tmpaccfldocline WHERE DebCre = ? AND DocNum = ? AND DocLineItem = ?";
	Cpstmt = conn.prepareStatement(Csql);
	Cpstmt.setString(1, Credit);
	Cpstmt.setString(2, DocCode);
	Cpstmt.setString(3, DocCodeNumber);
	
	String Dsql = "SELECT * FROM tmpaccfldocline WHERE DebCre = ? AND DocNum = ? AND DocLineItem = ?";
	Dpstmt = conn.prepareStatement(Dsql);
	Dpstmt.setString(1, Debit);
	Dpstmt.setString(2, DocCode);
	Dpstmt.setString(3, DocCodeNumber);
	
	Crs = Cpstmt.executeQuery();
	Drs = Dpstmt.executeQuery();
	
	if(Crs.next()) {
		CreTotal -= Integer.parseInt(Crs.getString("TAmount"));
	} else {
		CreTotal = CreTotal;
	}
	if(Drs.next()){
		DeTotal -= Integer.parseInt(Drs.getString("TAmount"));
	} else{
		DeTotal = DeTotal;
	}
	JSONObject jsonresponse = new JSONObject();
	jsonresponse.put("CreTotal", CreTotal);
	jsonresponse.put("DeTotal", DeTotal);
	
	out.print(jsonresponse);
} catch(SQLException e){
	e.printStackTrace();
}
%>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Num = request.getParameter("Number"); // 전표번호에 대한 항번 0001
	String NowDocNum = request.getParameter("SlipDocNum"); // FIG20230531S0001
	String first = null;
	
	System.out.println("전달 받은 항번: " + Num + ", 전표 번호 : " + NowDocNum);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	/* String sql = "SELECT * FROM ordertable WHERE SUBSTRING(Mmpo, 1, 18) = ? ORDER BY Seq ASC"; */
//	String sql = "SELECT DocNum, DocLineItem FROM tmpaccfldocline WHERE DocNum = ? ORDER BY DocLineItem DESC";
	String sql = "SELECT * FROM tmpaccfldocline WHERE DocNum = ? ORDER BY DocLineItem DESC";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, NowDocNum);
	
	rs = pstmt.executeQuery();
	
/* 	System.out.println(sql + ", " + NowDocNum); */
	if(!rs.next()) {
		// 데이터가 없다면
		first = Num;
		System.out.println("최종 항번 ver1: " + first);
	} else {
		// 데이터가 있다면 가장 최근에 등록된 데이터에 1을 더하여 저장
		/* System.out.println("Data found. Saving the incremented value of the most recent one."); */
		String recentData = rs.getString("DocLineItem"); // FIG20230530S0001, PURO20240420S00001
		int incrementedValue = Integer.parseInt(recentData) + 1;
		first = String.format("%04d", incrementedValue);
		
		System.out.println("저장된 최신 항번: " + recentData);
		System.out.println("변경된 입력 예정인 항번 : " + incrementedValue);
		System.out.println("최종 항번 ver2: " + first);
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


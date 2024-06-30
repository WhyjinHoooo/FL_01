<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String ItemNo = request.getParameter("movCode"); // 전달받은 MovCode
	String Doc = request.getParameter("docCode"); // 오늘 날짜에서 '-' 제거
	System.out.println("GI Item No : " + ItemNo + ", 문서번호 : " + Doc); // 전달이 잘 됬는지 확인
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	/* String sql = "SELECT * FROM ordertable WHERE SUBSTRING(Mmpo, 1, 18) = ? ORDER BY Seq ASC"; */
	String sql = "SELECT * FROM placetable WHERE DocName = ? ORDER BY seq DESC"; // 2023-12-13 수정 전, 수정 시 주석 삭제 예정
	/* String sql = "SELECT * FROM ordertable ORDER BY Seq DESC"; */
	pstmt = conn.prepareStatement(sql);
	
	/* pstmt.setString(1, first); */
	pstmt.setString(1, Doc);
	rs = pstmt.executeQuery();
	
	if(!rs.next()) {
		// 데이터가 없다면
		ItemNo = ItemNo;
		System.out.println("GI Item No: " + ItemNo);
	} else {
		// 데이터가 있다면 가장 최근에 등록된 데이터에 1을 더하여 저장
		/* System.out.println("Data found. Saving the incremented value of the most recent one."); */
		int recentData = rs.getInt("ItemNO");
		int incrementedValue = recentData + 1;
		ItemNo = String.format("%04d", incrementedValue);
		
		System.out.println("Recent Data: " + recentData);
		System.out.println("Incremented Value: " + incrementedValue);
		System.out.println("first: " + ItemNo);
	}
	out.print(ItemNo.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


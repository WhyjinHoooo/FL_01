<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String Code = request.getParameter("movCode"); // 전달받은 MovCode
	String Two_Code = Code.substring(0,2); // MovCode 중 앞에 두 글자만 추출
	String Date = request.getParameter("Outdate").replace("-", ""); // 오늘 날짜에서 '-' 제거
	System.out.println("MovCode 중 두 글자 : " + Two_Code + " 날짜 : " + Date); // 전달이 잘 됬는지 확인
	String first = "M" + Two_Code + Date + "S00001"; // 출고 문서번호 생성
	String three = first.substring(0, 3); // 출고 문서번호 중 앞의 세 글자만 추출
	System.out.println("문서번호 중 앞의 세 글자 : " + three); 
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT MatDocNum FROM storehead WHERE SUBSTRING(MatDocNum, 1, 3) = ? ORDER BY MatDocNum DESC"; // 2023-12-13 수정 전, 수정 시 주석 삭제 예정
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, three);
	rs = pstmt.executeQuery();
	
	if(!rs.next()) {
		// 데이터가 없다면
		first = first;
		System.out.println("Data: " + first);
	} else {
		// 데이터가 있다면 가장 최근에 등록된 데이터에 1을 더하여 저장
		/* System.out.println("Data found. Saving the incremented value of the most recent one."); */
		String recentData = rs.getString("MatDocNum");
		String numberPart = recentData.substring(15);
		int incrementedValue = Integer.parseInt(numberPart) + 1;
		first = first.substring(0, 13) + String.format("%05d", incrementedValue);
		
		System.out.println("Recent Data: " + recentData);
		System.out.println("Number Part: " + numberPart);
		System.out.println("Incremented Value: " + incrementedValue);
		System.out.println("first: " + first);
	}
	out.print(first.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


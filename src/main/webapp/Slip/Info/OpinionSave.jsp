<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<%@ include file="../../mydbcon.jsp" %>
<title>Insert title here</title>
</head>
<body>
<%
response.setContentType("application/json"); // JSON 응답의 콘텐츠 유형 설정
response.setCharacterEncoding("UTF-8"); // 응답 인코딩 설정
String jsonResponse = "";
try {
    String SlipCode = request.getParameter("SlipCode");
    String Opinion = request.getParameter("Opinion");
    String Name = (String)session.getAttribute("name");
    String Level = "0";

    if (SlipCode == null || Opinion == null || Name == null) {
        jsonResponse = "{\"status\":\"error\", \"message\":\"Invalid input parameters\"}"; // 입력 파라미터 오류 처리
    } else {
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM docworkflowline WHERE DocNum = ? AND RespPersonName = ? AND WFStep = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, SlipCode);
        pstmt.setString(2, Name);
        pstmt.setString(3, Level);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            String Up_sql = "UPDATE docworkflowline SET DocReviewOpinion = ? WHERE DocNum = ? AND RespPersonName = ? AND WFStep = ?";
            PreparedStatement Up_Pstmt = conn.prepareStatement(Up_sql);
            Up_Pstmt.setString(1, Opinion);
            Up_Pstmt.setString(2, SlipCode);
            Up_Pstmt.setString(3, Name);
            Up_Pstmt.setString(4, Level);
            Up_Pstmt.executeUpdate();
            jsonResponse = "{\"status\":\"success\"}"; // 성공 응답
        } else {
            jsonResponse = "{\"status\":\"error\", \"message\":\"No matching record found\"}"; // 일치하는 레코드 없음
        }
    }
} catch (SQLException e) {
    jsonResponse = "{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}"; // 오류 메시지를 JSON 형식으로 반환
    e.printStackTrace();
} finally {
    out.print(jsonResponse); // JSON 응답을 출력
    out.flush(); // 응답을 즉시 전송
}
%>
</body>
</html>

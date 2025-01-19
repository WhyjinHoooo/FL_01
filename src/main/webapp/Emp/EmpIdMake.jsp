<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String DateId = request.getParameter("DateId");
	String DateForNo = request.getParameter("DateId").replace("-", ""); // 정표 입력 일자 202406\
	String firstId = DateForNo + "0001";
	System.out.println("1. firstId: " + firstId);
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM emp WHERE EMPLOYEE_ID = ? ORDER BY EMPLOYEE_ID DESC";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, firstId);
	
	rs = pstmt.executeQuery();
    boolean idFound = false;
    while (!idFound) {
        pstmt.setString(1, firstId);
        rs = pstmt.executeQuery();
        
        if (!rs.next()) {
            idFound = true; // 사용 가능한 ID를 찾았으므로 루프 종료
        } else {
            String recentData = rs.getString("EMPLOYEE_ID");
            String numberPart = recentData.substring(6, 10);
            int incrementedValue = Integer.parseInt(numberPart) + 1;
            firstId = firstId.substring(0, 6) + String.format("%04d", incrementedValue);
            System.out.println("firstId: " + firstId);
        }
    }
	out.print(firstId.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


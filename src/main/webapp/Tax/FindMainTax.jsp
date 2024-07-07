<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONObject" %>
<%@page import="java.sql.SQLException"%>  

<%
try {
    String companyCode = request.getParameter("Company_Code");
    String MainSub = "1";
    
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String sql = "SELECT * FROM taxarea WHERE ComCode = ? AND MAIN_SUB = ?";
    
    pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, companyCode);
	pstmt.setString(2, MainSub);
	
	rs = pstmt.executeQuery();
	
	String TAXCode = "";

	if(rs.next()){
		TAXCode = rs.getString("Main_TA");
	}

	out.print(TAXCode);
} catch(SQLException e){
   e.printStackTrace();
   // 오류 발생 시 오류 메시지를 응답으로 반환
   out.print("error");
}
%>

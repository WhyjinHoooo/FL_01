<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONObject" %>
<%@page import="java.sql.SQLException"%>  

<%
try {
    String companyCode = request.getParameter("Company_Code");
    
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String sql = "SELECT Na_Code, Nationality FROM company WHERE Com_Cd = ?";
    
    pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, companyCode);
	rs = pstmt.executeQuery();
	
	String naCode = "";
	String nationality = "";

	if(rs.next()){
		naCode = rs.getString("Na_Code");
		nationality = rs.getString("Nationality");
	}

	out.print(naCode + "|" + nationality);
} catch(SQLException e){
   e.printStackTrace();
   // 오류 발생 시 오류 메시지를 응답으로 반환
   out.print("error");
}
%>

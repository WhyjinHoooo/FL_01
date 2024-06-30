<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String code = request.getParameter("cocd");
	System.out.println("cocd: " + code);

	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	
	ResultSet rs = null;
	ResultSet rs2 = null;
	
	String sql = "SELECT BIZ_AREA FROM bizarea WHERE Com_Code = ?";
	String sql2 = "SELECT COCT_GROUP FROM coct WHERE ComCode = ?";
	
	pstmt = conn.prepareStatement(sql);
	pstmt2 = conn.prepareStatement(sql2);
	
	pstmt.setString(1, code);
	pstmt2.setString(1, code);
	
	rs = pstmt.executeQuery();
	rs2 = pstmt2.executeQuery();
	
    JSONArray bizArray = new JSONArray();
    JSONArray coctArray = new JSONArray();
    
    while(rs.next()){
        bizArray.add(rs.getString("BIZ_AREA"));
    }
    
    while(rs2.next()) {
        coctArray.add(rs2.getString("COCT_GROUP"));
    }
    
    JSONObject responseObj = new JSONObject();
    responseObj.put("BIZ", bizArray);
    responseObj.put("COCT", coctArray);
    
    // JSONArray를 문자열로 변환하고 응답으로 전송
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(responseObj.toJSONString());
} catch(SQLException e){
	e.printStackTrace();
}
%>
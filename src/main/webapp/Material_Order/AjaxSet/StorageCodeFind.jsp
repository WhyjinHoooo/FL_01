<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try {
	String StorageCode = request.getParameter("SCode");
    System.out.println("StorageCode : " + StorageCode);

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT * FROM storage WHERE STORAGR_ID = ?";
    pstmt = conn.prepareStatement(sql);

    pstmt.setString(1, StorageCode);

    rs = pstmt.executeQuery();

    if (!rs.next()) {
        // 데이터가 없다면
        out.print("해당 plant에 대한 정보가 없습니다.");
    } else{
        String storageDes = rs.getString("STORAGR_NAME");
        System.out.println("Storage Description: " + storageDes);
        out.print(storageDes.trim());
    }
    
} catch (SQLException e) {
    e.printStackTrace();
}

%>

<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*" %>
<%@ include file="../mydbcon.jsp" %>
<%
String selectedCode = request.getParameter("ComCode");

if (selectedCode != null && !selectedCode.isEmpty()) {
    PreparedStatement pstmt2 = null;
    ResultSet rs2= null;

    String sql2= "SELECT MAX(BAGLevel) AS MaxLevel FROM bizareagroup WHERE ComCode=?";
    pstmt2=conn.prepareStatement(sql2);
    pstmt2.setString(1, selectedCode);  // Set the selected Com-code

    rs2=pstmt2.executeQuery();

    if(rs2.next()){
        Integer levelObj=(Integer)rs2.getObject("MaxLevel");
        int level = (levelObj == null) ? 0 : (levelObj == 0 ? 1 : levelObj+1);
        
        out.print(level);  // Print the max level as the response
    }
}
%>

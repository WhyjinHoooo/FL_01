<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*" %>
<%@ include file="../../mydbcon.jsp" %>
<%
	String selectedCode = request.getParameter("ComCode");
	String Sort = request.getParameter("Cate");
	PreparedStatement pstmt = null;
	ResultSet rs= null;
	String sql = null;
switch(Sort){
	case "BAG":
		if (selectedCode != null && !selectedCode.isEmpty()) {
			System.out.println("Bussiness Area Group Area");
		    sql= "SELECT MAX(BAGLevel) AS MaxLevel FROM bizareagroup WHERE ComCode=?";
		    pstmt=conn.prepareStatement(sql);
		    pstmt.setString(1, selectedCode);  // Set the selected Com-code
		
		    rs=pstmt.executeQuery();
		
		    if(rs.next()){
		        Integer levelObj=(Integer)rs.getObject("MaxLevel");
		        int level = (levelObj == null) ? 0 : (levelObj == 0 ? 1 : levelObj+1);
		        
		        out.print(level);  // Print the max level as the response
		    }
		}
		break;
	case "CCG":
		if (selectedCode != null && !selectedCode.isEmpty()) {
			System.out.println("Cost Center Group Area");
		    sql= "SELECT MAX(COCTG_LEV) AS MaxLevel FROM coct WHERE ComCode=?";
		    pstmt=conn.prepareStatement(sql);
		    pstmt.setString(1, selectedCode);  // Set the selected Com-code
		
		    rs=pstmt.executeQuery();
		
		    if(rs.next()){
		        Integer levelObj=(Integer)rs.getObject("MaxLevel");
		        int level = (levelObj == null) ? 0 : (levelObj == 0 ? 1 : levelObj+1);
		        
		        out.print(level);  // Print the max level as the response
		    }
		}
		break;
}

%>

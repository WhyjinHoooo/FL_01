<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%
try {
	String EleKeyValue = request.getParameter("KeyValue");
	System.out.println(EleKeyValue);

	String sql = "SELECT * FROM ordertable WHERE KeyValue = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, EleKeyValue);
	ResultSet rs = pstmt.executeQuery();
	String SavedItemNumber = null;
	String NewKeyValue = null;
	if(rs.next()){
		SavedItemNumber = rs.getString("ItemNo");
		if(!SavedItemNumber.equals(EleKeyValue.substring(19))){
			NewKeyValue = EleKeyValue.subSequence(0, 18) + "-" + SavedItemNumber;
			
			String UpSql = "UPDATE ordertable SET KeyValue = ? WHERE KeyValue = ?";
			PreparedStatement UpPstmt = conn.prepareStatement(UpSql);
			UpPstmt.setString(1, NewKeyValue);
			UpPstmt.setString(2, EleKeyValue);
			UpPstmt.executeUpdate();
		}
	}
	out.print("Success");
} catch (Exception e) {
    e.printStackTrace();
    out.print("Fail");
}
%>

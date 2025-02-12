<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>
<%@ page import ="org.json.simple.JSONArray" %>
<%@ page import ="org.json.simple.JSONObject" %> 
<%@page import="java.sql.SQLException"%>  

<%
try{
	String DateValue = request.getParameter("DateVal").replace("-","");
	String MoveTypeValue = request.getParameter("MoveTypeVal").substring(0,2); 
	String InitialDocNumber = "M"+ MoveTypeValue + DateValue + "S00001";
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM storehead WHERE MatDocNum = ?";
	
	pstmt = conn.prepareStatement(sql);
	boolean DupCheck = false;
	while(!DupCheck){
		pstmt.setString(1, InitialDocNumber);
		rs = pstmt.executeQuery();
		if(!rs.next()){
			DupCheck = true;
		} else{
			String SavedDocNumber = rs.getString("MatDocNum");
			String NumPart = SavedDocNumber.substring(12);
			int PlusValue = Integer.parseInt(NumPart) + 1;
			InitialDocNumber = InitialDocNumber.substring(0,12) + String.format("%05d", PlusValue);
		}
	}
	out.print(InitialDocNumber.trim());
} catch(SQLException e){
	e.printStackTrace();
}
%>


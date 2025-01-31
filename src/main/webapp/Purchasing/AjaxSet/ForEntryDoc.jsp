<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
try{
	String Topic = request.getParameter("Code");
	String TopicDate = request.getParameter("Date").replace("-","");
	String EntryDocCode = Topic + TopicDate + "S0001";
	/* PREOyyyymmddS0001 */
	String sql = "SELECT * FROM request_doc WHERE DocNumPR = ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, EntryDocCode);
	ResultSet rs = null;
	rs = pstmt.executeQuery();
	
	boolean Chk = false;
	while(!Chk){
		pstmt.setString(1, EntryDocCode);
		rs = pstmt.executeQuery();
		
		if(!rs.next()){
			Chk = true;
		}else{
			String RegistedDocCode = rs.getString("DocNumPR");
			String NumberPart = RegistedDocCode.substring(13);
			int ChangedNumpart = Integer.parseInt(NumberPart) + 1;
			EntryDocCode = Topic + TopicDate + "S" + String.format("%04d", ChangedNumpart);
		}
	}
	out.print(EntryDocCode.trim());
}catch(SQLException e){
	e.printStackTrace();
}
%>

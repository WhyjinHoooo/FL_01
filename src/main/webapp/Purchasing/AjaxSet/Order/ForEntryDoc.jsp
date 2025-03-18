<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>

<%
try{
	String FromType = request.getParameter("From");
	String EntryDocCode = "";
	String Topic = null;
	String TopicDate = null;
	String sql = "";
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	boolean Chk = true;
	switch(FromType){
	case"Review":
		System.out.println("Review");
		Topic = request.getParameter("Code");
		TopicDate = request.getParameter("Date").replace("-","");
		EntryDocCode = Topic + TopicDate + "S0001";
		sql = "SELECT * FROM request_doc WHERE DocNumPR = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, EntryDocCode);
		rs = pstmt.executeQuery();
		Chk = false;
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
		break;
	case "Req":
		System.out.println("Request");
		Topic = request.getParameter("Code");
		TopicDate = request.getParameter("Date").replace("-","");
		EntryDocCode = Topic + TopicDate + "S0001";
		/* PREOyyyymmddS0001 */
		sql = "SELECT * FROM request_doc WHERE DocNumPR = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, EntryDocCode);
		rs = pstmt.executeQuery();
		Chk = false;
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
		break;
	}
	out.print(EntryDocCode.trim());
}catch(SQLException e){
	e.printStackTrace();
}
%>

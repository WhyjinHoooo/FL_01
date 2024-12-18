<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Word01 = request.getParameter("Route").substring(0,3); // 판매경로
	String S_Word02 = request.getParameter("Date").replace("-","").substring(2, 6); // 반출예정일자
	String Value = null;
	String ExistedNo = null;
	String NumberPart = null;
	int NewNum = 0;
	
	try{
		String sql01 = "SELECT * FROM sales_delplanheader WHERE SalesOrdNum = ?";
		PreparedStatement pstmt01 = conn.prepareStatement(sql01);
		pstmt01.setString(1, "SO" + S_Word02 + S_Word01 + "00001");
		ResultSet rs01 = pstmt01.executeQuery();		
		while(true){
			if(!rs01.next()){
				Value = "SO" + S_Word02 + S_Word01 + "00001";
				break;
			} else{
				ExistedNo = rs01.getString("SalesOrdNum");
				NumberPart = ExistedNo.substring(10);
				NewNum = Integer.parseInt(NumberPart)+1;
				Value = "SO" + S_Word02 + S_Word01 + String.format("%05d",NewNum);
				break;
			}
		}
		out.print(Value);
}catch(SQLException e){
	e.printStackTrace();
}
%>

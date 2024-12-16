<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Word01 = request.getParameter("Date").replace("-","").substring(2); // 반출예정일자
	String Value = null;
	String ExistedNo = null;
	String NumberPart = null;
	int NewNum = 0;
	try{
		String sql01 = "SELECT * FROM sales_delrequestcmdheader WHERE DelivNoteNum = ?";
		PreparedStatement pstmt01 = conn.prepareStatement(sql01);
		pstmt01.setString(1, "DN" + S_Word01 + "S00001");
		ResultSet rs01 = pstmt01.executeQuery();		
		while(true){
			if(!rs01.next()){
				Value = "SO" + S_Word01 + "S00001";
				break;
			} else{
				System.out.println("잉잉123123123901728793612873");
				ExistedNo = rs01.getString("DelivNoteNum");
				NumberPart = ExistedNo.substring(9);
				NewNum = Integer.parseInt(NumberPart)+1;
				Value = "SO" + S_Word01 + String.format("%05d",NewNum);
				break;
			}
		}
		out.print(Value);
	}catch(SQLException e){
		e.printStackTrace();
	}
%>

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
		String sql01 = "SELECT * FROM sales_delrequestcmdheader ORDER BY DelivNoteNum DESC";
		PreparedStatement pstmt01 = conn.prepareStatement(sql01);
		ResultSet rs01 = pstmt01.executeQuery();		
		while(true){
			if(!rs01.next()){
				System.out.println(S_Word01);
				Value = "DN" + S_Word01 + "S00001";
				break;
			} else{
				ExistedNo = rs01.getString("DelivNoteNum");
				NumberPart = ExistedNo.substring(9);
				NewNum = Integer.parseInt(NumberPart)+1;
				Value = "DN" + S_Word01 + "S" +String.format("%05d",NewNum);
				break;
				/* D N 2 4 1 2 3 1 S 0 0  0  0  1 */
				/* 0 1 2 3 4 5 6 7 8 9 10 11 12 13 */
			}
		}
		out.print(Value);
	}catch(SQLException e){
		e.printStackTrace();
	}
%>

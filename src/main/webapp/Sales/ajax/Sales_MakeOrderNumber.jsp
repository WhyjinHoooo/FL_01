<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Word[] = request.getParameter("Seed").split(","); // 사용자의 아이디
	for(int i = 0 ; i < S_Word.length ; i++){
		System.out.println(S_Word[i]);
	}
	String OrderNumber = null;
	
	String OrderNumberSql = null;
	PreparedStatement Pstmt = null;
	ResultSet rs = null;
	try{
			OrderNumber = "FS" + S_Word[1].replace("-", "").substring(2) + "S001";
			/* FS240101S001  */
			OrderNumberSql = "SELECT * FROM project.sales_clientorder WHERE CustOrdNum = ?";
			Pstmt = conn.prepareStatement(OrderNumberSql);
			Pstmt.setString(1, OrderNumber);
			rs = Pstmt.executeQuery();
			if(!rs.next()){
				OrderNumber = OrderNumber;
			} else{
				int OrderNumber_Number = Integer.parseInt(OrderNumber.substring(9));
				OrderNumber_Number++;
				OrderNumber = "FS" + S_Word[1].replace("-", "").substring(2) + "S" + String.format("%03d", OrderNumber_Number);
				/* aa24 */
			}
 		out.print(OrderNumber);
}catch(SQLException e){
	e.printStackTrace();
}
%>

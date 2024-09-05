<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>

<%
	String S_ComCode = request.getParameter("CompanyCode");
	try{
		String sql = "SELECT * FROM company WHERE Com_Des = '"+ S_ComCode + "'";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		if(!rs.next()){
%>
	<tr>
		<td colspan="12">해당 법인에 대한 정보가(는) 없습니다.</td>
	</tr>
<%
		} else {
		do{
%>
	<tr>
		<td><%=rs.getString("Com_Cd") %></td>
		<td><%=rs.getString("Com_Des") %></td>
		<td><%=rs.getString("Nationality") %></td>
		<td><%=rs.getString("P_Num") %></td>
		<td><%=rs.getString("Addr01") %></td>
		<td><%=rs.getString("Addr02") %></td>
		<td><%=rs.getString("Local_Currency") %></td>
		<td><%=rs.getString("Language") %></td>
		<td><%=rs.getBoolean("B_Area") %></td>
		<td><%=rs.getBoolean("T_Area") %></td>
		<td><%=rs.getString("T_Area__B_Area") %></td>
		<td><%=rs.getString("FSRL") %></td>
	</tr>
<%
		}while(rs.next());
	}
}catch(SQLException e){
	e.printStackTrace();
}
%>

<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Nation = request.getParameter("SearchWord");
	String sql = "SELECT * FROM nation WHERE Name LIKE ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, "%"+S_Nation+"%");
	ResultSet rs = pstmt.executeQuery();
	try{
		
		
		if(!rs.next()){
%>
	<tr>
		<td colspan="2">해당 나라에 대한 정보가(는) 없습니다.</td>
	</tr>
<%
		} else {
		do{
%>
	<tr>
		<td><a href="javascript:void(0)" 
			onClick="
			var NCode = '<%=rs.getString("Code")%>';
			var NDes = '<%=rs.getString("Name")%>';
				           
			window.opener.document.querySelector('#NationCode').value = NCode;
			window.opener.document.querySelector('#NationDes').value = NDes;
				           
			window.opener.document.querySelector('#NationCode').dispatchEvent(new Event('change'));
			window.close();
			">
			<%=rs.getString("Code") %>
			</a>
		</td>
		<td><%=rs.getString("Name") %></td>
	</tr>
<%
		}while(rs.next());
	}
}catch(SQLException e){
	e.printStackTrace();
}finally {
    if(rs != null) try { rs.close(); } catch(SQLException e) {}
    if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
}
%>

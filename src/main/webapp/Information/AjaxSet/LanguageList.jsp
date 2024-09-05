<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String S_Word = request.getParameter("SearchWord");
	String sql = "SELECT * FROM language WHERE KRname LIKE ?";
	PreparedStatement pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, "%"+S_Word+"%");
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
			var EngName = '<%=rs.getString("ENGname")%>';
				           
			window.opener.document.querySelector('.language-code').value = EngName;
				           
			window.opener.document.querySelector('.language-code').dispatchEvent(new Event('change'));
			window.close();
			">
			<%=rs.getString("ENGname") %>
			</a>
		</td>
		<td><%=rs.getString("KRname") %></td>
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

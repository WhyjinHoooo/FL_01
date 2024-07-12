<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String QAccSubject = request.getParameter("QAccSubject");
	String AccCategory = request.getParameter("AccCate");
	String sql = null;
	if(AccCategory.equals("Code")){
		sql = "SELECT * FROM glaccount WHERE GLAccount LIKE ?";
	} else {
		sql = "SELECT * FROM glaccount WHERE AcctDesc LIKE ?";	
	}
	PreparedStatement pstmt = null;
	ResultSet rs = null;
try {   
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, "%" + QAccSubject + "%");
	rs = pstmt.executeQuery();
			
	if(!rs.next()){
%> 
	<tr>
		<td colspan="2">해당 계정과목에 대한 정보 없습니다.</td>
	</tr>
<%
} else{
	do{
%>
	<tr>
		<td>
			<a href="javascript:void(0)"
				onClick="
					var AccSubCode = '<%=rs.getString("GLAccount")%>';
					var AccSubCodeDes = '<%=rs.getString("AcctDesc")%>';
					window.opener.document.querySelector('.AccSubject').value= AccSubCode;
					window.opener.document.querySelector('.AccSubjectDes').value= AccSubCodeDes;
					window.opener.document.querySelector('.AccSubject').dispatchEvent(new Event('change')); window.close();"
			><%=rs.getString("GLAccount") %>
			</a>
		</td>
		<td><%=rs.getString("AcctDesc") %></td>
	</tr>
<%
		} while(rs.next());
	}
} catch(SQLException e) {
	e.printStackTrace();
} finally {
	if(rs != null) try { rs.close(); } catch(SQLException e) {}
	if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
}
%>

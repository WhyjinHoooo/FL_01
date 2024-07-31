<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>

<%
	String LF_info = request.getParameter("LF_Information");
	String User_Cate = request.getParameter("USer_Category");
	String sql = null;
	if(User_Cate.equals("Name")){
		sql = "SELECT * FROM emp WHERE EMPLOYEE_NAME LIKE ?";
	}
	PreparedStatement pstmt = null;
	ResultSet rs = null;
try {   
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, "%" + LF_info + "%");
	rs = pstmt.executeQuery();
			
	if(!rs.next()){
%> 
	<tr>
		<td colspan="5">해당 사원에 대한 정보가 없습니다.</td>
	</tr>
<%
} else{
	do{
%>
<tr>
	<td>
		<a href="javascript:void(0)"
			onClick="
				var UserCode = '<%=rs.getString("EMPLOYEE_ID") %>';
				var UserCode_Des = '<%=rs.getString("EMPLOYEE_NAME") %>';
				window.opener.document.querySelector('.InputerId').value=UserCode;
				window.opener.document.querySelector('.Inputer_Name').value=UserCode_Des;
				window.opener.document.querySelector('.InputerId').dispatchEvent(new Event('change'));
				window.close();
		">
		<%=rs.getString("EMPLOYEE_ID")%>
		</a>
	</td>
	<td><%=rs.getString("EMPLOYEE_NAME") %></td>
	<td><%=rs.getString("COCT") %></td>
	<td><%=rs.getString("COCT_DES") %></td>
	<td><%=rs.getString("POSITION") %></td>
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

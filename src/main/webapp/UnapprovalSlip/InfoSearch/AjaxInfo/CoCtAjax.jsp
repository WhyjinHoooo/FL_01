<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>

<%
	String LF_info = request.getParameter("LF_Information");
	String CoCt_Cate = request.getParameter("CoCt_Category");
	String sql = null;
	if(CoCt_Cate.equals("Code")){
		sql = "SELECT * FROM dept WHERE COCT LIKE ?";
	} else {
		sql = "SELECT * FROM dept WHERE COCT_NAME LIKE ?";	
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
				var CoCtCode = '<%=rs.getString("COCT") %>';
				var CpCtCode_Des = '<%=rs.getString("COCT_NAME") %>';
				window.opener.document.querySelector('.UserDepartCd').value=CoCtCode;
				window.opener.document.querySelector('.UserDepartCd_Des').value=CpCtCode_Des;
				window.opener.document.querySelector('.UserDepartCd').dispatchEvent(new Event('change'));
				window.close();
		">
		<%=rs.getString("COCT")%>
		</a>
	</td>
	<td><%=rs.getString("COCT_NAME") %></td>
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

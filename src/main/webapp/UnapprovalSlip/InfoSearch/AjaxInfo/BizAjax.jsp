<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>

<%
	String LF_info = request.getParameter("LF_Information");
	String Biz_Cate = request.getParameter("Biz_Category");
	String sql = null;
	if(Biz_Cate.equals("Code")){
		sql = "SELECT * FROM bizarea WHERE BIZ_AREA LIKE ?";
	} else {
		sql = "SELECT * FROM bizarea WHERE BA_Name LIKE ?";	
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
					var BizCode = '<%=rs.getString("BIZ_AREA") %>';
					var BizCode_Des = '<%=rs.getString("BA_Name") %>';
					window.opener.document.querySelector('.UserBizArea').value=BizCode;
					window.opener.document.querySelector('.UserBizArea_Des').value=BizCode_Des;
					window.opener.document.querySelector('.UserBizArea').dispatchEvent(new Event('change'));
					window.close();
			">
			<%=rs.getString("BIZ_AREA")%>
			</a>
		</td>
		<td><%=rs.getString("BA_Name") %></td>
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

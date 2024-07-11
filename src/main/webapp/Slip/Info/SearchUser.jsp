<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

<%
	String QAccSubject = request.getParameter("QAccSubject");
	String AccCategory = request.getParameter("AccCate");
	String sql = null;
	switch(AccCategory){
	case "UserCode":
		sql = "SELECT * FROM emp WHERE EMPLOYEE_ID LIKE ?";
		break;
	case "UserName":
		sql = "SELECT * FROM emp WHERE EMPLOYEE_NAME LIKE ?";
		break;
	case "UserRank":
		sql = "SELECT * FROM emp WHERE POSITION LIKE ?";
		break;
	case "UserCoct":
		sql = "SELECT * FROM emp WHERE COCT LIKE ?";
		break;
	case "UserCoCtDes":
		sql = "SELECT * FROM emp WHERE COCT_DES LIKE ?";
		break;
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
		<td colspan="5">해당 직원에 대한 정보 없습니다.</td>
	</tr>
<%
} else{
	do{
%>
	<tr>
		<td>
		    <a href="javascript:void(0)" 
		       onClick="
					var UserCode = '<%= rs.getString("EMPLOYEE_ID") %>';
					var UserName = '<%= rs.getString("EMPLOYEE_NAME") %>';
					var UserRank = '<%= rs.getString("POSITION") %>';
					var UserCoCt = '<%= rs.getString("COCT") %>';
					var UserCoCtDes = '<%= rs.getString("COCT_DES") %>';
		           
					window.opener.document.querySelector('.ApproverCode').value = UserCode;
					window.opener.document.querySelector('.AppName').value = UserName;
					window.opener.document.querySelector('.AppRank').value = UserRank;
					window.opener.document.querySelector('.AppCoCt').value = UserCoCt;
					window.opener.document.querySelector('.AppCoCtName').value = UserCoCtDes;
					window.opener.document.querySelector('.ApproverCode').dispatchEvent(new Event('change'));
					window.close();
		       ">
		       <%= rs.getString("EMPLOYEE_ID") %>
		    </a>
		</td>
		<td><%=rs.getString("EMPLOYEE_NAME") %></td>
		<td><%=rs.getString("POSITION") %></td>
		<td><%=rs.getString("COCT") %></td>
		<td><%=rs.getString("COCT_DES") %></td>
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

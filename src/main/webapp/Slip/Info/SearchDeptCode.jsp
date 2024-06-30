<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

	<%
	    String Deptd = request.getParameter("Deptd");
	    String sql = "SELECT * FROM dept WHERE COCT_NAME LIKE ?";
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	
	    try {
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setString(1, "%" + Deptd + "%");
	    rs = pstmt.executeQuery();
			
	    if(!rs.next()){
	%> 
		<tr>
			<td colspan="3">해당 관리/귀속 부서에 대한 정보는 없습니다.</td>
		</tr>
	<%
	} else{
		do{
	%>
		<tr>
		    <td><a href="javascript:void(0)" onClick="var deptdCoct = '<%=rs.getString("COCT")%>'; var deptdCoctDes = '<%=rs.getString("COCT_NAME")%>';var BizArea = '<%=rs.getString("BIZ_AREA")%>'; window.opener.document.querySelector('.Deptd').value=deptdCoct ; window.opener.document.querySelector('.DeptdDes').value= deptdCoctDes ; window.opener.document.querySelector('.AdminAlloc').value= BizArea ; window.opener.document.querySelector('.Deptd').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("COCT") %></a></td>
	        <td><%=rs.getString("COCT_NAME") %></td>
	        <td><%=rs.getString("BIZ_AREA") %></td>
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

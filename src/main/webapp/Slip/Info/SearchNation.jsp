<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../mydbcon.jsp" %>

	<%
	    String nation = request.getParameter("nation");
	    String sql = "SELECT * FROM nationmoney WHERE NationDes LIKE ? ORDER BY No ASC";
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	
	    try {
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setString(1, "%" + nation + "%");
	    rs = pstmt.executeQuery();
			
	    if(!rs.next()){
	%>  
		<tr>
			<td colspan="3">해당 국가에 대한 정보는 없습니다.</td>
		</tr>
	<%
	} else{
		do{
	%>
		<tr>
		    <td><a href="javascript:void(0)" onClick="var MCode = '<%=rs.getString("MoneyCode")%>';window.opener.document.querySelector('.money-code').value= MCode ;window.opener.document.querySelector('.money-code').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("MoneyCode") %></a></td>
		    <td><%=rs.getString("MoneyDes") %></td>
	        <td><%=rs.getString("NationDes") %></td>
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

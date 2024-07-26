<%@ page import="java.sql.*, java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../../mydbcon.jsp" %>

<%
    String startChar = request.getParameter("startChar");
    String ComCode = request.getParameter("Comcode");
    
    String sql = "SELECT * FROM dept WHERE COCT LIKE ?";
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, startChar + "%");
        rs = pstmt.executeQuery();
        
        while(rs.next()) {
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
        }
    } catch(SQLException e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException e) {}
        if(pstmt != null) try { pstmt.close(); } catch(SQLException e) {}
    }
%>

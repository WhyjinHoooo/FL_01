
 <%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Insert title here</title>
</head>
<body>
<h1>검색</h1>
<hr>
    <center>
<div class="ComSearch-board">
    <table>
        <tr>
            <th>YYMM</th><th>CompanyCode</th><th>Material</th><th>LotName</th>
        </tr>
    <%
        try{
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM project.totalmaterial_head";
        
        pstmt = conn.prepareStatement(sql);
        
        rs = pstmt.executeQuery();
        
        if(!rs.next()){ // 데이터가 없을 경우
    %>
        <tr>
            <td colspan="4"><a href="javascript:void(0)" onClick="window.close();">자재를 입고해주세요.</a></td>
        </tr>
    <%  
        } else { // 데이터가 있을 경우
            do {
    %>
                <tr>
                	<td><%=rs.getString("YYMM") %></td>
                    <td><%=rs.getString("Com_Code") %></td>
                    <td><%=rs.getString("Material") %></td>
                	<td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('.LotNum').value='<%=rs.getString("LotName")%>';window.opener.document.querySelector('.LotNum').dispatchEvent(new Event('input')); window.close();"><%=rs.getString("LotName") %></a></td>
                    
                </tr>
    <%  
            } while(rs.next());
        }
        }catch(SQLException e){
            e.printStackTrace();
        }
    %>
    </table>    
</div>    
    </center>
</body>
</html>
 
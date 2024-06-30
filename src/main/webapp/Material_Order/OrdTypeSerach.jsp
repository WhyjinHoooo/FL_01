<!-- test.jsp -->
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="ComSearch-board">
			<table>
			    <tr>
			        <th>Code</th><th>Description</th>
			    </tr>
			<%
			    try{
			    String sql = "SELECT * FROM ordertype";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			<tr>
			    <td><%=rs.getString("Code") %></td>
			    <td><a href="javascript:void(0)" onClick="var OrdCode = '<%=rs.getString("Code")%>'; var OrdName = '<%=rs.getString("Des")%>'; window.opener.document.querySelector('.ordType').value=OrdCode; window.opener.document.querySelector('.ordType').dispatchEvent(new Event('change')); window.opener.console.log('Selected OrdCode: ' + OrdCode); window.close();"><%=rs.getString("Des") %></a></td>
			</tr>

			<%  
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

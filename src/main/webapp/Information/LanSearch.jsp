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
			        <th>언어(영문)</th><th>나라(국문)</th>
			    </tr>
			<%
			    try{
			    String sql = "SELECT * FROM language ORDER BY Id ASC";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){	
			        
			%>
			<tr>
			    <td><a href="javascript:void(0)" onClick="var LCode = '<%=rs.getString("ENGname")%>';window.opener.document.querySelector('.language-code').value= LCode ;window.opener.document.querySelector('.language-code').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("ENGname") %></a></td>
			    <td><%=rs.getString("KRname") %></td>
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

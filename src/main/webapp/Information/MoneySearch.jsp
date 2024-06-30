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
			        <th>화폐(영문)</th><th>화폐(국문)</th>
			    </tr>
			<%
			    try{
			    String sql = "SELECT * FROM money ORDER BY Id ASC";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){	
			        
			%>
			<tr>
			    <td><a href="javascript:void(0)" onClick="var MCode = '<%=rs.getString("code")%>';window.opener.document.querySelector('.money-code').value= MCode ;window.opener.document.querySelector('.money-code').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("Code") %></a></td>
			    <td><%=rs.getString("Kr_Money") %></td>
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

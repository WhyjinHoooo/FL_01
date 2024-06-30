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
			        <th>회사 코드</th><th>회사 이름</th>
			    </tr>
			<%
			    try{
			    String sql = "SELECT * FROM company ORDER BY Com_Cd ASC";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){	
			        
			%>
			<tr>
			    <td><a href="javascript:void(0)" onClick="var ComCode = '<%=rs.getString("Com_Cd")%>';window.opener.document.querySelector('.Com-code').value= ComCode;window.opener.document.querySelector('.Com-code').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("Com_Cd") %></a></td>
			    <td><%=rs.getString("Com_Des") %></td>
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

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
			        <th>코드</th><th>설명</th>
			    </tr>
			<%
			    try{
			    String sql = "SELECT * FROM nation order by Id ASC";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			    <tr>
			        <td><%=rs.getString("Code") %></td>
			        <td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('.NationCode').value='<%=rs.getString("Code")%>'; window.opener.document.querySelector('.NationDes').value='<%=rs.getString("Name")%>'; window.close();"><%=rs.getString("Name") %></a></td>
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

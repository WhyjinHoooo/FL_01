<!-- test.jsp -->
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/PopUp.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="Total_board">
			<table class="TotalTable">
				<thead>
				    <tr>
				        <th>코드</th><th>설명</th>
				    </tr>
			    </thead>
			    <tbody>
			<%
			    try{
			    String sql = "SELECT * FROM warehouse ORDER BY code ASC";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			    <tr>
			        <td>
			        	<a href="javascript:void(0)" onClick="
			        	window.opener.document.querySelector('.Stor_Code').value='<%=rs.getString("code")%>';
			        	window.opener.document.querySelector('.Stor_Des').value='<%=rs.getString("name")%>';
			        	window.opener.document.querySelector('.Stor_Code').dispatchEvent(new Event('change'));
			        	window.close();">
			        		<%=rs.getString("code") %>
			        	</a>
			        </td>
			        <td><%=rs.getString("name") %></td>
			    </tr>
			<%  
			    }
			    }catch(SQLException e){
			        e.printStackTrace();
			    }
			%>
				</tbody>
			</table>	
		</div>	
	</center>
</body>
</html>

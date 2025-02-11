<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/PopUp.css?after">
<title>Insert title here</title>
</head>
<body>
<h1>MoveMent Type 검색</h1>
<hr>
	<center>
		<div class="Total_board ForMove">
			<table class="TotalTable">
				<thead>
			        <tr>
						<th>MoveType</th><th>+/-</th><th>MoveTypeDes</th>
					</tr>
				<tbody>
				<%
				try{
					String gr = "GR";
					String sql = "SELECT * FROM movetype WHERE GRGI = ?";
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, gr);
					rs = pstmt.executeQuery();
					
					
					while(rs.next()){
				%>
					<tr>
						<td>
							<a href="javascript:void(0)" onClick="
						var MovType = '<%=rs.getString("MoveType")%>';
						var MovDes = '<%=rs.getString("MoveTypeDes")%>';
						var PlMi = '<%=rs.getString("QtyPlusMinus")%>';
						window.opener.document.querySelector('.MovType').value=MovType;
						window.opener.document.querySelector('.MovType_Des').value=MovDes;
						window.opener.document.querySelector('.PlusMinus').value=PlMi;
						window.opener.document.querySelector('.MovType').dispatchEvent(new Event('input'));
						window.close();">
							<%= rs.getString("MoveType")%>
							</a>
						</td>
						<td><%= rs.getString("QtyPlusMinus")%></td>
						<td><%=rs.getString("MoveTypeDes") %></td>
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
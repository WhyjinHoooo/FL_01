<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/PopUp.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="Sales_TradeCom_board">
			<table class="TradeComTable">
				<thead>
				    <tr>
				        <th>판매경로(DChannel)</th><th>판매경로명(DChannelDesc)</th>
				    </tr>
			    </thead>
			    <tbody>
			<%
			try{
			    String sql = "SELECT * FROM project.sales_route";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    while(rs.next()){
			%>
			<tr>
			    <td>
				    <a href="javascript:void(0)" 
				       onClick="
				           window.opener.document.querySelector('.SalesRouteCode').value = '<%= rs.getString("SalesRoute") %>';
				           window.opener.document.querySelector('.SalesRouteCodeDes').value = '<%= rs.getString("SalesRouteDEs") %>';
				           window.opener.document.querySelector('.SalesRouteCode').dispatchEvent(new Event('change'));
				           window.close();
				       ">
				       <%= rs.getString("SalesRoute") %> <!-- 판매경로 코드 -->
				    </a>
				</td>
			    <td><%=rs.getString("SalesRouteDEs") %></td> <!-- 판매경로 코드에 대한 설명 -->
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

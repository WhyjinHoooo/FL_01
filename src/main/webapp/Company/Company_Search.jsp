<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="../css/style.css">
<title>Insert title here</title>
</head>
<script>
	$(document).ready(function(){
		$('.SearchBtn').click(function(){
			var ComCode = $('.CompanyId').val();
			console.log("검색할 회사 코드 : " + ComCode);
			$.ajax({
				url: '${contextPath}/Company/Company_Search_Ok.jsp',
				type: 'POST',
				data: {CompanyCode : ComCode},
				success: function(response){
					$('.ComInfoTable tbody').html(response);
				}
			});
		});
		
		$('.CompanyId').keydown(function(e){
        	if(e.which == 13){
        		$('.SearchBtn').trigger("click");
        		return false;
        	}
        });
	});
</script>
</script>
<body>
	<h1>Company Search</h1>
	<hr>
	<center>
		<div class="ComInfoSearchArea">
			<input type="text" class="CompanyId" placeholder="입력">
			<button class="SearchBtn">Search</button>
			<button class="ReSetBtn" onClick="window.location.reload()">Reset</button>
		</div>
		<div class="ComInfoDetail">
			<table class="ComInfoTable">
				<thead>
					<tr>
						<th>Company Code</th><th>Company Description</th><th>Nationality</th><th>Postal Number</th><th>Address 1</th>
						<th>Address 2</th><th>Local Currency</th><th>Language</th><th>Business Area 사용 여부</th><th>Tax Area 사용 여부</th>
						<th>Tax Area vs Biz,Area 대응 관계</th><th>Financial Statement Reporting Level</th>
					</tr>
				</thead>
				<tbody>
				<%
				try{
					String Sql = "SELECT * FROM company";
					PreparedStatement pstmt = conn.prepareStatement(Sql);
					ResultSet rs = pstmt.executeQuery();
					while(rs.next()){
				%>
				<tr>
					<td><%=rs.getString("Com_Cd") %></td>
					<td><%=rs.getString("Com_Des") %></td>
					<td><%=rs.getString("Nationality") %></td>
					<td><%=rs.getString("P_Num") %></td>
					<td><%=rs.getString("Addr01") %></td>
					<td><%=rs.getString("Addr02") %></td>
					<td><%=rs.getString("Local_Currency") %></td>
					<td><%=rs.getString("Language") %></td>
					<td><%=rs.getBoolean("B_Area") %></td>
					<td><%=rs.getBoolean("T_Area") %></td>
					<td><%=rs.getString("T_Area__B_Area") %></td>
					<td><%=rs.getString("FSRL") %></td>
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
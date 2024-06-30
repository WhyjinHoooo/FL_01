<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css">
<title>Result</title>
</head>
<body>
	<h1>Search Result</h1>
	<hr>
	<div class="Search-Result">
		<table border="1">
			<tr>
				<th>Company Code</th><th>Company Description</th><th>Nationality</th><th>Postal Number</th><th>Address 1</th><th>Address 2</th><th>Local Currency</th><th>Language</th><th>Business Area 사용 여부</th><th>Tax Area 사용 여부</th><th>Tax Area vs Biz,Area 대응 관계</th><th>Financial Statement Reporting Level</th>
			</tr>
		<%
		request.setCharacterEncoding("UTF-8");
		
		String ComSearch = request.getParameter("Com_search");
		String sql = "SELECT * FROM company WHERE Com_Cd = '"+ ComSearch + "'";
		try{
			PreparedStatement pstmt = conn.prepareStatement(sql);
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
		} catch(SQLException e){
			e.printStackTrace();
		}
		%>
		</table>
	</div>
</body>
</html>
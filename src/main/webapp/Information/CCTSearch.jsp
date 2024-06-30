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
			        <th>코드(Code)</th><th>이름(Description)</th>
			    </tr>
			<%
			    try{
			   	
			    String sql = "SELECT * FROM depart";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			%>
			<tr>
			    <td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('.cct').value= <%=rs.getString("COCT_Type") %>;window.opener.document.querySelector('.CCT_Des').value= <%=rs.getString("COCT_Description") %>;window.opener.document.querySelector('.cct').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("COCT_Type") %></a></td>
			    <td><%=rs.getString("COCT_Description") %></td>
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

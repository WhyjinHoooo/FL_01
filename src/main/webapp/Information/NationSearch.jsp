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
			        <th>나라(영문)</th><th>나라(국문)</th>
			    </tr>
			<%
			    try{
			    String sql = "SELECT * FROM nation ORDER BY Id ASC";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){	
			        
			%>
			<tr>
			    <td><a href="javascript:void(0)" 
				       onClick="
				           var NCode = '<%=rs.getString("Code")%>';
				           var NDes = '<%=rs.getString("Name")%>';
				           
				           window.opener.document.querySelector('#NationCode').value = NCode;
				           window.opener.document.querySelector('#NationDes').value = NDes;
				           
				           window.opener.document.querySelector('#NationCode').dispatchEvent(new Event('change'));
				           window.close();
				       ">
				       <%=rs.getString("Code") %>
				    </a>
			    </td>
			    <td><%=rs.getString("Name") %></td>
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

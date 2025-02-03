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
			    String sql = "SELECT * FROM company";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
		        while(rs.next()){ // 데이터가 없을 경우
		    %>
			    <tr>
			        <td>
			        	<a href="javascript:void(0)" onclick="
			        		var ComCode='<%=rs.getString("Com_Cd")%>';
			        		window.opener.document.querySelector('.ComCode').value=ComCode;
			        		window.opener.document.querySelector('.ComCode').dispatchEvent(new Event('change'));
			        		window.close();
			        	">
			        	<%=rs.getString("Com_Cd") %>
			        	</a>
			        </td>
			        <td><%=rs.getString("Com_Des") %></td>
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

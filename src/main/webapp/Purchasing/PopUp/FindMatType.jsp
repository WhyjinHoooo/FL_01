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
		<div class="Total_board MaterialTypePop">
			<table class="TotalTable">
				<thead>
					<tr>
				        <th>Material Type</th><th>Material Type Description</th>
				    </tr>
				</thead>
				<tbody>
			<%
			try{
			    String sql = "SELECT * FROM mattype";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
		        while(rs.next()){ // 데이터가 없을 경우
		    %>
			    <tr>
			        <td>
			        	<a href="javascript:void(0)" onclick="
			        		var MTCode='<%=rs.getString("Mat_Type")%>';
			        		var MTCoDes='<%=rs.getString("Des")%>';
			        		window.opener.document.querySelector('.MatTypeCode').value=MTCode + '(' + MTCoDes + ')';
			        		window.opener.document.querySelector('.MatTypeCode').dispatchEvent(new Event('change'));
			        		window.close();
			        	">
			        	<%=rs.getString("Mat_Type") %>
			        	</a>
			        </td>
			        <td><%=rs.getString("Des") %></td>
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

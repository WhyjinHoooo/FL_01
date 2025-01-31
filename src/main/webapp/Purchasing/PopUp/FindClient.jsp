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
				<tr>
					<td>
						<a href="javascript:void(0)" onclick="
			        		window.opener.document.querySelector('.Client').value='BLANK';
			        		window.opener.document.querySelector('.Client').dispatchEvent(new Event('change'));
			        		window.close();
			        	">
						BLANK
						</a>
					</td>
					<td>BLANK</td>
				</tr>
			<%
			try{
				String Category = request.getParameter("Category");
			    String sql = "SELECT * FROM emp";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
		        while(rs.next()){ // 데이터가 없을 경우
		        	 if(Category.equals("Search")) {
		    %>
			    <tr>
			        <td>
			        	<a href="javascript:void(0)" onclick="
			        		var Uid='<%=rs.getString("EMPLOYEE_ID")%>';
			        		window.opener.document.querySelector('.Client').value=Uid;
			        		window.opener.document.querySelector('.Client').dispatchEvent(new Event('change'));
			        		window.close();
			        	">
			        	<%=rs.getString("EMPLOYEE_ID") %>
			        	</a>
			        </td>
			        <td><%=rs.getString("EMPLOYEE_NAME") %></td>
			    </tr>		    
		    <%
					}else if(Category.equals("Entry")) {
			%>
				<tr>
			        <td>
			        	<a href="javascript:void(0)" onclick="
			        		var Uid='<%=rs.getString("EMPLOYEE_ID")%>';
			        		window.opener.document.querySelector('.Entry_Client').value=Uid;
			        		window.opener.document.querySelector('.Entry_Client').dispatchEvent(new Event('change'));
			        		window.close();
			        	">
			        	<%=rs.getString("EMPLOYEE_ID") %>
			        	</a>
			        </td>
			        <td><%=rs.getString("EMPLOYEE_NAME") %></td>
			    </tr>	
			<% 	
					}
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

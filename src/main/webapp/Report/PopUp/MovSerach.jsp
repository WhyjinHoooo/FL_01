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
<h1>검색</h1>
<hr>
    <center>
		<div class="Total_board ForMove">
			<table class="TotalTable">
				<thead>
			        <tr>
			            <th>코드</th>
			        </tr>
			        </thead>
			        <tbody>
		    <%
			try{
				String type = request.getParameter("Move");
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        String sql = "SELECT distinct(GRGI) as Type FROM movetype";
		        
		        pstmt = conn.prepareStatement(sql);
		        
		        rs = pstmt.executeQuery();
		        
				while(rs.next()){
					if(type.equals("MovCode-In")){
		    %>
				<tr>
					<td>
						<a href="javascript:void(0)" onClick="
						window.opener.document.querySelector('.MovCode-In').value='<%=rs.getString("Type")%>';
						window.opener.document.querySelector('.MovCode-In').dispatchEvent(new Event('change'));
						window.close();">
						<%=rs.getString("Type") %>
						</a>
					</td>
				</tr>
		    <%  
					}else{
			%>
				<tr>
					<td>
						<a href="javascript:void(0)" onClick="
						window.opener.document.querySelector('.MovCode-Out').value='<%=rs.getString("Type")%>';
						window.opener.document.querySelector('.MovCode-Out').dispatchEvent(new Event('change'));
						window.close();">
						<%=rs.getString("Type") %>
						</a>
					</td>
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

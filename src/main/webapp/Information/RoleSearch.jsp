<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/PopUp.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="Total_board">
			<table class="TotalTable">
				<thead>
				    <tr>
				        <th>직무코드(RoleCode)</th><th>직무(RoleDescription)</th>
				    </tr>
			    </thead>
			    <tbody>
			<%
			    try{
			    String sql = "SELECT * FROM sys_dute";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    if(!rs.next()){
			%>
				<tr>
					<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">해당 회계단위(은)는 없습니다.</a></td>
				</tr>
			<%
			    } else{
			    	do{
			%>
			<tr>
			    <td>
				    <a href="javascript:void(0)" 
				       onClick="
				           window.opener.document.querySelector('.UserDutyCode').value = '<%= rs.getString("RnRCode") %>';
				           window.opener.document.querySelector('.UserDutyDes').value = '<%= rs.getString("RnRDescp") %>';
				           window.opener.document.querySelector('.UserDutyCode').dispatchEvent(new Event('change'));
				           window.close();
				       ">
				       <%= rs.getString("RnRCode") %>
				    </a>
				</td>
			    <td><%=rs.getString("RnRDescp") %></td>
			</tr>
			<%  
			    	}while(rs.next());
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

<!-- test.jsp -->
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
			    String sql = "SELECT * FROM plant";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			<tr>
			    <td><%=rs.getString("Plant_ID") %></td>
			    <td hidden><%=rs.getString("COMCODE") %></td>
			    <td>
				    <a href="javascript:void(0)" onClick="
					    var PlantCode = '<%=rs.getString("PLANT_ID")%>';
					    var PlantName = '<%=rs.getString("PLANT_NAME")%>';
					    var ComCode = '<%=rs.getString("COMCODE")%>'; 
					    window.opener.document.querySelector('.plantCode').value=PlantCode;
					    window.opener.document.querySelector('.plantDes').value=PlantName;
					    window.opener.document.querySelector('.plantComCode').value=ComCode;
					    window.opener.document.querySelector('.plantCode').dispatchEvent(new Event('change'));
					    window.close();">
				    	<%=rs.getString("PLANT_NAME") %>
				    </a>
			    </td>
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

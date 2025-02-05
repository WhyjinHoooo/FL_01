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
			    String sql = "SELECT * FROM mattype";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			    <tr>
			        <td><%=rs.getString("Mat_Type") %></td>
			        <td><a href="javascript:void(0)" onClick="var MatCode = '<%=rs.getString("Mat_Type")%>'; var MatName = '<%=rs.getString("Des")%>'; window.opener.document.querySelector('.matTypeCode').value=MatCode; window.opener.document.querySelector('.matTypeCode').dispatchEvent(new Event('change')); window.opener.document.querySelector('.matTypeDes').value=MatName; window.opener.console.log('Selected MatCode: ' + MatCode + ', MatName: ' + MatName); window.close();"><%=rs.getString("Des") %></a></td>
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

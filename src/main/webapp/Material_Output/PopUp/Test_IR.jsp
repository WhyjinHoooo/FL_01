<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" import=" java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%@page session="true"%>
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
	<jsp:include page="../../Winpop.jsp"></jsp:include>
	<center>
		<div class="Total_board ForMove">
			<table class="TotalTable">
				<thead>
				    <tr>
			        	<th>코드</th><th>+/-</th><th>설명</th>
			    	</tr> 
			    </thead>
				<tbody>  
			<%
			    try{
			    String sql = "SELECT * FROM movetype WHERE GRGI = ?";
			    String ir = "IR";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, ir);
			    rs = pstmt.executeQuery();
			    
			    while(rs.next()){
			        
			%>
			<tr>
			    <td><%=rs.getString("MoveType") %></td>
			    <td><%= rs.getString("QtyPlusMinus")%></td>
			    <td>
			    	<a href="javascript:void(0)" onClick="
			    	var MovType = '<%=rs.getString("MoveType")%>';
			    	var MovDes = '<%=rs.getString("MoveTypeDes")%>';
			    	var PlMi = '<%=rs.getString("QtyPlusMinus")%>';
			    	window.opener.document.querySelector('.movCode').value=MovType;
			    	window.opener.document.querySelector('.movDes').value=MovDes;
			    	window.opener.document.querySelector('.PlusMinus').value=PlMi;
			    	window.opener.document.querySelector('.movCode').dispatchEvent(new Event('change'));
			    	window.close();">
			    	<%=rs.getString("MoveTypeDes") %>
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

<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/forSlip.css?after">
<title>Insert title here</title>
</head>
<body>
    <center>
	<div class="ComSearch-board">
	     <table id="resultTable">
	     	<thead>
		        <tr>
		            <th>회사 코드</th><th>회사 이름</th>
		        </tr>
	        </thead>
	        <tbody>
		<%
	        try{
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        String sql = "SELECT * FROM bizarea";
	        
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	   		
	        while(rs.next()){
		%>
			<tr>
				<td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('#TargetDepartCd').value='<%=rs.getString("BIZ_AREA")%>'; window.opener.document.querySelector('#TargetDepartDes').value='<%=rs.getString("BA_Name")%>';window.opener.document.querySelector('#TargetDepartCd').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("BIZ_AREA") %></a></td>
				<td><%=rs.getString("BA_Name") %></td>
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
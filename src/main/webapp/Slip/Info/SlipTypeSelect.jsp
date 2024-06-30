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
		            <th>전표 유형(ENG)</th><th>전표 유형(KOR)</th>
		        </tr>
	        </thead>
	        <tbody>
		<%
	        try{
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        String sql = "SELECT * FROM sliptype;";
	        
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	   		
	        while(rs.next()){
		%>
			<tr>
				<td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('#SlipType').value='<%=rs.getString("FIDocType")%>'; window.opener.document.querySelector('#SlipTypeDes').value='<%=rs.getString("FIDocTypeDesc")%>';window.opener.document.querySelector('#SlipType').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("FIDocType") %></a></td>
				<td><%=rs.getString("FIDocTypeDesc") %></td>
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
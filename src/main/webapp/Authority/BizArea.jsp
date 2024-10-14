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
<link rel="stylesheet" href="${contextPath}/css/PopUp.css?after">
<title>Insert title here</title>
</head>
<body>
    <center>
	<div class="PopUp-board">
	     <table class="">
	     	<thead>
		        <tr>
		            <th>사업영역(코드)</th><th>사업영역</th>
		        </tr>
	        </thead>
	        <tbody>
		<%
		try{
	        String ComCode = request.getParameter("ComCode"); // 현재 사용자가 소속괸 Company Code
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        String sql = "SELECT * FROM bizarea WHERE Com_Code = ?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, ComCode);
	        rs = pstmt.executeQuery();
	        
	        if(!rs.next()){
		%>
			<tr>
				<td colspan="3"><a href="javascript:void(0)" onClick="window.close();">해당 기업의 사업부서없습니다.</a></td>
			</tr>
		<%    	
	        } else{
	        	do{
	    %>
			<tr>
				<td>
					<a href="javascript:void(0)" 
						onClick="
						window.opener.document.querySelector('#BizAreaCode').value = '<%= rs.getString("BIZ_AREA") %>';
						window.opener.document.querySelector('#BizAreaName').value = '<%= rs.getString("BA_Name") %>';
						window.opener.document.querySelector('#BizAreaCode').dispatchEvent(new Event('change'));
						window.close();
				     ">
				     <%= rs.getString("BIZ_AREA") %>
				  </a>
				</td>
				<td><%=rs.getString("BA_Name") %></td>
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
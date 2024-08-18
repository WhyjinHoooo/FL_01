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
<link rel="stylesheet" href="../../css/USTcss.css?after">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<center>
		<div class="LineInfoBoard">
			<table class="SearchedTable">
				<thead>
					<tr>
						<th>전표번호_라인</th><th>조회순서</th><th>계정관리항목</th><th>관리정보명</th><th>관리정보값</th>
					</tr>
				</thead>
				<tbody>
					<%
						try{
							String SlipCode = request.getParameter("SlipCode");
						
							String sql = "SELECT * FROM fidoclineinform WHERE DocNum_LineDetail LIKE ?";
							PreparedStatement pstmt = null;
							ResultSet rs = null;
							pstmt = conn.prepareStatement(sql);
							pstmt.setString(1, SlipCode + "%");
							rs = pstmt.executeQuery();
							
							while(rs.next()){
					%>
					<tr>
						<td><%=rs.getString("DocNum_Line")%></td>
						<td><%=rs.getString("DispSeq") %></td>
						<td><%=rs.getString("AcctInfoCode") %></td>
						<td><%=rs.getString("InfoDescrip") %></td>
						<td><%=rs.getString("InfoValue") %></td>
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
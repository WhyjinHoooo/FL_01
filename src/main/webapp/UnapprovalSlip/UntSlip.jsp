<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/USTcss.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전표 품의 상신 및 결재</title>
</head>
<body>
<h5>전표 품의상신 및 결재</h5>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<form name="###" class="###" action="###" method="###" enctype="UTF-7">
		<div class="TotalArea">
			<div class="slip_Search_Area">
				<div class="Area_title">검색 조건</div>
				<table class="UserInfo">
						<tr>
							<th>법인(ComCode) : </th>
							<td>
								<input>
							</td>
						</tr>
						<tr>
							<th>전표입력 BA : </th>
							<td>
								<input>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표입력부서 : </th>
							<td>
								<input>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표 입력자 : </th>
							<td>
								<input>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>결재 합의자 : </th>
							<td>
								<input>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>기표일자(From) : </th>
							<td>
								<input>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>기표일자(To) : </th>
							<td>
								<input>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>미승인전표 상태 : </th>
							<td>
								<input>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표유형 : </th>
							<td>
								<input>
								<button>&#8681;</button>
							</td>
						</tr>
				</table>
			</div>
			<div class="UntSituation">
				<input>
			</div>
		</div>
	</form>
</body>
</html>
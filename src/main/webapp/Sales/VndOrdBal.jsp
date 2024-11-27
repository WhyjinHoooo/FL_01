<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<hr>
	<div class="VndOrdArea">
		<div class="VndOrd-Main">
			<div class="VndOrd-Main-Header">SEARCH FIELDS</div>
			<div class="VndOrd-Main-Input">
				<label>회사: </label>
				<input>
			</div>
			<div class="VndOrd-Main-Input">
				<label>회계단위: </label>
				<div class="ColumnInput">
					<input>
					<input>
				</div>
			</div>
			<div class="VndOrd-Main-Input">
				<label>거래처: </label>
				<div class="ColumnInput">
					<input>
					<input>
				</div>
			</div>
			
			<div class="BtnArea">
				<button class="DoItBtn">실행</button>
			</div>
		</div>
		<div class="VndOrd-Sub">
			<div class="VndOrd-Sub-Header">거래처 수주 잔량 현황</div>
		</div>
	</div>
</body>
</html>
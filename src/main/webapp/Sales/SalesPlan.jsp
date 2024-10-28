<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="SalesArea">
	<div class="SalesMainArea">
		<div class="InputArea">
			<div class="Sales_UserInfo">
				<label id="Company">회사: </label>
				<input class="ComCode" name="ComCode" id="ComCode" readonly value="Click">
				<label id="User">입력자: </label>
				<input class="UserId" name="UserId" id="UserId" readonly>
			</div>
			<div class="Sales_BizInfo">
				<label id="BizUnit">회계단위: </label>
				<input class="BizCode" name="BizCode" id="BizCode" readonly value="Click">
				<input class="BizCodeDes" name="BizCodeDes" id="BizCodeDes" readonly>
				<label id="InputDate">입력일자: </label>
				<input type="Date" class="InputDate" name="InputDate" id="InputDate">
			</div>
			<div class="Sales_PlanInfo">
				<label id="PlanYear">계획연도: </label>
				<select class="Year" name="Year" id="Year">
					<option>SELECT</option>
				</select>
			</div>
			<div class="Sales_DocInfo">
				<label id="DocVersion">Plan Version: </label>
				<input class="DocCode" name="DocCode" id="DocCode" readonly value="Click">
				<input class="DocCodeDes" name="DocCodeDes" id="DocCodeDes" readonly value="Click">
				<label id="CountUnit">수량 입력단위: </label>
				<select class="Unit" name="Unit" id="Unit">
					<option>SELECT</option>
				</select>
			</div>
			<div class="Sales_PlanPeriod">
				<label id="Period">계획기간: </label>
				<input class="PeriodStart" name="PeriodStart" id="PeriodStart">
				~
				<input class="PeriodEnd" name="PeriodEnd" id="PeriodEnd">
			</div>
			<div class="Sales_DealComInfo">
				<label id="DealCompany">거래처: </label>
				<input class="DealComCode" name="DealComCode" id="DealComCode" readonly value="Click">
				<input class="DealComCodeDes" name="DealComCodeDes" id="DealComCodeDes" readonly>
			</div>
		</div>
	</div>
	<div class="ButtonArea">
		<button class="SaveBtn">저장</button>
	</div>
	<div class="SalesSubArea">
		<table class="SalesPlanTable">
			<thead class="SalesPlanTable_Head">
				<th>품목코드</th><th>품목명</th><th>단위</th>
				<th>1월</th><th>2월</th><th>3월</th><th>4월</th>
				<th>5월</th><th>6월</th><th>7월</th><th>8월</th>
				<th>9월</th><th>10월</th><th>11월</th><th>12월</th>
			</thead>
			<tbody class="SalesPlanTable_Body">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
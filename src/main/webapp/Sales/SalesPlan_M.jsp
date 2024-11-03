<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
function InfoSearch(field){
	event.preventDefault();
	
	var popupWidth = 1000;
    var popupHeight = 600;
    
    // 현재 활성화된 모니터의 위치를 감지
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    console.log(dualScreenLeft);
    // 전체 화면의 크기를 감지
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
    if (width == 2560 && height == 1440) {
        // 단일 모니터 2560x1440 중앙에 팝업창 띄우기
        xPos = (2560 / 2) - (popupWidth / 2);
        yPos = (1440 / 2) - (popupHeight / 2);
    } else if (width == 1920 && height == 1080) {
        // 단일 모니터 1920x1080 중앙에 팝업창 띄우기
        xPos = (1920 / 2) - (popupWidth / 2);
        yPos = (1080 / 2) - (popupHeight / 2);
    } else {
        // 확장 모드에서 2560x1440 모니터 중앙에 팝업창 띄우기
        var monitorWidth = 2560;
        var monitorHeight = 1440;
        xPos = (monitorWidth / 2) - (popupWidth / 2) + dualScreenLeft;
        yPos = (monitorHeight / 2) - (popupHeight / 2) + dualScreenTop;
    }
    
}
$(document).ready(function(){
	
	$('.SalesPlanTable_Body_Month').empty();
    // 50개의 <tr> 요소 추가
	for (let i = 0; i < 50; i++) {
        const row = $('<tr></tr>'); // 새로운 <tr> 생성
        // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
        for (let j = 0; j < 34; j++) {
            row.append('<td></td>');
        }
        // 생성한 <tr>을 <tbody>에 추가
        $('.SalesPlanTable_Body_Month').append(row);
    }
})
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String todayDate = today.format(formatter);
	
	String UserId = (String)session.getAttribute("id");
	String UserComCode = (String)session.getAttribute("depart");
%>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="SalesArea">
	<div class="SalesMainArea">
		<div class="InputArea">
			<div class="Sales_UserInfo">
				<label id="Company">회사: </label>
				<input type="text" class="Com-code" name="Comcode" id="ComCode" value=<%=UserComCode %> readonly>
				<label id="User">입력자: </label>
				<input class="UserId" name="UserId" id="UserId" value=<%=UserId %> readonly>
			</div>
			<div class="Sales_BizInfo">
				<label id="BizUnit">회계단위: </label>
				<input type="text" class="BizCode" name="BizCode" id="BizCode" readonly>
				<input type="text" class="BizCodeDes" name="BizCodeDes" id="BizCodeDes" readonly>
				<label id="InputDate">입력일자: </label>
				<input type="text" class="InputDate" name="InputDate" id="InputDate" value=<%=todayDate %> readonly> 
			</div>
			<div class="Sales_DocInfo">
				<label id="DocVersion">Plan Version: </label>
				<input type="text" class="DocCode" name="DocCode" id="DocCode" readonly value="Click">
				<input class="DocCodeDes" name="DocCodeDes" id="DocCodeDes" readonly value="Click">
				<label id="CountUnit">수량 입력단위: </label>
				<select class="Unit" name="Unit" id="Unit">
					<option>SELECT</option>
					<option value="1">1</option>
					<option value="10000">10,000</option>
					<option value="1000000">1,000,000</option>
				</select>
			</div>
			<div class="Sales_PlanInfo">
				<label id="PlanYear">계획년월: </label>
				<select class="Month" name="Month" id="Month">
					<option>SELECT</option>
				</select>
			</div>
			<div class="Sales_PlanPeriod">
				<label id="Period">계획기간: </label>
				<select class="PeriodStart" name="PeriodStart" id="PeriodStart">
				</select> 
				~
				<input type="text" class="PeriodEnd" name="PeriodEnd" id="PeriodEnd" readonly>
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
	<div class="SalesSubArea_Month">
		<table class="SalesPlanTable_Month">
			<thead class="SalesPlanTable_Head_Month">
				<th>품목코드</th><th>품목명</th><th>단위</th>
				<th>1일</th><th>2일</th><th>3일</th><th>4일</th><th>5일</th><th>6일</th><th>7일</th>
				<th>8일</th><th>9일</th><th>10일</th><th>11일</th><th>12일</th><th>13일</th><th>14일</th>
				<th>15일</th><th>16일</th><th>17일</th><th>18일</th><th>19일</th><th>20일</th><th>21일</th>
				<th>22일</th><th>23일</th><th>24일</th><th>25일</th><th>26일</th><th>27일</th><th>28일</th>
				<th>29일</th><th>30일</th><th>31일</th>
			</thead>
			<tbody class="SalesPlanTable_Body_Month">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
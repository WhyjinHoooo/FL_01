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
    
    switch(field){
    	case "ComSearch":
			window.open("${contextPath}/Information/ComSearch.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
			break;
		case "BizSearch":
			var ComCode = $('.Com-code').val();
			window.open("${contextPath}/Information/BizAreaSearch.jsp?ComCode=" + ComCode, "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
			break;
    }
}
$(document).ready(function(){
	var YearInput = document.getElementById('Year');
	var CurrentYear = new Date().getFullYear();
	var StartYear = CurrentYear + 1;
	var EndYear = StartYear + 100;
	for(let Year = StartYear; Year <= EndYear ; Year++){
		var Option = document.createElement('option');
		Option.value = Year;
		Option.textContent = Year;
		YearInput.appendChild(Option);
	}
	
	$('.Year').change(function(){
		alert("야야야야야양야");
	})
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
%>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="SalesArea">
	<div class="SalesMainArea">
		<div class="InputArea">
			<div class="Sales_UserInfo">
				<label id="Company">회사: </label>
				<input type="text" class="Com-code" name="Comcode" id="ComCode" onclick="InfoSearch('ComSearch')" readonly value="Click">
				<label id="User">입력자: </label>
				<input class="UserId" name="UserId" id="UserId" readonly>
			</div>
			<div class="Sales_BizInfo">
				<label id="BizUnit">회계단위: </label>
				<input type="text" class="Biz_Code" name="BizCode" id="BizCode" onclick="InfoSearch('BizSearch')"  readonly value="Click">
				<input type="text" class="Biz_Code_Des" name="BizCodeDes" id="BizCodeDes" readonly>
				<label id="InputDate">입력일자: </label>
				<input type="text" class="InputDate" name="InputDate" id="InputDate" value=<%=todayDate %> readonly> 
			</div>
			<div class="Sales_PlanInfo">
				<label id="PlanYear">계획연도: </label>
				<select class="Year" name="Year" id="Year">
					<option>SELECT</option>
				</select>
			</div>
			<div class="Sales_DocInfo">
				<label id="DocVersion">Plan Version: </label>
				<input type="text" class="DocCode" name="DocCode" id="DocCode" readonly value="Click">
				<input class="DocCodeDes" name="DocCodeDes" id="DocCodeDes" readonly value="Click">
				<label id="CountUnit">수량 입력단위: </label>
				<select class="Unit" name="Unit" id="Unit">
					<option>SELECT</option>
				</select>
			</div>
			<div class="Sales_PlanPeriod">
				<label id="Period">계획기간: </label>
				<input type="text" class="PeriodStart" name="PeriodStart" id="PeriodStart" readonly>
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
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
<script>
function InfoSearch(field){
	event.preventDefault();
	
	var popupWidth = 1000;
    var popupHeight = 600;
    
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
    var UserComCode = $('.UserCompany').val();
    
    if (width == 2560 && height == 1440) {
        xPos = (2560 / 2) - (popupWidth / 2);
        yPos = (1440 / 2) - (popupHeight / 2);
    } else if (width == 1920 && height == 1080) {
        xPos = (1920 / 2) - (popupWidth / 2);
        yPos = (1080 / 2) - (popupHeight / 2);
    } else {
        var monitorWidth = 2560;
        var monitorHeight = 1440;
        xPos = (monitorWidth / 2) - (popupWidth / 2) + dualScreenLeft;
        yPos = (monitorHeight / 2) - (popupHeight / 2) + dualScreenTop;
    }
    
    switch(field){
    case "TradeCom":
    	popupWidth = 550;
    	popupHeight = 610;
    	window.open("${contextPath}/Sales/Popup/FindTradeCom.jsp?ComCode=" + UserComCode, "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    break;
	case "BizArea":
		popupWidth = 550;
		popupHeight = 610;
		window.open("${contextPath}/Sales/Popup/FindBizArea.jsp?ComCode=" + UserComCode, "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	}
}
$(document).ready(function(){
	function InitialTable(){
		$('.PendingTable_Body').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 13; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.ShowInfoTable_Body').append(row);
        }
	}
	InitialTable(); // 1번 테이블 초기화
	var InfoList = [];
	var UserId = $('.UserId').text();
	console.log(UserId);
	var BizArea = {};
	$.ajax({
		type: "POST",
		url: "${contextPath}/Sales/ajax/Sales_BizAreaSearch.jsp",
		data: {Id : UserId},
		success: function(response){
			console.log(response.trim());
			BizArea = response.trim().split(',')
			$('.BizCode').val(BizArea[0]);
			$('.BizCodeDes').val(BizArea[1]);
		}
	});
	
	$('.BalanceAdjDate').change(function(){
		var SalesRoute = $('.DealComCode').val();
		var DispatchDate = $('.BalanceAdjDate').val();
		$.ajax({
			type: "POST",
			url: "${contextPath}/Sales/ajax/Sales_CreateDelPlanNo.jsp",
			data: {Route : SalesRoute, Date : DispatchDate},
			success: function(response){
				console.log(response.trim());
				$('.DeliveryPlanNo').val(response.trim());
			}
		});
	});
	
	$('.DoItBtn').on('click',function(){
		var DealCom = $('.DealComCode').val();
		var DealComDes = $('.DealComCodeDes').val();
		var UCom = $('.UserCompany').val();
		var UBizArea = $('.BizCode').val();
		InfoList = [UCom, UBizArea, DealCom, DealComDes]
		if(DealCom === ''){
			alert('거래처를 선택해주세요.');
			return false;
		} else{
			console.log(InfoList);
			$.ajax({
				url: '${contextPath}/Sales/ajax/CustOrderFetch.jsp',
				type: 'POST',
				data: JSON.stringify(InfoList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data) {
					console.log(data);
					if(data.length > 0){
						$('.ShowInfoTable_Body').empty();
						for(var i = 0 ; i < data.length ; i++){
							var row = '<tr>' +
							'<td><input type="checkbox" class="checkboxBtn"></td>' + //체크 박스
							'<td>' + data[i].DealCom + '</td>' + // 거래처
							'<td>' + data[i].DealComDes + '</td>' + // 거래처명
							'<td>' + data[i].OreNumber + '</td>' + // 고객주문번호
							'<td>' + data[i].Seq + '</td>' + // 항번
							'<td>' + data[i].MatCode + '</td>' + // 품번
							'<td>' + data[i].MatCodeDes + '</td>' + // 품명
							'<td>' + data[i].Unit + '</td>' + // 수량 단위
							'<td>' + data[i].OrderCount + '</td>' + // 주문 수량
							'<td>' + data[i].DelPlanQty + '</td>' + // 납품계획수량
							'<td>' + data[i].DeliveredQty + '</td>' + // 납품완료수량
							'<td>' + data[i].OrderBalance + '</td>' + // 주문잔량
							'<td>' + data[i].DeliverDate + '</td>' + // 납품희망일자
							'</tr>';
							$('.ShowInfoTable_Body').append(row);
						};
					};
				}
			});
		};
	});
})
</script>
</head>
<body>
<%
	String UserId = (String)session.getAttribute("id");
	String UserCompany = (String)session.getAttribute("depart");
%>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<hr>
	<div class="UserId" hidden><%=UserId %></div>
	<div class="DelPlanArea">
		<div class="DelPlan-Main">
			<div class="DelPlan-Main-Header">SEARCH FIELDS</div>
			<div class="DelPlan-Main-Input">
				<label>회사: </label>
				<input type="text" class="UserCompany" value=<%=UserCompany %> readonly>
			</div>
			<div class="DelPlan-Main-Input">
				<label>회계단위: </label>
				<div class="ColumnInput">
					<input class="BizCode" onclick="InfoSearch('BizArea')" readonly>
					<input class="BizCodeDes" readonly>
				</div>
			</div>
			<div class="DelPlan-Main-Input">
				<label>거래처: </label>
				<div class="ColumnInput">
					<input class="DealComCode" placeholder="Select" onclick="InfoSearch('TradeCom')" readonly>
					<input class="DealComCodeDes" readonly>
				</div>
			</div>
			<div class="DelPlan-Main-Input">
				<label>판매경로: </label>
				<div class="ColumnInput">
					<input class="DealComCode" placeholder="Select" onclick="InfoSearch('TradeCom')" readonly>
					<input class="DealComCodeDes" readonly>
				</div>
			</div>
			
			<div class="BtnArea">
				<button class="DoItBtn">실행</button>
			</div>
		</div>
		<div class="DelPlan-Sub">
			<div class="DelPlan-Sub-Header">납품계획 미수립 수주현황</div>
			
			<div class="DelShowInfoArea">
				<table class="PendingTable">
					<thead>
						<th>선택</th><th>고객주문번호</th><th>수주접수일자</th><th>품번</th><th>품명</th><th>수령단위</th><th>주문수량</th><th>납품완료수량</th>
						<th>납품잔량</th><th>납품희망일자</th><th>납품장소</th>
					</thead>
					<tbody class="PendingTable_Body">
					<tr>
						<td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td><td>10</td>
						<td>11</td>
					</tr>
					</tbody>
				</table>
			</div>
			
			<div class="BtnArea">
				<div class="DelPlanBtnSetup">
					<label>반출예정일자: </label>
						<input class="BalanceAdjDate" type="date">
					<label>납품계획번호: </label>
						<input class="DeliveryPlanNo" type="text" readonly>
				</div>
				<button class="custom-button">
					<img src="${contextPath}/img/Dvector.png" alt="Button Image">
	  				<span class="button-text">반영</span>
				</button>
				<button class="SaveBtn">저장</button>
			</div>
			
			<div class="DelResultInfoArea">
				<table class="PlannedTable">
					<thead>
						<th>항번</th><th>고객주문번호</th><th>품번</th><th>품명</th><th>수량단위</th><th>납품잔량</th><th>납품계획수량</th>
					</thead>
					<tbody>
					<tr>
						<td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td>
					</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
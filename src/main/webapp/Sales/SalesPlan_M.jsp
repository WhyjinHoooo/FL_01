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
	
	/*$('.SalesPlanTable_Body').empty();
    
    // 50개의 <tr> 요소 추가
     for (let i = 0; i < 50; i++) {
        const row = $('<tr></tr>'); // 새로운 <tr> 생성

        // 각 <td> 추가 (빈 데이터)
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        row.append('<td></td>');
        // 생성한 <tr>을 <tbody>에 추가
		$('.SalesPlanTable_Body').append(row);
    }*/
	
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
		var NewYearBegin = $(this).val();
		$('.PeriodStart').empty();
		$('.PeriodStart').append("<option>선택</option>")
		for(var i = 1 ; i <=12 ; i++){
			var Month = i.toString().padStart(2, '0'); // 월을 두 자리로 설정
			var Date = `${ "${NewYearBegin}-${Month}-01"}`;
			$('.PeriodStart').append(`<option value=${"${Date}"}>${"${Date}"}</option>`)
		}
		$('.PeriodEnd').val(NewYearBegin + '-12-' +'31')
	})
	
	var UserId = $('.UserId').val();
	var BizArea = {};
	console.log('사용자 아이디 : ' + UserId);
	$.ajax({
		type: "POST",
		url: "${contextPath}/Information/AjaxSet/Sales_BizAreaSearch.jsp",
		data: {Id : UserId},
		success: function(response){
			console.log(response.trim());
			BizArea = response.trim().split(',')
			$('.BizCode').val(BizArea[0]);
			$('.BizCodeDes').val(BizArea[1]);
		}
	})
	
	let Tablebody = $('.SalesPlanTable_Body');
	Tablebody.empty();
	$.ajax({
        url: 'ItemCodeSearch.jsp',
        type: 'GET',
        dataType: 'json', // 데이터 형식에 맞게 조정
        success: function(data) {
            for (let i = 0; i < 50; i++) {
                const row = $('<tr></tr>');

                const hiddenCell = $('<td style="display:none;"></td>').text(i+1);
                row.append(hiddenCell); // 숨겨진 <td> 추가
                
                // 첫 번째 <td>에 <select> 추가
                const select = $('<select></select>');
                const defaultOption = $('<option></option>')
                .val('') // 기본 옵션의 value는 빈 문자열
                .text('선택'); // 기본 옵션의 텍스트
            	select.append(defaultOption);
                
                data.forEach(item => {
                    const option = $('<option></option>')
                        .val(`${ "${item.ProductCode}" },${"${item.ProductName}" },${ "${item.ProductUnit}" }`)
                        .text(`${ "${item.ProductCode}" }`);
                    select.append(option);
                });

                row.append($('<td></td>').append(select));

                // 두 번째 <td>에 품목명 추가
                const productNameCell = $('<td></td>');
                select.on('change', function() {
                    const selectedValue = $(this).val().split(',');
                    productNameCell.text(selectedValue[1]); // 품목명
                });
                row.append(productNameCell);

                // 세 번째 <td>에 단위 추가
                const productUnitCell = $('<td></td>');
                select.on('change', function() {
                    const selectedValue = $(this).val().split(',');
                    productUnitCell.text(selectedValue[2]); // 단위
                });
                row.append(productUnitCell);

                // 네 번째와 다섯 번째 <td>에 <input> 추가
                for (let j = 0; j < 12; j++) {
                    const input = $('<input type="text" />');
                    row.append($('<td></td>').append(input));
                }

                // <tbody>에 추가
                /* $('.SalesPlanTable_Body').append(row); */
                Tablebody.append(row);
                
            }
            var CountUnit = null;

         	// 'Unit' 클래스의 <select>에서 값이 변경될 때
         	$('.Unit').change(function() {
            CountUnit = parseInt($(this).val()); // 선택한 값을 정수로 변환
            console.log('CountUnit:', CountUnit);
	        });
	
	        // 'SalesPlanTable_Body' 내의 각 <tr>에 대해
         	$('.SalesPlanTable_Body').find('tr').each(function() {
         	    // <td> 요소들 중 4번째 인덱스 이상의 <td>를 찾고, <input>에 대한 이벤트 리스너 추가
         	    $(this).find('td:gt(3)').find('input').on('keydown', function(event) {
         	        // Enter(키 코드 13) 키가 눌렸는지 확인
         	        if (event.key === 'Enter') {
         	            event.preventDefault(); // 기본 동작 방지 (폼 제출 방지)

         	            // 사용자가 입력한 값
         	            var userInput = parseInt($(this).val()) || 0; // 입력값이 없으면 0으로 처리
         	            
         	            // 계산된 값
         	            var calculatedValue = userInput * CountUnit;

         	            // 계산된 값을 3자리 구분 기호를 포함하여 표시
         	            $(this).val(calculatedValue.toLocaleString('en-US'));
         	            /* console.log('Calculated value:', $(this).val()); */
         	        }
         	    });
         	});
       },
	       error: function(xhr, status, error) {
	           console.error('AJAX Error: ', status, error);
	       }
    });
	var DateList = {};
	$('.PeriodStart').change(function(){
		var SelectedStartedDate = $(this).val();
		DateList = SelectedStartedDate.split('-');
		let Tablebody = $('.SalesPlanTable_Body');
		var month = parseInt(DateList[1]);
		
		Tablebody.find('tr').each(function(){
	        $(this).find('td').find('input, select, textarea').prop('disabled', false);
	    });
		
		if (month >= 2 && month <= 12) {
	        Tablebody.find('tr').each(function() {
	            for (let i = 4; i < 4 + (month - 1); i++) {  // 다섯 번째 td부터 시작
	                $(this).find('td').eq(i).find('input, select, textarea').prop('disabled', true);
	            }
	        });
	    }
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
	<div class="SalesSubArea">
		<table class="SalesPlanTable">
			<thead class="SalesPlanTable_Head">
				<th>품목코드</th><th>품목명</th><th>단위</th>
				<th>1일</th><th>2일</th><th>3일</th><th>4일</th><th>5일</th><th>6일</th><th>7일</th>
				<th>8일</th><th>9일</th><th>10일</th><th>11일</th><th>12일</th><th>13일</th><th>14일</th>
				<th>15일</th><th>16일</th><th>17일</th><th>18일</th><th>19일</th><th>20일</th><th>21일</th>
				<th>22일</th><th>23일</th><th>24일</th><th>25일</th><th>26일</th><th>27일</th><th>28일</th>
				<th>29일</th><th>30일</th><th>31일</th>
			</thead>
			<tbody class="SalesPlanTable_Body">
			<!-- 23개의 <tr>...</tr> 들어가면 스크롤바가 생성됨-->
				<!-- <tr>
					<td>FERT-10001</td><td>완제품 10001</td><td>EA</td>
					<td>1</td><td>2</td><td>3</td><td>4</td>
					<td>5</td><td>6</td><td>7</td><td>8</td>
					<td>9</td><td>10</td><td>11</td><td>12</td>
				</tr> -->
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
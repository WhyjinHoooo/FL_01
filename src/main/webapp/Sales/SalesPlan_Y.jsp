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
    
    var UserComCode = $('.Com-code').val();
    
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
    case "PlanVer":
    	var PlanYear = $('.Year').val();
    	console.log(UserComCode);
    	popupWidth = 550;
    	popupHeight = 610;
    	window.open("${contextPath}/Sales/Popup/FindPlanVersion_Y.jsp?ComCode=" + UserComCode + "&Year=" + PlanYear, "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "TradeCom":
    	popupWidth = 550;
    	popupHeight = 610;
    	window.open("${contextPath}/Sales/Popup/FindTradeCom.jsp?ComCode=" + UserComCode, "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    }
}
$(document).ready(function(){
	function InitialPage(){
		$('.SalesPlanTable_Body').empty();
	    
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
	    }
	}
	
	InitialPage();
	
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
	
	$('.DocCode').change(function(){
		/* var NewYearBegin = $(this).val();
		$('.PeriodStart').empty();
		$('.PeriodStart').append("<option>선택</option>")
		for(var i = 1 ; i <=12 ; i++){
			var Month = i.toString().padStart(2, '0'); // 월을 두 자리로 설정
			var Date = `${ "${NewYearBegin}-${Month}-01"}`;
			$('.PeriodStart').append(`<option value=${"${Date}"}>${"${Date}"}</option>`)
		}
		$('.PeriodEnd').val(NewYearBegin + '-12-' +'31') */
		var PlanCode = $(this).val();
		var PlaningYear = $('.Year').val();
		var DateGroup = {};
		$.ajax({
			type: "POST",
			url: '${contextPath}/Sales/ajax/FindPlanVersion.jsp',
			data: {PV : PlanCode},
			success: function(Data){
				console.log(Data.trim());
				DateGroup = Data.trim().split(',')
				console.log(DateGroup[0]);
				console.log(DateGroup[1]);
				/* if(parseInt(DateGroup[1]) == 1){
					$('.PeriodStart').val(Data);
				} else{
					console.log(DateGroup[0] + '-' + ((parseInt(DateGroup[1]))+1).toString().padStart(2,'0') +'-'+ DateGroup[2]);
					$('.PeriodStart').val(DateGroup[0] + '-' + ((parseInt(DateGroup[1]))+1).toString().padStart(2,'0') +'-'+ DateGroup[2]);
				} */
				$('.PeriodStart').val(DateGroup[0]);
				$('.PeriodEnd').val(DateGroup[1])
			}
			
		})
	})
	
	var UserId = $('.UserId').val();
	var BizArea = {};
	console.log('사용자 아이디 : ' + UserId);
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
	})
	
	$('.DealComCode').change(function(){
		var TradeCompany = $(this).val();
		console.log(TradeCompany);
		let Tablebody = $('.SalesPlanTable_Body');
		Tablebody.empty();
		$.ajax({
	        url: '${contextPath}/Sales/ajax/ItemCodeSearch.jsp',
	        type: 'GET',
	        data: {DealCom : TradeCompany},
	        dataType: 'json', // 데이터 형식에 맞게 조정
	        success: function(data) {
	        	var PlanningDateList = {};
	        	PlanningDateList = $('.PeriodStart').val().split('-');
	        	if (!data || data.length === 0) {  // data가 비어있거나 없는 경우
	                alert('해당 거래처는 아직 등록되지 않았습니다.');
	        		return false;
	            } else{
					for (let i = 0; i < 50; i++) {
						const row = $('<tr></tr>');
						
						// 첫 번째 <td>의 품목들 순번
		                const hiddenCell = $('<td style="display:none;"></td>').text(i+1);
		                row.append(hiddenCell); // 숨겨진 <td> 추가
		                
		                // 두 번째 <td>에 <select> 추가
		                const select = $('<select></select>');
		                const defaultOption = $('<option></option>')
		                .val('') // 기본 옵션의 value는 빈 문자열
		                .text('선택'); // 기본 옵션의 텍스트
		            	select.append(defaultOption);
		                
		                data.forEach(item => {
		                    const option = $('<option></option>')
		                        .val(`${ "${item.ProductCode}" },${"${item.ProductName}" },${ "${item.ProductUnit}" },${ "${item.DealRate}" }`)
		                        .text(`${ "${item.ProductCode}" }`);
		                    select.append(option);
		                });

		                row.append($('<td></td>').append(select));

		                // 세 번째 <td>에 품목명 추가
		                
// 		                const productNameCell = $('<td></td>');
// 		                select.on('change', function() {
// 		                    const selectedValue = $(this).val().split(',');
// 		                    productNameCell.text(selectedValue[1]); // 품목명
// 		                });
// 		                row.append(productNameCell);

		                
		                const productNameCell = $('<td></td>');
		                select.on('change', function() {
		                    const selectedValue = $(this).val().split(',');
		                    
		                    // <input> 요소 생성
		                    const inputElement = $('<input>', {
		                        type: 'text',
		                        value: selectedValue[1],  // selectedValue[1]을 value로 설정
		                        readonly: true,            // readonly 속성 추가
		                        class: 'readonly-input'    // 선택적으로 class 추가 가능
		                    });

		                    // 생성된 <input>을 <td> 안에 추가
		                    productNameCell.empty().append(inputElement);  // 기존 내용은 지우고 input 추가
		                });
		                row.append(productNameCell);

		                // 네 번째 <td>에 단위 추가
		                const productUnitCell = $('<td></td>');
		                select.on('change', function() {
		                	const selectedValue = $(this).val() ? $(this).val().split(',') : [];
		                    if (selectedValue.length === 0) { // 배열이 비어 있는지 확인
		                    	productUnitCell.text(""); // 단위
		                    }else{
		                    	productUnitCell.text(selectedValue[2]); // 단위
		                    }
		                });
		                row.append(productUnitCell);

		                // 다섯 번째부터 열여섯 번째까지 <td>에 <input> 추가
		                for (let j = 0; j < 12; j++) {
		                    const input = $('<input type="text" />');
		                    
		                    if (parseInt(PlanningDateList[1], 10) > 1 && j < parseInt(PlanningDateList[1], 10) - 1) {
		                        input.prop('disabled', true);
		                    }
		                    
		                    row.append($('<td></td>').append(input));
		                }

		                // <tbody>에 추가
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
		         	            var calculatedValue = userInput;

		         	            // 계산된 값을 3자리 구분 기호를 포함하여 표시
		         	            $(this).val(calculatedValue.toLocaleString('en-US'));
		         	        }
		         	    });
		         	});
	            }   
	       },
		   error: function(xhr, status, error) {
				console.error('AJAX Error: ', status, error);
			}
	    });
	})
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
	$('.Year').change(function() {
	    InitialPage();
	    const resetElements = [
	        ".DocCode", ".DocCodeDes", 
	        ".PeriodStart", ".PeriodEnd", 
	        ".DealComCode", ".DealComCodeDes"
	    ];
	    resetElements.forEach(selector => {
	        const element = document.querySelector(selector);
	        if (element) {
	            if (selector === ".DocCode" || selector === ".DealComCode") {
	                element.value = 'Click';  // DocCode만 다르게 설정
	            } else {
	                element.value = '';  // 나머지는 빈 값으로 초기화
	            }
	        }
	    });
	});
	// SaveBtn 클릭 시 데이터 저장 프로세스
	$('.SaveBtn').on('click', function() {
	    var SaveList = {};  // 저장할 객체

	    // 모든 <tr> 요소를 순회하면서 데이터 추출
	    $('table tr').each(function(index, tr) {
	        // 해당 <tr> 내부의 <td> 요소들 찾기
	        var $tr = $(tr);
	        var rowNumber = $tr.find('td:first').text();  // 순번에 해당하는 첫 번째 <td> 텍스트
	        var selectedOptionValue = $tr.find('select option:selected').val(); // 선택된 <option>의 value
	        
	        // 값이 입력된 <tr>인지 확인
	        if (selectedOptionValue) {
	            // 데이터를 배열로 저장
	            var rowData = [selectedOptionValue];
	            console.log(rowData);
	            
	            rowData.push($('.DocCode').val());
	            rowData.push($('.DealComCode').val());
	            rowData.push($('.Unit').val());
	            rowData.push($('.Year').val());
	            rowData.push($('.BizCode').val());
	            rowData.push($('.Com-code').val());
	            
	            // 순서대로 각 <td>의 <input> 요소 값을 배열에 추가
	            $tr.find('td input[type="text"]').each(function() {
	                rowData.push($(this).val());
	            });
	            
	            // SaveList에 rowNumber를 key로 rowData를 value로 저장
	            SaveList[rowNumber] = rowData;
	        }
	    });

	    // 확인용 콘솔 출력
	    console.log(SaveList);
	    
	    $.ajax({
	    	url:'${contextPath}/Sales/ajax/SalesListSave.jsp',
	    	type:'POST',
	    	data: JSON.stringify(SaveList),
	    	contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(data) {
		        if (data.status === "Success") {
		        	InitialPage();
		        	const resetElements = [
		        		".Year",
		    	        ".DocCode", ".DocCodeDes", 
		    	        ".PeriodStart", ".PeriodEnd", 
		    	        ".DealComCode", ".DealComCodeDes"
		    	    ];
		    	    resetElements.forEach(selector => {
		    	        const element = document.querySelector(selector);
		    	        if (element) {
		    	            if (selector === ".DocCode" || selector === ".DealComCode") {
		    	                element.value = 'Click';  // DocCode만 다르게 설정
		    	            } else if(selector === ".Year"){
		    	            	element.value = 'SELECT';
		    	            } else {
		    	                element.value = '';  // 나머지는 빈 값으로 초기화
		    	            }
		    	        }
		    	    });
		            console.log('저장되었습니다.');
		        } else {
		            console.log('저장 실패');
		        }
		    },
		    error: function(xhr, status, error) {
		        console.log('AJAX 요청 실패:', error);
		    }
	    })
	});

	
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
			<div class="Sales_PlanInfo">
				<label id="PlanYear">계획연도: </label>
				<select class="Year" name="Year" id="Year">
					<option>SELECT</option>
				</select>
			</div>
			<div class="Sales_DocInfo">
				<label id="DocVersion">Plan Version: </label>
				<input type="text" class="DocCode" name="DocCode" id="DocCode" onclick="InfoSearch('PlanVer')" readonly value="Click">
				<input class="DocCodeDes" name="DocCodeDes" id="DocCodeDes" readonly>
				<label id="CountUnit">수량 입력단위: </label>
				<select class="Unit" name="Unit" id="Unit">
					<option value="1">1</option>
					<option value="1000">1,000</option>
					<option value="10000">10,000</option>
					<option value="1000000">1,000,000</option>
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
				<input class="DealComCode" name="DealComCode" id="DealComCode" onclick="InfoSearch('TradeCom')" readonly value="Click">
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
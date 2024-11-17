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
<%

LocalDateTime today = LocalDateTime.now();
DateTimeFormatter formatter_YMD = DateTimeFormatter.ofPattern("yyyy-MM-dd");
DateTimeFormatter formatter_Y = DateTimeFormatter.ofPattern("yyyy");
String todayDate = today.format(formatter_YMD);
String Year = today.format(formatter_Y);
%>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const tbody = document.querySelector('.SalesPlanTable_Body_Month');
    const thead = document.querySelector('.SalesPlanTable_Head_Month');

    tbody.addEventListener('scroll', function() {
        thead.scrollLeft = tbody.scrollLeft; // thead의 스크롤 위치를 직접 설정
    });
});

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
    var UserComCode = $('.Com-code').val();
    
    switch(field){
    case "PlanVer":
    	var PlanYear = <%=Year%> + 1;
    	console.log(UserComCode);
    	popupWidth = 550;
    	popupHeight = 610;
    	window.open("${contextPath}/Sales/Popup/FindPlanVersion_M.jsp?ComCode=" + UserComCode + "&Year=" + PlanYear, "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "TradeCom":
    	popupWidth = 550;
    	popupHeight = 610;
    	window.open("${contextPath}/Sales/Popup/FindTradeCom.jsp?ComCode=" + UserComCode, "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    }
    
}
$(document).ready(function(){
// 	$('.SalesPlanTable_Body_Month').empty();
    // 50개의 <tr> 요소 추가
    function InitialPage(){
    	$('.SalesPlanTable_Body_Month').empty();
    	for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 34; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.SalesPlanTable_Body_Month').append(row);
        }
    }
    InitialPage();
    
	var UserId = $('.UserId').val();
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
	})
	$('.PeriodStart').change(function(){
		var Start = $('.PeriodStart').val().substring(5,7);
		var End = $('.PeriodEnd').val().substring(5,7);
		var Year = <%=Year%> + 1;
		
		var StartMonth = parseInt(Start, 10);
		var EndMonth = parseInt(End, 10);
		console.log(StartMonth);
		console.log(EndMonth);
		var StartValue = null;
		for(var i = StartMonth; i <= EndMonth ; i++){
			StartValue = Year + "." + i.toString().padStart(2,'0') + "월";
			$('.Month').append(`<option value=${"${StartValue}"}>${"${StartValue}"}</option>`);
// 	        $('.Month').append('<option value="' + StartValue + '">' + StartValue + '</option>');
//			템플릿 리터럴(Template Literal)를 사용하지 않는 방법
		}
	})
	
	$('.DealComCode').change(function(){
		var TradeCompany = $(this).val();
		console.log(TradeCompany);
		let Tablebody = $('.SalesPlanTable_Body_Month');
		Tablebody.empty();
		$.ajax({
	        url: '${contextPath}/Sales/ajax/ItemCodeSearch.jsp',
	        type: 'GET',
	        data: {DealCom : TradeCompany},
	        dataType: 'json', // 데이터 형식에 맞게 조정
	        success: function(data) {
	        	var PlanningDateList = {};
	        	PlanningDateList = $('.PeriodStart').val().split('-');
	        	console.log(PlanningDateList);
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
		                for (let j = 0; j < 31; j++) {
		                    const input = $('<input type="text" />');
		                    
		                    /* if (parseInt(PlanningDateList[1], 10) > 1 && j < parseInt(PlanningDateList[1], 10) - 1) {
		                        input.prop('disabled', true);
		                    } */
		                    
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
var DateSetting = [];
$('.Month').change(function() {
    // 선택된 값을 년도와 월로 분리하여 DateSetting 배열에 저장
    DateSetting = $(this).val().split('.'); 
    var year = parseInt(DateSetting[0], 10); // 선택된 년도
    var month = parseInt(DateSetting[1].replace('월', ''), 10); // 선택된 월, '월'을 제거한 후 숫자로 변환
    // 최대 일수를 계산하기 위한 변수 
    var maxDays = 31;

    // 2월의 경우: 윤년을 고려하여 최대 일수를 결정
    if (month === 2) {
        maxDays = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) ? 29 : 28; // 윤년이면 29일, 아니면 28일
    } else if (month === 4 || month === 6 || month === 9 || month === 11) {
        // 4, 6, 9, 11월은 30일
        maxDays = 30;
    }
    console.log(maxDays);

    // SalesPlanTable_Body_Month의 각 <td>에 대해 <input>을 설정
    $('.SalesPlanTable_Body_Month tr').each(function(rowIndex) {
        $(this).find('td').each(function(index) {
            var input = $(this).find('input'); // <td> 안에 있는 <input> 요소

            // 5번째부터 35번째까지 <td>만 처리 (index 기준)
            if (index >= 4 && index < 35) {
                console.log("Valid index: " + index); // 조건을 만족하는 index인지 확인

                // maxDays + 4보다 작은 index에 대해서 활성화 처리
                if (index < maxDays + 4) {
                    console.log("Enabling input for index " + index); // 활성화 처리
                    input.prop('disabled', false);
                } else {
                    console.log("Disabling input for index " + index); // 비활성화 처리
                    input.prop('disabled', true);
                }
            }
        });
    });

});
	
	$('.DocCode').change(function() {
	    InitialPage();
	    const resetElements = [
	        ".Month", ".DealComCode",".DealComCodeDes"
	    ];
	    resetElements.forEach(selector => {
	        const element = document.querySelector(selector);
	        if (element) {
	            if (selector === ".Month") {
	                element.value = 'SELECT';  // DocCode만 다르게 설정
	            } else if(selector === ".DealComCode"){
	                element.value = 'Click';  // 나머지는 빈 값으로 초기화
	            } else{
	            	element.value = '';
	            }
	        }
	    });
	});
	var ClickCount = 0;
	var OptionList = [];
	$('.SaveBtn').on('click', function() {
		var OptionCount = $('.Month option').length - 1;
		var SelectedOption = $('.Month option:selected').val();
		OptionList.push(SelectedOption);
		console.log(OptionList);
		console.log('SelectedOption ' + SelectedOption);
		console.log('OptionCount ' + OptionCount);
		console.log('Before ' + ClickCount);
		ClickCount++;
		console.log('After ' + ClickCount);
	    var SaveList = {};  // 저장할 객체

// 	    // 모든 <tr> 요소를 순회하면서 데이터 추출
// 	    $('table tr').each(function(index, tr) {
// 	        // 해당 <tr> 내부의 <td> 요소들 찾기
// 	        var $tr = $(tr);
// 	        var rowNumber = $tr.find('td:first').text();  // 순번에 해당하는 첫 번째 <td> 텍스트
// 	        var selectedOptionValue = $tr.find('select option:selected').val(); // 선택된 <option>의 value
	        
// 	        // 값이 입력된 <tr>인지 확인
// 	        if (selectedOptionValue) {
// 	            // 데이터를 배열로 저장
// 	            var rowData = [selectedOptionValue];
// 	            console.log(rowData);
	            
// 	            rowData.push($('.DocCode').val());
// 	            rowData.push($('.DealComCode').val());
// 	            rowData.push($('.Unit').val());
// 	            rowData.push($('.Year').val());
// 	            rowData.push($('.BizCode').val());
// 	            rowData.push($('.Com-code').val());
	            
// 	            // 순서대로 각 <td>의 <input> 요소 값을 배열에 추가
// 	            $tr.find('td input[type="text"]').each(function() {
// 	                rowData.push($(this).val());
// 	            });
	            
// 	            // SaveList에 rowNumber를 key로 rowData를 value로 저장
// 	            SaveList[rowNumber] = rowData;
// 	        }
// 	    });

// 	    // 확인용 콘솔 출력
// 	    console.log(SaveList);
	    
// 	    $.ajax({
// 	    	url:'${contextPath}/Sales/ajax/SalesListSave.jsp',
// 	    	type:'POST',
// 	    	data: JSON.stringify(SaveList),
// 	    	contentType: 'application/json; charset=utf-8',
// 			dataType: 'json',
// 			async: false,
// 			success: function(data) {
// 		        if (data.status === "Success") {
// 		        	InitialPage();
// 		        	const resetElements = [
// 		        		".Year",
// 		    	        ".DocCode", ".DocCodeDes", 
// 		    	        ".PeriodStart", ".PeriodEnd", 
// 		    	        ".DealComCode", ".DealComCodeDes"
// 		    	    ];
// 		    	    resetElements.forEach(selector => {
// 		    	        const element = document.querySelector(selector);
// 		    	        if (element) {
// 		    	            if (selector === ".DocCode" || selector === ".DealComCode") {
// 		    	                element.value = 'Click';  // DocCode만 다르게 설정
// 		    	            } else if(selector === ".Year"){
// 		    	            	element.value = 'SELECT';
// 		    	            } else {
// 		    	                element.value = '';  // 나머지는 빈 값으로 초기화
// 		    	            }
// 		    	        }
// 		    	    });
// 		            console.log('저장되었습니다.');
// 		        } else {
// 		            console.log('저장 실패');
// 		        }
// 		    },
// 		    error: function(xhr, status, error) {
// 		        console.log('AJAX 요청 실패:', error);
// 		    }
// 	    })
	});
	
})
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%	
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
				<input type="text" class="DocCode" name="DocCode" id="DocCode" readonly value="Click" onclick="InfoSearch('PlanVer')">
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
				<input class="DealComCode" name="DealComCode" id="DealComCode" readonly value="Click" onclick="InfoSearch('TradeCom')">
				<input class="DealComCodeDes" name="DealComCodeDes" id="DealComCodeDes" readonly>
			</div>
			<div class="Sales_PlanInfo">
				<label id="PlanYear">계획년월: </label>
				<select class="Month" name="Month" id="Month">
					<option>SELECT</option>
				</select>
			</div>
		</div>
	</div>
	<div class="ButtonArea">
		<button class="SaveBtn">저장</button>
	</div>
	<div class="SalesSubArea_Month">
	    <table class="SalesPlanTable_Month">
	        <thead class="SalesPlanTable_Head_Month">
	            <tr>
	                <th>품목코드</th><th>품목명</th><th>단위</th>
	                <th>1일</th><th>2일</th><th>3일</th><th>4일</th><th>5일</th><th>6일</th><th>7일</th>
	                <th>8일</th><th>9일</th><th>10일</th><th>11일</th><th>12일</th><th>13일</th><th>14일</th>
	                <th>15일</th><th>16일</th><th>17일</th><th>18일</th><th>19일</th><th>20일</th><th>21일</th>
	                <th>22일</th><th>23일</th><th>24일</th><th>25일</th><th>26일</th><th>27일</th><th>28일</th>
	                <th>29일</th><th>30일</th><th>31일</th>
	            </tr>
	        </thead>
	        <tbody class="SalesPlanTable_Body_Month"></tbody>
	    </table>
	</div>
</div>
</body>
</html>
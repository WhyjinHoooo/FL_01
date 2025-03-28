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
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    console.log(dualScreenLeft);
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
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
    
    var UserComCode = $('.Com-code').val();
    
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
	     for (let i = 0; i < 50; i++) {
	        const row = $('<tr></tr>');
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
		var PlanCode = $(this).val();
		var PlaningYear = $('.Year').val();
		var DateGroup = {};
		$.ajax({
			type: "POST",
			url: '${contextPath}/Sales/ajax/Planning/FindPlanVersion.jsp',
			data: {PV : PlanCode},
			success: function(Data){
				console.log(Data.trim());
				DateGroup = Data.trim().split(',')
				console.log(DateGroup[0]);
				console.log(DateGroup[1]);
				$('.PeriodStart').val(DateGroup[0]);
				$('.PeriodEnd').val(DateGroup[1])
			}
			
		})
	})
	
	var UserId = $('.UserId').val();
	var BizArea = {};
	$.ajax({
		type: "POST",
		url: "${contextPath}/Sales/ajax/Planning/Sales_BizAreaSearch.jsp",
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
		var DocCode = $('.DocCode').val();
		let Tablebody = $('.SalesPlanTable_Body');
		Tablebody.empty();
		$.ajax({
	        url: '${contextPath}/Sales/ajax/Planning/ItemCodeSearch.jsp',
	        type: 'GET',
	        data: {DealCom : TradeCompany, PlanVer : DocCode},
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
		                const hiddenCell = $('<td style="display:none;"></td>').text(i+1);
		                row.append(hiddenCell);
		                const select = $('<select></select>');
		                const defaultOption = $('<option></option>').val('').text('선택');
		            	select.append(defaultOption);
		                
		                data.forEach(item => {
		                    const option = $('<option></option>')
		                        .val(`${ "${item.ProductCode}" },${"${item.ProductName}" },${ "${item.ProductUnit}" },${ "${item.DealRate}" }`)
		                        .text(`${ "${item.ProductCode}" }`);
		                    select.append(option);
		                });
		                row.append($('<td></td>').append(select));
		                const productNameCell = $('<td></td>');
		                select.on('change', function() {
		                    const selectedValue = $(this).val().split(',');
		                    
		                    // <input> 요소 생성
		                    const inputElement = $('<input>', {
		                        type: 'text',
		                        value: selectedValue[1],
		                        readonly: true,
		                        class: 'readonly-input'
		                    });
		                    productNameCell.empty().append(inputElement);
		                });
		                row.append(productNameCell);
		                const productUnitCell = $('<td></td>');
		                select.on('change', function() {
		                	const selectedValue = $(this).val() ? $(this).val().split(',') : [];
		                    if (selectedValue.length === 0) {
		                    	productUnitCell.text("");
		                    }else{
		                    	productUnitCell.text(selectedValue[2]);
		                    }
		                });
		                row.append(productUnitCell);
		                for (let j = 0; j < 12; j++) {
		                    const input = $('<input type="text" />');
		                    if (parseInt(PlanningDateList[1], 10) > 1 && j < parseInt(PlanningDateList[1], 10) - 1) {
		                        input.prop('disabled', true);
		                    }
		                    row.append($('<td></td>').append(input));
		                }
		                Tablebody.append(row);
		            	}
		            	var CountUnit = null;
		         	$('.Unit').change(function() {
		            CountUnit = parseInt($(this).val());
		            console.log('CountUnit:', CountUnit);
			        });
		         	$('.SalesPlanTable_Body').find('tr').each(function() {
		         	    $(this).find('td:gt(3)').find('input').on('keydown', function(event) {
		         	        if (event.key === 'Enter') {
		         	            event.preventDefault();
		         	            var userInput = parseInt($(this).val()) || 0;
		         	            var calculatedValue = userInput;
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
	$('.SaveBtn').on('click', function() {
	    var SaveList = {};
	    $('table tr').each(function(index, tr) {
	        var $tr = $(tr);
	        var rowNumber = $tr.find('td:first').text();
	        var selectedOptionValue = $tr.find('select option:selected').val();
	        if (selectedOptionValue) {
	            var rowData = [selectedOptionValue];
	            rowData.push($('.DocCode').val());
	            rowData.push($('.DealComCode').val());
	            rowData.push($('.Unit').val());
	            rowData.push($('.Year').val());
	            rowData.push($('.BizCode').val());
	            rowData.push($('.Com-code').val());
	            $tr.find('td input[type="text"]').each(function() {
	                rowData.push($(this).val());
	            });
	            SaveList[rowNumber] = rowData;
	        }
	    });
	    $.ajax({
	    	url:'${contextPath}/Sales/ajax/Planning/SalesListSave.jsp',
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
		    	                element.value = '';
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
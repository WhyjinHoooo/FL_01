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
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
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
    function InitialPage(){
    	$('.SalesPlanTable_Body_Month').empty();
    	for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>');
            for (let j = 0; j < 34; j++) {
                row.append('<td></td>');
            }
            $('.SalesPlanTable_Body_Month').append(row);
        }
    }
	InitialPage();
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
		}
	})
	
	$('.DealComCode').change(function(){
		var TradeCompany = $(this).val();
		var PlanVer = $('.DocCode').val();
		console.log(TradeCompany);
		let Tablebody = $('.SalesPlanTable_Body_Month');
		Tablebody.empty();
		$.ajax({
	        url: '${contextPath}/Sales/ajax/Planning/ItemCodeSearch.jsp',
	        type: 'GET',
	        data: {DealCom : TradeCompany, PlanVer : PlanVer},
	        dataType: 'json',
	        success: function(data) {
	        	var PlanningDateList = {};
	        	PlanningDateList = $('.PeriodStart').val().split('-');
	        	console.log(PlanningDateList);
	        	if (!data || data.length === 0) {
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
		                    	productUnitCell.text(selectedValue[2]); // 단위
		                    }
		                });
		                row.append(productUnitCell);

		                for (let j = 0; j < 31; j++) {
		                    const input = $('<input type="text" />');
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
var DateSetting = [];
$('.Month').change(function() {
    DateSetting = $(this).val().split('.'); 
    var year = parseInt(DateSetting[0], 10);
    var month = parseInt(DateSetting[1].replace('월', ''), 10);
    var maxDays = 31;

    if (month === 2) {
        maxDays = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) ? 29 : 28;
    } else if (month === 4 || month === 6 || month === 9 || month === 11) {
        maxDays = 30;
    }
    console.log(maxDays);
    $('.SalesPlanTable_Body_Month tr').each(function(rowIndex) {
        $(this).find('td').each(function(index) {
            var input = $(this).find('input');
            if (index >= 4 && index < 35) {
                if (index < maxDays + 4) {
                    input.prop('disabled', false);
                } else {
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
	                element.value = 'SELECT';
	            } else if(selector === ".DealComCode"){
	                element.value = 'Click';
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
		if(OptionList.length === 0){
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
		            rowData.push($('.Month').val());
		            rowData.push($('.BizCode').val());
		            rowData.push($('.Com-code').val());
		            $tr.find('td input[type="text"]').each(function() {
		                rowData.push($(this).val());
		            });
		            SaveList[rowNumber] = rowData;
		        }
		    });
		    console.log(SaveList);
			$.ajax({
		    	url:'${contextPath}/Sales/ajax/Planning/SalesListSave_M.jsp',
		    	type:'POST',
		    	data: JSON.stringify(SaveList),
		    	contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data) {
			        if (data.status === "Success") {
			        	$('.SalesPlanTable_Body_Month tr').each(function(rowIndex) {
			                $(this).find('td').each(function(index) {
			                    var select = $(this).find('select');
			                    var input = $(this).find('input');

			                    if (index >= 1 && index < 35) {
			                        if (select.length > 0) {
			                        	select.val('');
			                            select.trigger('change');
			                        }
			                        if(input.length > 0){
			                        	input.val('');
			                        }
			                        if(select.length === 0 && input.length === 0){
			                        	$(this).val('');
			                        } 
			                        
			                    }
			                });
			            });
			        }
			    },
			    error: function(xhr, status, error) {
			        console.log('AJAX 요청 실패:', error);
			    }
		    });
			OptionList.push(SelectedOption);
			ClickCount++;  
		} else{
			var alreadyExists = OptionList.some(function(option) {
	            return option === SelectedOption;
	        });
	        
	        if (alreadyExists) {
	            alert('해당 월의 계획은 등록되었습니다. \n 다시 선택해주세요.');
	            return false;
	        }
			var SaveList = {};
			$('table tr').each(function(index, tr) {
		        var $tr = $(tr);
		        var rowNumber = $tr.find('td:first').text();
		        var selectedOptionValue = $tr.find('select option:selected').val();

		        if (selectedOptionValue) {
		            var rowData = [selectedOptionValue];
		            console.log(rowData);
		            
		            rowData.push($('.DocCode').val());
		            rowData.push($('.DealComCode').val());
		            rowData.push($('.Unit').val());
		            rowData.push($('.Month').val());
		            rowData.push($('.BizCode').val());
		            rowData.push($('.Com-code').val());
		            $tr.find('td input[type="text"]').each(function() {
		                rowData.push($(this).val());
		            });
		            SaveList[rowNumber] = rowData;
		        }
		    });
		    console.log(SaveList);
			$.ajax({
		    	url:'${contextPath}/Sales/ajax/Planning/SalesListSave_M.jsp',
		    	type:'POST',
		    	data: JSON.stringify(SaveList),
		    	contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data) {
			        if (data.status === "Success") {
			        	$('.SalesPlanTable_Body_Month tr').each(function(rowIndex) {
			                $(this).find('td').each(function(index) {
			                    var select = $(this).find('select');
			                    var input = $(this).find('input');
			                    if (index >= 1 && index < 35) {
			                        if (select.length > 0) {
			                        	select.val('선택');
			                        	select.find('option[value=""]').prop('selected', true);
			                            select.trigger('change');
			                        }
			                        if(input.length > 0){
			                        	input.val('');
			                        }
			                        if(select.length === 0 && input.length === 0){
			                        	$(this).val('');
			                        } 
			                        
			                    }
			                });
			            });
			        }
			    },
			    error: function(xhr, status, error) {
			        console.log('AJAX 요청 실패:', error);
			    }
		    });
			OptionList.push(SelectedOption);
			ClickCount++;  
		}
		 
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
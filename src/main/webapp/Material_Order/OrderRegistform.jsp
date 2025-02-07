<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>자재발주</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
var path = window.location.pathname;
var Address = path.split("/").pop();
window.addEventListener('unload', (event) => {
	// beforeunload를 사용할 경우, Form문에서 snbmit의 기능을 가진 버튼을 사용하면 페이지가 이동하게 되는데, 이를 새로고침으로 인식하여 
	// 임시저장테이블에 있는 데이터를 삭제해서 정성적으로 작동이 안됨
	// 따라서 unload를 사용
	var data = {
		action : 'deleteOrderData',
		page : Address
			
	}
    navigator.sendBeacon('../DeleteOrder', JSON.stringify(data));
});
	
function InfoSearch(field){
	var popupWidth = 500;
    var popupHeight = 600;
    
    // 현재 활성화된 모니터의 위치를 감지
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
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
    
    var ComCode = $('.ComCode').val();
    var VenCode = document.querySelector('.VendorCode').value;
    
    switch(field){
    case "ComSearch":
    	window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "PlantSearch":
    	window.open("${contextPath}/Information/PlantSerach.jsp?ComCode=" + ComCode, "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "VendorSearch":
    	window.open("${contextPath}/Information/VendorSerach.jsp?ComCode=" + ComCode, "PopUp04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "OrdTypeSearch":
    	window.open("${contextPath}/Material_Order/PopUp/OrdTypeSerach.jsp", "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "MatSearch":
    	popupWidth = 720;
    	window.open("${contextPath}/Material_Order/PopUp/MaterialSerach.jsp?ComCode=" + ComCode + "&Vendor=" + VenCode, "PopUp05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    }
}

// document.addEventListener("DOMContentLoaded", function() {
//     var now_utc = Date.now();
// 	    var timeOff = new Date().getTimezoneOffset() * 60000;
// 	    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
// 	    var dateElement = document.getElementById("Date");
	
// 	    if (dateElement) {
// 	        dateElement.setAttribute("min", today);
// 	    } else {
// 	        console.error("Element with id 'Date' not found.");
// 	    }
// 	});
	
// 	window.addEventListener('DOMContentLoaded',(event) => {
// 		const ORDTYPE = document.querySelector('.ordType');
// 		const matCode = document.querySelector('.MatCode');
// 		const matDes = document.querySelector('.MatDes');
// 		const matType = document.querySelector('.MatType');
// 		const count = document.querySelector('.OrderCount');
// 		const orUnit = document.querySelector('.OrderUnit');
// 		const stUnit = document.querySelector('.StockUnit');
// 		const date = document.querySelector('.Date');
// 		const sCode = document.querySelector('.SlocaCode');
// 		const sDes = document.querySelector('.SlocaDes');
		
// 		const resetInputs = (inputs) => {
// 	        inputs.forEach(input => input.value = '');
// 	    };
		
// 	    const Subinfo = [matCode, matDes, matType, count, orUnit, stUnit, date, sCode, sDes];
// 	    ORDTYPE.addEventListener('change', () => resetInputs(Subinfo));
// 	});
$(document).ready(function(){
	function DateSetting(){
		var CurrentDate = new Date();
		var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-' + ('0' + CurrentDate.getDate()).slice(-2);
		$('.date').val(today);
		$('.DeliHopeDate').attr('min', today);
		
	}
	function InitialTable(){
		var UserId = $('.UserID').val();
		$('.InfoTable-Body').empty();
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 16; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.InfoTable-Body').append(row);
        }
		$.ajax({
			url:'${contextPath}/Material_Order/AjaxSet/ForPlant.jsp',
			type:'POST',
			data:{id : UserId},
			dataType: 'text',
			success: function(data){
				console.log(data.trim());
				var dataList = data.trim().split('-');
				console.log(dataList);
				$('.PlantCode').val(dataList[0]);
				$('.PlantDes').val(dataList[1]);
			}
		})
	}
	function CallORD() {
		var type=$('.ordType').val();
		var date = $('.date').val();
		console.log(type + ',' + date);
		$.ajax({
			type: "POST",
			url: "${contextPath}/Material_Order/AjaxSet/MakeNumber.jsp",
			data: { type: type, date: date },
			success: function(response) {
				console.log(response.trim);
	   			$('input[name="OrderNum"]').val($.trim(response));
				$('input[name="OIN"]').val("0001");
			}
		});
	}
	function BodyDisabled(){
		$('.Mat-Area').find('input').prop('disabled', true);
	}
	function BodyAbled(){
		$('.Mat-Area').find('input').prop('disabled', false);
	}
	InitialTable();
	DateSetting();
	CallORD();
	$('.ordType').change(function(){
		$('.Mat-Area').find('input').val('');
		CallORD();	
	});
	BodyDisabled();
	$('.CreateBtn').click(function(){
		var VendorCode = $('.VendorCode').val();
		if(VendorCode === ''){
			alert('모든 데이터를 입력해주세요.');
		}else{
			BodyAbled();
		}
	})
	$('.SlocaCode').change(function() {
		var Code = $(this).val();
		console.log('Storage Code : ' + Code);
		$.ajax({
			type: "POST",
			url: "${contextPath}/AjaxSet/Material_Order/StorageCodeFind.jsp",
			data: { SCode: Code },
			success: function(response) {
				console.log(response);
				$('input[name="SlocaDes"]').val($.trim(response));
			},
			error: function(xhr, textStatus, errorThrown) {
				console.log(xhr.statusText);
			}
		});
	});
    var rowNum = 1;
    var itemNum = 0;
    var deletedItems = [];
    var maxRowNum = 0;
    
    $(".container").on('click', "img[name='Down']", function(){
    	console.log($("img[name='Down']").length);
    	itemNum++;
        var currentOIN = parseInt($('.OIN').val(), 10); //이 값을 10진수로 해석하여 정수로 변환
        /* $('.OIN').val(currentOIN); */
        var dataToSend = {};
        $(".Key-Com").each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            dataToSend[name] = value;
        }); // 끝
        
        var check = ["MatCode", "OrderCount", "Date"];
        var messages = ["재료를 선택해주세요", "수량을 입력해주세요", "날짜를 선택해주세요"];

        for(var i = 0 ; i < check.length ; i++){
            if(!dataToSend[check[i]]){
                alert(messages[i]);
                break;
            }
        }
        
        const Subinfo = [$('.MatCode'), $('.MatDes'), $('.MatType'), $('.OrderCount'), $('.OrderUnit'), $('.StockUnit'), $('.Date'), $('.SlocaCode'), $('.SlocaDes')];
        Subinfo.forEach(input => input.val(''));
        
        const UnitMoney = [$('.OrdPrice')];
        UnitMoney.forEach(input => input.val('0'))
        
        $.ajax({
            url: 'exp.jsp',
            type: 'POST',
            data: JSON.stringify(dataToSend),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            async: false,
            success: function(data) {
            	var Del = "Delete";
                var newRow = "<tr class='dTitle'>";
                var rowNum = $(".WirteForm tr").length;
                newRow += "<td class='datasize'>" + rowNum + "</td>";
                newRow += "<td class='datasize'><input type='button' name='deleteBTN' value='" + Del + "'></td>";
                
                var order = ["OrderNum", "OIN", "MatCode", "MatDes", "MatType", "OrderCount", "OrderUnit", "Oriprice", "PriUnit", "OrdPrice", "MonUnit", "Date", "SlocaCode", "plantCode"];
                $.each(order, function(index, key){
                    if (key === "OIN") {
                        newRow += "<td class='datasize'>" + ("0000" + itemNum).slice(-4) + "</td>";
                    } else {
                        newRow += "<td class='datasize'>" + data[key] + "</td>";
                    }
                });

                newRow += "</tr>";
                $(".WirteForm").append(newRow);
                $('.OIN').val(("0000" + (currentOIN + 1)).slice(-4));
                maxRowNum = rowNum;
            }
        });
    });


    $(".WirteForm").on('click', "input[name='deleteBTN']", function(){
        var row = $(this).closest('tr');
        var orderNum = row.find('td:eq(2)').text();
        var OIN = row.find('td:eq(3)').text();
        console.log("PO번호: " + orderNum);
        console.log("Item번호: " + OIN);
        deletedItems.push({OrderNum: orderNum, OIN: OIN});
        console.log(deletedItems);
        console.log("Deleted item: OrderNum - " + orderNum + ", OIN - " + OIN);
        row.remove();
        rowNum--;
        console.log(rowNum);

        $(".WirteForm tr").each(function(index){
            if(index != 0) {
                $(this).find('td:first').text(index);
            }
        });
        
        $.ajax({
            url: 'edit.jsp',
            type: 'POST',
            data: {'data': JSON.stringify(deletedItems)},
            contentType: 'application/x-www-form-urlencoded; charset=utf-8',
            dataType: 'json',
            async: false,
            success: function(data){
                if (data.result) {
                    console.log('삭제 성공');
                } else {
                    console.log('삭제 실패: ' + data.message);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log("AJAX error: " + textStatus + ' : ' + errorThrown);
            }
        });
        console.log(deletedItems);
    });
    
    $('.OrderCount').on('input', function(){
        var count = parseFloat($(this).val());
        var unit = parseFloat($('.Oriprice').val());
        var money = $('.MonUnit').val();
        var total;
        if(money == "KRW"){
            total = Math.round(count * unit);
        } else{
            total = (count * unit).toFixed(2);
        }
        console.log('발주수량 : ' + count + ', 구입단가 : ' + unit + ', 거래통화 : ' + money + ', 총액 : ' + total);
        $('input[name="OrdPrice"]').val(total);
    });
});
</script>
<%
String UserId = (String)session.getAttribute("id");
String userComCode = (String)session.getAttribute("depart");
String UserIdNumber = (String)session.getAttribute("UserIdNumber");
%>
</head>
<body>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<!-- <form name="OrderRegistForm" id="OrderRegistForm" action="OrderRegist_Ok.jsp" method="POST" enctype="UTF-8"> -->
	<div class="Mat-Order">
		<div class="MatOrder-Header">
			<div class="Header-Title">Mateiral Order Header</div>
			<div class="InfoInput">
				<label>Company : </label>
				<input type="text" class="ComCode" name="ComCode" onclick="InfoSearch('ComSearch')" value="<%=userComCode %>" readonly>
				<input type="text" class="Com_Name" name="Com_Name" readonly hidden>
			</div>
			
			<div class="InfoInput">
				<label>Plant : </label>
				<input type="text" class="PlantCode Key-Com" name="PlantCode" onclick="InfoSearch('PlantSearch')" readonly>
				<input type="text" class="PlantDes" name="PlantDes" readonly> 
				
			</div>
			
			<div class="InfoInput">
				<label>Vendor : </label>
				<input type="text" class="VendorCode" name="VendorCode" onclick="InfoSearch('VendorSearch')" placeholder="선택" readonly>
				<input type="text" class="VendorDes" name="VendorDes" readonly>
			</div>
			
			<div class="InfoInput">
				<label>ORD type : </label>
				<input type="text" class="ordType Key-Com" name="ordType" onclick="InfoSearch('OrdTypeSearch')" value=PURO readonly>
			</div>
			
			<div class="InfoInput">
				<label>PO Number : </label>
				<input type="text" class="OrderNum Key-Com" name="OrderNum">
			</div>
			
			<div class="InfoInput">
				<label>발주자 사번 : </label>
				<input type="text" class="UserID" name="UserID" value="<%=UserIdNumber %>" readonly>
			</div>
			<div class="InfoInput">
				<label>발주일자 : </label>
				<input type="text" class="date" name="date" readonly>
			</div>	
			
			<div class="BtnArea">
				<button class="CreateBtn">Create</button>
			</div>
		</div>
		
		<div class="MatOrder-Body">
			<div class="Body-Title">Mateiral Order Body</div>
			<div class="Mat-Area">
				<div class="InfoInput">
					<label>Order No. : </label> 
					<input type="text" class="OIN Key-Com" name="OIN" readonly> 
				</div>
				
				<div class="InfoInput">
					<label>Material : </label> 
					<input type="text" class="MatCode Key-Com" name="MatCode" onclick="InfoSearch('MatSearch')" readonly>
					<input type="text" class="MatDes Key-Com" name="MatDes" readonly>
					
				 	<label>Material 유형 : </label>
					<input type="text" class="MatType Key-Com" name="MatType" readonly> 
				</div>
				
				<div class="InfoInput">
					<label>발주수량 : </label> 
					<input type="text" class="OrderCount Key-Com" name="OrderCount">
							
					<label>구매단위 : </label> 
					<input type="text" class="OrderUnit Key-Com" name="OrderUnit" readonly>
							
					<label>재고단위 : </label>
					<input type="text" class="StockUnit" name="StockUnit" readonly>
				</div>
				
				<div class="InfoInput">
					<label>납품희망일자 : </label> 
					<input type="date" class="DeliHopeDate Key-Com" name="DeliHopeDate">
								
					<label>납품S.Location : </label>
					<input type="text" class="SlocaCode Key-Com" name="SlocaCode" readonly>
					<input type="text" class="SlocaDes" name="SlocaDes" readonly>
				</div>
					
				<div class="InfoInput">
					<label>구입단가 : </label>
					<input type="text" class="Oriprice Key-Com" name="Oriprice" readonly>
								
					<label>가격단위 : </label>
					<input type="text" class="PriUnit Key-Com" name="PriUnit" readonly>
								
					<label>발주금액 : </label>
					<input type="text" class="OrdPrice Key-Com" name="OrdPrice" readonly>
								
					<label>거래통화 : </label>
					<input type="text" class="MonUnit Key-Com" name="MonUnit" readonly> 
				</div>
			</div>

			<div class="BtnArea">
				<button class="InsertBtn">Insert</button>
				<button class="ResetBtn">Reset</button>
			</div>
		
			<div class=Info-Area>
				<div class="Tail-Title">Ordered RegisteForm</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>항번</th><th>삭제</th><th>PO번호</th><th>Item번호</th><th>Material</th><th>Material Description</th>
							<th>Material유형</th><th>수량</th><th>구매단위</th><th>구입단가</th><th>가격단위</th><th>발주금액</th><th>거래통화</th>
							<th>납품희망일자</th><th>납품창고</th><th>Plant</th>
						</tr>
					</thead>
					<tbody class="InfoTable-Body">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
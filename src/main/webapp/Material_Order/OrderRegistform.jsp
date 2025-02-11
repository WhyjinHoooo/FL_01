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
    var VenCode = $('.VendorCode').val();
    
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
    	popupWidth = 1000;
    	window.open("${contextPath}/Material_Order/PopUp/MaterialSerach.jsp?ComCode=" + ComCode + "&Vendor=" + VenCode, "PopUp05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    }
}
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
	        const row = $('<tr></tr>');
	        for (let j = 0; j < 16; j++) {
	            row.append('<td></td>');
	        }
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
	BodyDisabled();
	$('.ordType').change(function(){
		$('.Mat-Area').find('input').val('');
		CallORD();	
	});
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
			url: "${contextPath}/Material_Order/AjaxSet/StorageCodeFind.jsp",
			data: { SCode: Code },
			success: function(response) {
				$('input[name="SlocaDes"]').val($.trim(response));
			},
			error: function(xhr, textStatus, errorThrown) {
				console.log(xhr.statusText);
			}
		});
	});
    var HeaderInfoList = {};
    var dataToSend = {};
    var Plus = 0;
    var rowNum;
    $('.InsertBtn').click(function(){
    	$('.Key-Com').each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            dataToSend[name] = value;
        });
    	console.log(dataToSend);
    	var pass = true;
    	$.each(dataToSend,function(key, value){
    		if(value == null || value === ''){
    			pass = false;
    			return false;
    		}
    	})
    	if(!pass){
    		alert('모든 항목을 입력해주세요.');
    	}else{
    		$.ajax({
                url: '${contextPath}/Material_Order/AjaxSet/Quicksave.jsp',
                type: 'POST',
                data: JSON.stringify(dataToSend),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: false,
                success: function(data) {
                	var RegistedData = data.DataList;
                	if(data.status === 'Success'){
                		if(Plus === 0){
                			$('.InfoTable-Body').empty();
                			rowNum = $('.InfoTable-Body tr').length; 
                			var row = '<tr>' +
							'<td>' + (rowNum + 1).toString().padStart(2,'0') + '</td>' + 
							'<td><button class="DeleteBtn">Delete</button></td>' +
							'<td>' + RegistedData.OrderNum + '</td>' + 
							'<td>' + RegistedData.OIN + '</td>' + 
							'<td>' + RegistedData.MatCode + '</td>' + 
							'<td>' + RegistedData.MatDes + '</td>' + 
							'<td>' + RegistedData.MatType + '</td>' + 
							'<td>' + RegistedData.OrderCount + '</td>' + 
							'<td>' + RegistedData.OrderUnit + '</td>' + 
							'<td>' + RegistedData.Oriprice + '</td>' + 
							'<td>' + RegistedData.PriUnit + '</td>' + 
							'<td>' + RegistedData.OrdPrice + '</td>' + 
							'<td>' + RegistedData.MonUnit + '</td>' +
							'<td>' + RegistedData.DeliHopeDate + '</td>' +
							'<td>' + RegistedData.SlocaCode + '</td>' +
							'<td>' + RegistedData.PlantCode + '</td>' +
							'<td hidden>' + RegistedData.OrderNum + '-' + RegistedData.OIN  + '</td>' +
							'</tr>';
	                		$('.InfoTable-Body').append(row);
	                		rowNum++;
                    		$('.OIN').val((rowNum + 1).toString().padStart(4,'0'));
                		}else{
                			rowNum = $('.InfoTable-Body tr').length;
                			var row = '<tr>' +
							'<td>' + (rowNum + 1).toString().padStart(2,'0') + '</td>' + 
							'<td><button class="DeleteBtn">Delete</button></td>' +
							'<td>' + RegistedData.OrderNum + '</td>' + 
							'<td>' + RegistedData.OIN + '</td>' + 
							'<td>' + RegistedData.MatCode + '</td>' + 
							'<td>' + RegistedData.MatDes + '</td>' + 
							'<td>' + RegistedData.MatType + '</td>' + 
							'<td>' + RegistedData.OrderCount + '</td>' + 
							'<td>' + RegistedData.OrderUnit + '</td>' + 
							'<td>' + RegistedData.Oriprice + '</td>' + 
							'<td>' + RegistedData.PriUnit + '</td>' + 
							'<td>' + RegistedData.OrdPrice + '</td>' + 
							'<td>' + RegistedData.MonUnit + '</td>' +
							'<td>' + RegistedData.DeliHopeDate + '</td>' +
							'<td>' + RegistedData.SlocaCode + '</td>' +
							'<td>' + RegistedData.PlantCode + '</td>' +
							'<td hidden>' + RegistedData.OrderNum + '-' +  RegistedData.OIN + '</td>' +
							'</tr>';
	                		$('.InfoTable-Body').append(row);
	                		rowNum++;
                			$('.OIN').val((rowNum + 1).toString().padStart(4,'0'));
                		}
                		console.log($('.OIN').val());
                	}else{
                		alert('오류가 발생했습니다.');
                	}
                }
            });
    	}
    	$('.Mat-Area input').not('.OIN').val('');
    	Plus++;
    })
    
    $('.InfoTable-Body').on('click', '.DeleteBtn', function(e){
	    e.preventDefault();
	    var row = $(this).closest('tr');
	    var OrderNum = row.find('td:eq(2)').text();
	    var ItemNum = row.find('td:eq(3)').text();
	    var MatCode = row.find('td:eq(4)').text();
	    var KeyValue = OrderNum + '-' + ItemNum;
	    
	    var rowCount;
	    $.ajax({
			type: "POST",
			url: "${contextPath}/Material_Order/AjaxSet/Quickdelete.jsp",
			data: { key: KeyValue, mat : MatCode},
			success: function(response) {
				if(response.trim() === 'Success'){
					row.remove();
					rowCount = $('.InfoTable-Body tr').length;
					console.log('rowCount : ' + rowCount);
					$('.OIN').val((rowCount + 1).toString().padStart(4,'0'));
					if(rowCount === 0){
						for (let i = 0; i < 20; i++) {
					        const row = $('<tr></tr>');
					        for (let j = 0; j < 16; j++) {
					            row.append('<td></td>');
					        }
					        $('.InfoTable-Body').append(row);
					    }
					}else{
						$('.InfoTable-Body tr').each(function(index, tr){
							console.log('Index : ' + index);
							var Element = $(this);
							var ElementKeyValue = Element.find('td:eq(16)').text()
							$.ajax({
								type: "POST",
								url: "${contextPath}/Material_Order/AjaxSet/Quickmanage.jsp",
								data: { KeyValue: ElementKeyValue },
								success: function(response) {
									if(response.trim() === 'Success'){
										Element.find('td:eq(0)').text((index+1).toString().padStart(2,'0'));
										Element.find('td:eq(3)').text((index+1).toString().padStart(4,'0'));
										Element.find('td:eq(16)').text(Element.find('td:eq(2)').text() + '-' + Element.find('td:eq(3)').text());
									}
								},
								error: function(xhr, textStatus, errorThrown) {
									console.log(xhr.statusText);
								}
							});
						})
					}
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				console.log(xhr.statusText);
			}
		});
	    
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
        $('input[name="OrdPrice"]').val(total);
    });
    
    $('.SaveBtn').click(function(){
    	console.log('클릭');
    	$(".Header").each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            HeaderInfoList[name] = value;
        });
    	console.log(HeaderInfoList);
    	var pass = true;
    	$.each(HeaderInfoList,function(key, value){
    		if(value == null || value === ''){
    			pass = false;
    			return false;
    		}
    	})
    	if(!pass){
    		alert('모든 항목을 입력해주세요.');
    	}else{
    		$.ajax({
                url: '${contextPath}/Material_Order/OrderRegist_Ok.jsp',
                type: 'POST',
                data: JSON.stringify(HeaderInfoList),
                contentType: 'application/json; charset=utf-8',
                success: function(response){
                	console.log(response.trim());
                	if(response.trim() === 'Success'){
                		location.reload();
                	} else{
                		alert('등록과정 중 문제가 발생했습니다.')
                	}
                }
            });
    	}
    })
    
    $('.ResetBtn').click(function(){
    	location.reload();
    })
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
	<div class="Mat-Order">
		<div class="MatOrder-Header">
			<div class="Header-Title">자재 발주 헤더</div>
			<div class="InfoInput">
				<label>Company : </label>
				<input type="text" class="ComCode" name="ComCode" onclick="InfoSearch('ComSearch')" value="<%=userComCode %>" readonly>
				<input type="text" class="Com_Name" name="Com_Name" readonly hidden>
			</div>
			
			<div class="InfoInput">
				<label>Plant : </label>
				<input type="text" class="PlantCode Key-Com Header" name="PlantCode" onclick="InfoSearch('PlantSearch')" readonly>
				<input type="text" class="PlantDes Header" name="PlantDes" readonly> 
				
			</div>
			
			<div class="InfoInput">
				<label>Vendor : </label>
				<input type="text" class="VendorCode Header" name="VendorCode" onclick="InfoSearch('VendorSearch')" placeholder="선택" readonly>
				<input type="text" class="VendorDes Header" name="VendorDes" readonly>
			</div>
			
			<div class="InfoInput">
				<label>ORD type : </label>
				<input type="text" class="ordType Key-Com Header" name="ordType" onclick="InfoSearch('OrdTypeSearch')" value=PURO readonly>
			</div>
			
			<div class="InfoInput">
				<label>PO Number : </label>
				<input type="text" class="OrderNum Key-Com Header" name="OrderNum">
			</div>
			
			<div class="InfoInput">
				<label>발주자 사번 : </label>
				<input type="text" class="UserID Header" name="UserID" value="<%=UserIdNumber %>" readonly>
			</div>
			<div class="InfoInput">
				<label>발주일자 : </label>
				<input type="text" class="date Header" name="date" readonly>
			</div>	
			
			<div class="BtnArea">
				<button class="CreateBtn">Create</button>
			</div>
		</div>
		
		<div class="MatOrder-Body">
			<div class="Body-Title">자재 발주 상세</div>
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
				<button class="SaveBtn">Save</button>
				<button class="ResetBtn">Reset</button>
			</div>
		
			<div class=Info-Area>
				<div class="Tail-Title">발주서</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>항번</th><th>삭제</th><th>PO번호</th><th>Item번호</th><th>원자재</th><th>원자재 설명</th>
							<th>원자재 유형</th><th>수량</th><th>구매단위</th><th>구입단가</th><th>가격단위</th><th>발주금액</th><th>거래통화</th>
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
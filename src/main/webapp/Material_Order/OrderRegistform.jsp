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
<script type="text/javascript">
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
		var popupWidth = 1000;
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
	    
	    var ComCode = document.querySelector('.plantComCode').value;
	    var VenCode = document.querySelector('.VendorCode').value;
	    
	    switch(field){
	    case "PlantSearch":
	    	window.open("${contextPath}/Material/PlantSerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "OrdTypeSearch":
	    	window.open("${contextPath}/Material_Order/OrdTypeSerach.jsp", "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "VendorSearch":
	    	window.open("${contextPath}/Material_Order/VendorSerach.jsp?ComCode=" + ComCode, "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "MatSearch":
	    	window.open("${contextPath}/Material_Order/MaterialSerach.jsp?ComCode=" + ComCode + "&Vendor=" + VenCode, "PopUp04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    }
	}
	
	document.addEventListener("DOMContentLoaded", function() {
	    var now_utc = Date.now();
	    var timeOff = new Date().getTimezoneOffset() * 60000;
	    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
	    var dateElement = document.getElementById("Date");
	
	    if (dateElement) {
	        dateElement.setAttribute("min", today);
	    } else {
	        console.error("Element with id 'Date' not found.");
	    }
	});
	
	window.addEventListener('DOMContentLoaded',(event) => {
		const ORDTYPE = document.querySelector('.ordType');
		const matCode = document.querySelector('.MatCode');
		const matDes = document.querySelector('.MatDes');
		const matType = document.querySelector('.MatType');
		const count = document.querySelector('.OrderCount');
		const orUnit = document.querySelector('.OrderUnit');
		const stUnit = document.querySelector('.StockUnit');
		const date = document.querySelector('.Date');
		const sCode = document.querySelector('.SlocaCode');
		const sDes = document.querySelector('.SlocaDes');
		
		const resetInputs = (inputs) => {
	        inputs.forEach(input => input.value = '');
	    };
		
	    const Subinfo = [matCode, matDes, matType, count, orUnit, stUnit, date, sCode, sDes];
	    ORDTYPE.addEventListener('change', () => resetInputs(Subinfo));
	});
</script>

<script>
$(document).ready(function(){
    var rowNum = 1;  // 항번을 위한 변수
    var itemNum = 0;  // Item 번호를 위한 변수
    /* var deletedRowNums = [];  // 삭제한 항번을 저장하는 배열 */
    var deletedItems = [];  // 삭제된 항번의 OrderNum, OIN을 저장하는 리스트, 추가된 부분
    var maxRowNum = 0;
    
    function CallORD() {
		var type=$('.ordType').val();
		var date = $('.date').val();
		console.log('ORD type : ' + type);
		
		$.ajax({
            type: "POST",
            url: "${contextPath}/Material_Order/MakeNumber.jsp", // 실제 요청을 보낼 URL을 입력해주세요.
            data: { type: type, date: date }, // 서버로 보낼 데이터를 입력해주세요.
            success: function(response) {
                console.log(response);
                $('input[name="OrderNum"]').val($.trim(response));
                $('input[name="OIN"]').val("0001");  // OrderNum이 변경되면 Item 번호를 '0001'로 초기화
            }
        });
	}
	CallORD();
	$('.ordType').change(CallORD);
    
	$('.SlocaCode').change(function() {
		var Code = $(this).val();
		console.log('Storage Code : ' + Code);
		$.ajax({
			type: "POST",
			url: "${contextPath}/Material_Order/StorageCodeFind.jsp",
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
        } // for문의 끝
        
        const Subinfo = [$('.MatCode'), $('.MatDes'), $('.MatType'), $('.OrderCount'), $('.OrderUnit'), $('.StockUnit'), $('.Date'), $('.SlocaCode'), $('.SlocaDes')];
        Subinfo.forEach(input => input.val(''));
        
        const UnitMoney = [$('.OrdPrice')];
        UnitMoney.forEach(input => input.val('0'))
        
        $.ajax({
            url: 'exp.jsp', // 여기에 서버 URL을 입력하세요
            type: 'POST',
            data: JSON.stringify(dataToSend),
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            async: false,
            success: function(data) {
            	var Del = "Delete";
                var newRow = "<tr class='dTitle'>";
                var rowNum = $(".WirteForm tr").length;
                newRow += "<td class='datasize'>" + rowNum + "</td>";  // 항번 추가
                newRow += "<td class='datasize'><input type='button' name='deleteBTN' value='" + Del + "'></td>";
                
                // 데이터 순서를 정하고, 순서대로 행에 추가합니다.
                var order = ["OrderNum", "OIN", "MatCode", "MatDes", "MatType", "OrderCount", "OrderUnit", "Oriprice", "PriUnit", "OrdPrice", "MonUnit", "Date", "SlocaCode", "plantCode"];
                $.each(order, function(index, key){
                    if (key === "OIN") {  // Item 번호인 경우
                        newRow += "<td class='datasize'>" + ("0000" + itemNum).slice(-4) + "</td>";  // '0001' 형식으로 추가
                    } else {
                        newRow += "<td class='datasize'>" + data[key] + "</td>";
                    }
                }); // $.each(order, function(index, key)의 끝

                newRow += "</tr>";
                $(".WirteForm").append(newRow);
                $('.OIN').val(("0000" + (currentOIN + 1)).slice(-4));
                maxRowNum = rowNum;
            } // success: function(data) 의 끝
        }); // $.ajax({의 끝
    });
        
 	// 삭제 버튼 클릭 이벤트
    $(".WirteForm").on('click', "input[name='deleteBTN']", function(){
        var row = $(this).closest('tr');  // 클릭된 버튼이 속한 행 선택
        var orderNum = row.find('td:eq(2)').text();  // 삭제된 항번의 OrderNum, 수정된 부분
        var OIN = row.find('td:eq(3)').text();  // 삭제된 항번의 OIN, 수정된 부분
        console.log("PO번호: " + orderNum);  // log 추가
        console.log("Item번호: " + OIN);  // log 추가
        deletedItems.push({OrderNum: orderNum, OIN: OIN});  // 삭제된 항번의 정보를 리스트에 추가, 추가된 부분
        console.log(deletedItems);  // log 추가
        console.log("Deleted item: OrderNum - " + orderNum + ", OIN - " + OIN); // 삭제된 항번의 OrderNum, OIN 확인
        row.remove();  // 행 삭제
        rowNum--;
        console.log(rowNum);

        // 항번 다시 정렬
        $(".WirteForm tr").each(function(index){
            if(index != 0) { // 테이블 헤더를 제외하고 순번을 부여
                $(this).find('td:first').text(index);
            }
        }); // .WirteForm tr의 끝
        
        $.ajax({
            url: 'edit.jsp',
            type: 'POST',
            data: {'data': JSON.stringify(deletedItems)},  // data 속성 수정
            contentType: 'application/x-www-form-urlencoded; charset=utf-8',  // contentType 수정
            dataType: 'json',
            async: false,
            success: function(data){
                // 서버에서 응답이 온 후의 처리
                if (data.result) {
                    console.log('삭제 성공');
                } else {
                    console.log('삭제 실패: ' + data.message);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log("AJAX error: " + textStatus + ' : ' + errorThrown);
            }
        }); // 'edit.jsp'의 끝
        console.log(deletedItems);  // log 추가
    }); // .WirteForm의 끝
    
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
	request.setCharacterEncoding("UTF-8");
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String Today = today.format(formatter);
	
	String plantCode = (String) session.getAttribute("pCode");
	String plantDes = (String) session.getAttribute("pDes");
	String plantComCode = (String) session.getAttribute("pComCode");
	
	String User_Id = (String) session.getAttribute("id");
%>
</head>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
		<form name="OrderRegistForm" id="OrderRegistForm" action="OrderRegist_Ok.jsp" method="POST" enctype="UTF-8">
		<div class="content-wrapper">
			<aside id="SideMenu" class="side-menu-container">
				<li>Plant</li>
				<td class="input-info">
				<%
					if( plantCode == null){
				%>
				<input type="text" class="plantCode Key-Com" name="plantCode" onclick="InfoSearch('PlantSearch')" placeholder="선택" readonly>
				<input type="text" class="plantDes" name="plantDes" readonly> 
				<input type="text" name="plantComCode" class="plantComCode" hidden>
				<%
					} else{
					%>
				<input type="text" class="plantCode Key-Com" name="plantCode" readonly value="<%= plantCode %>" onclick="InfoSearch('PlantSearch')">
				<input type="text" class="plantDes" name="plantDes" readonly value="<%= plantDes %>">
				<input type="text" name="plantComCode" class="plantComCode" hidden value="<%= plantComCode %>">
				<%
					}
				%>
				</td>
				<br><br>
				<li>Vendor</li>
					<td class="input-info" colspan="2">
						<input type="text" class="VendorCode" name="VendorCode" onclick="InfoSearch('VendorSearch')" placeholder="선택" readonly>
						<input type="text" class="VendorDes" name="VendorDes" readonly>
				</td>
					<br><br>
				<li>PO Number</li>
					<td class="input-info"> 
						<input type="text" class="OrderNum Key-Com" name="OrderNum"> <!-- 전송 --> 
					</td>
					<br><br>
				<li>ORD type</th></li>
					<td>
						<input type="text" class="ordType Key-Com" name="ordType" onclick="InfoSearch('OrdTypeSearch')" value=PURO readonly>
					</td>
					<br><br>
				<li>발주자 사번</th></li>
					<td class="input-info">
						<%
						if(User_Id != null){
						%>
						<input type="text" class="UserID" name="UserID" value="<%=User_Id%>" readonly>
						<%
						} else{
						%>
						<input type="text" class="UserID" name="UserID" value="없음" readonly>
						<%
						}
						%>
					</td>
					<br><br>
				<li>발주일자</li>
					<td class="input-info">
							<input type="text" class="date" name="date" value="<%=Today%>" readonly>
					</td>
			</aside>
			
			<section class="main-content-container">
			<div class="order-sub-info">
				<div class="table-container">
					<table class="table_1">
						<tr><th class="info">Order No. : </th> 
							<td class="input-info">
								<input type="text" class="OIN Key-Com" name="OIN" size="5" readonly> <!-- 전송 -->
							</td>
						</tr>
					</table>
					
					<table class="table_2">
						<tr><th class="info">Material : </th>
							<td class="input-info" id="twoLines" colspan="2"> 
								<input type="text" class="MatCode Key-Com" name="MatCode" onclick="InfoSearch('MatSearch')" size="10" readonly>
								<input type="text" class="MatDes Key-Com" name="MatDes" readonly><!--  전송 -->
							</td> 
							
							<td class="spaceCell-s"></td>
							
							<th class="info">Material 유형 : </th>
							<td class="input-info">
								<input type="text" class="MatType Key-Com" name="MatType" size="10" readonly> <!-- 전송 -->
							</td>
						</tr>
					</table>
					
					<table class="table_3">
						<tr>
							<th class="info">발주수량 : </th>
								<td class="input-info"> 
									<input type="text" class="OrderCount Key-Com" name="OrderCount" size="10"><!-- 전송 -->
								</td>
								
								<td class="spaceCell-ss"></td>
								
							<th class="info">구매단위 : </th>
								<td class="input-info"> 
									<input type="text" class="OrderUnit Key-Com" name="OrderUnit" size="10" readonly> <!-- 전송 -->
								</td> 
								
								<td class="spaceCell-ss"></td>
								
							<th class="info">재고단위 : </th>
								<td class="input-info">
									<input type="text" class="StockUnit" name="StockUnit" size="10" readonly>
								</td>		
						</tr>
					</table>
					
					<table class="table_4">
						<tr>
							<th class="info">납품희망일자 : </th>
								<td class="input-info"> 
									<input type="date" class="Date Key-Com" name="Date" id="Date" size="10"> <!-- 전송 -->
								</td>
								
								<td class="spaceCell-sss"></td>
								
							<th class="info">납품S.Location : </th>
								<td class="input-info" id="twoLines" colspan="2">
									<input type="text" class="SlocaCode Key-Com" name="SlocaCode" size="10" readonly> <!-- 전송 -->
									<input type="text" class="SlocaDes" name="SlocaDes" readonly>
								</td>
						</tr>
					</table>
					
					<table class="table_5">
						<tr>
							<th class="info">구입단가 : </th>
								<td class="input-info">
									<input type="text" class="Oriprice Key-Com" name="Oriprice" readonly> <!-- 전송 -->
								</td>
								
							<td class="spaceCell-50"></td>
								
							<th class="info">가격단위 : </th>
								<td class="input-info">
									<input type="text" class="PriUnit Key-Com" name="PriUnit" readonly> <!-- 전송 -->
								</td>
								
							<td class="spaceCell-50"></td>
								
							<th class="info">발주금액 : </th>
								<td class="input-info">
									<input type="text" class="OrdPrice Key-Com" name="OrdPrice" readonly> <!-- 전송 -->
								</td>
								
							<td class="spaceCell-90"></td>
								
							<th class="info">거래통화 : </th>
								<td class="input-info">
									<input type="text" class="MonUnit Key-Com" name="MonUnit" readonly> <!-- 전송 -->
								</td>		
						</tr>
					</table>
				</div>
			</div>
			
			<div class="container">
				<img name="Down" src="${contextPath}/img/Dvector.png" alt="">
				<input class="input-btn" id="btn" type="submit" value="Insert">
			</div>
			
			<div class="order-ready">
				<div class="table-container">
					<table class="WirteForm">
						<tr style="cursor: default;">
							<th>항번</th><th>삭제</th><th>PO번호</th><th>Item번호</th><th>Material</th><th>Material Description</th><th>Material유형</th><th>수량</th><th>구매단위</th><th>구입단가</th><th>가격단위</th><th>발주금액</th><th>거래통화</th><th>납품희망일자</th><th>납품창고</th><th>Plant</th>
						</tr>
					</table>
					</div>
				</div>
			</section>
		</div>
		</form>
	
</body>
</html>
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
<%@ include file="../mydbcon.jsp" %>
<meta charset="UTF-8">
<title>수출신고필증, B/L 등록</title>
</head>
<body>
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
    
    var UserComCode = $('.UserCom').val();
    var BizArea = $('.BizCode').val();
    var DealCom = $('.DealComCode').val();
    
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
	case "DNNumber":
		popupWidth = 550;
		popupHeight = 610;
		window.open("${contextPath}/Sales/Popup/FindDnNumber.jsp?ComCode=" + UserComCode + "&Biz=" + BizArea + "&Deal=" + DealCom, "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	}
}
$(document).ready(function(){
	function InitialTable(){
		$('.EPBL_Body').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 8; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.EPBL_Body').append(row);
        }
	}
	/* 위에는 함수 영역 */
	var Btnclick = 0;
	InitialTable();
	const button = document.querySelector('#ChangeMode'); // 변경 버튼
	const ChgBtn = document.querySelector('#SearchBtn'); // 검색 버튼
	
	var Company = null;
	var BizArea = null;
	var Partner = null;
	var OrderNum = null;
	
	button.addEventListener('click', function() {
	    Btnclick++;
	    if(Btnclick % 2 == 0){
	        // 짝수 클릭
	        $('#ChangeTgk01').text('수출 신고번호 :');
	        $('.TgkSep[value="even"]').prop('checked', true);
	        $('.TgkSep[value="odd"]').prop('checked', false);
	    } else {
	        // 홀수 클릭
	        $('#ChangeTgk01').text('신고번호 :');
	        $('.TgkSep[value="odd"]').prop('checked', true);
	        $('.TgkSep[value="even"]').prop('checked', false);
	    }
	});
	
	ChgBtn.addEventListener('click', function() {
		Company = $('.UserCom').val();
		BizArea = $('.BizCode').val();
		Partner = $('.DealComCode').val();
		OrderNum = $('.EDNumber').val();
		console.log('OrderNum : ' + OrderNum);
		if(OrderNum && String(OrderNum).trim() !== ''){
			var InfoList = [];
			InfoList = [Company, BizArea, Partner, OrderNum];
			$.ajax({
				url: '${contextPath}/Sales/ajax/DataLoading.jsp',
				type: 'POST',
				data: JSON.stringify(InfoList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
					$('.EPBL_Body').empty();
					console.log(data);
					console.log(data.length);
					var DataList = {};
					if(data.length > 0){
						for(var i = 0 ; i < data.length ; i++){
							var key = data[i];
							if(!DataList[key]){
								DataList[key] = [];	
							}
							DataList[key].push(i);
						}
						for(var key in DataList){
							var KeyNumber = DataList[key];
							console.log('KeyNumber : ' + KeyNumber);
							for(var j = 0 ; j < KeyNumber.length ; j++){
								var index = KeyNumber[j];
								console.log('index : ' + index);
								var row = '<tr>' +
									'<td>' + (index + 1) + '</td>' +
									'<td>' + data[index].MatCode + '</td>' + 
									'<td>' + data[index].MatCodeDes + '</td>' + 
									'<td>' + data[index].Unit + '</td>' + 
									'<td>' + data[index].Qty + '</td>' + 
									'<td>' + data[index].SalesUnit + '</td>' + 
									'<td>' + data[index].Currency + '</td>' + 
									'<td>' + Number(data[index].TotalPrice).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '</td>' + 
									'</tr>';
								$('.EPBL_Body').append(row);
							}
						}
					} else{
						alert('해당 검색 조건에 만족하는 데이터가 존재하지 않습니다.');
						return false;
					}
				}
			});
		}else{
			alert('aaa');
		}
	});
	
})
</script>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<%
	String Id = (String)session.getAttribute("id");
	String UserComCode = (String)session.getAttribute("depart");
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter_YMD = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String Rnow = today.format(formatter_YMD);
%>
<div class="EPBLForm"> <!-- Export Permit Bill of Landing Form-->
	<div class="EPBL_MainArea">
		<div class="EPBL-Column">
			<label>회사 : </label>
			<input class="UserCom" value=<%=UserComCode %> readonly>
			<button id="ChangeMode">변경</button>
			<label>입력자 : </label>
			<input class="UserId" value=<%=Id %> readonly>
		</div>
		<div class="EPBL-Column">
			<label>회계단위 : </label>
			<input class="BizCode" onclick="InfoSearch('BizArea')" readonly placeholder="SELECT">
			<input class="BizCodeDes Des" readonly>
			<label>입력일자 : </label>
			<input class="ToDate" value=<%=Rnow %> readonly>
		</div>
		<div class="EPBL-Column">
			<label>거래처 : </label>
			<input class="DealComCode" onclick="InfoSearch('TradeCom')" readonly placeholder="SELECT">
			<input class="DealComCodeDes Des"readonly>
			<label>수량단위 : </label>
			<select class="Unit">
				<option value="1">1</option>
				<option value="1000">1,000</option>
				<option value="10000">10,000</option>
				<option value="1000000">1,000,000</option>
			</select>
		</div>
		<div class="EPBL-Column">
			<label>신고자 : </label>
			<input class="Exporter" readonly placeholder="SELECT">
			<input class="ExporterDes Des" readonly>
		</div>
		<div class="EPBL-Column">
			<label>납품지시번호 : </label><!-- Export Declaration Number -->
			<input class="EDNumber" onclick="InfoSearch('DNNumber')" readonly placeholder="SELECT">
			<label id="ChangeTgk01">수출 신고번호 : </label> <!-- Delivery Order Number -->
			<input type="text" class="DONumber">
			<input type="checkbox" class="TgkSep" value="odd" hidden> <!-- 수출 B/L 등록인 경우 -->
			<input type="checkbox" class="TgkSep" value="even" checked hidden> <!-- 수출신고필증 등록인 경우 -->
		</div>
		<div class="EPBL-Column">
			<label>CIF 신고금액 : </label>
			<input type="text" class="CIF">
			<label>FOB 신고금액 : </label>
			<input type="text" class="FOB">
		</div>
	</div>
	<div class="BtnArea">
		<button class="SearchBtn" id="SearchBtn">검색</button>	
		<button class="DoItBtn">저장</button>
	</div>
	<div class="EPBL_SubArea">
		<table class="EPBL_Table">
			<thead class="EPBL_Header">
				<th>항번</th><th>품번</th><th>품명</th><th>수량단위</th><th>수량</th><th>판매단가</th><th>거래통화</th><th>거래통화매출금액</th>
			</thead>
			<tbody class="EPBL_Body">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
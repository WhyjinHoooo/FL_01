<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
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
	const button = document.querySelector('#ChangeMode');
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
})
</script>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<%
	String Id = (String)session.getAttribute("id");
	String UserComCode = (String)session.getAttribute("depart");
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
			<input class="BizCode" onclick="InfoSearch('BizArea')" readonly>
			<input class="BizCodeDes Des" readonly>
			<label>입력일자 : </label>
			<input class="ToDate" readonly>
		</div>
		<div class="EPBL-Column">
			<label>거래처 : </label>
			<input class="DealComCode" onclick="InfoSearch('TradeCom')" readonly>
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
			<input class="Exporter" readonly>
			<input class="ExporterDes Des" readonly>
		</div>
		<div class="EPBL-Column">
			<label>납품지시번호 : </label><!-- Export Declaration Number -->
			<input class="EDNumber" readonly>
			<label id="ChangeTgk01">수출 신고번호 : </label> <!-- Delivery Order Number -->
			<input class="DONumber" id="ChangeTgk02" readonly>
			<input type="checkbox" class="TgkSep" value="odd" hidden> <!-- 수출 B/L 등록인 경우 -->
			<input type="checkbox" class="TgkSep" value="even" checked hidden> <!-- 수출신고필증 등록인 경우 -->
		</div>
		<div class="EPBL-Column">
			<label>CIF 신고금액 : </label>
			<input class="CIF" readonly>
			<label>FOB 신고금액 : </label>
			<input class="FOB" readonly>
		</div>
	</div>
	<div class="BtnArea">
		<button class="DoItBtn">실행</button>
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
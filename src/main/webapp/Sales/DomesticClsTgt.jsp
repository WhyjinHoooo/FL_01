<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<meta charset="UTF-8">
<title>국내매출 마감 대상 확정</title>
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
    
    var UserComCode = $('.UserCompany').val();
    
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
	var Today = new Date().toISOString().split('T')[0];
	var FutureDate = new Date();
	FutureDate.setDate(FutureDate.getDate() + 30);
	var EndDate = FutureDate.toISOString().split('T')[0];
	$('.StartDate, .SalesEndDate').attr({
		'value' : Today,
		'min' : Today
	});
	$('.EndDate').attr({
		'min' : Today,
		'max' : EndDate
	});
	function InitialTable(){
		$('.ConfirmTable_Body').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 14; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.ConfirmTable_Body').append(row);
        }
	}
	
	var Trg_SalesConMonth = document.getElementById('SalesClsMonth');
	var CurrentYear = new Date().getFullYear();
	var Initial_Year = CurrentYear + 100;
	var MonthList = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
	for(let year = CurrentYear + 1 ; year < Initial_Year ; year++){
		for(var i = 0 ; i < MonthList.length ; i++){
			var option = document.createElement('option');
			option.value = year + '.' + MonthList[i];
			option.textContent = year + '.' + MonthList[i] + '.월';
			Trg_SalesConMonth.appendChild(option);
		}
	}
	
	
	
	InitialTable(); // 1번 테이블 초기화
	var InfoList = [];
	var UserId = $('.UserId').text();
	console.log(UserId);
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
	});
	
	$('.DoItBtn').on('click',function(){
		var DealCom = $('.DealComCode').val(); // 거래처
		var UCom = $('.UserCompany').val(); // 회사
		var UBizArea = $('.BizCode').val();
		
		var Start = $('.StartDate').val();
		var End = $('.EndDate').val();
		if(!DealCom || !Start || !End){
			alert("검색조건을 정확이 입력해주세요");
			return false;
		}
		var StartDateValue = new Date(Start).getTime();
		var EndDateValue = new Date(End).getTime();
		if(EndDateValue >= StartDateValue && DealCom !== ''){
	 		InfoList = [UCom, UBizArea, DealCom, Start, End]
			console.log(InfoList);
			$.ajax({
				url: '${contextPath}/Sales/ajax/DomesticEndFetch.jsp',
				type: 'POST',
				data: JSON.stringify(InfoList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data) {
					console.log(data);
					console.log(data.length);
					if(data.length > 0){
						$('.ConfirmTable_Body').empty();
						// 그룹별 카운트를 저장할 객체
						var groupedData = {};

						// 데이터 그룹화: DelPlanOrderNum와 MatCode를 키로 사용
						for (var i = 0; i < data.length; i++) {
						    var key = data[i].OrderNum + "_" + data[i].MatCode;
						    console.log(key);
						    if (!groupedData[key]) {
						        groupedData[key] = [];
						    }
						    groupedData[key].push(i); // 같은 그룹의 인덱스를 저장
						}

						// 각 그룹을 처리하여 Seq 값 설정
						for (var key in groupedData) {
						    var indices = groupedData[key]; // 해당 그룹에 속한 인덱스들
						    for (var j = 0; j < indices.length; j++) {
						        var index = indices[j];
						        var row = '<tr>' +
						            '<td><input type="checkbox" class="checkboxBtn"></td>' + // 체크 박스 1
						            '<td>' + data[index].OutDate + '</td>' + // 반출예정일자 2
						            '<td>' + data[index].OrderNum + '</td>' + // 거래처 3
						            '<td>' + data[index].Seq + '</td>' + // 납품계획번호 4
						            '<td>' + data[index].MatCode + '</td>' + // 같은 그룹 내에서 증가하는 Seq 값 5
						            '<td>' + data[index].MatCodeDes + '</td>' + // 품번 6
						            '<td>' + data[index].Quantity + '</td>' + // 품명 7 
						            '<td>' + data[index].Unit + '</td>' + // 납품수량 8
						            '<td>' + data[index].TPWay + '</td>' + // 수량단위 9
						            '<td>' + data[index].Station + '</td>' + // 운송수단 10
						            '<td>' + data[index].ArrivePlace + '</td>' + // 인도장소 11
						            '<td>' + data[index].DealCom + '</td>' + // 거래처 12
						            '</tr>';
						        $('.ConfirmTable_Body').append(row);
						    }
						}
					} else{
						alert('해당 검색 조건에 만족하는 데이터가 존재하지 않습니다.');
						return false;
					};
				}
			});
		} else{
			alert("검색 날짜를 정확히 입력해주세요.");
			return false;
		};
	});
	
	var KeyValueList = [];
	var PeriodList = [];
	var SaveList = [];
	$('.SaveBtn').on('click',function(){
		var OrderNum = null;
		var DealCom = null;
		$('.ConfirmTable_Body tr').each(function(index, tr){
			var $tr = $(tr);
			var $Chk = $tr.find('input[type="checkbox"]');
			if($Chk.prop('checked')){
				OrderNum = $tr.find('td:nth-child(3)').text().trim();
				var Seq = String($tr.find('td:nth-child(4)').text().trim()).padStart(2, '0');
				DealCom = $('.UserCompany').val();
				
				KeyValueList.push(OrderNum+Seq+DealCom);
			}
		})
		PeriodList.push($('.ConfirmDate').val());
		PeriodList.push(OrderNum);
		PeriodList.push($('.UserCompany').val());
		SaveList.push(KeyValueList);
		SaveList.push(PeriodList);
		
		console.log(SaveList);
		$.ajax({
			url: '${contextPath}/Sales/ajax/DelConfirmSave.jsp',
			type: 'POST',
			data: JSON.stringify(SaveList),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(data){
				if(data.status === "Success"){
					InitialTable();
					KeyValueList = [];
					PeriodList = [];
					SaveList = [];
	                console.log('저장되었습니다.');
				}else{
					console.log('저장 실패');
				}
			},
		    error: function(xhr, status, error) {
		        console.log('AJAX 요청 실패:', error);
		    }
		})
	})
})
</script>
</head>
<body>
<%
	String UserId = (String)session.getAttribute("id");
	String UserCompany = (String)session.getAttribute("depart");
%>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<hr>
	<div class="UserId" hidden><%=UserId %></div>
	<div class="DomesticArea">
		<div class="Domestic-Main"><!-- DelOrder-Main -->
			<div class="Domestic-Main-Header">SEARCH FIELDS</div>
			<div class="Domestic-Main-Input">
				<label>회사: </label>
				<input type="text" class="UserCompany SelectInput" value=<%=UserCompany %> readonly>
			</div>
			<div class="Domestic-Main-Input">
				<label>회계단위: </label>
				<div class="ColumnInput">
					<input class="BizCode SelectInput" onclick="InfoSearch('BizArea')" readonly>
					<input class="BizCodeDes" readonly>
				</div>
			</div>
			<div class="Domestic-Main-Input">
				<label>거래처: </label>
				<div class="ColumnInput">
					<input class="DealComCode SelectInput" placeholder="Select" onclick="InfoSearch('TradeCom')" readonly>
					<input class="DealComCodeDes" readonly>
				</div>
			</div>
			<div class="Domestic-Main-Input">
				<label>매출마감월: </label>
				<div class="ColumnInput SalesRouteArea">
					<select class="SalesClsMonth" id="SalesClsMonth">
					</select>
				</div>
			</div>
			
			<div class="Domestic-Main-Input">
				<label>마감차수: </label>
				<div class="ColumnInput SalesRouteArea">
					<select class="SalesClsOrder">
						<option>SELECT</option>
						<option value="1">1차</option>
						<option value="2">2차</option>
						<option value="3">3차</option>
					</select>
				</div>
			</div>
			
			<div class="Domestic-Main-Input">
				<label>과세구분: </label>
				<div class="ColumnInput SalesRouteArea">
					<select class="SalesTexType">
						<option value="T10">T10 과세(Taxable)</option>
						<option value="T20">T20 면세(Exempt)</option>
						<option value="T30">T30 영세율(Zero-Rated)</option>
						<option value="T40">T40 비과세(Non-Taxable)</option>
						<option value="T50">T50 면제(tax-exempt)</option>
						<option value="T60">T60 간이과세(Simplified Taxation)</option>
						<option value="T70">T70 수입과세(Import Taxable)</option>
					</select>
				</div>
			</div>
			
			<div class="Domestic-Main-Input">
				<label>마감일자: </label>
				<div class="ColumnInput SalesRouteArea">
					<input type="date" class="SalesEndDate">
				</div>
			</div>
			
			<div class="Domestic-Main-Input">
				<label>납품일자: </label>
				<div class="ColumnInput SalesRouteArea">
					<input type="date" class="StartDate">
					<input type="date" class="EndDate"><!-- SalesRouteCodeDes -->
				</div>
			</div>
			
			<div class="BtnArea">
				<button class="DoItBtn">실행</button>
			</div>
		</div>
		
		<div class="Domestic-Sub">
			<div class="Domestic-Sub-Header">국판 매출 마감 대상 현황</div>
			
			<div class="DomesticInfoArea">
				<table class="ConfirmTable">
					<thead>
						<th>선택</th><th>반출일자</th><th>납품번호</th><th>항번</th><th>품번</th><th>품명</th><th>납품수량</th><th>수량단위</th>
						<th>개당가격</th><th>공급가액</th><th>부가세액</th><th>합계</th><th>거래처</th><th>Tax구분</th>
					</thead>
					<tbody class="ConfirmTable_Body">
					</tbody>
				</table>
			</div>
			
			<div class="BtnArea">
				<button class="SaveBtn">저장</button>
			</div>
		</div>
	</div>
</body>
</html>
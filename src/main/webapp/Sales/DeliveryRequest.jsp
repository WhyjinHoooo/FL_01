<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<meta charset="UTF-8">
<title>납품요청(지시)</title>
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
	function InitialTable(){
		$('.PendingTable_Body').empty();
		$('.PlannedTable_Body').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 11; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.PendingTable_Body').append(row);
        }
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 13; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.PlannedTable_Body').append(row);
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
	
	$('.BalanceAdjDate').change(function(){
		var DispatchDate = $('.BalanceAdjDate').val();
		$.ajax({
			type: "POST",
			url: "${contextPath}/Sales/ajax/Sales_CreateDel_Cmd_PlanNo.jsp",
			data: { Date : DispatchDate},
			success: function(response){
 				$('.DeliveryPlanNo').val(response.trim());
 				$('.PlannedTable_Body').empty();
			}
		});
	});
	
	$('.SalesRouteCode').change(function(){
		var Value = $(this).val();
		$('.SalesRouteCodeDes').val(Value.substring(4));
	})
	
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
				url: '${contextPath}/Sales/ajax/DelReqFetch.jsp',
				type: 'POST',
				data: JSON.stringify(InfoList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data) {
					console.log(data);
					console.log(data.length);
					if(data.length > 0){
						$('.PendingTable_Body').empty();
						// 그룹별 카운트를 저장할 객체
// 						var groupedData = {};

// 						// 데이터 그룹화: DelPlanOrderNum와 MatCode를 키로 사용
// 						for (var i = 0; i < data.length; i++) {
// 						    var key = data[i].DelPlanOrderNum + "_" + data[i].MatCode;
// 						    console.log(key);
// 						    if (!groupedData[key]) {
// 						        groupedData[key] = [];
// 						    }
// 						    groupedData[key].push(i); // 같은 그룹의 인덱스를 저장
// 						}

// 						// 각 그룹을 처리하여 Seq 
// 						for (var key in groupedData) {
// 						    var indices = groupedData[key]; // 해당 그룹에 속한 인덱스들
// 						    for (var j = 0; j < indices.length; j++) {
// 						        var index = indices[j];
// 						        var row = '<tr>' +
// 						            '<td><input type="checkbox" class="checkboxBtn"></td>' + // 체크 박스 1
// 						            '<td>' + data[index].OutDate + '</td>' + // 반출예정일자 2
// 						            '<td>' + data[index].DealCom + '</td>' + // 거래처 3
// 						            '<td>' + data[index].DelPlanOrderNum + '</td>' + // 납품계획번호 4
// 						            '<td>' + data[index].Seq + '</td>' + // 같은 그룹 내에서 증가하는 Seq 값 5
// 						            '<td>' + data[index].MatCode + '</td>' + // 품번 6
// 						            '<td>' + data[index].MatCodeDes + '</td>' + // 품명 7 
// 						            '<td>' + data[index].DelQuantity + '</td>' + // 납품수량 8
// 						            '<td>' + data[index].Unit + '</td>' + // 수량단위 9
// 						            '<td>' + data[index].TPChannel + '</td>' + // 운송수단 10
// 						            '<td>' + data[index].FinalPlace + '</td>' + // 인도장소 11
// 						            '<td hidden>' + data[index].Channel + '</td>' + // 판매경로 12
// 						            '</tr>';
// 						        $('.PendingTable_Body').append(row);
// 						    }
// 						}
						for(var i = 0 ; i < data.length ; i++){
							var row = '<tr>' +
							'<td><input type="checkbox" class="checkboxBtn"></td>' + //체크 박스 1
							'<td>' + data[i].OutDate + '</td>' + // 반출예정일자 2
							'<td>' + data[i].DealCom + '</td>' + // 거래처 3
							'<td>' + data[i].DelPlanOrderNum + '</td>' + // 납품계획번호 4
							'<td>' + data[i].Seq + '</td>' + // 납품계획항번 5
							'<td>' + data[i].MatCode + '</td>' + // 품번 6
							'<td>' + data[i].MatCodeDes + '</td>' + // 품명 7 
							'<td>' + data[i].DelQuantity + '</td>' + // 납품수량 8
							'<td>' + data[i].Unit + '</td>' + // 수량단위 9
							'<td>' + data[i].TPChannel + '</td>' + // 운송수단 10
							'<td>' + data[i].FinalPlace + '</td>' + // 인도장소 11
							'<td hidden>' + data[i].Channel + '</td>' + // 판매경로 12
							'<td hidden>' + data[i].ArrivePlace + '</td>' + // 납품장소 13
							'</tr>';
							$('.PendingTable_Body').append(row);
						};
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
	var PeriodList = {};
	$('.button-text'). on('click', function(){
		var DocCode = $('.DeliveryPlanNo').val(); // 납품번호
		var OutDate = $('.BalanceAdjDate').val(); // 반출일자
		console.log('DocCode : ' + DocCode);
		
		$('.PendingTable_Body tr').each(function(index, tr){
			var $tr = $(tr);
			var $Chk = $tr.find('input[type="checkbox"]');
			if($Chk.prop('checked')){
				var OrderNum = $tr.find('td:nth-child(4)').text().trim(); // 납품계획번호
				var TradeCom = $tr.find('td:nth-child(3)').text().trim(); // 거래처
				var TradeComDes = $('.DealComCodeDes').val(); // 거래처명
				var Count = $tr.find('td:nth-child(5)').text().trim(); // 항번
				var MatCode = $tr.find('td:nth-child(6)').text().trim(); // 품번
				var MatDes = $tr.find('td:nth-child(7)').text().trim(); // 품명
				var MatQty = $tr.find('td:nth-child(8)').text().trim(); // 납품수량
				var MatUnit = $tr.find('td:nth-child(9)').text().trim(); // 수량단위
				var TPWay = $tr.find('td:nth-child(10)').text().trim(); // 운송수단
				var FianlPlace = $tr.find('td:nth-child(11)').text().trim(); // 인도장소
				var Channel = $tr.find('td:nth-child(12)').text().trim(); // 판매경로
				var ArrivPlace = $tr.find('td:nth-child(13)').text().trim(); // 납품장소
				
				if (!PeriodList[DocCode]) {
	                PeriodList[DocCode] = [];
	            }
				PeriodList[DocCode].push({ 
					OrderNum : OrderNum, TradeCom : TradeCom, TradeComDes : TradeComDes, MatCode : MatCode, MatDes : MatDes,
					MatQty : MatQty, MatUnit : MatUnit, TPWay : TPWay, FianlPlace : FianlPlace, Channel: Channel, ArrivPlace : ArrivPlace
					});
			}
		})
		console.log(PeriodList);
// 		console.log(PeriodList[DocCode].length);
		console.log(PeriodList[DocCode][0].TradeCom);
		if(PeriodList[DocCode].length > 0){
			var YesNo = false;
		    
		    // PendingTable_Body에 tr가 존재하는지 확인
		    var PlanningTr = $('.PlannedTable_Body tr');
		    console.log(PlanningTr.length);
		    if (PlanningTr.length === 50) {
		        console.log("No <tr> elements found in PendingTable_Body.");
		    }
		    
		    PlanningTr.each(function(){
		        var FirstText =  $(this).find('td:nth-child(3)').text().trim();
		        console.log('FirstText : ' + FirstText);
		        if(FirstText === DocCode){
		            YesNo = true;
		            return false;
		        }
		    });
		    if(YesNo){
		        alert('해당 납품계획문서가 작성중입니다.');
		        return false;
		    }
			
			$('.PlannedTable_Body').empty();
			for(var i = 0 ; i < PeriodList[DocCode].length ; i++){
				var row = 
				'<tr>' + 
					'<td>' + (i+1) + '</td>' + // 항번 1
					'<td>' + OutDate + '</td>' + // 반출예정일자 2
					'<td>' + DocCode + '</td>' + // 납품번호 3
					'<td>' + (i+1) + '</td>' + // 항번 4
					'<td>' + PeriodList[DocCode][i].MatCode + '</td>' + // 품번 5
					'<td>' + PeriodList[DocCode][i].MatDes + '</td>' + // 품명 6
					'<td>' + PeriodList[DocCode][i].MatQty + '</td>' + // 납품수량 7
					'<td>' + PeriodList[DocCode][i].MatUnit + '</td>' + // 수량단위 8
					'<td>' + PeriodList[DocCode][i].TPWay + '</td>' + // 운송수단 9 
					'<td>' + PeriodList[DocCode][i].FianlPlace + '</td>' +// 인도장소 10
					'<td>' + PeriodList[DocCode][i].TradeCom + '</td>' +// 거래처 11
					'<td>' + PeriodList[DocCode][i].TradeComDes + '</td>' +// 거래첨명 12
					'<td>' + PeriodList[DocCode][i].OrderNum + '</td>' +// 납품지시번호 13
					'<td hidden>' + PeriodList[DocCode][i].Channel + '</td>' +// 납품지시번호 14
					'<td hidden>' + PeriodList[DocCode][i].ArrivPlace + '</td>' +// 납품장소 15
				'</tr>';
				$('.PlannedTable_Body').append(row);
			}
		}
		
	});
	
	$('.SaveBtn').on('click',function(){
		var UniqueValue = new Set();
		var Sum = 0;
		var SaveList = {};
		$('.PlannedTable_Body tr').each(function(index, tr){
			var $tr = $(tr);
			var DelPlanNo = $('.DeliveryPlanNo').val();
 			var PlanningDate = $('.BalanceAdjDate').val();
			console.log('DelPlanNo : ' + DelPlanNo);
			console.log('DelPlanNo : ' + $('.PlannedTable_Body tr').length);
			
			var key = $tr.find('td:nth-child(5)').text().trim();
			
			if(!UniqueValue.has(key)){
				UniqueValue.add(key);
				
				var Quantity = parseFloat($tr.find('td:nth-child(7)').text().trim()) || 0;
				Sum += Quantity;
			}
			
			if(DelPlanNo){
				var HeadDataList = [];
				HeadDataList.push(DelPlanNo); // 납품번호
				HeadDataList.push(PlanningDate); // 반출일자
				HeadDataList.push($('.DealComCode').val()); // 거래처
				HeadDataList.push($('.PlannedTable_Body tr').length); // 품번개수
				HeadDataList.push(Sum); // 납품총수량
// 				HeadDataList.push($('.BalanceAdjDate').val()); // 납품확정일시 제외
				HeadDataList.push($('.BizCode').val()); // 회계단위
				HeadDataList.push($('.UserCompany').val()); // 회사
				HeadDataList.push(DelPlanNo + $('.UserCompany').val()); //키값
				
				var childList = [];
				childList.push($tr.find('td:nth-child(2)').text()); // 반출일자
				childList.push($tr.find('td:nth-child(3)').text()); // 납품번호
				childList.push($tr.find('td:nth-child(4)').text()); // 항번
				childList.push($tr.find('td:nth-child(5)').text()); // 품번
				childList.push($tr.find('td:nth-child(6)').text()); // 품명
				childList.push($tr.find('td:nth-child(7)').text()); // 납품수량
				childList.push($tr.find('td:nth-child(8)').text()); // 수량단위
				childList.push($tr.find('td:nth-child(9)').text()); // 운송수단
				childList.push($tr.find('td:nth-child(10)').text()); // 인도장소
				childList.push($tr.find('td:nth-child(11').text()); // 거래처
				childList.push($tr.find('td:nth-child(13)').text()); // 납품계획번호
				childList.push($tr.find('td:nth-child(14)').text()); // 판매경로
				childList.push($tr.find('td:nth-child(15)').text()); // 납품장소
				childList.push($('.BizCode').val()); // 회계단위
				childList.push($('.UserCompany').val()); // 회사
				
				if(!SaveList[DelPlanNo]){
					SaveList[DelPlanNo] = {HeadDataList: [], ChildList: []};
				}
				
				SaveList[DelPlanNo].HeadDataList = HeadDataList;
				SaveList[DelPlanNo].ChildList.push(childList);
			}
		});
		console.log(Sum);
		console.log(SaveList);
		
		$.ajax({
			url: '${contextPath}/Sales/ajax/DelRequestSave.jsp',
			type: 'POST',
			data: JSON.stringify(SaveList),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: 'false',
			success: function(data){
				if(data.status === "Success"){
					InitialTable();
					const resetElements = [
		        		".DealComCode", ".DealComCodeDes",
		        		".StartDate", ".EndDate",
		        		".BalanceAdjDate", ".DeliveryPlanNo"
		    	    ];
					resetElements.forEach(selector => {
		    	        const element = document.querySelector(selector);
		    	        if (element) {
		    	        	if(selector === ".DealComCode"){
		    	        		element.value = 'SELECT';
		    	        	}else{
		    	        		element.value = '';  // 나머지는 빈 값으로 초기화
		    	        	}
		    	        }
		    	    });
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
	<div class="DelOrderArea">
		<div class="DelOrder-Main">
			<div class="DelOrder-Main-Header">SEARCH FIELDS</div>
			<div class="DelOrder-Main-Input">
				<label>회사: </label>
				<input type="text" class="UserCompany SelectInput" value=<%=UserCompany %> readonly>
			</div>
			<div class="DelOrder-Main-Input">
				<label>회계단위: </label>
				<div class="ColumnInput">
					<input class="BizCode SelectInput" onclick="InfoSearch('BizArea')" readonly>
					<input class="BizCodeDes" readonly>
				</div>
			</div>
			<div class="DelOrder-Main-Input">
				<label>거래처: </label>
				<div class="ColumnInput">
					<input class="DealComCode SelectInput" placeholder="Select" onclick="InfoSearch('TradeCom')" readonly>
					<input class="DealComCodeDes" readonly>
				</div>
			</div>
			<div class="DelOrder-Main-Input">
				<label>납품예정일자: </label>
				<div class="ColumnInput SalesRouteArea">
					<input type="date" class="SalesRouteCodeDes StartDate">
					<input type="date" class="SalesRouteCodeDes EndDate">
				</div>
			</div>
			
			<div class="BtnArea">
				<button class="DoItBtn">실행</button>
			</div>
		</div>
		<div class="DelOrder-Sub">
			<div class="DelOrder-Sub-Header">납품계획 미수립 수주현황</div>
			
			<div class="DelShowInfoArea">
				<table class="PendingTable">
					<thead>
						<th>선택</th><th>반출예정일자</th><th>거래처</th><th>납품계획번호</th><th>납품계획항번</th><th>품번</th><th>품명</th><th>납품수량</th>
						<th>수량단위</th><th>운송수단</th><th>인도장소</th>
					</thead>
					<tbody class="PendingTable_Body">
					</tbody>
				</table>
			</div>
			
			<div class="BtnArea">
				<div class="DelPlanBtnSetup">
					<label>반출일자: </label>
						<input class="BalanceAdjDate" type="date">
					<label>납품번호: </label>
						<input class="DeliveryPlanNo" type="text" readonly>
				</div>
				<button class="custom-button">
					<img src="${contextPath}/img/Dvector.png" alt="Button Image">
	  				<span class="button-text">반영</span>
				</button>
				<button class="SaveBtn">저장</button>
			</div>
			
			<div class="DelResultInfoArea">
				<table class="PlannedTable">
					<thead>
						<th>항번</th><th>반출예정일자</th><th>납품번호</th><th>항번</th><th>품번</th><th>품명</th><th>납품수량</th><th>수량단위</th><th>운송수단</th>
						<th>인도장소</th><th>거래처</th><th>거래처명</th><th>납품지시번호</th>
					</thead>
					<tbody class="PlannedTable_Body">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
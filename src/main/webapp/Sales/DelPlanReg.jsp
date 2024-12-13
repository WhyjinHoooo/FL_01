<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<meta charset="UTF-8">
<title>납품계획 등록</title>
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
// 		for (let i = 0; i < 50; i++) {
//             const row = $('<tr></tr>'); // 새로운 <tr> 생성
//             // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
//             for (let j = 0; j < 7; j++) {
//                 row.append('<td></td>');
//             }
//             // 생성한 <tr>을 <tbody>에 추가
//             $('.PlannedTable_Body').append(row);
//         }
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
		var SalesRoute = $('.SalesRouteCode').val();
		var DispatchDate = $('.BalanceAdjDate').val();
		$.ajax({
			type: "POST",
			url: "${contextPath}/Sales/ajax/Sales_CreateDelPlanNo.jsp",
			data: {Route : SalesRoute, Date : DispatchDate},
			success: function(response){
				$('.DeliveryPlanNo').val(response.trim());
			}
		});
	});
	
	$('.SalesRouteCode').change(function(){
		var Value = $(this).val();
		$('.SalesRouteCodeDes').val(Value.substring(4));
	})
	
	$('.DoItBtn').on('click',function(){
		var DealCom = $('.DealComCode').val();
		var DealComDes = $('.DealComCodeDes').val();
		var UCom = $('.UserCompany').val();
		var UBizArea = $('.BizCode').val();
		InfoList = [UCom, UBizArea, DealCom, DealComDes]
		if(DealCom === ''){
			alert('거래처를 선택해주세요.');
			return false;
		} else{
			console.log(InfoList);
			$.ajax({
				url: '${contextPath}/Sales/ajax/CustOrderFetch.jsp',
				type: 'POST',
				data: JSON.stringify(InfoList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data) {
					console.log(data);
					if(data.length > 0){
						$('.PendingTable_Body').empty();
						for(var i = 0 ; i < data.length ; i++){
							var row = '<tr>' +
							'<td><input type="checkbox" class="checkboxBtn"></td>' + //체크 박스 1
							'<td>' + data[i].OreNumber + '</td>' + // 고객주문번호 2
							'<td>' + data[i].RecvDate + '</td>' + // 수주접수일자 3
							'<td>' + data[i].MatCode + '</td>' + // 품번 4
							'<td>' + data[i].MatCodeDes + '</td>' + // 품명 5
							'<td>' + data[i].Unit + '</td>' + // 수령단위 6
							'<td>' + data[i].OrderCount + '</td>' + // 주문수량 7 
							'<td>' + data[i].DeliveredQty + '</td>' + // 납품완료수량 8
							'<td>' + data[i].OrderBalance + '</td>' + // 납품잔량 9
							'<td>' + data[i].DeliverDate + '</td>' + // 납품희망일자 10
							'<td>' + data[i].ArrivePlace + '</td>' + // 납품장소 11
							'</tr>';
							$('.PendingTable_Body').append(row);
						};
					};
				}
			});
		};
	});
	var PeriodList = {};
	$('.button-text'). on('click', function(){
		var DocCode = $('.DeliveryPlanNo').val();
		console.log('DocCode : ' + DocCode);
		
		$('.PendingTable_Body tr').each(function(index, tr){
			var $tr = $(tr);
			var $Chk = $tr.find('input[type="checkbox"]');
			if($Chk.prop('checked')){
				var TradeCom = $tr.find('td:nth-child(2)').text().trim(); // 고객주문번호
				var MatCode = $tr.find('td:nth-child(4)').text().trim(); // 품번
				var MatDes = $tr.find('td:nth-child(5)').text().trim(); // 품명
				var MatQty = $tr.find('td:nth-child(6)').text().trim(); // 수량단위
				var MatRemainQty = $tr.find('td:nth-child(9)').text().trim(); // 납품잔량
				var ArrivePlace = $tr.find('td:nth-child(11)').text().trim();
					
				if (!PeriodList[DocCode]) {
	                PeriodList[DocCode] = [];
	            }
				PeriodList[DocCode].push({ TradeCom: TradeCom, MatCode: MatCode, MatDes: MatDes, MatQty: MatQty, MatRemainQty: MatRemainQty, Place: ArrivePlace});
			}
		})
		console.log(PeriodList);
		console.log(PeriodList[DocCode].length);
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
		        var FirstText =  $(this).find('td:nth-child(1)').text().trim();
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
					'<td hidden>' + DocCode + '</td>' + // 납품계획번호 1
					'<td>' + (i+1) + '</td>' + // 항번 2
					'<td>' + PeriodList[DocCode][i].TradeCom + '</td>' + // 고객주문번호 3
					'<td>' + PeriodList[DocCode][i].MatCode + '</td>' + // 품번 4
					'<td>' + PeriodList[DocCode][i].MatDes + '</td>' + // 품명 5
					'<td>' + PeriodList[DocCode][i].MatQty + '</td>' + // 수량단위 6
					'<td>' + PeriodList[DocCode][i].MatRemainQty + '</td>' + // 납품잔량 7
					'<td><input type="text" class="DeliverPlanQuanty" required></td>' + // 남품계획수량 8
					'<td hidden>' + PeriodList[DocCode][i].Place + '</td>' + // 남품계획수량 9
				'</tr>';
				$('.PlannedTable_Body').append(row);
			}
		}
		
	});
	
	$('.SaveBtn').on('click',function(){
		var SaveList = {};
		$('.PlannedTable_Body tr').each(function(index, tr){
			var $tr = $(tr);
			var DelPlanNo = $tr.find('td:nth-child(1)').text();
			var PlanningDate = $('.BalanceAdjDate').val();
			console.log('DelPlanNo : ' + $('.PlannedTable_Body tr').length);
			
			
			if(DelPlanNo){
				var HeadDataList = [];
				HeadDataList.push(DelPlanNo); // 납품계획번호
				HeadDataList.push($('.DealComCode').val()); // 거래처
				HeadDataList.push($('.BalanceAdjDate').val()); // 반출예정일자
				HeadDataList.push($('.PlannedTable_Body tr').length); // 품번갯수
				/* HeadDataList.push($('.BalanceAdjDate').val()); // 납품장소 */
				HeadDataList.push($('.BizCode').val()); // 회계단위
				HeadDataList.push($('.UserCompany').val()); // 회사
				
				
			
				var childList = [];
				childList.push($tr.find('td:nth-child(2)').text()); // 항번
				childList.push($tr.find('td:nth-child(3)').text()); // 고객주문번호
				childList.push($tr.find('td:nth-child(4)').text()); // 품번
				childList.push($tr.find('td:nth-child(5)').text()); // 품명
				childList.push($tr.find('td:nth-child(6)').text()); // 수량단위
				childList.push($tr.find('td:nth-child(9)').text()); // 납품장소
				$tr.find('td input[type="text"]').each(function(){
					childList.push($(this).val()); // 납품계획수량	
				});
				childList.push($('.SalesRouteCode').val()); // 판매경로
				
				if(!SaveList[DelPlanNo]){
					SaveList[DelPlanNo] = {HeadDataList: [], ChildList: []};
				}
				
				SaveList[DelPlanNo].HeadDataList = HeadDataList;
				SaveList[DelPlanNo].ChildList.push(childList);
			}
		});
		console.log(SaveList);
		
		$.ajax({
			url: '${contextPath}/Sales/ajax/DelPlanSave.jsp',
			type: 'POST',
			data: JSON.stringify(SaveList),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: 'false',
			success: function(data){
				if(data.status === "Success"){
					InitialTable();
					const resetElements = [
		        		".DealComCodeDes",".SalesRouteCodeDes",
		        		".DealComCode", ".BalanceAdjDate",
		        		".DeliveryPlanNo"
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
		    	    const updatedOptions = `
						<option>SELECT</option>
						<option value="EX1,직수출">EX1</option>
						<option value="EX2,국판매출">EX2</option>
						<option value="EX3,대행수출">EX3</option>
						<option value="EX4,삼국수출">EX4</option>
						<option value="EX5,기타매출">EX5</option>
	                `;
	                $(".SalesRouteCode").html(updatedOptions);
	                console.log('저장되었습니다.');
				}else{
					console.log('저장 실패');
				}
			},
		    error: function(xhr, status, error) {
		        console.log('AJAX 요청 실패:', error);
		    }
		})
	});
});
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
	<div class="DelPlanArea">
		<div class="DelPlan-Main">
			<div class="DelPlan-Main-Header">SEARCH FIELDS</div>
			<div class="DelPlan-Main-Input">
				<label>회사: </label>
				<input type="text" class="UserCompany SelectInput" value=<%=UserCompany %> readonly>
			</div>
			<div class="DelPlan-Main-Input">
				<label>회계단위: </label>
				<div class="ColumnInput">
					<input class="BizCode SelectInput" onclick="InfoSearch('BizArea')" readonly>
					<input class="BizCodeDes" readonly>
				</div>
			</div>
			<div class="DelPlan-Main-Input">
				<label>거래처: </label>
				<div class="ColumnInput">
					<input class="DealComCode SelectInput" placeholder="Select" onclick="InfoSearch('TradeCom')" readonly>
					<input class="DealComCodeDes" readonly>
				</div>
			</div>
			<div class="DelPlan-Main-Input">
				<label>판매경로: </label>
				<div class="ColumnInput SalesRouteArea">
					<select class="SalesRouteCode SelectInput">
						<option>SELECT</option>
						<option value="EX1,직수출">EX1</option>
						<option value="EX2,국판매출">EX2</option>
						<option value="EX3,대행수출">EX3</option>
						<option value="EX4,삼국수출">EX4</option>
						<option value="EX5,기타매출">EX5</option>
					</select>
					<input class="SalesRouteCodeDes" readonly>
				</div>
			</div>
			
			<div class="BtnArea">
				<button class="DoItBtn">실행</button>
			</div>
		</div>
		<div class="DelPlan-Sub">
			<div class="DelPlan-Sub-Header">납품계획 미수립 수주현황</div>
			
			<div class="DelShowInfoArea">
				<table class="PendingTable">
					<thead>
						<th>선택</th><th>고객주문번호</th><th>수주접수일자</th><th>품번</th><th>품명</th><th>수령단위</th><th>주문수량</th><th>납품완료수량</th>
						<th>납품잔량</th><th>납품희망일자</th><th>납품장소</th>
					</thead>
					<tbody class="PendingTable_Body">
					</tbody>
				</table>
			</div>
			
			<div class="BtnArea">
				<div class="DelPlanBtnSetup">
					<label>반출예정일자: </label>
						<input class="BalanceAdjDate" type="date">
					<label>납품계획번호: </label>
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
						<th>항번</th><th>고객주문번호</th><th>품번</th><th>품명</th><th>수량단위</th><th>납품잔량</th><th>납품계획수량</th>
					</thead>
					<tbody class="PlannedTable_Body">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
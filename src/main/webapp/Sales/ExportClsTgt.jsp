<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<meta charset="UTF-8">
<title>수출 마감 대상 확정</title>
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
		$('.ConfirmTable_Body').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 17; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.ConfirmTable_Body').append(row);
        }
	}
	function updateConfirmTableData() {
        var TableBody = document.querySelector('.ConfirmTable_Body');
        if (TableBody && TableBody.rows.length > 0) {
            var ChkDataLust = [];
            var ChkTotalItemCount = 0;
            var ChkSPriceSum = 0;
            var ChkVATSum = 0;
            var ChkToTalSum = 0;

            // 각 tr을 순회
            $('.ConfirmTable_Body tr').each(function(index, tr) {
                var $tr = $(tr);
                var $Chk = $tr.find('input[type="checkbox"]');
                
                // 체크된 항목만 처리
                if ($Chk.prop('checked')) {
                	function FormChange(value){
                    	return parseFloat(value.replace(/,/g,'').trim() || 0);
                    }
                    var MatCode = $tr.find('td:nth-child(7)').text().trim(); // 반출일자
					var ConfirmCount = FormChange($tr.find('td:nth-child(9)').text()); // 납품수량
//                     var SPriceSum = FormChange($tr.find('td:nth-child(13)').text()); // 공급가액
//                     var VATSum = FormChange($tr.find('td:nth-child(11)').text()); // 부가세액
                    var ToTalSum = FormChange($tr.find('td:nth-child(16)').text()); // 합계

                    // 고유값 추가 함수
                    function AddUnique(Value) {
                        if (!ChkDataLust.includes(Value)) {
                            ChkDataLust.push(Value);
                        }
                    }
                    AddUnique(MatCode);
                    ChkTotalItemCount += ConfirmCount;
                    ChkSPriceSum += ToTalSum;
//                     ChkVATSum += VATSum;
                    ChkToTalSum += ToTalSum;
                    	
                }
            });
            $('.FProCount').val(ChkDataLust.length);  // 마감 품목 수
            $('.FProTotal').val(ChkTotalItemCount);  // 마감수량
            $('.SPriceSum').val(ChkSPriceSum.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));// 공급가액 합계
//             $('.VATSum').val(ChkVATSum.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));// 부가가치세 합계
            $('.ToTalSum').val(ChkToTalSum.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));// 총 합계
        }
    };
    
    var Trg_SalesConMonth = document.getElementById('SalesClsMonth');
	var CurrentYear = new Date().getFullYear();
	var Initial_Year = CurrentYear + 100;
	var MonthList = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
	for(let year = CurrentYear ; year < Initial_Year ; year++){
		for(var i = 0 ; i < MonthList.length ; i++){
			var option = document.createElement('option');
			option.value = year + '.' + MonthList[i];
			option.textContent = year + '.' + MonthList[i] + '.월';
			Trg_SalesConMonth.appendChild(option);
		}
	};
	setTimeout(function() {
	    $("#SalesClsMonth").trigger("change");
	}, 100);
	$("#SalesClsMonth").on("change", function() {
		console.log('사용자가 선택한 값:', this.value);
	    // 여기에 원하는 동작을 추가
	    var [year, month] = this.value.split('.');
	    // 선택된 월의 다음 달의 0일을 설정 (이전 달의 마지막 날)
	    var lastDay = new Date(year, month, 1);
	    // YYYY-MM-DD 형식으로 포맷팅
	    var EndDate = lastDay.toISOString().split('T')[0];
	    $('.EndDate, .SalesEndDate').attr({
	        'value': EndDate
	    });
	});

	$(document).on('change', '.ConfirmTable_Body input[type="checkbox"]', function() {
        updateConfirmTableData();
    });
	
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
		var EndMonth = $('.SalesClsMonth').val();
		
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
						            '<td>' + EndMonth + '</td>' + // 반출예정일자 2
						            '<td>' + data[index].DealCom + '</td>' + // 납품번호 3
						            '<td>' + '' + '</td>' + // 항번 4
						            '<td>' + data[index].OrderNum + '</td>' + // 납품번호 5
						            '<td>' + data[index].Seq + '</td>' + // 항번 6 
						            '<td>' + data[index].MatCode + '</td>' + // 품번 7
						            '<td>' + data[index].MatCodeDes + '</td>' + // 품명 8
						            '<td>' + data[index].Quantity + '</td>' + // 납품수량 9 
						            '<td>' + data[index].Unit + '</td>' + // 수량단위 10
						            '<td>' + data[index].UnitPrice.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '</td>' + // 판매단가 11
						            '<td>' + 'USD' + '</td>' + // 거래통화 12
						            '<td>' + ((data[index].Quantity * data[index].UnitPrice)).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '</td>' + // 거래통화매출금액 13
						            '<td>' + 'BRE' + '</td>' + // 환율유형 14
						            '<td>' + '1475.29' + '</td>' + // 환율
						            '<td>' + ((data[index].Quantity * data[index].UnitPrice * 1475.29)).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '</td>' + // 장부통화매출금액
						            '<td>' + 'KRW' + '</td>' + // 장부통화
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
		var DataList = [];
		var TotalItemCount = 0;
		$('.ConfirmTable_Body tr').each(function(index, tr){
			var $tr = $(tr);
			var $Chk = $tr.find('input[type="checkbox"]');
			
			var MatCode = $tr.find('td:nth-child(7)').text().trim(); // 테스트
			var Count = parseInt($tr.find('td:nth-child(9)').text().trim()); // 테스트
			function AddUnique(Value){
				if(!DataList.includes(Value)){
					DataList.push(Value)
				}
			}
			AddUnique(MatCode)
			TotalItemCount += Count;
		})
		$('.CloseItemCount').val(DataList.length);
		$('.CloseItemTotal').val(TotalItemCount);
	});
	
	var SaveList = {};
	$('.SaveBtn').on('click',function(){
		var Month = $('.SalesClsMonth').val(); // 매출마감월
		var TaxCode = $('.SalesTaxType').val(); // 과세구분(세율코드)
		var TaxInvoiceDate = $('.SalesEndDate').val();
		var SalesChannel = 'DO1';
		var BizArea = $('.BizCode').val();
		var UserCom = $('.UserCompany').val();
		var SalesClsOrder = $('.SalesClsOrder').val(); // 매출마감차수
		var KeyValue = null;
		
		var OrderNum = null;
		var DealCom = null;
		$('.ConfirmTable_Body tr').each(function(index, tr){
			var $tr = $(tr);
			var $Chk = $tr.find('input[type="checkbox"]');
			if($Chk.prop('checked')){
				OrderNum = $tr.find('td:nth-child(3)').text().trim(); // 납품번호
				var Seq = String($tr.find('td:nth-child(4)').text().trim()).padStart(2, '0'); // 항번
				var MatCode = $tr.find('td:nth-child(5)').text().trim(); // 품번
				var MatCodeDes = $tr.find('td:nth-child(6)').text().trim(); // 품번
				var DelivOrdQty = $tr.find('td:nth-child(7)').text().trim(); // 납품수량
				var QtyUnit = $tr.find('td:nth-child(8)').text().trim(); // 수량단위
				var SalesUnitPrice = $tr.find('td:nth-child(9)').text().trim(); // 판매단가
				var LocalCurr = 'KRW'; // 장부통화
				var ExRate = 1; // 환율
				var ExRateType = 'BRE'; // 환율유형
				DealCom = $tr.find('td:nth-child(13)').text().trim(); // 거래처
				KeyValue = OrderNum + Seq + UserCom;
				if(!SaveList[KeyValue]){
					SaveList[KeyValue] = [];
				}
				SaveList[KeyValue].push({
					Month : Month, DealCom : DealCom, OrderNum : OrderNum, Seq : Seq, MatCode : MatCode, MatCodeDes : MatCodeDes,
					DelivOrdQty : DelivOrdQty, DelivOrdQty : DelivOrdQty, SalesUnitPrice : SalesUnitPrice, LocalCurr : LocalCurr,
					ExRateType : ExRateType, ExRate : ExRate, LocalCurr : LocalCurr, TaxCode : TaxCode, SalesChannel : SalesChannel,
					BizArea : BizArea, UserCom : UserCom, QtyUnit : QtyUnit, TaxInvoiceDate : TaxInvoiceDate, SalesClsOrder: SalesClsOrder
				})
			}
		})
		console.log(SaveList);
		$.ajax({
			url: '${contextPath}/Sales/ajax/DomesticClsTgtSave.jsp',
			type: 'POST',
			data: JSON.stringify(SaveList),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(data){
				if(data.status === "Success"){
					SaveList = {}
					InitialTable();
					const resetElements = [
						".CloseItemCount",	".CloseItemTotal",
						".FProCount", ".FProTotal", ".SPriceSum",
						".VATSum", ".ToTalSum",
						".DealComCode", ".DealComCodeDes",
						".SalesClsMonth", ".SalesClsOrder",
						".SalesTaxType", ".StartDate"
					]
					resetElements.forEach(selector => {
						const element = document.querySelector(selector);
						if(element){
							if(element === ".DealComCode"){
								element.value = '';
								element.attr('placeholder', 'SELECT');
							}else if(element === ".SalesClsMonth" || element === ".SalesClsOrder" ||element === ".SalesTaxType"){
								 $('.SalesClsMonth').prop('selectedIndex', 0);
							}else{
								element.value = '';
							}
							
						}
					})
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
	<div class="OverseasArea">
		<div class="Overseas-Main"><!-- DelOrder-Main -->
			<div class="Overseas-Main-Header">SEARCH FIELDS</div>
			<div class="Overseas-Main-Input">
				<label>회사: </label>
				<input type="text" class="UserCompany SelectInput" value=<%=UserCompany %> readonly>
			</div>
			<div class="Overseas-Main-Input">
				<label>회계단위: </label>
				<div class="ColumnInput">
					<input class="BizCode SelectInput" onclick="InfoSearch('BizArea')" readonly>
					<input class="BizCodeDes" readonly>
				</div>
			</div>
			<div class="Overseas-Main-Input">
				<label>거래처: </label>
				<div class="ColumnInput">
					<input class="DealComCode SelectInput" placeholder="Select" onclick="InfoSearch('TradeCom')" readonly>
					<input class="DealComCodeDes" readonly>
				</div>
			</div>
			<div class="Overseas-Main-Input">
				<label>매출마감월: </label>
				<div class="ColumnInput SalesRouteArea">
					<select class="SalesClsMonth" id="SalesClsMonth">
					</select>
				</div>
			</div>
			
			<div class="Overseas-Main-Input">
				<label>마감일자: </label>
				<div class="ColumnInput SalesRouteArea">
					<input type="date" class="SalesEndDate">
				</div>
			</div>
			
			<div class="Overseas-Main-Input">
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
		
		<div class="Overseas-Sub">
			<div class="Overseas-Sub-Header">수출 매출 마감 대상 현황</div>
			
			<div class="OverseasInfoArea">
				<table class="ConfirmTable">
					<thead>
						<th>선택</th><th>매출마감월</th><th>거래처</th><th>사업자번호</th><th>납품번호</th><th>항번</th><th>품번</th><th>품명</th><th>납품수량</th>
						<th>수량단위</th><th>판매단가</th><th>거래통화</th><th>거래통화매출금액</th><th>환율유형</th><th>환율</th><th>장부통화매출금액</th>
						<th>장부통화</th>
					</thead>
					<tbody class="ConfirmTable_Body">
					</tbody>
				</table>
			</div>
			
			<div class="BtnArea">
				<div class="BtnArea-Result">
					<label>마감대상 품목 수 : </label>
					<input class="CloseItemCount" readonly>
					<label>마감대상 총수량 : </label>
					<input class="CloseItemTotal" readonly>
				</div>
				<div class="BtnArea-Result">
					<label>마감 품목 수 : </label>
					<input class="FProCount" readonly>
					<label>마감수량 : </label>
					<input class="FProTotal" readonly>
				</div>
				<div class="BtnArea-Result">
					<label>공급가액 합계 : </label>
					<input class="SPriceSum" readonly>
					<label>부가가치세 합계 : </label>
					<input class="VATSum" readonly>
					<label>총 합계 : </label>
					<input class="ToTalSum" readonly>
					
 					<button class="SaveBtn">저장</button>
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>
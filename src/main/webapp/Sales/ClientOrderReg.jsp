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
<script>
<%
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter_YMD = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String InputDate = today.format(formatter_YMD);
%>
	function InfoSearch(field){
		event.preventDefault();
		
		var popupWidth = 1000;
	    var popupHeight = 600;
	    
	    // 현재 활성화된 모니터의 위치를 감지
	    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
	    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
	    console.log(dualScreenLeft);
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
	    var UserComCode = $('.Com-code').val();
	    
	    switch(field){
	    case "TradeCom":
	    	popupWidth = 550;
	    	popupHeight = 610;
	    	window.open("${contextPath}/Sales/Popup/FindTradeCom.jsp?ComCode=" + UserComCode, "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    }
	    
	}
$(document).ready(function(){
	function InitialTable(){
		$('.DocTable_Body').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 7; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.DocTable_Body').append(row);
        }
	}
	
	InitialTable();
	var UserId = $('.UserId').val();
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
	
	$('.DealComCode').change(function(){
		var TradeCompany = $(this).val();
		console.log(TradeCompany);
		let Tablebody = $('.DocTable_Body');
		Tablebody.empty();
		$.ajax({
	        url: '${contextPath}/Sales/ajax/PurchaseOrderItemSearch.jsp',
	        type: 'GET',
	        data: {DealCom : TradeCompany},
	        dataType: 'json', // 데이터 형식에 맞게 조정
	        success: function(data) {
					for (let i = 0; i < 50; i++) {
						const row = $('<tr></tr>');
						
						// 첫 번째 <td>의 품목들 순번
		                const hiddenCell = $('<td></td>').text(i+1);
		                row.append(hiddenCell); // 숨겨진 <td> 추가
		                
		                // 두 번째 <td>에 <select> 추가
		                const select = $('<select></select>');
		                const defaultOption = $('<option></option>')
		                .val('') // 기본 옵션의 value는 빈 문자열
		                .text('선택'); // 기본 옵션의 텍스트
		            	select.append(defaultOption);
		                
		                data.forEach(item => {
		                    const option = $('<option></option>')
		                        .val(`${ "${item.ProductCode}" },${"${item.ProductName}" },${ "${item.ProductUnit}" },${ "${item.DealRate}" }`)
		                        .text(`${ "${item.ProductCode}" }`);
		                    select.append(option);
		                });

		                row.append($('<td></td>').append(select));

		                // 세 번째 <td>에 품목명 추가
		                const productNameCell = $('<td></td>');
		                select.on('change', function() {
		                    const selectedValue = $(this).val().split(',');
		                    
		                    // <input> 요소 생성
		                    const inputElement = $('<input>', {
		                        type: 'text',
		                        value: selectedValue[1],  // selectedValue[1]을 value로 설정
		                        readonly: true,            // readonly 속성 추가
		                        class: 'readonly-input'    // 선택적으로 class 추가 가능
		                    });

		                    // 생성된 <input>을 <td> 안에 추가
		                    productNameCell.empty().append(inputElement);  // 기존 내용은 지우고 input 추가
		                });
		                row.append(productNameCell);

		                // 네 번째 <td>에 단위 추가
		                const productUnitCell = $('<td></td>');
		                select.on('change', function() {
		                	const selectedValue = $(this).val() ? $(this).val().split(',') : [];
		                    if (selectedValue.length === 0) { // 배열이 비어 있는지 확인
		                    	productUnitCell.text(""); // 단위
		                    }else{
		                    	productUnitCell.text(selectedValue[2]); // 단위
		                    }
		                });
		                row.append(productUnitCell);
		                

		                // 다섯 번째부터 열여섯 번째까지 <td>에 <input> 추가
		                for (let j = 0; j < 3; j++) {
			                    const input = $('<input type="text" />');
			                    if (j === 1) {
			                        input.attr('type', 'date'); // j가 1일 때만 타입을 date로 변경
			                    }
			                    row.append($('<td></td>').append(input));
		                // <tbody>에 추가
		                }
		                Tablebody.append(row);
		            }
			
				        // 'SalesPlanTable_Body' 내의 각 <tr>에 대해
			         	$('.SalesPlanTable_Body').find('tr').each(function() {
			         	    // <td> 요소들 중 4번째 인덱스 이상의 <td>를 찾고, <input>에 대한 이벤트 리스너 추가
			         	    $(this).find('td:gt(3)').find('input').on('keydown', function(event) {
			         	        // Enter(키 코드 13) 키가 눌렸는지 확인
			         	        if (event.key === 'Enter') {
			         	            event.preventDefault(); // 기본 동작 방지 (폼 제출 방지)
	
			         	            // 사용자가 입력한 값
			         	            var userInput = parseInt($(this).val()) || 0; // 입력값이 없으면 0으로 처리
			         	            
			         	            // 계산된 값
			         	            var calculatedValue = userInput;
	
			         	            // 계산된 값을 3자리 구분 기호를 포함하여 표시
			         	            $(this).val(calculatedValue.toLocaleString('en-US'));
			         	        }
			         	    });
			         	});  
	       },
		   error: function(xhr, status, error) {
				console.error('AJAX Error: ', status, error);
			}
	    });
	});
});

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
<div class="OrderLogArea">
	<div class="OrderMainArea">
		<div class="Order_InputArea">
			<div class="Order_UserInfo01"> 
				<label id="Company">회사: </label>
				<input type="text" class="Com-code" value=<%=UserComCode %> readonly>
				<label id="User">입력자: </label>
				<input type="text" class="UserId" value=<%=UserId %> readonly>
			</div>
			<div class="Order_UserInfo02">
				<label id="BizArea">회계단위 : </label>
				<input type="text" class="BizCode" readonly>
				<input type="text" class="BizCodeDes" readonly>
				<label id="InputDate">입력일자 : </label>
				<input type="text" class="InputDate" value=<%=InputDate %> readonly>
			</div>
			<div class="Order_ClientInfo">
				<label id="BizArea">거래처 : </label>
				<input type="text" class="DealComCode" onclick="InfoSearch('TradeCom')" readonly>
				<input type="text" class="DealComCodeDes" readonly>
				<label id="CountUnit">수량단위 : </label>
				<select class="UnitList">
					<option value="1">1</option>
					<option value="1000">1,000</option>
					<option value="1000000">1,000,000</option>
					<option value="10000000">10,000,000</option>
				</select>
			</div>
			<div class="Order_DocInfo">
				<label id="OrderType">주문유형: </label>
				<select class="OrderList">
					<option value="A">A 구매주문서</option>
					<option value="B">B Forecasting</option>
				</select>
				<label id="ClientOrderNum">고객주문번호: </label>
				<input type="text" class="OrderNumber" required>
				<label id="ClientOrderDate">고객주문일자: </label>
				<input type="Date" class="OrderDate">
			</div>
		</div>
	</div>
	<div class="ButtonArea">
		<button class="SaveBtn">저장</button>
	</div>
	<div class="OrderSubArea">
		<table class="DocTable">
			<thead class="DocTable_Head">
				<tr>
					<th>항번</th><th>품번</th><th>품명</th><th>수량단위</th><th>주문수량</th><th>남품회망일자</th><th>납품장소</th>
				</tr>
			</thead>
			<tbody class="DocTable_Body">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
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
})

</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<link rel="stylesheet" href="../css/ForSales.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="OrderLogArea">
	<div class="OrderMainArea">
		<div class="Order_InputArea">
			<div class="Order_UserInfo01"> 
				<label id="Company">회사: </label>
				<input type="text" class="Com-code" readonly>
				<label id="User">입력자: </label>
				<input type="text" class="USerId" readonly>
			</div>
			<div class="Order_UserInfo02">
				<label id="BizArea">회계단위 : </label>
				<input type="text" class="BizCode" readonly>
				<input type="text" class="BizCodeDes" readonly>
				<label id="InputDate">입력일자 : </label>
				<input type="text" class="InputDate" readonly>
			</div>
			<div class="Order_ClientInfo">
				<label id="BizArea">거래처 : </label>
				<input type="text" class="DealComCode" readonly>
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
				<input type="text" class="OrderNumber" readonly>
				<label id="ClientOrderDate">고객주문일자: </label>
				<input type="Date" class="OrderDate">
			</div>
		</div>
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
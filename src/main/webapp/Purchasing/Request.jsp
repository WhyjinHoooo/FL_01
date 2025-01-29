<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<meta charset="UTF-8">
<title>구매 요청서</title>
<script>
$(document).ready(function(){
	function InitialTable(){
		$('.InfoTable-Body').empty();
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 13; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.InfoTable-Body').append(row);
        }
	}
	InitialTable();
})
</script>
</head>
<body>
<link rel="stylesheet" href="../css/ReqCss.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<div class="Req-Centralize">
		<div class="Req-Header">
				<div class="Req-Title">구매요청 Header</div>
				<div class="InfoInput">
					<label>Company : </label> 
					<input type="text" class="ComCode" readonly>
				</div>
				
				<div class="InfoInput">
					<label>Plant :  </label>
					<input type="text" class="PlantCode" readonly>
				</div>
				
				<div class="InfoInput">
					<label>Material :  </label>
					<input type="text" class="MatCode" placeholder="SELECT" readonly>
				</div>
				
				<div class="InfoInput">
					<label>등록일자(From) :  </label>
					<input type="date" class="FromDate">
				</div>
				
				<div class="InfoInput">
					<label>등록일자(To) :  </label>
					<input type="date" class="EndDate">
				</div>
				
				<div class="InfoInput">
					<label>구매 요청자 :  </label>
					<input type="text" class="Client" readonly>
				</div>
				
				<div class="InfoInput">
					<label>ORD TYPE :  </label>
					<input type="text" class="DocCode" readonly>
				</div>
				
				<div class="InfoInput">
					<label>구매요청일자 :  </label>
					<input type="text" class="BuyDate" readonly>
				</div>
				
				<button class="SearBtn">실행</button>	
		</div>
		<div class="Req-Body">
			<div class="Info-Area">
				<div class="Req-Title">구매 요청 현황</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>선택</th><th>구매요청번호</th><th>Material</th><th>Material Description</th><th>재고유형</th><th>요청수량</th>
							<th>단위</th><th>납품요청일자</th><th>납품장소</th><th>구매요청사항</th><th>상태</th><th>발주번호</th><th>요청자</th>
						</tr>
					</thead>
					<tbody class="InfoTable-Body">
					</tbody>
				
				</table>
			</div>
			<div class="Btn-Area">
				<button class="NewEntryBtn">신규등록</button>
				<button class="SaveBtn">저장</button>
				<button class="EditBtn">수정</button>
			</div>
			<div class="Req-Area">
				<div class="Req-Title">구매 요청 신청/등록</div>
				<div class="MatInput">
					<label>구매요청번호 :  </label>
					<input type="text" class="###" readonly>
				</div>
				<div class="MatInput">
					<label>Material :  </label>
					<input type="text" class="###" placeholder="SELECT" readonly>
					<label>Description :  </label>
					<input type="text" class="###" readonly>
				</div>
				<div class="MatInput">
					<label>구매 요청 수량 :  </label>
					<input type="text" class="###" placeholder="INPUT" readonly>
					<label>재고관리 단위 :  </label>
					<input type="text" class="###" readonly>
				</div>
				<div class="MatInput">
					<label>납품요청일자 :  </label>
					<input type="text" class="###" readonly>
					<label>구매담당자 :  </label>
					<input type="text" class="###" readonly>
				</div>
				<div class="MatInput">
					<label>납품 장소 :  </label>
					<input type="text" class="###" placeholder="SELECT" readonly>
					<label>납품 장소명 :  </label>
					<input type="text" class="###" readonly>
				</div>
				<div class="MatInput">
					<label>구매 요청 내용 :  </label>
					<input type="text" class="###" placeholder="INPUT" readonly>
				</div>
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
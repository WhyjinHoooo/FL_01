<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<meta charset="UTF-8">
<title>구매단가 생성</title>
<script>
$(document).ready(function(){
	function InitialTable(){
		$('.InfoTable-Body').empty();
		for (let i = 0; i < 20; i++) {
			const row = $('<tr></tr>');
			for (let j = 0; j < 16; j++) {
				row.append('<td></td>');
			}
		$('.InfoTable-Body').append(row);
		}
	}
	InitialTable();
})
</script>
</head>
<body>
<%
String UserId = (String)session.getAttribute("id");
String userComCode = (String)session.getAttribute("depart");
String UserIdNumber = (String)session.getAttribute("UserIdNumber");
%>
<link rel="stylesheet" href="../css/ReqCss.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<div class="Pur-Centralize">
		<div class="PriCreate-Header">
			<div class="Pur-Title">구매단가 등록</div>
			<div class="InfoInput">
				<label>Company : </label> 
				<input type="text" class="Fixed" name="" value="<%=userComCode %>" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Plant :  </label>
				<input type="text" class="" name="" onclick="InfoSearch('Plant')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Material Type:  </label>
				<input type="text" class="" name="" onclick="InfoSearch('Mateiral')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Vendor :  </label>
				<input type="text" class="" name="" onclick="InfoSearch('Vendor')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>등록일자 :  </label>
				<input type="text" class="Fixed" name="" readonly>
			</div>
			
			<div class="InfoInput">
				<label>등록담당자 :  </label>
				<input type="text" class="Fixed" name="" readonly>
			</div>
			<div class="InfoInput">
				<label>등록부서 :  </label>
				<input type="text" class="Fixed" name="" value="<%=UserIdNumber %>" onclick="InfoSearch('Client')" readonly>
			</div>
			<button class="SearBtn">검색</button>	
		</div>
		<div class="PriCreate-Body">
			<div class="Info-Area">
				<div class="Pur-Title">구매단가 등록 현황</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>Material</th><th>Material Description</th><th>공급업체</th><th>공급업체명</th><th>단위</th>
							<th>구매금액</th><th>단위당단가</th><th>거래통화</th><th>유효시작일자</th><th>유효만료일자</th><th>승인일자</th><th>최종결제자</th>
							<th>등록일자</th><th>둥록자</th><th>공장</th><th>회사</th>
						</tr>
					</thead>
					<tbody class="InfoTable-Body">
					</tbody>
				</table>
			</div>
			<div class="Btn-Area">
				<button class="SaveBtn">저장</button>
			</div>
			<div class="Category">단가등록</div>
			<div class="PriCreate-Area">
				<div class="InfoInput">
					<label>Material :  </label>
					<input type="text" class="" id="" name="" readonly>
					<label>Description :  </label>
					<input type="text" class="Fixed" id="" name="" readonly>
				</div>
				<div class="InfoInput">
					<label>가격 기준 수량 :  </label>
					<input type="text" class="" id="" name="" readonly>
					<label>재고관리 단위 :  </label>
					<input type="text" class="Fixed" id="" name= readonly>
				</div>
				<div class="InfoInput">
					<label>구매 금액 :  </label>
					<input type="text" class="" id="" name="" readonly>
					<label>거래 통화 :  </label>
					<input type="text" class="" id="" name= readonly>
				</div>
				<div class="InfoInput">
					<label>포장 단위 :  </label>
					<input type="text" class="Fixed" id="" name="" readonly>
					<label>단위당 단가 :  </label>
					<input type="text" class="Fixed" id="" name= readonly>
				</div>
				<div class="InfoInput">
					<label>적용 시작일자 :  </label>
					<input type="text" class="" id="" name="" readonly>
					<label>적용만료일자 :  </label>
					<input type="text" class="" id="" name= readonly>
				</div>
				<div class="InfoInput">
					<label>사용 여부 :  </label>
					<span>사용</span>
					<input type="radio" class="" id="" name="" checked>
					<span>미사용</span>
					<input type="radio" class="" id="" name="">
					<label>거래조건 :  </label>
					<input type="text" class="" id="" name="">
				</div>
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
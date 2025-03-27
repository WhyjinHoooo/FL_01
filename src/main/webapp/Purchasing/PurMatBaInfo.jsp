<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<meta charset="UTF-8">
<title>구매 Material 기초정보</title>
<script>
function PopupPosition(popupWidth, popupHeight) {
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
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
    
    return { x: xPos, y: yPos };
}
function InfoSearch(field){
	event.preventDefault();
	var popupWidth = 500;
    var popupHeight = 600;
    
    var position = PopupPosition(popupWidth, popupHeight);
    
    switch(field){
    case "Plant":
    	window.open("${contextPath}/Purchasing/PopUp/FindPlant.jsp", "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "Mateiral":
    	popupWidth = 700;
    	popupHeight = 605;
    	position = PopupPosition(popupWidth, popupHeight);
    	window.open("${contextPath}/Purchasing/PopUp/FindMatType.jsp", "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "Vendor":
    	window.open("${contextPath}/Purchasing/PopUp/FindVendor.jsp?From=General", "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "New_Mateiral":
    	popupWidth = 670;
    	popupHeight = 350;
    	position = PopupPosition(popupWidth, popupHeight);
    	window.open("${contextPath}/Purchasing/PopUp/FindNewMat.jsp", "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "Money":
    	popupWidth = 505;
    	popupHeight = 680;
    	position = PopupPosition(popupWidth, popupHeight);
    	window.open("${contextPath}/Purchasing/PopUp/FindMoney.jsp", "POPUP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "New_Vendor":
    	window.open("${contextPath}/Purchasing/PopUp/FindVendor.jsp?From=NewMat", "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
	}
}
function checkOnlyOne(element) {
    const checkboxes =  $('.' + element.className);
    checkboxes.each(function () {
        this.checked = false;
    });
    element.checked = true;
}
$(document).ready(function(){

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
		<div class="Price-Header">
			<div class="Pur-Title">검색 항목</div>
			<div class="InfoInput">
				<label>Company : </label> 
				<input type="text" class="ComCode" name="ComCode" value="<%=userComCode %>" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Plant :  </label>
				<input type="text" class="PlantCode" name="PlantCode" onclick="InfoSearch('Plant')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Material Type:  </label>
				<input type="text" class="MatTypeCode" name="MatTypeCode" onclick="InfoSearch('Mateiral')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Vendor :  </label>
				<input type="text" class="VendorCode" name="VendorCode" onclick="InfoSearch('Vendor')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>등록일자 :  </label>
				<input type="text" class="RegistedDate" name="RegistedDate" readonly>
			</div>
			
			<div class="InfoInput">
				<label>등록담당자 :  </label>
				<input type="text" class="RegistedId" name="RegistedId" value="<%=UserIdNumber %>" onclick="InfoSearch('Manager')" readonly>
			</div>
			<div class="InfoInput">
				<label>등록부서 :  </label>
				<input type="text" class="RegistedCoct" name="RegistedCoct"  readonly>
			</div>
			<button class="SearBtn">검색</button>	
		</div>
		<div class="Price-Body">
			<div class="Info-Area">
				<div class="Pur-Title">재고 위험 관리 자료 등록 현황</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>선택</th><th>자재코드</th><th>자재코드명</th><th>공급업체</th><th>공급업체명</th><th>수입검사여부</th><th>구매담당자</th><th>포장단위</th>
							<th>포장단위수량</th><th>수량단위</th><th>거래처라벨</th><th>거래조건</th><th>지급조건</th><th>조달기간</th><th>기간단위</th>
							<th>공장</th><th>회사</th><th>등록일자</th><th>등록자</th>
						</tr>
					</thead>
					<tbody class="InfoTable-Body">
					</tbody>
				</table>
			</div>
			<div class="Btn-Area">
				<button class="SaveBtn">저장</button>
			</div>
			<div class="PriCreate-Area">
				<div class="Pur-Title">자재 구매 기초 정보 등록/수정</div>
				<div class="InfoInput">
					<label>자재코드 :  </label>
					<input type="text" class="" name="" readonly>
					<label>자재코드명 :  </label>
					<input type="text" class="" name="" readonly>
				</div>
				<div class="InfoInput">
					<label>공급업체 :  </label>
					<input type="text" class="" name="" readonly>
					<label>공급업체명 :  </label>
					<input type="text" class="" name="" readonly>
				</div>
				<div class="InfoInput">
					<label>수입검사 여부 :  </label>
					<span>검사</span>
					<input type="radio" class="CheckYN" name="CheckYN" value="Y" onclick="checkOnlyOne(this)" checked>
					<span>무검사</span>
					<input type="radio" class="CheckYN" name="CheckYN" value="N" onclick="checkOnlyOne(this)">
					<label>구매담당자 :  </label>
					<select class=""  name="">
					</select>
				</div>
				<div class="InfoInput">
					<label>포장단위 수량 :  </label>
					<input type="text" class="" name="">
					<label>포장 단위 :  </label>
					<input type="text" class="" name="" readonly>
				</div>
				<div class="InfoInput">
					<label>Vendor 바코드 :  </label>
					<span>사용</span>
					<input type="radio" class="UseYN" name="UseYN" value="Y" onclick="checkOnlyOne(this)" checked>
					<span>미사용</span>
					<input type="radio" class="UseYN" name="UseYN" value="N" onclick="checkOnlyOne(this)">
					<label>수량 단위 :  </label>
					<input type="text" class="" name="" readonly>
				</div>
				<div class="InfoInput">
					<label>거래 조건 :  </label>
					<input type="number" class="" name="">
					<label>대금 지급 조건 :  </label>
					<input type="text" class="" name="" readonly>
				</div>
				<div class="InfoInput">
					<label>조달 기간 :  </label>
					<input type="text" class="" name="" readonly>
					<label>기간 단위 :  </label>
					<input type="text" class="" name="" readonly>
				</div>
				<div class="InfoInput">
					<label>Vendor  PartNum :  </label>
					<input type="date" class="" name="">
				</div>
				
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
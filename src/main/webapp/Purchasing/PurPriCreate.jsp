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
    	window.open("${contextPath}/Purchasing/PopUp/FIndNewMat.jsp", "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "Money":
    	popupWidth = 505;
    	popupHeight = 680;
    	position = PopupPosition(popupWidth, popupHeight);
    	window.open("${contextPath}/Purchasing/PopUp/FindMoney.jsp", "POPUP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
	}
}
function checkOnlyOne(element) {
    const checkboxes = $('.UseYN');
    checkboxes.each(function () {
        this.checked = false;
    });
    element.checked = true;
}
$(document).ready(function(){
	var Manager = $('.RegistedId').val();
	function InitialTable(id){
		var id = id;
		$('.InfoTable-Body').empty();
		for (let i = 0; i < 20; i++) {
			const row = $('<tr></tr>');
			for (let j = 0; j < 16; j++) {
				row.append('<td></td>');
			}
		$('.InfoTable-Body').append(row);
		}
		$.ajax({
			url:'${contextPath}/Purchasing/AjaxSet/Purchasing/ForPlant.jsp',
			type:'POST',
			data:{id : Manager},
			dataType: 'text',
			success: function(data){
				var dataList = data.trim().split(',');
				$('.PlantCode').val(dataList[0]+'('+dataList[1]+')');
				$('.RegistedCoct').val(dataList[2]+'('+dataList[3]+')');
			}
		})
	}
	function DateSetting(){
		var CurrentDate = new Date();
		var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-' + ('0' + CurrentDate.getDate()).slice(-2);
		$('.RegistedDate').val(today);
	}
	InitialTable(Manager);
	DateSetting();
	$('.NewMaterialFDate').change(function(){
		var StdDate = $(this).val();
		$('.NewMaterialEDate').attr('min', StdDate);
	});
	$('.NewMaterialPrice').on('input',function(){
		var Price = $(this).val();
		var UnitCount = $('.PricePerCount').val();
		var UnitPrice = (Price/UnitCount).toFixed(2);
		$('.NewMaterialUnitPrice').val(UnitPrice);
	})
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
				<input type="text" class="RegistedDate Fixed" name="RegistedDate" readonly>
			</div>
			
			<div class="InfoInput">
				<label>등록담당자 :  </label>
				<input type="text" class="RegistedId Fixed" name="RegistedId" value="<%=UserIdNumber %>" onclick="InfoSearch('Manager')" readonly>
			</div>
			<div class="InfoInput">
				<label>등록부서 :  </label>
				<input type="text" class="RegistedCoct Fixed" name="RegistedCoct"  readonly>
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
					<input type="text" class="NewMaterialCode" name="NewMaterialCode" onclick="InfoSearch('New_Mateiral')" placeholder="SELECT" readonly>
					<label>Description :  </label>
					<input type="text" class="NewMaterialCodeDes Fixed" name="NewMaterialCodeDes" readonly>
				</div>
				<div class="InfoInput">
					<label>가격 기준 수량 :  </label>
					<input type="number" class="PricePerCount" name="PricePerCount">
					<label>재고관리 단위 :  </label>
					<input type="text" class="NewMaterialInvUnit Fixed" name="NewMaterialInvUnit" readonly>
				</div>
				<div class="InfoInput">
					<label>구매 금액 :  </label>
					<input type="number" class="NewMaterialPrice" name="NewMaterialPrice">
					<label>거래 통화 :  </label>
					<input type="text" class="Currency" name="Currency" onclick="InfoSearch('Money')" placeholder="SELECT" readonly>
				</div>
				<div class="InfoInput">
					<label>포장 단위 :  </label>
					<input type="text" class="NewMaterialWrapUnit Fixed" name="NewMaterialWrapUnit" readonly>
					<label>단위당 단가 :  </label>
					<input type="text" class="NewMaterialUnitPrice Fixed" name="NewMaterialUnitPrice" readonly>
				</div>
				<div class="InfoInput">
					<label>적용 시작일자 :  </label>
					<input type="date" class="NewMaterialFDate" name="NewMaterialFDate">
					<label>적용만료일자 :  </label>
					<input type="date" class="NewMaterialEDate" name="NewMaterialEDate">
				</div>
				<div class="InfoInput">
					<label>사용 여부 :  </label>
					<span>사용</span>
					<input type="radio" class="UseYN" name="UseYN" value="Yes" onclick="checkOnlyOne(this)" checked>
					<span>미사용</span>
					<input type="radio" class="UseYN" name="UseYN" value="No" onclick="checkOnlyOne(this)">
					<label>거래조건 :  </label>
					<input type="text" class="DealCondition"  name="DealCondition" placeholder="SELECT" readonly>
				</div>
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
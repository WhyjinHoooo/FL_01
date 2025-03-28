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
function DateSetting(Manager){
	var CurrentDate = new Date();
	var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-' + ('0' + CurrentDate.getDate()).slice(-2);
	$('.RegistedDate').val(today);
	
	$.ajax({
		url:'${contextPath}/Purchasing/AjaxSet/Purchasing/ForPlant.jsp',
		type:'POST',
		data:{id : Manager},
		dataType: 'text',
		success: function(data){
			var dataList = data.trim().split(',');
			$('.PlantCode').val(dataList[0]+'('+dataList[1]+')');
			console.log(dataList[0]+'('+dataList[1]+')');
			$('.RegistedCoct').val(dataList[2]+'('+dataList[3]+')');
		}
	})
}
function InitialTable(){
	$('.InfoTable-Body').empty();
	for (let i = 0; i < 20; i++) {
		const row = $('<tr></tr>');
		for (let j = 0; j < 19; j++) {
			row.append('<td></td>');
		}
	$('.InfoTable-Body').append(row);
	}
}
$(document).ready(function(){
	var USerId = $('.RegistedId').val();
	DateSetting(USerId);
	InitialTable();
	var SearchList = {};
	$('.SearBtn').click(function(){
		$('.SearOp').each(function(){
            var name = $(this).attr("name");
            var value = $(this).val().trim();
            SearchList[name] = value;
        });
		var pass = true;
		$.each(SearchList,function(key, value){
			if(key === 'MatTypeCode' || key === 'VendorCode'){
				return true;
			}else{
				if(value == null || value === ''){
					pass = false;
					return false;
				}
			}
		})
		if(!pass){
			alert('모든 항목을 입력해주세요.');
		}else{
			$.ajax({
				url : '${contextPath}/Purchasing/AjaxSet/Purchasing/LoadMat.jsp',
				type : 'POST',
				data :  JSON.stringify(SearchList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success : function(data){
					if(data.length > 0){
						$('.InfoTable-Body').empty();
						for(var i = 0 ; i < data.length ; i++){
							var row = '<tr>' +
							'<td><button>클릭</button</td>' + 
							'<td>' + data[i].MatNum + '</td>' + 
							'<td>' + data[i].MatDesc + '</td>' + 
							'<td>' + data[i].Vendor + '</td>' + 
							'<td>' + data[i].VendorDesc + '</td>' + 
							'<td>' + data[i].IQCYN + '</td>' + 
							'<td>' + data[i].PurchPerson + '</td>' + 
							'<td>' + data[i].PackingUInit + '</td>' + 
							'<td>' + data[i].QtyPerPacking + '</td>' + 
							'<td>' + data[i].Qtyunit + '</td>' + 
							'<td>' + data[i].VenBarCode + '</td>' + 
							'<td>' + data[i].IncoTerms + '</td>' +
							'<td>' + data[i].PayTerms + '</td>' +
							'<td>' + data[i].Ltinbound + '</td>' +
							'<td>' + data[i].PeriUnit + '</td>' +
							'<td>' + data[i].Plant + '</td>' +
							'<td>' + data[i].ComCode + '</td>' +
							'<td>' + data[i].RegistDate + '</td>' +
							'<td>' + data[i].Registperson + '</td>' +
							'</tr>';
							$('.InfoTable-Body').append(row);
						}
					}else{
						alert('해당 조건의 데이터가 존재하지 않습니다.');
					}
				},
				error: function(jqXHR, textStatus, errorThrown){
					alert('오류 발생: ' + textStatus + ', ' + errorThrown);
		    	}
	    	})
		}
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
		<div class="Price-Header">
			<div class="Pur-Title">검색 항목</div>
			<div class="InfoInput">
				<label>Company : </label> 
				<input type="text" class="ComCode SearOp" name="ComCode" value="<%=userComCode %>" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Plant :  </label>
				<input type="text" class="PlantCode SearOp" name="PlantCode" onclick="InfoSearch('Plant')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Material Type:  </label>
				<input type="text" class="MatTypeCode SearOp" name="MatTypeCode" onclick="InfoSearch('Mateiral')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Vendor :  </label>
				<input type="text" class="VendorCode SearOp" name="VendorCode" onclick="InfoSearch('Vendor')" placeholder="SELECT" readonly>
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
					<input type="text" class="FixedMatCode" name="FixedMatCode" readonly>
					<label>자재코드명 :  </label>
					<input type="text" class="FixedMatCodeDes" name=""FixedMatCodeDes"" readonly>
				</div>
				<div class="InfoInput">
					<label>공급업체 :  </label>
					<input type="text" class="FixedVendor" name="FixedVendor" readonly>
					<label>공급업체명 :  </label>
					<input type="text" class="FixedVendorDes" name="FixedVendorDes" readonly>
				</div>
				<div class="InfoInput">
					<label>수입검사 여부 :  </label>
					<span>검사</span>
					<input type="radio" class="CheckYN" name="CheckYN" value="Y" onclick="checkOnlyOne(this)" checked>
					<span>무검사</span>
					<input type="radio" class="CheckYN" name="CheckYN" value="N" onclick="checkOnlyOne(this)">
					<label>구매담당자 :  </label>
					<select class="EditBuyer"  name="EditBuyer">
					</select>
				</div>
				<div class="InfoInput">
					<label>포장단위 수량 :  </label>
					<input type="number" class="EditPackQuantity" name="EditPackQuantity">
					<label>포장 단위 :  </label>
					<input type="text" class="EditPackUnit" name="EditPackUnit" readonly>
				</div>
				<div class="InfoInput">
					<label>Vendor 바코드 :  </label>
					<span>사용</span>
					<input type="radio" class="UseYN" name="UseYN" value="Y" onclick="checkOnlyOne(this)" checked>
					<span>미사용</span>
					<input type="radio" class="UseYN" name="UseYN" value="N" onclick="checkOnlyOne(this)">
					<label>수량 단위 :  </label>
					<input type="text" class="EditQuantityUnit" name="EditQuantityUnit" readonly>
				</div>
				<div class="InfoInput">
					<label>거래 조건 :  </label>
					<input type="text" class="EditDealCondi" name="EditDealCondi" readonly>
					<label>대금 지급 조건 :  </label>
					<input type="text" class="EditPriTerm" name="EditPriTerm" readonly>
				</div>
				<div class="InfoInput">
					<label>조달 기간 :  </label>
					<input type="text" class="EditPeriod" name="EditPeriod" readonly>
					<label>기간 단위 :  </label>
					<input type="text" class="EditPeriodUnit" name="EditPeriodUnit" readonly>
				</div>
				<div class="InfoInput">
					<label>Vendor  PartNum :  </label>
					<input type="text" class="VenPartNum" name="VenPartNum">
				</div>
				
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
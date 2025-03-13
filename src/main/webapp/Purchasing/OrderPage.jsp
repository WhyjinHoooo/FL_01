<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<meta charset="UTF-8">
<title>자재발주</title>
<script>
function InfoSearch(field){
	event.preventDefault();
	var MatCode = $('.Entry_MatCode').val();
	var popupWidth = 500;
    var popupHeight = 600;
    
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
    
    switch(field){
    case "Plant":
    	window.open("${contextPath}/Purchasing/PopUp/FindPlant.jsp", "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    break;
    case "Material":
    	popupWidth = 1000;
        popupHeight = 600;
    	window.open("${contextPath}/Purchasing/PopUp/FindMat.jsp?Category=Search", "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    break;
    case "Vendor":
    	window.open("${contextPath}/Purchasing/PopUp/FindVendor.jsp", "POPUP08", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;
    case "Company":
    	window.open("${contextPath}/Purchasing/PopUp/FindCom.jsp", "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "EntryClient":
    	window.open("${contextPath}/Purchasing/PopUp/FindClient.jsp?Category=Entry", "POPUP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;	
    case "EntryDeli":
    	window.open("${contextPath}/Purchasing/PopUp/FindMatPlace.jsp?MatCode=" + MatCode, "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;
    case "EntrySLocation":
    	window.open("${contextPath}/Purchasing/PopUp/FindSLoc.jsp", "POPUP07", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
	}
}
function checkOnlyOne(element) {
    const checkboxes = $('.UnitSum');
    checkboxes.each(function () {
        this.checked = false;
    });
    element.checked = true;
}

$(document).ready(function(){
	function EntryDisabled(){
		$('.Ord-Area').find('input').prop('disabled', true);
	}
	function EntryAbled(){
		$('.Ord-Area').find('input').not('.Entry_Reject').prop('disabled', false);
	}
	function InitialTable(UserId){
		$('.InfoTable-Body').empty();
		var UserId = UserId;
		console.log(UserId);
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>');
            for (let j = 0; j < 13; j++) {
                row.append('<td></td>');
            }
            $('.InfoTable-Body').append(row);
        }
		$.ajax({
			url:'${contextPath}/Purchasing/AjaxSet/ForPlant.jsp',
			type:'POST',
			data:{id : UserId},
			dataType: 'text',
			success: function(data){
				console.log(data.trim());
				var dataList = data.trim().split('-');
				console.log(dataList);
				$('.PlantCode').val(dataList[0]+'('+dataList[1]+')');
			}
		})
	}
	function DateSetting(){
		var CurrentDate = new Date();
		var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-' + ('0' + CurrentDate.getDate()).slice(-2);
		$('.OrderDate').val(today);
	}
	function CreateEntryDocument(){
		var DocTopic = $('.DocCode').val();
		var DocDate = $('.BuyDate').val();
		$('.Req-Area').find('input').prop('disabled', false);
		$.ajax({
			url:'${contextPath}/Purchasing/AjaxSet/ForEntryDoc.jsp',
			type:'POST',
			data:{Code : DocTopic, Date : DocDate},
			dataType: 'text',
			success: function(data){
				$('.Entry_DocNum').val(data.trim());
			}
		})
	}
	var Userid = $('.PurManager').val();
	InitialTable(Userid);
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
	<div class="MatOrd-Centralize">
		<div class="MatOrd-Header">
			<div class="MatOrd-Title">SEARCH FIELD</div>
			<div class="InfoInput">
				<label>Company : </label> 
				<input type="text" class="ComCode" name="ComCode" value="<%=userComCode %>" onclick="InfoSearch('Company')" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Plant :  </label>
				<input type="text" class="PlantCode" name="PlantCode" onclick="InfoSearch('Plant')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Vendor :  </label>
				<input type="text" class="Entry_VCode" name="Entry_VCode" onclick="InfoSearch('Vendor')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>구매그룹 :  </label>
				<select class="PurState" name="State">
					<option value="SELECT">SELECT</option>
					<option value="A 구매요청">A 구매요청</option>
					<option value="B 발주준비">B 발주준비</option>
					<option value="C 발주완료">C 방주완료</option>
					<option value="D 반려">D 반려</option>
				</select>
			</div>
			<div class="InfoInput">
				<label>ORD TYPE :  </label>
				<input type="text" class="DocCode" value="PXRO" readonly>
			</div>
			
			<div class="InfoInput">
				<label>동일품목 합산 :  </label>
				<span>합산</span><input type="checkbox" class="UnitSum" name="UnitSum" value="Sum" onclick="checkOnlyOne(this)" readonly checked>
				<span>건별</span><input type="checkbox" class="UnitSum" name="UnitSum" value="Solo" onclick="checkOnlyOne(this)" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Material :  </label>
				<input type="text" class="MatCode" name="MatCode" onclick="InfoSearch('Mateiral')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>남풉요청일자(FR) :  </label>
				<input type="date" class="FromDate" name="FromDate">
			</div>
			
			<div class="InfoInput">
				<label>남풉요청일자(TO) :  </label>
				<input type="date" class="ToDate" name="ToDate">
			</div>
			<div class="InfoInput">
				<label>구매담당자 :  </label>
				<input type="text" class="PurManager" name="PurManager" value="<%=UserIdNumber %>" onclick="InfoSearch('Client')" readonly>
			</div>
			
			
			
			<button class="SearBtn">검색</button>	
		</div>
		<div class="MatOrd-Body">
			<div class="Info-Area">
				<div class="MatOrd-Title">발주 계획 현황</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>선택</th><th>Material</th><th>Material Description</th><th>재고유형</th><th>발주계획수량</th><th>단위</th>
							<th>공급업체</th><th>공급업체이름</th><th>구매단가</th><th>거래통화</th><th>납품요청일자</th><th>납풍장소</th><th>발주계획번호</th>
						</tr>
					</thead>
					<tbody class="InfoTable-Body">
					</tbody>
				
				</table>
			</div>
			<div class="Btn-Area">
				<button class="ChgBtn">발주전환</button>
				<button class="SaveBtn">저장</button>
				<button class="CancelBtn">일괄 저장</button>
			</div>
			<div class="MatOrd-Area">
				<div class="Req-Title">발주서 발행</div>
				<div class="MatInput">
					<label>발주계획번호 :  </label>
					<input type="text" class="Entry_DocNum EntryItem" id="Entry_DocNum" name="Entry_DocNum" readonly>
					<label>구매요청구분 :  </label>
					<input type="text" class="Entry_Doc_State EntryItem" id="Entry_Doc_State" name="Entry_Type" readonly>
					<input type="text" class="OreReqNumber" id="OreReqNumber" name="OreReqNumber" hidden>
				</div>
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
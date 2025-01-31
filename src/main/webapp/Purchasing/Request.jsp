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
function InfoSearch(field){
	event.preventDefault();
	
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
    case "Client":
    	window.open("${contextPath}/Purchasing/PopUp/FindClient.jsp?Category=Search", "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;
    case "EntryMaterial":
    	popupWidth = 1000;
        popupHeight = 600;
    	window.open("${contextPath}/Purchasing/PopUp/FindMat.jsp?Category=Entry", "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "EntryClient":
    	window.open("${contextPath}/Purchasing/PopUp/FindClient.jsp?Category=Entry", "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;	
	}
}
$(document).ready(function(){
	function EntryDisabled(){
		$('.Req-Area').find('input').prop('disabled', true);
	}
	function InitialTable(UserId){
		$('.InfoTable-Body').empty();
		var UserId = $('.Client').val();
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 13; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
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
		$('.BuyDate').val(today);
		$('.FromDate').val(today);
		
		var Past = new Date(today);
		Past.setMonth(Past.getMonth() - 1);
		var PastDate = Past.getFullYear() + '-' + ('0' + (Past.getMonth() + 1)).slice(-2) + '-' + ('0' + Past.getDate()).slice(-2);
		
		
		$('.FromDate').attr('min', today);
		$('.EndDate').attr('max', today);
		$('.EndDate').val(PastDate);
		$('.Entry_EndDate').attr('min', today);
	}
	var Userid = $('.Client').val();
	InitialTable(Userid);
	EntryDisabled();
	DateSetting();

	
	$('.SearBtn').click(function(){
		var DataArray = [];
		event.preventDefault();
		$('.SearOption').each(function(){
			var value = $(this).val();
			DataArray.push(value);
		})
		console.log(DataArray);
		$.ajax({
			url: '${contextPath}/Purchasing/AjaxSet/ImportFile.jsp',
			type: 'POST',
			data: JSON.stringify(DataArray),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(data){
				console.log(data);
				console.log(data.length);
				if(data.length === 0){
					alert('등록된 데이터가 존재하지 않습니다. \n신규등록을 해주시길 바랍니다.');
				}else{
					
				}
			}
		})
	})
	$('.NewEntryBtn').click(function(){
		var DocTopic = $('.DocCode').val();
		var DocDate = $('.BuyDate').val();
		$('.Req-Area').find('input').prop('disabled', false);
		$.ajax({
			url:'${contextPath}/Purchasing/AjaxSet/ForEntryDoc.jsp',
			type:'POST',
			data:{Code : DocTopic, Date : DocDate},
			dataType: 'text',
			success: function(data){
				console.log(data);
				$('.Entry_DocNum').val(data);
			}
		})
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
	<div class="Req-Centralize">
		<div class="Req-Header">
				<div class="Req-Title">구매요청 Header</div>
				<div class="InfoInput">
					<label>Company : </label> 
					<input type="text" class="ComCode SearOption" name="ComCode" value="<%=userComCode %>" readonly>
				</div>
				
				<div class="InfoInput">
					<label>Plant :  </label>
					<input type="text" class="PlantCode SearOption" onclick="InfoSearch('Plant')" readonly>
				</div>
				
				<div class="InfoInput">
					<label>Material :  </label>
					<input type="text" class="MatCode SearOption" onclick="InfoSearch('Material')" placeholder="SELECT" readonly>
				</div>
				
				<div class="InfoInput">
					<label>등록일자(From) :  </label>
					<input type="date" class="EndDate SearOption">
				</div>
				
				<div class="InfoInput">
					<label>등록일자(To) :  </label>
					<input type="date" class="FromDate SearOption">
				</div>
				
				<div class="InfoInput">
					<label>구매 요청자 :  </label>
					<input type="text" class="Client SearOption" value="<%=UserIdNumber %>" onclick="InfoSearch('Client')" readonly>
				</div>
				
				<div class="InfoInput">
					<label>ORD TYPE :  </label>
					<input type="text" class="DocCode" value="PREO" readonly>
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
					<input type="text" class="Entry_DocNum" readonly>
				</div>
				<div class="MatInput">
					<label>Material :  </label>
					<input type="text" class="Entry_MatCode" placeholder="SELECT" onclick="InfoSearch('EntryMaterial')" readonly>
					<label>Description :  </label>
					<input type="text" class="Entry_MatDes" readonly>
				</div>
				<div class="MatInput">
					<label>구매 요청 수량 :  </label>
					<input type="text" class="Entry_Count" placeholder="INPUT">
					<label>재고관리 단위 :  </label>
					<input type="text" class="Entry_Unit" readonly>
				</div>
				<div class="MatInput">
					<label>납품요청일자 :  </label>
					<input type="date" class="Entry_EndDate">
					<label>구매담당자 :  </label>
					<input type="text" class="Entry_Client" onclick="InfoSearch('EntryClient')" placeholder="SELECT" readonly>
				</div>
				<div class="MatInput">
					<label>납품 장소 :  </label>
					<input type="text" class="Entry_PCode" placeholder="SELECT" readonly>
					<label>납품 장소명 :  </label>
					<input type="text" class="Entry_PCodeDes" readonly>
				</div>
				<div class="MatInput">
					<label>구매 요청 내용 :  </label>
					<input type="text" class="Entry_Ref" placeholder="INPUT">
				</div>
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
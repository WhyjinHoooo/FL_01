<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<meta charset="UTF-8">
<title>발주검토</title>
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
    case "Client":
    	window.open("${contextPath}/Purchasing/PopUp/FindClient.jsp?Category=Search", "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;
    case "Company":
    	window.open("${contextPath}/Purchasing/PopUp/FindCom.jsp?", "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "EntryClient":
    	window.open("${contextPath}/Purchasing/PopUp/FindClient.jsp?Category=Entry", "POPUP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;	
    case "EntryDeli":
    	window.open("${contextPath}/Purchasing/PopUp/FindMatPlace.jsp?MatCode=" + MatCode, "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;
	}
}
$(document).ready(function(){
	function EntryDisabled(){
		$('.Req-Area').find('input').prop('disabled', true);
	}
	function InitialTable(UserId){
		$('.InfoTable-Body').empty();
		var UserId = UserId;
		console.log(UserId);
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 14; j++) {
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
				console.log(data.trim());
				$('.Entry_DocNum').val(data.trim());
			}
		})
	}
	var Userid = $('.PurManager').val();
	InitialTable(Userid);
	EntryDisabled();
	DateSetting();
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
					<input type="text" class="ComCode SearOption" name="ComCode" value="<%=userComCode %>" onclick="InfoSearch('Company')" readonly>
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
					<label>구매요청 상태 :  </label>
					<select class="PurState">
						<option value="SELECT">SELECT</option>
						<option value="A 구매요청">A 구매요청</option>
						<option value="B 발주준비">B 발주준비</option>
						<option value="C 방주완료">C 방주완료</option>
						<option value="D 반려">D 반려</option>
					</select>
				</div>
				
				<div class="InfoInput">
					<label>구매담당자 :  </label>
					<input type="text" class="PurManager" value="<%=UserIdNumber %>" onclick="InfoSearch('Client')" readonly>
				</div>
				
				<div class="InfoInput">
					<label>ORD TYPE :  </label>
					<input type="text" class="DocCode" value="PREO" readonly>
				</div>
				
				<div class="InfoInput">
					<label>발주계획일자 :  </label>
					<input type="text" class="OrderDate" name="OrderDate" readonly>
				</div>
				
				<button class="SearBtn">실행</button>	
		</div>
		<div class="Req-Body">
			<div class="Info-Area">
				<div class="Req-Title">구매 요청 현황</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>선택</th><th>Material</th><th>Material Description</th><th>재고유형</th><th>구매요청수량</th><th>단위</th>
							<th>구매단가</th><th>거래통화</th><th>Vendor</th><th>Vendor명</th><th>납품요청일자</th><th>납품장소</th><th>구매요청상황</th>
							<th>구매요청번호</th>
						</tr>
					</thead>
					<tbody class="InfoTable-Body">
					</tbody>
				
				</table>
			</div>
			<div class="Btn-Area">
				<button class="NewEntryBtn">수정</button>
				<button class="SaveBtn">저장</button>
				<button class="EditBtn">일괄 저장</button>
			</div>
			<div class="Req-Area OrdArea">
				<div class="Req-Title">구매 요청 검토/저장</div>
				<div class="MatInput">
					<label>구매요청번호 :  </label>
					<input type="text" class="Entry_DocNum EntryItem" id="Entry_DocNum" name="Entry_DocNum" readonly>
					<label>구매요청구분 :  </label>
					<input type="text" class="Entry_Doc_State EntryItem" id="Entry_Doc_State" name="Entry_DocNum" readonly>
				</div>
				<div class="MatInput">
					<label>Material :  </label>
					<input type="text" class="Entry_MatCode EntryItem" id="Entry_MatCode" name="Entry_MatCode" placeholder="SELECT"  readonly>
					<label>Description :  </label>
					<input type="text" class="Entry_MatDes EntryItem" id="Entry_MatDes" name="Entry_MatDes" readonly>
				</div>
				<div class="MatInput">
					<label>구매 요청 수량 :  </label>
					<input type="text" class="Entry_Count EntryItem" id="Entry_Count" name="Entry_Count" placeholder="INPUT">
					<label>재고관리 단위 :  </label>
					<input type="text" class="Entry_Unit EntryItem" id="Entry_Unit" name="Entry_Unit" readonly>
				</div>
				<div class="MatInput">
					<label>납품요청일자 :  </label>
					<input type="date" class="Entry_EndDate EntryItem" id="Entry_EndDate" name="Entry_EndDate">
					<label>납품장소 :  </label>
					<input type="text" class="Entry_Place EntryItem" id="Entry_Place" name="Entry_Place" placeholder="SELECT" readonly>
				</div>
				<div class="MatInput">
					<label>Vendor:  </label>
					<input type="text" class="Entry_VCode EntryItem" id="Entry_VCode" name="Entry_VCode" placeholder="SELECT" readonly>
					<label>발주 여부 :  </label>
					<span>발주준비</span><input type="radio" class="Entry_Pos EntryItem" id="Entry_Pos" name="Entry_Pos">
					<span>반려</span><input type="radio" class="Entry_Neg EntryItem" id="Entry_Neg" name="Entry_Neg">
				</div>
				<div class="MatInput">
					<label>구매단가 :  </label>
					<input type="text" class="Entry_UnitPrice EntryItem" id="Entry_UnitPrice" name="Entry_UnitPrice">
					<label>거래통화 :  </label>
					<input type="text" class="Entry_Cur EntryItem" id="Entry_Cur" name="Entry_Cur"  readonly>
				</div>
				<div class="MatInput">
					<label>반려 이유 :  </label>
					<input type="text" class="Entry_Reject EntryItem" id="Entry_Reject" name="Entry_Reject" placeholder="※ 반려할 경우, 이유를 간단히 적어주시기 바랍니다.">
				</div>
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
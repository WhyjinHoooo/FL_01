<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수불관리</title>
<link rel="stylesheet" href="../css/Inven.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
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
    
    var ComCode = $('.ComCode').val();
    var position = PopupPosition(popupWidth, popupHeight);
    
    switch(field){
    case "PlantSearch":
        window.open("${contextPath}/Report/PopUp/PlantSerach.jsp?ComCode=" + ComCode, "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "MatSearch":
    	popupWidth = 910;
    	popupHeight = 600;
        window.open("${contextPath}/Report/PopUp/MatSerach.jsp?ComCode=" + ComCode, "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    }
}
const cssMap = {
	1: '../css/Inv_ComLev.css',
	2: '../css/Inv_PlaLev.css',
	3: '../css/Inv_SlocLev.css',
	4: '../css/Inv_MovLev.css',
	default: '../css/Inven.css?after'
	};
	
function applyCSS(condition) {
	const link = document.createElement('link');
	link.rel = 'stylesheet';
	link.href = cssMap[condition] || cssMap['default'];
	
	const oldLink = document.querySelector('link[data-target="tbody"]');
	if (oldLink) oldLink.remove();
	
	link.setAttribute('data-target', 'tbody');
	document.head.appendChild(link);
}

function TestFunction(value) {
    let Turl;
    if (value === 'Company') {
        Turl = 'SubHall/ComLevelTable.jsp';
    } else if (value === 'Plant') {
        Turl = 'SubHall/PlantLevelTable.jsp';
    } else if (value === 'Slocation') {
        Turl = 'SubHall/SlocLevelTable.jsp';
    }else  if(value === 'Move'){
    	Turl = 'SubHall/MovLevelTable.jsp';
    }
    if(Turl){
    	$('.InfoTable-Header').load(Turl);
    }
}
function InitialTable(count){
	$('.InfoTable-Body').empty();
	for (let i = 0; i < 50; i++) {
		const row = $('<tr></tr>');
		for (let j = 0; j < count; j++) {
			row.append('<td></td>');
		}
	$('.InfoTable-Body').append(row);
	}
}
function DateSetting(){
	var CurrentDate = new Date();
	var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-' + ('0' + CurrentDate.getDate()).slice(-2);
	$('.FromDate').val(today);
}
$(document).ready(function() {
	DateSetting();
	TestFunction('Company');
	InitialTable('15');
	var condition = 1;
	applyCSS(condition);
    var value = 1;
    var count = null;
    $('.CateBtn').click(function() {
    	value = $(this).val();
    	switch(value){
    	case '1':
    		$('.LvP, .LvS, .LvM').prop('hidden',true);
    		count = 15;
    		condition = 1;
    		break;
    	case '2':
    		$('.LvP').prop('hidden',false);
    		$('.LvS, LvM').prop('hidden',true);
    		count = 16;
    		condition = 2;
    		break;
    	case '3':
    		$('.LvP, .LvS').prop('hidden',false);
    		$('.LvM').prop('hidden',true);
    		count = 17;
    		condition = 3;
    		break;
    	case '4':
    		$('.LvP, .LvM').prop('hidden',false);
    		$('.LvS').prop('hidden',true);
    		count = 16;
    		condition = 4;
    		break;
    	}
		InitialTable(count);
		switch(value){
    	case '4':
    		applyCSS(condition);
    		break;
    	case '3':
    		applyCSS(condition);
    		break;
    	case '2':
    		applyCSS(condition);
    		break;
    	case '1':
    		applyCSS(condition);
    		break;
    	}
	});
    $('.SearBtn').click(function(){
    	var FromDate = $('.FromDate').val();
    	var EndDate = $('.EndDate').val();
    	var IntFromDate = new Date(FromDate).getTime();
    	var IntEndDate = new Date(EndDate).getTime();
    	var MatData = $('.MatCode').val();
    	var ComData = $('.ComCode').val();
    	var PlantData = $('.PlantCode').val();
    	var SLoData = $('.SLocCode').val();
    	if (isNaN(IntEndDate)) {
    	    alert('유효하지 않은 날짜 형식입니다.');
    	    return false;
    	}
    	if (IntFromDate > IntEndDate) {
    	    alert('조회기간을 다시 입력하세요.');
    	    return false;
    	}
    	var List = {
    		'FromDate' : FromDate,
    		'EndDate' : EndDate,
    		'MatData' : MatData,
    		'ComData' : ComData
    	}
    	console.log(List);
    	switch(value){
    	case 1:
        	$.ajax({
    			url : '${contextPath}/Report/AjaxSet/C_LoadData.jsp',
    			type : 'POST',
    			data :  JSON.stringify(List),
    			contentType: 'application/json; charset=utf-8',
    			dataType: 'json',
    			async: false,
    			success: function(data){
    			    if(data.length === 0){
    			    	alert('해당하는 자재에 대한 데이터가 존재하지 않습니다.');
    			    	$('.MatCode').val('');
    			    	return false;
    			    }
    			    $('.InfoTable-Body').empty();
    			    for(var i = 0 ; i < data.length ; i++){
    			        var row = '<tr>' +
    			        '<td>' + (i + 1).toString().padStart(2,'0') + '</td>' + 
    			        '<td>' + (data[i].ComCode || '') + '</td>' + 
    			        '<td>' + (data[i].Material || '') + '</td>' + 
    			        '<td>' + (data[i].MaterialDes || '') + '</td>' + 
    			        '<td>' + (data[i].Unit || '') + '</td>' + 
    			        '<td>' + (data[i].Inventory_Qty ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Inventory_Amt ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Purchase_In ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Purchase_Amt ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Material_Out ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Material_Amt ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Transfer_InOut ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Transfer_Amt ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Inventory_Qty ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Inventory_Amt ?? 0) + '</td>' + 
    			        '</tr>';
    			        $('.InfoTable-Body').append(row);
    			    }
    			},
    			error: function(jqXHR, textStatus, errorThrown){
    				alert('오류 발생: ' + textStatus + ', ' + errorThrown);
    	    	}
        	});
    		break;
    	case 2:
    	case 3:
    		List[value] = value; 
    		List[PlantData] = PlantData;
    		List[SLoData] = SLoData;
    		$.ajax({
    			url : '${contextPath}/Report/AjaxSet/PS_LoadData.jsp',
    			type : 'POST',
    			data :  JSON.stringify(List),
    			contentType: 'application/json; charset=utf-8',
    			dataType: 'json',
    			async: false,
    			success: function(data){
    			    $('.InfoTable-Body').empty();
    			    for(var i = 0 ; i < data.length ; i++){
    			        var row = '<tr>' +
    			        '<td>' + (i + 1).toString().padStart(2,'0') + '</td>' + 
    			        '<td>' + (data[i].ComCode || '') + '</td>' + 
    			        '<td>' + (data[i].Material || '') + '</td>' + 
    			        '<td>' + (data[i].MaterialDes || '') + '</td>' + 
    			        '<td>' + (data[i].Unit || '') + '</td>' + 
    			        '<td>' + (data[i].Inventory_Qty ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Inventory_Amt ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Purchase_In ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Purchase_Amt ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Material_Out ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Material_Amt ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Transfer_InOut ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Transfer_Amt ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Inventory_Qty ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Inventory_Amt ?? 0) + '</td>' + 
    			        '</tr>';
    			        $('.InfoTable-Body').append(row);
    			    }
    			},
    			error: function(jqXHR, textStatus, errorThrown){
    				alert('오류 발생: ' + textStatus + ', ' + errorThrown);
    	    	}
        	});
    		break;
//     	case '':
//     		break;
    	}
    	applyCSS(condition)
    })
});
</script>
<%
String UserId = (String)session.getAttribute("id");
String userComCode = (String)session.getAttribute("depart");
String UserIdNumber = (String)session.getAttribute("UserIdNumber");
%>
</head>
<body>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="Hall">
	<div class="MainHall">
		<div class="Title">검색 항목</div>
		<div class="Category">
			<button class="CateBtn" onclick="TestFunction('Company')" value="1">Com.Lv</button> <!-- 1 -->
			<button class="CateBtn" onclick="TestFunction('Plant')" value="2">Pla.Lv</button> <!-- 2 -->
			<button class="CateBtn" onclick="TestFunction('Slocation')" value="3">SLo.lv</button> <!-- 3 -->
			<button class="CateBtn" onclick="TestFunction('Move')" value="4">Mov.Lv</button> <!-- 4 -->
		</div>
		<div class="MainHallArray">
			<div class="Main-Colume">
				<label>❗Company : </label>
				<input type="text" class="ComCode" name="ComCode" value="<%=userComCode%>" readonly>
			</div>
			<div class="Main-Colume">
				<label>❗조회기간(FromDate) : </label>
				<input type="date" class="FromDate" name="FromDate">
			</div>
			<div class="Main-Colume">
				<label>❗조회기간(EndDate) : </label>
				<input type="date" class="EndDate" name="EndDate">
			</div>
			<div class="Main-Colume LvP" hidden>
				<label>❗Plant : </label>
				<input type="text" class="PlantCode" name="PlantCode" onclick="InfoSearch('PlantSearch')" placeholder="SELECT" readonly>
			</div>
			<div class="Main-Colume LvS" hidden>
				<label>❗창고 : </label>
				<input type="text" class="SLocCode" name="SLocCode" onclick="InfoSearch('Null')" placeholder="SELECT" readonly>
			</div>
<!-- 			<div class="Main-Colume">
				<label>❗재고유형 : </label>
				<input type="text" class="MatType" name="MatType" onclick="InfoSearch('Null')" readonly>
			</div> -->
			<div class="Main-Colume LvM" hidden>
				<label>입출고 구분(From) : </label>
				<input type="text" class="MovCode-In" name="MovCode-In" onclick="InfoSearch('Null')" placeholder="SELECT">
			</div>
			<div class="Main-Colume LvM" hidden>
				<label>입출고 구분(To) : </label>
				<input type="text" class="MovCode-Out" name="MovCode-Out" onclick="InfoSearch('Null')" placeholder="SELECT">
			</div>
			<div class="Main-Colume">
				<label>Mateiral : </label>
				<input type="text" class="MatCode" name="MatCode" onclick="InfoSearch('MatSearch')" placeholder="SELECT" readonly>
			</div>
		</div>
		
		<div class="BtnArea">
			<button class="SearBtn">Search</button>
		</div>
	</div>
	
	<div class="SubHall">
		<div class="Title">재고 수불 현황</div>
		<table class="InfoTable">
			<thead class="InfoTable-Header">

 			</thead>
			<tbody class="InfoTable-Body">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
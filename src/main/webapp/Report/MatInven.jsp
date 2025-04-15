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
document.addEventListener('DOMContentLoaded', function() {
    const tbody = document.querySelector('.InfoTable-Body');
    const thead = document.querySelector('.InfoTable-Header');

    tbody.addEventListener('scroll', function() {
        thead.scrollLeft = tbody.scrollLeft; // thead의 스크롤 위치를 직접 설정
    });
});
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
    
    var MoveType = event.target.name;
    
    switch(field){
    case "PlantSearch":
        window.open("${contextPath}/Report/PopUp/PlantSerach.jsp?ComCode=" + ComCode, "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "MatSearch":
    	popupWidth = 910;
    	popupHeight = 600;
        window.open("${contextPath}/Report/PopUp/MatSerach.jsp?ComCode=" + ComCode, "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "SLoSearch":
        window.open("${contextPath}/Report/PopUp/SLoSerach.jsp?ComCode=" + ComCode, "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    	break;
    case "TypeSearch":
    	window.open("${contextPath}/Report/PopUp/TypeSerach.jsp", "PopUp04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    	break;
    case "MovSearch":
    	window.open("${contextPath}/Report/PopUp/MovSerach.jsp?Move=" + MoveType, "PopUp05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    	break;
    }
}
const cssMap = {
	1: '../css/Inv_ComLev.css?after',
	2: '../css/Inv_PlaLev.css?after',
	3: '../css/Inv_SlocLev.css?after',
	4: '../css/Inv_MovLev.css?after',
	default: '../css/Inven.css?after'
};	
function applyCSS(condition) {
	console.log('applyCSS condition : ' + condition);
	const linkTbody = document.createElement('link');
    linkTbody.rel = 'stylesheet';
    linkTbody.href = cssMap[condition] || cssMap['default'];

    const oldLinkTbody = document.querySelector('link[data-target="tbody"]');
    if (oldLinkTbody) oldLinkTbody.remove();

    linkTbody.setAttribute('data-target', 'tbody');
    document.head.appendChild(linkTbody);

    const linkFooter = document.createElement('link');
    linkFooter.rel = 'stylesheet';
    linkFooter.href = cssMap[condition] || cssMap['default'];

    const oldLinkFooter = document.querySelector('link[data-target="footer"]');
    if (oldLinkFooter) oldLinkFooter.remove();

    linkFooter.setAttribute('data-target', 'footer');
    document.head.appendChild(linkFooter);
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
	var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-01';
	$('.FromDate').val(today);
}
function updateClock() {
    const now = new Date();
    const year = now.getFullYear();
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    const hours = now.getHours();
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');
    
    const dateString = `${'${year}'}-${'${month}'}-${'${day}'}`;
    const timeString = `${'${hours}'}:${'${minutes}'}:${'${seconds}'}`;
    const fullString = `${'${dateString}'} ${'${timeString}'}`;
    document.getElementById('clock').textContent = fullString;
}
$(document).ready(function() {
	let TimeSetting = setInterval(updateClock, 1000);
	//updateClock();
	DateSetting();
	$('.FromDate, .EndDate').change(function() {
		var BeforeDate = null;
		var value = $(this).val();
		if($(this).hasClass('FromDate')){
			BeforeDate = new Date(value);
			var initDate = BeforeDate.getFullYear() + '-' + ('0' + (BeforeDate.getMonth() + 1)).slice(-2) + '-01';
			console.log('initDate : ' + initDate);
			$(this).val(initDate);
		}else{
			BeforeDate = new Date(value);
			var FinalDate = BeforeDate.getFullYear() + '-' + ('0' + (BeforeDate.getMonth() + 1)).slice(-2) + '-' +new Date(BeforeDate.getFullYear(), (BeforeDate.getMonth() + 1), 0).getDate();
			console.log('FinalDate : ' + FinalDate);
			$(this).val(FinalDate);
		}
		
	});
	TestFunction('Company');
	InitialTable(15);
	$('.ResBtn').click(function(){
		TimeSetting = setInterval(updateClock, 1000);
		$('.SearOp').each(function(){
           $(this).val('');
           $(this).attr('placeholder', 'SELECT');
        });
	})
	$('.Main-Colume > button').click(function(){
		$(this).closest('div').find('input').val('');
		$(this).closest('div').find('input').attr('placeholder', 'SELECT');
	})
	
	var condition = 1;
	applyCSS(condition);
    var value = '1';
    var count = null;
    $('.CateBtn').click(function() {
    	value = $(this).val();
    	switch(value){
    	case '1':
    		$("footer").show();
    		$('.LvP, .LvS, .LvM').prop('hidden',true);
    		count = 15;
    		condition = 1;
    		break;
    	case '2':
    		$("footer").show();
    		$('.LvP').prop('hidden',false);
    		$('.LvS, LvM').prop('hidden',true);
    		count = 16;
    		condition = 2;
    		break;
    	case '3':
    		$("footer").show();
    		$('.LvP, .LvS').prop('hidden',false);
    		$('.LvM').prop('hidden',true);
    		count = 17;
    		condition = 3;
    		break;
    	case '4':
    		$("footer").hide();
    		$('.LvP, .LvM').prop('hidden',false);
    		$('.LvS').prop('hidden',true);
    		count = 16;
    		condition = 4;
    		var UserId = $('.UserId').val();
    		$.ajax({
    			url:'${contextPath}/Material_Output/AjaxSet/ForPlant.jsp',
    			type:'POST',
    			data:{id : UserId},
    			dataType: 'text',
    			success: function(data){
    				var dataList = data.trim().split('-');
    				console.log(dataList);
    				$('.PlantCode').val(dataList[0]);
    			}
    		})
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
    	var InQ = 0;
    	var InA = 0;
    	var PI = 0;
    	var PA = 0;
    	var MO = 0;
    	var MA = 0;
    	var TI = 0;
    	var TA = 0;
    	var IQ = 0;
    	var IA = 0;
    	
    	
    	var FromDate = $('.FromDate').val();
    	var EndDate = $('.EndDate').val();
    	var IntFromDate = new Date(FromDate).getTime();
    	var IntEndDate = new Date(EndDate).getTime();
    	var MatData = $('.MatCode').val();
    	var ComData = $('.ComCode').val();
    	var PlantData = $('.PlantCode').val();
    	var SLoData = $('.SLocCode').val();
    	var MatType = $('.MatType').val()
    	var MovIn = $('.MovCode-In').val();
    	var MovOut = $('.MovCode-Out').val();
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
    	switch(value){
    	case '1':
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
    			        '<td>' + (data[i].Initial_Qty ?? 0) + '</td>' + 
    			        '<td>' + (data[i].Initial_Amt ?? 0) + '</td>' + 
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
    			        InQ += Number(data[i].Initial_Qty || 0);
    			        InA += Number(data[i].Initial_Amt || 0);
    			        PI += Number(data[i].Purchase_In || 0);
    			        PA += Number(data[i].Purchase_Amt || 0);
    			        MO += Number(data[i].Material_Out || 0);
    			        MA += Number(data[i].Material_Amt || 0);
    			        TI += Number(data[i].Transfer_InOut || 0);
    			        TA += Number(data[i].Transfer_Amt || 0);
    			        IQ += Number(data[i].Inventory_Qty || 0);
    			        IA += Number(data[i].Inventory_Amt || 0);
    			    }
    			},
    			error: function(jqXHR, textStatus, errorThrown){
    				alert('오류 발생: ' + textStatus + ', ' + errorThrown);
    	    	}
        	});
    		break;
    	case '2':
    	case '3':
    		if (value === '2' && (!PlantData || PlantData.trim() === '')) {
    		    return false;
    		}else if(value === '3' && (!PlantData || PlantData.trim() === '') && (!SLoData || SLoData.trim() === '')){
    			return false;
    		}
    		List['value'] = value; 
    		List['PlantData'] = PlantData;
    		List['SLoData'] = SLoData;
    		$.ajax({
    			url : '${contextPath}/Report/AjaxSet/PS_LoadData.jsp',
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
    			        '<td>' + (data[i].ComCode || '') + '</td>';
    			        if(value === '2'){
    			        	row += '<td>' + (data[i].Plant || '') + '</td>'; 
    			        }else{
    			        	row += '<td>' + (data[i].Plant || '') + '</td>' +
    			        		   '<td>' + (data[i].StorLoc || '') + '</td>';
    			        }
    			        row += '<td>' + (data[i].Material || '') + '</td>' + 
		    			       '<td>' + (data[i].MaterialDes || '') + '</td>' + 
		    			       '<td>' + (data[i].Unit || '') + '</td>' + 
		    			       '<td>' + (data[i].Initial_Qty ?? 0) + '</td>' + 
		    			       '<td>' + (data[i].Initial_Amt ?? 0) + '</td>' + 
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
    	case '4':
    		List['PlantData'] = PlantData;
    		List['MovIn'] = MovIn;
    		List['MovOut'] = MovOut;
    		List['MatType'] = MatType;
    		$.ajax({
    			url : '${contextPath}/Report/AjaxSet/Mov_LoadData.jsp',
    			type : 'POST',
    			data :  JSON.stringify(List),
    			contentType: 'application/json; charset=utf-8',
    			dataType: 'json',
    			async: false,
    			success: function(data){
    				console.log(data);
    				if(data.length === 0){
    			    	alert('해당하는 자재에 대한 데이터가 존재하지 않습니다.');
    			    	$('.MatCode').val('');
    			    	return false;
    			    }
    			    $('.InfoTable-Body').empty();
    			    for(var i = 0 ; i < data.length ; i++){
    			        var row = '<tr>' +
    			        '<td>' + (data[i].DocDate || '') + '</td>' + 
    			        '<td>' + (data[i].MatDocNum || '') + '</td>' +
    			        '<td>' + (data[i].ItemNum || '') + '</td>' + 
						'<td>' + (data[i].Material || '') + '</td>' + 
						'<td>' + (data[i].MaterialDescription || '') + '</td>' + 
						'<td>' + (data[i].InvUnit ?? '') + '</td>' + 
						'<td>' + (data[i].MovType ?? '') + '</td>' + 
						'<td>' + (data[i].MoveTypeDes ?? '') + '</td>' + 
						'<td>' + (data[i].Quantity ?? 0) + '</td>' + 
						'<td>' + (data[i].StoLoca ?? '') + '</td>' + 
						'<td>' + (data[i].STORAGR_NAME ?? '') + '</td>' + 
						'<td>' + (data[i].OrderNum ?? 'N/A') + '</td>' + 
						'<td>' + (data[i].CostObject ?? 'N/A') + '</td>' + 
						'<td>' + (data[i].Plant ?? '') + '</td>' +
						'<td>' + ComData + '</td>' + 
						'<td>' + (data[i].InputPerson ?? '') + '</td>' + 
						'</tr>';
    			        $('.InfoTable-Body').append(row);
    			    }
    			},
    			error: function(jqXHR, textStatus, errorThrown){
    				alert('오류 발생: ' + textStatus + ', ' + errorThrown);
    	    	}
        	});
    		break;
    	}
    	var TotalCount = [IA, IQ, TA, TI, MA, MO, PA, PI,InA, InQ];
    	for(var n = 0 ; n < TotalCount.length ; n++ ){
        	$("footer div").eq(n).text(TotalCount[n]);
    	}
    	applyCSS(condition);
    	clearInterval(TimeSetting);
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
			<input class="UserId" value="<%=UserIdNumber%>" hidden>
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
				<input type="text" class="PlantCode SearOp" name="PlantCode" onclick="InfoSearch('PlantSearch')" placeholder="SELECT" readonly>
				<button>Del</button>
			</div>
			<div class="Main-Colume LvS" hidden>
				<label>❗창고 : </label>
				<input type="text" class="SLocCode SearOp" name="SLocCode" onclick="InfoSearch('SLoSearch')" placeholder="SELECT" readonly>
				<button>Del</button>
			</div>
 			<div class="Main-Colume LvM" hidden>
				<label>❗재고유형 : </label>
				<input type="text" class="MatType SearOp" name="MatType" onclick="InfoSearch('TypeSearch')" readonly placeholder="SELECT">
				<button>Del</button>
			</div>
			<div class="Main-Colume LvM" hidden>
				<label>입출고 구분(From) : </label>
				<input type="text" class="MovCode-In MovCode SearOp" name="MovCode-In" onclick="InfoSearch('MovSearch')" readonly placeholder="SELECT">
				<button>Del</button>
			</div>
			<div class="Main-Colume LvM" hidden>
				<label>입출고 구분(To) : </label>
				<input type="text" class="MovCode-Out MovCode SearOp" name="MovCode-Out" onclick="InfoSearch('MovSearch')" readonly placeholder="SELECT">
				<button>Del</button>
			</div>
			<div class="Main-Colume">
				<label>Mateiral : </label>
				<input type="text" class="MatCode SearOp" name="MatCode" onclick="InfoSearch('MatSearch')" placeholder="SELECT" readonly>
				<button>Del</button>
			</div>
		</div>
		
		<div class="BtnArea">
			<button class="SearBtn">Search</button>
			<button class="ResBtn">Reset</button>
			<div class="TimeArea" id="clock">Loading...</div>
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
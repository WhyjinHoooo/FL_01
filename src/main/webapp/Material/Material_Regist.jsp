<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Material Code 생성</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script type='text/javascript'>
$(document).ready(function(){
	function InitialTable(){
		$('.InfoTable-Body').empty();
		var UserId = UserId;
		console.log(UserId);
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 8; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.InfoTable-Body').append(row);
        }
	}
	InitialTable();
	$('.matlv3Code').change(function(){
        var lv3 = $(this).val();
        console.log('lv3 Code : ' + lv3);
        $.ajax({
        	type : 'post',
        	url : '${contextPath}/Material/MakeCode.jsp',
        	data : {first : lv3},
        	success : function(response){
        		console.log(response);
        		$('input[name="matCode"]').val($.trim(response));
        	} 
        });
    });
});

window.addEventListener('DOMContentLoaded', (event) => {
    const matTypeCodeInput = document.querySelector('.matTypeCode');
    const lv1CodeInput = document.querySelector('.matlv1Code');
    const lv1DesInput = document.querySelector('.matlv1Des');
    const lv2CodeInput = document.querySelector('.matlv2Code');
    const lv2DesInput = document.querySelector('.matlv2Des');
    const lv3CodeInput = document.querySelector('.matlv3Code');
    const lv3DesInput = document.querySelector('.matlv3Des');
    const GroupCodeInput = document.querySelector('.matGroupCode');
    const GroupDesInput = document.querySelector('.matGroupDes');
    const matCodeInput = document.querySelector('.matCode');
    const DescriptionInput = document.querySelector('.Des');
    const DescriptionInput1Lv = document.querySelector('.Des');
    const DescriptionInput2Lv = document.querySelector('.Des');
    
    const resetInputs = (inputs) => {
        inputs.forEach(input => input.value = '');
    };
    
    const updateDes = () => {
        const lv1Des = lv1DesInput.value;
        const lv2Des = lv2DesInput.value;
        const lv3Des = lv3DesInput.value;

        DescriptionInput.value = [lv1Des, lv2Des, lv3Des].join(',');
    };
    
    lv3DesInput.addEventListener('change', updateDes);

    const matTypeInputs = [lv1CodeInput, lv1DesInput, lv2CodeInput, lv2DesInput, lv3CodeInput, lv3DesInput, GroupCodeInput, GroupDesInput, matCodeInput, DescriptionInput];
    const lv1Inputs = [lv2CodeInput, lv2DesInput, lv3CodeInput, lv3DesInput, GroupCodeInput, GroupDesInput, matCodeInput];
    const lv2Inputs = [lv3CodeInput, lv3DesInput, GroupCodeInput, GroupDesInput, matCodeInput];
    
    matTypeCodeInput.addEventListener('change', () => resetInputs(matTypeInputs));
    lv1CodeInput.addEventListener('change', () => resetInputs(lv1Inputs));
    lv2CodeInput.addEventListener('change', () => resetInputs(lv2Inputs));
});

function InfoSearch(field){
	var popupWidth = 1000;
    var popupHeight = 600;
    
    // 현재 활성화된 모니터의 위치를 감지
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    // 전체 화면의 크기를 감지
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
    if (width == 2560 && height == 1440) {
        // 단일 모니터 2560x1440 중앙에 팝업창 띄우기
        xPos = (2560 / 2) - (popupWidth / 2);
        yPos = (1440 / 2) - (popupHeight / 2);
    } else if (width == 1920 && height == 1080) {
        // 단일 모니터 1920x1080 중앙에 팝업창 띄우기
        xPos = (1920 / 2) - (popupWidth / 2);
        yPos = (1080 / 2) - (popupHeight / 2);
    } else {
        // 확장 모드에서 2560x1440 모니터 중앙에 팝업창 띄우기
        var monitorWidth = 2560;
        var monitorHeight = 1440;
        xPos = (monitorWidth / 2) - (popupWidth / 2) + dualScreenLeft;
        yPos = (monitorHeight / 2) - (popupHeight / 2) + dualScreenTop;
    }
    var ComCode = document.querySelector('.plantComCode').value;
    var matType = document.querySelector('.matTypeCode').value;
    var lv1 = document.querySelector('.matlv1Code').value;
    var lv2 = document.querySelector('.matlv2Code').value;
    
    switch(field){
    case "PlantSearch":
    	window.open("${contextPath}/Material/PlantSerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "MatTypeSearch":
    	window.open("${contextPath}/Material/MattypeSerach.jsp", "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "MatLv1Search":
    	window.open("${contextPath}/Material/MatLv1Serach.jsp?matType=" + matType, "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "MatLv2Search":
    	window.open("${contextPath}/Material/MatLv2Serach.jsp?matType=" + matType + "&lv1=" + lv1, "PopUp04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "MatLv3Search":
    	window.open("${contextPath}/Material/MatLv3Serach.jsp?matType=" + matType + "&lv2=" + lv2, "PopUp05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "WareSearch":
    	window.open("${contextPath}/Material/WareSerach.jsp?ComCode=" + ComCode, "PopUp06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "AdjustSearch":
    	window.open("${contextPath}/Material/AdjustSerach.jsp?ComCode=" + ComCode, "PopUp07", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    }
}
</script>
</head>
<body>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="Mat-Registed">
	<div class="Mat-Header">
		<div class="Header-Title">MaterialCode Generation</div>
		<div class="InfoInput">
			<label>Plant Code :</label>
			<input type="text" name="plantCode" class="plantCode" placeholder="선택" onclick="InfoSearch('PlantSearch')" readonly>
			<input type="text" name="plantDes" class="plantDes" readonly>
			<input type="text" name="plantComCode" class="plantComCode" hidden>
		</div>
				
		<div class="InfoInput">
			<label>Material 유형 : </label>
			<input type="text" name="matTypeCode" class="matTypeCode" placeholder="선택" onclick="InfoSearch('MatTypeSearch')" readonly>
			<input type="text" name="matTypeDes" class="matTypeDes" readonly>
		</div>
	
		<div class="InfoInput">
			<label>MatGroup 1 Level : </label>
			<input type="text" name="matlv1Code" class="matlv1Code" placeholder="선택" onclick="InfoSearch('MatLv1Search')" readonly>
			<input type="text" name="matlv1Des" class="matlv1Des" readonly>
		</div>
	
		<div class="InfoInput">
			<label>MatGroup 2 Level : </label>
			<input type="text" name="matlv2Code" class="matlv2Code" placeholder="선택" onclick="InfoSearch('MatLv2Search')" readonly>
			<input type="text" name="matlv2Des" class="matlv2Des" readonly>
		</div>
	
		<div class="InfoInput">
			<label>MatGroup 3 Level : </label>
			<input type="text" name="matlv3Code" class="matlv3Code" placeholder="선택" onclick="InfoSearch('MatLv3Search')" readonly>
			<input type="text" name="matlv3Des" class="matlv3Des" readonly>
		</div>
	
		<div class="InfoInput">
			<label>Material Code : </label>
			<input type="text" name="matCode" class="matCode" readonly>
		</div>
		
		<div class="InfoInput">
			<label>Description : </label>
			<input type="text" name="Des" class="Des">
		</div>
		
		<div class="Mat-Header-btnArea">
			<button>CREATE</button>
		</div>
	</div>
	
	<div class="Mat-Body">
		<div class="Body-Title">MaterialCode Detail</div>
		<div class="Mat-Area">
			<div class="InfoInput">		
				<label>Default 입고창고 : </label>
				<input type="text" name="StorageCode" class="StorageCode" onclick="InfoSearch('WareSearch')" placeholder="선택" readonly>
				<input type="text" name="StorageDes" class="StorageDes" readonly> 
			</div>
			
			<div class="InfoInput">	
				<label>규격 : </label>
				<input type="text" name="size" class="size">
			</div>
	
			<div class="InfoInput">
				<label>Material Group : </label>
				<input type="text" name="matGroupCode" class="matGroupCode" readonly>
				<input type="text" name="matGroupDes" class="matGroupDes" readonly> 
			</div>
				
			<div class="InfoInput">
				<label>Material 적용단계 : </label>
				<input type="text" name="matadjustCode" class="matadjustCode" onclick="InfoSearch('AdjustSearch')" placeholder="선택" readonly>
				<input type="text" name="matadjustDes" class="matadjustDes" readonly> 
			</div>
			
			<div class="InfoInput">
				<label>재고관리 단위 :</label>
				<select class="unit" name="unit">
					<optipn>SELECT</optipn>
				</select>
			</div>
			
			<div class="InfoInput">
				<label>수입검사 품목 여부 : </label>
				<input type="radio" name="examine" class="examineItem1" value="true" checked>유검사 품목	
				<input type="radio" name="examine" class="examineItem2" value="false">무검사 품목 
			</div>
			
			<div class="InfoInput">
				<label>사용 여부 : </label>
				<input type="radio" name="useYN" class="useYN1" value="true" checked>사용
				<input type="radio" name="useYN" class="useYN2" value="false">미사용
			</div>
		</div>
		
		<div class="BtnArea">
			<button class="InsertBtn">INSERT</button>
			<button class="SaveBtn">SAVE</button>
		</div>
		
		<div class="Info-Area">
			<div class="Tail-Title">Generated Material</div>
			<table class="InfoTable">
				<thead class="InfoTable-Header">
					<tr>
						<th>Material</th><th>Material Description</th><th>Storage</th><th>Standard</th><th>Material Group</th>
						<th>Material Level</th><th>Incoming Inspection</th><th>Availability</th>
					</tr>
				</thead>
				<tbody class="InfoTable-Body">
				</tbody>
			</table>
		</div>
	</div>
</div>
<footer>
	<img id="logo" name="Logo" src="${contextPath}/img/White_Logo.png" alt="">
</footer>
</body>
</html>
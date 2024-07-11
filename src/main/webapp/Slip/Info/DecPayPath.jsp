<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/forSlip.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>Insert title here</title>
</head>
<script type='text/javascript'>
function SelectOption(inputFieldId){
    var popupWidth = 515;
    var popupHeight = 600;
   /*  var ComCode = document.querySelector('#UserDepart').value; */
    
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
    var docNumber, slipNo;
    
    if(inputFieldId === "Approver"){
    	popupWidth = 700;
        popupHeight = 600;
    	var approverPopup = window.open("${contextPath}/Slip/Info/ApproverSel.jsp", "approverPopup", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } 
}
</script>
<script>
$(document).ready(function(){
	
	var add = 0;
	var minus = 0;
	
	function AddLine(){
	add++;
	console.log("추가한 횟수 : " + add);
			
	var rowItem = "<tr>";
		rowItem += "<td class='rowNum'>" + add + "</td>";
		rowItem += "<td><input type='checkbox' class='ChkBox' id='ChkBox' name='ChkBox'></td>";
		rowItem += "<td><select class='PayOp' id='PayOp' name='PayOp'>";
		rowItem += "<option value='A'>A 결재</option>"
		rowItem += "<option value='B'>B 합의</option>"
		rowItem += "<option value='C'>C 통보</option>"
		rowItem += "</select></td>"
		rowItem += "<td><a href='javascript:void(0)' onclick=\"SelectOption('Approver')\"><input class='ApproverCode line' value='Select' readonly></a></td>";
		rowItem += "<td><input type='text' class='AppName line' id='AppName' name='AppName'></td>";
		rowItem += "<td><input type='text' class='AppRank line' id='AppRank' name='AppRank'></td>";
		rowItem += "<td><input type='text' class='AppCoCt line' id='AppCoCt' name='AppCoCt'></td>";
		rowItem += "<td><input type='text' class='AppCoCtName line' id='AppCoCtName' name='AppCoCtName'></td>";
		rowItem += "<td><button class='DelBtn' id='DelBtn' name='DelBtn'>삭제</button></td>";
		rowItem += "</tr>";
	
	$('#tableBody').append(rowItem); // 동적으로 row를 추가한다.
		
	}

	$('.BtnDiv').on('click',"button[name='AddBtn']", function(){
		 AddLine();
	});	
	
	$('.tableBody').on('click',"button[name='DelBtn']", function(){
		minus++;
		var Row = $(this).closest('tr');	
		Row.remove();
		add--;
		updateRowNumbers();
	});	
	function updateRowNumbers() {
        $('#tableBody tr').each(function(index) {
            $(this).find('.rowNum').text(index + 1);
        });
    }	
});
</script>
<div class="PayPathBanner">결재/합의 경로지정</div>
<body>
    <center>
	<div class="PayPathDiv">
	     <table id="resultTable">
	     	<thead>
		        <tr>
		            <th>항번</th><th>선택</th><th>결재구분</th><th>결재/합의자 사번</th><th>성명</th><th>직급</th><th>부서코드</th><th>부서명</th><th>삭제</th>
		        </tr>
	        </thead>
	        <tbody class="tableBody" id="tableBody">
			</tbody>
	    </table>
	</div>   
	<div class="BtnDiv">
		<button type="button" class="AddBtn btn" id="AddBtn" name="AddBtn">셀 추가</button>
		<button class="ApproverChange btn" id="ApproverChange">결재자 변경</button>
		<button class="InfoSave btn" id="ApproverChange">저 장</button>
		<button class="InfoCancel btn" id="ApproverChange">취 소</button>
	</div> 
    </center>
</body>
</html>
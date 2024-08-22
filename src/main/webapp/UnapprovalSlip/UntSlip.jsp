<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<%
	String User_Id = (String)session.getAttribute("id");
	String User_Depart = (String)session.getAttribute("depart");
	LocalDateTime Calendar = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String formattedToday = Calendar.format(formatter);
%>
<link rel="stylesheet" href="../css/USTcss.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
$(document).ready(function(){
	BtnAccess();
	$('.InputerId').on('change', function() {
		BtnAccess();
	});
	    
	$('.ApproverId').on('change', function() {
		BtnAccess();
	});
/* 	var OP_ComCode = $('.UserComCode').val(); // 검색 조건 중 회사코드
	var OP_BA = $('.UserBizArea').val(); // 검색 조건 중 BA
	var OP_COCT = $('.UserDepartCd').val(); // 검색 조건 중 COCT
	var OP_Inputer = $('.InputerId').val(); // 검색 조건 중 전표 입력자
	var OP_Approver = $('.ApproverId').val(); // 검색 조건 중 결재합의자
	var OP_TFrom = $('.TimeStampF').val(); // 검색 조건 중 기표일자 From
	var OP_TEnd = $('.TimeStampE').val(); // 검색 조건 중 기표일자 End
	var OP_SlipState = $('.UnSlipState').val(); // 검색 조건 중 전표 상태
	var OP_SlipType = $('.SlipType').val(); // 검색 조건 중 전요유형 */
	var OP_table = $('.UnAppSlipTable');
	
	var FromDate = new Date("<%=formattedToday%>");
	$(".TimeStampF").val(formatDate(FromDate));
	$(".TimeStampE").val(formatDate(FromDate));
	
	function formatDate(date) {
	    var dd = String(date.getDate()).padStart(2, '0');
	    var mm = String(date.getMonth() + 1).padStart(2, '0'); //January is 0!
	    var yyyy = date.getFullYear();
	
	   return yyyy + '-' + mm + '-' + dd;
	}
	
	function InfoReset(event){
		$('.UserBizArea').val('');
		$('.UserBizArea_Des').val('');
		$('.UserDepartCd').val('');
		$('.UserDepartCd_Des').val('');
		$('.InputerId').val('');
		$('.Inputer_Name').val('');
		$('.ApproverId').val('');
		$('.Approver_Name').val('');
	}
	function SlipSearch(event){
		event.preventDefault();
		
		var OP_ComCode = $('.UserComCode').val(); // 검색 조건 중 회사코드
		var OP_BA = $('.UserBizArea').val(); // 검색 조건 중 BA
		var OP_COCT = $('.UserDepartCd').val(); // 검색 조건 중 COCT
		var OP_Inputer = $('.InputerId').val(); // 검색 조건 중 전표 입력자
		var OP_Approver = $('.ApproverId').val(); // 검색 조건 중 결재합의자
		var OP_TFrom = $('.TimeStampF').val(); // 검색 조건 중 기표일자 From
		var OP_TEnd = $('.TimeStampE').val(); // 검색 조건 중 기표일자 End
		var OP_SlipState = $('.UnSlipState').val(); // 검색 조건 중 전표 상태
		var OP_SlipType = $('.SlipType').val(); // 검색 조건 중 전요유형
		
		
		const Date_From = new Date(OP_TFrom); // 검색 조건 중 기표일자 From -> 날짜의 형식으로 변환
		const Date_End = new Date(OP_TEnd); // 검색 조건 중 기표일자 End -> 날짜의 형식으로 변환
		if(Date_From.getTime() > Date_End.getTime()){
			alert("날짜를 정확하게 입력해주세요.");
			return false;
		};
		
		var OptionList = {};
		$('.Option').each(function(){
			var name = $(this).attr("name");
			var value = $(this).val();
			OptionList[name] = value;
		})
		console.log("검색할 조건들01 : ", OptionList);
		
		
		$.ajax({
			url: '${contextPath}/UnapprovalSlip/InfoSearch/FacetSearch.jsp', // Facet: 조건검색
			type: 'POST',
			data: JSON.stringify(OptionList),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(response){
				console.log(response);
				 var $tbody = $('#UnAppSlipTable tbody');
				if(response.length > 0){
					$tbody.empty(); // 기존 데이터 삭제
					//var data = JSON.parse(response);
					// OP_table.find('tr:gt(0)').remove();
					for(var i = 0 ; i < response.length; i++){
						var row = '<tr>' +
						'<td>' + (i+1) + '</td>' + // 항번
						'<td><input type="checkbox" class="checkboxBtn"></td>' + //체크 박스
						'<td class="SubmitDate" name="PostingDate">' + response[i].Date + '</td>' + // 기표일자
						'<td class="SubmitDate Head" id="SlipNo" name="SlipNo">' + response[i].DocCode + '</td>' + // 전표번호
						'<td class="SubmitDate" name="Script">' + response[i].Script + '</td>' + // 적요
						'<td class="SubmitDate Head" name="UserBizArea">' + response[i].BA + '</td>' + // BA
						'<td class="SubmitDate Head" name="TargetDepartCd">' + response[i].CoCt + '</td>' + // COCT
						'<td class="SubmitDate Head" name="User">' + response[i].Inputer + '</td>' + // 입력자
						'<td class="SubmitDate" name="DSum">' + response[i].DSum + '</td>' + // 차변 합계
						'<td class="SubmitDate" name="CSum">' + response[i].CSum + '</td>' + // 대변 합계
						'<td class="SubmitDate" name="DocState">' + response[i].Status + '</td>' + // 전표상태
						'<td class="SubmitDate" name="ApprovalLevel">' + response[i].Step + '</td>' + // 결재단계
						'<td class="SubmitDate" name="Approver">' + response[i].Approver + '</td>' + // 결재/합의자
						'<td class="SubmitDate" name="Time">' + response[i].Time + '</td>' + // 경과일수
						'<td class="SubmitDate" name="DocType">' + response[i].Type + '</td>' + // 전표유형
						'<td class="SubmitDate Head" name="UserDepart" hidden>' + response[i].ComCode + '</td>'; // 법인

						// 조건에 따른 LineInfo 열 추가
					    if (response[i].LineInfo == "Yes") {
					    	 row += '<td class="SubmitDate" name="LineInfo" id="LineInfo"><a href="javascript:void(0)" onClick="LinfInfoShow(\'' + response[i].DocCode + '\')">&#128172;</a></td>';
					    } else {
					        row += '<td class="SubmitDate" name="LineInfo" id="LineInfo"></td>';
					    }
						
						 row += '</tr>';
						//OP_table.append(row);
						$tbody.append(row);
					};
				} else{
					alert("해당 조건을 만족하는 미승인 전표가 없습니다.");
					$tbody.empty();
				}
			},
			error: function(){
		          alert("에러 발생");
			}
		});
		
	}
	$('.Inquiry').on('click', SlipSearch);
	$('.ResetBtn').on('click', InfoReset);
	/* 
	사용자 인터랙션 처리:

	1. 웹 페이지에서 사용자와 상호작용할 수 있는 요소(버튼, 링크, 폼 등)는 여러 가지가 있습니다. 이벤트 리스너를 통해 이러한 요소들이 클릭되거나 다른 방식으로 상호작용될 때 실행할 코드를 정의할 수 있습니다.
	예: 사용자가 버튼을 클릭하면 특정 작업(알림 표시, 폼 데이터 제출 등)이 수행됩니다.
	비동기 이벤트 처리:
	
	2. 이벤트 리스너는 비동기적으로 동작합니다. 즉, 웹 페이지가 로드된 후에도 이벤트가 발생할 때마다 지정된 함수를 호출합니다. 이를 통해 사용자의 액션에 실시간으로 반응할 수 있습니다.
	코드의 분리와 유지보수:
	
	3. 이벤트 리스너를 사용하면 코드를 더 모듈화하고 관리하기 쉽게 만들 수 있습니다. 특정 이벤트에 대한 처리를 별도의 함수로 정의하고, 필요할 때 그 함수를 호출하는 구조로 만들면 코드가 더 깔끔하고 유지보수하기 쉬워집니다.
	다양한 이벤트 처리 가능:
	
	4. 이벤트 리스너를 사용하면 클릭, 마우스 이동, 키보드 입력, 페이지 로드 등 다양한 이벤트를 처리할 수 있습니다. 이를 통해 더 복잡하고 풍부한 사용자 경험을 제공할 수 있습니다.
	
	이벤트 리스너의 역할:
		이벤트 연결: 이벤트 리스너는 특정 이벤트와 이를 처리할 함수를 연결하는 역할을 합니다. 예를 들어, 버튼 클릭 이벤트와 SlipSearch 함수를 연결합니다.
		이벤트 발생 시 함수 호출: 이벤트가 발생할 때 이벤트 리스너가 연결된 함수를 호출하여 정의된 동작을 수행합니다. 예를 들어, 버튼이 클릭될 때 SlipSearch 함수가 호출됩니다.
	*/
});
</script>
<script>
function LinfInfoShow(docCode){
    console.log("Selected DocCode:", docCode);
    var popupWidth = 1030;
    var popupHeight = 360;
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
    window.open("${contextPath}/UnapprovalSlip/InfoSearch/LineinfoShow.jsp?SlipCode=" + docCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
}
function BtnAccess() {
    var loginId = "<%=User_Id%>"; // loginId를 문자열로 처리합니다.
    var InputerId = $('.InputerId').val(); // 전표입력자
    var ApproverId = $('.ApproverId').val(); // 결재합의자  
    if (
        // 1. InputerId와 ApproverId가 모두 없고 loginId만 있는 경우
        (!InputerId && !ApproverId && loginId) ||

        // 2. ApproverId가 없고 InputerId가 loginId와 같은 경우
        (!ApproverId && InputerId === loginId) ||

        // 3. InputerId의 유무에 상관없이 ApproverId가 loginId와 같은 경우
        (ApproverId === loginId)
    ) {
        console.log("EnabledBtn 실행됨");
        EnabledBtn();
    } else {
        console.log("DisabledBtn 실행됨");
        DisabledBtn();
    }
};

function DisabledBtn(){
    $('.ButtonArea Button').attr('disabled', true);
};

function EnabledBtn(){
    $('.ButtonArea Button').attr('disabled', false);
};

function InfoSearch(event, inputFieldId){
	event.preventDefault();

	var popupWidth = 1000;
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
    
    var UserComCode = $('.UserComCode').val();
    
    switch(inputFieldId){
	    case "BA_Btn":
	    	window.open("${contextPath}/UnapprovalSlip/InfoSearch/BAInfoSearch.jsp?Comcode=" + UserComCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "COCT_Btn":
	    	window.open("${contextPath}/UnapprovalSlip/InfoSearch/CoCtInfoSearch.jsp?Comcode=" + UserComCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    		break;
	    case "Inputer_Btn":
	    	window.open("${contextPath}/UnapprovalSlip/InfoSearch/InputerInfoSearch.jsp?Comcode=" + UserComCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    		break;
	    case "Approver_Btn":
	    	window.open("${contextPath}/UnapprovalSlip/InfoSearch/ApproverInfoSearch.jsp?Comcode=" + UserComCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    		break;
	    default:
    		break;
    		
    }
}
function ApprovalBtn(event, ActionField){
	event.preventDefault();
	
	/* if ($('.ButtonArea button').attr('disabled')) {
        return; // 버튼이 비활성화된 경우, 아무 동작도 하지 않음
    } */
	
	var popupWidth = 1000;
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
    var HeadList = {};
    $('input.checkboxBtn:checked').closest('tr').find('.Head').each(function(){
    	var name = $(this).attr("name");
    	/* var value = $(this).val(); */
    	var value = $(this).text();
    	HeadList[name] = value;
    });
    var Ch_Count = $('input.checkboxBtn:checked').length;
    console.log(Ch_Count);
    if(Ch_Count > 1){
    	alert("전표 1개만 선택해주세요.");
    	return false;
    } else if(Ch_Count === 0){
    	alert("전표 1개를 선택해주세요.");
    	return false;
    }
    
    var row = $('input.checkboxBtn:checked').closest('tr');
    
    console.log("HeadList : " , HeadList);
    
    var queryString = Object.keys(HeadList).map(function(key) {
        return encodeURIComponent(key) + '=' + encodeURIComponent(HeadList[key]);
    }).join('&');
    
    var SilpCode = $('input.checkboxBtn:checked').closest('tr').find('#SlipNo').text();
    console.log("전표코드를 확인용 코드 : " + SilpCode);
    
	switch(ActionField){
	case "Path":
		$.ajax({
			url: '${contextPath}/Slip/Info/WFCheck.jsp',
			 type: 'POST',
			 data: JSON.stringify(HeadList),
			 contentType: 'application/json; charset=utf-8',
 	         dataType: 'json', // 수정: datatype -> dataType
 	        success: function(response){
 	        	if(response.result === "Fail"){ // 미상신 전표 중 결재경로가 등록되지 않는 전표인 경우
 	        		popupWidth = 1200;
 	        	    popupHeight = 600;
 	                console.log("백곰파Success");
 	               var popup = window.open(
 	                        "${contextPath}/Slip/Info/DecPayPath.jsp?" + queryString, 
 	                        "테스트", 
 	                        "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
 	                    );
 	               
 	              var timer = setInterval(function() { 
 	            	    if (popup.closed) {
 	            	        clearInterval(timer);
 	            	        if (confirm("품의 상신을 진행하시겠습니까?")) {
 	            	        	popupWidth = 750;
	 	            	   	    popupHeight = 400;
	 	            	   		window.open(
 	            	                    "UnslipOpWirte.jsp?SlipCode=" + SilpCode, 
 	            	                    "테스트", 
 	            	                    "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
 	            	                );
 	            	        } else {
 	            	            // 취소 버튼을 눌렀을 때 실행할 코드
 	            	            console.log("작업을 취소합니다.");
 	            	        }
 	            	    }
 	            	}, 500);
 	        	} else{
 	        		if (confirm("결재경로가 등록된 전표입니다.\n품의 상신을 진행하시겠습니까?")) {
         	        	popupWidth = 750;
	            	   	    popupHeight = 400;
	            	   		window.open(
         	                    "UnslipOpWirte.jsp?SlipCode=" + SilpCode, 
         	                    "테스트", 
         	                    "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
         	                );
         	        } else {
         	            alert("품의 상신을 취소합니다.");
         	        }
 	        	}
 	        }
		})
		break
	case "Submit":
		$.ajax({
			url: '${contextPath}/Slip/Info/WFCheck.jsp',
			 type: 'POST',
			 data: JSON.stringify(HeadList),
			 contentType: 'application/json; charset=utf-8',
 	         dataType: 'json', // 수정: datatype -> dataType
 	        success: function(response){
 	        	if(response.result === "Fail"){ // 미상신 전표 중 결재경로가 등록되지 않는 전표인 경우
 	        		popupWidth = 1200;
 	        	    popupHeight = 600;
 	                console.log("백곰파Success");
 	               var popup = window.open(
 	                        "${contextPath}/Slip/Info/DecPayPath.jsp?" + queryString, 
 	                        "테스트", 
 	                        "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
 	                    );
 	               
 	              var timer = setInterval(function() { 
 	            	    if (popup.closed) {
 	            	        clearInterval(timer);
 	            	        if (confirm("품의 상신을 진행하시겠습니까?")) {
 	            	        	popupWidth = 750;
	 	            	   	    popupHeight = 400;
	 	            	   		window.open(
 	            	                    "UnslipOpWirte.jsp?SlipCode=" + SilpCode, 
 	            	                    "테스트", 
 	            	                    "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
 	            	                );
 	            	        } else {
 	            	        	alert("품의 상신을 취소합니다.");
 	            	        }
 	            	    }
 	            	}, 500);
 	        	} else{
 	        		if (confirm("결재경로가 등록된 전표입니다.\n품의 상신을 진행하시겠습니까?")) {
         	        	popupWidth = 750;
	            	   	popupHeight = 400;
	            	   	window.open(
							"UnslipOpWirte.jsp?SlipCode=" + SilpCode, 
							"테스트", 
         	                "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
         	                );
         	        } else {
         	            // 취소 버튼을 눌렀을 때 실행할 코드
         	            console.log("작업을 취소합니다.");
         	        }
 	        	}
 	        }
		})
		break;
	case "Cancel":
		$.ajax({
			url: '${contextPath}/UnapprovalSlip/InfoSearch/DeleteUnSlip.jsp',
			type: 'POST',
			data: {DocCode : SilpCode},
			dataType: 'json',
			success: function(response){
				if(response.status === 'success'){
					alert('데이터 삭제 완료');
					row.remove();
				} else {
					alert('삭제 실패');
					console.log('Error : ', response.message);
				}
			}, 
            error: function(jqXHR, textStatus, errorThrown) {
                console.log('Error:', textStatus, errorThrown);
            }
		});
		break;
	case "Approve":
		$.ajax({
			url: '${contextPath}/UnapprovalSlip/InfoSearch/SlipStateCheck.jsp',
			type: 'POST',
			data: {EntryCode : SilpCode},
			data: {DocCode : SilpCode},
			dataType: 'json',
			success: function(response){
				if(response.status === 'C'){
					console.log("저장 전표")
						$.ajax({
						url: '${contextPath}/Slip/Info/WFCheck.jsp',
						type: 'POST',
						data: JSON.stringify(HeadList),
						contentType: 'application/json; charset=utf-8',
			 	        dataType: 'json', // 수정: datatype -> dataType
			 	        success: function(response){
			 	        	if(response.result === "Fail"){ // 미상신 전표 중 결재경로가 등록되지 않는 전표인 경우
			 	        		popupWidth = 1200;
								popupHeight = 600;
			 	                console.log("백곰파Success");
			 	               	var popup = window.open(
			 	                        "${contextPath}/Slip/Info/DecPayPath.jsp?" + queryString, 
			 	                        "테스트", 
			 	                        "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
			 	                    );
			 	               
			 	              	var timer = setInterval(function() {
									if (popup.closed) {
			 	            	    	clearInterval(timer);
			 	            	        if (confirm("품의 상신을 진행하시겠습니까?")) {
			 	            	        	popupWidth = 750;
				 	            	   	    popupHeight = 400;
				 	            	   		window.open(
			 	            	                    "UnslipOpWirte.jsp?SlipCode=" + SilpCode, 
			 	            	                    "테스트", 
			 	            	                    "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
			 	            	                );
			 	            	        } else {
			 	            	        	alert("품의 상신을 취소합니다.");
			 	            	        }
			 	            	    }
			 	            	}, 500);
			 	        	} else{
			 	        		if (confirm("결재경로가 등록된 전표입니다.\n품의 상신을 진행하시겠습니까?")) {
			         	        	popupWidth = 750;
				            	   	popupHeight = 400;
				            	   	window.open(
			         	            	"UnslipOpWirte.jsp?SlipCode=" + SilpCode, 
			         	                "테스트", 
			         	                "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
			         	                );
			         	        } else {
			         	            // 취소 버튼을 눌렀을 때 실행할 코드
			         	            console.log("작업을 취소합니다.");
			         	        }
			 	        	}
			 	        }
					})
				} else if(response.status === 'B'){
					console.log("품의 상신 진행");
					if (confirm("결재경로가 등록된 전표입니다.\n품의 상신을 진행하시겠습니까?")) {
         	        	popupWidth = 750;
	            	   	popupHeight = 400;
	            	   	window.open(
         	                    "UnslipOpWirte.jsp?SlipCode=" + SilpCode, 
         	                    "테스트", 
         	                    "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
         	                );
         	        } else {
         	            alert("품의 상신을 취소합니다.");
         	        }
				} else{
					console.log("결재 진행");
					//window.location.href="${contextPath}/UnapprovalSlip/AppAgree.jsp?EnrtyNumber=" + SilpCode;
					popupWidth = 2300;
            	   	popupHeight = 900;
            	   	xPos = (monitorWidth / 2) - (popupWidth / 2) + dualScreenLeft;
                    yPos = (monitorHeight / 2) - (popupHeight / 2) + dualScreenTop;
            	   	console.log("xPos : " + xPos);
            	   	console.log("yPos : " + yPos);
            	   	window.open(
     	                    "${contextPath}/UnapprovalSlip/AppAgree.jsp?EnrtyNumber=" + SilpCode, 
     	                    "테스트", 
     	                    "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
     	                );
				}
			}, 
            error: function(jqXHR, textStatus, errorThrown) {
                console.log('Error:', textStatus, errorThrown);
            }
		})
		break;
	default:
			break;
	}
}
</script>
<meta charset="UTF-8">
<title>전표 품의 상신 및 결재</title>
</head>
<body>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<hr>
	<form name="###" class="###" action="###" method="###" enctype="UTF-7">
		<div class="TotalArea">
			<div class="slip_Search_Area">
				<div class="Area_title">검색 조건</div>
				<table class="UserInfo">
						<tr>
							<th>법인(ComCode) : </th>
							<td>
								<input type="text" class="UserComCode Option" name="UserComCode" id="UserComCode" value="<%=User_Depart%>" readonly>
								<checkbox></checkbox>
							</td>
						</tr>
						<tr>
							<th>전표입력 BA : </th>
							<td>
								<a><input type="text" class="UserBizArea Option" name="UserBizArea" id="UserBizArea" placeholder="선택" readonly></a>
								<input type="text" class="UserBizArea_Des" name="UserBizArea_Des" id="UserBizArea_Des" hidden>
								<button class="BASearchBtn" id="BASearchBtn" onclick="InfoSearch(event, 'BA_Btn')";>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표입력부서 : </th>
							<td>
								<a><input class="UserDepartCd Option" name="UserDepartCd" id="UserDepartCd" placeholder="선택" readonly></a>
								<input type="text" class="UserDepartCd_Des" name="UserDepartCd_Des" id="UserDepartCd_Des" hidden>
								<button class="COCTSearchBtn" id="COCTSearchBtn" onclick="InfoSearch(event, 'COCT_Btn')">&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표 입력자 : </th>
							<td>
								<input type="text" class="InputerId Option" name="InputerId" id="InputerId" placeholder="선택" readonly>
								<input type="text" class="Inputer_Name" name="Inputer_Name" id="Inputer_Name" hidden>
								<button class="InputerSearchBtn" id="InputerSearchBtn" name="InputerSearchBtn" onclick="InfoSearch(event, 'Inputer_Btn')">&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>결재 합의자 : </th>
							<td>
								<input type="text" class="ApproverId Option" name="ApproverId" id="ApproverId" placeholder="선택" readonly>
								<input type="text" class="Approver_Name" name="Approver_Name" id="Approver_Name" hidden>
								<button class="ApproverSearchBtn" id="ApproverSearchBtn" name="ApproverSearchBtn" onclick="InfoSearch(event, 'Approver_Btn')">&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>기표일자(From) : </th>
							<td>
								<input type="date" class="TimeStampF Option" name="TimeStamp From" id="TimeStamp_From">
							</td>
						</tr>
						<tr>
							<th>기표일자(To) : </th>
							<td>
								<input type="date" class="TimeStampE Option" name="TimeStamp To" id="TimeStamp_End">
							</td>
						</tr>
						<tr>
							<th>미승인전표 상태 : </th>
							<td>
								<select class="UnSlipState Option" id="UnSlipState" name="UnSlipState">
									<option value="A">A 미상신</option>
									<option value="B">B 결재 진행중</option>
									<option value="C">C 승인 완료</option>
									<option value="D">D 결재 반려</option>
									<option value="Z">Z 불완전전표</option>
								</select>
							</td>
						</tr>
				</table>
				<button class="Inquiry">조회</button>
				<button class="ResetBtn">초기화</button>
			</div>
			<div class="UntSituation">
				<div class="Area_title">미승인전표 현황</div>
				<div class="ButtonArea">
					<button onclick="ApprovalBtn(event, 'Path')">결재경로</button>
					<button onclick="ApprovalBtn(event, 'Submit')">품의상신</button>
					<button onclick="ApprovalBtn(event, 'Cancel')">품의취소</button>
					<button onclick="ApprovalBtn(event, 'Approve')">결재/합의</button>
				</div>
				<div class="UnApprovalDocArea">
					<table class="UnAppSlipTable" id="UnAppSlipTable">
					<thead>
						<th>항번</th><th>선택</th><th>기표일자</th><th>전표번호</th><th>적요</th><th>전표입력 BA</th>
						<th>전표입력부서</th><th>전표입력자</th><th>차변합계</th><th>대변합계</th><th>전표상태</th>
						<th>결재단계</th><th>결재/합의자</th><th>경과일수</th><th>전표유형</th><th>상세</th>
					</thead>
					<tbody>
				        <!-- 데이터가 여기에 로드됩니다 -->
				    </tbody>
					</table>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
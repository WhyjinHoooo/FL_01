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
<link rel="stylesheet" href="../css/forSlip.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>일반 대체전표 입력</title>
<%
	String User_Id = (String)session.getAttribute("UserIdNumber");
	String User_Depart = (String)session.getAttribute("depart");
	String User_Name = (String)session.getAttribute("name");
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String todayDate = today.format(formatter);
%>
<script type='text/javascript'>
	document.addEventListener("DOMContentLoaded", function() {
	    var now_utc = Date.now();
	    var timeOff = new Date().getTimezoneOffset() * 60000;
	    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
	    var dateElement = document.getElementById("Date");
	
	    if (dateElement) {
	        dateElement.setAttribute("max", today);
	    } else {
	        console.error("Element with id 'Date' not found.");
	    }
	});
</script>
<script type='text/javascript'>
function UserBAInput(inputFieldId){
    var popupWidth = 515;
    var popupHeight = 600;
   /*  var ComCode = document.querySelector('#UserDepart').value; */

    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;

    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    /*  
    window.innerWidth와 window.innerHeight:
	-> 현재 브라우저 창의 콘텐츠 영역의 너비와 높이를 나타냅니다.
	-> 보통 브라우저 창의 크기를 나타내며, 스크롤 바와 메뉴 바를 제외한 영역을 포함합니다.
	-> 대부분의 현대 브라우저에서 지원합니다.
	
	document.documentElement.clientWidth와 document.documentElement.clientHeight:	
	-> 문서의 루트 요소 (<html> 태그)의 클라이언트 영역의 너비와 높이를 나타냅니다.
	-> 이 값은 window.innerWidth와 window.innerHeight가 정의되지 않았을 때 사용됩니다.
	-> 보통은 스크롤 바를 제외한 콘텐츠 영역의 크기를 의미합니다.
	
	screen.width와 screen.height:	
	-> 사용 중인 모니터의 전체 해상도를 나타냅니다.
	-> window.innerWidth와 document.documentElement.clientWidth가 둘 다 정의되지 않은 경우에 사용됩니다.
	-> 스크린 전체의 너비와 높이를 반환합니다.
    */
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
    var docNumber, slipNo;
    if(inputFieldId === "UsedUserBA"){
    	window.open("${contextPath}/Slip/Info/UsedCom.jsp", "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } else if(inputFieldId === "BizMoneyCode"){
    	popupWidth = 900;
    	window.open("${contextPath}/Slip/Info/MoneySearch.jsp", "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } else if(inputFieldId === "AccSubjectSelect"){
    	popupWidth = 900;
    	window.open("${contextPath}/Slip/Info/AccSubjectSearch.jsp", "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } else if(inputFieldId === "SlipTypeSel"){
    	popupWidth = 900;
    	window.open("${contextPath}/Slip/Info/SlipTypeSelect.jsp", "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    }else if(inputFieldId === "DeptdSelect"){
    	popupWidth = 900;
    	window.open("${contextPath}/Slip/Info/DeptdSelect.jsp", "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } else if(inputFieldId === "LineInfo"){
    	var element = event.target.closest('[data-docnumber][data-slipno]');
        docNumber = element.getAttribute('data-docnumber');
        slipNo = element.getAttribute('data-slipno');

        var C100 = ("0000" + docNumber).slice(-4);
        var D100 = slipNo + "_" + C100;
    	popupWidth = 900;
    	window.open("${contextPath}/Slip/Info/LineInfo.jsp?SearchDoc=" + D100, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    }
}
</script>
<script type="text/javascript">
$(document).ready(function(){
	var SlipType = $('.SlipType').val();
	var FirSlipNo = $('.SlipNo').val();
	var todayDate = $('.ToDate').val();
	var UserId = $('.User').val();
	var DeCreBDid = $('.DeCre').val();
	var Acc = $('.AccSubject').val();
	
	$.ajax({
		url: '${contextPath}/Slip/AjaxSet/SlipNoSelect.jsp',
		type: 'POST',
		data: { type : SlipType, No : FirSlipNo, Date: todayDate },
		success: function(response){
			console.log(response);
			$('input[name="SlipNo"]').val($.trim(response));
			$('input[name="DocNumber"]').val("0001").change();
			
			var Number = $('.DocNumber').val(); // 아마도 0001
			var SlipDocNum = $('.SlipNo').val(); // 바뀐 전표 번호, FIG20230531S0001
			
			$.ajax({
				url: '${contextPath}/Slip/AjaxSet/NumberChange.jsp',
				type: 'POST',
				data: { Number : Number, SlipDocNum : SlipDocNum },
				success: function(response){
					console.log(response);
					$('input[name="DocNumber"]').val($.trim(response));
				}
			});
		}
	});
	
	$('.SlipType').on('change', function() {

	    var SlipType = $(this).val(); // 이벤트 핸들러 내에서 값 가져오기
	    var FirSlipNo = $('.SlipNo').val();
	    var todayDate = $('.ToDate').val();

	    $.ajax({
	        url: '${contextPath}/Slip/AjaxSet/SlipNoSelect.jsp',
	        type: 'POST',
	        data: { type: SlipType, No: FirSlipNo, Date: todayDate },
	        success: function(response) {
	            console.log(response);
	            $('input[name="SlipNo"]').val($.trim(response));
	            $('input[name="DocNumber"]').val("0001").change();

	            var Number = $('.DocNumber').val(); // 아마도 0001
	            var SlipDocNum = $('.SlipNo').val(); // 바뀐 전표 번호, FIG20230531S0001
	            
	            $.ajax({
	                url: '${contextPath}/Slip/AjaxSet/NumberChange.jsp',
	                type: 'POST',
	                data: { Number: Number, SlipDocNum: SlipDocNum },
	                success: function(response) {
	                    console.log(response);
	                    $('input[name="DocNumber"]').val($.trim(response));
	                }
	            });
	        }
	    });
	});
	
	$.ajax({
	    url: '${contextPath}/Slip/AjaxSet/WriterInfo.jsp',
	    type: 'POST',
	    data: { id: UserId },
	    success: function(response) {
	        if (response.length > 0) {
	            var data = response[0];
	            $('#UserBizArea').val(data.UserBA);
	            $('#TargetDepartCd').val(data.UserCoct);
	            $('#TargetDepartDes').val(data.UserCoctDes);
	        } else {
	            console.log("No data found.");
	        }
	    },
	    error: function(xhr, status, error) {
	        console.error("Ajax request failed: ", status, error);
	    }
	});
	var ComCode = $('.UserDepart').val();
	console.log("회사 코드 : " + ComCode);
	
	if(ComCode == null || ComCode == ""){
		return false;
	};
	$.ajax({
		url: '${contextPath}/Slip/AjaxSet/CurrencyFind.jsp',
		type: 'POST',
		data: { Com : ComCode },
		success: function(response){
			console.log(response);
			$('input[name="ledcurrency"]').val($.trim(response));
		}
	});
	
	/*
	버튼을 사용하는 경우
	$('.DealPrice-btn').on('click', function(event) {
        event.preventDefault();
        convertCurrency();
    });
	
	function convertCurrency() {
        var dealPrice = parseFloat(document.getElementById("DealPrice").value);
        var currencyCode = document.getElementById("ledcurrency").value;
        var DealCurrency = document.getElementById("money-code").value;
        
        if (!isNaN(dealPrice) && currencyCode) {
        	console.log(dealPrice + ", " + currencyCode + ", " + DealCurrency);
        	
            $.ajax({
                url: 'PriceExchange.jsp', // 절대 경로로 변경
                type: 'POST',
                data: { currencyCode: currencyCode, dealPrice: dealPrice, DealCurrency: DealCurrency },
                success: function(response) {
                	$('input[name="ledPrice"]').val($.trim(response));
                },
                error: function() {
                    alert('Failed to retrieve exchange rate');
                }
            });
        } else {
            alert('Please enter a valid deal price and currency code');
        }
    } 
	*/
	$('.DealPrice').on('input', function(){
		// 버튼을 사용하지 않고 거래통화와 거래 금액만 입력되면 바로 작동되는 경우
		var dealPrice = parseFloat($(this).val());
        var currencyCode = document.getElementById("ledcurrency").value;
        var DealCurrency = document.getElementById("money-code").value;
        if (!isNaN(dealPrice) && currencyCode) {
        	console.log(dealPrice + ", " + currencyCode + ", " + DealCurrency);
        	
            $.ajax({
                url: '${contextPath}/Slip/AjaxSet/PriceExchange.jsp', // 절대 경로로 변경
                type: 'POST',
                data: { currencyCode: currencyCode, dealPrice: dealPrice, DealCurrency: DealCurrency },
                success: function(response) {
                	$('input[name="ledPrice"]').val($.trim(response));
                },
                error: function() {
                    alert('Failed to retrieve exchange rate');
                }
            });
        } else {
            alert('Please enter a valid deal price and currency code');
        }
	});
    /* 화면에 보이는 항번을 정의하기 위한 변수들 */
	var Add = 0;
	var Minus = 0;
	var RowNum = 1; // 행번호
	var DelItemNum = null;
	var DeletedItems = []; // 삭제할 항목들 리스트
	
	$('.DeCre').on('change', function() {
	    DeCreBDid = $('input[name="DeCre"]:checked').val();
	    SlipType = $('input[name="SlipType"]').val();
	    Acc = $('input[name="AccSubject"]').val();
	});
	
	$('.FuncArea').on('click', "img[name='Down']", function(){ // 임시 저장버튼을 클릭한 경우
		DeCreBDid = $('input[name="DeCre"]:checked').val(); // Debit/Credit
	    SlipType = $('input[name="SlipType"]').val(); // 전표유형
	    Acc = $('input[name="AccSubject"]').val();
	   
		var AccSubject = $('.AccSubject').val();
		var DealCode = $('.money-code').val();
		var DealPrice = $('.DealPrice').val();
		var Deptd = $('.Deptd').val();
		var LineBrief = $('.LineBriefs').val();
		
		var ConSumeDate = $('.ConsumeDate').val();
		
		var PageNumber = parseInt($('.DocNumber').val(), 10);
		
		if(!AccSubject || !DealCode || !DealPrice || !Deptd || !LineBrief){
			alert("계정과목, 거래통화, 거래금액, 관리/귀속 부서, 라인 적요를 입력해주세요.");
			return false;
		}
		
		var Combination = {};
		
		var ChildList = {};
		$('.child').each(function(){
			var name = $(this).attr("name");
			// class가 'child'인 것들 중 name속성에 저장된 이름을 var name에 저장
			if($(this).attr('type') === 'checkbox'){
				if($(this).is(':checked')){
					var value = $(this).val();	
					ChildList[name] = value;
				}
			}else {
				var value = $(this).val();
				ChildList[name] = value;
			}
		}); // Child에 입력된 정보를 임시저장테이블 tmpaccfldocline에 저장할 항목들
		
		
		var LineFormList = {};
		
		if(DeCreBDid === "C" /* && SlipType === "CRE" */ && (Acc === "2003500" || Acc === "2003510" || Acc === "2003520")){
			$('.lineform').each(function(){
				var name = $(this).attr("name");
				var value = $(this).val();
				LineFormList[name] = value;
			}); // 전표유형이 CRE고 차변이고, 계정과목일 미지급금일 경우, 임시저장테이블 tmpaccfidoclineinform에 저장할 항목들
			
			Combination = {
					TmpAccFLine : ChildList,
					TmpAccFLForm : LineFormList
			};
		} else {
			Combination = {
					TmpAccFLine : ChildList
					};
		} // if문 끝
		
		console.log("ChildList : ", ChildList);
		/* 		console.log("LineFormList : ", LineFormList); */
		var NowItemNumber = parseInt($('.DocNumber').val(), 10);
		console.log("현재 항번 : " + NowItemNumber);
		if(Minus > 0){
			var editNum = Add - Minus + 1;
			console.log("수정된 번호 : " + editNum);
		}
		
		Add++;
		console.log("버튼이 클릭 횟수 : " + Add);
		
		$.ajax({
			url: '${contextPath}/Slip/AjaxSet/KidLineTemSave.jsp',
			type: 'POST',
			data: JSON.stringify(Combination),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(data){
				var DelBtn = "삭제";
				var NewRow = "<tr class='STitel'>";
				var RowNum = $('.SlipTable tr').length;
				
				NewRow += "<td>" + RowNum + "</td>";
				NewRow += "<td><input type='Button' name='DeleteBtn' value='" + DelBtn + "'></td>";
				
				var List = ["AccSubject", "AccSubjectDes", "DeCre", "DealPrice", "money-code", "ledPrice", "ledcurrency","Rate", "Deptd", 
					"Order", "AdminAlloc","UserDepart", "Date", "SlipNo", "DocNumber", "Line"];
				
				$.each(List, function(index, key){
					if(key === "Rate"){
						NewRow += "<td>" + "1" + "</td>";
					} else if(key === "Order"){
						NewRow += "<td>" + "" + "</td>";
					} else if(key === "Line"){
						NewRow += "<td><a href=\"javascript:void(0)\" onClick=\"UserBAInput('LineInfo')\" data-docnumber=\"" + ("0000" + RowNum).slice(-4) + "\" data-slipno=\"" + data.SlipNo + "\">&#128172;</a></td>";
					} else {
						NewRow += "<td>" + data[key] + "</td>";
					}
				});
				NewRow += "</tr>";
				$(".SlipTable").append(NewRow);
				/* <input class="DocNumber child lineform" id="DocNumber" name="DocNumber" readonly > */
				console.log("입력한 항번 : " + PageNumber);
				$('.DocNumber').val(("0000" + (PageNumber + 1)).slice(-4));
				console.log("다음에 입력할 항번 : " + ("0000" + (PageNumber + 1)).slice(-4));
			}
		}); //  임시저장테이블에 저장할 항목들을 진짜로 임시저장테이블로 옮김
		const resetChild = [$('.AccSubject'), $('.AccSubjectDes'), $('.money-code'), $('.DealPrice'), $('.DealPrice'), $('.ledPrice'), $('.Deptd'), $('.DeptdDes'), $('.AdminAlloc'), $('.LineBriefs')];

	    resetChild.forEach(input => input.val(''));

	    // $('.lineform')에 해당하는 모든 input 요소를 선택하여 값을 초기화합니다.
	    $('.SlipOptionTable02').find('.lineform').each(function() {
	        $(this).val('');
	    });
	    $.ajax({
	    	url : '${contextPath}/Slip/AjaxSet/Calculate.jsp',
	    	type: 'POST',
	    	success: function(response) {
	    		var data = JSON.parse(response);
            	$('input[name="DebitTotal"]').val($.trim(data.DeTotal));
            	$('input[name="CreditTotal"]').val($.trim(data.CreTotal));
            },
            error: function() {
                alert('Failed to retrieve exchange rate');
            }
	    });
	}); // img[name='Down'] 클릭 끝
	
	$('.SlipTable').on('click', "input[name='DeleteBtn']", function(){
			Minus++;
			console.log("삭제한 횟수 : " + Minus);
			var Row = $(this).closest('tr'); // 클릭된 삭제 버튼이 속한 행 선택
		    var DelDoc = Row.find('td:eq(15)').text(); // CRE20240621S0001
		    var DelDocNum = Row.find('td:eq(16)').text(); // CRE20240621S0001의 ItemNumber, 0001...
		    var DelItemNum = Row.find('td:eq(0)').text(); // 항번
		    var GLAccount = Row.find('td:eq(2)').text(); // 
		    
		    var CreditTotal = $('.CreditTotal').val();
		    var DebitTotal = $('.DebitTotal').val();
		    
		    console.log("삭제한 것 확인용 콘솔 : " + CreditTotal);
		    console.log("삭제한 것 확인용 콘솔 : " + DebitTotal);
	    
		
		    DeletedItems.push({DocCode: DelDoc, DocCodeNumber: DelDocNum, DelConut: Minus, GLAccountCode : GLAccount});
		    console.log("삭제할 것들 : ", DeletedItems);
		    Row.remove();
		    RowNum--;
		
		    $.ajax({
		    	url : '${contextPath}/Slip/AjaxSet/MinusCalcu.jsp',
		    	type: 'POST',
		    	data: {DocCode: DelDoc, DocCodeNumber: DelDocNum, Cre: CreditTotal, De: DebitTotal},
		    	success: function(response) {
		    		var data = JSON.parse(response);
	            	$('input[name="DebitTotal"]').val($.trim(data.DeTotal));
	            	$('input[name="CreditTotal"]').val($.trim(data.CreTotal));
	            },
	            error: function() {
	                alert('Failed to retrieve exchange rate');
	            }
		    });
		    
		    $.ajax({
		        url: '${contextPath}/Slip/AjaxSet/DeleteTemDoc.jsp',
		        type: 'POST',
		        data: {'List': JSON.stringify(DeletedItems)},
		        contentType: 'application/x-www-form-urlencoded; charset=utf-8',
		        dataType: 'json',
		        async: false,
		        success: function(List) {
		            // 서버에서 응답이 온 후의 처리
		            if (List.result) {
		                console.log('삭제 성공');
		                DeletedItems = [];
		            } else {
		                console.log('삭제 실패: ' + List.message);
		            }
		        },
		        error: function(jqXHR, textStatus, errorThrown) {
		            console.log("AJAX error: " + textStatus + ' : ' + errorThrown);
		        }
		    });
	    
		    $(".SlipTable tr").each(function(index){
		    	if(index != 0){
		    		$(this).find('td:eq(0)').text(index);
	                $(this).find('td:eq(16)').text(("0000" + index).slice(-4));
	                $(this).find('td a').attr("data-docnumber", ("0000" + index).slice(-4));
		    	}
		    });
		    var ChangeDocNumber = ("0000" + (Add - Minus + 1)).slice(-4);
		    console.log("확인용 로그 : " + ChangeDocNumber);
		    $(".DocNumber").val(ChangeDocNumber);
	});
});
</script>
<script>
	function CreDeCompare(event){
		
		event.preventDefault();
		
		var TotalCre = document.getElementById("CreditTotal").value;
		var TotalDe = document.getElementById("DebitTotal").value;
		var SlipDocCode = $('.SlipNo').val();
		var InPuter = $('.User').val();
		var InPuterCom = $('.UserDepart').val();
		var InPuterBA = $('.UserBA').val();
		var InPuterCoCt = $('.UserCoCT').val();
		var EntryDate = $('.ConsumeDate').val();
		
		console.log("기표일자 : " + EntryDate);
		
		if(TotalCre !== TotalDe){
			alert("합계가 맞지 않습니다.");
			return false;
		} else if(TotalCre === "0" && TotalDe === "0"){
			alert("대변과 차변을 입력해주세요.");
			return false;
		} else{
			$.ajax({
		    	url : 'CreateSlip_Ok.jsp',
		    	type: 'POST',
		    	data: {SlipCode : SlipDocCode, User : InPuter, ComCode : InPuterCom, BA : InPuterBA, COCT : InPuterCoCt, EntryDay : EntryDate},
		    	success: function(response) {
		    		location.reload();
	            },
	            error: function() {
	                alert('Failed to retrieve exchange rate');
	            }
		    });
			if(!confirm("결재경로와 품의를 신청하시겠습니까?")){
				return false;
			} else{
				alert("페이지를 이동합니다.");
				window.location = "${contextPath}/UnapprovalSlip/UntSlip.jsp";
			}
			return true;
		} 
	}

	function PayRequest(event, inputFieldId){
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
		
	    var HeadList = {};
	    var briefsValid = true; 
	    
		$('.Head').each(function(){
			var name = $(this).attr("name");
			var value = $(this).val();
			HeadList[name] = value;
			if(name === "briefs" && value === ""){
				briefsValid = false;
				return false;
			}
		});
	    console.log("HeadList: ", HeadList);
	    
		var queryString = Object.keys(HeadList).map(function(key) {
	        return encodeURIComponent(key) + '=' + encodeURIComponent(HeadList[key]);
	    }).join('&');
		/* 
		Object.keys(HeadList): HeadList 객체의 키-값 쌍을 URL 쿼리 문자열 형식으로 변환하는 과정
		.map(function(key) {...}): HeadList 객체의 모든 키를 배열 형태로 반환, 예를 들어, HeadList가 {a: 1, b: 2}라면, Object.keys(HeadList)는 ['a', 'b']가 됩니다.
		.map(function(key) {...}): map 함수는 배열의 각 요소에 대해 주어진 함수를 호출하여 새로운 배열을 생성
		function(key) { return encodeURIComponent(key) + '=' + encodeURIComponent(HeadList[key]); }:
			key=value 형식의 문자열을 반환, encodeURIComponent 함수는 URL에 안전하게 포함될 수 있도록 문자열을 인코딩,
			예를 들어, 키가 name이고 값이 John Doe라면, 이 함수는 name=John%20Doe를 반환합니다 (%20은 공백 문자).
		.join('&'):	map 함수로 생성된 배열의 각 요소를 '&' 문자열로 연결하여 하나의 문자열로 만듭니다. 예를 들어, ['a=1', 'b=2']는 'a=1&b=2'가 됩니다.
		*/
		
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
		
		var TotalCre = document.getElementById("CreditTotal").value;
		var TotalDe = document.getElementById("DebitTotal").value;
		var DocCodeNumber = $('.SlipNo').val();
		
		if((TotalCre !== TotalDe) ){
			alert("합계가 맞지 않습니다.");
			return false;
		} else{
			if(inputFieldId === "SelPayPath"){ // 결재경로
		    	window.open(
		                "${contextPath}/Slip/Info/DecPayPath.jsp?" + queryString, 
		                "테스트", 
		                "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
		            );
		     } else if(!briefsValid){
		    	 alert("적요를 입력해주세요.");
		    	 return false;
		     } else if(inputFieldId === "ApprovalPage" && briefsValid){ // 품의 상신
		    	 //1. 입력하려는 데이터의 결제경로가 등록되어 있는지 확인
		    	    $.ajax({
		    	        url: '${contextPath}/Slip/Info/WFCheck.jsp',
		    	        type: 'POST',
		    	        data: JSON.stringify(HeadList),
		    	        contentType: 'application/json; charset=utf-8',
		    	        dataType: 'json', // 수정: datatype -> dataType
		    	        success: function(response){
		    	            if(response.result === "Success"){
		    	            	popupWidth = 750;
		    	        	    popupHeight = 400;
		    	                console.log("Success");
		    	                // 2. 결제경로가 등럭되어 있으면 바로 품의 상신 진행
		    	                $.ajax({
		    	                    url: '${contextPath}/Slip/Info/ApprovalProcess.jsp',
		    	                    type: 'POST',
		    	                    data: JSON.stringify(HeadList),
		    	                    contentType: 'application/json; charset=utf-8',
		    	                    dataType: 'json', // 수정: datatype -> dataType
		    	                    success: function(response) {
		    	                        if (response.status === 'success') {
		    	                            console.log("ApprovalProcess Success");
		    	                            window.open(
		    	            		                "${contextPath}/Slip/Info/OpinionWrite.jsp?SlipCode=" + DocCodeNumber, 
		    	            		                "테스트", 
		    	            		                "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
		    	            		            );
		    	                            
		    	                            var timer = setInterval(function() {
		    	                                if (popup.closed) {
		    	                                    clearInterval(timer);
		    	                                    location.reload();
		    	                                }
		    	                            }, 500);
		    	                        } else {
		    	                            console.log("ApprovalProcess Error:", response.message);
		    	                        }
		    	                    },
		    	                    error: function(jqXHR, textStatus, errorThrown) {
		    	                        console.log("ApprovalProcess Error:", textStatus, errorThrown);
		    	                    }
		    	                });

		    	            } else{
		    	            	// 2-1. 결재경로가 등록안돼있으면 등록하라고 요청
		    	            	console.log("fail");
		    	                alert("결재경로를 등록해주세요.");
		    	                window.open(
		    	                    "${contextPath}/Slip/Info/DecPayPath.jsp?" + queryString, 
		    	                    "테스트", 
		    	                    "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
		    	                );
		    	            } // if(response.result === "Success"){...}의 끝
		    	        },
		    	        error: function(jqXHR, textStatus, errorThrown) { // 수정: 오류 핸들러 추가
		    	            console.log("WFCheck Error:", textStatus, errorThrown);
		    	        }
		    	    });
		    	}
			return true;
		}
	}
</script>
</head>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
		<div class="Slip">
		<div class="SlipHeader">
			<div class="title">일반 전표 메인</div>
			<div class="Main-Colume">
				<label>전표유형 : </label>
				<input class="SlipType" id="SlipType" name="SlipType" value="FIG" onClick="UserBAInput('SlipTypeSel')" readonly placeholder="선택">
				<input class="SlipTypeDes" id="SlipTypeDes" name="SlipTypeDes" hidden>
			</div>
			<div class="Main-Colume">
				<label>전표번호 : </label>
				<input class="SlipNo child lineform Head" id="SlipNo" name="SlipNo" readonly>
			</div>
			<div class="Main-Colume">
				<label>전표 입력자 : </label>
				<input class="User child Head" id="User" name="User" value="<%=User_Id%>" readonly>
			</div>
			<div class="Main-Colume">
				<label>회사 : </label>
				<input type="text" class="UserDepart child Head" id="UserDepart" name="UserDepart" value="<%=User_Depart%>" readonly>
			</div>
			<div class="Main-Colume">
				<label>전표입력 BA : </label>
				<input type="text" class="Head UserBA" name="UserBizArea" id="UserBizArea" readonly>
			</div>
			<div class="Main-Colume">
				<label>전표 입력 일자 : </label>
				<input class="ToDate" id="ToDate" name="ToDate" value="<%=todayDate%>" readonly>							
			</div>
			<div class="Main-Colume">
				<label>기표일자 : </label>
				<input type="date" class="ConsumeDate child Head" id="Date" name="Date">
			</div>
			<div class="Main-Colume">		
				<label>전표 입력 부서 : </label>
				<input type="text" class="Head UserCoCT" id="TargetDepartCd" name="TargetDepartCd" readonly>
				<input type="text" id="TargetDepartDes" name="TargetDepartDes" readonly>				
			</div>
			<div class="Main-Colume">
				<label>적요 : </label>
				<input type="text" class="child Head" id="briefs" name="briefs">				
			</div>
		</div>
		
		<div class="SlipBody">
			<div class="title">일반 전표 서브</div>
			<div class="SlipBodyDetail">	
				<div class="BodyChild01">
					<div class="Main-Colume">
						<label>항번 : </label>
						<input class="DocNumber child lineform" id="DocNumber" name="DocNumber" readonly >
					</div>
						</table>
					<div class="Main-Colume">
						<label>계정과목 : </label>
						<input class="AccSubject child" id="AccSubject" name="AccSubject" onClick="UserBAInput('AccSubjectSelect')" placeholder="선택" readonly></a>
						<input class="AccSubjectDes child" id="AccSubjectDes" name="AccSubjectDes" readonly>
					</div>
					<div class="Main-Colume">
						<label>Debit/Credit : </label>
						<input type="checkbox" class="DeCre child" name="DeCre" value="C" onclick="checkOnlyOne(this)" checked>C 대변(Credit)
						<input type="checkbox" class="DeCre child" name="DeCre" value="D" onclick="checkOnlyOne(this)">D 차변(Debit)
					<script type="text/javascript">
						function checkOnlyOne(element) {
						const checkboxes = document.getElementsByName("DeCre");
						checkboxes.forEach((cb) => {
							cb.checked = false;
						});
						element.checked = true;
						}
						function reset(){
							$('.SlipOptionTable02 input').val("");
						}
						function checkInputs(){
							const SelectedValue = $('input[name="DeCre"]:checked').val();
							const TypeValue = $('input[name="SlipType"]').val();
							const SubValue = $('input[name="AccSubject"]').val();
							
							if (SelectedValue === "C" /* && TypeValue === "CRE" */ && (SubValue === "2003500" || SubValue === "2003510" || SubValue === "2003520")) {
								$('.SlipOptionTable02 input').prop('disabled', false);
							} else {
								$('.SlipOptionTable02 input').prop('disabled', true);
								}
						}
						$(document).ready(function(){
							$('.DeCre').on('change', function() {
								checkOnlyOne(this);
								reset();
								checkInputs();
							});
							$('#AccSubject').on('change', function() {
								 checkInputs();
							});
							checkInputs();
						});
					</script>		
					</div>
					<div class="Main-Colume">
						<label>거래 통화 : </label>
						<input class="money-code child" id="money-code" name="money-code" onClick="UserBAInput('BizMoneyCode')" placeholder="선택" readonly></a>
						<label>장부 통화 : </label>
						<input type="text" class="ledcurrency child" id="ledcurrency" name="ledcurrency" readonly>
					</div>			
					<div class="Main-Colume">
						<label>거래 금액 : </label>
						<input type="text" class="DealPrice child" id="DealPrice" name="DealPrice">
						<label>장부 금액 : </label>
						<input type="text" class="ledPrice child" id="ledPrice" name="ledPrice" readonly>	
					</div>
					<div class="Main-Colume">
						<label>관리/귀속 부서 : </label>
						<input class="Deptd child" id="Deptd" name="Deptd" placeholder="선택" readonly></a>
						<input class="DeptdDes child" id="DeptdDes" name="DeptdDes" readonly>
					</div>
					<div class="Main-Colume">				
						<label>관리/귀속 BA : </label>
						<input class="AdminAlloc child" id="AdminAlloc" name="AdminAlloc" placeholder="선택" readonly>
					</div>
					<div class="Main-Colume">
						<label>라인 적요 : </label>
						<input class="LineBriefs child" id="LineBriefs" name="LineBriefs">
					</div>
				</div>	
				<div class="BodyChild02">
					<table class="SlipOptionTable01">
						<thead>
							<th id="No1">항번</th><th id="No2_2">관리항목명</th><th id="No3">관리항목 값</th>
						</thead>
					</table>
					<table class="SlipOptionTable02">
						<tr name="CardNum" value="CardNum">
					        <td id="No1" name="CardNumPort">1</td><td id="No2" name="CardNumName">신용카드번호</td><td id="No3"><input name="CardNumVal" class="lineform"></td>
					    </tr>
					    <tr name="ApprovalDate" value="ApprovalDate">
					        <td id="No1" name="ApprovalDatePort">2</td><td id="No2" name="ApprovalDateName">승인일자</td><td id="No3"><input name="ApprovalDateVal" class="lineform"></td>
					    </tr>
					    <tr name="ApprovalNum" value="ApprovalNum">
					        <td id="No1" name="ApprovalNumPort">3</td><td id="No2" name="ApprovalNumName">승인번호</td><td id="No3"><input name="ApprovalNumVal" class="lineform"></td>
					    </tr>
					    <tr name="UseNation" value="UseNation">
					        <td id="No1" name="UseNationPort">4</td><td id="No2" name="UseNationName">사용국가</td><td id="No3"><input name="UseNationVal" class="lineform"></td>
					    </tr>
					    <tr name="TaxIdentiNum" value="TaxIdentiNum">
					        <td id="No1" name="TaxIdentiNumPort">5</td><td id="No2" name="TaxIdentiNumName">사업자등록번호</td><td id="No3"><input name="TaxIdentiNumVal" class="lineform"></td>
					    </tr>
					    <tr name="UsingPlaceAdd" value=UsingPlaceAdd>
					        <td id="No1" name="UsingPlaceAddPort">6</td><td id="No2" name="UsingPlaceAddName">사용처주소</td><td id="No3"><input name="UsingPlaceAddVal" class="lineform"></td>
					    </tr>
					</table>
				</div>
			</div>
		</div>
		
		</div>
		<div class="FuncArea">
			<img id="DownBtn" name="Down" src="../img/Dvector.png" alt="">
			<input class="input-btn" id="btn" type="submit" value="저장" onclick="CreDeCompare(event)">
			<button class="PayPath" id="PayPath" onclick="PayRequest(event, 'SelPayPath')">결재경로</button>
			<button class="Approval" id="Approval" onclick="PayRequest(event, 'ApprovalPage')">품의상신</button>
		</div>

		<div class="SlipFoot">
			<table class="SlipTable">
				<th>항번</th><th>삭제</th><th>G/L Account</th><th>Account Description</th><th>Debit/Credit</th><th>Transaction Amount</th><th>Trans Curr</th><br>
				<th>Local Amount</th><th>Local Curr</th><th>Exchange Rate</th><th>Cost Center</th><th>Order</th><th>Biz Area</th><th>Company</th><br>
				<th>Posting Date</th><th>Document Number</th><th>Item Number</th><th>관리항목</th>
			</table>
		</div>
		<div class="TotalPrice">
			<div class="DebCre-Colume">
				<label>차변(Debit) 합계 Local Amount :</label>
				<input class="DebitTotal" id="DebitTotal" name="DebitTotal" value="0" readonly>
			</div>
			<div class="DebCre-Colume">
				<label>대변(Credit) 합계 Local Amount :</label>
				<input class="CreditTotal" id="CreditTotal" name="CreditTotal" value="0" readonly> 
			</div> 
		</div>
</body>
</html>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ page import="java.sql.*" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Tax Area 등록</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script>
$(document).ready(function() {
	$('.Com-code').change(function() {
		var selectedValue = $(this).val();
		$.ajax({
			type: 'post',
			url: 'Com-Na-Output.jsp',
			data: { Company_Code : selectedValue }, // 수정된 부분
			success: function(response) {
				if (response !== 'error') {
		        var dataArr = response.split("|");
		        var NaCodeInput = document.getElementById("Na-Code");
		        var NaDesInput = document.getElementById("na-Des");

		        NaCodeInput.value = dataArr[0];
		        NaDesInput.value = dataArr[1];
		                    
				} else {
					console.error('An error occurred while retrieving the nationality.');
				}
			}
		});
	});
	function MainSubFunc(Value){
		var ComValue = $('.Com-code').val();
		var taxAreaValue = $('.TaxArea_MS:checked').val();
		if(taxAreaValue === "1"){
			console.log(taxAreaValue);
			$('input[name="main-TA-Code"]').val(Value);
			$('#main-tax-area-code-row button').prop('disabled', false);
		} else if(taxAreaValue === "2"){
			console.log(taxAreaValue);
			$.ajax({
				type: 'POST',
				url: 'FindMainTax.jsp',
				data: { Company_Code: ComValue },
				success: function(response) {
					console.log("FindMainTax Response: ", response);
					if (response !== 'error' && response !== null && response.trim() !== '') {
						$('input[name="main-TA-Code"]').val($.trim(response));
						$('#main-tax-area-code-row button').prop('disabled', true);
					} else {
						alert("Main Tax Area를 등록해주세요.");
						$('input[name="main-TA-Code"]').val(Value);
		                $('input.TaxArea_MS[value="1"]').prop('checked', true);
					}
				},
				error: function(xhr, status, error) {
					console.error("Error: ", error);
					alert("서버 요청에 실패했습니다. 다시 시도해주세요.");
					}
				});
		}
	}
	
	$('.TAC').on('input', function() {
		var MainValue = $(this).val();
		MainSubFunc(MainValue);
	});
	  
	$('.TaxArea_MS').change(function() {
		var MainValue = $('.TAC').val();
		MainSubFunc(MainValue);
	});
});

	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	            var addr = ''; // 주소 변수
	            var extraAddr = ''; // 참고항목 변수
	
	            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                addr = data.roadAddress;
	            } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                addr = data.jibunAddress;
	            }
	
	            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	            if(data.userSelectedType === 'R'){
	                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있고, 공동주택일 경우 추가한다.
	                if(data.buildingName !== '' && data.apartment === 'Y'){
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                if(extraAddr !== ''){
	                    extraAddr = ' (' + extraAddr + ')';
	                }
	                // 조합된 참고항목을 해당 필드에 넣는다.
	                document.getElementById("extraAddress").value = extraAddr;
	            
	            } else {
	                document.getElementById("extraAddress").value = '';
	            }
	
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
	            document.getElementById('postcode').value = data.zonecode;
	            document.getElementById("address").value = addr;
	            // 커서를 상세주소 필드로 이동한다.
	            document.getElementById("detailAddress").focus();
	        }
	    }).open();
	};

	function comfirm(){
		var TAC = document.Tax-RegistForm.TAC.value;
		var Des = document.Tax-RegistForm.Des.value;
		
		var Comcode = document.Tax-RegistForm.Com-code.value;
		var NaCode = document.Tax-RegistForm.Na-Code.value;
		
		var Poscode = document.Tax-RegistForm.AddrCode.value;
		
		var Addr1 = document.Tax-RegistForm.Addr.value;
		var Addr2 = document.Tax-RegistForm.AddrDetail.value;
		
		var Select_MS = document.Tax-RegistForm.Select_MS.value;
		var mainTACode = document.Tax-RegistForm.main-TA-Code.value;
		
		var UseUseless = document.Tax-RegistForm.Use-Useless.value;
	    
	    if(!TAC || !Des || !Comcode || !NaCode || !Poscode || !Addr1 || !Addr2 || !SelectMS || !mainTACode || !UseUseless){
	    	alert('모든 항목을 입력해주세요.');
	    	return false;
	    } else{
	    	return true;
	    }
	}
	function InfoSearch(field){
		event.preventDefault();
		
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
	    
	    switch(field){
	    case "ComSearch":
	    	window.open("${contextPath}/Information/ComSearch.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "TaxAreaCheck":
	    	var TaxCode = $('.TAC').val();
	    	var ComCode = $('.Com-code').val();
	    	if(TaxCode == '' || ComCode == ''){
	    		alert('사업장등록번호와 기업코드를 입력해주세요.')
	    		break;
	    	}
	    	$.ajax({
	    		type: "POST",
	    		url: '${contextPath}/Information/AjaxSet/Deduplication.jsp',
	    		data: {S_ComCode : ComCode},
	    		success: function(response){
	    			if(response.trim() === 'No'){
	    				alert('해당 기업의 Main 사업장등록번호는 이미 등록됐습니다. \n 다시 입력해주세요.');
	    				//$('input[name="TAC"]').val('');
	    				$('input[name="main-TA-Code"]').val('');
	    			} else{
	    				alert('사용 가능합니다.');
	    			}
	    		}
	    	});
	    	break;
	    }
	};
</script>
</head>
<body>
	<h1>Tax Area 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="Tax-RegistForm" name="Tax-RegistForm" action="Tax-Regist_Ok.jsp" method="post" onSubmit="return comfirm()">
			<div class="tax-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Tax Area Code : </th>
							<td class="input-info">
								<input type="text" class="TAC" name="TAC" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td>
								<input type="text" name="Des" size="41">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="tax-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input_info">
								<input type="text" class="Com-code" name="Com-code" onclick="InfoSearch('ComSearch')" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Nationality : </th>
							<td class="input-info">
								<input type="text" class="Nationality-Code" name="Na-Code" id="Na-Code" size="7" readonly>
								<input type="text" class="Nationality-Des" name="Na-Des" id="na-Des" size="41" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Postal Code : </th>
							<td class="input-info">
								<input type="text" class="AddrCode NewAddr" name="AddrCode" id="postcode" placeholder="우편번호" readonly>
						        <input type="button" onclick="execDaumPostcode()" value="우편번호 찾기">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Address : </th>
							<td class="input-info">
						        <div>
						            <input type="text" class="Addr NewAddr" name="Addr" id="address" placeholder="주소" readonly>
						        </div>
						        <div>
						            <input type="text" class="AddrDetail NewAddr" name="AddrDetail" id="detailAddress" placeholder="상세주소" required>
						        </div>
						        <div>
						            <input type="text" class="AddrRefer NewAddr" id="extraAddress" placeholder="참고항목" hidden>
						        </div>
							</td>
						</tr>											
						
						<tr class="spacer-row"></tr>
							
						<tr><th class="info">Main Tax Area :</th>
						    <td class="input-info">
						        <input type="radio" class="TaxArea_MS" name="Select_MS" value="1" checked> Main Tax Area
						        <span class="spacing"></span>
						        <input type="radio" class="TaxArea_MS" name="Select_MS" value="2"> Sub Tax Area
						    </td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr id="main-tax-area-code-row">
							<th class="info">Main Tax Area Code : </th>
							<td class="input-info">
								<input class="main-TA-Code" id="main-TA-Code" name="main-TA-Code" size="10" readonly>
								<button class="Deduplication" name="Deduplication" onclick="InfoSearch('TaxAreaCheck')">중복검사</button>
							</td>												
						</tr>					
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">사용 여부 : </th>
							<td class="input-info"> 
								<input type="radio" class="TA-InputUse" name="Use-Useless" value="1" checked>사용
								<span class="spacing"></span>
								<input type="radio" class="TA-InputUse" name="Use-Useless" value="2">미사용
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
	</center>
</body>
</html>
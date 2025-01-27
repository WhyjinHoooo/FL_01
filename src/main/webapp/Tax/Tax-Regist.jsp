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
	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            var addr = '';
	            var extraAddr = '';
	            if (data.userSelectedType === 'R') {
	                addr = data.roadAddress;
	            } else {
	                addr = data.jibunAddress;
	            }
	            if(data.userSelectedType === 'R'){
	                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                    extraAddr += data.bname;
	                }
	                if(data.buildingName !== '' && data.apartment === 'Y'){
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                if(extraAddr !== ''){
	                    extraAddr = ' (' + extraAddr + ')';
	                }
	                document.getElementById("extraAddress").value = extraAddr;
	            
	            } else {
	                document.getElementById("extraAddress").value = '';
	            }
	            document.getElementById('postcode').value = data.zonecode;
	            document.getElementById("address").value = addr;
	            document.getElementById("detailAddress").focus();
	        }
	    }).open();
	};
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
	    case "ComSearch":
	    	window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
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
	    				$('input[name="main-TA-Code"]').val('');
	    			} else{
	    				alert('사용 가능합니다.');
	    			}
	    		}
	    	});
	    	break;
	    }
	};
$(document).ready(function() {
	function MainSubFunc(Value){
		var ComValue = $('.ComCode').val();
		var taxAreaValue = $('.TaxArea_MS:checked').val();
		console.log('1.taxAreaValue : ' + taxAreaValue);
		if(taxAreaValue === "1"){
			$.ajax({
				type: 'POST',
				url: 'FindMainTax.jsp',
				data: { Company_Code: ComValue },
				dataType: 'text',
				success: function(response) {
					console.log("FindMainTax Response: ", response.trim());
					if (response !== 'error' && response !== null && response.trim() !== '') {
						alert('해당 기업에 대한 Main Tax Area는 등록됐었습니다. \n 다시 입력해주세요.');
						$('.TAC').val('');
						$('.TAC_Des').val('');
						$('.ComCode').val('');
						$('.ComCode').attr('placeholder', 'SELECT');
					} else {
						$('input[name="main-TA-Code"]').val(Value);
						$('#main-tax-area-code-row button').prop('disabled', true);
						$.ajax({
							type: 'post',
							url: 'Com-Na-Output.jsp',
							data: { Company_Code : ComValue }, // 수정된 부분
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
					}
				},
				error: function(xhr, status, error) {
					console.error("Error: ", error);
					alert("서버 요청에 실패했습니다. 다시 시도해주세요.");
				}
			});
		} else if(taxAreaValue === "2"){
			$.ajax({
				type: 'POST',
				url: 'FindMainTax.jsp',
				data: { Company_Code: ComValue },
				dataType: 'text',
				success: function(response) {
					console.log("FindMainTax Response: ", response.trim());
					if (response !== 'error' && response !== null && response.trim() !== '') {
						$('input[name="main-TA-Code"]').val($.trim(response));
						$('#main-tax-area-code-row button').prop('disabled', true);
						$.ajax({
							type: 'post',
							url: 'Com-Na-Output.jsp',
							data: { Company_Code : ComValue }, // 수정된 부분
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
					} else {
						alert("Main Tax Area를 등록해주세요.");
						$('.ComCode').val('');
						$('.ComCode').attr('placeholder', 'SELECT');
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
	$('.ComCode').change(function() {
		var MainValue = $('.TAC').val();
		console.log('MainValue : ' + MainValue);
		MainSubFunc(MainValue);
	});
	var ChkList = {};
    $('.Info-input-btn').click(function(){
    	console.log('asd');
    	event.preventDefault();
    	$('.KeyInfo').each(function(){
			var Name = $(this).attr('name');
			var Value;
			if ($(this).attr('type') === 'radio') {
		        Value = $('input[name="' + Name + '"]:checked').val();
		    } else if(Name === 'Na-Code'){
		    	Value = $(this).val().trim();
		    }else {
		        Value = $(this).val();
		    }			
			ChkList[Name] = Value;
		})
		var pass = true;
		$.each(ChkList,function(key, value){
	    	if(value == null || value === ''){
	    		console.log('value : ' + value);
	    		pass = false;
	    		return false;
	    	}
	    })
		console.log(ChkList);
	    if(!pass){
	    	alert('모든 항목을 입력해주세요.');
	    }else{
	    	$.ajax({
				url:'${contextPath}/Tax/Tax-Regist_Ok.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
					if(data.status === 'Success'){
						alert('과세항목이 등록되었습니다.');
						$('.KeyInfo').each(function(){
							var name = $(this).attr('name');
							if(name === 'TAC' || name === 'Des'){
								$(this).val('');
							}else if(name === 'AddrCode'){
								$(this).val('');
								$(this).attr('placeholder', '우편번호');
							} else if(name === 'Addr'){
								$(this).val('');
								$(this).attr('placeholder', '주소');
							} else if(name === 'AddrDetail'){
								$(this).val('');
								$(this).attr('placeholder', '상세주소');
							} else if(name === 'Use-Useless' || name === 'Select_MS'){
								$('input[type="radio"][value="1"]').prop('checked', true);
							} else if(name === "ComCode"){
								$(this).val('');
							    $(this).attr('placeholder', 'SELECT');
							} else{
								$(this).val('');
								$('.Nationality-Des').val('');
							}
						})
					}else{
						alert('다시 입력해주세요.');
					}
				}
			});
		}
	})
});
</script>
</head>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
		<div class="tax-main-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Tax Area Code : </th>
						<td class="input-info">
							<input type="text" class="TAC KeyInfo" name="TAC" size="10">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Description : </th>
						<td>
							<input type="text" class="TAC_Des KeyInfo" name="Des" size="41">
						</td>
					</tr>											
					
					<tr class="spacer-row"></tr>
						
					<tr><th class="info">Tax Area :</th>
					    <td class="input-info">
					        <input type="radio" class="TaxArea_MS KeyInfo" name="Select_MS" value="1" checked> Main
					        <span class="spacing"></span>
					        <input type="radio" class="TaxArea_MS KeyInfo" name="Select_MS" value="2"> Sub
					    </td>
					</tr>
				</table>
			</div>
		</div>
		
		<button class="Info-input-btn" id="btn">Insert</button>
		
		<div class="tax-sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Company Code : </th>
						<td class="input_info">
							<input type="text" class="ComCode KeyInfo" name="ComCode" onclick="InfoSearch('ComSearch')" placeholder="SELECT" readonly>
							<input class="Com_Name" hidden>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Nationality : </th>
						<td class="input-info">
							<input type="text" class="Nationality-Code KeyInfo" name="Na-Code" id="Na-Code" readonly>
							<input type="text" class="Nationality-Des" name="Na-Des" id="na-Des" readonly>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Postal Code : </th>
						<td class="input-info">
							<input type="text" class="AddrCode NewAddr KeyInfo" name="AddrCode" id="postcode" placeholder="우편번호" readonly>
					        <input type="button" onclick="execDaumPostcode()" value="우편번호 찾기">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Address : </th>
						<td class="input-info">
					        <div>
					            <input type="text" class="Addr NewAddr KeyInfo" name="Addr" id="address" placeholder="주소" readonly>
					        </div>
					        <div>
					            <input type="text" class="AddrDetail NewAddr KeyInfo" name="AddrDetail" id="detailAddress" placeholder="상세주소">
					        </div>
					        <div>
					            <input type="text" class="AddrRefer NewAddr" id="extraAddress" placeholder="참고항목" hidden>
					        </div>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr id="main-tax-area-code-row">
						<th class="info">Main Tax Area Code : </th>
						<td class="input-info">
							<input class="main-TA-Code KeyInfo" id="main-TA-Code" name="main-TA-Code" size="10" readonly>
							<button class="Deduplication" name="Deduplication" onclick="InfoSearch('TaxAreaCheck')">중복검사</button>
						</td>												
					</tr>					
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">사용 여부 : </th>
						<td class="input-info"> 
							<input type="radio" class="TA-InputUse KeyInfo" name="Use-Useless" value="1" checked>사용
							<span class="spacing"></span>
							<input type="radio" class="TA-InputUse KeyInfo" name="Use-Useless" value="2">미사용
						</td>
					</tr>
				</table>
			</div>
		</div>
	</center>
	<footer>
		<img id="logo" name="Logo" src="${contextPath}/img/White_Logo.png" alt="">
	</footer>	
</body>
</html>
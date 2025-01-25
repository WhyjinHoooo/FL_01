<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="../css/style.css?after">
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
}
function InfoSearch(field){
	var popupWidth = 500;
    var popupHeight = 600;
    var ComCode = $('.ComCode').val();

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
    	window.open("${contextPath}/Information/CompanySerach.jsp", "test01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "MoneySearch":
    	window.open("${contextPath}/Information/MoneySearch.jsp", "test02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "LanSearch":
	    window.open("${contextPath}/Information/LanSearch.jsp", "test03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "TACSearch":
	    window.open("${contextPath}/Information/TACSearch.jsp?CoCd=" + ComCode, "test04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "BAGSearch":
	    window.open("${contextPath}/Information/BAGSearch.jsp?CoCd=" + ComCode, "test05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    }
}
$(document).ready(function(){
    $('.ComCode').change(function(){
        var CompanyCode = $(this).val();
        
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
	    $.ajax({
            type: 'post',
            url: '${contextPath}/Tax/Com-Na-Output.jsp',
            data: { Company_Code : CompanyCode },
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
	    window.open("${contextPath}/Information/TACSearch.jsp?CoCd=" + CompanyCode, "Pop01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    });
    var ChkList = {};
    $('.Info-input-btn').click(function(){
    	event.preventDefault();
    	$('.KeyInfo').each(function(){
			var Name = $(this).attr('name');
			var Value;
			if ($(this).attr('type') === 'radio') {
		        Value = $('input[name="' + Name + '"]:checked').val();
		    } else {
		        Value = $(this).val();
		    }			
			ChkList[Name] = Value;
		})
		var pass = true;
		$.each(ChkList,function(key, value){
	    	if(value == null || value === ''){
	    		pass = false;
	    		return false;
	    	}
	    })
	    if(!pass){
	    	alert('모든 항목을 입력해주세요.');
	    }else{
	    	$.ajax({
				url:'${contextPath}/BusinessArea/BusinessArea_Regist_Ok.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
					if(data.status === 'Success'){
						alert('회사가 등록되었습니다.');
						$('.KeyInfo').each(function(){
							var name = $(this).attr('name');
							if(name === 'BAC' || name === 'Des'){
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
							} else if(name === 'Use-Useless'){
								$('input[type="radio"][value="true"]').prop('checked', true);
							} else{
								$(this).val('');
							    $(this).attr('placeholder', 'SELECT');
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
<title>Business Area 등록</title>
</head>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
			<div class="ba-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Business Area Code : </th>
							<td class="input-info">
								<input type="text" class="KeyInfo" name="BAC" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" class="KeyInfo" name="Des" size="41">
							</td>
						</tr>						
					</table>
				</div>
			</div>
			
			<button class="Info-input-btn" id="btn">Insert</button>
			
			<div class="ba-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input-info">
								<input type="text" class="ComCode KeyInfo" name="ComCode" onclick="InfoSearch('ComSearch')" placeholder="SELECT" readonly>
								<input class="Com_Name" hidden>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>						
				
						<tr><th class="info">Nationality : </th>
							<td class="input-info">
								<input type="text" class="Nationality-Code KeyInfo" name="Na-Code" id="Na-Code" placeholder="SELECT" readonly>
								<input type="text" class="Nationality-Des KeyInfo" name="Na-Des" id="na-Des" readonly>
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
						            <input type="text" class="AddrDetail NewAddr KeyInfo" name="AddrDetail" id="detailAddress" placeholder="상세주소" required>
						        </div>
						        <div>
						            <input type="text" class="AddrRefer NewAddr" id="extraAddress" placeholder="참고항목" hidden>
						        </div>
							</td>
						</tr>
						
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Local Currency : </th>
						<td class="input_info">
							<input type="text" class="money-code KeyInfo" name="money" placeholder="SELECT" onclick="InfoSearch('MoneySearch')" placeholder="SELECT" readonly>
						</td>
						
						<th class="info">Language : </th>
							<td class="input_info">
								<input type="text" class="language-code KeyInfo" name="lang" placeholder="SELECT" onclick="InfoSearch('LanSearch')" placeholder="SELECT" readonly>
							</td>
					</tr>	
					
					<tr class="spacer-row"></tr>	
					
						<tr><th class="info">Tax Area Code : </th>
							<td class="input-info">
								<input type="text" class="TA-code KeyInfo" name="TA-code" placeholder="SELECT" onclick="InfoSearch('TACSearch')" placeholder="SELECT" readonly>
							</td>
						</tr>

						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Biz.Area Group : </th>
							<td class="input-info">
								<input type="text" class="BAG-code KeyInfo" name="BAG-code" placeholder="SELECT" onclick="InfoSearch('BAGSearch')" placeholder="SELECT" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">사용 여부: </th>
							<td class="input_info">
									<input type="radio" class="InputUse KeyInfo" name="Use-Useless" value="true" checked>사용
									<span class="spacing"></span>
									<input type="radio" class="InputUse KeyInfo" name="Use-Useless" value="false">미사용								
								</select>
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
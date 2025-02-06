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
<title>Vendor Master 등록</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
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
                document.getElementById("ExtraAddress").value = extraAddr;
            
            } else {
                document.getElementById("ExtraAddress").value = '';
            }

            document.getElementById('Postcode').value = data.zonecode;
            document.getElementById("Address").value = addr;
            document.getElementById("DetailAddress").focus();
        }
    }).open();
}

function InfoSearch(field){
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
    case "NationSearch":
    	window.open("${contextPath}/Information/NationSearch.jsp", "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    }
}
$(document).ready(function(){
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
		console.log(ChkList);
		var pass = true;
		$.each(ChkList, function(key, value){
			if(value == null || value ===''){
				pass = false;
				return false;
			}
		})
		if(!pass){
			alert('모든 항목을 입력해주세요.');
		}else{
			$.ajax({
				url:'${contextPath}/Vendor/Vendor_Regist_Ok.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				success: function(data){
					console.log(data);
					if(data.status === 'Success'){
						$('.KeyInfo').each(function(){
							var name = $(this).attr('name');
							if(name === 'ComCode' || name === 'NationCode'){
								$(this).val('');
						        $(this).attr('placeholder', 'SELECT');
							} else if(name === 'AddrCode'){
								$(this).val('');
						        $(this).attr('placeholder', '우편번호');
							} else if(name === 'Addr'){
								$(this).val('');
						        $(this).attr('placeholder', '주소');
							} else if(name === 'AddrDetail'){
								$(this).val('');
						        $(this).attr('placeholder', '상세주소');
							} else if(name === 'Deal'){
								$(this).find('option:first').prop('selected', true);
							} else {
								$(this).val('');
							}
						})
					}else{
						alert('다시 입력해주세요.');
					}
				},
			    error: function(jqXHR, textStatus, errorThrown) {
			        console.log("AJAX Error: " + textStatus + ' : ' + errorThrown);
			    }
			});
		}
	})
})
</script>
</head>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
		<div class="ven-main-info">
			<div class="table-container">
				<div class="InfoInput">
					<label>Vendor Code : </label>
					<input type="text" name="vendorInput" class="vendorInput KeyInfo">
				</div>
				<div class="InfoInput">
					<label>Description : </label>
					<input type="text" name="vendorDes" class="vendorDes KeyInfo">
				</div>
			</div>
		</div>
		
		<button class="Info-input-btn" id="btn">Insert</button>
		
		<div class="ven-sub-info">
			<div class="table-container">
				<div class="InfoInput">
					<label>Company Code : </label>
					<input type="text" name="ComCode" class="ComCode KeyInfo" onclick="InfoSearch('ComSearch')" placeholder="SELECT" readonly>
					<input type="text" name="Com_Name" class="Com_Name KeyInfo" readonly>
				</div>
					
				<div class="InfoInput">	
					<label>Nationality : </label>
					<input type="text" name="NationCode" id="NationCode" class="NationCode KeyInfo" onclick="InfoSearch('NationSearch')" placeholder="SELECT" readonly>
					<input type="text" name="NationDes" id="NationDes" class="NationDes KeyInfo" readonly>
				</div>
					
				<div class="InfoInput">	
					<label>Postal Code : </label>
					<input type="text" class="AddrCode NewAddr KeyInfo" name="AddrCode" id="Postcode" placeholder="우편번호" readonly>
					<input type="button" onclick="execDaumPostcode()" value="우편번호 찾기">
				</div>
					
				<div class="InfoInput">
					<label>Address : </label>
					<div class="ForAddrColumn">
						<input type="text" class="Addr NewAddr KeyInfo" name="Addr" id="Address" placeholder="주소">
						<input type="text" class="AddrDetail NewAddr KeyInfo" name="AddrDetail" id="DetailAddress" placeholder="상세주소" required>
						<input type="text" class="AddrRefer NewAddr" id="ExtraAddress" placeholder="참고항목" hidden>
					</div>
				</div>
					
				<div class="InfoInput">
					<label>대표 전화번호 : </label>
					<input type="text" name="RepPhone" class="RepPhone KeyInfo">
				</div>
					
				<div class="InfoInput">
					<label>대표자 성명 : </label>
					<input type="text" name="RepName" class="RepName KeyInfo">
				</div>
				
				<div class="InfoInput">
					<label>거래 구분 : </label>
					<input type="radio" name="Deal" class="Deal KeyInfo" value="true" checked>매입
					<input type="radio" name="Deal" class="Deal KeyInfo" value="false">매출
				</div>
				
				<div class="InfoInput">
					<label>사업자 번호 : </label>
					<input type="text" name="PhoneNum" class="PhoneNum KeyInfo">
				</div>
				
				<div class="InfoInput">	
					<label>업태코드 : </label>
					<input type="text" name="UptaCode" class="UptaCode KeyInfo">
				</div>
				
				<div class="InfoInput">	
					<label>업종코드 : </label>
					<input type="text" name="BusinessCode" class="BusinessCode KeyInfo">
				</div>
			</div>
		</div>
	</center>
	<footer>
		<img id="logo" name="Logo" src="${contextPath}/img/White_Logo.png" alt="">
	</footer>
</body>
</html>
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
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<title>Company 등록</title>
<script>
	function InfoSearch(field){
		event.preventDefault();
		
		var popupWidth = 600;
	    var popupHeight = 700;
	    
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
	    case "NationSearch":
	    	popupWidth = 510;
	    	window.open("${contextPath}/Information/NationSearch.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "MoneySearch":
	    	window.open("${contextPath}/Information/MoneySearch.jsp", "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "LanSearch":
	    	window.open("${contextPath}/Information/LanSearch.jsp", "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "ComSearch":
	    	popupWidth = 1500;
	    	xPos = -2279;
	    	window.open("${contextPath}/Company/Company_Search.jsp", "PopUp04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    }
	}
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
$(document).ready(function(){
	var ChkList = {};
	$('.Info-input-btn').click(function(){
		event.preventDefault();
		$('.ComInfo').each(function(){
			var Name = $(this).attr('name');
			var Value = $(this).val();
			ChkList[Name] = Value;
		})
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
				url:'${contextPath}/Company/Company_Regist_Ok.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
					console.log(data.status);
					if(data.status === 'Success'){
						alert('회사가 등록되었습니다.');
						$('.ComInfo').each(function(){
							var name = $(this).attr('name');
							if(name === 'NationCode' || name === 'money' || name === 'lang'){
								$(this).val('');
						        $(this).attr('placeholder', 'Click');
							} else if(name === 'AddrCode'){
								$(this).val('');
						        $(this).attr('placeholder', '우편번호');
							} else if(name === 'Addr'){
								$(this).val('');
						        $(this).attr('placeholder', '주소');
							} else if(name === 'AddrDetail'){
								$(this).val('');
						        $(this).attr('placeholder', '상세주소');
							} else if(name === 'TA_use' || name === 'TB_use' || name === 'BA_use' || name === 'FSRL'){
								$(this).find('option:first').prop('selected', true);
							} else{
								$(this).val('');
							}
						})
					}else{
						alert('다시 입력해주세요.');
					}
				}
			});
		}
	});
})	
</script>
</head>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
			<div class="main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input_info">
								<input type="text" class="ComInfo" name="Com_code" size="10">
								<input type="button" class="search-link" value="Search" onclick="InfoSearch('ComSearch')" readonly>	
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input_info">
								<input type="text" class="ComInfo" name="Des" size="41">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<button class="Info-input-btn" id="btn">Input</button>	
			
			<div class="sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Nationality : </th>
						<td class="input_info">
							<input type="text" class="ComInfo" id="NationCode" name="NationCode" onclick="InfoSearch('NationSearch')" placeholder="CLICK" readonly>	
							<input type="text" class="ComInfo" id="NationDes" name="NationName_input" readonly>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Postal Code : </th>
							<td class="input-info">
								<input type="text" class="AddrCode NewAddr ComInfo" name="AddrCode" id="postcode" placeholder="우편번호" readonly>
						        <input type="button" onclick="execDaumPostcode()" value="우편번호 찾기">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
					<tr><th class="info">Address : </th>
						<td class="input-info">
					        <div>
					            <input type="text" class="Addr NewAddr ComInfo" name="Addr" id="address" placeholder="주소" readonly>
					        </div>
					        <div>
					            <input type="text" class="AddrDetail NewAddr ComInfo" name="AddrDetail" id="detailAddress" placeholder="상세주소" required>
					        </div>
					        <div>
					            <input type="text" class="AddrRefer NewAddr" id="extraAddress" placeholder="참고항목" hidden>
					        </div>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Local Currency : </th>
						<td class="input_info">
							<input type="text" class="money-code ComInfo" name="money" onclick="InfoSearch('MoneySearch')" placeholder="CLICK" readonly>
						</td>
						
						<th class="info">Language : </th>
							<td class="input_info">
								<input type="text" class="language-code ComInfo" name="lang" onclick="InfoSearch('LanSearch')" placeholder="CLICK" readonly>
							</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Business Area 사용 : </th>
						<td class="input_info">
							<select class="yn ComInfo" name="BA_use" id="BA_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>	
					
					<tr><th class="info">Tax Area 사용 : </th>
						<td class="input_info">
							<select class="yn ComInfo" name="TA_use" id="TA_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">TaxArea vs BizArea : </th>
						<td class="input_info">
							<select class="yn ComInfo" name="TB_use" id="TB_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Financial Statement Reporting Level : </th>
						<td class="input_info">
							<select class="ComInfo" name="FSRL" id="FSRL">
								<option value="1">1(Company)</option>
								<option value="2">2(Biz Area)</option>
								<option value="3">3(Tax Area)</option>
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
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
<title>Company 등록</title>
<script>
	function infoSearch(field){
		event.preventDefault();
		
		var popupWidth = 1000;
	    var popupHeight = 600;
	    
	    // 현재 활성화된 모니터의 위치를 감지
	    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
	    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
	    console.log(dualScreenLeft);
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
	    case "NationSearch":
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
	
	function comfirm(){
		var cocd = document.Com_registform.Com_code.value;
		var Des = document.Com_registform.Des.value;
		
		var NaCode = document.Com_registform.NationCode.value;
		var NaName = document.Com_registform.NationName_input.value;
		
		var PtCd = document.Com_registform.PtCd.value;
		
		var Addr01 = document.Com_registform.Addr01.value;
		var Addr02 = document.Com_registform.Addr02.value;
		
		var money = document.Com_registform.money.value;
		var lang = document.Com_registform.lang.value;
		
		var BA_use = document.Com_registform.BA_use.value;
		var TA_use = document.Com_registform.TA_use.value;
		var TB_use = document.Com_registform.TB_use.value;
		var FSRL = document.Com_registform.FSRL.value;
	    
	    if(!cocd || !Des || !NaCode || !NaName || !PtCd || !Addr01 || !Addr02 || !money || !lang || !BA_use || !TA_use || !TB_use || !FSRL){
	    	alert('모든 항목을 입력해주세요.');
	    	return false;
	    } else{
	    	return true;
	    }
	}
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
	}
</script>
</head>
<body>
	<h1>Company 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="Com_registform" name="Com_registform" action="Company_Regist_Ok.jsp" method="post" onSubmit="return comfirm()" enctype="UTF-8">
			<div class="main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input_info">
								<input type="text" name="Com_code" size="10">
								<input type="button" class="search-link" value="Search" onclick="infoSearch('ComSearch')" readonly>	
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input_info">
								<input type="text" name="Des" size="41">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Input">	
			
			<div class="sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Nationality : </th>
						<td class="input_info">
							<input type="text" id="NationCode" name="NationCode" onclick="infoSearch('NationSearch')" readonly>	
							<input type="text" id="NationDes" name="NationName_input" readonly>
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
					
					<tr><th class="info">Local Currency : </th>
						<td class="input_info">
							<input type="text" class="money-code" name="money" onclick="infoSearch('MoneySearch')" readonly>
						</td>
						
						<th class="info">Language : </th>
							<td class="input_info">
								<input type="text" class="language-code" name="lang" onclick="infoSearch('LanSearch')" readonly>
							</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Business Area 사용 : </th>
						<td class="input_info">
							<select class="yn" name="BA_use" id="BA_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>	
					
					<tr><th class="info">Tax Area 사용 : </th>
						<td class="input_info">
							<select class="yn" name="TA_use" id="TA_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">TaxArea vs BizArea : </th>
						<td class="input_info">
							<select class="yn" name="TB_use" id="TB_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Financial Statement Reporting Level : </th>
						<td class="input_info">
							<select name="FSRL" id="FSRL">
								<option value="1">1(Company)</option>
								<option value="2">2(Biz Area)</option>
								<option value="3">3(Tax Area)</option>
							</select>
						</td>
					</tr>	
				</table>
			</div>																							
			</div>
		</form>
	</center>
</body>
</html>
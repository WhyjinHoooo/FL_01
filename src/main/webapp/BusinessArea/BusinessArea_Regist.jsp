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
<script type='text/javascript'>
	$(document).ready(function(){
	    $('.Com-code').change(function(){
	        var CompanyCode = $(this).val();
	        console.log('1. 선택된 값: ' + CompanyCode);
	        
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
		    
		    console.log('2. 선택된 값: ' + CompanyCode);
		    window.open("${contextPath}/Information/TACSearch.jsp?CoCd=" + CompanyCode, "yangjinho", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
		    //window.open("${contextPath}/Information/TACSearch.jsp?CoCd=" + CompanyCode, "asdfasdfasdf", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
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
	}
	
	function InfoFunction(field){
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
	    
	    var ComCode = document.querySelector('.Com-code').value;
	    
	    switch(field){
	    case "ComSearch":
	    	window.open("${contextPath}/Information/ComSearch.jsp", "test01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
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
</script>
<script>

</script>
<title>Business Area 등록</title>
</head>
<body>
	<h1>Business Area 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="BusA-RegistForm" name="BusA-RegistForm" action="BusinessArea_Regist_Ok.jsp" method="post" onSubmit="" encType="UTF-8">
			<div class="ba-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Business Area Code : </th>
							<td class="input-info">
								<input type="text" name="BAC" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" name="Des" size="41">
							</td>
						</tr>						
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="ba-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input-info">
								<a href="javascript:void(0);" onclick="InfoFunction('ComSearch')"><input type="text" class="Com-code" name="Com-code" readonly></a>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<script type="text/javascript">
						$(document).ready(function(){
						    $('.Com-code').change(function(){
						        var Company_Code = $(this).val(); // 수정된 부분
						        
						        $.ajax({
						            type: 'post',
						            url: '${contextPath}/Tax/Com-Na-Output.jsp',
						            data: { Company_Code : Company_Code }, // 수정된 부분
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
						});
						</script>
						
				
						<tr><th class="info">Nationality : </th>
							<td class="input-info">
								<input type="text" class="Nationality-Code" name="Na-Code" id="Na-Code" readonly>
								<input type="text" class="Nationality-Des" name="Na-Des" id="na-Des" readonly>
							</td>
						</tr>
												
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Postal Code : </th>
							<td class="input-info">
								<!-- <input type="text" class="PosCode" name="PosCode"> -->
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
							<a href="javascript:void(0);" onclick="InfoFunction('MoneySearch')"><input type="text" class="money-code" name="money" placeholder="SELECT" readonly></a>
						</td>
						
						<th class="info">Language : </th>
							<td class="input_info">
								<a href="javascript:void(0);" onclick="InfoFunction('LanSearch')"><input type="text" class="language-code" name="lang" placeholder="SELECT" readonly></a>
							</td>
					</tr>	
					
					<tr class="spacer-row"></tr>	
					
						<tr><th class="info">Tax Area Code : </th>
							<td class="input-info">
								<a href="javascript:void(0);" onclick="InfoFunction('TACSearch')"><input type="text" class="TA-code" name="TA-code" placeholder="SELECT" readonly></a>
							</td>
						</tr>

						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Biz.Area Group : </th>
							<td class="input-info">
								<a href="javascript:void(0);" onclick="InfoFunction('BAGSearch')"><input type="text" class="BAG-code" name="BAG-code" placeholder="SELECT" readonly></a>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">사용 여부: </th>
							<td class="input_info">
									<input type="radio" class="InputUse" name="Use-Useless" value="true" checked>사용
									<span class="spacing"></span>
									<input type="radio" class="InputUse" name="Use-Useless" value="false">미사용								
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
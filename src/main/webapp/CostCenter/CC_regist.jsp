<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="javax.swing.text.DateFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<%
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String formattedToday = today.format(formatter);
%>
<link rel="stylesheet" href="../css/style.css?after">
<title>Cost Center 등록</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
<script type='text/javascript'>
	$(document).ready(function() {
	    var start_date = new Date("<%=formattedToday%>");
	    var end_date = new Date(start_date.getTime());
	    end_date.setFullYear(end_date.getFullYear() + 10);
	    $(".date01").val(formatDate(start_date));
	    $(".date02").attr("max", formatDate(end_date));
	    
	    $('.Com-code').change(function(){
	    	$('.Biz_Code').val('');
	    	$('.Biz_Code_Des').val('');
	    	$('.cct').val('');
	    	$('.CCT_Des').val('');
	    })
	});
	
	function formatDate(date) {
	    var dd = String(date.getDate()).padStart(2, '0');
	    var mm = String(date.getMonth() + 1).padStart(2, '0'); //January is 0!
	    var yyyy = date.getFullYear();
	
	   return yyyy + '-' + mm + '-' + dd;
	}
	
	function CompanyCode(d){
		var v = d.value;
		document.CC_Registform.Com_Des.value = v;
	}
	function CCTapply(d){
		var v = d.value;
		document.CC_Registform.CCT_Des.value = v;
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
	
	function InfoSearch(field){
		var popupWidth = 1000;
	    var popupHeight = 600;
	    
	    // 현재 활성화된 모니터의 위치를 감지
	    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
	    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
	    
	    // 전체 화면의 크기를 감지
	    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
	    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
	    var xPos, yPos;
		
	    var CompanyCode = document.querySelector('.Com-code').value;
	    
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
	    case"ComSearch":
	    	window.open("${contextPath}/Information/ComSearch.jsp", "test01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case"BusiAreaSearch":
	    	window.open("${contextPath}/Information/BizAreaSearch.jsp?ComCode=" + CompanyCode, "test02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case"MoneySearch":
	    	window.open("${contextPath}/Information/MoneySearch.jsp", "test03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case"LanSearch":
		    window.open("${contextPath}/Information/LanSearch.jsp", "test04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case"CCGSearch":
		    window.open("${contextPath}/Information/CCGSearch.jsp?ComCode=" + CompanyCode, "test05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case"CCTSearch":
		    window.open("${contextPath}/Information/CCTSearch.jsp", "test06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    }
	}
</script>

<body>
	<h1>Cost Center 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="CC_Registform" name="CC_Registform" action="CC_regist_Ok.jsp" method="post" enctype="UTF-8">
			<div class="cc-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Cost Center Code : </th>
							<td class="input-info">
								<input type="text" name="cost_code" size="10">
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
			
			<div class="cc-sub-info">
					<div class="table-container">
						<table>
							<tr><th class="info">Company Code : </th>
								<td class="input-info">
									<div class="test">
									<input type="text" class="Com-code" name="Com-Code" placeholder="SELECT" onchange="CompanyCode(this)" onclick="InfoSearch('ComSearch')" readonly>
										<input type="text" name="Com_Des" size="31" readonly>	
									</div>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info"> Biz.Area Code : </th>
								<td class="input-info">
									<input type="text" class="Biz_Code" name="Biz_Code" placeholder="SELECT" onclick="InfoSearch('BusiAreaSearch')" readonly>
									<input type="text" class="Biz_Code_Des" name="Biz_Code_Des" size="31" readonly>
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
								<td class="input-info">
									<input type="text" class="money-code" name="money" onclick="InfoSearch('MoneySearch')" readonly>
								</td>
								<th class="info">Language : </th>
									<td class="input-info">
										<input type="text" class="language-code" name="lang" onclick="InfoSearch('LanSearch')" readonly>
									</td>
							</tr>		
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">유효기간 : </th>
								<td class="input-info">
									<input type="date" class='date01' name='start_date'>
									~
									<input type="date" class='date02' name='end_date'>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Cost Center Group : </th>
								<td class="input-info">
									<input type="text" class="CCG_Des" name="CCG_Des" size="31" onclick="InfoSearch('CCGSearch')" readonly>
									<input type="text" class="CCG" name="CCG" hidden>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Cost Center Type : </th>
								<td class="input-info">
									<input type="text" class="cct" name="cct" onchange="CCTapply(this)" placeholder="SELECT" onclick="InfoSearch('CCTSearch')" readonly>
									<input type="text" class="CCT_Des" name="CCT_Des" size="31" readonly>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Responsibility Person : </th>
								<td class="input-info">
									<select class="rp" name="rp">
										<option value="Nope">Select</option>
									</select>
									<input type="text" name="RPescon_Dese" size="31">
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
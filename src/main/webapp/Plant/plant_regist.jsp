<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<title>Plant 등록</title>
<link rel="stylesheet" href="../css/style.css?after">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
    var now_utc = Date.now();
    var timeOff = new Date().getTimezoneOffset() * 60000;
    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
    var testElement = document.getElementById("today");

    if (testElement) {
        testElement.setAttribute("min", today);
        testElement.setAttribute("max", today);
    } else {
        console.error("Element with id 'today' not found.");
    }
});
document.addEventListener("DOMContentLoaded", function() {
    var now_utc = Date.now();
    var timeOff = new Date().getTimezoneOffset() * 60000;
    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
    var testElement = document.getElementById("future");

    if (testElement) {
        testElement.setAttribute("min", today);
    } else {
        console.error("Element with id 'test' not found.");
    }
});
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
    
    var code = $('.ComCode').val();
    
    switch(field){
    case "ComPany":
    	window.open("${contextPath}/Information/CompanySerach.jsp", "POP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "BizArea":
    	window.open("${contextPath}/Information/BizAreaCSearch.jsp?ComCode=" + code, "POP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "Money":
    	window.open("${contextPath}/Information/MoneySearch.jsp", "POP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "Language":
    	window.open("${contextPath}/Information/LanSearch.jsp", "POP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
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
</script>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
		<!-- <form id="plant_RegistForm" name="plant_RegistForm" action="plant_regist_Ok.jsp" method="post" ecntype="UTF-8"> -->
		<div class="plant-main-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Plant Code : </th>
						<td class="input-info">
							<input typr="text" name="plant_code" size="10">
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
				
		<div class="plant-sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Company Code : </th>
						<td class="input-info">
							<input type="text" class="ComCode" name="ComCode" placeholder="SELECT" onclick="InfoSearch('ComPany')" readonly>
							<input type="text" class="Com_Name" name="Com_Name" readonly >
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Biz.Area Code : </th>
						<td class="input-info">
							<input type="text" class="BizSelect" name="BizSelect" placeholder="SELECT" onclick="InfoSearch('BizArea')" readonly>
							<input type="text" class="Biz_Des" name="Biz_Des" readonly>
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
							<input type="text" class="money-code" name="money" placeholder="SELECT" onclick="InfoSearch('Money')" readonly>
						</td>
						<th class="info">Language</th>
							<td class="input-info">
								<input type="text" class="language-code" name="lang" placeholder="SELECT" onclick="InfoSearch('Language')" readonly>
							</td>
							
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">유효기간 : </th>
						<td class="input-info">
							<input type="date" class="today" id="today" name="today">
							~
							<input type="date" class="future" id="future" name="future">
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
	</center>
	<footer>
		<img id="logo" name="Logo" src="${contextPath}/img/White_Logo.png" alt="">
	</footer>
</body>
</html>
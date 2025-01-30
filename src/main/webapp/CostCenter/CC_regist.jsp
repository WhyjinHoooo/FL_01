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
function formatDate(date) {
    var dd = String(date.getDate()).padStart(2, '0');
    var mm = String(date.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = date.getFullYear();

   return yyyy + '-' + mm + '-' + dd;
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
    case"ComSearch":
    	window.open("${contextPath}/Information/CompanySerach.jsp", "POP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case"BusiAreaSearch":
    	window.open("${contextPath}/Information/BizAreaSearch.jsp?ComCode=" + ComCode, "POP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case"MoneySearch":
    	window.open("${contextPath}/Information/MoneySearch.jsp", "POP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case"LanSearch":
	    window.open("${contextPath}/Information/LanSearch.jsp", "POP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case"CCGSearch":
	    window.open("${contextPath}/Information/CCGSearch.jsp?ComCode=" + ComCode, "POP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case"CCTSearch":
	    window.open("${contextPath}/Information/CCTSearch.jsp", "POP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    }
}
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
				url:'${contextPath}/CostCenter/CC_regist_Ok.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
				console.log(data.status);
					if(data.status === 'Success'){
						$('.KeyInfo').each(function(){
							var name = $(this).attr('name');
							if(name === 'ComCode' || name === 'Biz_Code' || name === 'money' || name === 'lang' || name === 'CCG' || name === 'cct'){
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
							} else if(name === 'Use-Useless'){
								$(this).find('option:first').prop('selected', true);
							} else if(name === 'start_date'){
								$(".date01").val(formatDate(start_date));
							} else {
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
});
</script>

<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
		<div class="cc-main-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Cost Center Code : </th>
						<td class="input-info">
							<input type="text" class="KeyInfo" name="cost_code" size="10">
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
		
		<div class="cc-sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Company Code : </th>
						<td class="input-info">
							<div class="test">
							<input type="text" class="ComCode KeyInfo" name="ComCode" placeholder="SELECT"onclick="InfoSearch('ComSearch')" readonly>
							<input type="text" class="Com_Name KeyInfo" name="Com_Name" size="31" readonly>	
							</div>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
						<tr><th class="info"> Biz.Area Code : </th>
						<td class="input-info">
							<input type="text" class="Biz_Code KeyInfo" name="Biz_Code" placeholder="SELECT" onclick="InfoSearch('BusiAreaSearch')" readonly>
							<input type="text" class="Biz_Code_Des KeyInfo" name="Biz_Code_Des" size="31" readonly>
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
						<td class="input-info">
							<input type="text" class="money-code KeyInfo" name="money" onclick="InfoSearch('MoneySearch')" placeholder="SELECT" readonly>
						</td>
						<th class="info">Language : </th>
							<td class="input-info">
								<input type="text" class="language-code KeyInfo" name="lang" onclick="InfoSearch('LanSearch')" placeholder="SELECT" readonly>
							</td>
					</tr>		
					
					<tr class="spacer-row"></tr>
						
					<tr><th class="info">유효기간 : </th>
						<td class="input-info">
							<input type="date" class="date01 KeyInfo" name="start_date">
							~
							<input type="date" class="date02 KeyInfo" name="end_date">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Cost Center Group : </th>
						<td class="input-info">
							<input type="text" class="CCG_Des" name="CCG_Des" onclick="InfoSearch('CCGSearch')" placeholder="SELECT" readonly>
							<input type="text" class="CCG KeyInfo" name="CCG" hidden>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Cost Center Type : </th>
						<td class="input-info">
							<input type="text" class="cct KeyInfo" name="cct" placeholder="SELECT" onclick="InfoSearch('CCTSearch')" readonly>
							<input type="text" class="CCT_Des KeyInfo" name="CCT_Des" size="31" readonly>
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
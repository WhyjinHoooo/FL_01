<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.awt.print.PrinterException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<title>Employee 등록</title>
<link rel="stylesheet" href="../css/style.css?after">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function InfoSearch(field){
	var popupWidth = 520;
    var popupHeight = 680;
    
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
    var ComCode = document.querySelector('.ComCode').value;
    
    switch(field){
    case "ComSearch":
    	window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "CCSearch":
    	window.open("${contextPath}/Information/CostCenterSearch.jsp?ComCode=" + ComCode, "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "DutySearch":
    	popupWidth = 800;
    	window.open("${contextPath}/Information/DutySearch.jsp", "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "titleSearch":
    	window.open("${contextPath}/Information/titleSearch.jsp", "PopUp04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
	case "RoleSearch":
		window.open("${contextPath}/Information/RoleSearch.jsp", "PopUp04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
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

$(document).ready(function(){
	function DateSetting(){
		var DateObject = new Date();
		var TodayDate = DateObject.getFullYear() + '-' + ('0' + (DateObject.getMonth() + 1)).slice(-2) + '-' + ('0' + DateObject.getDate()).slice(-2);
		$('.join').attr('max', TodayDate);
		$('.Birth').attr('max', TodayDate);
	}
	function EmpIdMaker(){
		var DateForId = $('.NoDate').val();
		$.ajax({
			url: '${contextPath}/Emp/EmpIdMake.jsp',
			type: 'POST',
			data: {DateId: DateForId},
			success: function(response){
				$('.Emp_id').val($.trim(response));
			}
		})
	}
	DateSetting();
	EmpIdMaker();
	$('.ComCode').change(function(){
		$('.CC_Code').val('');
		$('.CC_Name').val('');
	})
	$('.Birth').change(function(){
		var BornDate = $(this).val();
		var Jumin1St = BornDate.substring(2).replace('-','').replace('-','');
		$('.Jumin_1st').val(Jumin1St);
	})
	var ChkList = {};
	$('.Info-input-btn').click(function(){
		event.preventDefault();
		$('.KeyInfo').each(function(){
			var Name = $(this).attr('name');
			var Value = $(this).val();
		    
			ChkList[Name] = Value;
		})
		console.log(ChkList);
		var pass = true;
		$.each(ChkList, function(key, value){
			if(value == null || value ===''){
				if(key === 'retire'){
					return true;
				}
				pass = false;
				return false;
			}
		})
		if(!pass){
			alert('모든 항목을 입력해주세요.');
		}else{
			$.ajax({
				url:'${contextPath}/Emp/Emp-regist-Ok.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
				console.log(data.status);
					if(data.status === 'Success'){
						EmpIdMaker();
						$('.KeyInfo').each(function(){
							var name = $(this).attr('name');
							if(name === 'ComCode' || name === 'CC_Code' || name === 'title_Code' || name === 'duty_code' || name === 'UserDutyCode'){
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
							} else if(name === 'Jumin_2nd'){
								$(this).val('');
						        $(this).attr('placeholder', 'INPUT');
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
})
</script>
</head>
<%
	LocalDateTime date = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
	String YearMon = date.format(formatter); 
%>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
		<!-- <form name="empRegistForm" id="empRegistForm" action="Emp-regist-Ok.jsp" method="post" enctype="UTF-8"> -->
		<div class="emp-main-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Employee ID : </th>
						<td class="input-info">
							<input type="text" class="Emp_id KeyInfo" name="Emp_id" size="10" readonly>
							<input type="text" class="NoDate" value="<%=YearMon %>" hidden>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Employee Name : </th>
						<td class="input-info">
							<input type="text" class="KeyInfo" name="Des" size="47">
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<button class="Info-input-btn" id="btn">Insert</button>
		
		<div class="emp-sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Company Code : </th>
						<td class="input-info">
							<input type="text" class="ComCode KeyInfo" name="ComCode" id="ComCode" size="10" readonly onclick="InfoSearch('ComSearch')" placeholder="SELECT">
							<input type="text" class="Com_Name KeyInfo" name="Com_Name" size="31" readonly>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>				
					
					<tr><th class="info">Cost Center : </th>
						<td class="input-info">
							<input type="text" class="CC_Code KeyInfo" name="CC_Code" size="11" readonly onclick="InfoSearch('CCSearch')" placeholder="SELECT">
							<input type="text" class="CC_Name KeyInfo" name="CC_Name"size="31" readonly>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Postal Code : </th>
						<td class="input-info">
							<input type="text" class="AddrCode NewAddr KeyInfo" name="AddrCode" id="Postcode" placeholder="우편번호" readonly>
					        <input type="button" onclick="execDaumPostcode()" value="우편번호 찾기">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Address : </th>
						<td class="input-info">
					        <div>
					            <input type="text" class="Addr NewAddr KeyInfo" name="Addr" id="Address" placeholder="주소">
					        </div>
					        <div>
					            <input type="text" class="AddrDetail NewAddr KeyInfo" name="AddrDetail" id="DetailAddress" placeholder="상세주소" required>
					        </div>
					        <div>
					            <input type="text" class="AddrRefer NewAddr" id="ExtraAddress" placeholder="참고항목" hidden>
					        </div>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">생년월일 : </th>
						<td class="input-info">
							<input type="date" class="Birth KeyInfo" name="Birth" id="Birth">
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">주민등록번호 : </th>
						<td class="input-info">
							<input type="text" class="Jumin_1st KeyInfo" name="Jumin_1st" readonly>
							<input type="text" class="Jumin_2nd KeyInfo" name="Jumin_2nd" placeholder="INPUT">
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">수행직무 : </th>
						<td class="input-info">
							<input type="text" class="UserDutyCode KeyInfo" name="UserDutyCode" onclick="InfoSearch('RoleSearch')" placeholder="SELECT" readonly>
							<input type="text" class="UserDutyDes KeyInfo" name="UserDutyDes" readonly>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">입사 일자 : </th>
						<td class="input-info">
							<input type="date" class="join KeyInfo" id="join" name="join">
						</td>
						<th class="info">퇴직 일자 : </th>
						<td>
							<input type="date" class="retire KeyInfo" id="retire" name="retire">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">직책 : </th>
						<td class="input-info">
							<input type="text" class="duty_code KeyInfo" name="duty_code" placeholder="SELECT" onclick="InfoSearch('DutySearch')" readonly>
							<input type="text" class="duty_Des KeyInfo" name="duty_Des" size="31" readonly>
						</td>
						<th>직책 발령 일자 : </th>
						<td>
							<input type="date" class="duty_Start KeyInfo" name="duty_Start" id="duty_Start">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">직위 : </th>
						<td class="input-info">
							<input type="text" class="title_Code KeyInfo" name="title_Code" placeholder="SELECT" onclick="InfoSearch('titleSearch')" readonly>
							<input type="text" class="title_Des KeyInfo" name="title_Des" size="31" readonly>
						</td>
						<th class="info">승격 일자 : </th>
						<td class="input-info">
							<input type="date" class="KeyInfo" name="promot">
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
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
<script type='text/javascript'>
$(document).ready(function(){
	var DateForId = $('.NoDate').val();
	console.log(DateForId);
	
	$.ajax({
		url: 'EmpIdMake.jsp',
		type: 'POST',
		data: {DateId: DateForId},
		success: function(response){
			console.log(response);
			$('input[name="Emp_id"]').val($.trim(response));
		}
	})
})
window.addEventListener('DOMContentLoaded', (event) => {
    const comCodeInput = document.querySelector('.ComCode');
    const comNameInput = document.querySelector('.Com_Name');
    const ccCodeInput = document.querySelector('.CC_Code');
    const ccNameInput = document.querySelector('.CC_Name');

    const resetCCInputs = () => {
        ccCodeInput.value = '';
        ccNameInput.value = '';
    };

    comCodeInput.addEventListener('change', resetCCInputs);
    comNameInput.addEventListener('change', resetCCInputs);
});

document.addEventListener("DOMContentLoaded", function() {
    var now_utc = Date.now();
    var timeOff = new Date().getTimezoneOffset() * 60000;
    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
    var testElement = document.getElementById("join");
    var testElement2 = document.getElementById("Birth");

    if (testElement) {
        testElement.setAttribute("max", today);
        testElement2.setAttribute("max", today);
    } else {
        console.error("Element with id 'test' not found.");
    }
});
function Search() {
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;

    window.open("${contextPath}/Information/CompanySerach.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);
}
function CCSearch() {
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    var comCode = document.querySelector('.ComCode').value;

    window.open("${contextPath}/Information/CostCenterSearch.jsp?ComCode=" + comCode, "테스트", "width=500,height=500, left=500 ,top=" + yPos);
}
function DutySearch() {
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    var comCode = document.querySelector('.ComCode').value;

    window.open("${contextPath}/Information/DutySearch.jsp", "테스트", "width=595,height=545, left=500 ,top=" + yPos);	
}
function titleSearch() {
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    var comCode = document.querySelector('.ComCode').value;

    window.open("${contextPath}/Information/titleSearch.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);	
}
function sample6_execDaumPostcode() {
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
                document.getElementById("sample6_extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("sample6_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample6_postcode').value = data.zonecode;
            document.getElementById("sample6_address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("sample6_detailAddress").focus();
        }
    }).open();
}
</script>
</head>
<%
	LocalDateTime date = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
	String YearMon = date.format(formatter); 
%>
<body>
	<h1>Employee 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form name="empRegistForm" id="empRegistForm" action="Emp-regist-Ok.jsp" method="post" enctype="UTF-8">
			<div class="emp-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Employee ID : </th>
							<td class="input-info">
								<input type="text" class="Emp_id" name="Emp_id" size="10" readonly>
								<input type="text" class="NoDate" value="<%=YearMon %>" hidden>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" name="Des" size="47">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="emp-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input-info">
								<a href="javascript:Search()"><input type="text" class="ComCode" name="ComCode" id="ComCode" size="10" readonly placeholder="SELECT"></a>
									<!-- <a href="javascript:Search()" class="Com-Search"><img src="../img/edit_glass2.png" alt=""></a> -->
								<input type="text" name="Com_Name" class="Com_Name" size="31" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>				
						
						<tr><th class="info">Cost Center : </th>
							<td class="input-info">
								<a href="javascript:CCSearch()"><input type="text" name="CC_Code" class="CC_Code" size="11" readonly placeholder="SELECT"></a>
								<input type="text" name="CC_Name" class="CC_Name" size="31" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Postal Code : </th>
							<td class="input-info">
								<!-- <input type="text" class="PosCode" name="PosCode"> -->
								<input type="text" class="AddrCode NewAddr" name="AddrCode" id="sample6_postcode" placeholder="우편번호">
						        <input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Address : </th>
							<td class="input-info">
						        <div>
						            <input type="text" class="Addr NewAddr" name="Addr" id="sample6_address" placeholder="주소">
						        </div>
						        <div>
						            <input type="text" class="AddrDetail NewAddr" name="AddrDetail" id="sample6_detailAddress" placeholder="상세주소" required>
						        </div>
						        <div>
						            <input type="text" class="AddrRefer NewAddr" id="sample6_extraAddress" placeholder="참고항목" hidden>
						        </div>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">생년월일 : </th>
							<td class="input-info">
								<input type="date" name="Birth" id="Birth">
							</td>
						</tr>	
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">주민등록번호 : </th>
							<td class="input-info">
								<input type="text" name="Jumin_1st" size="11">
								<input type="text" name="Jumin_2nd" size="11">
							</td>
						</tr>	
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">입사 일자 : </th>
							<td class="input-info">
								<input type="date" class="join" id="join" name="join">
							</td>
							<th class="info">퇴직 일자 : </th>
							<td>
								<input type="date" class="retire" id="retire" name="retire">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">직책 : </th>
							<td class="input-info">
								<a href="javascript:DutySearch()"><input type="text" class="duty_code" name="duty_code" placeholder="SELECT" readonly></a>
								<input type="text" class="duty_Des" name="duty_Des" readonly>
							</td>
							<th>직책 발령 일자 : </th>
							<td>
								<input type="date" class="duty_Start" name="duty_Start" id="duty_Start">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">직위 : </th>
							<td class="input-info">
								<a href="javascript:titleSearch()"><input type="text" class="title_Code" name="title_Code" placeholder="SELECT" readonly></a>
								<input type="text" class="title_Des" name="title_Des" size="31" readonly>
							</td>
							<th class="info">승격 일자 : </th>
							<td class="input-info">
								<input type="date" name="promot">
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
	</center>
</body>
</html>
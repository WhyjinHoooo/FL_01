<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/USTcss.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function() {
    var now_utc = Date.now();
    var timeOff = new Date().getTimezoneOffset() * 60000;
    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
    var TS_From = document.getElementById("TimeStamp_From");
    var TS_To = document.getElementById("TimeStamp_End");

    if (TS_From && TS_To) {
        TS_From.setAttribute("max", today);
        TS_To.setAttribute("max", today);
    } else {
        console.error("Element with id 'TimeStamp_From' or 'TimeStamp_End' not found.");
    }
});

$(document).ready(function(){
	var OP_ComCode = $('.UserComCode').val(); // 검색 조건 중 회사코드
	var OP_BA = $('.UserBizArea').val(); // 검색 조건 중 BA
	var OP_COCT = $('.UserDepartCd').val(); // 검색 조건 중 COCT
	var OP_Inputer = $('.InputerId').val(); // 검색 조건 중 전표 입력자
	var OP_Approver = $('.ApproverId').val(); // 검색 조건 중 결재합의자
	var OP_TFrom = $('.TimeStampF').val(); // 검색 조건 중 기표일자 From
	var OP_TEnd = $('.TimeStampE').val(); // 검색 조건 중 기표일자 End
	var OP_SlipState = $('.UnSlipState').val(); // 검색 조건 중 전표 상태
	var OP_SlipType = $('.SlipType').val(); // 검색 조건 중 전요유형
	
	var OptionList = {};
	$('.Option').each(function(){
		var name = $(this).attr("name");
		var value = $(this).val();
		OptionList[name] = value;
	})
	console.log("검색할 조건들 : ", OptionList);
	
	function SlipSearch(event){
		event.preventDefault();
		
		$.ajax({
			url: '${contextPath}/UnapprovalSlip/InfoSearch/FacetSearch.jsp',
			type: 'POST',
			data: JSON.stringify(OptionList),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(data){
				
			}
		});
	}
	 $('.Inquiry').on('click', SlipSearch);
	/* 
	사용자 인터랙션 처리:

	1. 웹 페이지에서 사용자와 상호작용할 수 있는 요소(버튼, 링크, 폼 등)는 여러 가지가 있습니다. 이벤트 리스너를 통해 이러한 요소들이 클릭되거나 다른 방식으로 상호작용될 때 실행할 코드를 정의할 수 있습니다.
	예: 사용자가 버튼을 클릭하면 특정 작업(알림 표시, 폼 데이터 제출 등)이 수행됩니다.
	비동기 이벤트 처리:
	
	2. 이벤트 리스너는 비동기적으로 동작합니다. 즉, 웹 페이지가 로드된 후에도 이벤트가 발생할 때마다 지정된 함수를 호출합니다. 이를 통해 사용자의 액션에 실시간으로 반응할 수 있습니다.
	코드의 분리와 유지보수:
	
	3. 이벤트 리스너를 사용하면 코드를 더 모듈화하고 관리하기 쉽게 만들 수 있습니다. 특정 이벤트에 대한 처리를 별도의 함수로 정의하고, 필요할 때 그 함수를 호출하는 구조로 만들면 코드가 더 깔끔하고 유지보수하기 쉬워집니다.
	다양한 이벤트 처리 가능:
	
	4. 이벤트 리스너를 사용하면 클릭, 마우스 이동, 키보드 입력, 페이지 로드 등 다양한 이벤트를 처리할 수 있습니다. 이를 통해 더 복잡하고 풍부한 사용자 경험을 제공할 수 있습니다.
	
	이벤트 리스너의 역할:
		이벤트 연결: 이벤트 리스너는 특정 이벤트와 이를 처리할 함수를 연결하는 역할을 합니다. 예를 들어, 버튼 클릭 이벤트와 SlipSearch 함수를 연결합니다.
		이벤트 발생 시 함수 호출: 이벤트가 발생할 때 이벤트 리스너가 연결된 함수를 호출하여 정의된 동작을 수행합니다. 예를 들어, 버튼이 클릭될 때 SlipSearch 함수가 호출됩니다.
	*/
});
</script>
<script>
function InfoSearch(event, inputFieldId){
	event.preventDefault();

	var popupWidth = 1000;
    var popupHeight = 600;
   /*  var ComCode = document.querySelector('#UserDepart').value; */
    
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
    
    var UserComCode = $('.UserComCode').val();
    
    switch(inputFieldId){
	    case "BA_Btn":
	    	window.open("${contextPath}/UnapprovalSlip/InfoSearch/BAInfoSearch.jsp?Comcode=" + UserComCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    case "COCT_Btn":
	    	window.open("${contextPath}/UnapprovalSlip/InfoSearch/CoCtInfoSearch.jsp?Comcode=" + UserComCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    		break;
	    case "Inputer_Btn":
	    	window.open("${contextPath}/UnapprovalSlip/InfoSearch/InputerInfoSearch.jsp?Comcode=" + UserComCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    		break;
	    case "Approver_Btn":
	    	window.open("${contextPath}/UnapprovalSlip/InfoSearch/ApproverInfoSearch.jsp?Comcode=" + UserComCode, "테스트", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    		break;
	    default:
    		break;
    		
    }
}
</script>
<meta charset="UTF-8">
<title>전표 품의 상신 및 결재</title>
<%
	String User_Id = (String)session.getAttribute("id");
	String User_Depart = (String)session.getAttribute("depart");
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String todayDate = today.format(formatter);
%>
</head>
<body>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<hr>
	<form name="###" class="###" action="###" method="###" enctype="UTF-7">
		<div class="TotalArea">
			<div class="slip_Search_Area">
				<div class="Area_title">검색 조건</div>
				<table class="UserInfo">
						<tr>
							<th>법인(ComCode) : </th>
							<td>
								<input type="text" class="UserComCode Option" name="UserComCode" id="UserComCode" value="<%=User_Depart%>" readonly>
							</td>
						</tr>
						<tr>
							<th>전표입력 BA : </th>
							<td>
								<a><input type="text" class="UserBizArea Option" name="UserBizArea" id="UserBizArea" readonly></a>
								<input type="text" class="UserBizArea_Des" name="UserBizArea_Des" id="UserBizArea_Des" hidden>
								<button class="BASearchBtn" id="BASearchBtn" onclick="InfoSearch(event, 'BA_Btn')";>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표입력부서 : </th>
							<td>
								<a><input class="UserDepartCd Option" name="UserDepartCd" id="UserDepartCd" readonly></a>
								<input type="text" class="UserDepartCd_Des" name="UserDepartCd_Des" id="UserDepartCd_Des" hidden>
								<button class="COCTSearchBtn" id="COCTSearchBtn" onclick="InfoSearch(event, 'COCT_Btn')">&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표 입력자 : </th>
							<td>
								<input type="text" class="InputerId Option" name="InputerId" id="InputerId" readonly>
								<input type="text" class="Inputer_Name" name="Inputer_Name" id="Inputer_Name" hidden>
								<button class="InputerSearchBtn" id="InputerSearchBtn" name="InputerSearchBtn" onclick="InfoSearch(event, 'Inputer_Btn')">&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>결재 합의자 : </th>
							<td>
								<input type="text" class="ApproverId Option" name="ApproverId" id="ApproverId" readonly>
								<input type="text" class="Approver_Name" name="Approver_Name" id="Approver_Name" hidden>
								<button class="ApproverSearchBtn" id="ApproverSearchBtn" name="ApproverSearchBtn" onclick="InfoSearch(event, 'Approver_Btn')">&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>기표일자(From) : </th>
							<td>
								<input type="date" class="TimeStampF Option" name="TimeStamp From" id="TimeStamp_From">
							</td>
						</tr>
						<tr>
							<th>기표일자(To) : </th>
							<td>
								<input type="date" class="TimeStampE Option" name="TimeStamp To" id="TimeStamp_End">
							</td>
						</tr>
						<tr>
							<th>미승인전표 상태 : </th>
							<td>
								<select class="UnSlipState Option" id="UnSlipState" name="UnSlipState">
									<option>선택</option>
									<option value="A">A 미상신</option>
									<option value="B">B 결재 진행중</option>
									<option value="C">C 승인 완료</option>
									<option value="D">D 결재 반려</option>
									<option value="Z">Z 불완전전표</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>전표유형 : </th>
							<td>
								<select class="SlipType Option" id="SlipType" name="SlipType">
								<option>선택</option>
								<%
									try{
										String ST_Sql = "SELECT * FROM sliptype"; // Slip Type Sql
										PreparedStatement ST_Pstmt = conn.prepareStatement(ST_Sql);
										ResultSet ST_rs = ST_Pstmt.executeQuery();
									while(ST_rs.next()){	
								%>
									<option value="<%=ST_rs.getString("FIDocType")%>"><%=ST_rs.getString("FIDocType")%>(<%=ST_rs.getString("FIDocTypeDesc")%>)</option>
								<%
									}
									}catch(SQLException e){
										e.printStackTrace();
									}
								%>
								</select>
							</td>
						</tr>
				</table>
				<button class="Inquiry">조회</button>
			</div>
			<div class="UntSituation">
				<div class="Area_title">미승인전표 현황</div>
				<div class="ButtonArea">				
					<button>수정</button>
					<button>결재경로</button>
					<button>품의상신</button>
					<button>품의취소</button>
					<button>결재/합의</button>
				</div>
				<div class="UnApprovalDocArea">
					<table class="UnAppSlipTable">
						<th>항번</th><th>선택</th><th>기표일자</th><th>전표번호</th><th>적요</th><th>전표입력 BA</th>
						<th>전표입력부서</th><th>전표입력자</th><th>차변합계</th><th>대변합계</th><th>전표상태</th>
						<th>결재단계</th><th>결재/합의자</th><th>경과일수</th><th>전표유형</th>
					</table>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
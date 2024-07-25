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
    var TS_To = document.getElementById("TimeStamp_To");

    if (TS_From && TS_To) {
        TS_From.setAttribute("max", today);
        TS_To.setAttribute("max", today);
    } else {
        console.error("Element with id 'TimeStamp_From' or 'TimeStamp_To' not found.");
    }
});

$(document).ready(function(){
	var UId = $('.UserId').val();
	var UComCode = $('.UserComCode').val();
	$.ajax({
	    url: '${contextPath}/UnapprovalSlip/InfoSearch/UnWriterInfo.jsp',
	    type: 'POST',
	    data: { id: UId },
	    success: function(response) {
	        // response는 JSON 배열 형태로 받습니다.
	        if (response.length > 0) {
	            // JSON 배열의 첫 번째 요소를 사용합니다.
	            var data = response[0];
	            // HTML 입력 필드에 값을 배분합니다.
	            $('#UserBizArea').val(data.UserBA);
	            $('#UserDepartCd').val(data.UserCoct);
	        } else {
	            console.log("No data found.");
	        }
	    },
	    error: function(xhr, status, error) {
	        console.error("Ajax request failed: ", status, error);
	    }
	});
});
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
								<input type="text" class="UserComCode" name="UserComCode" id="UserComCode" value="<%=User_Depart%>" readonly>
							</td>
						</tr>
						<tr>
							<th>전표입력 BA : </th>
							<td>
								<a><input type="text" class="UserBizArea" name="UserBizArea" id="UserBizArea" readonly></a>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표입력부서 : </th>
							<td>
								<a><input class="UserDepartCd" name="UserDepartCd" id="UserDepartCd" readonly></a>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표 입력자 : </th>
							<td>
								<input type="text" class="UserId" name="UserId" id="UserId" value="<%=User_Id%>" readonly>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>결재 합의자 : </th>
							<td>
								<a><input readonly></a>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>기표일자(From) : </th>
							<td>
								<input type="date" class="TimeStamp" name="TimeStamp From" id="TimeStamp_From">
							</td>
						</tr>
						<tr>
							<th>기표일자(To) : </th>
							<td>
								<input type="date" class="TimeStamp" name="TimeStamp To" id="TimeStamp_To">
							</td>
						</tr>
						<tr>
							<th>미승인전표 상태 : </th>
							<td>
								<a><input readonly></a>
								<button>&#8681;</button>
							</td>
						</tr>
						<tr>
							<th>전표유형 : </th>
							<td>
								<a><input readonly></a>
								<button>&#8681;</button>
							</td>
						</tr>
				</table>
				<div class="GuideArea">
						<li>
							<ul>
								<b>※ 전표상태</b>
								<li>A 미상신</li>
								<li>B 결재 진행중</li>
								<li>C 승인 완료</li>
								<li>D 결재 반려</li>
								<li>Z 불완전전표</li>
							</ul>
						</li>
				</div>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<title>Insert title here</title>
</head>
<%
	String User_Id = (String)session.getAttribute("id");
	String User_Depart = (String)session.getAttribute("depart");
	String SlipCode = request.getParameter("EnrtyNumber");
%>
<script type="text/javascript">
$(document).ready(function(){
	var ApproveSlip = $('.SlipCode').val();
	console.log(ApproveSlip);
	$.ajax({
		url: '${contextPath}/UnapprovalSlip/InfoSearch/TotalSlipInfo.jsp',
		type: 'POST',
		data: {Slip : ApproveSlip},
		/* contentType: 'application/json; charset=utf-8', */
		dataType: 'json',
		async: false,
		success: function(response){
			// HeadInfo 배열 처리
			console.log("성공");
	        var headArray = response.HeadInfo;
	        $.each(headArray, function(index, headInfo) {
	            console.log("Head Info: ", headInfo);
	            // headInfo에서 데이터를 다루는 로직 추가
	        });

	        // LineInfo 배열 처리
	        var lineArray = response.LineInfo;
	        $.each(lineArray, function(index, lineInfo) {
	            console.log("Line Info: ", lineInfo);
	            // lineInfo에서 데이터를 다루는 로직 추가
	        });
		},
	    error: function(xhr, status, error) {
	        console.error('AJAX 요청 실패:', status, error);
	        console.error('서버 응답:', xhr.responseText);
	    }
		
	})
});
</script>
<body>
<div class="BodyArea">
	<div class="AppAgreeHeader">
		<div class=Area_title>전표 Header</div>
		<table class="UserInfo">
						<tr>
							<th>법인(ComCode) : </th>
							<td>
								<input type="text" class="CompanyCode" name="CompanyCode" id="CompanyCode" readonly>
							</td>
						</tr>
						<tr>
							<th>전표입력 BA : </th>
							<td>
								<input type="text" class="SlipBA" name="SlipBA" id="SlipBA">
							</td>
						</tr>
						<tr>
							<th>전표입력부서 : </th>
							<td>
								<a><input type="text" class="SlipCoCt" name="SlipCoCt" id="SlipCoCt" readonly></a>
							</td>
						</tr>
						<tr>
							<th>전표 입력자 : </th>
							<td>
								<a><input class="SlipWriter" name="SlipWriter" id="SlipWriter" readonly></a>
							</td>
						</tr>
						<tr>
							<th>전표 유형 : </th>
							<td>
								<input type="text" class="SlipType" name="SlipType" id="SlipType" readonly>
							</td>
						</tr>
						<tr>
							<th>전표 번호 : </th>
							<td>
								<input type="text" class="SlipCode" name="SlipCode" id="SlipCode" value=<%=SlipCode%> readonly>
							</td>
						</tr>
						<tr>
							<th>기표일자 : </th>
							<td>
								<input type="text" class="InpuuDate" name="InpuuDate" id="InpuuDate" readonly>
							</td>
						</tr>
				</table>
	</div>
	<div class="AppAgreeLine">
		<div class="Area_title">전표 Line</div>
		<div class="AppAgreBtnArea">
			<button onclick="">승인/합의</button>
			<button onclick="">반려</button>
		</div>
	</div>
</div>
</body>
</html>
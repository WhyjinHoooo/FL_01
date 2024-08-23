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
	           console.log(headArray[index].H_ComCode);
	           $('.CompanyCode').val(headArray[index].H_ComCode);
	           $('.SlipBA').val(headArray[index].H_BA);
	           $('.SlipCoCt').val(headArray[index].H_CoCt);
	           $('.SlipWriter').val(headArray[index].H_Inputer);
	           $('.SlipType').val(headArray[index].H_Type);
	           $('.InpuuDate').val(headArray[index].H_Date);
	        });

	        // LineInfo 배열 처리
	        var Table_Body = $('.FinalAppTable tbody');
	        var lineArray = response.LineInfo;
	        $.each(lineArray, function(index, lineInfo) {
	            console.log("Line Info: ", lineInfo);
	            // lineInfo에서 데이터를 다루는 로직 추가
	            console.log(lineArray.length);
	            console.log(lineArray[index].L_Account);
	            var row = '<tr>' +
	            '<td>' + (index + 1) + '</td>' +
	            '<td input class="L_GLAcc name="L_GLAcc">' + lineArray[index].L_Account + '</td>' + 
	            '<td input class="L_GLAcc_Des" name="L_GLAcc_Des">' + lineArray[index].L_AccountDes + '</td>' + 
	            '<td input class="L_DC" name="L_DC">' + lineArray[index].L_CD + '</td>' + 
	            '<td input class="L_TransMoney" name="L_TransMoney">' + lineArray[index].L_TransMoney + '</td>' + 
	            '<td input class="L_TransUnit" name="L_TransUnit">' + lineArray[index].L_TransUnit + '</td>' + 
	            '<td input class="L_LocalMoney" name="L_LocalMoney">' + lineArray[index].L_LocalMoney + '</td>' + 
	            '<td input class="L_LocalUnit" name="L_LocalUnit">' + lineArray[index].L_LocalUnit + '</td>' + 
	            '<td input class="L_Rate" name="L_Rate">' + lineArray[index].L_Rate + '</td>' + 
	            '<td input class="L_CostCenter" name="L_CostCenter">' + lineArray[index].L_CoCt + '</td>' + 
	            '<td input class="L_BizArea" name="L_BizArea">' + lineArray[index].L_Ba + '</td>' + 
	            '<td input class="L_Comment" name="L_Commant">' + lineArray[index].L_Des + '</td>' + 
	            '<td>' + "asd" + '</td>';
	            
	            row += '</tr>';
	            
	            Table_Body.append(row)
	        });
		},
	    error: function(xhr, status, error) {
	        console.error('AJAX 요청 실패:', status, error);
	        console.error('서버 응답:', xhr.responseText);
	    }
		
	})
});
</script>
<script>
function ApprovalBtn(event, Action){
	event.preventDefault();
	
	var popupWidth = 750;
    var popupHeight = 400;
    
    // 현재 활성화된 모니터의 위치를 감지
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    // 전체 화면의 크기를 감지
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
    var SlipCode = $('.SlipCode').val();
    
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
    switch(Action){
    case "Agree":
    	yPose = 150;
    	var popup = window.open(
					"${contextPath}/UnapprovalSlip/DispositionPopUp.jsp?SlipCode=" + SlipCode, 
					"DispositionPopUp", 
		            "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
		            );
    	var timer = setInterval(function(){
    		if (dispositionPopup.closed) {
                clearInterval(timer);
                alert("결재 의견을 등록했습니다.");
                window.close(); // AppAgree.jsp 팝업을 닫습니다.
            }
    	}, 500);
    	break;
    case "Cancel":
    	yPose = 150;
    	var popup = window.open(
				"${contextPath}/UnapprovalSlip/CancelPopUp.jsp?SlipCode=" + SlipCode, 
				"CancelPopUp", 
	            "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos
	            );
	var timer = setInterval(function(){
		if (dispositionPopup.closed) {
            clearInterval(timer);
            alert("반려 의견을 등록했습니다.");
            window.close(); // AppAgree.jsp 팝업을 닫습니다.
        }
	}, 500);
    	break;
    }
}
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
								<input type="text" class="SlipBA" name="SlipBA" id="SlipBA" readonly>
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
			<button onclick="ApprovalBtn(event, 'Agree')">승인/합의</button>
			<button onclick="ApprovalBtn(event, 'Cancel')">반려</button>
		</div>
		<div class="FinalAppLineTable">
			<table class="FinalAppTable" id="FinalAppTable">
				<thead>
					<th>항번</th><th>G/L Account</th><th>Account Des</th><th>Debot/Credit</th>
					<th>Transaction Amount</th><th>Trans. Currancy</th><th>Local Amount</th><th>Local Currancy</th>
					<th>Enchange Rate</th><th>Cost Center</th><th>Biz Area</th><th>적요</th><th>관리항목</th>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
</html>
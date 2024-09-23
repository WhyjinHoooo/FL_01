<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="${contextPath}/css/RightCss.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
function PickOption(field){
    var popupWidth = 515;
    var popupHeight = 600;
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    // 전체 화면의 크기를 감지
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
	var U_ComCode = $('.UserComCode').val();
	console.log("U_ComCode : " + U_ComCode);
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
    if(field === "BizArea"){
    	window.open("${contextPath}/Authority/BizArea.jsp?ComCode="+U_ComCode, "BAPopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } else if(field === "BizAreaGroup"){
    	popupWidth = 900;
    	window.open("${contextPath}/Authority/BizAreaGro.jsp?ComCode="+U_ComCode, "BAGPopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } 
};

$(document).ready(function(){
    $('.BizAreaCode').prop('disabled', false);
    $('.BizAreaName').prop('disabled', false);
    $('.BizAreaGroCode').prop('disabled', true);
    $('.BizAreaGroName').prop('disabled', true);
    
	$('.GroupDiv').change(function(){
        var G_Div = $(this).val();
        GroupSelect(G_Div);
    });
	function GroupSelect() {
	    var GroValue = $('.GroupDiv:checked').val();
	    console.log(GroValue);

	    // 비활성화할 필드와 활성화할 필드 정의
	    var disableFields = GroValue === 'BA' ? 
	        ['.BizAreaGroCode', '.BizAreaGroName'] :
	        ['.BizAreaCode', '.BizAreaName'];

	    var enableFields = GroValue === 'BA' ?
	        ['.BizAreaCode', '.BizAreaName'] :
	        ['.BizAreaGroCode', '.BizAreaGroName'];

	    // 필드 활성화 및 비활성화
	    $(disableFields.join(', ')).prop('disabled', true).val('');
	    $(enableFields.join(', ')).prop('disabled', false).val('');
	    /* 
	    disableFields.join(', ')는 GroValue의 값에 따라 .BizAreaGroCate, .BizAreaGroName 또는 .BizAreaCate, .BizAreaName가 될 수 있다.
	    근데, disableFields.join(', ')가 $(...)에 둘러 싸여 있어서, 클래스로 형번환되고 , .prop('disabled', true).val('')가 마치 수학의 분배법칙처럼 적용
	    */
	}
	$('.UserDuty').change(function(){
		var testValue = $(this).val();
		console.log(testValue);
		var Des = testValue.split(",");
		$('.UserDutyDes').val(Des[1]);
	});
	$('.BizAreaCode, .BizAreaGroCode').change(function(){
		var Value = $(this).val();
		var SysDute = $('.UserDuty').val().split(",")[0];
		console.log(SysDute);
		const ResetValue = [$('.BizAreaCode'), $('.BizAreaName'), $('.BizAreaGroCode'), $('.BizAreaGroName')];
		if(SysDute == '없음' || SysDute == null || SysDute == ''){
			alert('수행 직무를 선택해 주세요.');
			ResetValue.forEach(input => input.val(''));
			return false;
		}
		$.ajax({
			url: '${contextPath}/Authority/SysDuteExpose.jsp',
			type: 'POST',
			data: {SelDute : SysDute},
			success: function(response){
			    // 테이블의 tbody에 데이터를 추가
			    console.log('ajax 성공01');
			    console.log('response : ', response);
			    let tableBody = $('.AccessTable_Body');
			    tableBody.empty(); // 기존 내용을 비우고 새로 추가
			    console.log('ajax 성공02');
			    console.log(response);
			    response.forEach(function(item) {	
			    	console.log('Item:', item);
			        let row = '<tr>' +
			            '<td>' + item.RnRCode + '</td>' +
			            '<td>' + item.RnRDescp + '</td>' +
			            '<td>' + item.UiGroupDescrip + '</td>' +
			            '<td>' + item.UiGroup2LvList.join(', ') + '</td>' + // Lv2 배열을 문자열로 변환
			            '<td>' + item.UiGroup3LvList.join(', ') + '</td>' + // Lv3 배열을 문자열로 변환
			            '<td>' + item.UiGroup4LvList.join(', ') + '</td>' + // Lv4 배열의 설명
			            '<td><select>' +
			                item.UiGroup4LvList.map(function(ui) {
			                    return '<option value="' + ui.UiNumber + '">' + ui.UiDescrip + '</option>';
			                }).join('') +
			            '</select></td>' +
			            '</tr>';
			        
			        tableBody.append(row);
			    });
			}
		});
	});
	
})
</script>
<title>Insert title here</title>
</head>
<body>
<%
	String id = (String)session.getAttribute("id");
	String name = (String)session.getAttribute("name");
	String ComCode = (String)session.getAttribute("depart");
%>
<div class="AccessArea">
	<div class="UserInfoArea">
		<div class="UInfiInputArea">
			<div class="UserInfo">
				<label>사용자 아이디 :</label> 
				<input type="text" class="UserId MainInfo" name="UserId" value="<%=id %>" readonly>
				<input type="text" class="UserName SubInfo" name="UserName" value="<%=name %>" readonly>
				<input type="text" class="UserComCode" name="UserComCode" value="<%=ComCode %>" hidden>
			</div>
			<div class="UserInfo">
				<label>수행 직무 :</label> 
				<select class="UserDuty" name="UserDuty">
					<option>없음</option>
					<%
					try{
						String sql = "SELECT * FROM sys_dute";
						PreparedStatement pstmt = conn.prepareStatement(sql);
						ResultSet rs = pstmt.executeQuery();
						while(rs.next()){
					%>
						<option value="<%=rs.getString("RnRCode")%>,<%=rs.getString("RnRDescp")%>"><%=rs.getString("RnRCode")%></option>
					<%
						}
					}catch(SQLException e){
						e.printStackTrace();
					}
					%>
				</select>
				<input type="text" class="UserDutyDes" name="UserDutyDes" checked>
			</div>
			<div class="UserInfo">
				<label>권한부여 조직구분 :</label> 
				<input type="radio" class="GroupDiv" name="GroupDiv" value="BA" checked><span>BizArea</span>
				<input type="radio" class="GroupDiv" name="GroupDiv" value="BAG"><span>BizArea Group</span>
			</div>
			<div class="UserInfo">
				<label>Biz Area :</label>
				<input type="text" class="BizAreaCode MainInfo" name="BizAreaCode" id="BizAreaCode" onclick="PickOption('BizArea')" readonly>
				<input type="text" class="BizAreaName SubInfo" name="BizAreaName" id="BizAreaName" readonly>
			</div>
			<div class="UserInfo">
				<label>BizArea Group :</label> 
				<input type="text" class="BizAreaGroCode MainInfo" name="BizAreaGroCode" id="BizAreaGroCode" onclick="PickOption('BizAreaGroup')" readonly>
				<input type="text" class="BizAreaGroName SubInfo" name="BizAreaGroName" id="BizAreaGroName" readonly>
			</div>
		</div>
	</div>
	<div class="AccessInfoArea">
		<table class="AccessTable">
			<thead class="AccessTable_Head">
				<th>시스템 직무코드</th><th>직무명</th><th>직무화면그룹01</th><th>직무화면그룹02</th><th>직무화면그룹03</th><th>화면번호</th><th>기본권한</th>
			</thead>
			<tbody class="AccessTable_Body">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
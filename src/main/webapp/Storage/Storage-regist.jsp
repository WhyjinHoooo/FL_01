 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<title>Storage Location 등록</title>
<link rel="stylesheet" href="../css/style.css?after">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
function InfoSearch(field){
	var popupWidth = 500;
    var popupHeight = 600;
    
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
    
	var ComCode = document.querySelector('.ComCode').value;
	
	switch(field){
	case "ComSearch":
		window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
		break;
	case "PlantSearch":
		window.open("${contextPath}/Information/PlantSerach.jsp?ComCode=" + ComCode, "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
		break;
	case "StorageSearch":
		window.open("${contextPath}/Information/StorageSerach.jsp", "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
		break;
	}
}
$(document).ready(function(){
	$('.ComCode').change(function(){
		$('.Plant_Select').val('');
		$('.Plant_Name').val('');
		$('.Plant_Select').attr('placeholder','SELECT')
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
				url:'${contextPath}/Storage/Storage-regist-Ok.jsp',
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
							if(name === 'ComCode' || name === 'Plant_Select' || name === 'Stor_Code'){
								$(this).val('');
						        $(this).attr('placeholder', 'SELECT');
							} else if(name === 'Rack_YN' || name === 'Bin_YN' || name === 'Code_YN'){
								$(this).find('option:first').prop('selected', true);
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
	})
})
</script>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
	<!-- <form id="StorageResgistForm" name="StorageResgistForm" action="Storage-regist-Ok.jsp" method="post" enctype="UTF-8"> -->
		<div class="storage-main-info">
			<div class="table-container">
				<table>
					<tr><th class="info">StorageLocal ID : </th>
						<td class="input-info">
							<input type="text" class="Storage_Id KeyInfo" name="Storage_Id" size="10">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Description : </th>
						<td class="input-info">
							<input type="text" class="Des KeyInfo" name="Des" size="50">
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<button class="Info-input-btn" id="btn">Insert</button>
		
		<div class="storage-sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Company Code : </th>
						<td class="input-info">
							<input type="text" class="ComCode KeyInfo" name="ComCode" onclick="InfoSearch('ComSearch')" placeholder="선택" readonly>
						<input type="text" class="Com_Name KeyInfo" name="Com_Name" readonly>
					</td>	

					</tr>
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Plant : </th>
						<td class="input-info">
							<input type="text" class="Plant_Select KeyInfo" name="Plant_Select" onclick="InfoSearch('PlantSearch')" placeholder="선택" readonly>
							<input type="text" class="Plant_Name KeyInfo" name="Plant_Name" readonly>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Storage Location Type : </th>
						<td class="input-info">
						<input type="text" class="Stor_Code KeyInfo" name="Stor_Code" placeholder="선택" onclick="InfoSearch('StorageSearch')" readonly>
							<input type="text" class="Stor_Des KeyInfo" name="Stor_Des" readonly>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Rack 사용 여부 : </th>
						<td class="input-info">
							<input type="radio" class="Rack_YN KeyInfo" name="Rack_YN" value="true" checked>사용
							<input type="radio" class="Rack_YN KeyInfo"name="Rack_YN" value="false">미사용
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Bin 사용 여부 : </th>
						<td class="input-info">
							<input type="radio" class="Bin_YN KeyInfo" name="Bin_YN" value="true" checked>사용
							<input type="radio" class="Bin_YN KeyInfo" name="Bin_YN" value="false">미사용
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">창고코드 사용 여부 : </th>
						<td class="input-info">
							<input type="radio" class="Code_YN KeyInfo"name="Code_YN" value="true" checked>사용
							<input type="radio" class="Code_YN KeyInfo"name="Code_YN" value="false">미사용
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
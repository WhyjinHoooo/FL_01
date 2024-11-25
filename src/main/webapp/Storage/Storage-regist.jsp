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
<script type='text/javascript'>
window.addEventListener('DOMContentLoaded', (event) => {
    const comCodeInput = document.querySelector('.ComCode');
    const comNameInput = document.querySelector('.Com_Name');
    const plantSelectInput = document.querySelector('.Plant_Select');
    const plantNameInput = document.querySelector('.Plant_Name');

    const resetPlantInputs = () => {
        plantSelectInput.value = '';
        plantNameInput.value = '';
    };

    comCodeInput.addEventListener('change', resetPlantInputs);
    comNameInput.addEventListener('change', resetPlantInputs);
});
function InfoSearch(field){
	var popupWidth = 1000;
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
</script>
<body>
	<h1>Storage Location 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="StorageResgistForm" name="StorageResgistForm" action="Storage-regist-Ok.jsp" method="post" enctype="UTF-8">
			<div class="storage-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">StorageLocal ID : </th>
							<td class="input-info">
								<input type="text" class="Storage_Id" name="Storage_Id" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" class="Des" name="Des" size="50">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="storage-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input-info">
								<input type="text" class="ComCode" name="ComCode" onclick="InfoSearch('ComSearch')" placeholder="선택" readonly>
								<input type="text" class="Com_Name" name="Com_Name" readonly>
							</td>	
						</tr>

						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Plant : </th>
							<td class="input-info">
								<input type="text" class="Plant_Select" name="Plant_Select" onclick="InfoSearch('PlantSearch')" placeholder="선택" readonly>
								<input type="text" class="Plant_Name" name="Plant_Name" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Storage Location Type : </th>
							<td class="input-info">
							<input type="text" class="Stor_Code" name="Stor_Code" placeholder="선택" onclick="InfoSearch('StorageSearch')" readonly>
								<input type="text" class="Stor_Des" name="Stor_Des" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Rack 사용 여부 : </th>
							<td class="input-info">
								<input type="radio" name="Rack_YN" value="true" checked>사용
								<input type="radio" name="Rack_YN" value="false">미사용
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Bin 사용 여부 : </th>
							<td class="input-info">
								<input type="radio" name="Bin_YN" value="true" checked>사용
								<input type="radio" name="Bin_YN" value="false">미사용
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">창고코드 사용 여부 : </th>
							<td class="input-info">
								<input type="radio" name="Code_YN" value="true" checked>사용
								<input type="radio" name="Code_YN" value="false">미사용
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
	</center>
</body>
</html>
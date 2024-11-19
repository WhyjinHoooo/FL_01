<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>   
<%@ page import="java.sql.*" %>
<%@page import="java.sql.SQLException"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Cost Center Group Regist</title> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/path/to/jquery.min.js"></script> 
<script type="text/javascript"> 
	window.onload = function() { 
		document.querySelector('.Com-code').addEventListener('change', function() { 
		var v = this.value; 
		document.querySelector('input[name="tccg"]').value = v; 
		});  
	};
	
function InfoSearch(field){
	event.preventDefault();
	
	var popupWidth = 1000;
    var popupHeight = 600;
    
    // 현재 활성화된 모니터의 위치를 감지
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    console.log(dualScreenLeft);
    // 전체 화면의 크기를 감지
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
    var UserComCode = $('.Com-code').val();
    
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
    
    switch(field){
    case "ComSearch":
    	window.open("${contextPath}/Information/ComSearch.jsp", "PopUp", "width=600,height=495, left=500 ,top=" + yPos);
    	break;
    case "GetLevel":
    	var Code = document.querySelector('.Com-code').value;
    	window.open("${contextPath}/Information/GetLevel.jsp?ComCd=" + Code, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
    	break;
    case "CCTSearch":
    	var Code = document.querySelector('.Com-code').value;
	    var lv = document.querySelector('.CCTR-level').value;
    	window.open("${contextPath}/Information/UpCCTSearch.jsp?ComCode=" + Code + "&Level=" + lv, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
    }
}
</script>
</head>
<body>
	<h1>Cost Center Group 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="CCG_RegistForm" name="CCG_RegistForm" action="CCG-Regist-Ok.jsp" method="post" onSubmit="" encType="UTF-8">
			<div class="ccg-main-info">
				<div class="table-container">
					<table>
						<tr><th class="infp">Cost Center Group : </th>
							<td class="input-info">
								<input type="text" size="10" name="CCG">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description: </th>
							<td class="input-info">
								<input type="text" size="41" name="Des">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="ccg-sub-info">
				<div class="table-container">
					<table>
						<tr><th>Company Code : </th>
							<td class="input-info">
								<input type="text" class="Com-code" name="Com-Code" placeholder="SELECT" onclick="InfoSearch('ComSearch')" readonly >
							<th class="info">Top Cost Center Group : </th>
								<td>
									<input type="text" class="tccg" name="tccg" readonly size="10'">
								</td>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info"> CCTR Group Level : </th>
							<td class="input_info">
								<input type="text" class="CCTR-level" id="CCTRlvlSelected" name="CCT-level" placeholder="SELECT" onclick="InfoSearch('GetLevel')" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<script src="http://code.jquery.com/jquery-latest.js"></script> 
						 
						<tr><th class="info"> Upper CCT_Group : </th>
							<td class="input_info">
								<input type="text" class="Upper-CCT-Group" id="Upper-CCT-Group" name="Upper-CCT-Group" placeholder="SELECT" onclick="InfoSearch('CCTSearch')" readonly>
									<th class="info">Description : </th>
									<td>
										<input type="text" class="Upper-Cct-Name" name="Upper-Cct-Name" readonly>
									</td>								
							</td>
						</tr>
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">사용 여부: </th>
							<td class="input_info">
									<input type="radio" class="InputUse" name="Use-Useless" value="true" checked>사용
									<span class="spacing"></span>
									<input type="radio" class="InputUse" name="Use-Useless" value="false">미사용								
								</select>
							</td>
						</tr>						 
					</table>
				</div>
			</div>
		</form>
	</center>
</body>
</html>
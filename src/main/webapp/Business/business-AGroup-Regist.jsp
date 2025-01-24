<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Business Area Group 등록</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 

<script>
function InfoSearch(field){
	var popupWidth = 460;
	var popupHeight = 600;
	
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
	    
	switch(field){
	case "ComSearch":
		window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
		break;
	}
}
function sendData(Biz_level, CompanyCode) {
    console.log('Biz_level: ' + Biz_level);
    console.log('Company Code: ' + CompanyCode);
    $.ajax({
        type: 'POST',
        url: 'business-AGroup-LevelChange.jsp',
        data: { 
            Level: Biz_level, // 해당 기업 코드
            ComCode: CompanyCode // 입력 페이지에서 선택한 기업 코드
        },
        success: function(response) {
            response = JSON.parse(response);
            var options = '';
            for(var i=0; i<response.length; i++){
                if (response[i].BAGroup !== undefined && response[i].BAG_Name !== undefined) {
                    options += '<option value="' + response[i].BAG_Name + '">' + response[i].BAGroup + '</option>';
                } else {
                    console.error('응답의 ' + i.toString() + '번째 항목에 ComCode 속성이 없습니다:', response[i]);
                }
            }
            $('#Upper-Biz-level').html(options);
            $('select[name="Upper-Biz-level"]').change(function() {
                 var selectedOption = $(this).children("option:selected");
                 $('input[name="Upper-Biz-Name"]').val(selectedOption.val());
             });
            $('#Upper-Biz-level').prop('selectedIndex', 0).change();
         }
     });
}
$(document).ready(function() {
	var ChkList = {};
	$('.ComCode').change(function() {
		var selectedCode = $(this).val();
		$.ajax({
			type: 'POST',
			url: 'getMaxLevel.jsp',
			data: {ComCode: selectedCode},
			success: function(response) {
				var maxLevel = response;
				var options = '';
				for(var i=1; i<=maxLevel; i++){
					options += '<option value="' + i + '">' + i + ' Level</option>';
				}                
			$('.Biz-level').html(options);
			}
		});
		
		var Biz_level = 1;
        var CompanyCode = $(this).val();
        
        sendData(Biz_level, CompanyCode);
	});
	
    $('.Biz-level').change(function(){
        var Biz_level = $(this).val();
        var CompanyCode = $('.ComCode').val();
        
        sendData(Biz_level, CompanyCode);
    });
    
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
    	var pass = true;
    	$.each(ChkList,function(key, value){
    		if(value == null || value === ''){
    			pass = false;
    			return false;
    		}
    	})
    	if(!pass){
    		alert('모든 항목을 입력해주세요.');
    	}else{
    		$.ajax({
				url:'${contextPath}/Business/BAG-Regist-Ok.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
					if(data.status === 'Success'){
					alert('회사가 등록되었습니다.');
					$('.KeyInfo').each(function(){
						var name = $(this).attr('name');
						if(name === 'ComCode'){
							$(this).val('');
						       $(this).attr('placeholder', 'SELECT');
						} else if(name === 'Biz-level' || name === 'Upper-Biz-level'){
							$('#' + name).html('<option value="">선택</option>');
						} else if(name === 'Use-Useless'){
							$('input[type="radio"][value="true"]').prop('checked', true);
						} else{
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
});
</script>
</head>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
		<div class="bag-main-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Business Area Group : </th>
						<td class="input-info">
							<input class="KeyInfo" type="text" name="bag" size="10">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Description : </th>
						<td class="input-info">
							<input class="KeyInfo" type="text" name="bag-des" size="41">
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<button class="Info-input-btn" id="btn">Insert</button>
		
		<div class="bag-sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Company Code : </th>
						<td class="input_info">
							<input type="text" class="ComCode KeyInfo" name="ComCode" placeholder="SELECT" onclick="InfoSearch('ComSearch')" readonly>
							<th class="info">Top Biz.Area Group : </th>
							<td>
								<input type="text" class="Com_Name KeyInfo" name="Com_Name" readonly>
							</td>
						</td>
					</tr>
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Biz.Group Level : </th>
						<td class="input_info">
							<select class="Biz-level KeyInfo" id="Biz-level" name="Biz-level">
								<option value="">선택</option>
							</select>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>

					<tr><th class="info"> Upper Biz,Group : </th>
						<td class="input_info">
							<select class="Upper-Biz-level KeyInfo" id="Upper-Biz-level" name="Upper-Biz-level">
								<option value="">선택</option>
							</select>
								<th class="info">Description : </th>
								<td>
									<input type="text" class="Upper-Biz-Name KeyInfo" name="Upper-Biz-Name" readonly>
								</td>
						</td>
					</tr>

					<tr class="spacer-row"></tr>
					
					<tr><th class="info">사용 여부: </th>
						<td class="input_info">
							<input type="radio" class="InputUse KeyInfo" name="Use-Useless" value="true" checked>사용
							<span class="spacing"></span>
							<input type="radio" class="InputUse KeyInfo" name="Use-Useless" value="false">미사용
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
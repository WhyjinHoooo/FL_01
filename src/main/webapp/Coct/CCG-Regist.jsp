<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
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
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<%-- <script src="<%=request.getContextPath()%>/path/to/jquery.min.js"></script>  --%>
<script>
function InfoSearch(field){
	event.preventDefault();
	
	var popupWidth = 500;
    var popupHeight = 600;
    var Code = $('.ComCode').val();
    var lv = $('.CCTR-level').val();

    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    console.log(dualScreenLeft);

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
    	window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ", left=" + xPos + ",top=" + yPos);
    	break;
    case "CCTSearch":
    	window.open("${contextPath}/Information/UpCCTSearch.jsp?ComCode=" + Code + "&Level=" + lv, "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ", left=" + xPos + ",top=" + yPos);
    }
}
$(document).ready(function(){
	var ChkList = {};
	$('.ComCode').change(function() {
		var selectedCode = $(this).val();
		var ClassType = 'CCG';
		$.ajax({
			type: 'POST',
			url: '${contextPath}/Information/AjaxSet/SelectMaxLevel.jsp',
			data: {ComCode: selectedCode , Cate : ClassType},
			success: function(response) {
				var maxLevel = response;
				var options = '';
				for(var i=1; i<=maxLevel; i++){
					options += '<option value="' + i + '">' + i + ' Level</option>';
				}                
			$('.CCTR-level').html(options);
			}
		});
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
				url:'${contextPath}/Coct/CCG-Regist-Ok.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
					if(data.status === 'Success'){
						$('.KeyInfo').each(function(){
							var name = $(this).attr('name');
							if(name === 'ComCode' || name === 'Upper-CCT-Group'){
								$(this).val('');
								$(this).attr('placeholder', 'SELECT');
							} else if(name === 'CCTR-level'){
								$('#' + name).html('<option value="">선택</option>');
							}else if(name === 'Use-Useless'){
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
})
</script>
</head>
<body>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center class="testCenter">
		<div class="ccg-main-info">
			<div class="table-container">
				<table>
					<tr><th class="infp">Cost Center Group : </th>
						<td class="input-info">
							<input type="text" class="KeyInfo" size="10" name="CCG">
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Description: </th>
						<td class="input-info">
							<input type="text" class="KeyInfo" size="41" name="Des">
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
							<input type="text" class="ComCode KeyInfo" name="ComCode" placeholder="SELECT" onclick="InfoSearch('ComSearch')" readonly >
						<th class="info">Top Cost Center Group : </th>
							<td>
								<input type="text" class="Com_Name KeyInfo" name="Com_Name" readonly>
							</td>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info"> CCTR Group Level : </th>
						<td class="input_info">
							<select class="CCTR-level KeyInfo" id="CCTR-level" name="CCTR-level">
								<option value="">선택</option>
							</select>
						</td>
					</tr>
					
					<tr class="spacer-row"></tr>
					 
					<tr><th class="info"> Upper CCT_Group : </th>
						<td class="input_info">
							<input type="text" class="Upper-CCT-Group KeyInfo" id="Upper-CCT-Group" name="Upper-CCT-Group" placeholder="SELECT" onclick="InfoSearch('CCTSearch')" readonly>
								<th class="info">Description : </th>
								<td>
									<input type="text" class="Upper-Cct-Name KeyInfo" name="Upper-Cct-Name" readonly>
								</td>								
						</td>
					</tr>
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">사용 여부: </th>
						<td class="input_info">
								<input type="radio" class="InputUse KeyInfo" name="Use-Useless" value="true" checked>사용
								<span class="spacing"></span>
								<input type="radio" class="InputUse KeyInfo" name="Use-Useless" value="false">미사용								
							</select>
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
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<script src="<%=request.getContextPath()%>/path/to/jquery.min.js"></script> 

<script type="text/javascript">
	window.onload = function() { 
		document.querySelector('.Com-code').addEventListener('change', function() { 
		var v = this.value; 
		document.querySelector('input[name="ComName_input"]').value = v; 
		});  
	};  
	$(document).ready(function() {
		$('.Com-code').change(function() {
			var selectedCode = $(this).val();
			console.log('selectedCode: ' + selectedCode);
					
			$.ajax({
				type: 'POST',
				url: 'getMaxLevel.jsp',  // 요청을 보낼 JSP 파일의 URL
				data: {ComCode: selectedCode}, // 선택된 회사 코드
				success: function(response) {
					// 서버로부터 받은 응답 처리
					var maxLevel = response;  // 응답은 최대 레벨이어야 함
					var options = '';
					for(var i=1; i<=maxLevel; i++){
						options += '<option value="' + i + '">' + i + ' Level</option>';
					}                
				$('.Biz-level').html(options);
				}
			});
		});
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
	         $('select[name="Upper-Biz-level"]').change(function() {
	             var selectedOptionValue = $(this).val();
	         });
	    }
	    
	    $('.Biz-level').change(function(){
	        var Biz_level = $(this).val();
	        var CompanyCode = $('.Com-code').val();
	        
	        sendData(Biz_level, CompanyCode);
	    });
	    
	    $('.Com-code').change(function(){
	        var Biz_level = 1;
	        var CompanyCode = $(this).val();
	      	
	        console.log('Biz_level : ' + Biz_level);
	        console.log('CompanyCode : ' + CompanyCode);
	        
	        sendData(Biz_level, CompanyCode);
	        
	        $('input[name="ComName_input"]').val('');
	         
	        // Description 초기화 추가
	        $('input[name="Upper-Biz-Name"]').val('');
	    });
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
	    
	    switch(field){
	    case "ComSearch":
	    	window.open("${contextPath}/Information/ComSearch.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	    	break;
	    }
	}
</script>
</head>
<body>
	<h1>Business Area Group 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="Bag_registform" name="Bag_registform" action="BAG-Regist-Ok.jsp" method="post" onSubmit="" encType="UTF-8">
			<div class="bag-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Business Area Group : </th>
							<td class="input-info">
								<input type="text" name="bag" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" name="bag-des" size="41">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="bag-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input_info">
								<!-- <a href="javascript:ComSearch()"><input type="text" class="Com-code" name="Com-code" placeholder="SELECT" readonly></a> -->
									<input type="text" class="Com-code" name="Com-code" placeholder="SELECT" onclick="InfoSearch('ComSearch')" readonly>
									<th class="info">Top Biz.Area Group : </th>
									<td>
										<input type="text" name="ComName_input" readonly>
									</td>
							</td>
						</tr>
						
					
						
						<tr class="spacer-row"></tr>
						<tr><th class="info">Biz.Group Level : </th>
							<td class="input_info">
								<select class="Biz-level" id="BizlevelSelected" name="Biz-level">
									<option value="">선택</option>
								</select>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						<!-- END -->
						<tr><th class="info"> Upper Biz,Group : </th>
							<td class="input_info">
								<select class="Upper-Biz-level" id="Upper-Biz-level" name="Upper-Biz-level">
									<option value="">선택</option>
								</select>
									<th class="info">Description : </th>
									<td>
										<input type="text" name="Upper-Biz-Name" readonly>
									</td>
							</td>
						</tr>	
						
						
						<!-- TEST END -->
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
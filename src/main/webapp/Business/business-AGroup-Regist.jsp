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
	 </script>
	<script type="text/javascript">
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
			
		});
		
		function ComSearch(){
		    var xPos = (window.screen.width-2560) / 2;
		    var yPos = (window.screen.height-1440) / 2;
		    
		    window.open("${contextPath}/Information/ComSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
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
								<a href="javascript:ComSearch()"><input type="text" class="Com-code" name="Com-code" placeholder="SELECT" readonly></a>
									<th class="info">Top Biz.Area Group : </th>
									<td>
										<input type="text" name="ComName_input" readonly>
									</td>
							</td>
						</tr>
						
					
						
						<tr class="spacer-row"></tr>
						<!-- TEST START -->
						<!-- START -->
						<tr><th class="info">Biz,Group Level : </th>
							<td class="input_info">
								<select class="Biz-level" id="BizlevelSelected" name="Biz-level">
									<option value="">선택</option>
								</select>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						
						
						<script type="text/javascript">
						$(document).ready(function(){
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
						                    if (response[i].ComCode !== undefined && response[i].BAGroup !== undefined) {
						                        options += '<option value="' + response[i].BAGroup + '">' + response[i].ComCode + '</option>';
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
						             /* var selectedOptionText = $(this).children("option:selected").text();
						             
						             $('input[name="Upper-Biz-Name"]').val(selectedOptionValue); */
						             
						             // Description 값을 설정하는 코드 추가
						            /* $('.biz-group-description').each(function() {
						                 if ($(this).data('group') === selectedOptionText) {
						                     var description = $(this).data('description');
						                     $('input[name="bag-des"]').val(description);
						                     return false;
						                 }
						             }); */
						         });
						    }
						    
						    $('.Biz-level').change(function(){
						        var Biz_level = $(this).val();
						        var CompanyCode = $('.Com-code').val();
						        
						        sendData(Biz_level, CompanyCode);
						    });
						    
						    $('.Com-code').change(function(){
						        //var Biz_level = $('.Biz-level').val();
						        var Biz_level = 1;
						        var CompanyCode = $(this).val();
						      	
						        console.log('Biz_level : ' + Biz_level);
						        console.log('CompanyCode : ' + CompanyCode);
						        
						        sendData(Biz_level, CompanyCode);
						        
						         // Top Biz.Area Group 초기화 추가
						         $('input[name="ComName_input"]').val('');
						         
						         // Description 초기화 추가
						         $('input[name="Upper-Biz-Name"]').val('');
						    });
						});
						</script>

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
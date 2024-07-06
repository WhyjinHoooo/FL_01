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
  	function ComSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/ComSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
  	function GetLevel(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var Code = document.querySelector('.Com-code').value;
	    
	    window.open("${contextPath}/Information/GetLevel.jsp?ComCd=" + Code, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
  	function CCTSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var Code = document.querySelector('.Com-code').value;
	    var lv = document.querySelector('.CCTR-level').value;
	    
	    window.open("${contextPath}/Information/UpCCTSearch.jsp?ComCode=" + Code + "&Level=" + lv, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	</script>
<!-- 	<script type="text/javascript">
		$(document).ready(function() {
			$('.Com-code').change(function() {
				var selectedCode = $(this).val();
				console.log('selectedCode: ' + selectedCode);
						
				$.ajax({
					type: 'POST',
					url: 'getMaxLevel.jsp',  // 요청을 보낼 JSP 파일의 URL
					data: { 
							ComCode: selectedCode  // 선택된 회사 코드
							},
					success: function(response) {
					// 서버로부터 받은 응답 처리
					var maxLevel = response;  // 응답은 최대 레벨이어야 함
					var options = '';
					for(var i=1; i<=maxLevel; i++){
					options += '<option value="' + i + '">' + i + ' Level</option>';
					}
						                
					$('.CCTR-level').html(options);
					}
				});
			});
			
		});
	</script>  --> 
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
								<a href="javascript:ComSearch()"><input type="text" class="Com-code" name="Com-Code" placeholder="SELECT" readonly></a>
							<th class="info">Top Cost Center Group : </th>
								<td>
									<input type="text" class="tccg" name="tccg" readonly size="10'">
								</td>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info"> CCTR Group Level : </th>
							<td class="input_info">
								<a href="javascript:GetLevel()"><input type="text" class="CCTR-level" id="CCTRlvlSelected" name="CCT-level"></a>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<script src="http://code.jquery.com/jquery-latest.js"></script> 
						 
						<tr><th class="info"> Upper CCT_Group : </th>
							<td class="input_info">
								<a href="javascript:CCTSearch()"><input type="text" class="Upper-CCT-Group" id="Upper-CCT-Group" name="Upper-CCT-Group" readonly></a>
									<th class="info">Description : </th>
									<td>
										<input type="text" class="Upper-Cct-Name" name="Upper-Cct-Name" readonly>
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
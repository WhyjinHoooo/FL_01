<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>   
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script type='text/javascript'>
	function ComSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/ComSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function MoneySearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/MoneySearch.jsp", "테스트", "width=550,height=545, left=500 ,top=" + yPos);
	}
	function LanSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/LanSearch.jsp", "테스트", "width=600,height=550, left=500 ,top=" + yPos);
	}
	function TACSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var ComCode = document.querySelector('.Com-code').value;
	    
	    window.open("${contextPath}/Information/TACSearch.jsp?CoCd=" + ComCode, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function BAGSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var ComCode = document.querySelector('.Com-code').value;
	    
	    window.open("${contextPath}/Information/BAGSearch.jsp?CoCd=" + ComCode, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
</script>
<title>Business Area 등록</title>
</head>
<body>
	<h1>Business Area 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="BusA-RegistForm" name="BusA-RegistForm" action="BusinessArea_Regist_Ok.jsp" method="post" onSubmit="" encType="UTF-8">
			<div class="ba-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Business Area Code : </th>
							<td class="input-info">
								<input type="text" name="BAC" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" name="Des" size="41">
							</td>
						</tr>						
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="ba-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input-info">
								<a href="javascript:ComSearch()"><input type="text" class="Com-code" name="Com-code" readonly></a>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<script type="text/javascript">
						$(document).ready(function(){
						    $('.Com-code').change(function(){
						        var Company_Code = $(this).val(); // 수정된 부분
						        
						        //alert('회사 코드 : ' + Company_Code);
						        //console.log('회사 코드 : ' + Company_Code);
						        
						        $.ajax({
						            type: 'post',
						            url: '../Tax/Com-Na-Output.jsp',
						            data: { Company_Code : Company_Code }, // 수정된 부분
						            success: function(response) {
						                if (response !== 'error') {
						                    var dataArr = response.split("|");
						                    var NaCodeInput = document.getElementById("Na-Code");
						                    var NaDesInput = document.getElementById("na-Des");

						                    NaCodeInput.value = dataArr[0];
						                    NaDesInput.value = dataArr[1];
						                } else {
						                    console.error('An error occurred while retrieving the nationality.');
						                }
						            }
						        });
						    });
						});
						</script>
						
				
						<tr><th class="info">Nationality : </th>
							<td class="input-info">
								<input type="text" class="Nationality-Code" name="Na-Code" id="Na-Code" size="7" readonly>
								<input type="text" class="Nationality-Des" name="Na-Des" id="na-Des" size="41" readonly>
							</td>
						</tr>
												
						<tr class="spacer-row"></tr>

						<tr><th class="info">Postal Code : </th>
							<td class="input-info">
								<input type="text" name="Pos-code" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Address 1 : </th>
							<td class="input-info">
								<input type="text" name="Addr1" size="41">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Address 2 : </th>
							<td class="input-info">
								<input type="text" name="Addr2" size="41">
							</td>
						</tr>
						
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Local Currency : </th>
						<td class="input_info">
							<a href="javascript:MoneySearch()"><input type="text" class="money-code" name="money" placeholder="SELECT" readonly></a>
						</td>
						
						<th class="info">Language : </th>
							<td class="input_info">
								<a href="javascript:LanSearch()"><input type="text" class="language-code" name="lang" placeholder="SELECT" readonly></a>
							</td>
					</tr>	
					
					<tr class="spacer-row"></tr>	
					
					<script type="text/javascript">
					    $(document).ready(function(){
					        $('.Com-code').change(function(){
					            var CompanyCode = $(this).val(); // 선택된 값($(this).val())을 변수 asd에 할당합니다.
					            console.log('1. 선택된 값: ' + CompanyCode);
					            
					            var xPos = (window.screen.width-2560) / 2;
					    	    var yPos = (window.screen.height-1440) / 2;
					    	    var PopUp = window.open("TACSearch.jsp?CoCd=" + encodeURIComponent(CompanyCode), "테스트", "width=600,height=495, left=500 ,top=" + yPos);
					        });
					    });
					</script>
						<tr><th class="info">Tax Area Code : </th>
							<td class="input-info">
								<a href="javascript:TACSearch()"><input type="text" class="TA-code" name="TA-code" placeholder="SELECT" readonly></a>
							</td>
						</tr>					

						<tr class="spacer-row"></tr>

					<!-- <script type="text/javascript">
					    $(document).ready(function(){
					        $('.Com-code').change(function(){
					            var CompanyCode = $(this).val(); // 선택된 값($(this).val())을 변수 asd에 할당합니다.
					            // 선택된 값(asd)을 alert로 보여줍니다.
					           // alert('선택된 값: ' + asd);
					            // 또는 선택된 값을 console에 출력합니다.
					            console.log('2. 선택된 값: ' + CompanyCode);            
					            // AJAX 요청을 보냅니다.
					            $.ajax({
					                type: 'POST',
					                url: 'BAG-Code-Output.jsp', // 서버 측 스크립트의 경로를 지정합니다.
					                data: { CoCd: CompanyCode }, // 서버로 보낼 데이터를 객체 형태로 전달합니다.
					                success: function(response) {
					                    response = JSON.parse(response);  // Add this line
					                    var options = '';
					                    for(var i=0; i<response.length; i++){
					                        if (response[i].BAGroup !== undefined) {
					                            options += '<option value="' + response[i].BAGroup + '">' + response[i].BAGroup + '</option>';
					                        } else {
					                            console.error('응답의 ' + i.toString() + '번째 항목에 ComCode 속성이 없습니다:', response[i]);
					                        }
					                    }
					                    $('.BAG-code').html(options);
					                }
					            });
					        });
					    });
					</script> --> <!-- ajax를 이용해서 선택지를 불러오는 방법 -->
						
						<tr><th class="info">Biz.Area Group : </th>
							<td class="input-info">
								<a href="javascript:BAGSearch()"><input type="text" class="BAG-code" name="BAG-code" placeholder="SELECT" readonly></a>
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
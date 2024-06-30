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
<title>Tax Area 등록</title>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
	function comfirm(){
		var TAC = document.Tax-RegistForm.TAC.value;
		var Des = document.Tax-RegistForm.Des.value;
		
		var Com-code = document.Tax-RegistForm.Com-code.value;
		var Na-Code = document.Tax-RegistForm.Na-Code.value;
		
		var Pos-code = document.Tax-RegistForm.Pos-code.value;
		
		var Addr1 = document.Tax-RegistForm.Addr1.value;
		var Addr2 = document.Tax-RegistForm.Addr1.value;
		
		var Select_MS = document.Tax-RegistForm.Select_MS.value;
		var main-TA-Code = document.Tax-RegistForm.main-TA-Code.value;
		
		var Use-Useless = document.Tax-RegistForm.Use-Useless.value;
	    
	    if(!TAC || !Des || !Com-code || !Na-Code || !Pos-code || !Addr1 || !Addr2 || !Select_MS || !main-TA-Code || !Use-Useless){
	    	alert('모든 항목을 입력해주세요.');
	    	return false;
	    } else{
	    	return true;
	    }
	}
</script>
<script type="text/javascript">
	function ComSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/ComSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
</script>

</head>
<body>
	<h1>Tax Area 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="Tax-RegistForm" name="Tax-RegistForm" action="Tax-Regist_Ok.jsp" method="post" onSubmit="">
			<div class="tax-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Tax Area Code : </th>
							<td class="input-info">
								<input type="text" name="TAC" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td>
								<input type="text" name="Des" size="41">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="tax-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input_info">
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
						            url: 'Com-Na-Output.jsp',
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
							
						<tr><th class="info">Main Tax Area :</th>
						    <td class="input-info">
						        <input type="radio" class="TaxArea_MS" name="Select_MS" value="1"> Main Tax Area
						        <span class="spacing"></span>
						        <input type="radio" class="TaxArea_MS" name="Select_MS" value="2"> Sub Tax Area
						    </td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr id="main-tax-area-code-row">
							<th class="info">Main Tax Area Code : </th>
							<td class="input-info">
								<select class="main-TA-Code" name="main-TA-Code" readonly disabled>
									<option value="Null">선택</option>
								</select>
							</td>												
						</tr>
						
						<script type='text/javascript'>
						$(document).ready(function() {
						  $('.TaxArea_MS').change(function() {
						      var selectedValue = $(this).val();
						      var mainTaxAreaCodeRow = $('#main-tax-area-code-row');
						      var mainTaxAreaCodeInput = mainTaxAreaCodeRow.find('select');
						      
						      if (selectedValue === '1') {
						          mainTaxAreaCodeInput.prop('disabled', true);
						      } else {
						          mainTaxAreaCodeInput.prop('disabled', false);
						      }
						 });  
						});
						</script>
						<script type="text/javascript">
						$(document).ready(function() {
						  $('.Com-code').change(function() {
						      var selectedValue = $(this).val();
						      var taxAreaValue = $('.TaxArea_MS:checked').val();
						      
						      if (taxAreaValue === '1') {
						          return; // 1일 경우에는 함수 실행 중단
						      }
						      
						      var mainTaxAreaCodeInput = $('#main-tax-area-code-row select');
						      
						      if (selectedValue !== '') {
						          var newOptionHtml =
						              '<option value="' + selectedValue + '">' + selectedValue + '</option>';
						          
						          mainTaxAreaCodeInput.empty().append(newOptionHtml);
						      }
						  });
						});
						</script>						
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">사용 여부 : </th>
							<td class="input-info"> 
								<input type="radio" class="TA-InputUse" name="Use-Useless" value="1" checked>사용
								<span class="spacing"></span>
								<input type="radio" class="TA-InputUse" name="Use-Useless" value="2">미사용
							</td>
						</tr>
					</table>
				</div>
			</div>
			
		</form>
		
	</center>
</body>
</html>
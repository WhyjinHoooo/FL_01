<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Material Code 생성</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script type='text/javascript'>
window.addEventListener('DOMContentLoaded', (event) => {
    const matTypeCodeInput = document.querySelector('.matTypeCode');
    const lv1CodeInput = document.querySelector('.matlv1Code');
    const lv1DesInput = document.querySelector('.matlv1Des');
    const lv2CodeInput = document.querySelector('.matlv2Code');
    const lv2DesInput = document.querySelector('.matlv2Des');
    const lv3CodeInput = document.querySelector('.matlv3Code');
    const lv3DesInput = document.querySelector('.matlv3Des');
    const GroupCodeInput = document.querySelector('.matGroupCode');
    const GroupDesInput = document.querySelector('.matGroupDes');
    const matCodeInput = document.querySelector('.matCode');
    const DescriptionInput = document.querySelector('.Des');
    
    
    const resetInputs = (inputs) => {
        inputs.forEach(input => input.value = '');
    };
    
    const updateDes = () => {
        const lv1Des = lv1DesInput.value;
        const lv2Des = lv2DesInput.value;
        const lv3Des = lv3DesInput.value;

        DescriptionInput.value = [lv1Des, lv2Des, lv3Des].join(',');
    };

    lv1DesInput.addEventListener('change', updateDes);
    lv2DesInput.addEventListener('change', updateDes);
    lv3DesInput.addEventListener('change', updateDes);

    const matTypeInputs = [lv1CodeInput, lv1DesInput, lv2CodeInput, lv2DesInput, lv3CodeInput, lv3DesInput, GroupCodeInput, GroupDesInput, matCodeInput, DescriptionInput];
    const lv1Inputs = [lv2CodeInput, lv2DesInput, lv3CodeInput, lv3DesInput, GroupCodeInput, GroupDesInput, matCodeInput];
    const lv2Inputs = [lv3CodeInput, lv3DesInput, GroupCodeInput, GroupDesInput, matCodeInput];

    matTypeCodeInput.addEventListener('change', () => resetInputs(matTypeInputs));
    lv1CodeInput.addEventListener('change', () => resetInputs(lv1Inputs));
    lv2CodeInput.addEventListener('change', () => resetInputs(lv2Inputs));
});

function PlantSearch(){
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;

    window.open("PlantSerach.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);	   
}
function MatTypeSearch(){
	var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;

	window.open("MattypeSerach.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos); 
}
function MatLv1Search(){
	var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    var matType = document.querySelector('.matTypeCode').value;

	window.open("MatLv1Serach.jsp?matType=" + matType, "테스트", "width=500,height=500, left=500 ,top=" + yPos); 
}
function MatLv2Search(){
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    var matType = document.querySelector('.matTypeCode').value;
    var lv1 = document.querySelector('.matlv1Code').value;

    window.open("MatLv2Serach.jsp?matType=" + matType + "&lv1=" + lv1, "테스트", "width=500,height=500,left=500,top=" + yPos); 
}
function MatLv3Search(){
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    var matType = document.querySelector('.matTypeCode').value;
    var lv2 = document.querySelector('.matlv2Code').value;

    window.open("MatLv3Serach.jsp?matType=" + matType + "&lv2=" + lv2, "테스트", "width=500,height=500,left=500,top=" + yPos); 
}
function WareSearch(){
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    var ComCode = document.querySelector('.plantComCode').value;
    
    window.open("WareSerach.jsp?ComCode=" + ComCode, "테스트", "width=500,height=500,left=500,top=" + yPos);
}
function AdjustSearch(){
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    var ComCode = document.querySelector('.plantComCode').value;

    window.open("AdjustSerach.jsp?ComCode=" + ComCode, "테스트", "width=500,height=500,left=500,top=" + yPos); 
}
</script>
</head>
<body>
	<h1>Material Code 생성</h1>
	<center>
		<jsp:include page="../HeaderTest.jsp"></jsp:include>
		<form name="matRegistForm" id="matRegistForm" action="Material_Regist_Ok.jsp" method="post" enctype="UTF-8">
			<div class="mat-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Plant Code : </th>
							<td class="input-info">
								<a href="javascript:PlantSearch()"><input type="text" name="plantCode" class="plantCode" size="10" placeholder="선택" readonly></a>
								<input type="text" name="plantDes" class="plantDes" size="31" readonly>
								<input type="text" name="plantComCode" class="plantComCode" size="5" hidden>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Material 유형 : </th>
							<td class="input-info">
								<a href="javascript:MatTypeSearch()"><input type="text" name="matTypeCode" class="matTypeCode" size="10" placeholder="선택" readonly></a>
								<input type="text" name="matTypeDes" class="matTypeDes" size="31" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">MatGroup 1 Level : </th>
							<td class="input-info">
								<a href="javascript:MatLv1Search()"><input type="text" name="matlv1Code" class="matlv1Code" size="10" placeholder="선택" readonly></a>
								<input type="text" name="matlv1Des" class="matlv1Des" size="31" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">MatGroup 2 Level : </th>
							<td class="input-info">
								<a href="javascript:MatLv2Search()"><input type="text" name="matlv2Code" class="matlv2Code" size="10" placeholder="선택" readonly></a>
								<input type="text" name="matlv2Des" class="matlv2Des" size="31" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">MatGroup 3 Level : </th>
							<td class="input-info">
								<a a href="javascript:MatLv3Search()"><input type="text" name="matlv3Code" class="matlv3Code" size="10" placeholder="선택" readonly></a>
								<input type="text" name="matlv3Des" class="matlv3Des" size="31" readonly>
							</td>
						</tr>
						
						<script type="text/javascript">
						    $(document).ready(function(){
						        $('.matlv3Code').change(function(){
						            var lv3 = $(this).val();
						            console.log('lv3 Code : ' + lv3);
						            $.ajax({
						            	type : 'post',
						            	url : 'MakeCode.jsp',
						            	data : {first : lv3},
						            	/* datatype : 'json', */
						            	success : function(response){
						            		console.log(response);
						            		$('input[name="matCode"]').val($.trim(response));
						            	}
						            });
						        });
						    });
						</script>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Material Code : </th>
							<td class="input-info">
								<input type="text" name="matCode" class="matCode" size="10" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" name="Des" class="Des" size="47">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="mat-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">재고관리 단위 : </th>
							<td class="input-info">
								<select class="unit" name="unit">
									<optipn>SELECT</optipn>
									<%
									try{
										PreparedStatement pstmt = null;
										ResultSet rs = null;
										
										String sql = "SELECT * FROM sku";
										
										pstmt = conn.prepareStatement(sql);
										rs = pstmt.executeQuery();
										
										while(rs.next()){
											String code = rs.getString("code");
									%>
										<option value="<%=code%>"><%=code%></option>
									<%
										}
									}catch(Exception e){
										e.printStackTrace();
									}
									%>
								</select>
							</td>	
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Default 입고창고 : </th>
							<td class="input-info">
								<a href="javascript:WareSearch()"><input type="text" name="StorageCode" class="StorageCode" size="10" readonly></a>
								<input type="text" name="StorageDes" class="StorageDes" size="31" readonly> 
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">규격 : </th>
							<td class="input-info">
								<input type="text" name="size" class="size" size="47">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Material Group : </th>
							<td class="input-info">
								<input type="text" name="matGroupCode" class="matGroupCode" size="10" readonly>
								<input type="text" name="matGroupDes" class="matGroupDes" size="31" readonly> 
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Material 적용단계 : </th>
							<td class="input-info">
								<a href="javascript:AdjustSearch()"><input type="text" name="matadjustCode" class="matadjustCode" size="10" readonly></a>
								<input type="text" name="matadjustDes" class="matadjustDes" size="31" readonly> 
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">수입검사 품목 여부 : </th>
							<td class="input-info">
								<input type="radio" name="examine" class="examineItem1" value="true" checked>유검사 품목	
								<input type="radio" name="examine" class="examineItem2" value="false">무검사 품목 
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">사용 여부 : </th>
							<td class="input-info">
								<input type="radio" name="useYN" class="useYN1" value="true" checked>사용
								<input type="radio" name="useYN" class="useYN2" value="false">미사용
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
	</center>
</body>
</html>
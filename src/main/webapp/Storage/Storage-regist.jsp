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
/* function CompanyName(d){
	var v = d.value;
	var ComCode = v.split(',')[0];
	var ComName = v.split(',')[1];
	document.StorageResgistForm.ComCode_Name.value = ComName;
} */

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

/* function LocationType(d){
	var v = d.value;
	document.StorageResgistForm.Storage_Type_Des.value = v;
} */

function ComSearch(){
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;

    window.open("${contextPath}/Information/CompanySerach.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);
}
function PlantSearch(){
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
	var ComCode = document.querySelector('.ComCode').value;
	
    window.open("${contextPath}/Information/PlantSerach.jsp?ComCode=" + ComCode, "테스트", "width=500,height=500, left=500 ,top=" + yPos);
}
function StorageSearch(){
    var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;

    window.open("${contextPath}/Information/StorageSerach.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);
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
								<a href="javascript:ComSearch()"><input type="text" class="ComCode" name="ComCode" placeholder="선택" readonly></a>
								<input type="text" class="Com_Name" name="Com_Name" readonly>
							</td>	
						</tr>
						
						
						<!-- <script type="text/javascript">
						$(document).ready(function(){
							$('.ComCode').change(function(){
								var CompanyCode = $(this).val();s
								var ComCode = CompanyCode.split(',')[0];
								console.log('Edited CompanyCode : ' + ComCode);
								$.ajax({
									type : 'post',
									url : 'plant-find.jsp',
									data : {ComCode : ComCode},
									datatype : 'json',
									success : function(response){
										var plantoption = '';
										try{
											for(var i = 0 ; i < response.PLANT.length ; i++){
												plantoption += '<option value="'+response.PLANT[i]+'">'+response.PLANT[i] + '</option>';
											}
											
											$('.Plant_Select').html(plantoption);
											$('select[name="Plant_Select"]').change(function() {
						                         var selectedOption = $(this).children("option:selected");
						                         $('input[name="Plant_Select_Des"]').val(selectedOption.val()); // 수정된 부분
						                     });
											$('#Plant_Select').prop('selectedIndex', 0).change();
											
											var firstPlantOption = response.PLANT[0];
					                        $('input[name="Plant_Select_Des"]').val(firstPlantOption);
										} catch(error){
											console.error("JSON 파싱 중 오류 발생:", error, response);
										}
									}, 
									error : function(xhr, status, error) {
						                console.error("AJAX 요청 중 오류 발생:", error);
						            }
								});
							});
						});
						</script> -->

						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Plant : </th>
							<td class="input-info">
								<a href="javascript:PlantSearch()"><input type="text" class="Plant_Select" name="Plant_Select" placeholder="선택" readonly></a>
								<!-- <select class="Plant_Select" name="Plant_Select">
									<option value="NOPE">SELECT</option>
								</select> -->
								<input type="text" class="Plant_Name" name="Plant_Name" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Storage Location Type : </th>
							<td class="input-info">
							<a href="javascript:StorageSearch()"><input type="text" class="Stor_Code" name="Stor_Code" placeholder="선택" readonly></a> 
								<%-- <select class="Storage_Type" name="Storage_Type" onchange="LocationType(this)">
									<option value="NOPE">SELECT</option>
									<%
									try{
										PreparedStatement pstmt = null;
										ResultSet rs = null;
										String sql = "SELECT * FROM warehouse ORDER BY code ASC";
										pstmt = conn.prepareStatement(sql);
										
										rs = pstmt.executeQuery();
										
										while(rs.next()){
											String code = rs.getString("code");
											String name = rs.getString("name");
									%>
										<option value="<%=name%>"><%=code%></option>
									<%
										}
									}catch(Exception e){
										e.printStackTrace();
									}
									%>
								</select> --%>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script type='text/javascript'>
	function PlantSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    /* window.open("PlantSerach.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);	 */
	    var newWindow = window.open("MIPlantSerach.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);	 
	    
	    newWindow.onbeforeunload = function(){
	    	document.querySelector(".plantCode").dispatchEvent(new Event('change'));
	    }
	}
	function MoveTypeSearch(){
		var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    window.open("MoveTypeSerach.jsp", "테스트", "width=600,height=580, left=500 ,top=" + yPos);
	}
	function VendorSearch(){
		var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var ComCode = document.querySelector('.plantComCode').value;
	    
	    window.open("FindVendor.jsp?ComCode=" + ComCode, "테스트", "width=500,height=500, left=500 ,top=" + yPos);
	}
	
	window.addEventListener('DOMContentLoaded',(event) => {
		const PlantCode = document.querySelector(".plantCode");
		const VenCode = document.querySelector(".VendorCode");
		const VenDes = document.querySelector(".VenderDes");
		
		const resetVendor = (inputs) => {
			inputs.forEach(input => input.value = '');
		};
		const VENDOR = [VenCode,VenDes];
		
		PlantCode.addEventListener('change', () => resetVendor(VENDOR));
	});
</script>

<script type="text/javascript">
$(document).ready(function(){
	var rowNum = 1;
	var maxRowNum = 0;
	$('input.VendorCode, .plantCode').on('input',function(){
		var vendorcode = $('.VendorCode').val();/* $(this).val(); */
		var vendorname = $('.VenderDes').val();
		var plantcode = $('.plantCode').val();
		var table = $('.WrittenForm');
	
	    // 테이블 초기화
	     table.find('tr:gt(0)').remove();
		
		console.log('입력받은 Vendor코드 : ' + vendorcode + '입력받은 Plant코드 : ' + plantcode);
		
		$.ajax({
			type : "POST",
			url : "FindInfo.jsp",
			data : {vendor : vendorcode, plant : plantcode},
			dataType: "text",
			success: function(response){
				console.log(response);
				if (response.trim() !== '') {
					var data = JSON.parse(response);
					/* var table = $('.WrittenForm'); */
					
					table.find('tr:gt(0)').remove();
					
					for (var i = 0; i < data.length; i++) {
						var row = '<tr>' +
						'<td>' + (i + 1) + '</td>' + // 항번
						'<td><button type="button" class="sendBtn">전송</button></td>' + //선택 버튼
						'<td>' + vendorcode + '</td>' + //벤더 코드
						'<td>' + vendorname + '</td>' + // 벤더 설명
						'<td class="MMPO">' + data[i].MMPO + '</td>' + // PO번호
						'<td class="ItemNo">' + String(data[i].ItemNo).padStart(4, '0') + '</td>' + // Item번호
						'<td class="MatCode">' + data[i].MatCode + '</td>' + // 재료 코드
						'<td class="MatDes">' + data[i].MatDes + '</td>' + // 재료에 대한 설명
						'<td class="MatType">' + data[i].MatType + '</td>' + // 재료의 타입
						'<td class="Quantity">' + data[i].Quantity + '</td>' + // 발주 수량
						'<td class="PoUnit">' + data[i].PoUnit + '</td>' + // 구매 단위
						'<td class="StoredInput">' + data[i].Count + '</td>' + // 입고 수량
						'<td class="NotStored">' + data[i].PO_Rem + '</td>' + // 미입고수량
						'<td class="TraCurr">' + data[i].Money + '</td>' + //거래 통화
						'<td>' + data[i].Hdate + '</td>' + // 입고예정일자
						'<td class="Storage">' + data[i].Storage + '</td>' + // 입고창고 코드
						'<td class="PlantCode">' + data[i].PlantCode + '</td>' + // 플랜트 코드
						'</tr>';
						table.append(row);
					};
				}
			}
		});
	});

	$(document).on('click', '.sendBtn', function() {
		var row = $(this).closest('tr');
		var MMPO = row.find('.MMPO').text();
		var ItemNo = row.find('.ItemNo').text();
		var MatCode = row.find('.MatCode').text();
		var MatDes = row.find('.MatDes').text();
		var MatType = row.find('.MatType').text();
		var Quantity = row.find('.Quantity').text();
		var PoUnit = row.find('.PoUnit').text();
		var NotStored = row.find('.NotStored').text();
		var Storage = row.find('.Storage').text();
		var PlantCode = row.find('.PlantCode').text();
		var TraCurr = row.find('.TraCurr').text();
		/* var StoreCount = row.find('.StoredInput').text(); */
		
		$('.ItemNum').val('0001'); // GR Item Number
		$('.PurOrdNo').val(MMPO); // Purchase Order No
		$('.OIN').val(ItemNo); // Order Item Number
		$('.MatCode').val(MatCode); // Material
		$('.MatDes').val(MatDes); // Material Description
		$('.MatType').val(MatType); // Material 유형
		$('.OrderCount').val(Quantity); // 발주 수량
		$('.BuyUnit').val(PoUnit); // 구매단위
		//$('.InputCount').val('0'); //V 	입고 수량
		//$('.InputCount').val(StoreCount);  	입고 수량
		$('.GoodUnit').val(PoUnit); //	재고단위
		$('.NotInput').val(NotStored); // 미입고 수량
		$('.PlantCode').val(PlantCode); // Plant		
		$('.SLocCode').val(Storage).trigger('input'); //납품S.Location
		$('.SLocDes').val(''); //납품S.Location Description
		$('.WareRack').val(''); //창고 Rack
		$('.Bin').val(''); // Bin
		$('.Money').val(TraCurr);
	
		var date = new Date();
		var year = date.getFullYear();
		var month = ('0' + (date.getMonth() + 1)).slice(-2);
		var day = ('0' + date.getDate()).slice(-2);
		var formattedDate = year + month + day;
		$('.MatNum').val('MGR' + formattedDate + 'S00001').trigger('change');
		

		/* row.hide(); */ 
		//row.remove();  // 행 삭제

	    // 항번 재정렬
	    $('.WrittenForm tr').each(function(index) {
	        $(this).find('td:first').text(index);
	    });	
		
		const MovType = document.querySelector(".MovType");
		const MovType_Des = document.querySelector(".MovType_Des");
		const WareRack = document.querySelector(".WareRack");
		const Bin = document.querySelector(".Bin");
		const LotNum = document.querySelector(".LotNum");
		const MadeDate = document.querySelector(".MadeDate");
		const Deadline = document.querySelector(".Deadline");
		
		const resetVendor = (inputs) => {
			inputs.forEach(input => input.value = '');
		};
		const typing = [MovType,MovType_Des,WareRack,Bin,LotNum,MadeDate,Deadline];
		
		//resetVendor(typing);
		
	}); //$(document).on('click', '.sendBtn', function(){...}의 끝
	
	$('.MatNum').on('change', function(){
		var matinputNumber = $(this).val();
		/* $('.ItemNum').val('0001'); */
		var ginum = $('.ItemNum').val();
		console.log('2023-12-08 Material 입고 번호 : ' + matinputNumber + ', 2023-12-08 GR Item Number : ' + ginum);
		$.ajax({
			type : "POST",
			url : "FindMatNum.jsp",
			data : {MatNum : matinputNumber, GItemNumber : ginum},
			success: function(response){
				console.log(response);
				var values = response.trim().split(",");
				$('input[name="MatNum"]').val(values[0]); // Material 입고 번호
				$('.ItemNum').val(values[1]); // GR Item Number
			}
		})
	});
}); //$(document).ready(function(){...}의 끝
</script>
<script>
function checkCount(){
	var remain = parseInt(document.MatInputRegistForm.NotInput.value, 10); // 미입고 수량
	var input = parseInt(document.MatInputRegistForm.InputCount.value, 10); // 입고 수량
	
	if(input == 0 || (input > remain)){
		alert('입고 수량을 수정해주세요');
		return false;
	}else{
		return true;
	} 
	
}
</script>
<!-- --------------------------------- -->

<%
	request.setCharacterEncoding("UTF-8");
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String Today = today.format(formatter);
	int user_id = 17011381;
	
/* 	session.removeAttribute("pCode");
	session.removeAttribute("pDes");
	session.removeAttribute("pComCode");
	session.removeAttribute("vCode");
	session.removeAttribute("vDes"); */
	
	String pCode = (String) session.getAttribute("pCode");
	String pDes = (String) session.getAttribute("pDes");
	String pComCode = (String) session.getAttribute("pComCode");
	String vCode = (String) session.getAttribute("vCode");
	String vDes = (String) session.getAttribute("vDes");
%>
<title>자재입고</title>
</head>
<body>
	<h1>자재입고</h1>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form name="MatInputRegistForm" id="MatInputRegistForm" action="MatInput_OK.jsp" method="POST" onSubmit="return checkCount()" enctype="UTF-8">
			<div class="input-main-info">
				<div class="table-container">
					<table class="main-table">
						<tr>
							<th class="info">Plant : </th>
								<td class="input-info">
								<%
									if(pCode == null){
								%>
								<a href="javascript:PlantSearch()"><input type="text" class="plantCode" name="plantCode" readonly></a> <!-- 전송 -->
									<input type="text" class="plantDes" name="plantDes" readonly> 
									<input type="text" name="plantComCode" class="plantComCode" size="5" hidden>
								</td>
								<%
									}else{
								%>
								<a href="javascript:PlantSearch()"><input type="text" class="plantCode" name="plantCode" readonly value="<%=pCode%>"></a> <!-- 전송 -->
									<input type="text" class="plantDes" name="plantDes" readonly value="<%=pDes%>"> 
									<input type="text" name="plantComCode" class="plantComCode" size="5" hidden value="<%=pComCode%>">
								</td>
								<%
									}
								%>
								<td class="spaceCell"></td>
								
							<th class="info">입고자 사번: </th>
								<td class="input-info">
									<input type="text" class="Input_Id" name="Input_Id" value="<%=user_id%>" readonly>								
								</td>	
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<!-- <script type="text/javascript">
						$(document).ready(function(){
							$('input.plantComCode').on('input', function(){
								var plantcomcode = $(this).val();
								console.log('Plant Code : ' + plantcomcode);
								$.ajax({
									type : "POST",
									url : "FindVendor.jsp",
									data : {PlantComCode : plantcomcode},
									success: function(response){
					                    console.log(response);
					                    $('.VendorCode').val(response.VenCode);
					                    $('.VenderDes').val(response.VenDes);
					                    $('.VendorCode').trigger('input');
					                }
								})
							});
						});
						</script> -->
						
						<tr>
							<th class="info">Vendor : </th>
								<%
									if(vCode == null){
								%>
								<td class="input-info">
									<a href="javascript:VendorSearch()"><input type="text" class="VendorCode" name="VendorCode" readonly></a> <!-- 전송 -->
									<input type="text" class="VenderDes" name="VenderDes" readonly> 
								</td>
								<%
									}else{
								%>
								<td class="input-info">
									<a href="javascript:VendorSearch()"><input type="text" class="VendorCode" name="VendorCode" readonly  value="<%=vCode%>"></a> <!-- 전송 -->
									<input type="text" class="VenderDes" name="VenderDes" readonly  value="<%=vDes%>"> 
								</td>
								<script type="text/javascript">
									$(document).ready(function(){
									    var vCode = "<%=vCode%>"; // 세션에서 값을 가져옵니다.
									    var vDes = "<%=vDes%>"; // 세션에서 값을 가져옵니다.
	
									    // 입력 필드의 값을 설정합니다.
									    $('.VendorCode').val(vCode);
									    $('.VenderDes').val(vDes);
	
									    // input 이벤트를 발생시킵니다.
									    $('.VendorCode').trigger('input');
									});
								</script>
								<%
									}
								%>
								<td class="spaceCell"></td>
								
							<th class="info">입고 일자: </th>
								<td class="input-info">
									<input type="text" class="Input_Date" name="Input_Date" value="<%=Today%>" readonly>								
								</td>	
						</tr>						
					</table>
				</div>
			</div>
			

			
			<div class="orderedDate">
				<div class="table-container">
					<table class="WrittenForm">
						<tr>
							<th>항번</th><th>선택</th><th>Vendor</th><th>Vendor명</th><th>PO번호</th><th>Item번호</th><th>Material</th><th>Material Description</th><th>Material 유형</th><br>
							<th>발주수량</th><th>구매단위</th><th>입고수량</th><th>미입고수량</th><th>거래통화</th><th>입고예정일자</th><th>입고창고</th><th>Plant</th>
						</tr>
					</table>
				</div>
			</div>
			
			<div class="container">
				<img name="Down" src="../img/Dvector.png" alt="">
				<input class="input-btn" id="btn" type="submit" value="Insert">
			</div>
			
			<div class="input-sub-info">
				<div class="table-container">
					<table class="table_1">
						<tr>
							<th class="info">Material 입고 번호 : </th>
								<td class="input-info">
									<input type="text" class="MatNum KeyData" name="MatNum" readonly><!-- 中 -->
								</td>
							
							<td class="spaceCell-s"></td> <!-- 폭 150px -->
							
							<th class="info">GR Item Number : </th>
								<td class="input-info">
									<input type="text" class="ItemNum KeyDataNum" name="ItemNum" reqdonly><!-- 中 -->
								</td>
							
							<td class="spaceCell-b"></td> <!-- 폭 550px -->
							
							<th class="info">Movement Type: </th>
								<td class="input-info" colsapn="2">
									<a href="javascript:MoveTypeSearch()"><input type="text" class="MovType" name="MovType" readonly></a>
									<input type="text" class="MovType_Des" name="MovType_Des" size="40" readonly>
									<input type="text" class="PlusMinus" name="PlusMinus" hidden>
								</td>
						</tr>
					</table>
					
					<script type="text/javascript">
						$(document).ready(function(){
							$('input.MovType').on('input', function(){
								var Movement_Code = $(this).val();
								console.log('Movement_Code : ' + Movement_Code);
								$.ajax({
									type : "POST",
									url : "CheckMat.jsp",
									data : {movcode : Movement_Code},
									datatype : "josn",
									success: function(response){
										if(response.result === "fail") {
											alert(response.message);
											$('input.MovType').val('');
											$('input.MovType_Des').val('');
											$('input.PlusMinus').val('');
										}
									}
								})
							});
						});
					</script>
					
					
					<table class="table_2">
						<tr>
							<th class="info">Purchase Order No : </th>
								<td class="input-info">
									<input type="text" class="PurOrdNo KeyInfo" name="PurOrdNo" readonly>
								</td>
							
							<td class="spaceCell-ss-1-1"></td> <!-- 폭 130px -->
							
							<th class="info">Order Item Number : </th>
								<td class="input-info">
									<input type="text" class="OIN KeyInfo" name="OIN" readonly>
								</td>
						</tr>
					</table>
					
					<table class="table_3">
						<tr>
							<th class="info">Material : </th>
								<td class="input-info" colspan="2">
									<input type="text" class="MatCode KeyInfo" name="MatCode" readonly>
									<input type="text" class="MatDes KeyInfo" name="MatDes" readonly> 
								</td>
								
							<td class="spaceCell-515"></td>
							
							<th class="info">Material 유형 : </th>
								<td class="input-info">
									<input type="text" class="MatType KeyInfo" name="MatType" readonly>
								</td>
						</tr>
					</table>
					
					<table class="table_4">
						<tr>
							<th class="info">Plant : </th>
								<td class="input-info">
									<input type="text" class="PlantCode KeyInfo" name="PlantCode" readonly>
								</td>
								
							<td class="spaceCell-230"></td>
							
							<th class="info">납품S.Location : </th>
								<td class="input-info" colspan="2">
									<input type="text" class="SLocCode KeyInfo" name="SLocCode" readonly> <!-- ? -->
									<input type="text" class="SLocDes KeyInfo" name="SLocDes" readonly>
								</td>
							
							<script type="text/javascript">
							$(document).ready(function(){
								$('input.SLocCode').on('input', function(){
									var storageLoc = $(this).val();
									console.log('Storage Location Code : ' + storageLoc);
									$.ajax({
										type : "POST",
										url : "FindsLoc.jsp",
										data : {sloccode : storageLoc},
										success: function(response){
											console.log(response);
											if(response.SLocName) {
												$('.SLocDes').val(response.SLocName);
											}
										}
									})
								});
							});
							</script>
								
								
							<td class="spaceCell-250"></td>
							
							<th class="info">창고 Rack: </th>
								<td class="input-info">
									<input type="text" class="WareRack" name="WareRack" readonly>
								</td>	
								
							<td class="spaceCell-240"></td>
							
							<th class="info">Bin : </th>
								<td class="input-info">
									<input type="text" class="Bin" name="Bin" readonly>
								</td>	
						</tr>
					</table>
					
					<table class="table_5">
						<tr>
							<th class="info">발주 수량 : </th>
								<td class="input-info">
									<input type="text" class="OrderCount KeyInfo" name="OrderCount" readonly>
								</td>
							
								<td class="spaceCell-10"></td>
							
							<th class="info">구매단위 : </th>
								<td class="input-info" colspan="2">
									<input type="text" class="BuyUnit KeyInfo" name="BuyUnit" readonly>
									<input type="text" class="Money" name="Money" hidden>
								</td>
								
							<td class="spaceCell-250"></td>
							
							<th class="info">입고 수량: </th>
								<td class="input-info">
									<input type="text" class="InputCount KeyInfo" name="InputCount">
								</td>
									
							<td class="spaceCell-250"></td>
							
							<th class="info">재고단위 : </th>
								<td class="input-info">
									<input type="text" class="GoodUnit KeyInfo" name="GoodUnit" readonly>
								</td>
								
							<td class="spaceCell-300"></td>
							
							<th class="info">미입고 수량 : </th>
								<td class="input-info">
									<input type="text" class="NotInput KeyInfo" name="NotInput" readonly>
								</td>
										
						</tr>
					</table>
					
					<table class="table_6">
						<tr>
							<th class="info">지제 Lot 번호 : </th>
								<td class="input-info">
									<input type="text" class="LotNum" name="LotName"> <!-- ? -->
								</td>
								
							<td class="spaceCell-250"></td>
							
							<th class="info">제조일자 : </th>
								<td class="input-info">
									<input type="date" class="MadeDate" name="MadeDate">
								</td>
								
							<td class="spaceCell-200"></td>
							
							<th class="info">유효기간 만료일자 : </th>
								<td class="input-info">
									<input type="date" class="Deadline" name="Deadline">
								</td>	
						</tr>
					</table>
				</div>
			</div>
		</form>
	</center>
	
</body>
</html>
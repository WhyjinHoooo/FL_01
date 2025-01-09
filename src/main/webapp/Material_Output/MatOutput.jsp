<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>자재출고</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
function InfoSearch(field){
	event.preventDefault();
	
	var popupWidth = 1000;
    var popupHeight = 600;
    
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
    var comcode = $('.plantComCode').val();
    var plantcode = $('.plantCode').val();
    var storagecode = $('.StorageCode').val();
    var OutStorageCode = $('.StorageCode').val();
    
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
    case "PlantSearch":
    	popupWidth = 550;
    	popupHeight = 610;
    	window.open("${contextPath}/Material/PlantSerach.jsp", "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    break;
	case "StorageSearch":
		popupWidth = 550;
		popupHeight = 610;
		window.open("${contextPath}/Material_Output/StorageSerach.jsp?comcode=" + comcode, "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "MovSearch":
		popupWidth = 550;
		popupHeight = 610;
		window.open("${contextPath}/Material_Output/MovSerach.jsp", "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "MatSearch":
		popupWidth = 550;
		popupHeight = 610;
		window.open("${contextPath}/Material_Output/MatSearch.jsp?plantcode=" + plantcode + "&storagecode=" + storagecode, "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "LotSearch":
		popupWidth = 550;
		popupHeight = 610;
		window.open("${contextPath}/Material_Output/LotSearch.jsp?storagecode=" + storagecode, "POPUP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "DepartSearch":
		popupWidth = 550;
		popupHeight = 610;
		window.open("${contextPath}/Material_Output/DepartSearch.jsp", "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "InputSearch":
		popupWidth = 550;
		popupHeight = 610;
		window.open("${contextPath}/Material_Output/InputSearch.jsp?outStorage=" + OutStorageCode, "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	}
}
window.addEventListener('DOMContentLoaded',(event) => {
	const plantCode = document.querySelector('.plantCode');
	const storageCode = document.querySelector('.StorageCode');
	const storageDes = document.querySelector('.StorageDes');
	const storageComCode = document.querySelector('.StorageComCode');
    const movCode = document.querySelector('.movCode');
    const movDes = document.querySelector('.movDes');
	const PlusMinus = document.querySelector('.PlusMinus');
	const GINo = document.querySelector('.GINo');
	const Doc = document.querySelector('.Doc_Num');
	const MatCode = document.querySelector('.MatCode');
	const MatDes = document.querySelector('.MatDes');
	const MatLotNo = document.querySelector('.MatLotNo');
	const Make = document.querySelector('.MakeDate');
	const Dead = document.querySelector('.DeadDete');
	const OutCount = document.querySelector('.OutCount');
	const Orderunit = document.querySelector('.OrderUnit');
	const Before = document.querySelector('.BeforeCount');
	const DeptCode = document.querySelector('.UseDepart');
	const DeptName= document.querySelector('.DepartName');
	const InStor = document.querySelector('.InputStorage');
	const LotNumber = document.querySelector('.LotNumber');
    
	const resetInputs = (inputs, enableInput) => {
        inputs.forEach(input => input.value = '');
        if (enableInput) {
            enableInput.disabled = false;
        }
        if (DeptCode) {
            DeptCode.disabled = false;
        }
        if (InStor) {
            InStor.disabled = false;
        }
    };

	const plantchange = [storageCode, storageDes, storageComCode, movCode, movDes, PlusMinus, GINo, Doc, MatCode, MatDes, MatLotNo, Make, Dead, OutCount, Orderunit, Before, DeptCode, DeptName, InStor, LotNumber];
	const storagechange = [movCode, movDes, PlusMinus, GINo, Doc, MatCode, MatDes, MatLotNo, Make, Dead, OutCount, Orderunit, Before, DeptCode, DeptName, InStor, LotNumber];
	const movchange = [MatCode, MatDes, MatLotNo, Make, Dead, OutCount, Orderunit, Before, DeptCode, DeptName, InStor, LotNumber];
	
	plantCode.addEventListener('change', () => resetInputs(plantchange, LotNumber));
	storageCode.addEventListener('change', () => resetInputs(storagechange, LotNumber));
	movCode.addEventListener('change', () => resetInputs(movchange, LotNumber));
});

$(document).ready(function(){
	function checkInputs() {
		if ($('.UseDepart').val().length > 0 || $('.InputStorage').val().length > 0) {  // 사용 부서나 입고 창고에 한 글자라도 작성되어 있으면
			$('.LotNumber').prop('disabled', true);  // 'LotNumber' 클래스를 가진 input 필드 사용 불가능
		} else if ($('.LotNumber').val().length > 0) {  // 'LotNumber' 클래스를 가진 input 필드에 한 글자라도 작성되어 있으면
			$('.UseDepart, .InputStorage').prop('disabled', true);  // 사용 부서와 입고 창고 입력 불가능
		} else {  // 작성되어 있는 글자가 없으면
			$('.LotNumber, .UseDepart, .InputStorage').prop('disabled', false);  // 모든 필드 입력 가능
		}
	}

	$('.LotNumber, .UseDepart, .InputStorage').on('change', function() {
		checkInputs();
	});
	
	// 페이지 로드 시 초기 상태 체크
	checkInputs();
	
	$('.IR').hide();
    $('.movCode').change(function() {
    	console.log("movCode field has changed"); // 확인 메시지 추가
        var Code = $(this).val();
    	
        if (Code.startsWith('IR')) {
            $('.IR').show(); // 'IR'로 시작할 때만 테이블 보이기
            $('.GI').hide();
        } else {
            $('.IR').hide(); // 'IR'로 시작하지 않을 때는 테이블 숨기기
            $('.GI').show();
        }
        
        var date = $('.Out_date').val();
        console.log("전달받은 Movement Type Code : " + Code + "전달받은 날짜 : " + date);
        $.ajax({
            type : "POST",
            url : "MakeDocNumber.jsp",
            data : {movCode : Code, Outdate : date},
            success : function(response){
           		console.log(response);
           		$('input[name="Doc_Num"]').val($.trim(response));
           		$('input[name="GINo"]').val("0001").change();
                // 여기에 성공한 경우 수행할 작업을 추가합니다.
            }
        })
    });
	
	var rowNum = 1;
	var itemNum = 0;
	var deletedItems = []; 
    var maxRowNum = 0;
	
	$(document).on('click', "img[name='Down']", function(){
		
	var outCount = $('.OutCount').val(); // 출고 수량 3
	var materialCode = $('.MaterialCode').val();// 출고 자재코드 010101-00001
	var outStorage = $('.StorageCode').val();// 출고창고
	var inputStorage = $('.InputStorage').val(); // IR일 때, 입고 창고
	var giIr = $('.movCode').val();
	var ComCode = $('.plantComCode').val();
	var OutPlant = $('.plantCode').val();
	var plantCode = $('.TransPlantCode').val();
	var InputComCode = $('.TransComCode').val();
	
	console.log('확인용 출고 수량 : ' + outCount + ', 출고자재코드 : ' + materialCode + ', 출고창고 : ' + outStorage + ", MovementType : " + giIr + ", IR일 경우 입고 창고 : " + inputStorage);
	
	itemNum++;
	var currentGIN = parseInt($('.GINo').val(), 10);
	var type = $('.movCode').val().substring(0, 2);
	var DataToSend = {};
	$(".KeyInfo").each(function(){
		var name = $(this).attr("name");
		var value = $(this).val();
		DataToSend[name] = value;
	});
	const DataArry = [$('.MatCode'),$('.MatDes'),$('.MatType'),$('.MatLotNo'),$('.MakeDate'),$('.DeadDete'),$('.OutCount'),$('.OrderUnit'),$('.UseDepart'),$('.BeforeCount'),$('.DepartName'),$('.InputStorage'),$('.LotNumber')];
	DataArry.forEach(input => input.val(''));
	
	$('.UseDepart').prop('disabled', false);
	$('.InputStorage').prop('disabled', false);
	$('.LotNumber').prop('disabled', false);
		
	$.ajax({
		url : /* 'EXP.jsp' */ 'tmhcEdit.jsp',
		type : 'POST',
		data : {count : outCount, matCode : materialCode, Storage : outStorage, giir : giIr, Input : inputStorage, ComPany : ComCode, Plant : plantCode, OutPlantCd : OutPlant , InputComCd : InputComCode},
		success : function(response){
	        if(response.status == "success"){
	            console.log('수정 완료' + response.message);
	        } else {
	            console.log('수정 실패: ' + response.message);
	        }
	    },
	    error: function(jqXHR, textStatus, errorThrown){
	        alert('오류 발생: ' + textStatus + ', ' + errorThrown);
	    }
	});
});
	$(".WrittenForm").on('click',"input[name='deleteBTN']",function(){
		var row = $(this).closest('tr');
		var orderNum = row.find('td:eq(2)').text();
		var GINo = row.find('td:eq(3)').text();
		console.log("삭제될 항번의 Doc_Num : " + orderNum + ", 삭제될 항번의 GI Item No : " + GINo);
		deletedItems.push({doc_num : orderNum, GINO : GINo});
		console.log(deletedItems);
		console.log("곧 삭제될 항번의 Doc_Num : " + orderNum + ", GI Item No : " + GINo);
		row.remove();
		row--;
		
		$(".WrittenForm tr").each(function(index){
			if(index != 0){
				$(this).find('td:first').text(index);
			}
		});
		$.ajax({
			url : 'delete.jsp',
			type : 'POST',
			data : {'data' : JSON.stringify(deletedItems)},
			contentType : 'application/x-www-form-urlencoded; charset=utf-8',
			dataType : 'json',
			async : false,
			success : function(data){
				if(data.result){
					console.log("삭제 성공");
					$("input[name='GINo']").val(data.deletedGINO); // 삭제된 GINO 입력
				} else{
					console.log("삭제 실패 : " + data.message);
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
					console.log("AJAX error: " + textStatus + ' : ' + errorThrown);
			}
		});
			console.log(deletedItems);
	});
	$('.GINo').change(function() {
        var number = $(this).val();
        var doc = $('.Doc_Num').val();
        console.log("전달받은 GI Item No : " + number + ", Mat.출고 문서번호 : " + doc);
        $.ajax({
            type : "POST",
            url : "Deduplication.jsp",
            data : {movCode : number, docCode : doc},
            success : function(response){
           		console.log(response);
           		$('input[name="GINo"]').val($.trim(response));
                // 여기에 성공한 경우 수행할 작업을 추가합니다.
            }
        })
    });
});
</script>

<%
	request.setCharacterEncoding("UTF-8");
	String User_Id = /* (String) session.getAttribute("id") */"17011381";
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String Today = today.format(formatter);

%>
</head>
<body>
	<h1>자재출고</h1>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
		<form name="OPResgistform" id="OPResgistform" action="OutPut_Ok.jsp" method="POST" enctype="UTF-8">
			<div class="Content-Wrapper-OutAside">
				<aside class="side-menu-container" id="Out_SideMenu">
					<li>Plant</li>
						<td class="input-info">
							<!-- <a href="javascript:PlantSearch()"><input type="text" class="plantCode KeyInfo" name="plantCode" readonly></a> -->
							<input type="text" class="plantCode KeyInfo" name="plantCode" onclick="InfoSearch('PlantSearch')" readonly>
							<input type="text" class="plantDes" name="plantDes" readonly>
							<input type="text" class="plantComCode KeyInfo" name="plantComCode" hidden>
						</td>
						
					<br><br>						
						
					<li>출고창고</li>
						<td class="input-info">
							<!-- <a href="javascript:StorageSearch()"><input type="text" class="StorageCode KeyInfo" name="StorageCode" readonly></a> -->
							<input type="text" class="StorageCode KeyInfo" name="StorageCode" onclick="InfoSearch('StorageSearch')" readonly>
							<input type="text" class="StorageDes" name="StorageDes" readonly>
							<input type="text" class="StorageComCode" name="StorageComCode" hidden>
						</td>
								
					<br><br>
					

					
					<li>Movement Type : </li>
						<td class="input-info">
							<!-- <a href="javascript:MovSearch()"><input type="text" class="movCode KeyInfo" name="movCode" readonly></a> -->
							<input type="text" class="movCode KeyInfo" name="movCode" onclick="InfoSearch('MovSearch')" readonly>
							<input type="text" class="movDes" name="movDes" readonly>
							<input type="text" class="PlusMinus" name="PlusMinus" hidden>
						</td>
					
					<br><br>	
					
					<li>Mat. 출고 문서번호</li>
						<td class="input-info">
							<input type="text" class="Doc_Num KeyInfo" name="Doc_Num" readonly>
						</td>
					
					<br><br>
											
					<li>출고일자 : </li>
						<td class="input-info">
							<input type="text" class="Out_date KeyInfo" name="Out_date" readonly value="<%=Today%>">
						</td>
					
					<br><br>
						
					<li> 출고 담당자 사번</li>
						<td class="input-info">
							<%
							if(User_Id != null){
							%>
							<input type="text" class="User_Id" name="User_Id" readonly value="<%=User_Id%>">
							<%
							} else{
							%>
							<input type="text" class="User_Id" name="User_Id" readonly>
							<%
							}
							%>
						</td>	
				</aside>
	<div class="Content-Wrapper-OutMain">
		<section>
			<div class="output-sub-info"> <!-- output-sub-info START -->
				<div class="table-container">
					<table class="sub-table-01">
						<tr>
							<th class="info">GI Item No : </th> 
								<td class="input-info">
									<input type="text" class="GINo KeyInfo" name="GINo" readonly> 
								</td>
						</tr>
					</table>
					
					<table class="sub-table-02">
						<tr><th class="info">Material : </th>
							<td class="input-info" colspan="2">
								<input type="text" class="MatCode KeyInfo" name="MatCode" onclick="InfoSearch('MatSearch')" readonly>
								<input type="text" class="MatDes KeyInfo" name="MatDes" readonly><!--  전송 -->
								<input type="text" class="MatType KeyInfo" name="MatType" hidden>
								<input type="text" class="MaterialCode KeyInfo" name="MaterialCode" hidden> <!-- //? -->
							</td>
						</tr>
					</table>
					
					<table class="sub-table-03">
						<tr>
							<th class="info">자재 Lot 번호 : </th>
								<td class="input-info">
									<input type="text" class="MatLotNo KeyInfo" name="MatLotNo" onclick="InfoSearch('LotSearch')" readonly>
								</td>
								
								<td class="spaceCell-80"></td>
								
							<th class="info">제조일자 : </th>
								<td class="input-info"> 
									<input type="text" class="MakeDate KeyInfo" name="MakeDate" readonly> 
								</td> 
								
								<td class="spaceCell-80"></td>
								
							<th class="info">유효기간 만료일자 : </th>
								<td class="input-info">
									<input type="text" class="DeadDete KeyInfo" name="DeadDete" readonly>
								</td>		
						</tr>
					</table>
					
					<table class="sub-table-04">
						<tr>
							<th class="info">창고 Rack : </th>
								<td class="input-info"> 
									<input type="text" class="Rack" name="Rack" readonly>
								</td>
								
								<td class="spaceCell-ss"></td>
								
							<th class="info">Bin : </th>
								<td class="input-info"> 
									<input type="text" class="Bin" name="Bin" readonly> 
								</td>		
						</tr>
					</table>
					
					<table class="sub-table-05">
						<tr>
							<th class="info">출고 수량 : </th>
								<td class="input-info"> 
									<input type="text" class="OutCount KeyInfo" name="OutCount">
								</td>
								
								<td class="spaceCell-40"></td>
								
							<th class="info">단위 : </th>
								<td class="input-info"> 
									<input type="text" class="OrderUnit KeyInfo" name="OrderUnit"readonly> 
								</td> 
								
								<td class="spaceCell-250"></td>
								
							<th class="info">출고 전 창고재고 : </th>
								<td class="input-info">
									<input type="text" class="BeforeCount" name="BeforeCount" readonly>
								</td>	 
								
								<td class="spaceCell-40"></td>
						</tr>
					</table>
					
					<table class="sub-table-06">
						<tr>
							<th class="info GI">사용 부서 : </th>
								<td class="input-info GI">
									<input type="text" class="UseDepart KeyInfo" name="UseDepart" onclick="InfoSearch('DepartSearch')" readonly>
								</td>
							<th class="info IR">입고 창고 : </th>
								<td class="input-info IR">
									<input type="text" class="InputStorage KeyInfo" name="InputStorage" onclick="InfoSearch('InputSearch')" readonly>
									<input type="text" class="TransPlantCode" name="TransPlantCode" hidden>
									<input type="text" class="TransComCode" name="TransComCode" hidden>
								</td>
							
							<td class="spaceCell-23"></td>
							
							<th class="info">부서명 : </th>
								<td class="input-info"> 
									<input type="text" class="DepartName" name="DepartName" readonly> 
								</td> 	
						</tr>
					</table>
					
					<table class="sub-table-07">
						<tr>
							<th class="info">생산 Lot번호 : </th>
								<td class="input-info">
									<input type="text" class="LotNumber KeyInfo" name="LotNumber">
								</td>
						</tr>
					</table>
				</div>
			</div><!-- output-sub-info END -->
		</section>
		
		<section>
			<div class="inputArea">
				<img name="Down" src="../img/Dvector.png" alt="">
				<input class="input-btn" id="btn" type="submit" value="Insert">
			</div>
		</section>
		
			<section>				
				<div class="expiredData">
					<div class="table-container">
						<table class="WrittenForm">
							<tr>
								<th>항번</th><th>삭제</th><th>문서번호</th><th>품목번호</th><th>자재</th><th>자재 설명</th><th>자재 유형</th><th>출고 구분</th><th>수량</th><br>
								<th>단위</th><th>사용 부서</th><th>생산 Lot 번호</th><th>출고 일자</th><th>자재 Lot 번호</th><th>출고 창고</th><th>공장</th><th>입고 창고</th>
							</tr>
						</table>
					</div>
				</div>
			</section>				
</div>				
			</div> <!-- Content-Wrapper-OutAside END -->	
		</form>
</body>
</html>
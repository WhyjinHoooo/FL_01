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
    	popupHeight = 635;
    	window.open("${contextPath}/Material/PlantSerach.jsp", "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    break;
	case "StorageSearch":
		popupWidth = 550;
		popupHeight = 635;
		window.open("${contextPath}/Material_Output/StorageSerach.jsp?comcode=" + comcode, "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "MovSearch":
		popupWidth = 1075;
		popupHeight = 750;
		window.open("${contextPath}/Material_Output/MovSerach.jsp", "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "MatSearch":
		popupWidth = 910;
		popupHeight = 600;
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
	function InitialTable(){
		$('.WrittenForm_Body').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 17; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.WrittenForm_Body').append(row);
        }
	}
	
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
	InitialTable();
	
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
	 
	$(document).on('click', "img[name='Down']", function(){
		var InfoArray = [];
	
		var DocCode = $('.Doc_Num').val(); // Mat. 출고 문서번호 !
		var SeqNum = $('.GINo').val(); // 아이템 번호 !
		
		var outCount = $('.OutCount').val(); // 출고 수량 3
		
		var materialCode = $('.MatCode').val();// 출고 자재코드 010101-00001
		var MatDes = $('.MatDes').val(); // 출고 자재에 대한 설명 !
		var MatType = $('.MatType').val(); // 자재 종류 !
		var MatCountUnit = $('.OrderUnit').val(); // 자재 단위 !
		
		var outStorage = $('.StorageCode').val();// 출고창고
		var inputStorage = $('.InputStorage').val(); // IR일 때, 입고 창고
		var giIr = $('.movCode').val();
		var ComCode = $('.plantComCode').val();
		var OutPlant = $('.plantCode').val();
		var plantCode = $('.TransPlantCode').val();
		var InputComCode = $('.TransComCode').val();
		
		var UseDepart = $('.UseDepart').val(); // 사용 부서 !
		var ProLotNum = $('.LotNumber').val(); // 생산 Lot번호 !
		var MatLotNum = $('.MatLotNo').val();// 자재 Lot 번호 !
		InfoArray = [outCount, materialCode, outStorage, giIr, inputStorage, ComCode, plantCode, OutPlant, InputComCode];
		
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
			url : 'tmhcEdit.jsp',
			type : 'POST',
			data :  JSON.stringify(InfoArray),
			success : function(response){
				console.log(response.status);
				console.log(response.DataList);
		        if(response.status == "success"){
		        	if($('.WrittenForm_Body > tr').length === 50){
		        		$('.WrittenForm_Body').empty();
			        	for(var i = 0 ; i < response.DataList.length ; i++){
			        		var row = '<tr>' +
							'<td>' + currentGIN + '</td>' + // 0
							'<td><button class="deleteBTN" id="deleteBTN">삭제</button></td>' + 
							'<td>' + DocCode + '</td>' + 
							'<td>' + String(currentGIN).padStart(4, "0") + '</td>' + 
							'<td>' + response.DataList[i].MatCode + '</td>' + 
							'<td>' + MatDes + '</td>' + 
							'<td>' + MatType + '</td>' + 
							'<td>' + response.DataList[i].movType + '</td>' +
							'<td>' + response.DataList[i].Count + '</td>' + 
							'<td>' + MatCountUnit + '</td>' + 
							'<td>' + UseDepart + '</td>' + 
							'<td>' + ProLotNum + '</td>' + 
							'<td>' + "출고 일자" + '</td>' + 
							'<td>' + MatLotNum + '</td>' + 
							'<td>' + response.DataList[i].Storage + '</td>' + 
							'<td>' + response.DataList[i].OutPlant + '</td>' +
							'<td>' + "입고 창고" + '</td>' +
							'<td hidden>' + response.DataList[i].ComCode + '</td>' +
							'</tr>';
						$('.WrittenForm_Body').append(row);
			        	}
		        		$('.GINo').val('0002');
		        	} else {
		        		for(var i = 0 ; i < response.DataList.length ; i++){
			        		var row = '<tr>' +
							'<td>' + currentGIN + '</td>' + // 0
							'<td><button class="deleteBTN" name="deleteBTN">삭제</button></td>' + 
							'<td>' + DocCode + '</td>' + 
							'<td>' + String(currentGIN).padStart(4, "0") + '</td>' + 
							'<td>' + response.DataList[i].MatCode + '</td>' + 
							'<td>' + MatDes + '</td>' + 
							'<td>' + MatType + '</td>' + 
							'<td>' + response.DataList[i].movType + '</td>' +
							'<td>' + response.DataList[i].Count + '</td>' + 
							'<td>' + MatCountUnit + '</td>' + 
							'<td>' + UseDepart + '</td>' + 
							'<td>' + ProLotNum + '</td>' + 
							'<td>' + "출고 일자" + '</td>' + 
							'<td>' + MatLotNum + '</td>' + 
							'<td>' + response.DataList[i].Storage + '</td>' + 
							'<td>' + response.DataList[i].OutPlant + '</td>' +
							'<td>' + "입고 창고" + '</td>' +
							'<td hidden>' + response.DataList[i].ComCode + '</td>' +
							'</tr>';
						$('.WrittenForm_Body').append(row);
			        	}
		        		$('.GINo').val(String($('.WrittenForm_Body > tr').length + 1).padStart(4, "0"));
		        	}
		        	
		        } 
		    },
		    error: function(jqXHR, textStatus, errorThrown){
		        alert('오류 발생: ' + textStatus + ', ' + errorThrown);
		    }
		});
	});
	var DeleteEle = [];
	$(document).on("click", ".deleteBTN", function() {
		event.preventDefault();
		var row = $(this).closest('tr');
		var orderNum = row.find('td:eq(2)').text(); // 문서번호
		var GINo = row.find('td:eq(3)').text(); // 품목번호
		var MatCode = row.find('td:eq(4)').text(); // 자재 코드
		var ComCode = row.find('td:eq(17)').text(); // 기업 코드
		var PlantCode = row.find('td:eq(15)').text(); // 공장(plant) 코드
		var StorageCode = row.find('td:eq(14)').text(); // 창고(storage) 코드
		var Date = $('.Out_date').val().substring(0,7);
		var Count = row.find('td:eq(8)').text();
		
		DeleteEle = [orderNum, GINo, MatCode, ComCode, StorageCode, PlantCode, Date, Count];
		$.ajax({
			url : '${contextPath}/Material_Output/delete.jsp',
			type : 'POST',
			data : JSON.stringify(DeleteEle),
			contentType: 'application/json; charset=utf-8',
			dataType : 'json',
			success : function(response){
				if(response.status === 'success'){
					row.remove();
					var index = $('.WrittenForm_Body tr').length;
					if(index === 0){
						$('.GINo').val('0001');
						InitialTable();
					} else{
						$('.GINo').val(String(index+1).padStart(4, "0"));
						$('.WrittenForm_Body tr').each(function(index){
							var number = index + 1;
							console.log('number : ' + number);
							$(this).find('td:eq(0)').text(number);
							$(this).find('td:eq(3)').text(("0000" + number).slice(-4));
						});
					}
				}
			},error: function(jqXHR, textStatus, errorThrown) {
			    console.log("AJAX 오류: " + textStatus + " : " + errorThrown);
			}
		});
	});	
	$('.input-btn').click(function() {
		location.reload();
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
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="Mat-OutPut">
	<div class="MatOutPut-Header">
		<div class="Title"">타이틀</div>
		<div class="InfoInput">
			<label>Company Code : </label>
			<input type="text" class="ComCode HeadInfo InputInfo Header" name="ComCode" onclick="InfoSearch('ComSearch')" readonly>
			<input type="text" class="Com_Name" name="Com_Name" hidden> 
		</div>
		<div class="InfoInput">
			<label>Plant : </label>
			<input type="text" class="plantCode KeyInfo" name="plantCode" onclick="InfoSearch('PlantSearch')" readonly>
			<input type="text" class="plantDes" name="plantDes" readonly>
		</div>
		<div class="InfoInput">
			<label>출고창고 : </label>
			<input type="text" class="StorageCode KeyInfo" name="StorageCode" onclick="InfoSearch('StorageSearch')" placeholder="SELECT" readonly>
			<input type="text" class="StorageDes" name="StorageDes" readonly>
			<input type="text" class="StorageComCode" name="StorageComCode" hidden>
		</div>
		<div class="InfoInput">
			<label>Movement Type : </label>
			<input type="text" class="movCode KeyInfo" name="movCode" onclick="InfoSearch('MovSearch')" placeholder="SELECT" readonly>
			<input type="text" class="movDes" name="movDes" readonly>
			<input type="text" class="PlusMinus" name="PlusMinus" hidden>
		</div>
		<div class="InfoInput">
			<label>Mat. 출고 문서번호 : </label>
			<input type="text" class="Doc_Num KeyInfo" name="Doc_Num" readonly>
		</div>
		<div class="InfoInput">
			<label>출고일자 : </label>
			<input type="text" class="Out_date KeyInfo" name="Out_date" readonly value="<%=Today%>">
		</div>
		<div class="InfoInput">
			<label>출고 담당자 사번 : </label>
			<input type="text" class="User_Id" name="User_Id" readonly value="<%=User_Id%>">
		</div>
		
		<div class="BtnArea">
				<button>Create</button>
		</div>	
	</div>	
	<div class="MatOutPut-Body">
		<div class="Title">타이틀</div>
		<div class="Mat-Area"> <!-- output-sub-info START -->
			<div class="InfoInput">
				<label>GI Item No : </label>
				<input type="text" class="GINo KeyInfo" name="GINo" readonly> 
			</div>
			<div class="InfoInput">
				<label>Material : </label>
				<input type="text" class="MatCode KeyInfo" name="MatCode" onclick="InfoSearch('MatSearch')" readonly>
				<input type="text" class="MatDes KeyInfo" name="MatDes" readonly><!--  전송 -->
				<input type="text" class="MatType KeyInfo" name="MatType" hidden>
				<input type="text" class="MatDocCode KeyInfo" name="MatDocCode" hidden> <!-- //? -->
			</div>
			<div class="InfoInput">
				<label>자재 Lot 번호 : </label>
				<input type="text" class="MatLotNo KeyInfo" name="MatLotNo" onclick="InfoSearch('LotSearch')" readonly>
				
				<label>제조일자 : </label>
				<input type="text" class="MakeDate KeyInfo" name="MakeDate" readonly> 
				
				<label>만료일자 : </label>
				<input type="text" class="DeadDete KeyInfo" name="DeadDete" readonly>
			</div>
			<div class="InfoInput">
				<label>창고 Rack : </label>
				<input type="text" class="Rack" name="Rack" readonly>
				
				<label>Bin : </label>
				<input type="text" class="Bin" name="Bin" readonly> 
			</div>
			<div class="InfoInput">
				<label>출고 수량 : </label>
				<input type="text" class="OutCount KeyInfo" name="OutCount">
				
				<label>단위 : </label>
				<input type="text" class="OrderUnit KeyInfo" name="OrderUnit"readonly>
				
				<label>출고 전 창고재고 : </label>
				<input type="text" class="BeforeCount" name="BeforeCount" readonly>
			</div>
			<div class="InfoInput">
				<label>사용 부서 : </label>
				<input type="text" class="UseDepart KeyInfo" name="UseDepart" onclick="InfoSearch('DepartSearch')" readonly>
				
				<label>입고 창고  : </label>
				<input type="text" class="InputStorage KeyInfo" name="InputStorage" onclick="InfoSearch('InputSearch')" readonly>
				<input type="text" class="TransPlantCode" name="TransPlantCode" hidden>
				<input type="text" class="TransComCode" name="TransComCode" hidden>
				
				<label>부서명 : </label>
				<input type="text" class="DepartName" name="DepartName" readonly>
			</div>
			<div class="InfoInput">
				<label>생산 Lot번호 : </label>
				<input type="text" class="LotNumber KeyInfo" name="LotNumber">
			</div>	
		</div>
	</div>
		
	<div class="BtnArea">
		<button class="InsertBtn">Insert</button>
		<button class="SaveBtn">Save</button>
		<button class="ResetBtn">Reset</button>
	</div>
				
	<div class=Info-Area>
		<div class="Title">타이틀</div>
		<table class="InfoTable" id="InfoTable">
			<thead>
				<th>항번</th><th>삭제</th><th>문서번호</th><th>품목번호</th><th>자재</th><th>자재 설명</th><th>자재 유형</th><th>출고 구분</th><th>수량</th><br>
				<th>단위</th><th>사용 부서</th><th>생산 Lot 번호</th><th>출고 일자</th><th>자재 Lot 번호</th><th>출고 창고</th><th>공장(Plant)</th><th>입고 창고</th>
			</thead>
			<tbody class="InfoBody">
			</tbody>
		</table>
	</div>	
</div>
</body>
</html>
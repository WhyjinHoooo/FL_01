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
	
	var popupWidth = 500;
    var popupHeight = 600;
    
   	var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
    var ComCode = $('.ComCode').val();
    var plantcode = $('.PlantCode').val();
    var storagecode = $('.StorageCode').val();
    
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
    case "ComSearch":
    	window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "PlantSearch":
    	window.open("${contextPath}/Information/PlantSerach.jsp?ComCode=" + ComCode, "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    break;
	case "StorageSearch":
		window.open("${contextPath}/Material_Output/PopUp/StorageSerach.jsp?comcode=" + ComCode, "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "MovSearch":
		popupWidth = 1050;
		popupHeight = 750;
		window.open("${contextPath}/Material_Output/PopUp/MovSerach.jsp", "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "MatSearch":
		popupWidth = 1670;
		popupHeight = 500;
		xPos = (monitorWidth / 2) - (popupWidth / 2) + dualScreenLeft;
        yPos = (monitorHeight / 2) - (popupHeight / 2) + dualScreenTop;
		window.open("${contextPath}/Material_Output/PopUp/MatSearch.jsp?plantcode=" + plantcode + "&storagecode=" + storagecode, "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "DepartSearch":
		window.open("${contextPath}/Material_Output/PopUp/DepartSearch.jsp", "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	case "InputSearch":
		window.open("${contextPath}/Material_Output/PopUp/InputSearch.jsp?outStorage=" + storagecode, "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
	break;
	}
}
$(document).ready(function(){
	function InitialTable(){
		var UserId = $('.UserID').val();
		$('.InfoBody').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>'); // 새로운 <tr> 생성
            // 34개의 빈 <td> 요소 추가 (3개의 헤더 항목 이후 31일치 데이터)
            for (let j = 0; j < 17; j++) {
                row.append('<td></td>');
            }
            // 생성한 <tr>을 <tbody>에 추가
            $('.InfoBody').append(row);
        }
		$.ajax({
			url:'${contextPath}/Material_Output/AjaxSet/ForPlant.jsp',
			type:'POST',
			data:{id : UserId},
			dataType: 'text',
			success: function(data){
				var dataList = data.trim().split('-');
				$('.PlantCode').val(dataList[0]);
				$('.PlantDes').val(dataList[1]);
			}
		})
		$('.InputStorage').prop('disabled', true);
	}
	function DateSetting(){
		var CurrentDate = new Date();
		var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-' + ('0' + CurrentDate.getDate()).slice(-2);
		$('.Out_date').val(today);
	}
	function checkInputs() {
		if ($('.UseDepart').val().length > 0 || $('.InputStorage').val().length > 0) {
			$('.LotNumber').prop('disabled', true); 
		} else if ($('.LotNumber').val().length > 0) {
			$('.UseDepart, .InputStorage, .DepartName').prop('disabled', true);
		} else {  // 작성되어 있는 글자가 없으면
			$('.LotNumber, .UseDepart, .InputStorage, .DepartName').prop('disabled', false);
		}
	}
	function BodyDisabled(){
		$('.Mat-Area').find('input').prop('disabled', true);
	}
	function BodyAbled(){
		var MovType = $('.movCode').val();
		if(MovType.substring(0,2) === 'IR'){
			$('.Mat-Area').find('input').prop('disabled', false);
		}else{
			$('.Mat-Area').find('input').prop('disabled', false).filter('.InputStorage').prop('disabled', true);
		}
	}
	$('.DepartReset').click(function(){
		$('.UseDepart').val('');
		$('.DepartName').val('');
		
		$('.LotNumber').prop('disabled', false);
	})
	$('.UseDepart, .InputStorage').on('change', function() {
		checkInputs();
	});
	$('.LotNumber').on('input',function(){
		checkInputs();
	})
	$('.OutCount').on('input',function(){
		var ExportValue = Number($(this).val());
		var Inventory = Number($('.BeforeCount').val());
		if(ExportValue > Inventory){
			alert('출고수량('+ ExportValue +')을 다시 입력해주세요.');
			$(this).val('');
			return false;
		}
	})
	checkInputs();
	InitialTable();
	DateSetting();
	BodyDisabled();
    $('.movCode').change(function() {
        var Code = $(this).val();
        if (Code.substring(0,2) === 'IR') {
        	$('.InputStorage').prop('disabled', false);
        } else {
        	$('.InputStorage').prop('disabled', true);
        }
        
        var date = $('.Out_date').val();
        $.ajax({
            type : "POST",
            url : "${contextPath}/Material_Output/AjaxSet/MakeDocNumber.jsp",
            data : {movCode : Code, Outdate : date},
            success : function(response){
           		$('input[name="Doc_Num"]').val($.trim(response));
           		$('input[name="GINo"]').val("0001").change();
                // 여기에 성공한 경우 수행할 작업을 추가합니다.
            }
        })
    });
    var AbledList = {};
	$('.MatOutPut-Header > .BtnArea > button').click(function(){
		$('.Abled').each(function(){
			var name = $(this).attr("name");
            var value = $(this).val();
			AbledList[name] = value;
		})
		var pass = true;
		$.each(AbledList,function(key, value){
    		if(value == null || value === ''){
    			pass = false;
    			return false;
    		}
    	})
    	if(!pass){
    		alert('모든 항목을 입력해주세요.');
    	}else{
    		BodyAbled();
    	}
		
	})
	$('.ResetBtn').click(function(){
		location.reload();
	})
	var InfoArray = {};
	$('.InsertBtn').click(function(){
		$('.KeyInfo').each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            InfoArray[name] = value;
        });
    	var pass = true;
    	$.each(InfoArray,function(key, value){
    		if (key === 'InputStorage' || key === 'LotNumber') {
    	        return true;
    	    }
    	    if (value == null || value === '') {
    	        pass = false;
    	        return false;
    	    }
    	})
		console.log(InfoArray);
/* 		$.ajax({
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
		}); */
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
String UserId = (String)session.getAttribute("id");
String userComCode = (String)session.getAttribute("depart");
String UserIdNumber = (String)session.getAttribute("UserIdNumber");
%>
</head>
<body>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="Mat-OutPut">
	<div class="MatOutPut-Header">
		<div class="Title"">타이틀</div>
		<div class="InfoInput">
			<label>Company Code : </label>
			<input type="text" class="ComCode KeyInfo" name="ComCode" onclick="InfoSearch('ComSearch')" value="<%=userComCode %>" readonly>
			<input type="text" class="Com_Name" name="Com_Name" hidden> 
		</div>
		<div class="InfoInput">
			<label>Plant : </label>
			<input type="text" class="PlantCode KeyInfo" name="PlantCode" onclick="InfoSearch('PlantSearch')" readonly>
			<input type="text" class="PlantDes" name="PlantDes" readonly>
		</div>
		<div class="InfoInput">
			<label>출고창고 : </label>
			<input type="text" class="StorageCode Abled KeyInfo" name="StorageCode" onclick="InfoSearch('StorageSearch')" placeholder="SELECT" readonly>
			<input type="text" class="StorageDes" name="StorageDes" readonly>
		</div>
		<div class="InfoInput">
			<label>Movement Type : </label>
			<input type="text" class="movCode Abled KeyInfo" name="movCode" onclick="InfoSearch('MovSearch')" placeholder="SELECT" readonly>
			<input type="text" class="movDes" name="movDes" readonly>
			<input type="text" class="PlusMinus KeyInfo" name="PlusMinus" hidden>
		</div>
		<div class="InfoInput">
			<label>Mat. 출고 문서번호 : </label>
			<input type="text" class="Doc_Num KeyInfo" name="Doc_Num" readonly>
		</div>
		<div class="InfoInput">
			<label>출고일자 : </label>
			<input type="text" class="Out_date KeyInfo" name="Out_date" readonly>
		</div>
		<div class="InfoInput">
			<label>출고 담당자 사번 : </label>
			<input type="text" class="UserID KeyInfo" name="UserID" readonly value="<%=UserIdNumber%>">
		</div>
		
		<div class="BtnArea">
			<button>Create</button>
		</div>	
	</div>	
	<div class="MatOutPut-Body">
		<div class="Title">타이틀</div>
		<div class="Mat-Area">
			<div class="InfoInput">
				<label>GI Item No : </label>
				<input type="text" class="GINo KeyInfo" name="GINo" readonly> 
			</div>
			
			<div class="InfoInput">
				<label>Material : </label>
				<input type="text" class="MatCode KeyInfo" name="MatCode" onclick="InfoSearch('MatSearch')" readonly>
				<input type="text" class="MatDes KeyInfo" name="MatDes" readonly><!--  전송 -->
			</div>
			
			<div class="InfoInput">
				<label>자재 Lot 번호 : </label>
				<input type="text" class="MatLotNo KeyInfo" name="MatLotNo" readonly>
				
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
				<input type="number" class="OutCount KeyInfo" name="OutCount">
				
				<label>단위 : </label>
				<input type="text" class="OrderUnit KeyInfo" name="OrderUnit"readonly>
				
				<label>출고 전 창고재고 : </label>
				<input type="text" class="BeforeCount" name="BeforeCount" readonly>
			</div>
			
			<div class="InfoInput">
				<label>사용 부서 : </label>
				<input type="text" class="UseDepart KeyInfo" name="UseDepart" onclick="InfoSearch('DepartSearch')" readonly>
				<button class="DepartReset">Clear</button>
				
				<label>부서명 : </label>
				<input type="text" class="DepartName" name="DepartName" readonly>
				
				<label>입고 창고  : </label>
				<input type="text" class="InputStorage KeyInfo" name="InputStorage" onclick="InfoSearch('InputSearch')" readonly>
			</div>
			
			<div class="InfoInput">
				<label>생산 Lot번호 : </label>
				<input type="text" class="LotNumber KeyInfo" name="LotNumber">
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
</div>
</body>
</html>
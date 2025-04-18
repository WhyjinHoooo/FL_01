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
<link rel="stylesheet" href="../css/MatOIO.css?after">
<title>자재출고</title>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
var path = window.location.pathname;
var Address = path.split("/").pop();
window.addEventListener('unload', (event) => {
	
	var data = {
		action : 'deleteOrderData',
		page : Address
			
	}
    navigator.sendBeacon('../DeleteOrder', JSON.stringify(data));
});
document.addEventListener('DOMContentLoaded', function() {
    const thead = document.querySelector('.InfoTable_Header');
    const tbody = document.querySelector('.InfoTable_Body');
    
    tbody.addEventListener('scroll', function() {
        thead.scrollLeft = tbody.scrollLeft;
    });
});
function PopupPosition(popupWidth, popupHeight) {
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
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
    
    return { x: xPos, y: yPos };
}
function InfoSearch(field){
    event.preventDefault();
    var popupWidth = 500;
    var popupHeight = 600;
    
    var ComCode = $('.ComCode').val();
    var plantcode = $('.PlantCode').val();
    var storagecode = $('.StorageCode').val();
    var MatCode = $('.MatCode').val();
    var DateCode = $('.Out_date').val();
    var OutTotalCode = ComCode + ',' + plantcode + ',' + MatCode + ',' + DateCode + ',' + storagecode;
    
    var position = PopupPosition(popupWidth, popupHeight);
    
    switch(field){
    case "ComSearch":
        window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
        break;
    case "PlantSearch":
        window.open("${contextPath}/Information/PlantSerach.jsp?ComCode=" + ComCode, "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "StorageSearch":
    	popupWidth = 900;
        popupHeight = 750;
    	position = PopupPosition(popupWidth, popupHeight);
        window.open("${contextPath}/Material_Output/PopUp/StorageSerach.jsp?OutCode=" + OutTotalCode, "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "MovSearch":
        popupWidth = 1050;
        popupHeight = 750;
        position = PopupPosition(popupWidth, popupHeight);
        window.open("${contextPath}/Material_Output/PopUp/MovSerach.jsp", "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "MatSearch":
        popupWidth = 850;
        popupHeight = 500;
        position = PopupPosition(popupWidth, popupHeight);
        window.open("${contextPath}/Material_Output/PopUp/MatSearch.jsp?plantcode=" + plantcode + "&storagecode=" + storagecode, "POPUP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "LotSearch":
        popupWidth = 950;
        popupHeight = 500;
        position = PopupPosition(popupWidth, popupHeight);
        window.open("${contextPath}/Material_Output/PopUp/LotSearch.jsp?MCode=" + MatCode + "&SCode=" + storagecode + "&PCode=" + plantcode, "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "DepartSearch":
        window.open("${contextPath}/Material_Output/PopUp/DepartSearch.jsp", "POPUP07", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    case "InputSearch":
        window.open("${contextPath}/Material_Output/PopUp/InputSearch.jsp?OutCode=" + OutTotalCode + "&", "POPUP08", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + position.x + ",top=" + position.y);
    break;
    }
}
$(document).ready(function(){
	function InitialTable(){
		var UserId = $('.UserID').val();
		$('.InfoTable_Body').empty();
		for (let i = 0; i < 50; i++) {
            const row = $('<tr></tr>');
            for (let j = 0; j < 16; j++) {
                row.append('<td></td>');
            }
            $('.InfoTable_Body').append(row);
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
		$('.Mat-Area').find('input, button').prop('disabled', true);
		$('.Mat-Area').find('button').prop('disabled', true);
		$('.Mat-Area').find('button').css('pointer-events', 'none');
		
	}
	function BodyAbled(){
		var MovType = $('.movCode').val();
		if(MovType.substring(0,2) === 'IR'){
			$('.Mat-Area').find('input').prop('disabled', false);
			$('.Mat-Area').find('button').prop('disabled', false);
			$('.Mat-Area').find('button').css('pointer-events', 'none');
		}else{
			$('.Mat-Area').find('input').prop('disabled', false).filter('.InputStorage').prop('disabled', true);
			$('.Mat-Area').find('button').prop('disabled', false);
			$('.Mat-Area').find('button').css('pointer-events', 'auto');
			
		}
	}
	$('.DepartReset, .LotReset').click(function(){
		if($(this).hasClass('DepartReset')){
			$('.UseDepart, .DepartName').val('');
			$('.LotNumber').prop('disabled', false);
		} else{
			$('.UseDepart, .DepartName, .LotNumber').val('');
			$('.LotNumber, .UseDepart, .DepartName').prop('disabled', false);
		}
		
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
			alert('출고수량을 다시 입력해주세요.');
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
            	$('.Mat-Area input').val('');
           		$('input[name="Doc_Num"]').val($.trim(response));
           		$('input[name="GINo"]').val("0001").change();
                // 여기에 성공한 경우 수행할 작업을 추가합니다.
            }
        })
    });
    $('.StorageCode').change(function() {
        var Code = $(this).val();
        $.ajax({
            type : "POST",
            url : "${contextPath}/Material_Output/AjaxSet/ForStoDes.jsp",
            data : {SLoCode : Code},
            success : function(response){
            	$('.StorageDes').val($.trim(response));
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

	var InfoArray = {};
	var Plus = 0;
	var RowNum = 0;
	$('.InsertBtn').click(function(){
		$('.KeyInfo').each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            InfoArray[name] = value;
        });
    	var pass = true;
    	$.each(InfoArray,function(key, value){
    		if (key === 'InputStorage' || key === 'LotNumber' || key === 'UseDepart' || key === 'DepartName') {
    	        return true;
    	    }
    	    if (value == null || value === '') {
    	        pass = false;
    	        return false;
    	    }
    	})
		console.log(InfoArray);
    	if(!pass){
    		alert('모든 항목을 입력해주세요.');
    	}else{
	    	$.ajax({
				url : '${contextPath}/Material_Output/AjaxSet/QuickSave.jsp',
				type : 'POST',
				data :  JSON.stringify(InfoArray),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success : function(data){
					if(data.status === 'Success'){
                		var QuickSavedData = data.DataList;
						if(Plus === 0){
                			$('.InfoTable_Body').empty();
                			RowNum = $('.InfoTable_Body tr').length;
                			console.log('RowNum : ' + RowNum);
                			var row = '<tr>' +
							'<td>' + (RowNum + 1).toString().padStart(2,'0') + '</td>' + 
							'<td><button class="DeleteBtn">Delete</button></td>' +
							'<td>' + QuickSavedData.Doc_Num + '</td>' + 
							'<td>' + QuickSavedData.GINo + '</td>' + 
							'<td>' + QuickSavedData.MatCode + '</td>' + 
							'<td>' + QuickSavedData.MatDes + '</td>' + 
							'<td>' + QuickSavedData.movCode + '</td>' + 
							'<td>' + QuickSavedData.OutCount + '</td>' + 
							'<td>' + QuickSavedData.OrderUnit + '</td>' + 
							'<td>' + QuickSavedData.UseDepart + '</td>' + 
							'<td>' + (QuickSavedData.LotNumber || 'N/A') + '</td>' + 
							'<td>' + QuickSavedData.Out_date + '</td>' + 
							'<td>' + QuickSavedData.MatLotNo + '</td>' +
							'<td>' + QuickSavedData.StorageCode + '</td>' +
							'<td>' + QuickSavedData.PlantCode + '</td>' +
							'<td>' + (QuickSavedData.InputStorage || 'N/A') + '</td>' +
							'</tr>';
	                		$('.InfoTable_Body').append(row);
	                		RowNum++;
						}else{
							RowNum = $('.InfoTable_Body tr').length;
                			console.log('RowNum : ' + RowNum);
                			var row = '<tr>' +
							'<td>' + (RowNum + 1).toString().padStart(2,'0') + '</td>' + 
							'<td><button class="DeleteBtn">Delete</button></td>' +
							'<td>' + QuickSavedData.Doc_Num + '</td>' + 
							'<td>' + QuickSavedData.GINo + '</td>' + 
							'<td>' + QuickSavedData.MatCode + '</td>' + 
							'<td>' + QuickSavedData.MatDes + '</td>' + 
							'<td>' + QuickSavedData.movCode + '</td>' + 
							'<td>' + QuickSavedData.OutCount + '</td>' + 
							'<td>' + QuickSavedData.OrderUnit + '</td>' + 
							'<td>' + QuickSavedData.UseDepart + '</td>' + 
							'<td>' + (QuickSavedData.LotNumber || 'N/A') + '</td>' + 
							'<td>' + QuickSavedData.Out_date + '</td>' + 
							'<td>' + QuickSavedData.MatLotNo + '</td>' +
							'<td>' + QuickSavedData.StorageCode + '</td>' +
							'<td>' + QuickSavedData.PlantCode + '</td>' +
							'<td>' + (QuickSavedData.InputStorage || 'N/A') + '</td>' +
							'</tr>';
	                		$('.InfoTable_Body').append(row);
	                		RowNum++;
                		}
						$('.GINo').val((RowNum + 1).toString().padStart(4,'0'));
						if(QuickSavedData.MatCode === $('.MatCode').val()){
							var currentCount = parseInt($('.BeforeCount').val()) || 0;
						    var newCount = currentCount - parseInt(QuickSavedData.OutCount);
						    $('.BeforeCount').val(newCount);
						}
			    	}
				},
				error: function(jqXHR, textStatus, errorThrown){
					alert('오류 발생: ' + textStatus + ', ' + errorThrown);
		    	}
	    	});
    	}
    	$('.Mat-Area input').not('.GINo, .MatCode, .MatDes, .MatLotNo, .MakeDate, .DeadDete, .OrderUnit, .BeforeCount').val('');
    	$('.LotNumber').prop('disabled', false);
    	Plus++;
	});
	
	$(".InfoTable_Body").on('click',".DeleteBtn", function(){
		event.preventDefault();
		var Row = $(this).closest('tr');
		var orderNum = Row.find('td:eq(2)').text(); // 문서번호
		var GINo = Row.find('td:eq(3)').text(); // 품목번호
		var Count = Row.find('td:eq(7)').text();
		var KeyCode = orderNum + '-' + GINo;
		var TableLength = 0;
		$.ajax({
			url : '${contextPath}/Material_Output/AjaxSet/QuickDelete.jsp',
			type : 'POST',
			data : {KeyValue : KeyCode},
			success : function(Data){
				var CurrentCount = parseInt($('.BeforeCount').val());
				var NewCount = CurrentCount + parseInt(Count);
				if(Data.trim() == 'Success'){
					$('.BeforeCount').val(NewCount);
					Row.remove();
					TableLength = $('.InfoTable_Body tr').length;
					if(TableLength === 0){
						for (let i = 0; i < 50; i++) {
				            const row = $('<tr></tr>');
				            for (let j = 0; j < 16; j++) {
				                row.append('<td></td>');
				            }
				            $('.InfoTable_Body').append(row);
				        }
						Plus = 0;
					}else{
						$('.InfoTable_Body tr').each(function(index, tr){
							var Element = $(this);
							ElementKeyValue = Element.find('td:eq(2)').text() + '-' + Element.find('td:eq(3)').text();
							$.ajax({
								type: "POST",
								url: "${contextPath}/Material_Output/AjaxSet/Quickmanage.jsp",
								data: { KeyValue: ElementKeyValue },
								success: function(response) {
									if(response.trim() === 'Success'){
										Element.find('td:eq(0)').text((index+1).toString().padStart(2,'0'));
										Element.find('td:eq(3)').text((index+1).toString().padStart(4,'0'));
									}
								},
								error: function(xhr, textStatus, errorThrown) {
									console.log(xhr.statusText);
								}
							});
						})
					}
				}
			}
		});
	});	
	var HeaderInfoList = {}; 
	$('.SaveBtn').click(function(){
		$(".Header").each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            HeaderInfoList[name] = value;
        });
    	console.log(HeaderInfoList);
    	$.ajax({
			url: '${contextPath}/Material_Output/MatOutput_Ok.jsp',
			type: 'POST',
			data: JSON.stringify(HeaderInfoList),
			contentType: 'application/json; charset=utf-8',
			success: function(response){
				location.reload();
            },
            error: function(xhr, textStatus, errorThrown) {
				console.log(xhr.statusText);
			}
		});
	})
	$('.ResetBtn').click(function(){
		location.reload();
	})
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
		<div class="Title"">자제 출고 헤더</div>
		<div class="InfoInput">
			<label>Company Code : </label>
			<input type="text" class="ComCode KeyInfo Header" name="ComCode" onclick="InfoSearch('ComSearch')" value="<%=userComCode %>" readonly>
			<input type="text" class="Com_Name" name="Com_Name" hidden> 
		</div>
		<div class="InfoInput">
			<label>Plant : </label>
			<input type="text" class="PlantCode KeyInfo Header" name="PlantCode" onclick="InfoSearch('PlantSearch')" readonly>
			<input type="text" class="PlantDes" name="PlantDes" readonly>
		</div>
		<div class="InfoInput">
			<label>출고창고 : </label>
			<input type="text" class="StorageCode Abled KeyInfo Header" name="StorageCode" onclick="InfoSearch('StorageSearch')" placeholder="SELECT" readonly>
			<input type="text" class="StorageDes" name="StorageDes" readonly>
		</div>
		<div class="InfoInput">
			<label>Movement Type : </label>
			<input type="text" class="movCode Abled KeyInfo Header" name="movCode" onclick="InfoSearch('MovSearch')" placeholder="SELECT" readonly>
			<input type="text" class="movDes" name="movDes" readonly>
			<input type="text" class="PlusMinus KeyInfo" name="PlusMinus" hidden>
		</div>
		<div class="InfoInput">
			<label>Mat. 출고 문서번호 : </label>
			<input type="text" class="Doc_Num KeyInfo Header" name="Doc_Num" readonly>
		</div>
		<div class="InfoInput">
			<label>출고일자 : </label>
			<input type="text" class="Out_date KeyInfo Header" name="Out_date" readonly>
		</div>
		<div class="InfoInput">
			<label>출고 담당자 사번 : </label>
			<input type="text" class="UserID KeyInfo Header" name="UserID" readonly value="<%=UserIdNumber%>">
		</div>
		
		<div class="BtnArea">
			<button>Create</button>
		</div>	
	</div>	
	<div class="MatOutPut-Body">
		<div class="Title">자체 출고 입력</div>
		<div class="Mat-Area">
			<div class="InfoInput">
				<label>GI Item No : </label>
				<input type="text" class="GINo KeyInfo" name="GINo" readonly> 
			</div>
			
			<div class="InfoInput">
				<label>Material : </label>
				<input type="text" class="MatCode KeyInfo" name="MatCode" onclick="InfoSearch('MatSearch')" placeholder="SELECT" readonly>
				<input type="text" class="MatDes KeyInfo" name="MatDes" readonly>
			</div>
			
			<div class="InfoInput">
				<label>자재 Lot 번호 : </label>
				<input type="text" class="MatLotNo KeyInfo" onclick="InfoSearch('LotSearch')" placeholder="SELECT" name="MatLotNo" readonly>
				
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
				<input type="text" class="UseDepart KeyInfo" name="UseDepart" onclick="InfoSearch('DepartSearch')" placeholder="SELECT" readonly>
				<button class="DepartReset">Clear</button>
				
				<label>부서명 : </label>
				<input type="text" class="DepartName" name="DepartName" readonly>
				
				<label>입고 창고  : </label>
				<input type="text" class="InputStorage KeyInfo" name="InputStorage" onclick="InfoSearch('InputSearch')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>생산 Lot번호 : </label>
				<input type="text" class="LotNumber KeyInfo" name="LotNumber">
				<button class="LotReset">Clear</button>
			</div>	
		</div>
		
		<div class="BtnArea">
			<button class="InsertBtn">Insert</button>
			<button class="SaveBtn">Save</button>
			<button class="ResetBtn">Reset</button>
		</div>
				
		<div class=Info-Area>
			<div class="Title">자제 출고 상태</div>
			<table class="InfoTable">
				<thead class="InfoTable_Header">
					<th>항번</th><th>삭제</th><th>문서번호</th><th>품목번호</th><th>자재</th><th>자재 설명</th><th>출고 구분</th><th>수량</th>
					<th>단위</th><th>사용 부서</th><th>생산 Lot 번호</th><th>출고 일자</th><th>자재 Lot 번호</th><th>출고 창고</th><th>공장(Plant)</th><th>입고 창고</th>
				</thead>
				<tbody class="InfoTable_Body">
				</tbody>
			</table>
		</div>	
	</div>
</div>
</body>
</html>
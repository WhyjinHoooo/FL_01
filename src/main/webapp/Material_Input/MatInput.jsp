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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
function InfoSearch(field){
	var popupWidth = 500;
    var popupHeight = 600;
    
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
    
    var ComCode = $('.ComCode').val();
    var VenCode = $('.VendorCode').val();
    
    switch(field){
    case "ComSearch":
    	window.open("${contextPath}/Information/CompanySerach.jsp", "PopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "PlantSearch":
    	window.open("${contextPath}/Information/PlantSerach.jsp?ComCode=" + ComCode, "PopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "VendorSearch":
    	window.open("${contextPath}/Material_Input/PopUp/FindVendor.jsp?ComCode=" + ComCode, "PopUp03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "MoveTypeSearch":
    	popupWidth = 900;
    	popupHeight = 600;
    	window.open("${contextPath}/Material_Input/PopUp/MoveTypeSerach.jsp", "PopUp04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    
    }
}
$(document).ready(function(){
	function InitialTable(){
		var UserId = $('.UserID').val();
		$('.OrderBody').empty();
		$('.InfoBody').empty();
		for (let i = 0; i < 20; i++) {
	        const row = $('<tr></tr>');
	        for (let j = 0; j < 17; j++) {
	            row.append('<td></td>');
	        }
	        $('.OrderBody').append(row);
	    }
		for (let i = 0; i < 20; i++) {
	        const row = $('<tr></tr>');
	        for (let j = 0; j < 18; j++) {
	            row.append('<td></td>');
	        }
	        $('.InfoBody').append(row);
	    }
		$.ajax({
			url:'${contextPath}/Material_Input/AjaxSet/ForPlant.jsp',
			type:'POST',
			data:{id : UserId},
			dataType: 'text',
			success: function(data){
				var dataList = data.trim().split('-');
				$('.PlantCode').val(dataList[0]);
				$('.PlantDes').val(dataList[1]);
			}
		})
	}
	function DateSetting(){
		var CurrentDate = new Date();
		var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-' + ('0' + CurrentDate.getDate()).slice(-2);
		$('.date').val(today);
		
	}
	function BodyDisabled(){
		$('.Mat-Area').find('input').prop('disabled', true);
	}
	function BodyAbled(){
		$('.Mat-Area').find('input').prop('disabled', false);
	}
	function MoveCode(){
		var Movement_Code = $('.MovType').val();
		$.ajax({
			type : "POST",
			url : "${contextPath}/Material_Input/AjaxSet/CheckMat.jsp",
			data : {movcode : Movement_Code},
			dataType : "json",
			success: function(response){
				if(response.result === "fail") {
					$('input.MovType').attr('placeholder','SELECT');
					$('input.MovType_Des').val('');
					$('input.PlusMinus').val('');
				}
			}
		})
	}
	function UpdateTable(){
		var VCode = $('.VendorCode').val();
		var PCode = $('.PlantCode').val();
		$.ajax({
			url : '${contextPath}/Material_Input/AjaxSet/FindInfo.jsp',
			type : 'POST',
			data : {vendor : VCode, plant : PCode},
			dataType: 'json',
			success: function(data){
				$('.OrderBody').empty();
				console.log(data);
				for(var i = 0 ; i < data.length ; i++){
					var row = '<tr>' +
					'<td>' + (i + 1).toString().padStart(2,'0') + '</td>' + 
					'<td><button class="AddBtn">추가</button></td>' +
					'<td>' + data[i].Vendor + '</td>' + 
					'<td>' + data[i].VenderDesc + '</td>' + 
					'<td>' + data[i].ActNumPO + '</td>' + 
					'<td>' + data[i].ItemNo.toString().padStart(4,'0') + '</td>' + 
					'<td>' + data[i].MatCode + '</td>' + 
					'<td>' + data[i].MatDesc + '</td>' + 
					'<td>' + data[i].MatType + '</td>' + 
					'<td>' + data[i].QtyPO + '</td>' + 
					'<td>' + data[i].Unit + '</td>' + 
					'<td>' + data[i].RecSumQty + '</td>' + 
					'<td>' + data[i].RegidQty + '</td>' + 
					'<td>' + data[i].TCur + '</td>' +
					'<td>' + data[i].RequestDate + '</td>' +
					'<td>' + data[i].StorLoca + '</td>' +
					'<td>' + data[i].Plant + '</td>' +
					'<td hidden>' + data[i].ActNumPO  + '</td>' +
					'</tr>';
            		$('.OrderBody').append(row);
				}
			}
		});
	}
	InitialTable();
	DateSetting();
	BodyDisabled();
	var ChkList = {};
	$('.BtnArea > button').click(function(){
		$('.HeadInfo').each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            ChkList[name] = value;
        });
		console.log(ChkList);
    	var pass = true;
    	$.each(ChkList,function(key, value){
    		if(key === 'VendorCode'){
    			pass = true;
    		}else if(value == null || value === ''){
    			pass = false;
    			return false;
    		}
    	})
    	if(!pass){
    		alert('모든 항목을 입력해주세요.');
    	}else{
    		BodyAbled();
    		UpdateTable();
    		$('.MovType').val('GR101');
    		$('.MovType_Des').val('구매발주 Material 입고');
    		MoveCode();
    	}
	})
	var Plus = 0;
	var PoinfoLst = [];
	var DataList = [];
	$('.OrderBody').on('click','.AddBtn', function(e){
		e.preventDefault();
		var todayDate = $('.date').val();
		var MoveType = $('.MovType').val();
		$.ajax({
			type: 'POST',
			url: '${contextPath}/Material_Input/AjaxSet/FindMatNum.jsp',
			data:{DateVal : todayDate, MoveTypeVal : MoveType},
			dataType: 'text',
			success: function(data){
				$('.MatNum').val(data.trim());
				if(Plus === 0){
					$('.ItemNum').val('0001');
				}
			}
		})
		var row = $(this).closest('tr');
		var DataList = [
			row.find('td:eq(4)').text(),
		    row.find('td:eq(5)').text(),
		    row.find('td:eq(6)').text(),
		    row.find('td:eq(7)').text(),
		    row.find('td:eq(8)').text(),
		    row.find('td:eq(16)').text(),
		    row.find('td:eq(15)').text(),
		    row.find('td:eq(9)').text(),
		    row.find('td:eq(10)').text(),
		    row.find('td:eq(12)').text(),
		    row.find('td:eq(13)').text(),
		    row.find('td:eq(2)').text(),
		]
		console.log(DataList);
		$('.PoInfo').each(function(){
			var Name = $(this).attr('name');
			PoinfoLst.push(Name);
		})
		for(var i = 0 ; i < PoinfoLst.length ; i++){
			if(i === 9){
				$('.' + PoinfoLst[i] + '').val(DataList[i-1]);
			}else if(i === 10){
				$('.' + PoinfoLst[i] + '').val(DataList[i-1]);
			}else if(i === 11 || i === 12){
				$('.' + PoinfoLst[i] + '').val(DataList[i-1]);
			}else{
				$('.' + PoinfoLst[i] + '').val(DataList[i]);
				if(i === 6){
					$('.' + PoinfoLst[i] + '').trigger('change');
				}
			}
		}
		$('.WareRack').val('Null');
		$('.Bin').val('Null');
		PoinfoLst = [];
		DataList = [];
	})
	$('.SLocCode').change(function(){
		var Value = $(this).val();
		$(this).val(Value.split('(')[0]);
		$('.SLocDes').val(Value.split('(')[1].replace(')',''))
		
	});
	$('.MadeDate').change(function(){
		var StartDate = new Date($(this).val());
		var EndDate = new Date(StartDate);
		EndDate.setFullYear(EndDate.getFullYear()+1);
		var DeadLine = EndDate.getFullYear() + '-' + ('0' + (EndDate.getMonth() + 1)).slice(-2) + '-' + ('0' + EndDate.getDate()).slice(-2);
		$('.Deadline').val(DeadLine);
	})
	var InputInfoList = {};
	var RowNum = 0;
	$('.InsertBtn').click(function(){
		$('.InputInfo').each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            InputInfoList[name] = value;
        });
    	var pass = true;
    	$.each(InputInfoList,function(key, value){
    		if (value == null || value === '') {
				pass = false;
				return false;
    	    }
    	})
    	if($('.NotInput').val() - InputInfoList.InputCount < 0){
    		alert('입고수량을 다시 입력해주세요.');
    		return false;
    	}
    	if(!pass){
    		alert('모든 항목을 입력해주세요.');
    		
    	}else{
    		$.ajax({
                url: '${contextPath}/Material_Input/AjaxSet/QuickSave.jsp',
                type: 'POST',
                data: JSON.stringify(InputInfoList),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                async: false,
                success: function(data){
                	if(data.status === 'Success'){
                		var QuickSavedData = data.DataList;
                		if(Plus === 0){
                			$('.InfoBody').empty();
                			RowNum = $('.InfoBody tr').length;
                			var row = '<tr>' +
							'<td>' + (RowNum + 1).toString().padStart(2,'0') + '</td>' + 
							'<td><button class="DeleteBtn">Delete</button></td>' +
							'<td>' + QuickSavedData.MatNum + '</td>' + 
							'<td>' + QuickSavedData.ItemNum + '</td>' + 
							'<td>' + QuickSavedData.MovType + '</td>' + 
							'<td>' + QuickSavedData.MatCode + '</td>' + 
							'<td>' + QuickSavedData.MatDes + '</td>' + 
							'<td>' + QuickSavedData.SLocCode + '</td>' + 
							'<td>' + QuickSavedData.Bin + '</td>' + 
							'<td>' + QuickSavedData.InputCount + '</td>' + 
							'<td>' + QuickSavedData.GoodUnit + '</td>' + 
							'<td>' + QuickSavedData.LotName + '</td>' + 
							'<td>' + QuickSavedData.MatPlant + '</td>' +
							'<td>' + QuickSavedData.HVendorCode + '</td>' +
							'<td>' + QuickSavedData.MadeDate + '</td>' +
							'<td>' + QuickSavedData.Deadline + '</td>' +
							'<td>' + QuickSavedData.PurOrdNo + '</td>' +
							'<td>' + QuickSavedData.ComCode + '</td>' +
							'<td hidden>' + QuickSavedData.MatNum + '-' + QuickSavedData.ItemNum + '</td>' +
							'</tr>';
	                		$('.InfoBody').append(row);
	                		RowNum++;
                		}else{
                			RowNum = $('.InfoBody tr').length;
                			var row = '<tr>' +
							'<td>' + (RowNum + 1).toString().padStart(2,'0') + '</td>' + 
							'<td><button class="DeleteBtn">Delete</button></td>' +
							'<td>' + QuickSavedData.MatNum + '</td>' + 
							'<td>' + QuickSavedData.ItemNum + '</td>' + 
							'<td>' + QuickSavedData.MovType + '</td>' + 
							'<td>' + QuickSavedData.MatCode + '</td>' + 
							'<td>' + QuickSavedData.MatDes + '</td>' + 
							'<td>' + QuickSavedData.SLocCode + '</td>' + 
							'<td>' + QuickSavedData.Bin + '</td>' + 
							'<td>' + QuickSavedData.InputCount + '</td>' + 
							'<td>' + QuickSavedData.GoodUnit + '</td>' + 
							'<td>' + QuickSavedData.LotName + '</td>' + 
							'<td>' + QuickSavedData.MatPlant + '</td>' +
							'<td>' + QuickSavedData.HVendorCode + '</td>' +
							'<td>' + QuickSavedData.MadeDate + '</td>' +
							'<td>' + QuickSavedData.Deadline + '</td>' +
							'<td>' + QuickSavedData.PurOrdNo + '</td>' +
							'<td>' + QuickSavedData.ComCode + '</td>' +
							'<td hidden>' + QuickSavedData.MatNum + '-' + QuickSavedData.ItemNum + '</td>' +
							'</tr>';
	                		$('.InfoBody').append(row);
	                		RowNum++;
                		}
                		$('.ItemNum').val((RowNum + 1).toString().padStart(4,'0'));
                    	Plus++;
                	}else{
                		alert('오류');
                	}
                	
                }
			})
    	}
    	$('.Mat-Area input').not('.MatNum, .ItemNum, .MovType, .MovType_Des, .PlusMinus').val('');
    	UpdateTable();
	})

	$(".InfoBody").on('click',".DeleteBtn", function(){
		var Row = $(this).closest('tr'); // 클릭된 번특이 속한 행 선택 
		var ElementKeyValue = Row.find('td:eq(18)').text();
		var RowLength = 0;
		 $.ajax({
			type: "POST",
			url: "${contextPath}/Material_Input/AjaxSet/DeleteMatInput.jsp",
			data: { DMatNum: ElementKeyValue},
			success: function(response) {
				if(response.trim() === 'Success'){
					Row.remove();
					RowLength = $('.InfoBody tr').length;
					$('.ItemNum').val((RowLength + 1).toString().padStart(4,'0'));
					if(RowLength === 0){
						for (let i = 0; i < 20; i++) {
					        const row = $('<tr></tr>');
					        for (let j = 0; j < 18; j++) {
					            row.append('<td></td>');
					        }
					        $('.InfoBody').append(row);
					    }
						Plus = 0;
					}else{
						$('.InfoBody tr').each(function(index, tr){
							var Element = $(this);
							ElementKeyValue = Element.find('td:eq(18)').text();
							$.ajax({
								type: "POST",
								url: "${contextPath}/Material_Input/AjaxSet/Quickmanage.jsp",
								data: { KeyValue: ElementKeyValue },
								success: function(response) {
									if(response.trim() === 'Success'){
										Element.find('td:eq(0)').text((index+1).toString().padStart(2,'0'));
										Element.find('td:eq(3)').text((index+1).toString().padStart(4,'0'));
										Element.find('td:eq(18)').text(Element.find('td:eq(2)').text() + '-' + Element.find('td:eq(3)').text());
									}
								},
								error: function(xhr, textStatus, errorThrown) {
									console.log(xhr.statusText);
								}
							});
						})
					}
				}
				UpdateTable();
			},
			error: function(xhr, textStatus, errorThrown) {
				console.log(xhr.statusText);
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
			url: '${contextPath}/Material_Input/MatInput_OK.jsp',
			type: 'POST',
			data: JSON.stringify(HeaderInfoList),
			contentType: 'application/json; charset=utf-8',
			success: function(response){
				console.log(response.trim());
				if(response.trim() === 'Success'){
					location.reload();
				} else{
					alert('등록과정 중 문제가 발생했습니다.')
				}
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
<title>자재입고</title>
</head>
<body>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<div class="Mat-Input">
		<div class="MatInput-Header">
			<div class="Title">자재 입고 헤더</div>
			<div class="InfoInput">
				<label>Company Code : </label>
				<input type="text" class="ComCode HeadInfo InputInfo Header" name="ComCode" onclick="InfoSearch('ComSearch')" value="<%=userComCode %>" readonly>
				<input type="text" class="Com_Name" name="Com_Name" hidden> 
			</div>
			<div class="InfoInput">
				<label>Plant : </label>
				<input type="text" class="PlantCode HeadInfo Header" name="PlantCode" onclick="InfoSearch('PlantSearch')" readonly>
				<input type="text" class="PlantDes" name="PlantDes" readonly> 
			</div>
			
			<div class="InfoInput">	
				<label>Vendor : </label>
				<input type="text" class="VendorCode HeadInfo Header" name="VendorCode" onclick="InfoSearch('VendorSearch')" readonly>
				<input type="text" class="VendorDes" name="VendorDes" readonly> 
			</div>
			
			<div class="InfoInput">
				<label>입고자 사번 : </label>
				<input type="text" class="UserID Header" name="UserID" value="<%=UserIdNumber %>"  readonly>
			</div>
					
			<div class="InfoInput">
				<label>입고 일자 : </label>
				<input type="text" class="date Header" name="date" readonly>	
			</div>
			
			<div class="BtnArea">
				<button>Create</button>
			</div>		
		</div>
		
		<div class="MatInput-Body">
			<div class="Order-Area">
				<div class="Title">자재 발주 상태</div>
				<table class="InfoTable">
					<thead>
						<tr>
							<th>항번</th><th>선택</th><th>공급업체</th><th>공급업체 프로필</th><th>PO번호</th><th>Item번호</th><th>자재</th><th>자재 정보</th><th>자재 유형</th>
							<th>발주수량</th><th>구매단위</th><th>입고수량</th><th>미입고수량</th><th>거래통화</th><th>입고예정일자</th><th>입고창고</th><th>Plant</th>
						</tr>
					</thead>
					<tbody class="OrderBody">
					</tbody>
				</table>
			</div>
		
			<div class="Mat-Area">
				<div class="InfoInput">
					<label>Material 입고 번호 : </label>
					<input type="text" class="MatNum InputInfo Header" name="MatNum" readonly>
					
					<label>GR Item Number :</label>
					<input type="text" class="ItemNum InputInfo" name="ItemNum" reqdonly>
					
					<label>Movement Type:</label>
					<input type="text" class="MovType InputInfo" name="MovType" onclick="InfoSearch('MoveTypeSearch')" readonly>
					<input type="text" class="MovType_Des" name="MovType_Des" readonly>
					<input type="text" class="PlusMinus InputInfo" name="PlusMinus" value="Plus" hidden>
				</div>
						
				<div class="InfoInput">
					<label>Purchase Order No : </label>
					<input type="text" class="PurOrdNo PoInfo InputInfo" name="PurOrdNo" readonly>
					<label>Order Item Number : </label>
					<input type="text" class="OIN PoInfo" name="OIN" readonly>
				</div>
					
				<div class="InfoInput">
					<label>Material : </label>
					<input type="text" class="MatCode PoInfo InputInfo" name="MatCode" readonly>
					<input type="text" class="MatDes PoInfo InputInfo" name="MatDes" readonly> 
					
					<label>Material 유형 : </label>
					<input type="text" class="MatType PoInfo InputInfo" name="MatType" readonly>
				</div>
				
				<div class="InfoInput">
					<label>Plant : </label>
					<input type="text" class="MatPlant PoInfo InputInfo" name="MatPlant" readonly>
						
					<label>납품S.Location : </label>
					<input type="text" class="SLocCode PoInfo InputInfo" name="SLocCode" readonly> 
					<input type="text" class="SLocDes" name="SLocDes" readonly>
					
					<label>창고 Rack: </label>
					<input type="text" class="WareRack" name="WareRack" readonly>
						
					<label>Bin : </label>
					<input type="text" class="Bin InputInfo" name="Bin" readonly>	
				</div>
				
				<div class="InfoInput">
					<label>발주수량 : </label>
					<input type="text" class="OrderCount PoInfo" name="OrderCount" readonly>
						
					<label>구매단위 : </label>
					<input type="text" class="BuyUnit PoInfo InputInfo" name="BuyUnit" readonly>
						
					<label>입고수량 : </label>
					<input type="text" class="InputCount InputInfo" name="InputCount">
						
					<label>재고단위 : </label>
					<input type="text" class="GoodUnit PoInfo InputInfo" name="GoodUnit" readonly>
						
					<label>미입고 수량 : </label>
					<input type="text" class="NotInput PoInfo" name="NotInput" readonly>
					
					<input type="text" class="DealCurrency PoInfo InputInfo" name="DealCurrency" hidden>
					<input type="text" class="HVendorCode PoInfo InputInfo" name="HVendorCode" hidden>
				</div>
				
				<div class="InfoInput">
					<label>자제 Lot 번호 : </label>
					<input type="text" class="LotNum InputInfo" name="LotName"> 
						
					<label>제조일자 : </label>
					<input type="date" class="MadeDate InputInfo" name="MadeDate">
						
					<label>만료일자 : </label>
					<input type="date" class="Deadline InputInfo" name="Deadline">
				</div>
			</div>
			
			<div class="BtnArea">
				<button class="InsertBtn">Insert</button>
				<button class="SaveBtn">Save</button>
				<button class="ResetBtn">Reset</button>
			</div>
			
			
			<div class=Info-Area>
				<div class="Title">자재 입고 상태</div>
				<table class="InfoTable" id="InfoTable">
					<thead>
						<tr>
							<th>항번</th><th>삭제</th><th>입고번호</th><th>Item번호</th><th>입고유형</th><th>자재</th><th>자재 정보</th>
							<th>창고</th><th>Bin</th><th>입고수량</th><th>재고단위</th><th>Lot번호</th><th>사업장<!-- Plant --></th><th>공급업체<!-- Vendor --></th><th>제조일자</th><th>만료일자</th>
							<th>PO번호</th><th>회사코드</th>
						</tr>
					</thead>
					<tbody class="InfoBody">
					</tbody>
				</table>
			</div>
			
		</div>
	</div> 	
</body>
</html>
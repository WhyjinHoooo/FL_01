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
		console.log(UserId);
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
				for(var i = 0 ; i < data.length ; i++){
					var row = '<tr>' +
					'<td>' + (i + 1).toString().padStart(2,'0') + '</td>' + 
					'<td><button class="AddBtn">추가</button></td>' +
					'<td>' + data[i].Vendor + '</td>' + 
					'<td>' + data[i].VendorDes + '</td>' + 
					'<td>' + data[i].MMPO + '</td>' + 
					'<td>' + data[i].ItemNo.toString().padStart(4,'0') + '</td>' + 
					'<td>' + data[i].MatCode + '</td>' + 
					'<td>' + data[i].MatDes + '</td>' + 
					'<td>' + data[i].MatType + '</td>' + 
					'<td>' + data[i].Quantity + '</td>' + 
					'<td>' + data[i].PoUnit + '</td>' + 
					'<td>' + data[i].Count + '</td>' + 
					'<td>' + data[i].PO_Rem + '</td>' + 
					'<td>' + data[i].Money + '</td>' +
					'<td>' + data[i].Hdate + '</td>' +
					'<td>' + data[i].Storage + '</td>' +
					'<td>' + data[i].PlantCode + '</td>' +
					'<td hidden>' + data[i].KeyValue  + '</td>' +
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
    	var pass = true;
    	$.each(ChkList,function(key, value){
    		if(value == null || value === ''){
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
				}else{
					$('.ItemNum').val(Plus.toString().padStart(4,'0'));
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
		]
		
		$('.PoInfo').each(function(){
			var Name = $(this).attr('name');
			PoinfoLst.push(Name);
		})
	console.log(PoinfoLst);
		console.log('DataList : ', DataList);
		for(var i = 0 ; i < PoinfoLst.length ; i++){
			if(i === 9){
				$('.' + PoinfoLst[i] + '').val(DataList[i-1]);
			}else if(i === 10){
				$('.' + PoinfoLst[i] + '').val(DataList[i-1]);
			}else if(i === 11){
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
	})
	$('.SLocCode').change(function(){
			var storageLoc = $(this).val();
			$.ajax({
				type : "POST",
				url : "${contextPath}/Material_Input/AjaxSet/FindsLoc.jsp",
				data : {sloccode : storageLoc},
				dataType: 'text',
				success: function(data){
					$('.SLocDes').val(data.trim());
				}
			})
		});
	
	var InputInfoList = {};
	$('.InsertBtn').click(function(){
		$('.InputInfo').each(function(){
            var name = $(this).attr("name");
            var value = $(this).val();
            InputInfoList[name] = value;
        });
    	var pass = true;
    	$.each(InputInfoList,function(key, value){
    		if(value == null || value === ''){
    			pass = false;
    			return false;
    		}
    	})
    	if($('.NotInput').val() - InputInfoList.InputCount < 0){
    		alert('입고수량을 다시 입력해주세요.');
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
                success: function(){
                	
                }
			})
    	}
    	
	})
	var RowNum = 1;
	var itemNum = 0; // Item 번호를 위한 변수 
	
	var deletedItems = []; // 삭제됭 항번의 Number
	var MaxRowNum = 0; 
	var DelItemNum = null;
	
	var Add = 0;
	var Minus = 0;
	$(".TemTable").on('click',"input[name='DeleteBtn']", function(){
		console.log(RowNum);
		Minus++;
		console.log("삭제한 횟수 : " + Minus);
		var Row = $(this).closest('tr'); // 클릭된 번특이 속한 행 선택 
		var DelMatNum = Row.find('td:eq(2)').text(); // MGR20240409S00001
		DelItemNum = Row.find('td:eq(3)').text(); // 0001
		var DelLotNum = Row.find('td:eq(11)').text(); // 1(Lot번호)
		
		var DelMatCode = Row.find('td:eq(5)').text(); // 010201-00003
		var DelPoCode = Row.find('td:eq(16)').text(); // PURO20240404S00001
		var DelCount = Row.find('td:eq(9)').text();// 1(입고수량)
		var KeyValue = Row.find('td:eq(18)').text();// 1(입고수량)
		deletedItems.push({MatNum: DelMatNum, ItemNum: DelItemNum, LotName: DelLotNum, MatCode: DelMatCode, PoNum: DelPoCode, Count: DelCount, KeyValue : KeyValue});
		console.log(deletedItems);
		Row.remove();
		RowNum--;
		
		$.ajax({
			url: 'DeleteMatInput.jsp',
			type: 'POST',
			data: {'List': JSON.stringify(deletedItems)},
			contentType: 'application/x-www-form-urlencoded; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(List){
                // 서버에서 응답이 온 후의 처리
                if (List.result) {
                    console.log('삭제 성공');
                } else {
                    console.log('삭제 실패: ' + List.message);
                }
                UpdateTable();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log("AJAX error: " + textStatus + ' : ' + errorThrown);
            }
		});
		
		// 항번 다시 정렬
        $(".TemTable tr").each(function(index){
            if(index != 0) { // 테이블 헤더를 제외하고 순번을 부여
                $(this).find('td:eq(0)').text(index);
                $(this).find('td:eq(3)').text(("0000" + index).slice(-4));
            }
        });
		
		var CancelValue = parseInt(DelCount);
		var PastValue = parseInt($('.NotInput').val());
		var NowValue = CancelValue + PastValue;
		console.log("NowValue : " + NowValue);
        $('.NotInput').val(NowValue);
        
		var EditItemNum = ("0000" + (Add - Minus + 1)).slice(-4);
		console.log("수정한 ItemNumber : " + EditItemNum);
		$(".ItemNum").val(EditItemNum);
	});
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
	<!-- <form name="MatInputRegistForm" id="MatInputRegistForm" action="MatInput_OK.jsp" method="POST" onSubmit="return checkCount()" enctype="UTF-8"> -->
	<div class="Mat-Input">
		<div class="MatInput-Header">
			<div class="Title">타이틀</div>
			<div class="InfoInput">
				<label>Company Code : </label>
				<input type="text" class="ComCode HeadInfo InputInfo" name="ComCode" onclick="InfoSearch('ComSearch')" value="<%=userComCode %>" readonly>
				<input type="text" class="Com_Name" name="Com_Name" hidden> 
			</div>
			<div class="InfoInput">
				<label>Plant : </label>
				<input type="text" class="PlantCode HeadInfo" name="PlantCode" onclick="InfoSearch('PlantSearch')" readonly>
				<input type="text" class="PlantDes" name="PlantDes" readonly> 
			</div>
			
			<div class="InfoInput">	
				<label>Vendor : </label>
				<input type="text" class="VendorCode HeadInfo InputInfo" name="VendorCode" onclick="InfoSearch('VendorSearch')" readonly>
				<input type="text" class="VendorDes" name="VendorDes" readonly> 
			</div>
			
			<div class="InfoInput">
				<label>입고자 사번 : </label>
				<input type="text" class="UserID" name="UserID" value="<%=UserIdNumber %>"  readonly>
			</div>
					
			<div class="InfoInput">
				<label>입고 일자 : </label>
				<input type="text" class="date" name="date" readonly>	
			</div>
			
			<div class="BtnArea">
				<button>Create</button>
			</div>		
		</div>
		
		<div class="MatInput-Body">
			<div class="Order-Area">
				<div class="Title">타이틀</div>
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
					<input type="text" class="MatNum InputInfo" name="MatNum" readonly>
					
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
				<div class="Title">타이틀</div>
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
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
					alert(response.message);
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
				console.log(data[0].Vendor);
				console.log(data.length);
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
	
$(document).on('click', '.sendBtn', function() {
		
		var row = $(this).closest('tr');
		var Key = row.find('.key').text();
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
		var KeyValue = row.find('.key').text();
		
		const TableName = document.getElementById('TemTable');
		const RowCount = TableName.rows.length - 1;
		
		$('.MatKeyData').val(Key);
		if(RowCount == 0){
			$('.ItemNum').val('0001'); // GR Item Number
			console.log("임시저장된 데이터 없는 경우");
		} else {
			$('.ItemNum').val(("0000" + (RowCount + 1)).slice(-4));
			console.log("임시저장된 데이터 있는 경우");
		}
		
		//$('.ItemNum').val('0001'); // GR Item Number
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
		$('.KeyValue').val(KeyValue);
	
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
	
	var RowNum = 1;
	var itemNum = 0; // Item 번호를 위한 변수 
	
	var deletedItems = []; // 삭제됭 항번의 Number
	var MaxRowNum = 0; 
	var DelItemNum = null;
	
	var Add = 0;
	var Minus = 0;
	
	$(".container").on('click', "img[name=Down]",function(){
		
		var EnterCount = $('.InputCount').val();
		var YetCount = $('.NotInput').val();
		var CMovType = $('.MovType').val();
		var CLotNum = $('.LotNum').val();
		var CMadeDate = $('.MadeDate').val();
		var CDeadline = $('.Deadline').val();
		
		
		if(!EnterCount || !CMovType || !CLotNum || !CMadeDate || !CDeadline){
			alert('항목을 모두 입력해주세요.');
			return false;
		} else if(YetCount - EnterCount < 0){
			alert('입고 수량을 수정해주세요.');
			return false;
		}
		
		
		if(Minus > 0){
			var editNum = Add - Minus + 1;
			console.log("수정된 번호 : " + editNum);
		}
		Add++;
		console.log("이미지 클릭 횟수 : " + Add);
		console.log(itemNum);
		itemNum++;
		var CurOIN = parseInt($('.ItemNum').val(), 10);
		console.log(CurOIN);
		
		console.log("itemNum : " + itemNum + ", CurOIN : " + CurOIN);
		if(itemNum !== CurOIN){
			itemNum = editNum;
			CurOIN = editNum;
			console.log("변경된 itemNum : " + itemNum + ", 변경된 CurOIN : " + CurOIN);
		};
		
		var DataList = {};
		$('.Dinfo').each(function(){
			var name = $(this).attr("name");
			var value = $(this).val();
			DataList[name] = value;
		});
		console.log("DataList : ", DataList);
		
		var CountList = {};
		$('.Pinfo').each(function(){
			var name = $(this).attr("name");
			var value = $(this).val();
			CountList[name] = value;	
		});
		console.log("CountList : ", CountList);
		
		var CombineList = {
			dList : DataList,
			CList : CountList
		};
		
		const reset = [/*  $('.MovType_Des'), $('.MovType'), */ $('.InputCount'), $('.MadeDate'), $('.Deadline'), $('.LotNum')];
		reset.forEach(input => input.val(''));
		
		$.ajax({
			url: 'SaveDraft.jsp',
			type: 'POST',
			data: JSON.stringify(CombineList),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(data){
				var DelBtn = "삭제";
				var NewRow = "<tr class='dTitle'>";
				var A_RowNum = $('.TemTable tr').length;
				console.log('잉잉잉잉 : ' + A_RowNum);
				
				NewRow += "<td>" + A_RowNum + "</td>";
				NewRow += "<td><input type='Button' name='DeleteBtn' value='" + DelBtn + "'></td>";
				
				var List = ["MatNum", "ItemNum", "MovType", "MatCode", "MatDes", "SLocCode",   
					 "Bin", "InputCount", "GoodUnit","LotName","PlantCode", "VendorCode", "MadeDate", "Deadline", "PurOrdNo","plantComCode", "KeyValue"];
				
				var InputCountValue = data["InputCount"];
				$('.NotInput').val($('.NotInput').val() - InputCountValue); /* <?> */
				
				$.each(List, function(index, key){
					if(key === "ItemNum"){
						NewRow += "<td>" + ("0000" + itemNum).slice(-4) + "</td>";
					} else if(key === "Bin"){
						data[key] = "NULL";
				        NewRow += "<td class='datasize'>" + data[key] + "</td>"; 
					}else if(key === "KeyValue"){
						NewRow += "<td class='datasize' hidden>" + data[key] + "</td>";
					}else{
						NewRow += "<td class='datasize'>" + data[key] + "</td>";
					}
				});
				NewRow += "</tr>";
				$(".TemTable").append(NewRow);
				console.log("입력한 ItemNumber : " + $('.ItemNum').val());
				$('.ItemNum').val(("0000" + (CurOIN + 1)).slice(-4));
				console.log("다음 ItemNumber : " + ("0000" + (CurOIN + 1)).slice(-4));
				$('.NotInput').val();
				MaxRowNum = A_RowNum;
				
				UpdateTable();
			}
			
		});
		
	}); // 화살표이미지 끝
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
				<input type="text" class="ComCode HeadInfo" name="ComCode" onclick="InfoSearch('ComSearch')" value="<%=userComCode %>" readonly>
				<input type="text" class="Com_Name" name="Com_Name" hidden> 
			</div>
			<div class="InfoInput">
				<label>Plant : </label>
				<input type="text" class="PlantCode HeadInfo" name="PlantCode" onclick="InfoSearch('PlantSearch')" readonly>
				<input type="text" class="PlantDes" name="PlantDes" readonly> 
			</div>
			
			<div class="InfoInput">	
				<label>Vendor : </label>
				<input type="text" class="VendorCode HeadInfo" name="VendorCode" onclick="InfoSearch('VendorSearch')" readonly>
				<input type="text" class="VendorDes" name="VendorDes" readonly> 
			</div>
			
			<div class="InfoInput">
				<label>입고자 사번 : </label>
				<input type="text" class="UserID Dinfo" name="UserID" value="<%=UserIdNumber %>"  readonly>
			</div>
					
			<div class="InfoInput">
				<label>입고 일자 : </label>
				<input type="text" class="date Dinfo" name="date" readonly>	
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
					<input type="text" class="MatNum Dinfo" name="MatNum" readonly>
					
					<label>GR Item Number :</label>
					<input type="text" class="ItemNum Dinfo" name="ItemNum" reqdonly>
					
					<label>Movement Type:</label>
					<input type="text" class="MovType Dinfo" name="MovType" onclick="InfoSearch('MoveTypeSearch')" readonly>
					<input type="text" class="MovType_Des" name="MovType_Des" readonly>
					<input type="text" class="PlusMinus" hidden>
				</div>
						
				<div class="InfoInput">
					<label>Purchase Order No : </label>
					<input type="text" class="PurOrdNo Dinfo" name="PurOrdNo" readonly>
					<label>Order Item Number : </label>
					<input type="text" class="OIN" name="OIN" readonly>
				</div>
					
				<div class="InfoInput">
					<label>Material : </label>
					<input type="text" class="MatCode Dinfo" name="MatCode" readonly>
					<input type="text" class="MatDes Dinfo" name="MatDes" readonly> 
					
					<label>Material 유형 : </label>
					<input type="text" class="MatType Dinfo" name="MatType" readonly>
				</div>
				
				<div class="InfoInput">
					<label>Plant : </label>
					<input type="text" class="PlantCode Dinfo" name="PlantCode" readonly>
						
					<label>납품S.Location : </label>
					<input type="text" class="SLocCode Dinfo" name="SLocCode" readonly> 
					<input type="text" class="SLocDes" name="SLocDes" readonly>
					
					<label>창고 Rack: </label>
					<input type="text" class="WareRack" name="WareRack" readonly>
						
					<label>Bin : </label>
					<input type="text" class="Bin Dinfo" name="Bin" readonly>	
				</div>
				
				<div class="InfoInput">
					<label>발주수량 : </label>
					<input type="text" class="OrderCount" name="OrderCount" readonly>
						
					<label>구매단위 : </label>
					<input type="text" class="BuyUnit" name="BuyUnit" readonly>
						
					<label>입고수량 : </label>
					<input type="text" class="InputCount Dinfo Pinfo" name="InputCount">
						
					<label>재고단위 : </label>
					<input type="text" class="GoodUnit Dinfo" name="GoodUnit" readonly>
						
					<label>미입고 수량 : </label>
					<input type="text" class="NotInput" name="NotInput" readonly>
				</div>
				
				<div class="InfoInput">
					<label>자제 Lot 번호 : </label>
					<input type="text" class="LotNum Dinfo" name="LotName"> 
						
					<label>제조일자 : </label>
					<input type="date" class="MadeDate Dinfo" name="MadeDate">
						
					<label>유효기간 만료일자 : </label>
					<input type="date" class="Deadline Dinfo" name="Deadline">
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
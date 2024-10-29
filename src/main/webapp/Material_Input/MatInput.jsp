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
	var path = window.location.pathname;
	var Address = path.split("/").pop();
	window.addEventListener('unload', (event) => {
		
		var data = {
			action : 'deleteOrderData',
			page : Address
				
		}
	    navigator.sendBeacon('../DeleteOrder', JSON.stringify(data));
	});

	function PlantSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
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
	function totalMatSearch(){
		var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var ComCode = document.querySelector('.plantComCode').value;
	    
	    window.open("FindVendor.jsp?ComCode=" + ComCode, "테스트", "width=500,height=500, left=500 ,top=" + yPos);
	}
	
	window.addEventListener('DOMContentLoaded',(event) => {
		const PlantCode = document.querySelector(".plantCode");
		const VenCode = document.querySelector(".VendorCode");
		const VenDes = document.querySelector(".VendorDes");
		
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
		var vendorname = $('.VendorDes').val();
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
						'<td class="datasize">' + vendorcode + '</td>' + //벤더 코드
						'<td class="datasize">' + vendorname + '</td>' + // 벤더 설명
						'<td class="key datasize" hidden>' + data[i].Key + '</td>' + // 데이터의 key값
						'<td class="MMPO datasize">' + data[i].MMPO + '</td>' + // PO번호
						'<td class="ItemNo datasize">' + String(data[i].ItemNo).padStart(4, '0') + '</td>' + // Item번호
						'<td class="MatCode datasize">' + data[i].MatCode + '</td>' + // 재료 코드
						'<td class="MatDes datasize">' + data[i].MatDes + '</td>' + // 재료에 대한 설명
						'<td class="MatType datasize">' + data[i].MatType + '</td>' + // 재료의 타입
						'<td class="Quantity datasize">' + data[i].Quantity + '</td>' + // 발주 수량
						'<td class="PoUnit datasize">' + data[i].PoUnit + '</td>' + // 구매 단위
						'<td class="StoredInput datasize">' + data[i].Count + '</td>' + // 입고 수량
						'<td class="NotStored datasize">' + data[i].PO_Rem + '</td>' + // 미입고수량
						'<td class="TraCurr datasize">' + data[i].Money + '</td>' + //거래 통화
						'<td>' + data[i].Hdate + '</td>' + // 입고예정일자
						'<td class="Storage datasize">' + data[i].Storage + '</td>' + // 입고창고 코드
						'<td class="PlantCode datasize">' + data[i].PlantCode + '</td>' + // 플랜트 코드
						'</tr>';
						table.append(row);
					};
				}
			},
			error: function() {
		          alert("에러 발생");
		    }
		}); // ajax의 끝
	});
	
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
		/* var StoreCount = row.find('.StoredInput').text(); */
		
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

<script type="text/javascript">
$(document).ready(function(){
	function UpdateTable(){
		var vendorcode = $('.VendorCode').val();/* $(this).val(); */
		var vendorname = $('.VendorDes').val();
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
						'<td class="datasize">' + vendorcode + '</td>' + //벤더 코드
						'<td class="datasize">' + vendorname + '</td>' + // 벤더 설명
						'<td class="key datasize" hidden>' + data[i].Key + '</td>' + // 데이터의 key값
						'<td class="MMPO datasize">' + data[i].MMPO + '</td>' + // PO번호
						'<td class="ItemNo datasize">' + String(data[i].ItemNo).padStart(4, '0') + '</td>' + // Item번호
						'<td class="MatCode datasize">' + data[i].MatCode + '</td>' + // 재료 코드
						'<td class="MatDes datasize">' + data[i].MatDes + '</td>' + // 재료에 대한 설명
						'<td class="MatType datasize">' + data[i].MatType + '</td>' + // 재료의 타입
						'<td class="Quantity datasize">' + data[i].Quantity + '</td>' + // 발주 수량
						'<td class="PoUnit datasize">' + data[i].PoUnit + '</td>' + // 구매 단위
						'<td class="StoredInput datasize">' + data[i].Count + '</td>' + // 입고 수량
						'<td class="NotStored datasize">' + data[i].PO_Rem + '</td>' + // 미입고수량
						'<td class="TraCurr datasize">' + data[i].Money + '</td>' + //거래 통화
						'<td>' + data[i].Hdate + '</td>' + // 입고예정일자
						'<td class="Storage datasize">' + data[i].Storage + '</td>' + // 입고창고 코드
						'<td class="PlantCode datasize">' + data[i].PlantCode + '</td>' + // 플랜트 코드
						'</tr>';
						table.append(row);
					};
				}
			},
			error: function() {
		          alert("에러 발생");
		    }
		});
	}
	
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
				var RowNum = $('.TemTable tr').length;
				
				NewRow += "<td>" + RowNum + "</td>";
				NewRow += "<td><input type='Button' name='DeleteBtn' value='" + DelBtn + "'></td>";
				
				var List = ["MatNum", "ItemNum", "MovType", "MatCode", "MatDes", "SLocCode",   
					 "Bin", "InputCount", "GoodUnit","LotName","PlantCode", "VendorCode", "MadeDate", "Deadline", "PurOrdNo","plantComCode"];
				
				var InputCountValue = data["InputCount"];
				$('.NotInput').val($('.NotInput').val() - InputCountValue); /* <?> */
				
				$.each(List, function(index, key){
					if(key === "ItemNum"){
						NewRow += "<td>" + ("0000" + itemNum).slice(-4) + "</td>";
					} else if(key === "Bin"){
						data[key] = "NULL";
				        NewRow += "<td class='datasize'>" + data[key] + "</td>"; 
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
				MaxRowNum = RowNum;
				
				UpdateTable();
			}
			
		});
		
	}); // 화살표이미지 끝
	$(".TemTable").on('click',"input[name='DeleteBtn']", function(){
		Minus++;
		console.log("삭제한 횟수 : " + Minus);
		var Row = $(this).closest('tr'); // 클릭된 번특이 속한 행 선택 
		var DelMatNum = Row.find('td:eq(2)').text(); // MGR20240409S00001
		DelItemNum = Row.find('td:eq(3)').text(); // 0001
		var DelLotNum = Row.find('td:eq(11)').text(); // 1(Lot번호)
		
		var DelMatCode = Row.find('td:eq(5)').text(); // 010201-00003
		var DelPoCode = Row.find('td:eq(16)').text(); // PURO20240404S00001
		var DelCount = Row.find('td:eq(9)').text();// 1(입고수량)
		deletedItems.push({MatNum: DelMatNum, ItemNum: DelItemNum, LotName: DelLotNum, MatCode: DelMatCode, PoNum: DelPoCode, Count: DelCount});
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
	}); // 삭제버튼이 클릭된 경우 기능 끝
	/* 	var TestNum = 0; 
	$(".WrittenForm").on('click',".sendBtn", function(){
		console.log("잠시 확인용 : " + Add);
		if(Add == 0){
			$('.ItemNum').val("0001");
		} else {
			TestNum = ("0000" + (Add + 1)).slice(-4);
		}
		console.log("잠시 확인용 2 : " + TestNum);
		$('.ItemNum').val(TestNum);
	}); */
});
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
	
	String User_Id = /* (String) session.getAttribute("id") */"17011381";
%>
<title>자재입고</title>
</head>
<body>
	<h1>자재입고</h1>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
		<form name="MatInputRegistForm" id="MatInputRegistForm" action="MatInput_OK.jsp" method="POST" onSubmit="return checkCount()" enctype="UTF-8">
		<div class="content-wrapper">
			<asdie class="side-menu-container" id="In_SideMenu">
				<li>Plant</li>
					<td class="input-info">
					<%
						if(pCode == null){
					%>
						<a href="javascript:PlantSearch()"><input type="text" class="plantCode" name="plantCode" readonly></a> <!-- 전송 -->
						<input type="text" class="plantDes" name="plantDes" readonly> 
						<input type="text" name="plantComCode" class="plantComCode Dinfo" size="5" hidden><!-- hidden -->
					</td>
					<%
						}else{
					%>
					<a href="javascript:PlantSearch()"><input type="text" class="plantCode" name="plantCode" readonly value="<%=pCode%>"></a> <!-- 전송 -->
						<input type="text" class="plantDes" name="plantDes" readonly value="<%=pDes%>"> 
						<input type="text" name="plantComCode" class="plantComCode Dinfo" size="5" value="<%=pComCode%>" hidden><!-- hidden -->
					</td>
					<%
						}
					%>
				<br><br>
					
				<li>Vendor</li>
					<%
						if(vCode == null){
					%>
					<td class="input-info">
						<a href="javascript:VendorSearch()"><input type="text" class="VendorCode Dinfo" name="VendorCode" readonly></a> <!-- 전송 -->
						<input type="text" class="VendorDes" name="VendorDes" readonly> 
					</td>
					<%
						}else{
					%>
					<td class="input-info">
						<a href="javascript:VendorSearch()"><input type="text" class="VendorCode Dinfo" name="VendorCode" readonly  value="<%=vCode%>"></a> <!-- 전송 -->
						<input type="text" class="VendorDes" name="VendorDes" readonly  value="<%=vDes%>"> 
					</td>
					<script type="text/javascript">
						$(document).ready(function(){
						    var vCode = "<%=vCode%>"; // 세션에서 값을 가져옵니다.
						    var vDes = "<%=vDes%>"; // 세션에서 값을 가져옵니다.
								    // 입력 필드의 값을 설정합니다.
						    $('.VendorCode').val(vCode);
						    $('.VendorDes').val(vDes);
								    // input 이벤트를 발생시킵니다.
						    $('.VendorCode').trigger('input');
						});
					</script>
					<%
						}
					%>	
				<br><br>
				<li>입고자 사번</li>
					<td class="input-info">
						<% 
						if(User_Id != null){
						%>
						<input type="text" class="UserID Dinfo" name="UserID" value="<%=User_Id%>" readonly>
						<%
						} else{
						%>
						<input type="text" class="UserID Dinfo" name="UserID"  readonly>
						<%
						}
						%>						
					</td>
					
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
				<br><br>				
				<li>입고 일자</li>
					<td class="input-info">
						<input type="text" class="date Dinfo" name="date" value="<%=Today%>" readonly>								
					</td>	
			</asdie>
			
			<div class="content-wrapper1">
				<section class="sub-content-container">
					<div class="orderedDate">
						<div class="table-container">
							<table class="WrittenForm" id="WrittenForm">
								<tr>
									<th>항번</th><th>선택</th><th>Vendor</th><th>Vendor명</th><th>PO번호</th><th>Item번호</th><th>Material</th><th>Material Description</th><th>Material 유형</th><br>
									<th>발주수량</th><th>구매단위</th><th>입고수량</th><th>미입고수량</th><th>거래통화</th><th>입고예정일자</th><th>입고창고</th><th>Plant</th>
								</tr>
							</table>
						</div>
					</div>
				</section>
			
				<section class="main-content-container">
					<div class="input-sub-info">
						<div class="table-container">
							<table class="table_1">
								<tr>
									<th class="info">Material 입고 번호 : </th>
										<td class="input-info">
											<input type="text" class="MatNum Dinfo" name="MatNum" readonly><!-- 中 -->
										</td>
										<td>
											<input type="text" class="MatKeyData Pinfo" name="MatKeyData" hidden><!-- hidden -->
										</td>
									
									<td class="spaceCell-s"></td> <!-- 폭 150px -->
									
									<th class="info">GR Item Number : </th>
										<td class="input-info">
											<input type="text" class="ItemNum Dinfo" name="ItemNum" reqdonly><!-- 中 -->
										</td>
									
									<td class="spaceCell-b"></td> <!-- 폭 550px -->
									
									<th class="info">Movement Type: </th>
										<td class="input-info" colsapn="2">
											<a href="javascript:MoveTypeSearch()"><input type="text" class="MovType Dinfo" name="MovType" value="GR101" readonly></a>
											<input type="text" class="MovType_Des" name="MovType_Des" size="40" value="구매발주 Material 입고" readonly>
											<input type="text" class="PlusMinus Dinfo" name="PlusMinus" value="Plus" hidden><!-- hidden -->
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
											dataType : "json",
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
											<input type="text" class="PurOrdNo Dinfo" name="PurOrdNo" readonly>
										</td>
									
									<td class="spaceCell-43"></td> <!-- 폭 43px -->
									
									<th class="info">Order Item Number : </th>
										<td class="input-info">
											<input type="text" class="OIN" name="OIN" readonly>
										</td>
								</tr>
							</table>
							
							<table class="table_3">
								<tr>
									<th class="info">Material : </th>
										<td class="input-info" colspan="2">
											<input type="text" class="MatCode Dinfo" name="MatCode" readonly>
											<input type="text" class="MatDes Dinfo" name="MatDes" readonly> 
										</td>
										
									<td class="spaceCell-515"></td>
									
									<th class="info">Material 유형 : </th>
										<td class="input-info">
											<input type="text" class="MatType Dinfo" name="MatType" readonly>
										</td>
								</tr>
							</table>
							
							<table class="table_4">
								<tr>
									<th class="info">Plant : </th>
										<td class="input-info">
											<input type="text" class="PlantCode Dinfo" name="PlantCode" readonly>
										</td>
										
									<td class="spaceCell-230"></td>
									
									<th class="info">납품S.Location : </th>
										<td class="input-info" colspan="2">
											<input type="text" class="SLocCode Dinfo" name="SLocCode" readonly> <!-- ? -->
											<input type="text" class="SLocDes" name="SLocDes" readonly>
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
										
									<td class="spaceCell-243"></td>
									
									<th class="info">Bin : </th>
										<td class="input-info">
											<input type="text" class="Bin Dinfo" name="Bin" readonly>
										</td>	
								</tr>
							</table>
							
							<table class="table_5">
								<tr>
									<th class="info">발주 수량 : </th>
										<td class="input-info">
											<input type="text" class="OrderCount" name="OrderCount" readonly>
										</td>
									
										<td class="spaceCell-10"></td>
									
									<th class="info">구매단위 : </th>
										<td class="input-info" colspan="2">
											<input type="text" class="BuyUnit" name="BuyUnit" readonly>
											<input type="text" class="Money Dinfo" name="Money" hidden><!-- hidden -->
										</td>
										
									<td class="spaceCell-250"></td>
									
									<th class="info">입고 수량: </th>
										<td class="input-info">
											<input type="text" class="InputCount Dinfo Pinfo" name="InputCount">
										</td>
											
									<td class="spaceCell-250"></td>
									
									<th class="info">재고단위 : </th>
										<td class="input-info">
											<input type="text" class="GoodUnit Dinfo" name="GoodUnit" readonly>
										</td>
										
									<td class="spaceCell-300"></td>
									
									<th class="info">미입고 수량 : </th>
										<td class="input-info">
											<input type="text" class="NotInput" name="NotInput" readonly>
										</td>
												
								</tr>
							</table>
							
							<table class="table_6">
								<tr>
									<th class="info">지제 Lot 번호 : </th>
										<td class="input-info">
											<input type="text" class="LotNum Dinfo" name="LotName"> <!-- ? -->
										</td>
										
									<td class="spaceCell-250"></td>
									
									<th class="info">제조일자 : </th>
										<td class="input-info">
											<input type="date" class="MadeDate Dinfo" name="MadeDate">
										</td>
										
									<td class="spaceCell-179"></td>
									
									<th class="info">유효기간 만료일자 : </th>
										<td class="input-info">
											<input type="date" class="Deadline Dinfo" name="Deadline">
										</td>	
								</tr>
							</table>
						</div>
					</div>
				</section>
				
				<section>
					<div class="container">
						<img name="Down" src="../img/Dvector.png" alt="">
						<input class="input-btn" id="btn" type="submit" value="Insert">
					</div>
				</section>
				
				<section>
					<div class="StoreReady">
						<div class="table-container">
							<table class="TemTable" id="TemTable">
								<tr>
									<th>항번</th><th>삭제</th><th>입고번호</th><th>Item번호</th><th>입고유형</th><th>Material</th><th>Material Description</th><br>
									<th>창고</th><th>Bin</th><th>입고수량</th><th>재고단위</th><th>Lot번호</th><th>Plant</th><th>Vendor</th><th>제조일자</th><th>만료일자</th><br>
									<th>PO번호</th><th>회사코드</th>
								</tr>
							</table>
						</div>
					</div>
					
				</section>
			</div>
		</div> 	
		</form>
</body>
</html>
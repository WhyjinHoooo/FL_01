<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<meta charset="UTF-8">
<title>자재발주</title>
<script>
function InfoSearch(field){
	event.preventDefault();
	var MatCode = $('.Entry_MatCode').val();
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
    
    switch(field){
    case "Plant":
    	window.open("${contextPath}/Purchasing/PopUp/FindPlant.jsp", "POPUP01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    break;
    case "Material":
    	popupWidth = 1000;
        popupHeight = 600;
    	window.open("${contextPath}/Purchasing/PopUp/FindMat.jsp?Category=Search", "POPUP02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    break;
    case "Vendor":
    	window.open("${contextPath}/Purchasing/PopUp/FindVendor.jsp", "POPUP08", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;
    case "Company":
    	window.open("${contextPath}/Purchasing/PopUp/FindCom.jsp", "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "EntryClient":
    	window.open("${contextPath}/Purchasing/PopUp/FindClient.jsp?Category=Entry", "POPUP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;	
    case "EntryDeli":
    	window.open("${contextPath}/Purchasing/PopUp/FindMatPlace.jsp?MatCode=" + MatCode, "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;
    case "EntrySLocation":
    	window.open("${contextPath}/Purchasing/PopUp/FindSLoc.jsp", "POPUP07", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
	}
}
function checkOnlyOne(element) {
    const checkboxes = $('.UnitSum');
    checkboxes.each(function () {
        this.checked = false;
    });
    element.checked = true;
}

$(document).ready(function(){
	function EntryDisabled(){
		$('.Ord-Area').find('input').prop('disabled', true);
	}
	function EntryAbled(){
		$('.Ord-Area').find('input').not('.Entry_Reject').prop('disabled', false);
	}
	function InitialTable(UserId){
		$('.InfoTable-Body').empty();
		$('.POTable-Body').empty();
		var UserId = UserId;
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>');
            for (let j = 0; j < 13; j++) {
                row.append('<td></td>');
            }
            $('.InfoTable-Body').append(row);
        }
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>');
            for (let j = 0; j < 14; j++) {
                row.append('<td></td>');
            }
            $('.POTable-Body').append(row);
        }
		$.ajax({
			url:'${contextPath}/Purchasing/AjaxSet/Order/ForPlant.jsp',
			type:'POST',
			data:{id : UserId},
			dataType: 'text',
			success: function(data){
				console.log(data.trim());
				var dataList = data.trim().split('-');
				console.log(dataList);
				$('.PlantCode').val(dataList[0]+'('+dataList[1]+')');
			}
		})
	}
	function DateSetting(){
		var CurrentDate = new Date();
		var today = CurrentDate.getFullYear() + '-' + ('0' + (CurrentDate.getMonth() + 1)).slice(-2) + '-' + ('0' + CurrentDate.getDate()).slice(-2);
		$('.FromDate').val(today);
		
		var LastDateForm = new Date(CurrentDate.getFullYear(), CurrentDate.getMonth() + 1, 0);
		var LastDate = LastDateForm.getFullYear() + '-' + ('0' + (LastDateForm.getMonth() + 1)).slice(-2) + '-' + ('0' + LastDateForm.getDate()).slice(-2);
		$('.ToDate').val(LastDate);
	}
	var Userid = $('.PurManager').val();
	InitialTable(Userid);
	DateSetting();
	
	var KeyInfoList = {};
	$('.SearBtn').click(function(){
		$('.KeyInfo').each(function(){
		    var name = $(this).attr('name');
		    var value = $(this).val();
		    if ($(this).is(':checkbox')) {
		        if ($(this).prop('checked')) {
		            KeyInfoList[name] = value;
		        }
		    } else {
		        KeyInfoList[name] = value;
		    }
		});
		var pass = true;
		$.each(KeyInfoList,function(key, value){
			if(key === 'State' || key === 'MatCode'){
				return true;
			}
			if (value == null || value === '') {
    	        pass = false;
    	        return false;
    	    }
		})
		if(!pass){
			alert('모든 필수 항목을 모두 입력해주세요.');
		}else{
			$.ajax({
				url : '${contextPath}/Purchasing/AjaxSet/Order/LoadPOPlan.jsp',
				type : 'POST',
				data :  JSON.stringify(KeyInfoList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success : function(data){
					if(data.length == 0){
						alert('해단 조건의 데이터가 없습니다. \n다시 입력해주세요.');
					}else{
						$('.InfoTable-Body').empty();
						for(var i = 0 ; i < data.length ; i++){
							var row = '<tr>' +
							'<td><input type="checkbox" class="ChkBox"></td>' + 
							'<td>' + data[i].MatCode + '</td>' + 
							'<td>' + data[i].MatDesc + '</td>' + 
							'<td>' + data[i].MatType + '</td>' + 
							'<td>' + data[i].PlanPOQty + '</td>' + 
							'<td>' + data[i].Unit + '</td>' + 
							'<td>' + data[i].Vendor + '</td>' + 
							'<td>' + data[i].VenderDesc + '</td>' + 
							'<td>' + data[i].PricePerUnit + '</td>' + 
							'<td>' + data[i].TCur + '</td>' + 
							'<td>' + data[i].RequestDate + '</td>' + 
							'<td>' + data[i].StorLoca + '</td>' +
							'<td>' + data[i].PlanNumPO + '</td>' +
							'</tr>';
							$('.InfoTable-Body').append(row);
						}
					}
				},
				error: function(jqXHR, textStatus, errorThrown){
					alert('오류 발생: ' + textStatus + ', ' + errorThrown);
		    	}
	    	});
		}
	})
	$('.ChgBtn').click(function(){
		var Count = 1;
		$('.POTable-Body').empty();
		$('.InfoTable-Body input[type="checkbox"]:checked').each(function() {
			var Row = $(this).closest('tr');
			var Mat = Row.find('td:eq(1)').text();
			var Ven = Row.find('td:eq(6)').text();
			var VenDes = Row.find('td:eq(7)').text();
			var Key = Row.find('td:eq(12)').text();
			switch(Key){
			case 'N/A':
				$.ajax({
					url : '${contextPath}/Purchasing/AjaxSet/Order/CreatePODoc.jsp?Case=NA',
					type : 'POST',
					data :  {MatCode : Mat, VenCode : Ven},
					dataType: 'json',
					async: false,
					success : function(data){
						console.log(data);
						$('.MatOrdDocNum').val(data[0]);
						$('.MatOrdVendor').val(Ven);
						$('.MatOrdVendorDes').val(VenDes);
						if(data.length == 0){
							alert('해단 조건의 데이터가 없습니다. \n다시 입력해주세요.');
						}else{
							for(var i = 1 ; i < data.length ; i++){
								var row = '<tr>' +
								'<td><button class="DELBtn">DELETE</button></td>' +
								'<td>' + data[i].POCode + '</td>' +
								'<td>' + (i + 1).toString().padStart(3,'0') + '</td>' + 
								'<td>' + data[i].MatCode + '</td>' + 
								'<td>' + data[i].MatDesc + '</td>' + 
								'<td>' + data[i].MatType + '</td>' + 
								'<td>' + data[i].PlanPOQty + '</td>' + 
								'<td>' + data[i].Unit + '</td>' + 
								'<td>' + data[i].PricePerUnit + '</td>' + 
								'<td>' + data[i].TotalPrice + '</td>' +
								'<td>' + data[i].TCur + '</td>' +
								'<td>' + data[i].Vendor +'(' + data[i].VenderDesc + ')' + '</td>' + 
								'<td>' + data[i].RequestDate + '</td>' + 
								'<td>' + data[i].StorLoca + '</td>' +
								'<td hidden>' + data[i].PlanNumPO + '</td>' +
								'</tr>';
								$('.POTable-Body').append(row);
							}
						}
					},
					error: function(jqXHR, textStatus, errorThrown){
						alert('오류 발생: ' + textStatus + ', ' + errorThrown);
				   	}
			    });
			break;
			default:
				$('.MatOrdVendor').val($('.Entry_VCode').val().substring(0,8));
				$('.MatOrdVendorDes').val($('.Entry_VCode').val().substring(9,13));
				$.ajax({
					url : '${contextPath}/Purchasing/AjaxSet/Order/CreatePODoc.jsp?Case=Nope',
					type : 'POST',
					data :  {MatCode : Mat, VenCode : Ven},
					dataType: 'json',
					async: false,
					success : function(data){
						console.log(data);
						$('.MatOrdDocNum').val(data[0]);
						var row = '<tr>' +
							'<td><button class="DELBtn">DELETE</button></td>' +
							'<td>' + data[0] + '</td>' + // 발주번호
							'<td>' + Count.toString().padStart(3,'0') + '</td>' + // 항번 
							'<td>' + Row.find('td:eq(1)').text() + '</td>' +  // 자재코드
							'<td>' + Row.find('td:eq(2)').text() + '</td>' +  // 자재코드 이름
							'<td>' + Row.find('td:eq(3)').text() + '</td>' +  // 재고유형
							'<td>' + Row.find('td:eq(4)').text() + '</td>' +  // 발주수량
							'<td>' + Row.find('td:eq(5)').text() + '</td>' +  // 단위
							'<td>' + Row.find('td:eq(8)').text() + '</td>' + // 구매단가  
							'<td>' + parseInt(Row.find('td:eq(4)').text()) * parseInt(Row.find('td:eq(8)').text()) + '</td>' + // 구매금액
							'<td>' + Row.find('td:eq(9)').text() + '</td>' + // 거래통화
							'<td>' + Row.find('td:eq(6)').text() +'(' + Row.find('td:eq(7)').text() + ')' + '</td>' + // 공급업체 
							'<td>' + Row.find('td:eq(10)').text() + '</td>' + // 납품요청일자 
 							'<td>' + Row.find('td:eq(11)').text() + '</td>' + // 납품창고
 							'<td hidden>' + Row.find('td:eq(12)').text() + '</td>' + // 납품창고
							'</tr>';
						$('.POTable-Body').append(row);
					},
					error: function(jqXHR, textStatus, errorThrown){
						alert('오류 발생: ' + textStatus + ', ' + errorThrown);
				   	}
			    });
				Count++;
			}
		})
	})
	
	$('.POTable-Body').on('click','.DELBtn', function(){
		var Value = null;
		$('.UnitSum').each(function(){
		    var $this = $(this);
		    if($this.is(':checkbox')){
		        if($this.prop('checked')){
		            Value = $this.val();
		        }
		    }
		});
		var Row = $(this).closest('tr');
		if(Value === 'Solo'){
	 		var KeyData = Row.find('td:eq(14)').text()
	 		console.log(KeyData);
	 		var TableLength = 0;
	 		$('.InfoTable-Body tr').each(function() {
	 	        if ($(this).find('td:eq(12)').text() === KeyData) {
	 	            $(this).find('input[type="checkbox"]').prop('checked', false);
	 	            return false;
	 	        }
	 	    });
	 		Row.remove();
	 		TableLength = $('.POTable-Body tr').length;
	 		if(TableLength === 0){
	 			$('.InfoTable-Body input[type="checkbox"]').prop('checked', false);
	 			$('.POTable-Body').empty();
	 			for (let i = 0; i < 20; i++) {
	 	            const row = $('<tr></tr>');
	 	            for (let j = 0; j < 14; j++) {
	 	                row.append('<td></td>');
	 	            }
	 	            $('.POTable-Body').append(row);
	 	        }
	 		}else{
	 			$('.POTable-Body tr').each(function(index, tr){
	 				var Element = $(this);
	 				Element.find('td:eq(2)').text((index+1).toString().padStart(3,'0'));
	 			})
	 		}
		}else{
			Row.remove();
	 		TableLength = $('.POTable-Body tr').length;
	 		if(TableLength === 0){
	 			$('.InfoTable-Body input[type="checkbox"]').prop('checked', false);
	 			$('.POTable-Body').empty();
	 			for (let i = 0; i < 20; i++) {
	 	            const row = $('<tr></tr>');
	 	            for (let j = 0; j < 14; j++) {
	 	                row.append('<td></td>');
	 	            }
	 	            $('.POTable-Body').append(row);
	 	        }
	 		}
		}

	})
	$('.SaveBtn').click(function(){
		var tableData = [];
		var POinfoList = [];
		$('.POinfo').each(function(){
		    var value = $(this).val();
		    POinfoList.push(value);
		});
		tableData.push(POinfoList);
		$('.POTable-Body tr').each(function(){
			var rowData = [];
			$(this).find('td:gt(0)').each(function(){
				rowData.push($(this).text());
			});
		    tableData.push(rowData);
		});
		$.ajax({
			url : '${contextPath}/Purchasing/AjaxSet/Order/OrdPageSave.jsp',
			type: 'POST',
			data :  JSON.stringify(tableData),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success : function(data){
				if(data.status === 'Success'){
					location.reload();
				}
			}
		})
	});
	$('.CancelBtn').click(function(){
		location.reload();
	})
})
</script>
</head>
<body>
<%
String UserId = (String)session.getAttribute("id");
String userComCode = (String)session.getAttribute("depart");
String UserIdNumber = (String)session.getAttribute("UserIdNumber");
%>
<link rel="stylesheet" href="../css/ReqCss.css?after">
<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<div class="MatOrd-Centralize">
		<div class="MatOrd-Header">
			<div class="MatOrd-Title">SEARCH FIELD</div>
			<div class="InfoInput">
				<label>Company : </label> 
				<input type="text" class="ComCode POinfo" name="ComCode" value="<%=userComCode %>" onclick="InfoSearch('Company')" readonly>
			</div>
			
			<div class="InfoInput">
				<label>❗Plant :  </label>
				<input type="text" class="PlantCode KeyInfo POinfo" name="PlantCode" onclick="InfoSearch('Plant')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>❗Vendor :  </label>
				<input type="text" class="Entry_VCode KeyInfo POinfo" name="Entry_VCode" onclick="InfoSearch('Vendor')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>❗구매그룹 :  </label>
				<select class="PurState KeyInfo POinfo" name="State">
					<option value="SELECT">SELECT</option>
					<option value="DO01">DO01: 내자 일반</option>
					<option value="DO02">DO02: 내자 특수</option>
					<option value="FO01">FO01: 외자 일반</option>
					<option value="FO01">FO02: 외자 특수</option>
					<option value="MO01">MO01: MRO 자재 (소모성 자재)</option>
					<option value="PR01">PR01: 프로젝트 자재</option>
					<option value="RM01">RM01: 원자재</option>
					<option value="SP01">SP01: 스페셜 오더 (주문 제작)</option>
					<option value="EQ01">EQ01: 설비 자재</option>
					<option value="IT01">IT01: IT 관련 자재</option>
				</select>
			</div>
			
			<div class="InfoInput">
				<label>❗동일품목 합산 :  </label>
				<span>합산</span><input type="checkbox" class="UnitSum KeyInfo" name="UnitSum" value="Sum" onclick="checkOnlyOne(this)" readonly checked>
				<span>건별</span><input type="checkbox" class="UnitSum KeyInfo" name="UnitSum" value="Solo" onclick="checkOnlyOne(this)" readonly>
			</div>
			
			<div class="InfoInput">
				<label>Material :  </label>
				<input type="text" class="MatCode KeyInfo" name="MatCode" onclick="InfoSearch('Mateiral')" placeholder="SELECT" readonly>
			</div>
			
			<div class="InfoInput">
				<label>남풉요청일자(FR) :  </label>
				<input type="date" class="FromDate KeyInfo" name="FromDate">
			</div>
			
			<div class="InfoInput">
				<label>남풉요청일자(TO) :  </label>
				<input type="date" class="ToDate KeyInfo" name="ToDate">
			</div>
			<div class="InfoInput">
				<label>구매담당자 :  </label>
				<input type="text" class="PurManager POinfo" name="PurManager" value="<%=UserIdNumber %>" onclick="InfoSearch('Client')" readonly>
			</div>
		
			<button class="SearBtn">검색</button>	
		</div>
		<div class="MatOrd-Body">
			<div class="Info-Area">
				<div class="MatOrd-Title">발주 계획 현황</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>선택</th><th>Material</th><th>Material Description</th><th>재고유형</th><th>발주계획수량</th><th>단위</th>
							<th>공급업체</th><th>공급업체이름</th><th>구매단가</th><th>거래통화</th><th>납품요청일자</th><th>납풍장소</th><th>발주계획번호</th>
						</tr>
					</thead>
					<tbody class="InfoTable-Body">
					</tbody>
				</table>
			</div>
			<div class="Btn-Area">
				<button class="ChgBtn">발주전환</button>
				<button class="SaveBtn">저장</button>
				<button class="CancelBtn">취소</button>
			</div>
			<div class="MatOrd-Area">
				<div class="Req-Title">발주서 발행</div>
				<div class="MatOrd-Area-Header">
					<div class="MatInput">
						<label>발주번호 :  </label>
						<input type="text" class="MatOrdDocNum" id="MatOrdDocNum" name="MatOrdDocNum" readonly>
					</div>
					<div class="MatInput">
						<label>공급업체 :  </label>
						<input type="text" class="MatOrdVendor" id="MatOrdVendor" name="MatOrdVendor" readonly>
						<label>공급업체명 :  </label>
						<input type="text" class="MatOrdVendorDes" id="MatOrdVendorDes" name="MatOrdVendorDes" readonly>
					</div>
				</div>
				<div>
					<table class="POTable">
						<thead class="POTable-Header">
							<tr>
								<th>선택</th><th>발주번호</th><th>PO항번</th><th>Material</th><th>Material Description</th><th>재고유형</th><th>발주수량</th>
								<th>단위</th><th>구매단가</th><th>구매금액</th><th>거래통화</th><th>공급업체</th><th>납품요청일자</th><th>납품창고</th>
							</tr>
						</thead>
						<tbody class="POTable-Body">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
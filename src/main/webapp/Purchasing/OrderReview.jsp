<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<meta charset="UTF-8">
<title>발주검토</title>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const tbody = document.querySelector('.InfoTable-Body');
    const thead = document.querySelector('.InfoTable-Header');

    tbody.addEventListener('scroll', function() {
        thead.scrollLeft = tbody.scrollLeft; // thead의 스크롤 위치를 직접 설정
    });
});
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
    case "Client":
    	window.open("${contextPath}/Purchasing/PopUp/FindClient.jsp?Category=Search", "POPUP03", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
        break;
    case "Company":
    	window.open("${contextPath}/Purchasing/PopUp/FindCom.jsp", "POPUP04", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "EntrySLocation":
    	window.open("${contextPath}/Purchasing/PopUp/FindSLoc.jsp", "POPUP05", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "EntryVendor":
    	window.open("${contextPath}/Purchasing/PopUp/FindVendor.jsp?From=Check", "POPUP06", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
	}
}
function checkOnlyOne(element) {
    const checkboxes = $('.Entry_Ag');
    checkboxes.each(function () {
        this.checked = false;
    });
    element.checked = true;

    if (element.value === 'Neg') {
        $('.Entry_Reject').attr('readonly', false).prop('disabled', false);
    } else {
        $('.Entry_Reject').attr('readonly', true).prop('disabled', true);
    }
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
		var UserId = UserId;
		console.log(UserId);
		for (let i = 0; i < 20; i++) {
            const row = $('<tr></tr>');
            for (let j = 0; j < 16; j++) {
                row.append('<td></td>');
            }
            $('.InfoTable-Body').append(row);
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
		$('.OrderDate').val(today);
	}
	function CreateEntryDocument(){
		var DocTopic = $('.DocCode').val();
		var DocDate = $('.BuyDate').val();
		$('.Req-Area').find('input').prop('disabled', false);
		$.ajax({
			url:'${contextPath}/Purchasing/AjaxSet/Order/ForEntryDoc.jsp?From=Review',
			type:'POST',
			data:{Code : DocTopic, Date : DocDate},
			dataType: 'text',
			success: function(data){
				$('.Entry_DocNum').val(data.trim());
			}
		})
	}
	var Userid = $('.Client').val();
	InitialTable(Userid);
	EntryDisabled();
	DateSetting();
	var OptionList = {};
	$('.SearBtn').click(function(){
		$('.SearOption').each(function(){
			var name = $(this).attr('name');
			var Value = $(this).val();
			OptionList[name] = Value;
		})
		var pass = true;
		$.each(OptionList,function(key,value){
			switch(key){
			case 'MatCode':
				return true;
				break;
			case 'State':
				if(value === 'SELECT'){
					pass = false;	
				}
				break
			default:
				if(value == null || value === ''){
					pass = false;
					return false;
				}
				break;
			}
		})
		if(!pass){
			alert('모든 항목을 입력해주세요.');
		}else{
			$.ajax({
				url : '${contextPath}/Purchasing/AjaxSet/Order/ReqStateQue.jsp',
				type : 'POST',
				data :  JSON.stringify(OptionList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success : function(data){
					EntryAbled();
					if(data.length == 0){
						alert('해당 조건의 데이터가 없습니다. \n다시 입력해주세요.');
					}else{
						$('.InfoTable-Body').empty();
						for(var i = 0 ; i < data.length ; i++){
							var row = '<tr>' +
							'<td><input type="checkbox" class="ChkBox"></td>' + 
							'<td><button class="EditBtn">EDIT</button></td>' +
							'<td>' + data[i].MatCode + '</td>' + 
							'<td>' + data[i].MatDesc + '</td>' + 
							'<td>' + data[i].MatType + '</td>' + 
							'<td>' + data[i].QtyPR + '</td>' + 
							'<td>' + data[i].Unit + '</td>' + 
							'<td>' + data[i].UnitPrice + '</td>' + 
							'<td>' + data[i].Price + '</td>' + 
							'<td>' + data[i].PurCurr + '</td>' + 
							'<td>' + data[i].VendCode + '</td>' + 
							'<td>' + data[i].VendDes + '</td>' + 
							'<td>' + data[i].RequestDate + '</td>' +
							'<td>' + data[i].StorLocaDesc + '</td>' +
							'<td>' + data[i].Reference + '</td>' +
							'<td>' + data[i].DocNumPR + '</td>' +
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
		$('.Ord-Area input').not('.Entry_Ag').val('');
	})
	
	$('.InfoTable-Body').on('click','.EditBtn', function(){
		event.preventDefault();
		var Row = $(this).closest('tr');
		var MatCode = Row.find('td:eq(2)').text();
		var MatDes = Row.find('td:eq(3)').text();
		var MatType = Row.find('td:eq(4)').text();
		var Quantity = Row.find('td:eq(5)').text();
		var Unit = Row.find('td:eq(6)').text().trim();
		var DeliDate = Row.find('td:eq(12)').text();
		var DeliPlace = Row.find('td:eq(13)').text();
		var UnitPrice = Row.find('td:eq(7)').text();
		var Cash = Row.find('td:eq(9)').text();
		var OreReqNumber = Row.find('td:eq(15)').text();
		
		var Today = $('.OrderDate').val();
		$.ajax({
			url: '${contextPath}/Purchasing/AjaxSet/Order/MakeDocNumber.jsp',
			data : {Date : Today},
			success : function(response){
				$('.Entry_DocNum').val(response.trim());
				$('.Entry_Doc_State').val('NMP');
				$('.Entry_MatCode').val(MatCode);
				$('.Entry_MatDes').val(MatDes + '(' + MatType + ')');
				$('.Entry_Count').val(Quantity);
				$('.Entry_Unit').val(Unit);
				$('.Entry_EndDate').val(DeliDate);
				$('.Entry_Place').val(DeliPlace);
				$('.Entry_UnitPrice').val(UnitPrice);
				$('.Entry_Cur').val(Cash);
				$('.OreReqNumber').val(OreReqNumber);
			}
		})
		Row.remove();
	})
	var ESaveList = {};
	$('.EditSaveBtn').click(function(){
		$('.EntryItem').each(function(){
			var Name = $(this).attr('name');
			var Value = $(this).val();
			if($(this).prop('ckecked')){
				ESaveList[Name] = Value;
			}else{
				ESaveList[Name] = Value;
			}
		})
		console.log(ESaveList);
		var pass = true;
		$.each(ESaveList,function(key, value){
			if(key === 'Entry_Reject'){
				return true;
			}
			if (value == null || value === '') {
    	        pass = false;
    	        return false;
    	    }
		})
		if(!pass){
			alert('모든 항목을 입력해주세요.');	
		}else{
			$.ajax({
				url : '${contextPath}/Purchasing/AjaxSet/Order/OrdRwSave.jsp?From=ESave',
				type: 'POST',
				data :  JSON.stringify(ESaveList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success : function(data){
					if(data.status === 'Success'){
						var OrdDocCode = $('.OreReqNumber').val();
						var ReqDocCode = ESaveList.Entry_DocNum;
						$.ajax({
							url : '${contextPath}/Purchasing/AjaxSet/Order/OrdRwEdit.jsp',
							type: 'POST',
							data :  {OrdCode : OrdDocCode, ReqCode : ReqDocCode},
							dataType: 'text',
							success : function(data){
								$('.Ord-Area input').not('.Entry_Ag').val('');
							}
						})
					}
				}
			})
		}
	})
	var TotalList = {};
	$('.TotalSaveBtn').click(function(){
// 		const checkedCount = $('input[type="checkbox"]:checked').length;
// 		console.log(checkedCount);
		var Pass = true;
		$('.InfoTable-Body input[type="checkbox"]:checked').each(function() {
			var Row = $(this).closest('tr');
			var Key = Row.find('td:eq(15)').text();
			 const rowData = [
				 Row.find('td:eq(2)').text(),
				 Row.find('td:eq(3)').text(),
				 Row.find('td:eq(4)').text(),
				 Row.find('td:eq(5)').text(),
				 Row.find('td:eq(6)').text().trim(),
				 Row.find('td:eq(7)').text(),
				 Row.find('td:eq(9)').text(),
				 Row.find('td:eq(10)').text(),
				 Row.find('td:eq(11)').text(),
				 Row.find('td:eq(12)').text(),
				 Row.find('td:eq(13)').text(),
				 $('.Client').val(),
				 $('.PlantCode').val(),
				 $('.ComCode').val(),
				 Row.find('td:eq(15)').text()
			    ];
			 for(var i = 0 ; i < rowData.length ; i++){
				 if(rowData[i] == null || rowData[i] === ''){
					 Pass = false;
					 return false;
				 }
			 }
			 TotalList[Key] = rowData;
			 Row.remove();
		 })
		if(!Pass){
			alert('항목을 다시 선택해주세요.');
		}else{
			$.ajax({
				url : '${contextPath}/Purchasing/AjaxSet/Order/OrdRwSave.jsp?From=TSave',
				type: 'POST',
				data :  JSON.stringify(TotalList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success : function(data){
					if(data.status === 'Success'){
						location.reload();
					}
				}
			})
		}
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
	<div class="Ord-Centralize">
		<div class="Ord-Header">
				<div class="Ord-Title">SEARCH FIELD</div>
				<div class="InfoInput">
					<label>Company : </label> 
					<input type="text" class="ComCode SearOption EntryItem" name="ComCode" value="<%=userComCode %>" onclick="InfoSearch('Company')" readonly>
				</div>
				
				<div class="InfoInput">
					<label>Plant :  </label>
					<input type="text" class="PlantCode SearOption EntryItem" name="PlantCode" onclick="InfoSearch('Plant')" readonly>
				</div>
				
				<div class="InfoInput">
					<label>Material :  </label>
					<input type="text" class="MatCode SearOption" name="MatCode" onclick="InfoSearch('Material')" placeholder="SELECT" readonly>
				</div>
				
				<div class="InfoInput">
					<label>구매요청 상태 :  </label>
					<select class="PurState SearOption" name="State">
						<option value="SELECT">SELECT</option>
						<option value="A 구매요청">A 구매요청</option>
						<option value="B 발주준비">B 발주준비</option>
						<option value="C 발주완료">C 발주완료</option>
						<option value="D 반려">D 반려</option>
					</select>
				</div>
				
				<div class="InfoInput">
					<label>구매담당자 :  </label>
					<input type="text" class="Client EntryItem" name="Client" value="<%=UserIdNumber %>" onclick="InfoSearch('Client')" readonly>
				</div>
				
				<div class="InfoInput">
					<label>ORD TYPE :  </label>
					<input type="text" class="DocCode" value="PXRO" readonly>
				</div>
				
				<div class="InfoInput">
					<label>발주계획일자 :  </label>
					<input type="text" class="OrderDate EntryItem" name="OrderDate" readonly>
				</div>
				
				<button class="SearBtn">검색</button>	
		</div>
		<div class="Ord-Body">
			<div class="Info-Area">
				<div class="Ord-Title">구매 요청 현황</div>
				<table class="InfoTable">
					<thead class="InfoTable-Header">
						<tr>
							<th>선택</th><th>수정</th><th>Material</th><th>Material Description</th><th>재고유형</th><th>구매요청수량</th>
							<th>단위</th><th>구매단가</th><th>구매금액</th><th>거래통화</th><th>Vendor</th><th>Vendor명</th><th>납품요청일자</th>
							<th>납품장소</th><th>구매요청상황</th><th>구매요청번호</th>
						</tr>
					</thead>
					<tbody class="InfoTable-Body">
					</tbody>
				
				</table>
			</div>
			<div class="Btn-Area">
				<button class="EditSaveBtn">저장</button>
				<button class="TotalSaveBtn">일괄 저장</button>
			</div>
			<div class="Ord-Area">
				<div class="Req-Title">구매 요청 검토/저장</div>
				<div class="MatInput">
					<label>발주계획번호 :  </label>
					<input type="text" class="Entry_DocNum EntryItem" id="Entry_DocNum" name="Entry_DocNum" readonly>
					<label>구매요청구분 :  </label>
					<input type="text" class="Entry_Doc_State EntryItem" id="Entry_Doc_State" name="Entry_Type" readonly>
					<input type="text" class="OreReqNumber" id="OreReqNumber" name="OreReqNumber" hidden>
				</div>
				<div class="MatInput">
					<label>Material :  </label>
					<input type="text" class="Entry_MatCode EntryItem" id="Entry_MatCode" name="Entry_MatCode" placeholder="SELECT"  readonly>
					<label>Description :  </label>
					<input type="text" class="Entry_MatDes EntryItem" id="Entry_MatDes" name="Entry_MatDes" readonly>
				</div>
				<div class="MatInput">
					<label>구매 요청 수량 :  </label>
					<input type="text" class="Entry_Count EntryItem EditOk" id="Entry_Count" name="Entry_Count" placeholder="INPUT">
					<label>재고관리 단위 :  </label>
					<input type="text" class="Entry_Unit EntryItem" id="Entry_Unit" name="Entry_Unit" readonly>
				</div>
				<div class="MatInput">
					<label>납품요청일자 :  </label>
					<input type="date" class="Entry_EndDate EntryItem EditOk" id="Entry_EndDate" name="Entry_EndDate">
					<label>납품장소 :  </label>
					<input type="text" class="Entry_Place EntryItem EditOk" id="Entry_Place" name="Entry_Place" placeholder="SELECT" onclick="InfoSearch('EntrySLocation')" readonly>
				</div>
				<div class="MatInput">
					<label>Vendor:  </label>
					<input type="text" class="Entry_VCode EntryItem EditOk" id="Entry_VCode" name="Entry_VCode" placeholder="SELECT" onclick="InfoSearch('EntryVendor')" readonly>
					<label>발주 여부 :  </label>
					<span>발주준비</span><input type="radio" class="Entry_Ag EntryItem"  name="Entry_Ag" value="Pos" onclick="checkOnlyOne(this)" checked>
					<span>반려</span><input type="radio" class="Entry_Ag EntryItem" name="Entry_Ag" value="Neg" onclick="checkOnlyOne(this)">
				</div>
				<div class="MatInput">
					<label>구매단가 :  </label>
					<input type="text" class="Entry_UnitPrice EntryItem" id="Entry_UnitPrice" name="Entry_UnitPrice" readonly>
					<label>거래통화 :  </label>
					<input type="text" class="Entry_Cur EntryItem" id="Entry_Cur" name="Entry_Cur"  readonly>
				</div>
				<div class="MatInput">
					<label>반려 이유 :  </label>
					<input type="text" class="Entry_Reject EntryItem EditOk" id="Entry_Reject" name="Entry_Reject" placeholder="※ 반려할 경우, 이유를 간단히 적어주시기 바랍니다." readonly>
				</div>
			</div>
		</div>
	</div>
<footer>
</footer>
</body>
</html>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="${contextPath}/css/RightCss.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script>
function PickOption(field){
    var popupWidth = 515;
    var popupHeight = 600;
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    // 전체 화면의 크기를 감지
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
	var U_ComCode = $('.UserComCode').val();
	console.log("U_ComCode : " + U_ComCode);
    if (width == 2560 && height == 1440) {
        // 단일 모니터 2560x1440 중앙에 팝업창 띄우기
        xPos = (2560 / 2) - (popupWidth / 2);
        yPos = (1440 / 2) - (popupHeight / 2);
    } else if (width == 1920 && height == 1080) {
        // 단일 모니터 1920x1080 중앙에 팝업창 띄우기
        xPos = (1920 / 2) - (popupWidth / 2);
        yPos = (1080 / 2) - (popupHeight / 2);
    } else {
        // 확장 모드에서 2560x1440 모니터 중앙에 팝업창 띄우기
        var monitorWidth = 2560;
        var monitorHeight = 1440;
        xPos = (monitorWidth / 2) - (popupWidth / 2) + dualScreenLeft;
        yPos = (monitorHeight / 2) - (popupHeight / 2) + dualScreenTop;
    }
    if(field === "BizArea"){
    	window.open("${contextPath}/Authority/BizArea.jsp?ComCode="+U_ComCode, "BAPopUp01", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } else if(field === "BizAreaGroup"){
    	popupWidth = 900;
    	window.open("${contextPath}/Authority/BizAreaGro.jsp?ComCode="+U_ComCode, "BAGPopUp02", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    } 
};

$(document).ready(function(){
    $('.BizAreaCode').prop('disabled', false);
    $('.BizAreaName').prop('disabled', false);
    $('.BizAreaGroCode').prop('disabled', true);
    $('.BizAreaGroName').prop('disabled', true);
    
	$('.GroupDiv').change(function(){
        var G_Div = $(this).val();
        GroupSelect(G_Div);
    });
	function GroupSelect() {
	    var GroValue = $('.GroupDiv:checked').val();
	    console.log(GroValue);

	    // 비활성화할 필드와 활성화할 필드 정의
	    var disableFields = GroValue === 'BA' ? 
	        ['.BizAreaGroCode', '.BizAreaGroName'] :
	        ['.BizAreaCode', '.BizAreaName'];

	    var enableFields = GroValue === 'BA' ?
	        ['.BizAreaCode', '.BizAreaName'] :
	        ['.BizAreaGroCode', '.BizAreaGroName'];

	    // 필드 활성화 및 비활성화
	    $(disableFields.join(', ')).prop('disabled', true).val('');
	    $(enableFields.join(', ')).prop('disabled', false).val('');
	    /* 
	    disableFields.join(', ')는 GroValue의 값에 따라 .BizAreaGroCate, .BizAreaGroName 또는 .BizAreaCate, .BizAreaName가 될 수 있다.
	    근데, disableFields.join(', ')가 $(...)에 둘러 싸여 있어서, 클래스로 형번환되고 , .prop('disabled', true).val('')가 마치 수학의 분배법칙처럼 적용
	    */
	}
	$('.UserDuty').change(function(){
		var testValue = $(this).val();
		console.log(testValue);
		var Des = testValue.split(",");
		$('.UserDutyDes').val(Des[1]);
	});
/* 	var AddDuteClickCount = 0; */
	$('.BizAreaCode, .BizAreaGroCode').change(function(){
		var Value = $(this).val();
		var SysDute = $('.UserDuty').val().split(",")[0];
		console.log(SysDute);
		const ResetValue = [$('.BizAreaCode'), $('.BizAreaName'), $('.BizAreaGroCode'), $('.BizAreaGroName')];
		if(SysDute == '없음' || SysDute == null || SysDute == ''){
			alert('수행 직무를 선택해 주세요.');
			ResetValue.forEach(input => input.val(''));
			return false;
		}
		$.ajax({
			url: '${contextPath}/Authority/SysDuteExpose.jsp',
			type: 'POST',
			data: {SelDute : SysDute},
			success: function(response){
			    console.log('response : ', response);
			    let tableBody = $('.AccessTable_Body');
			    tableBody.empty(); // 기존 내용을 비우고 새로 추가
			   
			    response.forEach(function(data){
			        let row = '<tr>' +
			        	'<td hidden>' + Value + '</td>' +
			            '<td>' + data.RnRCode + '</td>' +
			            '<td>' + data.RnRDescp + '</td>' +
			            '<td>' + data.UiGroupDescrip + '</td>';
			            
				            let Lv2List = data.UiGroup2LvList;
				           	let Lv2OriValue = Lv2List.join(',');
				           	let Lv2Value = Lv2OriValue.split(',');
				            
				            row += '<td>';  // 다섯 번째 열의 첫 번째 셀 시작
				            for(var Lv2 = 0; Lv2 < Lv2Value.length; Lv2++) {
				                row += '<div class=Lv2_'+ Lv2 +'>' + Lv2Value[Lv2] + '</div>';  // Lv3Value의 각 데이터를 새로운 셀에 추가
				            }
				            row += '</td>';
				            
				            let Lv3List = [];
				            
				            for(var i = 0 ; i < Lv2List.length ; i++){
				            	Lv3List.push(data[Lv2List[i]]);
				            }
				            let Lv3OriValue = Lv3List.join(',');
				            let Lv3Value = Lv3OriValue.split(',');
				            
				            row += '<td>';  // 다섯 번째 열의 첫 번째 셀 시작
				            for(var Lv3 = 0; Lv3 < Lv3Value.length; Lv3++) {
				                row += '<div class=Lv3_'+ Lv3 +'>' + Lv3Value[Lv3] + '</div>';  // Lv3Value의 각 데이터를 새로운 셀에 추가
				            }
				            row += '</td>';
				            
				            let Lv4List = [];
				            let Lv4KeyMap = [];
				            for(var j = 0 ; j < Lv3Value.length; j++){
				            	Lv4List.push(data[Lv3Value[j]]);
				            	Lv4KeyMap.push(Lv3Value[j]);  // Lv3Value에서 사용된 키 값을 Lv4KeyMap에 저장
				            }
				            console.log('Lv4List의 길이 : '+ Lv4List.length);
				            console.log('Lv4List 01 : '+ Lv4List);
				            console.log('Lv4List 02 : '+ Lv4KeyMap);
				            
				            row += '<td>';  // 여섯 번째 열 시작 (홀수 인덱스 데이터를 출력하는 열)
				            for (let a = 0; a < Lv4List.length; a++) {
				                for (let b = 0; b < Lv4List[a].length; b++) {
				                    if (b % 2 === 1) {  // 홀수 인덱스
				                        row += '<div class=Lv4_'+ a + '_' + b +'>' + Lv4List[a][b] + '</div>';
				                    }
				                }
				            }
				            row += '</td>';

				            row += '<td>';  // 일곱 번째 열 시작 (짝수 인덱스 데이터를 출력하는 열)
				            for (let a = 0; a < Lv4List.length; a++) {
				                for (let b = 0; b < Lv4List[a].length; b++) {
				                    if (b % 2 === 0) {  // 짝수 인덱스
				                        row += '<select>';
				                        const options = ['권한없음','입력/수정/조회', '수정/조회', '조회'];
				                        options.forEach(function(option) {
				                        		row += '<option value="' + option +','+ Lv4List[a][b] + '">' + option + '</option>';
				                        });
				                        row += '</select>';
				                    }
				                }
				            }
				            row += '</td>';

			            row += '</tr>';
			        	
			        tableBody.append(row);
					
		            for(let a = 0 ; a < Lv4List.length ; a++){
		            	console.log('a값: ' + a);
		            	let lv4DivCount = 0;
		            	const Lv4Pattern = new RegExp(`class=Lv4_${ "${a}" }`, 'g');
		            	lv4DivCount = (row.match(Lv4Pattern) || []).length;
		            	console.log('Lv4_'+a+'으로 시작하는 <div>의 개수:', lv4DivCount);
		            	if(lv4DivCount){
		            		let lv3DivCount = 0;
		            		const Lv3Pattenr = new RegExp(`class=Lv3_${ "${a}" }`, 'g');;
		            		lv3DivCount = (row.match(Lv3Pattenr) || []).length; 
		            		console.log('Lv3_'+a+'으로 시작하는 <div>의 개수:', lv3DivCount);
		            		
		            		for (let i = 0; i < lv3DivCount; i++) {
		                        // 각 Lv3 div의 고유한 클래스명을 만듦
		                        const lv3DivClassName = `Lv3_${ "${a}" }`;
		                        console.log(`Lv3_${ "${a}" }`);
		                        const newHeight = (lv4DivCount * 35) + 'px';
		                        $(`.Lv3_${"${a}"}`).css('height', newHeight);
		                        console.log(lv3DivClassName + '의 높이 : ' + newHeight);
		                        console.log('END');
		                    }
		            	}
		            }
		            
		            console.log('Lv3List의 길이 : ' + Lv3List[0].length);
		            console.log('Lv3List의 길이 : ' + Lv3List[1].length);
		            console.log('Lv3List의 길이 : ', Lv3List.length);
		            
		            for(let b = 0 ; b < Lv3List.length ; b++){
		            	let combinedArray = [].concat(...Lv3List); // 통합된 배열
		            	console.log('통합된 배열의 길이 : ' + combinedArray.length);
		            	console.log('통합된 배열', combinedArray);
		            	console.log(Lv3List[b]);
		            	console.log(Lv2Value[b]);
		            	
		            	let SearchLv2Value = Lv2Value[b];
		            	let NewDivHeight = 0;
		            	let DelCt = 0;
		            	if(SearchLv2Value && b === 0){
		            		for(let c = 0 ; c < Lv3List[b].length ; c++){
		            			let SearchLv3Value = combinedArray[c];
		            			const LookingLv3Div = new RegExp(`${ "${SearchLv3Value}" }`, 'g');
		            			let result = row.match(LookingLv3Div);
		            			console.log('result : ' + result);
		            			console.log('SearchLv3Value : ' + SearchLv3Value);
		            			if(result){ // 실재로 SearchLv3Value에 저장된 데이터를 갖는 <div>가 있는지 확인
		            				let divElement = document.querySelector(`.Lv3_${ "${c}" }`);
		            				console.log('divElement : ', divElement);
		            				let divHeight = divElement.style.height;
		            				let Lv2Height = parseInt(divHeight);
		            				NewDivHeight += Lv2Height;
		            			}
		            		}
		            	} else { // b가 0이 아닌 경우 예 -> b = 1
		            		 
		            		for(let p = 0 ; p < b ; p++){ // combinedArray에서 사용된 값들을 삭제하는 과정
		            			let UsedCount = Lv3List[p].length;
		            			console.log('UsedCount : ' + UsedCount);
		            			for(let q = 0 ; q < UsedCount ; q++){
		            				let UsedValue = combinedArray[0];
		            				console.log('UsedValue : ' + UsedValue);
		            				let DeleteEle = combinedArray.indexOf(UsedValue);
		            				if(DeleteEle > -1){
		            					combinedArray.splice(DeleteEle, 1);
		            					DelCt++;
		            				} 
		            			}
		            		}// combinedArray에서 사용된 값들을 삭제하는 과정
		            		 
		            		console.log(DelCt);
		            		for(let c = 0 ; c < Lv3List[b].length ; c++){
		            			let SearchLv3Value = combinedArray[c];
		            			const LookingLv3Div = new RegExp(`${ "${SearchLv3Value}" }`, 'g');
		            			let result = row.match(LookingLv3Div);
		            			console.log('result : ' + result);
		            			console.log('SearchLv3Value : ' + SearchLv3Value);
		            			if(result){ // 실재로 SearchLv3Value에 저장된 데이터를 갖는 <div>가 있는지 확인
		            				let divElement = document.querySelector(`.Lv3_${ "${DelCt}" }`);  
		            				console.log('divElement : ', divElement);
		            				let divHeight = divElement.style.height;
		            				let Lv2Height = parseInt(divHeight);
		            				NewDivHeight += Lv2Height;
		            				DelCt ++;
		            			}
		            		}
		            		
		            	}
	            		console.log('NewDivHeight : ' + NewDivHeight);
	            		$(`.Lv2_${"${b}"}`).css('height', NewDivHeight);
		            }
			    });
			}
		});
	});

	$('.SaveBtn').click(function(){
		var TempSaveList = [];
		var CountNumber = 1;
		
		var UserId = $('.UserId').val(); // 사용자의 아이디
		var UserName = $('.UserName').val(); // 사용자의 이름
		var UserCoCd = $('.UserComCode').val(); // 사용자가 속한 회사코드
		
		let UserInfo = [UserId, UserName, UserCoCd];
		
		TempSaveList['0'] = UserInfo;
		$('.AccessTable_Body tr').each(function() {
	        // 시스템 코드, 직무명 가져오기
	        var UserGroupCode = $(this).find('td:eq(0)').text().trim();  // BizArea 또는 BizAreaGroup의 코드
	        var SysDutyCode = $(this).find('td:eq(1)').text().trim();    // 시스템 직무코드
	        var SysDutyName = $(this).find('td:eq(2)').text().trim();    // 시스템 직무명
	        
	        console.log(UserGroupCode);
	        console.log(SysDutyCode);
	        console.log(SysDutyName);
	         // <div>에서 텍스트 가져오기
	        
	         // select 요소들을 가져와 선택된 값 저장
	        $(this).find('td:eq(7)').find('select').each(function(index) {
	        	
	            var selectedValue01 = $(this).val().split(",")[0];
	            var selectedValue02 = $(this).val().split(",")[1];
	            if (selectedValue01 !== '권한없음') {
	            	
	            	console.log('<select>의 순번 : ', index);
	            	console.log(selectedValue01); // 사용자가 신청한 권한
	            	console.log(selectedValue02); // 권한 코드
	            	
	            	var DivText = $(this).closest('tr').find('td:eq(6) div').eq(index).text().trim(); // 화면번호에 해당하는 이름
	            	console.log(DivText);
	            	let AuthRequest = [UserGroupCode, SysDutyCode, SysDutyName, selectedValue01, selectedValue02, DivText];
		            TempSaveList[CountNumber] = AuthRequest;
		            CountNumber++;
	            }
	            
	        });
	         
	    });
		console.log(TempSaveList);
		$.ajax({
			url: '${contextPath}/Authority/TempSavePage.jsp',
			type: 'POST',
			data: JSON.stringify(TempSaveList),
			contentType: 'application/json; charset=utf-8',
			dataType: 'json',
			async: false,
			success: function(response){
				console.log(response);
				console.log(response.status);
				if(response.status == "success"){
					alert('저장되었습니다.');
				}
				TempSaveList = [];
			}
		})
	});
	
	$('.AddDute').click(function() {
		
		var BizAreaVal = $('.BizAreaCode').val();
		var BizAreaGroVal = $('.BizAreaGroCode').val();
		var Value = null;
		
		if(BizAreaVal == null || BizAreaVal == ''){
			Value = BizAreaGroVal;
			console.log('BizAreaGroVal : ' + Value);
		} else{
			Value = BizAreaVal;
			console.log('BizAreaVal : ' + Value);
		}
		
		var SysDute = $('.UserDuty').val().split(",")[0];
	    
	    $.ajax({
			url: '${contextPath}/Authority/SysDuteExpose.jsp',
			type: 'POST',
			data: {SelDute : SysDute},
			success: function(response){
			    console.log('response : ', response);
			    let tableBody = $('.AccessTable_Body');
			   
			    response.forEach(function(data){
			        let row = '<tr>' +
			        	'<td hidden>' + Value + '</td>' +
			            '<td>' + data.RnRCode + '</td>' +
			            '<td>' + data.RnRDescp + '</td>' +
			            '<td>' + data.UiGroupDescrip + '</td>';
			            
				            let Lv2List = data.UiGroup2LvList;
				           	let Lv2OriValue = Lv2List.join(',');
				           	let Lv2Value = Lv2OriValue.split(',');
				            
				            row += '<td>';  // 다섯 번째 열의 첫 번째 셀 시작
				            for(var Lv2 = 0; Lv2 < Lv2Value.length; Lv2++) {
				                row += '<div class=Lv2_'+ Lv2 +'>' + Lv2Value[Lv2] + '</div>';  // Lv3Value의 각 데이터를 새로운 셀에 추가
				            }
				            row += '</td>';
				            
				            let Lv3List = [];
				            
				            for(var i = 0 ; i < Lv2List.length ; i++){
				            	Lv3List.push(data[Lv2List[i]]);
				            }
				            let Lv3OriValue = Lv3List.join(',');
				            let Lv3Value = Lv3OriValue.split(',');
				            
				            row += '<td>';  // 다섯 번째 열의 첫 번째 셀 시작
				            for(var Lv3 = 0; Lv3 < Lv3Value.length; Lv3++) {
				                row += '<div class=Lv3_'+ Lv3 +'>' + Lv3Value[Lv3] + '</div>';  // Lv3Value의 각 데이터를 새로운 셀에 추가
				            }
				            row += '</td>';
				            
				            let Lv4List = [];
				            let Lv4KeyMap = [];
				            for(var j = 0 ; j < Lv3Value.length; j++){
				            	Lv4List.push(data[Lv3Value[j]]);
				            	Lv4KeyMap.push(Lv3Value[j]);  // Lv3Value에서 사용된 키 값을 Lv4KeyMap에 저장
				            }
				            
				            row += '<td>';  // 여섯 번째 열 시작 (홀수 인덱스 데이터를 출력하는 열)
				            for (let a = 0; a < Lv4List.length; a++) {
				                for (let b = 0; b < Lv4List[a].length; b++) {
				                    if (b % 2 === 1) {  // 홀수 인덱스
				                        row += '<div class=Lv4_'+ a + '_' + b +'>' + Lv4List[a][b] + '</div>';
				                    }
				                }
				            }
				            row += '</td>';

				            row += '<td>';  // 일곱 번째 열 시작 (짝수 인덱스 데이터를 출력하는 열)
				            for (let a = 0; a < Lv4List.length; a++) {
				                for (let b = 0; b < Lv4List[a].length; b++) {
				                    if (b % 2 === 0) {  // 짝수 인덱스
				                        row += '<select>';
				                        const options = ['권한없음','입력/수정/조회', '수정/조회', '조회'];
				                        options.forEach(function(option) {
				                        		row += '<option value="' + option +','+ Lv4List[a][b] + '">' + option + '</option>';
				                        });
				                        row += '</select>';
				                    }
				                }
				            }
				            row += '</td>';

			            row += '</tr>';
			        	
			        tableBody.append(row);
					
		            for(let a = 0 ; a < Lv4List.length ; a++){
		            	let lv4DivCount = 0;
		            	const Lv4Pattern = new RegExp(`class=Lv4_${ "${a}" }`, 'g');
		            	lv4DivCount = (row.match(Lv4Pattern) || []).length;
		            	if(lv4DivCount){
		            		let lv3DivCount = 0;
		            		const Lv3Pattenr = new RegExp(`class=Lv3_${ "${a}" }`, 'g');;
		            		lv3DivCount = (row.match(Lv3Pattenr) || []).length;
		            		
		            		for (let i = 0; i < lv3DivCount; i++) {
		                        // 각 Lv3 div의 고유한 클래스명을 만듦
		                        const lv3DivClassName = `Lv3_${ "${a}" }`;
		                        const newHeight = (lv4DivCount * 35) + 'px';
		                        $(`.Lv3_${"${a}"}`).css('height', newHeight);
		                    }
		            	}
		            }
		            
		            for(let b = 0 ; b < Lv3List.length ; b++){
		            	let combinedArray = [].concat(...Lv3List); // 통합된 배열
		            	
		            	let SearchLv2Value = Lv2Value[b];
		            	let NewDivHeight = 0;
		            	let DelCt = 0;
		            	if(SearchLv2Value && b === 0){
		            		for(let c = 0 ; c < Lv3List[b].length ; c++){
		            			let SearchLv3Value = combinedArray[c];
		            			const LookingLv3Div = new RegExp(`${ "${SearchLv3Value}" }`, 'g');
		            			let result = row.match(LookingLv3Div);
		            			if(result){ // 실재로 SearchLv3Value에 저장된 데이터를 갖는 <div>가 있는지 확인
		            				let divElement = document.querySelector(`.Lv3_${ "${c}" }`);
		            				let divHeight = divElement.style.height;
		            				let Lv2Height = parseInt(divHeight);
		            				NewDivHeight += Lv2Height;
		            			}
		            		}
		            	} else { // b가 0이 아닌 경우 예 -> b = 1
		            		 
		            		for(let p = 0 ; p < b ; p++){ // combinedArray에서 사용된 값들을 삭제하는 과정
		            			let UsedCount = Lv3List[p].length;
		            			for(let q = 0 ; q < UsedCount ; q++){
		            				let UsedValue = combinedArray[0];
		            				let DeleteEle = combinedArray.indexOf(UsedValue);
		            				if(DeleteEle > -1){
		            					combinedArray.splice(DeleteEle, 1);
		            					DelCt++;
		            				} 
		            			}
		            		}// combinedArray에서 사용된 값들을 삭제하는 과정
		            		 
		            		console.log(DelCt);
		            		for(let c = 0 ; c < Lv3List[b].length ; c++){
		            			let SearchLv3Value = combinedArray[c];
		            			const LookingLv3Div = new RegExp(`${ "${SearchLv3Value}" }`, 'g');
		            			let result = row.match(LookingLv3Div);
		            			if(result){ // 실재로 SearchLv3Value에 저장된 데이터를 갖는 <div>가 있는지 확인
		            				let divElement = document.querySelector(`.Lv3_${ "${DelCt}" }`);
		            				let divHeight = divElement.style.height;
		            				let Lv2Height = parseInt(divHeight);
		            				NewDivHeight += Lv2Height;
		            				DelCt ++;
		            			}
		            		}
		            		
		            	}
	            		$(`.Lv2_${"${b}"}`).css('height', NewDivHeight);
		            }
			    });
			}
		});
	});
	$('.AccessRequest').click(function() {
		$.ajax({
			url: '${contextPath}/Authority/ApplicationPage.jsp',
			type: 'POST',
			success: function(response){
			}
		})
	});
	
})
</script>
<title>Insert title here</title>
</head>
<body>
<%
	String id = (String)session.getAttribute("id");
	String name = (String)session.getAttribute("name");
	String ComCode = (String)session.getAttribute("depart");
%>
<div class="AccessArea">
	<div class="UserInfoArea">
		<div class="UInfiInputArea">
			<div class="UserInfo">
				<label>사용자 아이디 :</label> 
				<input type="text" class="UserId MainInfo KeyValue" name="UserId" value="<%=id %>" readonly>
				<input type="text" class="UserName SubInfo KeyValue" name="UserName" value="<%=name %>" readonly>
				<input type="text" class="UserComCode KeyValue" name="UserComCode" value="<%=ComCode %>" hidden>
			</div>
			<div class="UserInfo">
				<label>수행 직무 :</label> 
				<select class="UserDuty" name="UserDuty">
					<option>없음</option>
					<%
					try{
						String sql = "SELECT * FROM sys_dute";
						PreparedStatement pstmt = conn.prepareStatement(sql);
						ResultSet rs = pstmt.executeQuery();
						while(rs.next()){
					%>
						<option value="<%=rs.getString("RnRCode")%>,<%=rs.getString("RnRDescp")%>"><%=rs.getString("RnRCode")%></option>
					<%
						}
					}catch(SQLException e){
						e.printStackTrace();
					}
					%>
				</select>
				<input type="text" class="UserDutyDes" name="UserDutyDes" checked>
			</div>
			<div class="UserInfo">
				<label>권한부여 조직구분 :</label> 
				<input type="radio" class="GroupDiv" name="GroupDiv" value="BA" checked><span>BizArea</span>
				<input type="radio" class="GroupDiv" name="GroupDiv" value="BAG"><span>BizArea Group</span>
			</div>
			<div class="UserInfo">
				<label>Biz Area :</label>
				<input type="text" class="BizAreaCode MainInfo" name="BizAreaCode" id="BizAreaCode" onclick="PickOption('BizArea')" readonly>
				<input type="text" class="BizAreaName SubInfo" name="BizAreaName" id="BizAreaName" readonly>
			</div>
			<div class="UserInfo">
				<label>BizArea Group :</label> 
				<input type="text" class="BizAreaGroCode MainInfo" name="BizAreaGroCode" id="BizAreaGroCode" onclick="PickOption('BizAreaGroup')" readonly>
				<input type="text" class="BizAreaGroName SubInfo" name="BizAreaGroName" id="BizAreaGroName" readonly>
			</div>
		</div>
	</div>
	
	<div class="ButtonArea">
		<button class="SaveBtn">저장</button> <!-- 정보를 임시 저장하기 위한 버튼 -->
		<button class="AddDute">직무추가</button> 
		<button class="AccessRequest">권한신청</button>
	</div>
	
	<div class="AccessInfoArea">
		<table class="AccessTable">
			<thead class="AccessTable_Head">
				<th>시스템 직무코드</th><th>직무명</th><th>직무화면그룹01</th><th>직무화면그룹02</th><th>직무화면그룹03</th><th>화면번호</th><th>기본권한</th>
			</thead>
			<tbody class="AccessTable_Body">
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
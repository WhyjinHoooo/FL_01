<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/> 
<link rel="stylesheet" href="../css/style.css?after">
<title>Insert title here</title>
<!--     <style>
        table {
            border-collapse: collapse;
            width: 50%;
            margin: 20px 0;
        }

        th, td {
            border: 1px solid #dddddd;
            text-align: center;
            padding: 8px;
        }

        th {
            background-color: #f2f2f2;
        }
    </style> -->
<script type='text/javascript'>
function Search(){
	var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;
    
    window.open("CateSearch.jsp", "테스트", "width=515,height=600, left=500 ,top=" + yPos);	
}
</script>
</head>
<body>
	<h1>데이터 조회</h1>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<div class="wrapper">
			<div class="search-section">
				<button type="button" onclick="Search()">Search</button>
				<select class="Category">
					<option>Select</option>	
					<option value="Com_Code">회사</option>
					<option value="Plant">공장</option>
					<option value="StorLoc">창고</option>
				</select>
				<input type="text" class="InputData" name="InputData">
				
				<button type="button" id="excelDownload" class="download">다운로드</button>
				<button onClick="window.location.reload()">새로고침</button>
			</div>
			<script type="text/javascript">
				$(document).ready(function(){
				    $('.InputData').keydown(function(event){
				        if(event.keyCode == 13) {
				            var data = $(this).val();
				            var Cate = $('.Category').val();
				            console.log("검색할 데이터 : " + data + ", 조건 : " + Cate);
				            $.ajax({
				                url : "InfoSearch.jsp",
				                type : "POST",
				                data : {Find : data, Condi : Cate},
				                success : function(response){
				                    if(response.length === 0 || response[0].hasOwnProperty('error')){
				                        alert(response[0].error);
				                        return;
				                    }
				                    var table = $('#tableData');
				                    for(var i = 0 ; i < response.length ; i++){
				                        var row = $("<tr>");
				                        row.append($("<td>").text(response[i]['년월']));
				                        row.append($("<td>").text(response[i]['회사']));
				                        row.append($("<td>").text(response[i]['재료']));
				                        row.append($("<td>").text(response[i]['Lot']));
				                        row.append($("<td>").text(response[i]['단위']));
				                        row.append($("<td>").text(response[i]['공장']));
				                        row.append($("<td>").text(response[i]['창고']));
				                        row.append($("<td>").text(response[i]['기초수량']));
				                        row.append($("<td>").text(response[i]['기초금액']));
				                        row.append($("<td>").text(response[i]['입고수량']));
				                        row.append($("<td>").text(response[i]['입고금액']));
				                        row.append($("<td>").text(response[i]['출고수량']));
				                        row.append($("<td>").text(response[i]['출고금액']));
				                        row.append($("<td>").text(response[i]['입출수량']));
				                        row.append($("<td>").text(response[i]['입출금액']));
				                        row.append($("<td>").text(response[i]['재고수량']));
				                        row.append($("<td>").text(response[i]['재고금액']));
				                        row.append($("<td>").text(response[i]['재고단가']));
				                        table.append(row);
				                    }
				                },
				                error: function(jqXHR, textStatus, errorThrown) {
				                    console.log(textStatus, errorThrown); // 오류 정보 출력
				                }
				            });
				        }
				    });
				});
			</script>
		
	    <table class="DataForm table-section" id="tableData">
	        <tr>
	            <th>년월</th><th>회사</th><th>자재코드</th><th>자재Lot번호</th><th>재고단위</th><th>공장</th><th>창고</th><!-- <th>Rack/Bin</th> --><th>기초수량</th><th>기초금액</th><br>
	            <th>매입입고수량</th><th>매입입고금액</th><!-- <th>기타입고수량</th><th>기타입고금액</th> --><th>출고수량</th><th>출고금액</th><th>이체입출고수량</th><th>이체입출고금액</th><br>
	            <th>재고수량</th><th>재고금액</th><th>총평균단가</th><!-- <th>이동평균단가</th> <th>마감일자</th><th>마감시간</th> -->
	        </tr>
	    </table>
	</div>    
<script>
    const excelDownload = document.querySelector('#excelDownload');
    
    document.addEventListener('DOMContentLoaded', ()=>{
        excelDownload.addEventListener('click', exportExcel);
    });
    
    function exportExcel(){ 
        // 사용자로부터 파일 이름 입력 받기
        var fileName = prompt("다운로드할 파일의 이름을 입력해주세요.", "test");
        if (fileName == null || fileName == "") {
            alert("파일 이름을 입력해주세요.");
            return;
        }
        
        var sheetName = prompt("시트의 이름을 입력해주세요.", "test");
        if (sheetName == null || sheetName == "") {
            alert("시트 이름을 입력해주세요.");
            return;
        }
        //엑셀 시트 생성
        var wb = XLSX.utils.book_new();
        var newSh = excelHandler.getWorksheet();
        XLSX.utils.book_append_sheet(wb, newSh, sheetName);
        var wb = XLSX.write(wb, {bookType:'xlsx',  type: 'binary'});
    
        saveAs(new Blob([stab(wb)],{type:"application/octet-stream"}), fileName + '.xlsx');
    }
    
    var excelHandler = {
        getExcelData : function(){
            return document.getElementById('tableData');   //TABLE id
        },
        getWorksheet : function(){
            return XLSX.utils.table_to_sheet(this.getExcelData());
        }
    }
    
    function stab(s) { 
        var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
        var view = new Uint8Array(buf);  //create uint8array as viewer
        for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
        return buf;    
    }
    
</script>     
</body>
</html>
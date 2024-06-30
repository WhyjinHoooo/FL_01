<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
<title>Insert title here</title>
    <style>
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
    </style>
</head>

<body>
	<button type="button" id="excelDownload" class="download">엑셀파일 다운로드</button>
    <table class="tb1" id="tableData">
        <tr>
            <th>스텔라이브</th>
            <th>설명</th>
        </tr>
        <tr>
            <td>유즈하 리코</td>
            <td>달콤한 맛과 다양한 영양소를 포함한 과일입니다.</td>
        </tr>
        <tr>
            <td>텐코 시부키</td>
            <td>대박박</td>
        </tr>
        <tr>
            <td>하나코 나나</td>
            <td>빰빠까밤~~~</td>
        </tr>
        <tr>
            <td>아오쿠모 린</td>
            <td>뇨~~~~</td>
        </tr>
    </table>
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
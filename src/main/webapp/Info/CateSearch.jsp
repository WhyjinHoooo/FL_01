<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Insert title here</title>
</head>
    <script type="text/javascript">
	    function executeSQL(sql, type) {
	        console.log("Executing SQL: " + sql);
	        $.ajax({
	            url: 'Find.jsp',
	            type: 'POST',
	            data: { sql: sql, type: type },
	            success : function(response){
	                var board = $('<div>').addClass('ComSearch-board');
	                var table = $('<table>');
	                table.append('<tr><th>코드</th><th>이름</th></tr>'); // 테이블 헤더 추가
	                if(response.length === 0 || response[0].hasOwnProperty('error')){
	                    alert(response[0].error);
	                } else {
	                    for(var i = 0 ; i < response.length ; i++){
	                        var row = $("<tr>");
	                        var codeCell = $("<td>");
	                        var nameCell = $("<td>");

	                        // 클릭 이벤트 추가
	                        codeCell.append($("<a>").attr("href", "javascript:void(0)").text(response[i]['코드']).click(function() {
	                            var code = $(this).text();
	                            var name = $(this).parent().next().text();
	                            window.opener.document.querySelector('.InputData').value= code;
	                            window.opener.document.querySelector('.Category').value= type;
	                            window.opener.document.querySelector('.InputData').dispatchEvent(new Event('change'));
	                            window.opener.console.log('선택된 Mat.사용부서 : ' + code + ', 부서명 ' + name);
	                            window.close();
	                        }));

	                        nameCell.text(response[i]['이름']);
	                        row.append(codeCell);
	                        row.append(nameCell);
	                        table.append(row);
	                    }
	                }
	                board.append(table);
	                $('.test').empty().append(board); // 'test' 클래스를 가진 요소 초기화 후, board 추가
	            }
	        });
	    }

        document.addEventListener('DOMContentLoaded', function() {
            var companyButton = document.getElementById('companyButton');
            var plantButton = document.getElementById('plantButton');
            var storageButton = document.getElementById('storageButton');

            companyButton.addEventListener('click', function() {
                var sql = "SELECT Com_Cd, Com_Des FROM company";
                executeSQL(sql, 'Com_Code');
            });

            plantButton.addEventListener('click', function() {
                var sql = "SELECT PLANT_ID, PLANT_NAME FROM plant";
                executeSQL(sql, 'Plant');
            });

            storageButton.addEventListener('click', function() {
                var sql = "SELECT STORAGR_ID, STORAGR_NAME FROM storage";
                executeSQL(sql, 'StorLoc');
            });
        });
    </script>
<body>
<h1>검색</h1>
<hr>
 	<button id="companyButton" type="button">회사</button>
    <button id="plantButton" type="button">공장</button>
    <button id="storageButton" type="button">창고</button>
    <center>
		<div class="ComSearch-board">
		    <table class="test">
		    
		    </table>    
		</div>    
    </center>
</body>
</html>
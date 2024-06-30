<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<%@ include file="../mydbcon.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<link rel="stylesheet" href="../css/basic.css?after">
<body>
	<div class="Find-container">
		<div class="id-container">
			<form>
				<div class="Find-Cate">Name</div>
					<input type="text" class="bottom-border" id="name">
				<div class="Find-Cate">Id</div>
					<input type="text" class="bottom-border" id="id">
				<div class="btn">
					<button type="submit" class="idFIndBtn">찾기</button>
	        	</div>
	        	<script type="text/javascript">
	        	$(document).ready(function() {
	        	    $('.idFIndBtn').click(function(event) {
	        	        event.preventDefault(); // 기본 이벤트 동작 방지

	        	        var Id = $('#id').val();
	        	        var Name = $('#name').val();
	        	        
	        	        if (!Id || !Name) {
	        	            alert('모든 항목을 입력해주세요.');
	        	            return false; // 이벤트 종료
	        	        }

	        	        // AJAX 요청
	        	        $.ajax({
	        	            type: "POST",
	        	            url: "PwSearch.jsp",
	        	            data: { I: Id, N: Name },
	        	            success: function(response) {
	        	            	if(response.Pass){
	        	            		alert("당신의 임시 비밀번호는 " + response.Pass + " 로 초기화했습니다."); // 응답 메시지 표시	
	        	            		window.close();
	        	            	} else{
	        	            		alert("회원가입을 해주세요.");
	        	            		window.close();
	        	            	}
	        	            },
	        	            error: function(xhr, status, error) {
	        	                console.error(xhr.responseText);
	        	                alert("에러 발생: " + error); // 에러 메시지 출력
	        	            }
	        	    	});
	        		});
	        	});
	        	</script>
			</form>
		</div>
	</div>
</body>
</html>
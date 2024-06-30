<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script>
	function confirm(){
		var search = document.Searchform.Com_search.value;
		if(!search){
			alert('검색 항목을 입력해주세요');
			return false;
		} else{
			return true;
		}
	}
</script>
<body>
	<h1>Company Search</h1>
	<hr>
	<form id="Searchform" name="Searchform" action="Company_Search_Ok.jsp" method="post" onSubmit="return confirm()" encType="UTF-8">
		<input type="text" name="Com_search" size="10">
		<input class="searchBtn" type="submit" value="Search">
	</form>
</body>
</html>
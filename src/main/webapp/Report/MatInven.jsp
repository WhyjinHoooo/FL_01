<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수불관리</title>
<link rel="stylesheet" href="../css/Inven.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script>
function TestFunction(value) {
    let url;
    if (value === 'Company') {
        url = 'MainHall/MainHallTest01.jsp';
    } else if (value === 'Plant') {
        url = 'MainHall/MainHallTest02.jsp';
    } else if (value === 'Slocation') {
        url = 'MainHall/MainHallTest03.jsp';
    }
    if (url) {
        $('.MainHallArray').load(url);
    }
}
$(document).ready(function() {
    TestFunction('Company');
});
</script>
</head>
<body>
<jsp:include page="../HeaderTest.jsp"></jsp:include>
<div class="Hall">
	<div class="MainHall">
		<div class="Title">검색 항목</div>
		<div class="Category">
			<button class="No1" onclick="TestFunction('Company')">Com.Lv</button>
			<button class="No1" onclick="TestFunction('Plant')">Pla.Lv</button>
			<button class="No1" onclick="TestFunction('Slocation')">SLo.lc</button>
		</div>
		<div class="MainHallArray"></div>
		
		<div class="BtnArea">
			<button>Search</button>
		</div>
	</div>
	
	<div class="SubHall">
		<div class="Title">재고 수불 현황</div>
		
	</div>
</div>
</body>
</html>
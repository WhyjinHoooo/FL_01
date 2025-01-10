<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<link rel="stylesheet" href="${contextPath}/css/Nav.css?after">
<!-- <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet"> -->


<!DOCTYPE html>
<head>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
<script>
$(document).ready(function(){
  // 중첩된 드롭다운 메뉴를 위한 클릭 이벤트
  $('.dropdown-menu a.dropdown-toggle').on('click', function(e) {
    if (!$(this).next().hasClass('show')) {
      $(this).parents('.dropdown-menu').first().find('.show').removeClass("show");
    }
    var $subMenu = $(this).next(".dropdown-menu");
    $subMenu.toggleClass('show');

    $(this).parents('li.nav-item.dropdown.show').on('hidden.bs.dropdown', function(e) {
      $('.dropdown-submenu .show').removeClass("show");
    });

    return false;
  });
});
</script>
</head>
<body>
	
<nav class="navbar navbar-expand-lg navbar-light" style="background-color: #002060;">
  <div class="container-fluid">
    <%-- <a class="navbar-brand Category" href="#" style="color: #ffffff;"><img src="${contextPath}/img/B_LoGo.png" alt=""></a> --%>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavDropdown">
      <ul class="navbar-nav">
        <!-- 기타 nav-item들 -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle Category" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">Type</a>
          <ul class="dropdown-menu Sang" aria-labelledby="navbarDropdownMenuLink">
            <li class="dropdown-submenu">
            	<a class="dropdown-item dropdown-toggle" href="#">GI(출고)/IR(이체출고)</a>
            	<ul class="dropdown-menu">
	                <li><a class="dropdown-item" href="MovSerach.jsp">출고(GI)</a></li>
	                <li><a class="dropdown-item" href="Test_IR.jsp">이체출고(IR)</a></li>
              	</ul>
            </li>          
          </ul>
        </li>
        
      </ul>
    </div>
  </div>
</nav>
</body>

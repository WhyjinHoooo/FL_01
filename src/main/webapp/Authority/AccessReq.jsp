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
$(document).ready(function(){
    $('.BizAreaCate').prop('disabled', false);
    $('.BizAreaName').prop('disabled', false);
    $('.BizAreaGroCate').prop('disabled', true);
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
	        ['.BizAreaGroCate', '.BizAreaGroName'] :
	        ['.BizAreaCate', '.BizAreaName'];

	    var enableFields = GroValue === 'BA' ?
	        ['.BizAreaCate', '.BizAreaName'] :
	        ['.BizAreaGroCate', '.BizAreaGroName'];

	    // 필드 활성화 및 비활성화
	    $(disableFields.join(', ')).prop('disabled', true).val('');
	    $(enableFields.join(', ')).prop('disabled', false).val('');
	    /* 
	    disableFields.join(', ')는 GroValue의 값에 따라 .BizAreaGroCate, .BizAreaGroName 또는 .BizAreaCate, .BizAreaName가 될 수 있다.
	    근데, disableFields.join(', ')가 $(...)에 둘러 싸여 있어서, 클래스로 형번환되고 , .prop('disabled', true).val('')가 마치 수학의 분배법칙처럼 적용
	    */
	}
})
</script>
<title>Insert title here</title>
</head>
<body>
<%
	String id = (String)session.getAttribute("id");
	String name = (String)session.getAttribute("name");
%>
<div class="AccessArea">
	<div class="UserInfoArea">
		<div class="UInfiInputArea">
			<div class="UserInfo">
				<label>사용자 아이디 :</label> 
				<input type="text" class="UserId MainInfo" name="UserId" value="<%=id %>" readonly>
				<input type="text" class="UserName SubInfo" name="UserName" value="<%=name %>" readonly>
			</div>
			<div class="UserInfo">
				<label>수행 직무 :</label> 
				<select class="UserDuty" name="UserDuty">
					<option>없음</option>
					<option>있음</option>
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
				<input type="text" class="BizAreaCate MainInfo" name="BizAreaCate" onclick="">
				<input type="text" class="BizAreaName SubInfo" name="BizAreaName" readonly>
			</div>
			<div class="UserInfo">
				<label>BizArea Group :</label> 
				<input type="text" class="BizAreaGroCate MainInfo" name="BizAreaGroCate" onclick="">
				<input type="text" class="BizAreaGroName SubInfo" name="BizAreaGroName" readonly>
			</div>
		</div>
	</div>
	<div class="AccessInfoArea">
	</div>
</div>
</body>
</html>
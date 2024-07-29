<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/forSlip.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>품의 상신 의견</title>
<script>
function OpinionBtn(event, FieldName){
    event.preventDefault();
    
    var DocCode = $('.SlipCode').val();
    var UserOpinion = $('.UserOp').val();
    if(FieldName === "Save"){
        $.ajax({
            url: 'OpinionSave.jsp',
            type:'POST',
            data: {SlipCode : DocCode, Opinion : UserOpinion},
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success') {
                    console.log('데이터를 수정했습니다');
                    // 팝업 창 닫기
                    window.opener.location.reload(); // 부모 창 새로 고침
                    window.close(); // 팝업 창 닫기
                } else {
                    console.log('Error:', response.message);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log('Error:', textStatus, errorThrown);
            }
        });
    }
}
</script>

</head>
<div class="OpinionBanner">품의 상신 의견</div>
<body class="testBody">
	<%
	String SlipCode = request.getParameter("SlipCode");
	String UserId = (String)session.getAttribute("id");
	String Username = (String)session.getAttribute("name");
	%>
	<div class="OpinionDiv">
        <table class="OpinionTable">
        	<tr>
        		<th>품의자 :</th>
        			<td>
        				 <input type="text" class="UserCode" id="UserCode" name="UserCode" value="<%=UserId%>" readonly>
        				 <input type="text" class="SlipCode" value="<%=SlipCode%>"> 
        			</td>
        	</tr>
        	<tr>
        		<th>결재/합의자 성명 :</th>
        			<td>
        				<input type="text" class="UserName" id="UserName" name="UserName" value="<%=Username%>" readonly>
        			</td>
        	</tr>
        	<tr>
        		<th>상신 의견 :</th>
        			<td>
        				 <textarea class="UserOp" id="UserOp" name="UserOp"></textarea>
        			</td>
        	</tr>
        </table>
        <button class="SaveBtn" onclick="OpinionBtn(event, 'Save')">저장</button>
        <button class="CancelBtn" onclick="OpinionBtn(event, 'Cancel')">취소</button>
    </div>
</body>
</html>
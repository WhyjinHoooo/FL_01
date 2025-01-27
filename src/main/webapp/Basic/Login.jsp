<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/basic.css?after">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<title>Insert title here</title>
<script>
function InfoSearch(field){
	var popupWidth = 1000;
    var popupHeight = 600;
    
    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
    
    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var xPos, yPos;
    
    if (width == 2560 && height == 1440) {
        xPos = (2560 / 2) - (popupWidth / 2);
        yPos = (1440 / 2) - (popupHeight / 2);
    } else if (width == 1920 && height == 1080) {
        xPos = (1920 / 2) - (popupWidth / 2);
        yPos = (1080 / 2) - (popupHeight / 2);
    } else {
        var monitorWidth = 2560;
        var monitorHeight = 1440;
        xPos = (monitorWidth / 2) - (popupWidth / 2) + dualScreenLeft;
        yPos = (monitorHeight / 2) - (popupHeight / 2) + dualScreenTop;
    }
    
    switch(field){
    case "IdFind":
    	window.open("${contextPath}/Basic/idFind.jsp", "IdPopUp", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "PwFind":
    	window.open("${contextPath}/Basic/PwFind.jsp", "PwPopUp", "width=" + popupWidth + ",height=" + popupHeight + ",left=" + xPos + ",top=" + yPos);
    	break;
    case "NewComer":
    	location.href = "${contextPath}/Basic/RegistMember.jsp";
    }
}
$(document).ready(function(){
	var ChkList = {};
	$('.Login_Btn').click(function(){
		$('.key').each(function(){
			var name = $(this).attr('name');
			var value = $(this).val();
			ChkList[name] = value;
		})
	    var pass = false;
		$.each(ChkList,function(key, value){
			if(value == null || value === ''){
				pass = true;
				return false;
			}
		});
		if(pass){
			alert('아이디와 비밀번호를 입력해주세요.');
			return false;
		}else{
			$.ajax({
				url: '${contextPath}/Basic/LoginOk.jsp',
				type: 'POST',
				data: JSON.stringify(ChkList),
				contentType: 'application/json; charset=utf-8',
				dataType: 'json',
				async: false,
				success: function(data){
					console.log(data.status);
					if(data.status === 'Success'){
						location.href = '${contextPath}/main.jsp';
					}else{
						alert('회원가입을 해주세요.');
					}
					
				}
			});
		}
	});
	$('.UserPw').keydown(function(e){
    	if(e.which == 13){
    		$('.Login_Btn').trigger("click");
    		return false;
    	}
    });
})
</script>
</head>
<body>
	<div class="Login-wrapper">
		<aside>
			<img id="logo" name="Logo" src="${contextPath}/img/reflect.png" alt="">
		</aside>
		<div class="Login-Area">
			<table class="Com-Area">
				<tr class="Area">
					<th class="ComTitle main-title">Company : </th>
						<td class="ComSec">
							<select class="ComChoice key" name="ComChoice">
								<option disabled selected>Select</option>
				        		<%
				        		String sql = "SELECT * FROM company";
				        		try{
				        			PreparedStatement pstmt = conn.prepareStatement(sql);
				        			ResultSet rs = pstmt.executeQuery();
				        			while(rs.next()){
				        		%>
				        			<option value="<%=rs.getString("Com_Cd")%>">(<%=rs.getString("Com_Cd")%>)<%=rs.getString("Com_Des")%></option>
				        		<%
				        			}
				        		} catch(SQLException e){
									e.printStackTrace();
				        		}
				        		%>
							</select>
						</td>
				</tr>
			</table>
			
				<div class="Input-Section">
					<table class="Id-Area">
						<tr class="Area">
							<th class="IdTitle main-title">Login-ID : </th>
								<td class="ComSec">
									<input type="text" class="UserId User key" name="UserId" placeholder="입력"> <!-- 매번 입력하기 번거로워서 미리 입력함 -->
								</td>
						</tr>
					</table>
					<table class="PW-Area">
						<tr class="Area">
							<th class="PwTitle main-title">Password : </th>
								<td class="ComSec">
									<input type="password" class="UserPw User key" name="UserPw" placeholder="입력"> <!-- 매번 입력하기 번거로워서 미리 입력함 -->
								</td>
						</tr>
					</table>
					<button class="Login_Btn" id="btn">Login</button>
				</div>
				<div class="SearchSection">
					<table id="findTable">
						<tr class="JoinSec">
							<th>※ 신규 회원 가입 신청</th>
								<td>
									<Button class="Join CommonBtn" name="Join" type="button" onclick="InfoSearch('NewComer')">회원가입</Button> <!-- onclick="NewComer()" -->
								</td>
						</tr>
						<tr class="JoinSec">
							<th>※ ID 확인 </th>
								<td>
									<Button class="IdFind CommonBtn" name="IdFind" type="button" onclick="InfoSearch('IdFind')">ID 찾기</Button>
								</td>
						</tr>
						<tr class="JoinSec">
							<th>※ Password 찾기 </th>
								<td>
									<Button class="PWCh CommonBtn" name="PwFind" type="button" onclick="InfoSearch('PwFind')">비밀번호 찾기</Button>
								</td>
						</tr>				
					</table>
				</div>
		</div>		
	</div>
</body>
</html>
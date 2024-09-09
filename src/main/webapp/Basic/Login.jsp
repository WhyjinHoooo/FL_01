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
	    
	    // 현재 활성화된 모니터의 위치를 감지
	    var dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
	    var dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
	    
	    // 전체 화면의 크기를 감지
	    var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
	    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
	    var xPos, yPos;
	    
	    if (width == 2560 && height == 1440) {
	        // 단일 모니터 2560x1440 중앙에 팝업창 띄우기
	        xPos = (2560 / 2) - (popupWidth / 2);
	        yPos = (1440 / 2) - (popupHeight / 2);
	    } else if (width == 1920 && height == 1080) {
	        // 단일 모니터 1920x1080 중앙에 팝업창 띄우기
	        xPos = (1920 / 2) - (popupWidth / 2);
	        yPos = (1080 / 2) - (popupHeight / 2);
	    } else {
	        // 확장 모드에서 2560x1440 모니터 중앙에 팝업창 띄우기
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
	    }
	}
	function NewComer(){
		/* window.location.href = "${contextPath}/Basic/RegistMember.jsp"; */
		location.href = "${contextPath}/Basic/RegistMember.jsp";
	}
</script>
</head>
<body>
	<form name="LoginPage" id="LoginPageId" action="LoginOk.jsp" method="POST" onsubmit="" enctype="UTF-8">
		<div class="Login-wrapper">
			<aside>
				<img id="logo" name="Logo" src="${contextPath}/img/Logo.png" alt="">
			</aside>
			<div class="Login-Area">
				<table class="Com-Area">
					<tr class="Area">
						<th class="ComTitle main-title">Company : </th>
							<td class="ComSec">
								<select class="ComChoice" name="ComChoice">
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
										<input type="text" class="UserId User" name="UserId" placeholder="입력"> <!-- 매번 입력하기 번거로워서 미리 입력함 -->
									</td>
							</tr>
						</table>
						<table class="PW-Area">
							<tr class="Area">
								<th class="PwTitle main-title">Password : </th>
									<td class="ComSec">
										<input type="password" class="UserPw User" name="UserPw" placeholder="입력"> <!-- 매번 입력하기 번거로워서 미리 입력함 -->
									</td>
							</tr>
						</table>
						<input class="Login_Btn" id="btn" type="submit" value="Login">
					</div>
					<div class="SearchSection">
						<table id="findTable">
							<tr class="JoinSec">
								<th>※ 신규 회원 가입 신청</th>
									<td>
										<Button class="Join CommonBtn" name="Join" type="button" onclick="NewComer()">회원가입</Button>
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
	</form>
</body>
</html>
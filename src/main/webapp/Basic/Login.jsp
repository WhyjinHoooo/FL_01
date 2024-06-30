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
	function IdFind(){
		var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Basic/idFind.jsp", "테스트", "width=600,height=495, right=500 ,top=" + yPos);
	}
	function PwFind(){
		var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Basic/PwFind.jsp", "테스트", "width=600,height=495, right=500 ,top=" + yPos);
	}
	function NewComer(){
	    var EmpNum;
	    var Check = prompt("사원 번호를 입력해주세요.");
	    if(Check != null){
	        EmpNum = Check;
	        $.ajax({
	            url: 'RegistionCheck.jsp',
	            type: 'POST',
	            data: {EmpCode : EmpNum},
	            success: function(response){
	                console.log(response); // 서버 응답 확인
	                if (response.trim() === "No") {
	                    alert(response.trim()); // 사원 코드가 없는 경우 알림 표시
	                } else if(response.trim() === "Yes") {
	                    alert("사원 코드가 있습니다."); // 사원 코드가 있는 경우 알림 표시
	                } else{
	                	alert("사원 페이지로 이동합니다."); // 사원 코드가 있는 경우 알림 표시
	                	 window.location.href = "RegistMember.jsp?Number=" + EmpNum;
	                }
	            }
	        });
	    }
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
										<input type="text" class="UserId User" name="UserId">
									</td>
							</tr>
						</table>
						<table class="PW-Area">
							<tr class="Area">
								<th class="PwTitle main-title">Password : </th>
									<td class="ComSec">
										<input type="password" class="UserPw User" name="UserPw">
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
										<!-- <Button class="Join CommonBtn" name="Join" type="button" onclick="location.href='RegistMember.jsp'">회원가입</Button> -->
										<Button class="Join CommonBtn" name="Join" type="button" onclick="NewComer()">회원가입</Button>
									</td>
							</tr>
							<tr class="JoinSec">
								<th>※ ID 확인 </th>
									<td>
										<a href="javascript:IdFind()"><Button class="IdFind CommonBtn" name="IdFind" type="button">ID 찾기</Button></a>
									</td>
							</tr>
							<tr class="JoinSec">
								<th>※ Password 찾기 </th>
									<td>
										<a href="javascript:PwFind()"><Button class="PWCh CommonBtn" name="PwFind" type="button">비밀번호 찾기</Button></a>
									</td>
							</tr>				
						</table>
					</div>
			</div>
			
		</div>
	</form>
</body>
</html>
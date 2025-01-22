<%@page import="java.sql.SQLException"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" href="../css/basic.css?after">
<title>회원가입</title>
<script>
$(document).ready(function(){
	$('#UserM').change(function(){
	var selectedMonth = parseInt($(this).val());
	var selectedYear = parseInt($('.Year').val());
	var daysInMonth = new Date(selectedYear, selectedMonth, 0).getDate();
	         		        
	for(var i = 1; i <= daysInMonth; i++) {
			$('#UserD').append('<option value="' + i + '">' + i + '</option>');
		}
	});
	
	$('.Year').change(function(){
		$('#UserM').trigger('change');
	});
	
	$('.ComSelect').on('change',function(){
		var SelectedComCode = $('.ComSelect').val();
		$.ajax({
			url: '${contextPath}/Information/AjaxSet/CoCtList.jsp',
			type: 'POST',
			data: {SendWord : SelectedComCode},
			success: function(response){
				$('.CoCtSelect').html(response);
			}
		});
	})
	$('#checkbtn').click(function() {
		event.preventDefault();
		var id = $('.InputId').val();
			if(!id){
				alert('아이디를 입력해주세요.');
				return false;
			} else{
				console.log("검사할 아이디: " + id);	
				}
		$.ajax({
			type : "POST",
			url : "IdCheck.jsp",
			dataType: "json",
			data : {CheckId : id},
			success : function(response){
				console.log(response);
				if(response.result == 'good'){
					alert('사용 가능한 아이디입니다.');
				}else{
					alert('사용 불가능한 아이디입니다.');
					$('.InputId').val("");
				}
			}
		})
	})	
});
window.addEventListener('DOMContentLoaded',(event) => {	
	const domainList = document.querySelector('#UserDoM');
	const domainListInput = document.querySelector('#UserDom_txt');
		if(domainList.value === "text"){
			domainListInput.readOnly = false;
		} else{
			domainList.value = domainListInput.value;
			domainListInput.readOnly = true;
		}
	domainList.addEventListener('change', (event) => {
		if(event.target.value === "text"){
			domainListInput.value = "";
			domainListInput.readOnly = false;
		} else{
			domainListInput.value = event.target.value;
			domainListInput.readOnly = true;
		}
	});
});
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = '';
            var extraAddr = '';

            if (data.userSelectedType === 'R') {
                addr = data.roadAddress;
                addr = data.jibunAddress;
            }
            if(data.userSelectedType === 'R'){
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                document.getElementById("Addr_extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("Addr_extraAddress").value = '';
            }

            document.getElementById('Addr_postcode').value = data.zonecode;
            document.getElementById("Addr_address").value = addr;
            document.getElementById("Addr_detailAddress").focus();
        }
    }).open();
}
function emptyCheck(){
	event.preventDefault();
	
	var UserInfoSet = {};
	$('.UserInfo').each(function(){
		var name = $(this).attr('name');
		var value = $(this).val();
		UserInfoSet[name] = value;
	})
	$.ajax({
		url:'${contextPath}/Information/AjaxSet/EMPList.jsp',
		type: 'POST',
		data: JSON.stringify(UserInfoSet),
		contentType: 'application/json; charset=utf-8',
		dataType: 'json',
		async: false,
		success: function(response){
			console.log(response);
			if(response.status === 'Success'){
				var pass = false;
				$.each(UserInfoSet, function(key, value){
					if(value == null || value === ""){
						console.log(key + ' : ' + value);
						pass == true;
						return false;
					}
				});
				if (pass){
					alert("모든 필수 항목을 입력해주세요.");
				    return false;
				}else{
					if(response.UserInfoList.UserIdCard1.length !== 6 || response.UserInfoList.UserIdCard2.length !== 7){
						alert("주민등록번호를 정확하게 입력해주세요.")
						return false;
					}
					if(response.UserInfoList.UserPw1 !== response.UserInfoList.UserPw2){
						alert('비밀번호가 같지 않습니다.')
						return false;
					} else {
						let reg = /^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[~?!@#$%^&*_-]).{8,}$/
						if(!reg.test(response.UserInfoList.UserPw1)){
							alert('비밀번호는 소문자, 특수문자를 포함한 8자 이상을 입력해주세요.');
							return false;
						}
					}
					if(response.UserInfoList.Ph_M.length !== 4 || response.UserInfoList.Ph_E.length!== 4){
						alert('전화번호를 올바르게 입력하세요.');
						return false;
					}
                    document.Registform.submit();
				}
			} else{
				alert(" 해당 사번(" + response.UserInfoList.UserId + ")은 등록되지 않았습니다.");
                return false;
			}
		},
	    error: function(xhr, status, error) {
	        console.error("AJAX 요청에 실패했습니다.");
	        console.error("상태: " + status);
	        console.error("에러: " + error);
	    }
	});
}
</script>
<script type="text/javascript">

</script>
</head>
<body class="RegistArea">
	<%
	LocalDateTime now = LocalDateTime.now();
	int Year = Integer.parseInt(now.format(DateTimeFormatter.ofPattern("yyyy")));
	%>
<div class="container">
	<div class="member-container">
		<form class="user-info" name="Registform" id="Registform" method="POST" onSubmit="return emptyCheck()" action="registOk.jsp" enctype="UTF-8">		
			<div class="Cate">Name</div>
				<input type="text" class="bottom-border UserInfo" name="UserName" placeholder="Input Name">
				
			<div class="Cate">ID card</div>
				<input type="text" class="IDNum1 UserInfo" name="UserIdCard1">-<input type="password" class="IDNum2 UserInfo" name="UserIdCard2">
				
			<div class="Cate">Login-Id</div> 
				<div class="IdArea">
					<input type="text" class="InputId UserInfo" name="UserId" placeholder="Input Id">
          			<button class="IdDuplicationBtn" id="checkbtn">Check</Button>
          		</div>
				<div id="ErrorMess">※5~12자의 영문,숫자만 사용 가능합니다.</div>
				
          	<div class="Cate">Password</div>
          		<input type="password" class="bottom-border UserInfo" name="UserPw1" placeholder="Input Password">
          		<div id="ErrorMess">※비밀번호는 8자 이상, 특수문자를 포함해주세요.</div>
          		
         	<div class="Cate">Password</div>
          		<input type="password" class="bottom-border UserInfo" name="UserPw2" placeholder="Input Password For Check">
          		
          	<div class="domain">
	          	<div class="Cate">E-Mail</div>
	          		<input type="text" class="Email UserInfo" name="UserEm" placeholder="Email">@
		          	<input type="text" class="Domain_txt UserInfo" name="UserDom_txt" id="UserDom_txt"  placeholder="Domain" readonly>
		          	<select class="Domain" name="UserDoM" id="UserDoM">
		          		<option value="text">Select</option>
		          		<option value="naver.com">naver.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="nate.com">nate.com</option>
						<option value="kakao.com">kakao.com</option>
		          	</select>
          	</div>
          	
          	<div class="Cate">BirthDay</div>
				<div>
	          		<select class="Year UserInfo" name="UserY" id="UserY">
	          			<option>SELECT</option>
	          			<%
	          			for(int i = Year; i > 1940 ; i--){
	          			%>
	          			<option value=<%= i %>><%=i %></option>
	          			<%
	          			}
	          			%>
	          		</select>
	          		년
	          		<select class="Month UserInfo" name="UserM" id="UserM">
	          			<option>SELECT</option>
	          			<%
	          				for(int i = 1 ; i < 13 ; i++){
	          			%>
	          			<option value=<%=i %>><%=i %></option>
	          			<%
	          				}
	          			%>
	          		</select>
	          		월
	          		<select class="Date UserInfo" name="UserD" id="UserD">
	          			<option>SELECT</option>
	          		</select>
	          		일
				</div>

          	<div class="Cate">Address</div>
				
				<input type="text" class="AddrCode UserInfo" id="Addr_postcode" name="ZipCd" placeholder="우편번호">
				<input type="button" class="AddrCodeBtn" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
				<input type="text" class="bottom-border UserInfo" name="Addr" id="Addr_address" placeholder="주소"><br>
				<input type="text" class="bottom-border" name="AddrRefer" id="Addr_extraAddress" placeholder="참고항목" hidden>	
				<input type="text" class="bottom-border UserInfo" name="AddrDetail" id="Addr_detailAddress" placeholder="상세주소">
				
          	<div class="Cate">Gender</div>
				<input type="radio" class="UserInfo" name="gender" value="male" checked/>남성
				<input type="radio" class="UserInfo" name="gender" value="female" />여성
				
        	<div class="Cate">Phone Number</div>
        	<select  class="PH_front UserInfo" name="Ph_F">
        		<option disabled selected>Select</option>
        		<% 
        			String[] PnFront = {"010","011","016","017","019"};
        			for(String prefix : PnFront){
        		%>
        			<option value=<%= prefix%>><%= prefix%></option>
        		<%
        			}
        		%>
        	</select>
        	-<input type="text" class="PH_middle UserInfo" name="Ph_M">-<input type="text" class="PH_end UserInfo" name="Ph_E">
        	
        <div class="Cate">소속</div>
        	<select class="ComSelect UserInfo" name="Belong">
        		<option>SELECT</option>
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
        	<select class="CoCtSelect UserInfo" name="CoCtSelect">
        		<option>SELECT</option>
        	</select>
        <div class="Cate">Employee ID</div>
			<input type="text" class="bottom-border Employee_ID UserInfo" name="Employee_ID" placeholder="Input Employee ID">	
			
        <div class="btn">			
			<button type="submit" class="RegistBtn">가입하기</button>
        </div>
       	</form>
      </div>
    </div>
</body>
</html>
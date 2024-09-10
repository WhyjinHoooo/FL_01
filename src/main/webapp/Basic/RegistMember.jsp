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
	    $('#checkbtn').click(function(event) {
	        event.preventDefault(); // 이벤트 기본 동작(페이지 이동 등)을 취소합니다.
	    });
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
		$('#UserM').trigger('change');
		
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
		/* 
		$('.testBtn').on('click', function(event) {
	        event.preventDefault();
	        
	        var Be = $('.ComSelect').val();
			var CoCt = $('.CoCtSelect').val();
			var EMP_ID = $('.Employee_ID').val();
	        
	        $.ajax({
				url:'${contextPath}/Information/AjaxSet/EMPList.jsp',
				type: 'POST',
				data: {SendCom : Be, SendCoCt : CoCt, SendID : EMP_ID},
				success: function(response){
					console.log(response);
				}
			});
	    });
		 */
		
	});
	window.addEventListener('DOMContentLoaded',(event) => {
		
		const domainList = document.querySelector('#UserDoM'); // 옵션에서 직접 선택한 도메인 주소
		const domainListInput = document.querySelector('#UserDom_txt'); // 사용자가 직접 입력한 도메인 주소
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
					/* domainListInput.value = ""; // 선택된 도메인 값을 텍스트 필드에서 제거합니다. */
					domainListInput.value = event.target.value;
					domainListInput.readOnly = true;
				}
			});
	});
	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	            var addr = ''; // 주소 변수
	            var extraAddr = ''; // 참고항목 변수
	
	            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                addr = data.roadAddress;
	            } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                addr = data.jibunAddress;
	            }
	
	            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	            if(data.userSelectedType === 'R'){
	                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                    extraAddr += data.bname;
	                }
	                // 건물명이 있고, 공동주택일 경우 추가한다.
	                if(data.buildingName !== '' && data.apartment === 'Y'){
	                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                if(extraAddr !== ''){
	                    extraAddr = ' (' + extraAddr + ')';
	                }
	                // 조합된 참고항목을 해당 필드에 넣는다.
	                document.getElementById("Addr_extraAddress").value = extraAddr;
	            
	            } else {
	                document.getElementById("Addr_extraAddress").value = '';
	            }
	
	            // 우편번호와 주소 정보를 해당 필드에 넣는다.
	            document.getElementById('Addr_postcode').value = data.zonecode;
	            document.getElementById("Addr_address").value = addr;
	            // 커서를 상세주소 필드로 이동한다.
	            document.getElementById("Addr_detailAddress").focus();
	        }
	    }).open();
	}
	function emptyCheck(){
		event.preventDefault();
		
		var UName = document.Registform.UserName.value;
		
		var UIdCd1 = document.Registform.UserIdCard1.value;
		var UIdCd2 = document.Registform.UserIdCard2.value;
		
		var Id = document.Registform.UserId.value;
		
		var Pw1 = document.Registform.UserPw1.value;
		var Pw2 = document.Registform.UserPw2.value;
		
		var EmF = document.Registform.UserEm.value;
		var EmD = document.Registform.UserDom_txt.value;
		
		var Y = document.Registform.UserY.value;
		var M = document.Registform.UserM.value;
		var D = document.Registform.UserD.value;
		
		var ZipCd = document.Registform.ZipCd.value;
		var Addr = document.Registform.Addr.value;
		var AddrRef = document.Registform.AddrRefer.value;
		
		var Gen = document.Registform.gender.value;
		
		var PH_f = document.Registform.Ph_F.value;
		var PH_m = document.Registform.Ph_M.value;
		var PH_e = document.Registform.Ph_E.value;
		
		var Be = document.Registform.Belong.value;
		var CoCt = document.Registform.CoCtSelect.value;
		
		var EMP_ID = document.Registform.Employee_ID.value;
		
		$.ajax({
			url:'${contextPath}/Information/AjaxSet/EMPList.jsp',
			type: 'POST',
			data: {SendCom : Be, SendCoCt : CoCt, SendID : EMP_ID},
			success: function(response){
				console.log(response);
				if(response.trim() === 'Yes'){
					if (
						!UName || !UIdCd1 || !UIdCd2 || !Id || 
						!Pw1 || !Pw2 || !EmF || !EmD || 
						!Y || !M || !D || !ZipCd || 
						!Addr || !AddrRef || !Gen || !Be || 
						!PH_f || !PH_m || !PH_e || !CoCt ||
						!EMP_ID
					){
						alert("모든 필수 항목을 입력해주세요.");
					    return false;
					}else{
						if(UIdCd1.length !== 6 || UIdCd2.length !== 7){
							alert("주민등록번호를 정확하게 입력해주세요.")
							return false;
						}
						if(Pw1 !== Pw2){
							alert('비밀번호가 같지 않습니다.')
							return false;
						} else {
							let reg = /^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[~?!@#$%^&*_-]).{8,}$/
							if(!reg.test(Pw1)){
								alert('비밀번호는 소문자, 특수문자를 포함한 8자 이상을 입력해주세요.');
								return false;
							}
						}
						if(PH_m.length !== 4 || PH_e.length!== 4){
							alert('전화번호를 올바르게 입력하세요.');
							return false;
						}
	                    document.Registform.submit();
					}
				} else{
					alert(EMP_ID + "는 등록된 사번입니다.\n 다시 입력해주세요.");
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
	<div class="member-container"><!-- registOk.jsp -->
		<form class="user-info" name="Registform" id="Registform" method="POST" onSubmit="return emptyCheck()" action="registOk.jsp" enctype="UTF-8">		
			<div class="Cate">Name</div>
				<input type="text" class="bottom-border" name="UserName" placeholder="Input Name">
				
			<div class="Cate">ID card</div>
				<input type="text" class="IDNum1" name="UserIdCard1">-<input type="password" class="IDNum2" name="UserIdCard2">
				
			<div class="Cate">Login-Id</div> 
				<div class="IdArea">
					<input type='text' class='InputId' name="UserId" placeholder="Input Id">
          			<button class="IdDuplicationBtn" id="checkbtn">Check</Button>
          			<script type="text/javascript">
          			$('#checkbtn').click(function() {
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
          			</script>
          		</div>
				<div id="ErrorMess">※5~12자의 영문,숫자만 사용 가능합니다.</div>
				
          	<div class="Cate">Password</div>
          		<input type="password" class="bottom-border" name="UserPw1" placeholder="Input Password">
          		<div id="ErrorMess">※비밀번호는 8자 이상, 특수문자를 포함해주세요.</div>
          		
         	<div class="Cate">Password</div>
          		<input type="password" class="bottom-border" name="UserPw2" placeholder="Input Password For Check">
          		
          	<div class="domain">
	          	<div class="Cate">E-Mail</div>
	          		<input type="text" class="Email" name="UserEm" placeholder="Email">@
		          		<input type="text" class="Domain_txt" name="UserDom_txt" id="UserDom_txt"  placeholder="Domain" readonly>
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
	          		<select class="Year" name="UserY" id="UserY">
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
	          		<select class="Month" name="UserM" id="UserM">
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
	          		<select class="Date" name="UserD" id="UserD">
	          			<option>SELECT</option>
	          		</select>
	          		일
				</div>

          	<div class="Cate">Address</div>
				
				<input type="text" class="AddrCode" id="Addr_postcode" name="ZipCd" placeholder="우편번호">
				<input type="button" class="AddrCodeBtn" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
				<input type="text" class="bottom-border" name="Addr" id="Addr_address" placeholder="주소"><br>
				<input type="text" class="bottom-border" name="AddrRefer" id="Addr_extraAddress" placeholder="참고항목" hidden>	
				<input type="text" class="bottom-border" name="AddrDetail" id="Addr_detailAddress" placeholder="상세주소">
				
          	<div class="Cate">Gender</div>
				<input type="radio" name="gender" value="male" checked/>남성
				<input type="radio" name="gender" value="female" />여성
				
        	<div class="Cate">Phone Number</div>
        	<select  class="PH_front" name="Ph_F">
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
        	-<input type="text" class="PH_middle" name="Ph_M">-<input type="text" class="PH_end" name="Ph_E">
        	
        <div class="Cate">소속</div>
        	<select class="ComSelect" name="Belong">
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
        	<select class="CoCtSelect" name="CoCtSelect">
        		<option>SELECT</option>
        	</select>
        <div class="Cate">Employee ID</div>
			<input type="text" class="bottom-border Employee_ID" name="Employee_ID" placeholder="Input Employee ID">	
			
        <div class="btn">			
			<button type="submit" class="RegistBtn">가입하기</button>
        </div>
       	</form>
      </div>
    </div>
</body>
</html>
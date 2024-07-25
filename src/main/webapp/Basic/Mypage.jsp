<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" href="../css/basic.css?after">
<title>회원정보 수정</title>
<script>
	window.addEventListener('DOMContentLoaded',(event) => {
		
		const domainList = document.querySelector('#UserDoM'); // 옵션에서 직접 선택한 도메인 주소
		const domainListInput = document.querySelector('#UserDom_txt'); // 사용자가 직접 입력한 도메인 주소
			if(domainList.value === "text"){
				domainListInput.readOnly = false;
			} else{
				/* domainList.value = ""; */
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
</script>
<script>
	$(document).ready(function(){
	    $('#checkbtn').click(function(event) {
	        event.preventDefault(); // 이벤트 기본 동작(페이지 이동 등)을 취소합니다.
	
	        // 여기에 추가적인 로직을 작성하거나 아무런 동작도 하지 않습니다.
	    });
	});
    function sample6_execDaumPostcode() {
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
                    document.getElementById("sample6_extraAddress").value = extraAddr;
                
                } else {
                    document.getElementById("sample6_extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample6_postcode').value = data.zonecode;
                document.getElementById("sample6_address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("sample6_detailAddress").focus();
            }
        }).open();
    }
</script>
<script>
	function emptyCheck(){
		
		var UName = document.Editform.UserName.value;
		
		var UIdCd1 = document.Editform.UserIdCard1.value;
		var UIdCd2 = document.Editform.UserIdCard2.value;
		
		var Id = document.Editform.UserId.value;
		
		var Pw1 = document.Editform.UserPw1.value;
		var Pw2 = document.Editform.UserPw2.value;
		
		var EmF = document.Editform.UserEm.value;
		var EmD = document.Editform.UserDom_txt.value;
		
		var Y = document.Editform.UserY.value;
		var M = document.Editform.UserM.value;
		var D = document.Editform.UserD.value;
		
		var ZipCd = document.Editform.ZipCd.value;
		var Addr = document.Editform.Addr.value;
		// var AddrRef = document.Editform.AddrRefer.value;
		var AddrDe = document.Editform.AddrDetail.value;
		
		var Gen = document.Editform.gender.value;
		
		var PH_f = document.Editform.Ph_F.value;
		var PH_m = document.Editform.Ph_M.value;
		var PH_e = document.Editform.Ph_E.value;
		
		var Be = document.Editform.Belong.value;
		
	    if (!UName || !UIdCd1 || !UIdCd2 || !Id || !Pw1 || !Pw2 || !EmF || !EmD || !Y || !M || !D || !ZipCd || !Addr || /* !AddrRef || */ !AddrDe || !Gen || !Be ||!PH_f || !PH_m || !PH_e) {
	        alert("모든 필수 항목을 입력해주세요.");
	        return false;
	    }else{
			if(UIdCd1.length !== 6 || UIdCd2.length !== 7){
				alert("주민등록번호를 정확하게 입력해주세요.")
				/* UIdCd1.focus(); */
				return false;
			}
			if(Pw1 !== Pw2){
				alert('비밀번호가 같지 않습니다.')
				/* Pw2.focus(); */
				return false;
			} else {
				let reg = /^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[~?!@#$%^&*_-]).{8,}$/
				if(!reg.test(Pw1)){
					alert('비밀번호는 소문자, 특수문자를 포함한 8자 이상을 입력해주세요.');
					/* Pw1.focus(); */
					return false;
				}
			}
			if(PH_m.length !== 4 || PH_e.length!== 4){
				alert('전화번호를 올바르게 입력하세요.');
				/* PH_m.focus(); */
				return false;
			}
			return true;
		}
	}
</script>
</head>
<body id="MyPEdit">
<%
	String UserId = (String)session.getAttribute("id");
	//String UserId = "76352491";
	LocalDateTime now = LocalDateTime.now();
	int Year = Integer.parseInt(now.format(DateTimeFormatter.ofPattern("yyyy")));
	
	String Esql = "SELECT * FROM membership WHERE Id = ?";	
	PreparedStatement Epstmt = conn.prepareStatement(Esql);
	Epstmt.setString(1, UserId);
	
	ResultSet Ers = Epstmt.executeQuery();
	
	String EName = null; // 사용자 이름
	String EId = UserId; // 사용자 아이디
	String EPw = null; //사용자 비밀번호
	

	String EIdF = null; // 주민등록번호 앞자리
	String EIdE = null; // 주민등록번호 뒷자리
	

	String EEF = null; // 이메일 앞부분
	String EES = null; // 이메일 뒷부분


	String YYYY = null; // 년
	String MM = null;; // 월
	String DD = null; // 일
	
	String EAddN = null; // 사용자 도로명주소
	String EAddF = null; // 사용자 집 주소
	String EAddrM = null; // 사용자 집 주소
	String EAddrE = null; // 사용자 집 주소
	
	//String EGender = null;
	String EGender = null; // 사용자 성별
	
	String Front = null;
	String Middle = null;
	String End = null;
	
	String EBlong = null;
	String EBlong_Des = null;
	
	
	if(Ers.next()){
		EName = Ers.getString("UserName"); // 사용자 이름
		EId = UserId; // 사용자 아이디
		EPw = Ers.getString("PW"); //사용자 비밀번호
		
		String[] Number = Ers.getString("IdCard").split("-"); // 사용자 주민등록번호
		EIdF = Number[0]; // 주민등록번호 앞자리
		EIdE = Number[1]; // 주민등록번호 뒷자리
		
		String[] IdAddr = Ers.getString("Email").split("@"); // 사용자 이메일
		EEF = IdAddr[0]; // 이메일 앞부분
		EES = IdAddr[1]; // 이메일 뒷부분
		
		String[] BirthDay = Ers.getString("Birth").split("-"); // 사용자 생일
		YYYY = BirthDay[0]; // 년
		MM = BirthDay[1]; // 월
		DD = BirthDay[2]; // 일
		
		String[] Address = Ers.getString("Address").split(",");
		EAddN = Ers.getString("AddressNumber");
		EAddF = Address[0]; // 사용자 집 주소
		EAddrM = Address[1]; // 사용자 집 주소
		//EAddrE = Address[2]; // 사용자 집 주소
		 
		EGender = Ers.getString("Gender"); // 사용자 성별
		
		String[] Phone = Ers.getString("Phone").split("-"); // 사용자 전화번호
		Front = Phone[0];
		Middle = Phone[1];
		End = Phone[2];
		
		EBlong = Ers.getString("Belong");
		String BeSQL = "";
		
	}
%>
<div class="testPart">
	<div class="headPart">
		<jsp:include page="../HeaderTest.jsp"></jsp:include>
	</div>
	<img class="logo_V1" id="logo_V1" name="Logo" src="${contextPath}/img/Logo.png" alt="">
	<div class=" container_V1">
			<div class="member-container">
				<form class="user-info" name="Editform" id="Editform" method="POST" onSubmit="return emptyCheck()" action="editedOk.jsp" enctype="UTF-8">
					<div class="Cate">Name</div>
						<input type="text" class="bottom-border" name="UserName" placeholder="Input Name" value='<%=EName%>' readonly>
					<div class="Cate">ID card</div>
						<input type="text" class="IDNum1" name="UserIdCard1" value='<%=EIdF%>' readonly>-<input type="password" class="IDNum2" name="UserIdCard2" value='<%=EIdE%>' readonly>
					<div class="Cate">Login-Id</div> 
						<div class="IdArea">
							<input type='text' class='InputId' name="UserId" placeholder="Input Id" value="<%=EId%>" readonly>
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
			          		<input type="text" class="Email" name="UserEm" placeholder="Email" value='<%=EEF%>'>@
				          		<input type="text" class="Domain_txt" name="UserDom_txt" id="UserDom_txt"  placeholder="Domain" value='<%=EES%>' readonly>
				          		<select class="Domain" name="UserDoM" id="UserDoM" value='<%=EES%>'>
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
			          			<option value='<%=YYYY%>'><%=YYYY%></option>
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
			          			<option value='<%=MM%>'><%=MM%></option>
			          			<%
			          				for(int i = 1 ; i < 13 ; i++){
			          			%>
			          			<option value=<%= i %>><%=i %></option>
			          			<%
			          				}
			          			%>
			          		</select>
			          		월
			          		<script type="text/javascript">
			          		$(document).ready(function(){
			          		    $('#UserM').change(function(){
			          		        var selectedMonth = parseInt($(this).val());
			          		        var selectedYear = parseInt($('.Year').val());
			          		        var daysInMonth = new Date(selectedYear, selectedMonth, 0).getDate();

			          		        $('#UserD').empty();
			          		      $('#UserD').append('<option value="' + '<%=DD%>' + '">' + '<%=DD%>' + '</option>');
			          		        for(var i = 1; i <= daysInMonth; i++) {
			          		            $('#UserD').append('<option value="' + i + '">' + i + '</option>');
			          		        }
			          		    });

			          		    $('.Year').change(function(){
			          		        $('#UserM').trigger('change');
			          		    });

			          		    $('#UserM').trigger('change');
			          		});
							</script>
			          		
			          		<select class="Date" name="UserD" id="UserD">
			          			<option value='<%=DD%>'><%=DD%></option>
			          		</select>
			          		일
						</div>
		
		          	<div class="Cate">Address</div>
						
						<input type="text" class="AddrCode" id="sample6_postcode" name="ZipCd" placeholder="우편번호" value='<%=EAddN%>'>
						<input type="button" class="AddrCodeBtn" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
						
						<input type="text" class="bottom-border" name="Addr" id="sample6_address" placeholder="주소" value='<%=EAddF%>'><br>	
						<input type="text" class="bottom-border" name="AddrDetail" id="sample6_detailAddress" placeholder="상세주소" value='<%=EAddrM%>'>
						<input type="text" class="bottom-border" name="AddrRefer" id="sample6_extraAddress" placeholder="참고항목" hidden>
						
		          	<div class="Cate">Gender</div>
		          	<%
		          		if(EGender.equals("male")){
		          	%>
						<input type="radio" name="gender" value="male" checked/>남성
						<input type="radio" name="gender" value="female" />여성
					<%
		          		} else{
					%>
						<input type="radio" name="gender" value="male" />남성
						<input type="radio" name="gender" value="female" checked/>여성
					<%
		          		}
					%>
		        	<div class="Cate">Phone Number</div>
		        	<select  class="PH_front" name="Ph_F">
		        		<option value='<%=Front%>'><%=Front%></option>
		        		<% 
		        			String[] PnFront = {"010","011","016","017","019"};
		        			for(String prefix : PnFront){
		        		%>
		        			<option value=<%= prefix%>><%= prefix%></option>
		        		<%
		        			}
		        		%>
		        	</select>
		        	-<input type="text" class="PH_middle" name="Ph_M" value='<%=Middle%>'>-<input type="text" class="PH_end" name="Ph_E" value='<%=End%>'>
		        <div class="Cate">소속</div>
		        	<select class="ComSelect" name="Belong">
		        		<option value='<%=EBlong%>'><%=EBlong%></option>
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
		        	
			        <div class="btn">
						<button  type="submit" class="RegistBtn">가입하기</button>
			        </div>
		       	</form>
	      </div>
    </div>
</div>

</body>
</html>
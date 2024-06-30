<%@page import="java.sql.SQLException"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		
	    if (!UName || !UIdCd1 || !UIdCd2 || !Id || !Pw1 || !Pw2 || !EmF || !EmD || !Y || !M || !D || !ZipCd || !Addr || !AddrRef || !Gen || !Be ||!PH_f || !PH_m || !PH_e) {
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
<body class="RegistArea">
	<%
	LocalDateTime now = LocalDateTime.now();
	int Year = Integer.parseInt(now.format(DateTimeFormatter.ofPattern("yyyy")));
	
	String UserNumber = request.getParameter("Number");
	String Qsql = "SELECT * FROM emp WHERE EMPLOYEE_ID = ?";
	PreparedStatement Qpstmt = conn.prepareStatement(Qsql);
	Qpstmt.setString(1, UserNumber);
	
	ResultSet Qrs = Qpstmt.executeQuery();
	
	String id = null; // 사원 코드
	String name = null; // 사원 이름
	
	String JuminiF = null; // 사원 주민 번호 앞
	String JuminiE = null; // 사원 주민 번호 뒷
	
	String BirYYYY = null; // 사원 생년
	String BirMM = null; // 사원 생월
	String BirDD = null; // 사원 생일
	
	String Belong = null; // 사원 소속 회사 코드
	String BelongDes = null; // 사원 소속 회사이름
	
	String PostCode = null; // 사원 우편번호
	
	String Addr = null; // 사원 주소
	String AddrDetail = null; // 사원 상세 주소
	
	if(Qrs.next()){
		id = UserNumber;
		name = Qrs.getString("EMPLOYEE_NAME");
		
		JuminiF = Qrs.getString("Jumin_1st");
		JuminiE = Qrs.getString("Jumin_2nd");
		
		String[] BirthDay = Qrs.getString("Birth").split("-");
		BirYYYY = BirthDay[0];
		BirMM = BirthDay[1];
		BirDD = BirthDay[2];
		
		PostCode = Qrs.getString("POST_ID");
		
		String[] Address = Qrs.getString("EMPLOYEE_ADDR").split(",");
		Addr = Address[0].trim();
		AddrDetail = Address[1].trim();
		
		Belong = Qrs.getString("COMCODE");
		BelongDes = Qrs.getString("COMCODE_DES");
	}
	%>
<div class="container">
	<div class="member-container">
		<form class="user-info" name="Registform" id="Registform" method="POST" onSubmit="return emptyCheck()" action="registOk.jsp" enctype="UTF-8">		
			<div class="Cate">Name</div>
				<input type="text" class="bottom-border" name="UserName" value="<%=name %>" placeholder="Input Name">
			<div class="Cate">ID card</div>
				<input type="text" class="IDNum1" name="UserIdCard1" value="<%=JuminiF%>">-<input type="password" class="IDNum2" name="UserIdCard2" value="<%=JuminiE%>">
			<div class="Cate">Login-Id</div> 
				<div class="IdArea">
					<input type='text' class='InputId' name="UserId" placeholder="Input Id" value="<%=id%>">
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
	          			<option value='<%=BirYYYY%>'><%=BirYYYY%></option>
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
	          			<option value='<%=BirMM%>'><%=BirMM%></option>
	          			<%
	          				for(int i = 1 ; i < 13 ; i++){
	          			%>
	          			<option value=<%=i %>><%=i %></option>
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
	          		      $('#UserD').append('<option value="' + '<%=BirDD%>' + '">' + '<%=BirDD%>' + '</option>');
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
	          			<option value='<%=BirDD%>'><%=BirDD%></option>
	          		</select>
	          		일
				</div>

          	<div class="Cate">Address</div>
				
				<input type="text" class="AddrCode" id="sample6_postcode" name="ZipCd" placeholder="우편번호" value=<%=PostCode %>>
				<input type="button" class="AddrCodeBtn" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
				<input type="text" class="bottom-border" name="Addr" id="sample6_address" placeholder="주소" value="<%=Addr %>"><br>
				<input type="text" class="bottom-border" name="AddrRefer" id="sample6_extraAddress" placeholder="참고항목" value="<%=AddrDetail %>">	
				<input type="text" class="bottom-border" name="AddrDetail" id="sample6_detailAddress" placeholder="상세주소" hidden>
				
          	<div class="Cate">Gender</div>
          	<%
          	if(JuminiE.charAt(0) % 2 == 0){
			/* %가 나머지, /(슬래쉬)는 몫 */
          	%>
				<input type="radio" name="gender" value="male" />남성
				<input type="radio" name="gender" value="female" checked/>여성
			<%
          	} else{
			%>
				<input type="radio" name="gender" value="male" checked/>남성
				<input type="radio" name="gender" value="female" />여성
			<%
          	}
			%>
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
        		<option value="<%=Belong%>">(<%=Belong %>)<%=BelongDes%></option>
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
</body>
</html>
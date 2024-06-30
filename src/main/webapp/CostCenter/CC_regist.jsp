<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="javax.swing.text.DateFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<%
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String formattedToday = today.format(formatter);
%>
<link rel="stylesheet" href="../css/style.css?after">
<title>Cost Center 등록</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script type='text/javascript'>
	$(document).ready(function() {
	    var start_date = new Date("<%=formattedToday%>");
	    var end_date = new Date(start_date.getTime());
	    end_date.setFullYear(end_date.getFullYear() + 10);
	    $(".date01").val(formatDate(start_date));
	});
	
	function formatDate(date) {
	    var dd = String(date.getDate()).padStart(2, '0');
	    var mm = String(date.getMonth() + 1).padStart(2, '0'); //January is 0!
	    var yyyy = date.getFullYear();
	
	   return yyyy + '-' + mm + '-' + dd;
	}
	
	function CompanyCode(d){
		var v = d.value;
		document.CC_Registform.Com_Des.value = v;
	}
	function CCTapply(d){
		var v = d.value;
		document.CC_Registform.CCT_Des.value = v;
	}
	function ComSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/ComSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function BusiAreaSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var CompanyCode = document.querySelector('.Com-code').value;
	    
	    window.open("${contextPath}/Information/BizAreaSearch.jsp?ComCode=" + CompanyCode, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function MoneySearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/MoneySearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function LanSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/LanSearch.jsp", "테스트", "width=505,height=550, left=500 ,top=" + yPos);
	}
	function CCGSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var CompanyCode = document.querySelector('.Com-code').value;
	    
	    window.open("${contextPath}/Information/CCGSearch.jsp?ComCode=" + CompanyCode, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function CCTSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var CompanyCode = document.querySelector('.Com-code').value;
	    
	    window.open("${contextPath}/Information/CCTSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
</script>

<body>
	<h1>Cost Center 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="CC_Registform" name="CC_Registform" action="CC_regist_Ok.jsp" method="post" enctype="UTF-8">
			<div class="cc-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Cost Center Code : </th>
							<td class="input-info">
								<input type="text" name="cost_code" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" name="Des" size="41">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="cc-sub-info">
					<div class="table-container">
						<table>
							<tr><th class="info">Company Code : </th>
								<td class="input-info">
									<div class="test">
									<a href="javascript:ComSearch()"><input type="text" class="Com-code" name="Com-Code" placeholder="SELECT" onchange="CompanyCode(this)" readonly></a>
										<input type="text" name="Com_Des" size="31" readonly>	
									</div>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info"> Biz.Area Code : </th>
								<td class="input-info">
									<a href="javascript:BusiAreaSearch()"><input type="text" class="Biz_Code" name="Biz_Code" placeholder="SELECT" readonly></a>
									<input type="text" class="Biz_Code_Des" name="Biz_Code_Des" size="31" readonly>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Postal Code : </th>
								<td class="input-info">
									<input type="text" name="PoCd" size="4">
								</td>	
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Address 1 : </th>
								<td class="input-info">
									<input type="text" name="addr1"size="41">
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Address 2 : </th>
								<td class="input-info">
									<input type="text" name="addr2" size="41">
								</td>
							</tr>	
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Local Currency : </th>
								<td class="input-info">
									<a href="javascript:MoneySearch()"><input type="text" class="money-code" name="money" readonly></a>
								</td>
								<th class="info">Language : </th>
									<td class="input-info">
										<a href="javascript:LanSearch()"><input type="text" class="language-code" name="lang" readonly></a>
									</td>
							</tr>		
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">유효기간 : </th>
								<td class="input-info">
									<input type="date" class='date01' name='start_date'>
									<!-- <select class='date01' name='start_date'>
									</select> --> ~ 
									<!-- <select class='date02' name='end_date'>
									</select> -->
									<input type="date" class='date02' name='end_date'>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Cost Center Group : </th>
								<td class="input-info">
									<a href="javascript:CCGSearch()"><input type="text" class="ccc" name="ccc" placeholder="SELECT" readonly></a>
									<!-- <select class="ccc" name="ccc">
										<option value="Nope">Select</option>
									</select> -->
									<input type="text" class="CCG_Des" name="CCG_Des" size="31" readonly>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Cost Center Type : </th>
								<td class="input-info">
									<a href="javascript:CCTSearch()"><input type="text" class="cct" name="cct" onchange="CCTapply(this)" placeholder="SELECT" readonly></a>
									<input type="text" class="CCT_Des" name="CCT_Des" size="31" readonly>
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">Responsibility Person : </th>
								<td class="input-info">
									<select class="rp" name="rp">
										<option value="Nope">Select</option>
									</select>
									<input type="text" name="RPescon_Dese" size="31">
								</td>
							</tr>
							
							<tr class="spacer-row"></tr>
							
							<tr><th class="info">사용 여부: </th>
								<td class="input_info">
										<input type="radio" class="InputUse" name="Use-Useless" value="true" checked>사용
										<span class="spacing"></span>
										<input type="radio" class="InputUse" name="Use-Useless" value="false">미사용								
									</select>
								</td>
							</tr>																																
						</table>
					</div>
			</div>
		</form>
	</center>
</body>
</html>
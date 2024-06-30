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
<%
	LocalDateTime today = LocalDateTime.now();
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	String formattedToday = today.format(formatter);
%>
<title>Plant 등록</title>
<link rel="stylesheet" href="../css/style.css?after">
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script> 
<script type='text/javascript'>
	document.addEventListener("DOMContentLoaded", function() {
	    var now_utc = Date.now();
	    var timeOff = new Date().getTimezoneOffset() * 60000;
	    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
	    var testElement = document.getElementById("today");
	
	    if (testElement) {
	        testElement.setAttribute("min", today);
	        testElement.setAttribute("max", today);
	    } else {
	        console.error("Element with id 'today' not found.");
	    }
	});
	document.addEventListener("DOMContentLoaded", function() {
	    var now_utc = Date.now();
	    var timeOff = new Date().getTimezoneOffset() * 60000;
	    var today = new Date(now_utc - timeOff).toISOString().split("T")[0];
	    var testElement = document.getElementById("future");
	
	    if (testElement) {
	        testElement.setAttribute("min", today);
	    } else {
	        console.error("Element with id 'test' not found.");
	    }
	});
	function CompanyCode(d){
		var v = d.value;
		document.plant_RegistForm.Com_Des.value = v;
	}
	function ComSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
    window.open("${contextPath}/Information/ComSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function BizACSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    var code = document.querySelector('.Com-code').value;
	    
    window.open("${contextPath}/Information/BizAreaCSearch.jsp?ComCode=" + code, "테스트", "width=600,height=495, left=500 ,top=" + yPos);
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
</script>
<body>
	<h1>Plant 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="plant_RegistForm" name="plant_RegistForm" action="plant_regist_Ok.jsp" method="post" ecntype="UTF-8">
			<div class="plant-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Plant Code : </th>
							<td class="input-info">
								<input typr="text" name="plant_code" size="10">
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
					
			<div class="plant-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input-info">
								<a href="javascript:ComSearch()"><input type="text" class="Com-code" name="ComCode" onchange="CompanyCode(this)" placeholder="SELECT" readonly></a>
								<%-- <select class="ComCode" name="ComCode" onchange="CompanyCode(this)">
									<option value="NOPE">SELECT</option>
									<%
										try{
											PreparedStatement pstmt = null;
											ResultSet rs = null;
											
											String sql = "SELECT Com_Cd FROM company";
											pstmt = conn.prepareStatement(sql);
											
											rs = pstmt.executeQuery();
											
											while(rs.next()){
												String ComCode = rs.getString("Com_Cd");
											%>
												<option value="<%=ComCode%>"><%=ComCode%></option>
											<%
											}
										}catch(Exception e){
											e.printStackTrace();
										}
									%>
								</select> --%>
								<input type="text" class="Com_Des" name="Com_Des" size="31" readonly >
							</td>
						</tr>
						
						
						<!-- <script type="text/javascript">
							$(document).ready(function(){
								$('.ComCode').change(function(){
									var CompanyCode = $(this).val();
									console.log('CompanyCode : ' + CompanyCode);
									$.ajax({
										type : 'post',
										url : 'biz-find.jsp',
										data : {ComCode : CompanyCode},
										datatype : 'json',
										success : function(response){
											var bizoption = '';
											try{
												for(var i = 0 ; i < response.BIZ.length ; i++){
													bizoption += '<option value="'+response.BIZ[i]+'">'+response.BIZ[i] + '</option>';
												}
												
												$('.BizSelect').html(bizoption);
												$('select[name="BizSelect"]').change(function() {
							                         var selectedOption = $(this).children("option:selected");
							                         $('input[name="Biz_Des"]').val(selectedOption.val()); // 수정된 부분
							                     });
												$('#BizSelect').prop('selectedIndex', 0).change();
												
												var firstBizOption = response.BIZ[0];
						                        $('input[name="Biz_Des"]').val(firstBizOption);
											} catch(error){
												console.error("JSON 파싱 중 오류 발생:", error, response);
											}
										}, 
										error : function(xhr, status, error) {
							                console.error("AJAX 요청 중 오류 발생:", error);
							            }
									});
								});
							});
						</script> -->
						
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Biz.Area Code : </th>
							<td class="input-info">
								<a href="javascript:BizACSearch()"><input type="text" class="BizSelect" name="BizSelect" placeholder="SELECT" readonly></a>
								<!-- <select class="BizSelect" name="BizSelect">
									<option value="NOPE">SELECT</option>
								</select> -->
								<input type="text" class="Biz_Des" name="Biz_Des" size="31" readonly>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Postal Code</th>
							<td class="input-info">
								<input type="text" name="PosCode" size="4">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Address 1</th>
							<td class="input-info">
								<input type="text" name="PlantAddr1" size="41">
							</td>
						</tr>	
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Address 2</th>
							<td class="input-info">
								<input type="text" name="PlantAddr2" size="41">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Local Currency : </th>
							<td class="input-info">
								<a href="javascript:MoneySearch()"><input type="text" class="money-code" name="money" placeholder="SELECT" readonly></a>
								<%-- <select class="LocalCurr" name="LocalCurr">
									<option value="NOPE">SELECT</option>
									<%
									try{
										PreparedStatement pstmt = null;
										ResultSet rs = null;
										String sql = "SELECT * FROM nation ORDER BY id ASC";
										pstmt = conn.prepareStatement(sql);
										rs = pstmt.executeQuery();
										while(rs.next()){
											String Code = rs.getString("Code");
									%>
										<option value="<%=Code%>"><%=Code%></option>
									<%
										}
									}catch(Exception e){
										e.printStackTrace();
									}
									%>
								</select> --%>
							</td>
							<th class="info">Language</th>
								<td class="input-info">
									<a href="javascript:LanSearch()"><input type="text" class="language-code" name="lang" placeholder="SELECT" readonly></a>
									<%-- <select class="LangSelect" name="LangSelect">
										<option value="NOPE">SELECT</option>
										<%
										try{
											PreparedStatement pstmt = null;
											ResultSet rs = null;
											String sql = "SELECT * FROM language ORDER BY id ASC";
											pstmt = conn.prepareStatement(sql);
											rs = pstmt.executeQuery();
											
											while(rs.next()){
												String KOR = rs.getString("KRname");
												String ENG = rs.getString("ENGname");
										%>
											<option value="<%=KOR%>"><%=ENG%></option>
										<%
											}
										}catch(Exception e){
											e.printStackTrace();
										}
										%>
									</select> --%>
								</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">유효기간 : </th>
							<td class="input-info">
								<input type="date" class="today" id="today" name="today">
								~
								<input type="date" class="future" id="future" name="future">
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
<title>Company 등록</title>
<script>
	function NationSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/NationSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function MoneySearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/MoneySearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	function LanSearch(){
	    var xPos = (window.screen.width-2560) / 2;
	    var yPos = (window.screen.height-1440) / 2;
	    
	    window.open("${contextPath}/Information/LanSearch.jsp", "테스트", "width=600,height=495, left=500 ,top=" + yPos);
	}
	
	function comfirm(){
		var cocd = document.Com_registform.Com_code.value;
		var Des = document.Com_registform.Des.value;
		
		var NaCode = document.Com_registform.NationCode.value;
		var NaName = document.Com_registform.NationName_input.value;
		
		var PtCd = document.Com_registform.PtCd.value;
		
		var Addr01 = document.Com_registform.Addr01.value;
		var Addr02 = document.Com_registform.Addr02.value;
		
		var money = document.Com_registform.money.value;
		var lang = document.Com_registform.lang.value;
		
		var BA_use = document.Com_registform.BA_use.value;
		var TA_use = document.Com_registform.TA_use.value;
		var TB_use = document.Com_registform.TB_use.value;
		var FSRL = document.Com_registform.FSRL.value;
	    
	    if(!cocd || !Des || !NaCode || !NaName || !PtCd || !Addr01 || !Addr02 || !money || !lang || !BA_use || !TA_use || !TB_use || !FSRL){
	    	alert('모든 항목을 입력해주세요.');
	    	return false;
	    } else{
	    	return true;
	    }
	}
</script>
<script type="text/javascript">
	function Search(){
	    var windowWidth = 900;
	    var windowHeight = 300;
	    var xPos = (window.innerWidth - windowWidth) / 2;
	    var yPos = (window.innerHeight - windowHeight) / 2;
		window.open("Company_Search.jsp","테스트","width=900,height=300,left="+xPos+",top="+yPos)
	}
</script>
</head>
<body>
	<h1>Company 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="Com_registform" name="Com_registform" action="Company_Regist_Ok.jsp" method="post" onSubmit="return comfirm()" enctype="UTF-8">
			<div class="main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input_info">
								<input type="text" name="Com_code" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input_info">
								<input type="text" name="Des" size="41">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Input">	
			<a href="javascript:Search()" class="search-link"><p>Search</p></a>
			
			<div class="sub-info">
			<div class="table-container">
				<table>
					<tr><th class="info">Nationality : </th>
						<td class="input_info">
							<a href="javascript:NationSearch()"><input type="text" id="NationCode" name="NationCode" readonly></a>	
							<input type="text" id="NationDes" name="NationName_input" readonly>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Postal Code : </th>
						<td class="input_info">
							<input type="text" name="PtCd" size="10">
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Address 1 : </th>
						<td class="input_info">
							<input type="text" name="Addr01" size="41">
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>

					<tr><th class="info">Address 2 : </th>
						<td class="input_info">
							<input type="text" name="Addr02" size="41">
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Local Currency : </th>
						<td class="input_info">
							<a href="javascript:MoneySearch()"><input type="text" class="money-code" name="money" readonly></a>
						</td>
						
						<th class="info">Language : </th>
							<td class="input_info">
								<a href="javascript:LanSearch()"><input type="text" class="language-code" name="lang" readonly></a>
							</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Business Area 사용 : </th>
						<td class="input_info">
							<select class="yn" name="BA_use" id="BA_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>	
					
					<tr><th class="info">Tax Area 사용 : </th>
						<td class="input_info">
							<select class="yn" name="TA_use" id="TA_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">TaxArea vs BizArea : </th>
						<td class="input_info">
							<select class="yn" name="TB_use" id="TB_use">
								<option value="true">Yes</option>
								<option value="false">No</option>
							</select>
						</td>
					</tr>	
					
					<tr class="spacer-row"></tr>
					
					<tr><th class="info">Financial Statement Reporting Level : </th>
						<td class="input_info">
							<select name="FSRL" id="FSRL">
								<option value="1">1(Company)</option>
								<option value="2">2(Biz Area)</option>
								<option value="3">3(Tax Area)</option>
							</select>
						</td>
					</tr>	
				</table>
			</div><!-- table-container -->																								
			</div><!-- sub-info -->
		</form>
	</center>
</body>
</html>
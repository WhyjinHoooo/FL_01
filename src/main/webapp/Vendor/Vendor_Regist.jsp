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
<title>Vendor Master 등록</title>
<script type='text/javascript'>
function NationSearch(){
	var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;

	window.open("${contextPath}/Information/NationSearch.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);	
}
function ComSearch(){
	var xPos = (window.screen.width-2560) / 2;
    var yPos = (window.screen.height-1440) / 2;

	window.open("${contextPath}/Information/ComSearch.jsp", "테스트", "width=500,height=500, left=500 ,top=" + yPos);	
}
</script>
</head>
<body>
	<h1>Vendor Master 등록</h1>
	<hr>
	<jsp:include page="../HeaderTest.jsp"></jsp:include>
	<center>
		<form id="vendorRegistform" name="vendorRegistform" method="post" action="Vendor_Regist_Ok.jsp" enctype="UTF-8">
			<div class="ven-main-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Company Code : </th>
							<td class="input-info">
								<a href="javascript:ComSearch()"><input type="text" name="ComCode" class="Com-code" size="10" readonly></a>
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Vendor Code : </th>
							<td class="input-info">
								<input type="text" name="vendorInput" class="vendorInput" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Description : </th>
							<td class="input-info">
								<input type="text" name="vendorDes" class="vendorDes" size="60">
							</td>
						</tr>
					</table>
				</div>
			</div>
			
			<input class="Info-input-btn" id="btn" type="submit" value="Insert">
			
			<div class="ven-sub-info">
				<div class="table-container">
					<table>
						<tr><th class="info">Nationality : </th>
							<td class="input-info">
								<a href="javascript:NationSearch()"><input type="text" name="NationCode" class="NationCode" size="10" readonly></a>
								<input type="text" name="NationDes" class="NationDes" size="41">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Postal Code : </th>
							<td class="input-info">
								<input type="text" name="PostalCode" class="PostalCode" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Address 1 : </th>
							<td class="input-info">
								<input type="text" name="Addr1" class="Addr1" size="57">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">Address 2 : </th>
							<td class="input-info">
								<input type="text" name="Addr2" class="Addr2" size="57">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">대표 전화번호 : </th>
							<td class="input-info">
								<input type="text" name="RepPhone" class="RepPhone" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">대표자 성명 : </th>
							<td class="input-info">
								<input type="text" name="RepName" class="RepName" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">거래 구분 : </th>
							<td class="input-info">
								<input type="radio" name="Deal" class="Deal1" value="true" checked>매입
								<input type="radio" name="Deal" class="Deal2" value="false">매출
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">사업자 번호 : </th>
							<td class="input-info">
								<input type="text" name="PhoneNum" class="PhoneNum" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">업태코드 : </th>
							<td class="input-info">
								<input type="text" name="UptaCode" class="UptaCode" size="10">
							</td>
						</tr>
						
						<tr class="spacer-row"></tr>
						
						<tr><th class="info">업종코드 : </th>
							<td class="input-info">
								<input type="text" name="BusinessCode" class="BusinessCode" size="10">
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
	</center>
</body>
</html>
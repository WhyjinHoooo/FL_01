<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/USTcss.css?after">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<script>
	$(document).ready(function() {
	    $('#SearcjBtn').click(function() {
	        var LF_Info = $('.Info_LF').val();
	        var CoCtCate = $('.CoCtCategory').val();
	        console.log("확인용01 : " + LF_Info);
	        console.log("확인용02 : " + CoCtCate);
	        $.ajax({
	            url: '${contextPath}/UnapprovalSlip/InfoSearch/AjaxInfo/CoCtAjax.jsp',
	            type: 'POST',
	            data: { LF_Information: LF_Info, CoCt_Category : CoCtCate },
	            success: function(response) {
	                $('.SearchedTable tbody').html(response);
	            }
	        });
	    });
	    
	    $('.Info_LF').keydown(function(e){
	    	if(e.which == 13){
	    		$('#SearcjBtn').trigger("click");
	    		return false;
	    	} /* else if(e.which == 8){
	    		$('#Reset').trigger("click");
	    	} */
	    });
	    
	    $('nav a').click(function() {
	        var startChar = $(this).text();
	        $.ajax({
	            url: '${contextPath}/UnapprovalSlip/InfoSearch/AjaxInfo/DeptSearch.jsp',
	            type: 'GET',
	            data: { startChar: startChar },
	            success: function(response) {
	                $('.SearchedTable tbody').html(response);
	            }
	        });
	    });
	});
</script>
<body>
<h1>BizArea 검색</h1>
<hr>
<nav class="CoCtNav" style="background-color: #002060;margin-bottom: 9px;">
	<a href="#">A</a>
	<a href="#">B</a>
	<a href="#">C</a>
</nav>
	<center>
		<div>
			<select class="CoCtCategory">
				<option value="Code">COCT Code</option>
				<option value="Name">COCT Name</option>
			</select>
			<input type="text" class="Info_LF" placeholder="검색"> <!-- Information Look For -->
			<button id="SearcjBtn" onkeyup="enterKey()">검색</button>
			<button id="ResetBtn" onClick="window.location.reload()">초기화</button>
		</div>
		<div class="InfoSearchBoard">
			<table class="SearchedTable">
				<thead>
					<tr>
						<th>COCT</th><th>COCT Name</th>
					</tr>
				</thead>
				<tbody>
					<%
						try{
							String ComCode = request.getParameter("Comcode");
						
							String sql = "SELECT * FROM dept";
							PreparedStatement pstmt = null;
							ResultSet rs = null;
							pstmt = conn.prepareStatement(sql);
							rs = pstmt.executeQuery();
							
							while(rs.next()){
					%>
					<tr>
						<td>
							<a href="javascript:void(0)"
								onClick="
									var CoCtCode = '<%=rs.getString("COCT") %>';
									var CpCtCode_Des = '<%=rs.getString("COCT_NAME") %>';
									window.opener.document.querySelector('.UserDepartCd').value=CoCtCode;
									window.opener.document.querySelector('.UserDepartCd_Des').value=CpCtCode_Des;
									window.opener.document.querySelector('.UserDepartCd').dispatchEvent(new Event('change'));
									window.close();
							">
							<%=rs.getString("COCT")%>
							</a>
						</td>
						<td><%=rs.getString("COCT_NAME") %></td>
					</tr>
					<%
							}
						}catch(SQLException e){
							e.printStackTrace();
						}
					%>
				</tbody>
			</table>
		</div>
	</center>
</body>
</html>
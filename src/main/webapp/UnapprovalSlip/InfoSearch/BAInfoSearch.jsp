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
	        var BizCate = $('.BizCategory').val();
	        console.log("확인용01 : " + LF_Info);
	        console.log("확인용02 : " + BizCate);
	        $.ajax({
	            url: '${contextPath}/UnapprovalSlip/InfoSearch/AjaxInfo/BizAjax.jsp',
	            type: 'POST',
	            data: { LF_Information: LF_Info, Biz_Category : BizCate },
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
	});
</script>
<body>
<h1>BizArea 검색</h1>
<hr>
	<center>
		<div>
			<select class="BizCategory">
				<option value="Code">BizArea Code</option>
				<option value="Name">BizArea Name</option>
			</select>
			<input type="text" class="Info_LF" placeholder="검색"> <!-- Information Look For -->
			<button id="SearcjBtn" onkeyup="enterKey()">검색</button>
			<button id="ResetBtn" onClick="window.location.reload()">초기화</button>
		</div>
		<div class="InfoSearchBoard">
			<table class="SearchedTable">
				<thead>
					<tr>
						<th>BizArea</th><th>BizArea Name</th>
					</tr>
				</thead>
				<tbody>
					<%
						try{
							String ComCode = request.getParameter("Comcode");
						
							String sql = "SELECT * FROM bizarea WHERE Com_Code = ?";
							PreparedStatement pstmt = null;
							ResultSet rs = null;
							pstmt = conn.prepareStatement(sql);
							pstmt.setString(1, ComCode);
							rs = pstmt.executeQuery();
							
							while(rs.next()){
					%>
					<tr>
						<td>
							<a href="javascript:void(0)"
								onClick="
									var BizCode = '<%=rs.getString("BIZ_AREA") %>';
									var BizCode_Des = '<%=rs.getString("BA_Name") %>';
									window.opener.document.querySelector('.UserBizArea').value=BizCode;
									window.opener.document.querySelector('.UserBizArea_Des').value=BizCode_Des;
									window.opener.document.querySelector('.UserBizArea').dispatchEvent(new Event('change'));
									window.close();
							">
							<%=rs.getString("BIZ_AREA")%>
							</a>
						</td>
						<td><%=rs.getString("BA_Name") %></td>
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
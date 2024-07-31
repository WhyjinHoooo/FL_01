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
	        var USerCate = $('.UserCategory').val();
	        console.log("확인용01 : " + LF_Info);
	        console.log("확인용02 : " + USerCate);
	        $.ajax({
	            url: '${contextPath}/UnapprovalSlip/InfoSearch/AjaxInfo/ApproverAjax.jsp',
	            type: 'POST',
	            data: { LF_Information: LF_Info, USer_Category : USerCate },
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
<h1>전표 입력자 검색</h1>
<hr>
	<center>
		<div>
			<select class="UserCategory">
				<option value="Name">이름</option>
			</select>
			<input type="text" class="Info_LF" placeholder="검색"> <!-- Information Look For -->
			<button id="SearcjBtn" onkeyup="enterKey()">검색</button>
			<button id="ResetBtn" onClick="window.location.reload()">초기화</button>
		</div>
		<div class="InfoSearchBoard">
			<table class="SearchedTable">
				<thead>
					<tr>
						<th>사원 코드</th><th>사원 이름</th><th>부서 코드</th><th>부서 이름</th><th>사원 직급</th>
					</tr>
				</thead>
				<tbody>
					<%
						try{
							String ComCode = request.getParameter("Comcode");
						
							String sql = "SELECT * FROM emp WHERE COMCODE = ?";
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
									var UserCode = '<%=rs.getString("EMPLOYEE_ID") %>';
									var UserCode_Des = '<%=rs.getString("EMPLOYEE_NAME") %>';
									window.opener.document.querySelector('.ApproverId').value=UserCode;
									window.opener.document.querySelector('.Approver_Name').value=UserCode_Des;
									window.opener.document.querySelector('.ApproverId').dispatchEvent(new Event('change'));
									window.close();
							">
							<%=rs.getString("EMPLOYEE_ID")%>
							</a>
						</td>
						<td><%=rs.getString("EMPLOYEE_NAME") %></td>
						<td><%=rs.getString("COCT") %></td>
						<td><%=rs.getString("COCT_DES") %></td>
						<td><%=rs.getString("POSITION") %></td>
						
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
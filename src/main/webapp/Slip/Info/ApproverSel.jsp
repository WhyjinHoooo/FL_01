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
<link rel="stylesheet" href="../../css/forSlip.css?after">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>Insert title here</title>
</head>
<script>
    $(document).ready(function() {
        $('#searchButton').click(function() {
            var QAccSubject = $('#AccSubjectInput').val();
            var AccCate = $('.AccCategory').val();
            console.log("확인용 : " + AccCate);
            $.ajax({
                url: 'SearchUser.jsp',
                type: 'POST',
                data: { QAccSubject: QAccSubject, AccCate : AccCate },
                success: function(response) {
                    $('#resultTable tbody').html(response);
                }
            });
        });
        
        $('#AccSubjectInput').keydown(function(e){
        	if(e.which == 13){
        		$('#searchButton').trigger("click");
        		return false;
        	} /* else if(e.which == 8){
        		$('#Reset').trigger("click");
        	} */
        });
    });
</script>
<body>
    <center>
	<div class="MoneyHeader">
		<select class="AccCategory">
			<option value="UserCode">결재/합의자 사번</option>
			<option value="UserName">성명</option>
			<option value="UserRank">직급</option>
			<option value="UserCoct">부서코드</option>
			<option value="UserCoCtDes">부서명</option>
		</select>
		<input type="text" id="AccSubjectInput" placeholder="입력">
		<button id="searchButton" onkeyup="enterkey()">검색</button>
		<button id="Reset" onClick="window.location.reload()">초기화</button>
	</div>
	<div class="ComSearch-board">
	     <table id="resultTable">
	     	<thead>
		        <tr>
		            <th>사번</th><th>성명</th><th>직급</th><th>부서코드</th><th>부서명</th>
		        </tr>
	        </thead>
	        <tbody>
		<%
	        try{
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        String sql = "SELECT * FROM emp";
	        
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	   		
	        while(rs.next()){
		%>
			<tr>
				<td>
				    <a href="javascript:void(0)" 
				       onClick="
							var UserCode = '<%= rs.getString("EMPLOYEE_ID") %>';
							var UserName = '<%= rs.getString("EMPLOYEE_NAME") %>';
							var UserRank = '<%= rs.getString("POSITION") %>';
							var UserCoCt = '<%= rs.getString("COCT") %>';
							var UserCoCtDes = '<%= rs.getString("COCT_DES") %>';
				           
							window.opener.document.querySelector('#ApproverCode_${param.rowNum}').value = UserCode; // 행 번호 사용
							window.opener.document.querySelector('#AppName_${param.rowNum}').value = UserName; // 행 번호 사용
							window.opener.document.querySelector('#AppRank_${param.rowNum}').value = UserRank; // 행 번호 사용
							window.opener.document.querySelector('#AppCoCt_${param.rowNum}').value = UserCoCt; // 행 번호 사용
							window.opener.document.querySelector('#AppCoCtName_${param.rowNum}').value = UserCoCtDes; // 행 번호 사용
							window.opener.document.querySelector('#ApproverCode_${param.rowNum}').dispatchEvent(new Event('change')); // 행 번호 사용
							window.close();
				       ">
				       <%-- ${param.rowNum}은 JSP의 EL(Expression Language)을 사용하여 request.getParameter("rowNum") 값을 가져오는 것과 동일한 기능을 합니다. --%>
				       <%= rs.getString("EMPLOYEE_ID") %>
				    </a>
				</td>
				<td><%=rs.getString("EMPLOYEE_NAME") %></td>
				<td><%=rs.getString("POSITION") %></td>
				<td><%=rs.getString("COCT") %></td>
				<td><%=rs.getString("COCT_DES") %></td>
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
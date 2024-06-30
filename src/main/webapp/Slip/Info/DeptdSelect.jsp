<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/forSlip.css?after">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<script>
    $(document).ready(function() {
        $('#searchButton').click(function() {
            var Deptd = $('#DeptdSearchInput').val();
            $.ajax({
                url: 'SearchDeptCode.jsp',
                type: 'POST',
                data: { Deptd: Deptd },
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
<h1>검색</h1>
<hr>
	<center>
		<div class="MoneyHeader">
		    <input type="text" id="DeptdSearchInput" placeholder="관리/귀속 부서 입력">
		    <button id="searchButton" onkeyup="enterkey()">검색</button>
		    <button id="Reset" onClick="window.location.reload()">초기화</button>
	    </div>
	    <div class="ComSearch-board">
	        <table id="resultTable">
	            <thead>
	                <tr>
	                    <th>관리/귀속 부서 코드</th><th>관리/귀속 부서 코드</th><th>관리/귀속 BA</th>
	                </tr>
	            </thead>
	            <tbody>
	                <!-- 기본 데이터 표시 -->
	                <%
	                    try {
	                        String sql = "SELECT * FROM project.dept;";
	                        PreparedStatement pstmt = null;
	                        ResultSet rs = null;
	
	                        pstmt = conn.prepareStatement(sql);
	                        rs = pstmt.executeQuery();
	
	                        while(rs.next()) {    
	                %>
	                <tr>
	                    <td><a href="javascript:void(0)" onClick="var deptdCoct = '<%=rs.getString("COCT")%>'; var deptdCoctDes = '<%=rs.getString("COCT_NAME")%>';var BizArea = '<%=rs.getString("BIZ_AREA")%>'; window.opener.document.querySelector('.Deptd').value=deptdCoct ; window.opener.document.querySelector('.DeptdDes').value= deptdCoctDes ; window.opener.document.querySelector('.AdminAlloc').value= BizArea ; window.opener.document.querySelector('.Deptd').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("COCT") %></a></td>
	                    <td><%=rs.getString("COCT_NAME") %></td>
	                    <td><%=rs.getString("BIZ_AREA") %></td>
	                </tr>
	                <%
	                        }
	                    } catch(SQLException e) {
	                        e.printStackTrace();
	                    }
	                %>
	            </tbody>
	        </table>    
	    </div>    
	</center>
</body>
</html>

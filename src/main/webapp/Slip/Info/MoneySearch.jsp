<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/forSlip.css?after">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        $('#searchButton').click(function() {
            var nation = $('#nationInput').val();
            $.ajax({
                url: 'SearchNation.jsp',
                type: 'POST',
                data: { nation: nation },
                success: function(response) {
                    $('#resultTable tbody').html(response);
                }
            });
        });
        
        $('#nationInput').keydown(function(e){
        	if(e.which == 13){
        		$('#searchButton').trigger("click");
        		return false;
        	} /* else if(e.which == 8){
        		$('#Reset').trigger("click");
        	} */
        });
    });
</script>
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="MoneyHeader">
		    <input type="text" id="nationInput" placeholder="국가명 입력">
		    <button id="searchButton" onkeyup="enterkey()">검색</button>
		    <button id="Reset" onClick="window.location.reload()">초기화</button>
	    </div>
	    <div class="ComSearch-board">
	        <table id="resultTable">
	            <thead>
	                <tr>
	                    <th>화폐코드</th><th>화폐이름</th><th>국가</th>
	                </tr>
	            </thead>
	            <tbody>
	                <!-- 기본 데이터 표시 -->
	                <%
	                    try {
	                        String sql = "SELECT * FROM nationmoney ORDER BY No ASC";
	                        PreparedStatement pstmt = null;
	                        ResultSet rs = null;
	
	                        pstmt = conn.prepareStatement(sql);
	                        rs = pstmt.executeQuery();
	
	                        while(rs.next()) {    
	                %>
	                <tr>
	                    <td><a href="javascript:void(0)" onClick="var MCode = '<%=rs.getString("MoneyCode")%>';window.opener.document.querySelector('.money-code').value= MCode ;window.opener.document.querySelector('.money-code').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("MoneyCode") %></a></td>
	                    <td><%=rs.getString("MoneyDes") %></td>
	                    <td><%=rs.getString("NationDes") %></td>
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

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
            var QAccSubject = $('#AccSubjectInput').val();
            var AccCate = $('.AccCategory').val();
            console.log("확인용 : " + AccCate);
            $.ajax({
                url: 'SearchAccountSubject.jsp',
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
<h1>검색</h1>
<hr>
	<center>
		<div class="MoneyHeader">
			<select class="AccCategory">
				<option value="Subject">계정과목</option>
				<option value="Code">계정코드</option>
			</select>
		    <input type="text" id="AccSubjectInput" placeholder="입력">
		    <button id="searchButton" onkeyup="enterkey()">검색</button>
		    <button id="Reset" onClick="window.location.reload()">초기화</button>
	    </div>
	    <div class="ComSearch-board">
	        <table id="resultTable">
	            <thead>
	                <tr>
	                    <th>계정 코드</th><th>계정 과목</th>
	                </tr>
	            </thead>
	            <tbody>
	                <!-- 기본 데이터 표시 -->
	                <%
	                    try {
	                        String sql = "SELECT * FROM project.glaccount;";
	                        PreparedStatement pstmt = null;
	                        ResultSet rs = null;
	
	                        pstmt = conn.prepareStatement(sql);
	                        rs = pstmt.executeQuery();
	
	                        while(rs.next()) {    
	                %>
	                <tr>
	                    <td>
						    <a href="javascript:void(0)" 
						       onClick="
						           var AccSubCode = '<%=rs.getString("GLAccount")%>';
						           var AccSubCodeDes = '<%=rs.getString("AcctDesc")%>';
						           window.opener.document.querySelector('.AccSubjectDes').value = AccSubCodeDes;
						           window.opener.document.querySelector('.AccSubject').value = AccSubCode;
						           window.opener.document.querySelector('.AccSubject').dispatchEvent(new Event('change'));
						           window.close();
						       ">
						       <%=rs.getString("GLAccount")%>
						    </a>
						</td>
	                    <td><%=rs.getString("AcctDesc") %></td>
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

<!-- test.jsp -->
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<link rel="stylesheet" href="../css/style.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="ComSearch-board">
			<table>
			    <tr>
			        <th>코드</th><th>설명</th>
			    </tr>
			<%
			    try {
			        String matType = request.getParameter("matType");
			        if (matType == null || matType.isEmpty()) {
			%>
			        <tr>
			            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Material 유형을 선택해주세요.</a></td>
			        </tr>
			<%
			        } else {
			            String sql = "SELECT * FROM matgroup WHERE MatType = ? AND Level = 1";
			            PreparedStatement pstmt = null;
			            ResultSet rs = null;
			            pstmt = conn.prepareStatement(sql);
			            pstmt.setString(1, matType);
			            rs = pstmt.executeQuery();
			            
			            if (!rs.next()) {
			%>
			            <tr>
			                <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Material 유형에 해당하는 값이 없습니다.</a></td>
			            </tr>
			<%
			            } else {
			                do {
			%>
			            <tr>
							<td><%=rs.getString("MatGroup") %></td>
							<td>
							    <a href="javascript:void(0)" 
							       onClick="
							           var lv1Group = '<%=rs.getString("MatGroup")%>';
							           var lv1Des = '<%=rs.getString("Des")%>';
							           
							           window.opener.document.querySelector('.matlv1Code').value = lv1Group;
							           window.opener.document.querySelector('.matlv1Code').dispatchEvent(new Event('change'));
							           
							           window.opener.document.querySelector('.matlv1Des').value = lv1Des;
							           
							           var existingDes = window.opener.document.querySelector('.Des').value;
							           
							           var Array = existingDes.split(',');
							           var length = Array.length;
							           
							           window.opener.document.querySelector('.Des').value = lv1Des;
							           
							           window.opener.console.log('Selected lv1Group ' + lv1Group + ', lv1Des ' + lv1Des);
							           
							           window.close();
							       ">
							       <%=rs.getString("Des") %>
							    </a>
							</td>
			            </tr>
			<%
			                } while(rs.next());
			            }
			        }
			    } catch (SQLException e) {
			        e.printStackTrace();
			    }
			%>
			</table>	
		</div>	
	</center>
</body>
</html>

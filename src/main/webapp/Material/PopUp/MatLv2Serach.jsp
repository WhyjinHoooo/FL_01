<!-- test.jsp -->
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/PopUp.css?after">
</head>

<body>
<h1>검색</h1>
<hr>
	<center>
		<div class="Total_board">
			<table class="TotalTable">
				<thead>
			    <tr>
			        <th>코드</th><th>설명</th>
			    </tr>
			    </thead>
			    <tbody>
			<%
			    try {
			        String matType = request.getParameter("matType");
			        String lv1 = request.getParameter("lv1");
			
			        if (lv1 == null || lv1.isEmpty()) {
			%>
			        <tr>
			            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">MatGroup 1 Level를(을) 선택해주세요.</a></td>
			        </tr>
			<%
			        } else {
			            String sql = "SELECT * FROM matgroup WHERE SUBSTRING(MatGroup, 1, 5) = ?  AND MatType = ? AND Level = 2";
			            PreparedStatement pstmt = null;
			            ResultSet rs = null;
			            pstmt = conn.prepareStatement(sql);
			            pstmt.setString(1, lv1);
			            pstmt.setString(2, matType);
			            rs = pstmt.executeQuery();
			            
			            if (!rs.next()) {
			%>
			            <tr>
			                <td colspan="2"><a href="javascript:void(0)" onClick="window.close();"><%=lv1%>에 해당하는 값이 없습니다.</a></td>
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
							           var lv2Group = '<%=rs.getString("MatGroup")%>';
							           var lv2Des = '<%=rs.getString("Des")%>';
							           
							           var matlv2CodeField = window.opener.document.querySelector('.matlv2Code');
							           matlv2CodeField.value = lv2Group;
							           matlv2CodeField.dispatchEvent(new Event('change'));
							           
							           var matlv2DesField = window.opener.document.querySelector('.matlv2Des');
							           matlv2DesField.value = lv2Des;
							           
							           var existingDesField = window.opener.document.querySelector('.Des');
							           var existingDes = existingDesField.value;
							           
							           var Array = existingDes.split(',');
							           var length = Array.length;
							           
							           if(Array == 1){
							               existingDesField.value = existingDes + ', ' + lv2Des;
							           } else {
							               existingDesField.value = Array[0] + ', ' + lv2Des
							           }
							           
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
				</tbody>
			</table>	
		</div>	
	</center>
</body>
</html>

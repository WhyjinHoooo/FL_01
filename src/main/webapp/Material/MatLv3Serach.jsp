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
			        String lv2 = request.getParameter("lv2");
			
			        if (lv2 == null || lv2.isEmpty()) {
			%>
			        <tr>
			            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">MatGroup 2 Level를(을) 선택해주세요.</a></td>
			        </tr>
			<%
			        } else {
			            String sql = "SELECT * FROM matgroup WHERE SUBSTRING(MatGroup, 1, 4) = ? AND LENGTH(MatGroup) = 6 AND MatType = ? AND Level = 3";
			            PreparedStatement pstmt = null;
			            ResultSet rs = null;
			            pstmt = conn.prepareStatement(sql);
			            pstmt.setString(1, lv2);
			            pstmt.setString(2, matType);
			            rs = pstmt.executeQuery();
			            
			            if (!rs.next()) {
			%>
			            <tr>
			                <td colspan="2"><a href="javascript:void(0)" onClick="window.close();"><%=lv2%>에 해당하는 값이 없습니다.</a></td>
			            </tr>
			<%
			            } else {
			                do {
			%>
			            <tr>
			                <td><%=rs.getString("MatGroup") %></td>
							<%-- <td><a href="javascript:void(0)" onClick="var lv3Group = '<%=rs.getString("MatGroup")%>'; var lv3Des = '<%=rs.getString("Des")%>'; window.opener.document.querySelector('.matlv3Code').value=lv3Group; window.opener.document.querySelector('.matlv3Code').dispatchEvent(new Event('change')); window.opener.document.querySelector('.matlv3Des').value=lv3Des; window.opener.document.querySelector('.matlv3Des').dispatchEvent(new Event('change')); window.opener.document.querySelector('.matGroupCode').value=lv3Group; window.opener.document.querySelector('.matGroupDes').value=lv3Des; var existingDes = window.opener.document.querySelector('.Des').value; if (existingDes) { window.opener.document.querySelector('.Des').value = existingDes + ', ' + lv3Des; } else { window.opener.document.querySelector('.Des').value = lv3Des; } window.opener.console.log('Selected lv3Group ' + lv3Group + ', lv3Des ' + lv3Des); window.close();"><%=rs.getString("Des") %></a></td> --%>
							<td>
							    <a href="javascript:void(0)" 
							       onClick="
							           var lv3Group = '<%=rs.getString("MatGroup")%>';
							           var lv3Des = '<%=rs.getString("Des")%>';
							           
							           var matlv3CodeField = window.opener.document.querySelector('.matlv3Code');
							           matlv3CodeField.value = lv3Group;
							           matlv3CodeField.dispatchEvent(new Event('change'));
							           
							           var matlv3DesField = window.opener.document.querySelector('.matlv3Des');
							           matlv3DesField.value = lv3Des;
							           matlv3DesField.dispatchEvent(new Event('change'));
							           
							           window.opener.document.querySelector('.matGroupCode').value = lv3Group;
							           window.opener.document.querySelector('.matGroupDes').value = lv3Des;
							           
							           window.opener.console.log('Selected lv3Group ' + lv3Group + ', lv3Des ' + lv3Des);
							           
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

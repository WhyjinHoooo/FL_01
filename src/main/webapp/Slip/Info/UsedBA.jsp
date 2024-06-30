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
<link rel="stylesheet" href="../../css/style.css?after">
<title>Insert title here</title>
</head>
<body>
    <center>
<div class="ComSearch-board">
    <table>
        <tr>
            <th>회사 코드</th><th>BA코드</th><th>BA이름</th>
        </tr>
	<%
        try{
        
        String ComCode = request.getParameter("ComCd"); // URL에서 Com_Cd 값을 가져옴
        System.out.println("입력자의 회사 코드: " + ComCode); // ComCode 값을 console에 출력
        
        if(ComCode == null || ComCode.isEmpty()){
	%>
		<tr>
		<td colspan="3"><a href="javascript:void(0)" onClick="window.close();">로그인을 해주세요.</a></td>
		</tr>
	<%
        } else{
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM bizarea WHERE Com_Code = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, ComCode);
        rs = pstmt.executeQuery();
   		
        if(!rs.next()){
	%>
        <tr>
            <td colspan="3"><a href="javascript:void(0)" onClick="window.close();">해당하는 BA가 없습니다.</a></td>
        </tr>
	<%
        } else{
        	do{
    %>
		<tr>
			<td><a href="javascript:void(0)" onClick="window.opener.document.querySelector('#TargetDepartCd').value='ComCode';window.opener.document.querySelector('#TargetDepartCd').dispatchEvent(new Event('change')); window.close();"><%=rs.getString("BIZ_AREA") %></a></td>
			<%-- <a href="nextpage.jsp?ComCd=<%=rs.getString("Com_Cd")%>" onClick="window.opener.document.querySelector('#TargetDepartCd').value='<%=rs.getString("Com_Cd")%>';window.opener.document.querySelector('#TargetDepartCd').dispatchEvent(new Event('change'));"> <%=rs.getString("Com_Cd") %> </a> --%>
			<td><%=rs.getString("BA_Name") %></td>
		</tr>    
    <%    		
	    	    	}while(rs.next());
    	    	}
        	}
        }catch(SQLException e){
            e.printStackTrace();
        }
	%>
    </table>    
</div>    
    </center>
</body>
</html>
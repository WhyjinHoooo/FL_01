<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="../../css/PopUp.css?after">
</head>
<script>
	$(document).ready(function(){
		$('.SearchBtn').click(function(){
			var Word = $('.Input_field').val();
			console.log(Word);
			$.ajax({
				url: '${contextPath}/Purchasing/AjaxSet/Purchasing/MoneyList.jsp',
				type: 'POST',
				data: {SearchWord : Word},
				success: function(response){
					$('.TotalTable tbody').html(response);
				}
			});
		});
		$('.Input_field').keydown(function(e){
        	if(e.which == 13){
        		$('.SearchBtn').trigger("click");
        		return false;
        	}
        });
	});
</script>
<body>
	<div class="SearchArea">
		<input type="text" class="Input_field" placeholder="입력">
		<button class="SearchBtn">Search</button>
		<button class="ReSetBtn" onClick="window.location.reload()">Reset</button>
	</div>
	<div class="Total_board NewMaterialCurr">
		<table class="TotalTable">
		<thead>
		    <tr>
		        <th>화폐(영문)</th><th>화폐(국문)</th>
		    </tr>
		</thead>
		<tbody>
		<%
		    try{
		    String sql = "SELECT * FROM money ORDER BY Id ASC";
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    pstmt = conn.prepareStatement(sql);
		    rs = pstmt.executeQuery();
		    while(rs.next()){
		%>
		<tr>
		    <td>
		        <a href="javascript:void(0)" 
		           onClick="
		               var MCode='<%=rs.getString("code")%>';
		               window.opener.document.querySelector('.Currency').value=MCode;
		               window.opener.document.querySelector('.Currency').dispatchEvent(new Event('change'));
		               window.close();
		           ">
		           <%=rs.getString("code") %>
		        </a>
		    </td>
		    <td><%=rs.getString("Kr_Money") %></td>
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
</body>
</html>

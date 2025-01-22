<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="../css/PopUp.css?after">
</head>
<script>
	$(document).ready(function(){
		$('.SearchBtn').click(function(){
			var Word = $('.Input_field').val();
			console.log(Word);
			$.ajax({
				url: '${contextPath}/Information/AjaxSet/LanguageList.jsp',
				type: 'POST',
				data: {SearchWord : Word},
				success: function(response){
					$('.LanguageTable tbody').html(response);
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
<h1>검색</h1>
<hr>
	<center>
		<div class="SearchArea">
			<input type="text" class="Input_field" placeholder="입력">
			<button class="SearchBtn">Search</button>
			<button class="ReSetBtn" onClick="window.location.reload()">Reset</button>
		</div>	
		<div class="Total_board">
			<table class="TotalTable">
				<thead>
				    <tr>
				        <th>언어(영문)</th><th>나라(국문)</th>
				    </tr>
				</thead>
				<tbody>
				<%
				    try{
				    String sql = "SELECT * FROM language ORDER BY Id ASC";
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
				               var EngName = '<%= rs.getString("ENGname") %>';
				               window.opener.document.querySelector('.language-code').value = EngName;
				               window.opener.document.querySelector('.language-code').dispatchEvent(new Event('change'));
				               window.close();
				           ">
				           <%= rs.getString("ENGname") %>
				        </a>
				    </td>
				    <td><%= rs.getString("KRname") %></td>
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

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
<title>Insert title here</title>
</head>
<div class="PayPathBanner">결재/합의 경로지정</div>
<body>
    <center>
	<div class="PayPathDiv">
	     <table id="resultTable">
	     	<thead>
		        <tr>
		            <th>항번</th><th>선택</th><th>결재구분</th><th>결재/합의자 사번</th><th>성명</th><th>직급</th><th>부서코드</th><th>삭제</th><th>삭제여부</th>
		        </tr>
	        </thead>
	        <tbody>
				
			</tbody>
	    </table>    
	    <div class="BtnDiv">
		    <button class="AddBtn btn" id="AddBtn">셀 추가</button>
		    <button class="ApproverChange btn" id="ApproverChange">결재자 변경</button>
		    <button class="InfoSave btn" id="ApproverChange">저 장</button>
		    <button class="InfoCancel btn" id="ApproverChange">취 소</button>
	    </div>
	</div>    
    </center>
</body>
</html>
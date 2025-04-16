<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/PopUp.css?after">
<title>재고 수불 및 금액 집계</title>
</head>
<body class="ForSummReport">
<div class="Title">재고 변동 현황 요약</div>
<%
try {
    String[] SummDataList = request.getParameter("Array").split(",");
   System.out.println("asd");
%>
    <table class="SummReport">
        <thead>
            <tr>
                <th>
                    <div>기초</div>
                    <div>
                        <span>수량</span>
                        <span>금액</span>
                    </div>
                </th>
                <th>
                    <div>입고</div>
                    <div>
                        <span>수량</span>
                        <span>금액</span>
                    </div>
                </th>
                <th>
                    <div>출고</div>
                    <div>
                        <span>수량</span>
                        <span>금액</span>
                    </div>
                </th>
                <th>
                    <div>이체입출고</div>
                    <div>
                        <span>수량</span>
                        <span>금액</span>
                    </div>
                </th>
                <th>
                    <div>기말재고</div>
                    <div>
                        <span>수량</span>
                        <span>금액</span>
                    </div>
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
<%
	DecimalFormat df = new DecimalFormat("###,###");
    for (int i = 0; i < SummDataList.length; i++) {
        if (SummDataList[i] != null && !SummDataList[i].trim().isEmpty()) {
            int IntegerTypeNumber = Integer.parseInt(SummDataList[i]);
            String StringTypeNumber = df.format(IntegerTypeNumber);
%>
        <td><%= StringTypeNumber %></td>
<%
        } else {
%>
        <td id="NullException" colspan="10">재고 수불을 조회해주시길 바랍니다.</td>
<%
        }
    }
%>
            </tr>
        </tbody>
    </table>
<%
} catch(Exception e){
    e.printStackTrace();
}
%>
</body>
</html>

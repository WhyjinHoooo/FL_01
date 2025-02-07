<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../../mydbcon.jsp" %>
<link rel="stylesheet" href="../../css/PopUp.css?after">
<title>Insert title here</title>
</head>
<body class="MatOrderPop">
<h1>검색</h1>
<hr>
    <center>
		<div class="Total_board MatOrderBoard">
			<table class="TotalTable">
				<thead>
			        <tr>
			            <th>코드</th><th>종류</th><th>설명</th><th>구입단가</th>
			        </tr>
				</thead>
				<tbody>
				<%
			        try{
			        String ComCode = request.getParameter("ComCode");
			        String Vendor = request.getParameter("Vendor");
			        if(ComCode == null || ComCode.isEmpty()){
				%>
					<tr>
					<td colspan="4"><a href="javascript:void(0)" onClick="window.close();">Plant를(을) 선택해주세요.</a></td>
					</tr>
				<%
			        } else if(Vendor == null || Vendor.isEmpty()){
				%>
					<tr>
						<td colspan="4"><a href="javascript:void(0)" onClick="window.close();">Vendor를(을) 선택해주세요.</a></td>
					</tr>
				<%
			        } else{
			        PreparedStatement pstmt = null;
			        ResultSet rs = null;
			        String sql = "SELECT DISTINCT matmaster.DefaultWARE, purprice.Plant, purprice.MatDesc, purprice.MatType, purprice.PurUnit, purprice.MatCode, purprice.PriceBaseQty, purprice.PurPrices, purprice.PurCurr " +
			        			"FROM purprice " +
			        			"JOIN matmaster ON purprice.Plant = matmaster.Plant " + 
			        			"WHERE matmaster.Company = ? AND purprice.VendCode = ?";
			        
			        pstmt = conn.prepareStatement(sql);
			        pstmt.setString(1, ComCode);
			        pstmt.setString(2, Vendor);
			        
			        rs = pstmt.executeQuery();
			   		
			        if(!rs.next()){
				%>
			        <tr>
			            <td colspan="4"><a href="javascript:void(0)" onClick="window.close();">Vendor에 등록된 재료가 없습니다.</a></td>
			        </tr>
				<%
			        } else{
			        	do{
			        		Double price = (double) rs.getInt("purprice.PurPrices") / (double) rs.getInt("purprice.PriceBaseQty");
			        		String unit = rs.getString("purprice.PurCurr") + "/" + rs.getString("purprice.PurUnit");
			    %>
					<tr>
			 			<td>
						  <a href="javascript:void(0)" onClick="
						    window.opener.document.querySelector('.MatCode').value='<%=rs.getString("purprice.MatCode")%>';
						    window.opener.document.querySelector('.MatDes').value='<%=rs.getString("purprice.MatDesc")%>';
						    window.opener.document.querySelector('.StockUnit').value='<%=rs.getString("purprice.PurUnit")%>';
						    window.opener.document.querySelector('.OrderUnit').value='<%=rs.getString("purprice.PurUnit")%>';
						    window.opener.document.querySelector('.SlocaCode').value='<%=rs.getString("matmaster.DefaultWARE")%>';
						    window.opener.document.querySelector('.MonUnit').value='<%=rs.getString("purprice.PurCurr")%>';
						    window.opener.document.querySelector('.PriUnit').value='<%=unit%>';
						    window.opener.document.querySelector('.MatType').value='<%=rs.getString("purprice.MatType")%>';
						    window.opener.document.querySelector('.Oriprice').value='<%=price %>';
						    window.opener.document.querySelector('.SlocaCode').dispatchEvent(new Event('change'));
						    window.close();">
						    <%=rs.getString("purprice.MatCode") %>
						  </a>
						</td>
			 			<td><%=rs.getString("purprice.MatType") %></td>
			 			<td><%=rs.getString("purprice.MatDesc") %></td>
			 			<td><%=price %></td>
					</tr>    
			    <%    		
				    	    	}while(rs.next());
			    	    	}
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

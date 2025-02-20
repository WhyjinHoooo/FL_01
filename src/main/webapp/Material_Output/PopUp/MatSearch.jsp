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
<body>
<h1>검색</h1>
<hr>
<center>
	<div class="Total_board ForMove">
		<table class="TotalTable">
			<thead>
			    <tr>
            		<th>입고문서</th><th>자재코드</th><th>자재이름</th><th>입고량</th><th>Lot번호</th><th>제조일자</th><th>만료일자</th><th>단위</th>
        		</tr>
        	</thead>
        	<tbody>
			<%
			try{
		        String PlantCode = request.getParameter("plantcode");
		        String StorageCode = request.getParameter("storagecode");
			if((PlantCode == null || PlantCode.isEmpty()) || (StorageCode == null || StorageCode.isEmpty())){
			%>
				<tr>
				<td colspan="5"><a href="javascript:void(0)" onClick="window.close();">Plant 또는 출고창고를(을) 선택해주세요.</a></td>
				</tr>
			<%
			} else{
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        String sql = "SELECT * FROM storechild WHERE Plant = ? AND StoLoca = ?";
		        
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, PlantCode);
		        pstmt.setString(2, StorageCode);
		        
		        rs = pstmt.executeQuery();
		   		
			if(!rs.next()){
			%>
		        <tr>
		            <td colspan="8"><a href="javascript:void(0)" onClick="window.close();">해당하는 재료가 없습니다.</a></td>
		        </tr>
			<%
			} else{
		    	do{
		    %>
				<tr>
					
					<td>
						<a href="javascript:void(0)" onclick="
					    window.opener.document.querySelector('.MatCode').value='<%=rs.getString("Material")%>';
					    window.opener.document.querySelector('.MatDes').value='<%=rs.getString("MaterialDescription")%>';
					    window.opener.document.querySelector('.BeforeCount').value='<%=rs.getString("Quantity")%>';
					    window.opener.document.querySelector('.MatLotNo').value='<%=rs.getString("VendProdLotNum")%>';
					    window.opener.document.querySelector('.MakeDate').value='<%=rs.getString("ManifacDate")%>';
					    window.opener.document.querySelector('.DeadDete').value='<%=rs.getString("ValidToDate")%>';
					    window.opener.document.querySelector('.OrderUnit').value='<%=rs.getString("InvUnit")%>';
					    window.opener.document.querySelector('.MatCode').dispatchEvent(new Event('change'));
					    window.close();">
						<%=rs.getString("MatDocNum") %>
						</a>
					</td>
					<td><%=rs.getString("Material") %></td>
					<td><%=rs.getString("MaterialDescription") %></td>
					<td><%=rs.getString("Quantity") %></td>
					<td><%=rs.getString("VendProdLotNum") %></td>
					<td><%=rs.getString("ManifacDate") %></td>
					<td><%=rs.getString("ValidToDate") %></td>
					<td><%=rs.getString("InvUnit") %></td>
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
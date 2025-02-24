<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	<div class="Total_board ForMove">
		<table class="TotalTable">
			<thead>
			    <tr>
		            <th>자재코드</th><th>자재 Lot 번호</th><th>제조일자</th><th>만료일자</th><th>단위</th>
		        </tr>
			</thead>
			<tbody>
			<%
			try{
		        
		        String MatCode = request.getParameter("MCode");
		        String PlantCode = request.getParameter("PCode");
		        String SToCode = request.getParameter("SCode");
		    if(MatCode == null || MatCode.isEmpty()){
			%>
				<tr>
					<td colspan="5"><a href="javascript:void(0)" onClick="window.close();">자재를(을) 선택해주세요.</a></td>
				</tr>
			<%
		    } else{
		        PreparedStatement pstmt = null;
		        ResultSet rs = null;
		        String sql = "SELECT * " +
		        			 "FROM storechild WHERE " +
		        			 "Material = ? AND " + 
		        			 "Plant = ? AND " +
		        			 "StoLoca = ? AND " +
		        			 "SUBSTRING(MovType, 1, 2) = 'GR'";
		        
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, MatCode);
		        pstmt.setString(2, PlantCode);
		        pstmt.setString(3, SToCode);
		        
		        rs = pstmt.executeQuery();
		   		
			if(!rs.next()){
			%>
		        <tr>
		            <td colspan="5"><a href="javascript:void(0)" onClick="window.close();">해당하는 재료가 없습니다.</a></td>
		        </tr>
			<%
			} else{
				do{
		    %>
				<tr>
					<td>
						<a href="javascript:void(0)" onClick="
							window.opener.document.querySelector('.MatLotNo').value='<%=rs.getString("VendProdLotNum")%>';
							window.opener.document.querySelector('.MakeDate').value='<%=rs.getString("ManifacDate")%>'; 
							window.opener.document.querySelector('.DeadDete').value='<%=rs.getString("ValidToDate")%>'; 
							window.opener.document.querySelector('.OrderUnit').value='<%=rs.getString("InvUnit")%>';
							window.opener.document.querySelector('.MatLotNo').dispatchEvent(new Event('change'));
							window.close();">
							<%=MatCode %>
						</a>
					</td>
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
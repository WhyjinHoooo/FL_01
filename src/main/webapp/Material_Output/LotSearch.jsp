<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
            <th>자재 Lot 번호</th><th>제조일자</th><th>만료일자</th>
        </tr>
	<%
        try{
        LocalDateTime now = LocalDateTime.now();
        String YearMonth = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
        
        String Storagecode = request.getParameter("storagecode"); // URL에서 Com_Cd 값을 가져옴
        String GR = "GR";
        System.out.println("TEST Storagecode: " + Storagecode); // ComCode 값을 console에 출력
        
        if(Storagecode == null || Storagecode.isEmpty()){
	%>
		<tr>
			<td colspan="3"><a href="javascript:void(0)" onClick="window.close();">Material를(을) 선택해주세요.</a></td>
		</tr>
	<%
        } else{
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT " +
					 "DISTINCT storechild.VendProdLotNum, storechild.ManifacDate, storechild.ValidToDate, storechild.InvUnit, totalmaterial_child.Inventory_Qty " +
        			 "FROM storechild,totalmaterial_child WHERE " +
        			 "storechild.StoLoca = ? AND " + 
        			 "totalmaterial_child.StorLoc = ? AND " +
        			 "SUBSTRING(storechild.MovType, 1, 2) = ? AND " +
        			 "totalmaterial_child.YYMM = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, Storagecode);
        pstmt.setString(2, Storagecode);
        pstmt.setString(3, GR);
        pstmt.setString(4, YearMonth);
        
        rs = pstmt.executeQuery();
   		
        if(!rs.next()){
	%>
        <tr>
            <td colspan="3"><a href="javascript:void(0)" onClick="window.close();">해당하는 재료가 없습니다.</a></td>
        </tr>
	<%
        } else{
        	do{
    %>
		<tr>
			<td>
				<a href="javascript:void(0)" onClick="
					window.opener.document.querySelector('.MatLotNo').value='<%=rs.getString("storechild.VendProdLotNum")%>';
					window.opener.document.querySelector('.MakeDate').value='<%=rs.getString("storechild.ManifacDate")%>'; 
					window.opener.document.querySelector('.DeadDete').value='<%=rs.getString("storechild.ValidToDate")%>'; 
					window.opener.document.querySelector('.OrderUnit').value='<%=rs.getString("storechild.InvUnit")%>';
					window.opener.document.querySelector('.BeforeCount').value='<%=rs.getString("totalmaterial_child.Inventory_Qty")%>';
					window.opener.document.querySelector('.MatLotNo').dispatchEvent(new Event('change'));
					window.close();">
					<%=rs.getString("storechild.VendProdLotNum") %>
				</a>
			</td>
			<td><%=rs.getString("storechild.ManifacDate") %></td>
			<td><%=rs.getString("storechild.ValidToDate") %></td>
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
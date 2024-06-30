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
			        <th>창고코드</th><th>창고설명</th>
			    </tr>
			<%
			    try{
			    String ComCode = request.getParameter("comcode");
			    System.out.println("입력받은 ComCode : " + ComCode);
			    
			    if(ComCode == null || ComCode.isEmpty()){
			%>
				<tr>
					<td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Plant를(을) 선택해주세요.</a></td>
				</tr>
			<%  	
			    } else{
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    String sql = "SELECT * FROM storage WHERE COMCODE = ?";
			    
			    pstmt = conn.prepareStatement(sql);
			    pstmt.setString(1, ComCode);
			    
			    rs = pstmt.executeQuery();
			    
			    if(!rs.next()){
			%>
		        <tr>
		            <td colspan="2"><a href="javascript:void(0)" onClick="window.close();">Company Code에 해당하는 값이 없습니다.</a></td>
		        </tr>			
			<% 
			    }else{
			    do{  
			%>
			<tr>
			    <td><%=rs.getString("STORAGR_ID") %></td>
			    <td hidden><%=rs.getString("COMCODE") %></td>
			    <td><a href="javascript:void(0)" onClick="var StorageCode = '<%=rs.getString("STORAGR_ID")%>'; var StorageName = '<%=rs.getString("STORAGR_NAME")%>'; var ComCode = '<%=rs.getString("COMCODE")%>';window.opener.document.querySelector('.StorageCode').value=StorageCode; window.opener.document.querySelector('.StorageDes').value=StorageName; window.opener.document.querySelector('.StorageComCode').value=ComCode;window.opener.document.querySelector('.StorageCode').dispatchEvent(new Event('change')); window.opener.console.log('Selected StorageCode: ' + StorageCode + ', StorageName: ' + StorageName + ', ComCode: ' + ComCode); window.close();"><%=rs.getString("STORAGR_NAME") %></a></td>
			</tr>

			<%  
							}while(rs.next());
				    	}
				    }
			    }catch(Exception e){
			        e.printStackTrace();
			    }
			%>
			</table>	
		</div>	
	</center>
</body>
</html>
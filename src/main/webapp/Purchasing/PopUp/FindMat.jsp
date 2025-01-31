<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
		<div class="Total_board ExMaterial">
			<table class="TotalTable">
				<thead>
					<tr>
				        <th>코드</th><th>설명</th>
				    </tr>
				</thead>
				<tbody>
			<%
			try{
				String Category = request.getParameter("Category");
				System.out.println("1.Category : " + Category);
			    String sql = "SELECT * FROM matmaster";
			    PreparedStatement pstmt = null;
			    ResultSet rs = null;
			    
			    pstmt = conn.prepareStatement(sql);
			    rs = pstmt.executeQuery();
			    while(rs.next()) {
		            if(Category.equals("Search")) {
			%>
		                <tr>
		                    <td>
		                        <a href="javascript:void(0)" onclick="
		                            window.opener.document.querySelector('.MatCode').value='<%=rs.getString("Material_code")%>';
		                            window.opener.document.querySelector('.MatCode').dispatchEvent(new Event('change'));
		                            window.close();
		                        ">
		                        <%=rs.getString("Material_code") %>
		                        </a>
		                    </td>
		                    <td><%=rs.getString("Description") %></td>
		                </tr>
			<%
		            } else if(Category.equals("Entry")) {
			%>
		                <tr>
		                    <td>
		                        <a href="javascript:void(0)" onclick="
		                            window.opener.document.querySelector('.Entry_MatCode').value='<%=rs.getString("Material_code")%>';
		                            window.opener.document.querySelector('.Entry_MatDes').value='<%=rs.getString("Description")%>';
		                            window.opener.document.querySelector('.Entry_Unit').value='<%=rs.getString("InvUnit")%>';
		                            window.opener.document.querySelector('.Entry_MatCode').dispatchEvent(new Event('change'));
		                            window.close();
		                        ">
		                        <%=rs.getString("Material_code") %>
		                        </a>
		                    </td>
		                    <td><%=rs.getString("Description") %></td>
		                </tr>
			<%
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

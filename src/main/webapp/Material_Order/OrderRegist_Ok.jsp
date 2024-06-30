<%@page import="java.sql.SQLException"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="../mydbcon.jsp" %>
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	LocalDateTime now = LocalDateTime.now();
	String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

	String mmpo = request.getParameter("OrderNum");
	String orderType = request.getParameter("ordType");
	String plantCode = request.getParameter("plantCode");
	String plantDes = request.getParameter("plantDes");
	String vendorCode = request.getParameter("VendorCode");
	String vendorDes = request.getParameter("VendorDes");
	String plantComCode = request.getParameter("plantComCode");
	/* String inco = request.getParameter(""); */
	/* Iten_Num은 따로 */
	String ordDate = request.getParameter("date");
	/* String Complete = request.getParameter(""); */
	String yet = "yet";
	int id = 17011381;
	
	String sql1 = "SELECT COUNT(Mmpo) AS MmpoCount FROM ordertable WHERE Mmpo = ?";
	PreparedStatement pstmt1 = conn.prepareStatement(sql1);
	ResultSet rs1 = null;
	pstmt1.setString(1, mmpo);
	rs1 = pstmt1.executeQuery();
	int ItemNum = 0;
	if(rs1.next()){
		ItemNum = rs1.getInt("MmpoCount");
	};
	
	String sql1_1 = "INSERT INTO poheader VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt1_1 = conn.prepareStatement(sql1_1);

	String sql1_2 = "DELETE FROM ordertable WHERE Mmpo = ?";
	PreparedStatement pstmt1_2 = conn.prepareStatement(sql1_2);
	pstmt1_2.setString(1, mmpo);
	
	String sql2 = "SELECT * FROM ordertable WHERE Mmpo = ?";
	PreparedStatement pstmt2 = conn.prepareStatement(sql2);
	ResultSet rs2 = null;
	pstmt2.setString(1, mmpo);
	rs2 = pstmt2.executeQuery();
	
	String sql2_1 = "INSERT INTO pochild VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt2_1 = conn.prepareStatement(sql2_1);
	String empty = "A";
	
	
	try{
		
		pstmt1_1.setString(1,mmpo);
		pstmt1_1.setString(2,orderType);
		pstmt1_1.setString(3,plantCode);
		pstmt1_1.setString(4,plantDes);
		pstmt1_1.setString(5,vendorCode);
		pstmt1_1.setString(6,vendorDes);
		pstmt1_1.setString(7,yet);
		pstmt1_1.setInt(8,ItemNum);
		pstmt1_1.setString(9,date);
		pstmt1_1.setInt(10,id);
		pstmt1_1.setString(11,yet);
		pstmt1_1.executeUpdate();
		
		int rowsAffected = pstmt1_2.executeUpdate();
		if (rowsAffected > 0) {
	        // 레코드 삭제가 성공했을 때의 처리
	        out.println("테이블에서 " + mmpo + " 자재 삭제 완료");
	    } else {
	        // 해당하는 주문이 없을 때의 처리
	        out.println("해당하는 자재가 없습니다: " + mmpo);
	    }
	while(rs2.next()){
		int inemp = 0; // PO잔량
		int doemp = 0; // 납품누적수량
		//PO 잔량 = Quantity - 납품누적수량
	    String key = rs2.getString("Mmpo") + "-" + String.format("%04d", rs2.getInt("ItemNo")); // 구분키
	    String mmpNo = rs2.getString("Mmpo"); // MMPO번호
	    int itemNo = rs2.getInt("ItemNo"); // 변수명 수정: Item_No -> itemNo
	    /* int formattedItemNo = Integer.parseInt(String.format("%04d", itemNo)); // 네 자리 숫자로 포맷팅된 문자열 */
	    String formattedItemNo = String.format("%04d", rs2.getInt("ItemNo")); // ItemNo
	   	String MatCode = rs2.getString("Material"); // material code
	    String MatDes = rs2.getString("MatDes"); // material des
	    String MatType = rs2.getString("Type"); // material type
	    int Quantity = rs2.getInt("Count"); // Quantity
	    String POunit = rs2.getString("BuyUnit"); // PO단위
	    Double POpriUnit = rs2.getDouble("OriPrice"); // PO단가
	    String PriUnit = rs2.getString("PriUnit"); // 가격단위
	    Double TotPrice = rs2.getDouble("Price"); // 발주금액
	    String Money = rs2.getString("money"); // 거래통화
	    String Hdate = rs2.getString("Hope"); // 납품희망일자
	    String StorageCode = rs2.getString("Warehouse"); // 납품창고
	    String PlantCode = rs2.getString("Plant"); // 플랜트 코드
	    
	    inemp = Quantity - doemp;
	    
	    pstmt2_1.setString(1, key); //구분키
	    pstmt2_1.setString(2, mmpNo); // MMPO번호
	    pstmt2_1.setString(3,formattedItemNo); // itemNo
	    pstmt2_1.setString(4, MatCode); // material code
	    pstmt2_1.setString(5, MatDes); // material des
	    pstmt2_1.setString(6, MatType); // material type
	    pstmt2_1.setInt(7, Quantity); // Quantity
	    pstmt2_1.setString(8, POunit); // PO단위
	    pstmt2_1.setDouble(9, POpriUnit); // PO단가
	    pstmt2_1.setString(10, PriUnit); // 가격단위
	    pstmt2_1.setDouble(11, TotPrice); // 발주금액
	    pstmt2_1.setString(12, Money); // 거래통화
	    pstmt2_1.setString(13, Hdate); // 납품희망일자
	    pstmt2_1.setString(14, StorageCode); // 납품창고
	    pstmt2_1.setString(15, PlantCode); // 플랜트 코드
	    pstmt2_1.setInt(16, doemp); // 납품누적수량
	    pstmt2_1.setInt(17, inemp); // PO잔량
	    pstmt2_1.setString(18, empty); // 납품마갑여부
	    pstmt2_1.executeUpdate();
	    
	    	    
	}
} catch(SQLException e){
	e.printStackTrace();
} finally{
	try{
		if(pstmt1 != null && !pstmt1.isClosed()){
			pstmt1.close();
		}
		if(pstmt1_1 != null && !pstmt1_1.isClosed()){
			pstmt1_1.close();
		}
		if(pstmt1_2 != null && !pstmt1_2.isClosed()){
			pstmt1_2.close();
		}
		if(pstmt2 != null && !pstmt2.isClosed()){
			pstmt2.close();
		}
		if(pstmt2_1 != null && !pstmt2_1.isClosed()){
			pstmt2_1.close();
		}
	}catch(SQLException e){
		e.printStackTrace();
	}
}	
	session.setAttribute("pCode", plantCode);
	session.setAttribute("pDes", plantDes);
	session.setAttribute("pComCode", plantComCode);
	conn.close();
/* out.println("<script>window.location.href='OrderRegistform.jsp?pCode="+plantCode+"&pDes="+plantDes+"&pComCode="+plantComCode+"';</script>"); */
	response.sendRedirect("/FL_01/Material_Order/OrderRegistform.jsp");

%>
</body>
</html>
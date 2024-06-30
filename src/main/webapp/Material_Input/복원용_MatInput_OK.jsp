<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.SQLException"%>
<%@page import="javax.imageio.plugins.tiff.ExifParentTIFFTagSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.math.RoundingMode"%>
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
	String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); //년-월-일 시:분:초
	String YYMM = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
	
	int ItemNumber = Integer.parseInt(request.getParameter("OIN"));
	String re_plantCode = request.getParameter("plantCode"); // Back  !
	String re_plantName = request.getParameter("plantDes"); // Back ! 
	String re_plantComCode = request.getParameter("plantComCode"); // Back !
	String re_venderDes = request.getParameter("VendorDes"); // Back !
	
	
	/* 부모용 */
	String MatDocNum = request.getParameter("MatNum"); // Material 입고 번호
	String PostingDate = request.getParameter("date"); // 오늘 날짜
	String PONum = request.getParameter("PurOrdNo"); // 발주서 번호
	String FIDocNum = "Nope";
	String Plant = request.getParameter("plantComCode"); // Plant코드
	String SLocation = request.getParameter("SLocCode"); // 창고 코드
	String Vendor = request.getParameter("VendorCode"); // Vender 코드 Back !
	String CreateDate = date; // 생성날짜
	String InputPerson = request.getParameter("UserID"); // 입고자 사번
	
	/* 자식용 */
	//Mataterial 입고 번호 + GR Item Number
	String C_MatDocItemID = request.getParameter("MatNum") + "-" + String.format("%04d", Integer.parseInt(request.getParameter("ItemNum")));
	String C_DocinDate = request.getParameter("date"); //공통, 오늘 날짜
	String C_MacDocNum = request.getParameter("MatNum"); // 공통, Material 입고 번호
	int C_ItemNum = Integer.parseInt(request.getParameter("ItemNum"));// Item 번호, String.format("%04d", Integer.parseInt(request.getParameter("ItemNum")))
	String C_MatCode = request.getParameter("MatCode"); // Material 코드
	String C_MatType = request.getParameter("MatType"); // Material 유형
	String C_MovType = request.getParameter("MovType");// Movement Type
	int C_Quantity = Integer.parseInt(request.getParameter("InputCount")); // 입고 수량 
	String C_InvUnit = request.getParameter("GoodUnit"); // 재고 단위
	Double C_TraAount = 0.0; // 입고 수량 + 단가항목(단가테이블 참고)
	String C_TraCurr = request.getParameter("Money"); // 통화 코드
	Double C_LocAount = 0.0; // 통화 코드에 대한 총 금액
	String C_LocCurr = "KRW"; // 장부통화
	String C_VendorCode = request.getParameter("VendorCode"); // 공통, Vender 코드
	String C_OrderNum = request.getParameter("PurOrdNo"); // 공통, 발주서 번호
	String C_VendProdLotNum = request.getParameter("LotName"); // 자재 Lot 번호
	String C_ManifacDate = request.getParameter("MadeDate"); // 제조일자
	String C_ValidDate = request.getParameter("Deadline"); // 만료일자
	String C_SLocCode = request.getParameter("SLocCode"); // 공통, 창고 코드
	String C_Bin = "nope"; // request.getParameter("Bin"), Bin 코드
	String C_PlantCode = request.getParameter("plantComCode"); // 공통, Plant 코드
	String C_InputId = request.getParameter("UserID"); // 공통, 입고자 사번
	
	String code_C = "C";
	BigDecimal emptyCell = new BigDecimal("0.000");
	int zero = 0;
	String seperation = C_MovType.substring(0, 2); // GR, GI, IR
	String PlMi = request.getParameter("PlusMinus");
	String empty = "empty";
	
	/* System.out.println("아아아아아 : " + seperation);
	System.out.println("이이이이이 : " + PlMi);
	
	
	System.out.println("==========HEAD==========");
	System.out.println("ItemNumber : " + ItemNumber);
	System.out.println("MatDocNum: " + MatDocNum);
	System.out.println("PostingDate: " + PostingDate);
	System.out.println("!!PONum: " + PONum);
	System.out.println("!!code_C: " + code_C);
	System.out.println("FIDocNum: " + FIDocNum);
	System.out.println("Plant: " + re_plantCode); // V
	System.out.println("SLocation: " + SLocation); // V
	System.out.println("Vendor: " + Vendor);
	System.out.println("CreateDate: " + CreateDate);
	System.out.println("InputPerson: " + InputPerson);
	System.out.println("==========CHILD==========");
	System.out.println("C_MatDocItemID:" + C_MatDocItemID);
	System.out.println("C_DocinDate: " + C_DocinDate);
	System.out.println("C_MacDocNum: " + C_MacDocNum);
	System.out.println("C_ItemNum: " + C_ItemNum);
	System.out.println("C_MatCode: " + C_MatCode); // V
	System.out.println("C_MatType: " + C_MatType);
	System.out.println("C_MovType: " + C_MovType);
	System.out.println("C_Quantity: " + C_Quantity);
	System.out.println("C_InvUnit: " + C_InvUnit);
	System.out.println("C_TraAount: " + C_TraAount);
	System.out.println("C_TraCurr: " + C_TraCurr);
	System.out.println("C_LocAount: " + C_LocAount);
	System.out.println("C_LocCurr: " + C_LocCurr);
	System.out.println("C_VendorCode: " + C_VendorCode);
	System.out.println("C_OrderNum: " + C_OrderNum);
	System.out.println("C_VendProdLotNum: " + C_VendProdLotNum);
	System.out.println("C_ManifacDate: " + C_ManifacDate);
	System.out.println("C_ValidDate: " + C_ValidDate);
	System.out.println("C_SLocCode: " + C_SLocCode); 
	System.out.println("C_Bin: " + C_Bin);
	System.out.println("C_PlantCode: " + C_PlantCode);
	System.out.println("C_InputId: " + C_InputId); */
	
	
	String H_sql = "INSERT INTO storehead VALUES(?,?,?,?,?,?,?,?,?)";
	String C_sql = "INSERT INTO storechild VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	String PC_sql = "SELECT Quantity, Count, PO_Rem FROM pochild WHERE MMPO = ? AND ItemNo = ?";
	String UP_sql = "UPDATE pochild SET Count = ?, PO_Rem = ? WHERE MMPO = ? AND ItemNo = ?"; // pochild중 Count, PO_Rem의 데이터값 변경
	String UP2_sql = "UPDATE pochild SET DeadLine = ? WHERE MMPO = ? AND ItemNo = ?"; //pochild중 DeadLine의 데이터값 변경
	String UP3_sql = "UPDATE poheader SET Complete = ? WHERE Mmpo = ?"; // poheader중 Complete의 데이터값 변경
	
	String Cc_sql = "SELECT count(pochild.key) as number, DeadLine FROM pochild WHERE DeadLine = ? AND MMPO = ?";
	String Hc_sql = "SELECT ItemNum FROM poheader WHERE Mmpo = ?";
	
	String PP_sql = "SELECT * FROM purprice WHERE MatCode = ?";
	
	String TMH_sql = "INSERT INTO totalMaterial_head ( " +
		    "YYMM, " +
		    "Com_Code, " +
		    "Material, " +
		    "Plant, " +
		    "StorLoc, " +
		    "Initial_Qty, " +
		    "Initial_Amt, " +
		    "Purchase_In, " +
		    "Purchase_Amt, " +
		    "Material_Out, " +
		    "Material_Amt, " +
		    "Transfer_InOut, " +
		    "Transfer_Amt, " +
		    "Inventory_Qty, " +
		    "Inventory_Amt, " +
		    "Inventory_UnitPrice, " +
		    "UnitPriceDiff, " +
		    "InvUnit" +
		") VALUES ( " +
		    "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? " +
		")";
	
	String THC_sql = "INSERT INTO totalMaterial_child ( " +
		    "YYMM, " +
		    "Com_Code, " +
		    "Material, " +
		    "Plant, " +
		    "StorLoc, " +
		    "Initial_Qty, " +
		    "Initial_Amt, " +
		    "Purchase_In, " +
		    "Purchase_Amt, " +
		    "Material_Out, " +
		    "Material_Amt, " +
		    "Transfer_InOut, " +
		    "Transfer_Amt, " +
		    "Inventory_Qty, " +
		    "Inventory_Amt, " +
		    "Inventory_UnitPrice, " +
		    "UnitPriceDiff, " +
		    "InvUnit" +
		") VALUES ( " +
		    "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? " +
		")";
	/* 
	String THC_sql = "INSERT INTO totalMaterial_child ( " +
			"Seq, " +
		    "YYMM, " +
		    "Com_Code, " +
		    "Material, " +
		    "Plant, " +
		    "StorLoc, " +
		    "Initial_Qty, " +
		    "Initial_Amt, " +
		    "Purchase_In, " +
		    "Purchase_Amt, " +
		    "Material_Out, " +
		    "Material_Amt, " +
		    "Transfer_InOut, " +
		    "Transfer_Amt, " +
		    "Inventory_Qty, " +
		    "Inventory_Amt, " +
		    "Inventory_UnitPrice, " +
		    "UnitPriceDiff" +
		") VALUES ( " +
		    "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? " +
		")";
	*/
	
	String TMH_check = "SELECT * FROM totalmaterial_head WHERE YYMM = ? AND Com_Code = ? AND Material = ?"; // 재고관리 테이블 부모 점검용
	//String TMH_check = "SELECT * FROM totalmaterial_head WHERE Com_Code = ? AND Material = ?";
	// String TMH_check = "SELECT * FROM totalmaterial_head WHERE (YYMM, Com_Code, Material) IN ((?,?,?))"; // 재고관리 테이블 부모 점검용
	
	String TMC_check = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?"; // 재고관리 테이블 자식 점검용
	//String TMC_check = "SELECT * FROM totalmaterial_child WHERE Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
	//String TMC_check = "SELECT * FROM totalmaterial_child WHERE (YYMM, Com_Code, Material, Plant, StorLoc) IN ((?,?,?,?,?))"; // 재고관리 테이블 자식 점검용
	
	// "UPDATE pochild SET DeadLine = ? WHERE MMPO = ? AND ItemNo = ?";
	String TMH_GR_renew = "UPDATE totalmaterial_head SET Purchase_In = ?, Purchase_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ?, Inventory_UnitPrice = ? WHERE Material = ? AND YYMM = ? AND Com_Code = ?";
/* 	String TMH_GI_renew = "";
	String TMH_IR_renew = ""; */
	
	String TMC_GR_renew = "UPDATE totalmaterial_child SET Purchase_In = ?, Purchase_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ?, Inventory_UnitPrice = ? WHERE Material = ? AND Plant = ? AND StorLoc = ? AND YYMM = ? AND Com_Code = ?";
/* 	String TMC_GI_renew = "";
	String TMC_IR_renew = ""; */
	
	String pochild_Chcek = "SELECT Count FROM pochild WHERE MMPO = ? AND ItemNo = ?";
	
	PreparedStatement H_pstmt = conn.prepareStatement(H_sql);
	PreparedStatement C_pstmt = conn.prepareStatement(C_sql);
	PreparedStatement PC_pstmt = conn.prepareStatement(PC_sql);
	
	PreparedStatement UP_pstmt = conn.prepareStatement(UP_sql);
	PreparedStatement UP2_pstmt = conn.prepareStatement(UP2_sql);
	PreparedStatement UP3_pstmt = conn.prepareStatement(UP3_sql);
	
	PreparedStatement Cc_pstmt = conn.prepareStatement(Cc_sql);
	PreparedStatement Hc_pstmt = conn.prepareStatement(Hc_sql);
	
	PreparedStatement PP_pstmt = conn.prepareStatement(PP_sql);
	
	PreparedStatement pc_CHK = conn.prepareStatement(pochild_Chcek);
	/* ---------------------------------------------------------------- */
	PreparedStatement TMH_pstmt = conn.prepareStatement(TMH_sql); // 재고관리 테이블 부모
	PreparedStatement TMC_pstmt = conn.prepareStatement(THC_sql); // 재고관리 테이블 자식
	
	PreparedStatement TMH_Check_pstmt = conn.prepareStatement(TMH_check); // 재고관리 부모테이블  점검용
	PreparedStatement TMC_Check_pstmt = conn.prepareStatement(TMC_check); // 재고관리 자식테이블  점검용

	PreparedStatement TMH_GR_pstmt = conn.prepareStatement(TMH_GR_renew); // 입고
/* PreparedStatement TMH_GI_pstmt = conn.prepareStatement(TMH_GI_renew); // 출고
	PreparedStatement TMH_IR_pstmt = conn.prepareStatement(TMH_IR_renew); //이체출고 */
	
	PreparedStatement TMC_GR_pstmt = conn.prepareStatement(TMC_GR_renew); //입고
/* PreparedStatement TMC_GI_pstmt = conn.prepareStatement(TMC_GI_renew); // 출고
	PreparedStatement TMC_IR_pstmt = conn.prepareStatement(TMC_IR_renew); // 이체출고 */
	/* ------------------------------------------------------------------ */

	PC_pstmt.setString(1, PONum);
	PC_pstmt.setInt(2, ItemNumber);
	
	Cc_pstmt.setString(1, code_C);
	Cc_pstmt.setString(2, PONum);
	
	Hc_pstmt.setString(1, PONum);
	
	PP_pstmt.setString(1, C_MatCode);
	
	TMH_Check_pstmt.setString(1, YYMM); /* ! */
	TMH_Check_pstmt.setString(2, C_PlantCode); /* ! */
	TMH_Check_pstmt.setString(3, C_MatCode); /* ! */
	
	TMC_Check_pstmt.setString(1, YYMM);
	TMC_Check_pstmt.setString(2, C_PlantCode);
	TMC_Check_pstmt.setString(3, C_MatCode);
	TMC_Check_pstmt.setString(4, re_plantCode);
	TMC_Check_pstmt.setString(5, SLocation);
	
	pc_CHK.setString(1, PONum);
	pc_CHK.setInt(2, ItemNumber);
	
	ResultSet PC_rs = PC_pstmt.executeQuery();
	ResultSet PP_rs = PP_pstmt.executeQuery();
	
	ResultSet TMH_Check_rs = TMH_Check_pstmt.executeQuery();
	ResultSet TMC_Check_rs = TMC_Check_pstmt.executeQuery();
	
	ResultSet pc_CHK_rs = pc_CHK.executeQuery();
	
	try{
		if (pc_CHK_rs.next() && PlMi.equals("Minus")) {
		    if (pc_CHK_rs.getInt("Count") < C_Quantity) {
		        // 입력한 수량이 발주한 수량보다 많을 때
		%>
		        <script>
		            alert("입력한 수량이 발주한 수량보다 많습니다.");
		            history.go(-1); // 이전 페이지로 이동
		        </script>
		<%
		        return;
		    }
		}
		
		if(PP_rs.next()){
					
				Double price = (double)PP_rs.getInt("PurPrices") / PP_rs.getInt("PriceBaseQty");
				int total_Price = (int)Math.round(C_Quantity * price);
				System.out.println("price : " + price);
				System.out.println("total_Price : " + total_Price);
				
				
		 		H_pstmt.setString(1, MatDocNum); // material 입고 번호
				H_pstmt.setString(2, PostingDate); // 오늘 날짜 
				H_pstmt.setString(3, PONum); // 발주서 번호
				H_pstmt.setString(4, FIDocNum); // 몰?루
				H_pstmt.setString(5, re_plantCode); // plant코드
				H_pstmt.setString(6, SLocation); // 창고 코드
				H_pstmt.setString(7, Vendor); // 벤더 코드
				H_pstmt.setString(8, CreateDate); // 오늘 날짜
				H_pstmt.setString(9, InputPerson); // 입고자 사번
				H_pstmt.executeUpdate();
				
				C_pstmt.setString(1, C_MatDocItemID); //material 입고 번호 + GR Item number
				C_pstmt.setString(2, C_DocinDate); // 오늘 날짜
				C_pstmt.setString(3, C_MacDocNum); // Material 입고 번호
				
				C_pstmt.setInt(4, C_ItemNum); // ItemNum
				
				C_pstmt.setString(5, C_MatCode); // material 코드
				C_pstmt.setString(6, C_MatType); // material 유형
				C_pstmt.setString(7, C_MovType); // Movement 유형
				
				C_pstmt.setInt(8, C_Quantity); // 입고 수량
				
				C_pstmt.setString(9, C_InvUnit); // 재고 단위
				
				C_pstmt.setDouble(10, total_Price); // 입고 수량 *단가항목
				C_pstmt.setString(11, C_TraCurr); // 통화 코드
				C_pstmt.setDouble(12, C_LocAount); // 통화코드에 대한 총 금액
				
				C_pstmt.setString(13, C_LocCurr); // 장부 통화
				C_pstmt.setString(14, C_VendorCode); // vendor 코드
				C_pstmt.setString(15, C_OrderNum); // PONum
				C_pstmt.setString(16, C_VendProdLotNum); // 자재 LOT 번호
				C_pstmt.setString(17, C_ManifacDate); // 제조일자
				C_pstmt.setString(18, C_ValidDate); // 말료일자
				C_pstmt.setString(19, C_SLocCode); // 창고 코드
				C_pstmt.setString(20, C_Bin); // BUM
				C_pstmt.setString(21, re_plantCode); // plant 코드
				C_pstmt.setString(22, C_InputId); // 입고자 사번
				C_pstmt.executeUpdate(); 
				
				if(PC_rs.next()){
					int New_Count = PC_rs.getInt("Count") + C_Quantity;
					int New_PORem = PC_rs.getInt("Quantity") - New_Count;
					
					System.out.println("Count 확인용 : " + PC_rs.getInt("Count"));
					System.out.println("Quantity 확인용: " + PC_rs.getInt("Quantity"));
					
					System.out.println("New_Count : " + New_Count);
					System.out.println("New_PORem : " + New_PORem);
					// String UP_sql = "UPDATE pochild SET Count = ?, PO_Rem = ? WHERE MMPO = ? AND ItemNo = ?";
					UP_pstmt.setInt(1, New_Count); // 납품 누적수량
					UP_pstmt.setInt(2, New_PORem); // PO잔량
					UP_pstmt.setString(3, PONum); // MMPO = Purchase Order No = PO번호
					UP_pstmt.setInt(4, ItemNumber); // ItemNo(0001,0002,0003)
					UP_pstmt.executeUpdate(); // 입출고 테이블에 데이터가 입력되고 발주 자식 테이블에 납품 누적수량 및 PO잔량 수정
					
					if(New_PORem == 0){ // PO잔량이 0개면 발동
						UP2_pstmt.setString(1, "C");
						UP2_pstmt.setString(2, PONum);
						UP2_pstmt.setInt(3, ItemNumber);
						UP2_pstmt.executeUpdate();
						
						ResultSet Cc_rs = Cc_pstmt.executeQuery();
						ResultSet Hc_rs = Hc_pstmt.executeQuery();
						
						if(Cc_rs.next() && Hc_rs.next()){
							System.out.println("DeadLine : " + Cc_rs.getString("DeadLine"));
							int PC_count = Cc_rs.getInt("number");
							int PH_count = Hc_rs.getInt("ItemNum");
							String ok = "Complete";
							
							System.out.println("PC_count : " + PC_count);
							System.out.println("PH_count : " + PH_count);
							
							if(PC_count == PH_count){
								System.out.println("성공한 경우");
								System.out.println("PC_count : " + PC_count);
								System.out.println("PH_count : " + PH_count);
								UP3_pstmt.setString(1, ok);
								UP3_pstmt.setString(2, PONum);
								UP3_pstmt.executeUpdate();
							} else{
								System.out.println("실패한 경우");
								System.out.println("PC_count : " + PC_count);
								System.out.println("PH_count : " + PH_count);
							}
						} // Cc_rs.next() && Hc_rs.next())의 끝
						
					}else{
						System.out.println(C_OrderNum + "의 잔량은 0이 아닙니다.");
					} // New_PORem == 0의 끝
							
					if(!TMH_Check_rs.next()){ // 입고가 되어 있지 않는 상태
						TMH_pstmt.setString(1, YYMM); // 연도
						TMH_pstmt.setString(2, re_plantComCode); // 회사 코드
						TMH_pstmt.setString(3, C_MatCode); // 자재 코드
						TMH_pstmt.setString(4,empty); // 공장 코드
						TMH_pstmt.setString(5,empty); // 창고 코드
						TMH_pstmt.setInt(6, zero); // 기초 수량
						TMH_pstmt.setInt(7, zero); // 기초 금액
						BigDecimal invenCost = new BigDecimal(total_Price / C_Quantity);
						if(seperation.equals("GR") && PlMi.equals("Plus")){
							TMH_pstmt.setInt(8, C_Quantity); // 구매입고 수량
							TMH_pstmt.setInt(9, total_Price); // 구매입고 금액
							TMH_pstmt.setInt(10, zero); // 자재 출고 수량
							TMH_pstmt.setInt(11, zero); // 자재 출고 금액
							TMH_pstmt.setInt(12, zero); // 이체출고입고 수량
							TMH_pstmt.setInt(13, zero); // 이체출고입고 금액
							TMH_pstmt.setInt(14, C_Quantity); // 재고 수량
							TMH_pstmt.setInt(15, total_Price); // 재고 금액
							TMH_pstmt.setBigDecimal(16, invenCost); //재고 단가
							TMH_pstmt.setBigDecimal(17, emptyCell); // 단수차
							TMH_pstmt.setString(18, C_InvUnit); // 재고단위
								
							//TMC_pstmt.setInt(1, zero);
							TMC_pstmt.setString(1, YYMM); // 연도
							TMC_pstmt.setString(2, re_plantComCode); // 회사 코드
							TMC_pstmt.setString(3, C_MatCode); // 자재 코드
							TMC_pstmt.setString(4, re_plantCode); // 공장 코드
							TMC_pstmt.setString(5, SLocation); // 창고 코드
							TMC_pstmt.setInt(6, zero); // 기초 수량
							TMC_pstmt.setInt(7, zero); // 기초 금액
							TMC_pstmt.setInt(8, C_Quantity); // 구매입고 수량
							TMC_pstmt.setInt(9, total_Price); // 구매입고 금액
							TMC_pstmt.setInt(10, zero); // 자재 출고 수량
							TMC_pstmt.setInt(11, zero); // 자재 출고 금액
							TMC_pstmt.setInt(12, zero); // 이체출고입고 수량
							TMC_pstmt.setInt(13, zero); // 이체출고입고 금액
							TMC_pstmt.setInt(14, C_Quantity); // 재고 수량
							TMC_pstmt.setInt(15, total_Price); // 재고 
							TMC_pstmt.setInt(16, total_Price / C_Quantity); //재고 단가
							TMC_pstmt.setInt(17, zero); // 단수차
							TMC_pstmt.setString(18, C_InvUnit); // 재고단위
						} else if(seperation.equals("GR") && PlMi.equals("Minus")){
							TMH_pstmt.setInt(8, -C_Quantity); // 구매입고 수량
							TMH_pstmt.setInt(9, -total_Price); // 구매입고 금액
							TMH_pstmt.setInt(10, zero); // 자재 출고 수량
							TMH_pstmt.setInt(11, zero); // 자재 출고 금액
							TMH_pstmt.setInt(12, zero); // 이체출고입고 수량
							TMH_pstmt.setInt(13, zero); // 이체출고입고 금액
							TMH_pstmt.setInt(14, C_Quantity); // 재고 수량
							TMH_pstmt.setInt(15, total_Price); // 재고 금액
							TMH_pstmt.setBigDecimal(16, invenCost); //재고 단가
							TMH_pstmt.setBigDecimal(17, emptyCell); // 단수차
							TMH_pstmt.setString(18, C_InvUnit); // 재고단위
							
							//TMC_pstmt.setInt(1, zero);
							TMC_pstmt.setString(1, YYMM); // 연도
							TMC_pstmt.setString(2, re_plantComCode); // 회사 코드
							TMC_pstmt.setString(3, C_MatCode); // 자재 코드
							TMC_pstmt.setString(4, re_plantCode); // 공장 코드
							TMC_pstmt.setString(5, SLocation); // 창고 코드
							TMC_pstmt.setInt(6, zero); // 기초 수량
							TMC_pstmt.setInt(7, zero); // 기초 금액
							TMC_pstmt.setInt(8, -C_Quantity); // 구매입고 수량
							TMC_pstmt.setInt(9, -total_Price); // 구매입고 금액
							TMC_pstmt.setInt(10, zero); // 자재 출고 수량
							TMC_pstmt.setInt(11, zero); // 자재 출고 금액
							TMC_pstmt.setInt(12, zero); // 이체출고입고 수량
							TMC_pstmt.setInt(13, zero); // 이체출고입고 금액
							TMC_pstmt.setInt(14, C_Quantity); // 재고 수량
							TMC_pstmt.setInt(15, total_Price); // 재고 금액
							TMC_pstmt.setInt(16, total_Price / C_Quantity); //재고 단가
							TMC_pstmt.setInt(17, zero); // 단수차
							TMC_pstmt.setString(18, C_InvUnit); // 재고단위
						}
						TMC_pstmt.executeUpdate();
						TMH_pstmt.executeUpdate();						
					} else if(TMC_Check_rs.next()){
						if(seperation.equals("GR") && PlMi.equals("Plus")){
							int new_Purchase_In = TMC_Check_rs.getInt("Purchase_In") + C_Quantity; // 기존의 입고 수량 + 새로 입고 수량
							int new_Inventory_Qty = (TMC_Check_rs.getInt("Purchase_In") + C_Quantity - TMC_Check_rs.getInt("Material_Out")) < 0 ? -(TMC_Check_rs.getInt("Purchase_In") + C_Quantity - TMC_Check_rs.getInt("Material_Out")) : (TMC_Check_rs.getInt("Purchase_In") + C_Quantity - TMC_Check_rs.getInt("Material_Out"));
							
							int new_Purchase_Amt = TMC_Check_rs.getInt("Purchase_Amt") + total_Price; // 기존의 입고 금액 + 새로 입고 금액
							int new_Inventory_Amt = (TMC_Check_rs.getInt("Purchase_Amt") + total_Price - TMC_Check_rs.getInt("Material_Amt")) < 0 ? -(TMC_Check_rs.getInt("Purchase_Amt") + total_Price - TMC_Check_rs.getInt("Material_Amt")) : (TMC_Check_rs.getInt("Purchase_Amt") + total_Price - TMC_Check_rs.getInt("Material_Amt"));
							
							BigDecimal new_Inventory_UnitPrice = new BigDecimal(new_Purchase_Amt).divide(new BigDecimal(new_Purchase_In), 3, RoundingMode.HALF_UP);
							
							System.out.println("new_Purchase_In : " + new_Purchase_In);
							System.out.println("new_Inventory_Qty : " + new_Inventory_Qty);
							System.out.println("new_Purchase_Amt : " + new_Purchase_Amt);
							System.out.println("new_Inventory_Amt : " + new_Inventory_Amt);

							TMH_GR_pstmt.setInt(1, new_Purchase_In);
							TMH_GR_pstmt.setInt(2, new_Purchase_Amt);
							TMH_GR_pstmt.setInt(3, new_Inventory_Qty);
							TMH_GR_pstmt.setInt(4, new_Inventory_Amt);
							TMH_GR_pstmt.setBigDecimal(5, new_Inventory_UnitPrice);
							TMH_GR_pstmt.setString(6, C_MatCode);
							TMH_GR_pstmt.setString(7, YYMM);
							TMH_GR_pstmt.setString(8, C_PlantCode);
							
							TMC_GR_pstmt.setInt(1, new_Purchase_In);
							TMC_GR_pstmt.setInt(2, new_Purchase_Amt);
							TMC_GR_pstmt.setInt(3, new_Inventory_Qty);
							TMC_GR_pstmt.setInt(4, new_Inventory_Amt);
							TMC_GR_pstmt.setBigDecimal(5, new_Inventory_UnitPrice);
							TMC_GR_pstmt.setString(6, C_MatCode);
							TMC_GR_pstmt.setString(7, re_plantCode);
							TMC_GR_pstmt.setString(8, SLocation);
							TMC_GR_pstmt.setString(9, YYMM);
							TMC_GR_pstmt.setString(10, C_PlantCode);
						} else if(seperation.equals("GR") && PlMi.equals("Minus")){
							int new_Purchase_In = TMC_Check_rs.getInt("Purchase_In") - C_Quantity; // 기존의 입고 수량 + 새로 입고 수량
							int new_Inventory_Qty = (TMC_Check_rs.getInt("Purchase_In") - C_Quantity - TMC_Check_rs.getInt("Material_Out")) < 0 ? -(TMC_Check_rs.getInt("Purchase_In") - C_Quantity - TMC_Check_rs.getInt("Material_Out")) : (TMC_Check_rs.getInt("Purchase_In") - C_Quantity - TMC_Check_rs.getInt("Material_Out"));
							
							int new_Purchase_Amt = TMC_Check_rs.getInt("Purchase_Amt") - total_Price; // 기존의 입고 금액 + 새로 입고 금액
							int new_Inventory_Amt = (TMC_Check_rs.getInt("Purchase_Amt") - total_Price - TMC_Check_rs.getInt("Material_Amt")) < 0 ? -(TMC_Check_rs.getInt("Purchase_Amt") - total_Price - TMC_Check_rs.getInt("Material_Amt")) : (TMC_Check_rs.getInt("Purchase_Amt") - total_Price - TMC_Check_rs.getInt("Material_Amt"));
							
							BigDecimal new_Inventory_UnitPrice = new BigDecimal(new_Purchase_Amt).divide(new BigDecimal(new_Purchase_In), 3, RoundingMode.HALF_UP);
							
							System.out.println("new_Purchase_In : " + new_Purchase_In);
							System.out.println("new_Inventory_Qty : " + new_Inventory_Qty);
							System.out.println("new_Purchase_Amt : " + new_Purchase_Amt);
							System.out.println("new_Inventory_Amt : " + new_Inventory_Amt);
							
							TMH_GR_pstmt.setInt(1, new_Purchase_In);
							TMH_GR_pstmt.setInt(2, new_Purchase_Amt);
							TMH_GR_pstmt.setInt(3, new_Inventory_Qty);
							TMH_GR_pstmt.setInt(4, new_Inventory_Amt);
							TMH_GR_pstmt.setBigDecimal(5, new_Inventory_UnitPrice);
							TMH_GR_pstmt.setString(6, C_MatCode);
							
							TMC_GR_pstmt.setInt(1, new_Purchase_In);
							TMC_GR_pstmt.setInt(2, new_Purchase_Amt);
							TMC_GR_pstmt.setInt(3, new_Inventory_Qty);
							TMC_GR_pstmt.setInt(4, new_Inventory_Amt);
							TMC_GR_pstmt.setBigDecimal(5, new_Inventory_UnitPrice);
							TMC_GR_pstmt.setString(6, C_MatCode);
							TMC_GR_pstmt.setString(7, re_plantCode);
							TMC_GR_pstmt.setString(8, SLocation);
						}
						TMH_GR_pstmt.executeUpdate();
						TMC_GR_pstmt.executeUpdate();
						
					}
				} //PC_rs.next()의 끝
		}
	}catch(SQLException e){
	    e.printStackTrace();
	}finally {
        // 리소스 해제
        try {
            if (H_pstmt != null && !H_pstmt.isClosed()) {
                H_pstmt.close();
            }
            if (C_pstmt != null && !C_pstmt.isClosed()) {
                C_pstmt.close();
            }
            if (PC_pstmt != null && !PC_pstmt.isClosed()) {
                PC_pstmt.close();
            }
            if (UP_pstmt != null && !UP_pstmt.isClosed()) {
                UP_pstmt.close();
            }
            if (UP2_pstmt != null && !UP2_pstmt.isClosed()) {
                UP2_pstmt.close();
            }
            if (UP3_pstmt != null && !UP3_pstmt.isClosed()) {
                UP3_pstmt.close();
            }
            if (Cc_pstmt != null && !Cc_pstmt.isClosed()) {
            	Cc_pstmt.close();
            }
            if (Hc_pstmt != null && !Hc_pstmt.isClosed()) {
            	Hc_pstmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	
	session.setAttribute("pCode", re_plantCode);
	session.setAttribute("pDes", re_plantName);
	session.setAttribute("pComCode", re_plantComCode);
	session.setAttribute("vCode", Vendor);
	session.setAttribute("vDes", re_venderDes);
	response.sendRedirect("MatInput.jsp");
	
%>
</body>
</html>
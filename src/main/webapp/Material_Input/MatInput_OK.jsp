<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.SQLException"%>
<%@page import="javax.imageio.plugins.tiff.ExifParentTIFFTagSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
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
	/* 기본적인 요소들 */
	String date = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); //년-월-일 시:분:초
	String YYMMdd = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")); // 년-월-일
	String YYMM = now.format(DateTimeFormatter.ofPattern("yyyy-MM")); // 년-월-일
	
	int UserId = Integer.parseInt(request.getParameter("UserID")); // 입고자 사번
	String PlantCode = request.getParameter("plantCode"); // P2000
	String VendorCode = request.getParameter("VendorCode"); // V1000004
	String ComCode = request.getParameter("plantComCode"); // E1000
	
	String Empty = "EMPTY";
	
	
	String SH_In_sql = "INSERT INTO storehead VALUES(?,?,?,?,?,?,?,?,?,?)"; // storehead에 데이터를 입력하는 SQL
	PreparedStatement H_pstmt = conn.prepareStatement(SH_In_sql);
	String SC_In_sql = "INSERT INTO storechild VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; // storechild에 데이터를 입력하는 SQL
	/*  */
	PreparedStatement C_pstmt = conn.prepareStatement(SC_In_sql);
	
	String TT_Sd_sql = "SELECT DISTINCT MatNum, COUNT(MatNum) as MatCount FROM temtable"; // temtable에서 중복 제외한 MatNum찾는 SQL문
	PreparedStatement SD_pstmt = conn.prepareStatement(TT_Sd_sql);
	ResultSet SD_rs = SD_pstmt.executeQuery();
	
	try{
		/* SD_rs.next()의 갯수가 1개일 경우 */
		if(SD_rs.next() && SD_rs.getRow() == 1 ){
			
			String MatName = request.getParameter("MatNum"); // MGR20240411S00001
			String Pon = request.getParameter("PurOrdNo"); // PURO20240404S00001
			String MatType = request.getParameter("MatType"); // RAWM
			String MatNum = request.getParameter("MatCode"); // 010201-00003
			String RackBin = "X";
			String SCode = request.getParameter("SLocCode"); // S2100
			String Unit = request.getParameter("BuyUnit"); // EA, 단위
			String TraCurr = request.getParameter("Money"); // KRW, TraCurr과 LocCurr하고 같음
			int RowCount = SD_rs.getInt("MatCount");
			String FIDocNum = "Nope";
			
			H_pstmt.setString(1, MatName);
			H_pstmt.setString(2, YYMMdd);
			H_pstmt.setString(3, Pon);
			H_pstmt.setString(4, FIDocNum);
			H_pstmt.setString(5, PlantCode);
			H_pstmt.setString(6, SCode);
			H_pstmt.setString(7, VendorCode);
			H_pstmt.setString(8, YYMMdd);
			H_pstmt.setInt(9, RowCount);
			H_pstmt.setInt(10, UserId);
			H_pstmt.executeUpdate();
			
			SD_rs.beforeFirst();
			
			while(SD_rs.next()){
				String TTS_sql = "SELECT * FROM temtable WHERE MatNum = ?";
				PreparedStatement TTS_pstmt = conn.prepareStatement(TTS_sql);
				TTS_pstmt.setString(1, MatName);
				ResultSet TTS_rs = TTS_pstmt.executeQuery();
				
				while(TTS_rs.next()){
					String ItemNum = String.format("%04d", TTS_rs.getInt("ItemNum")); // 0001
					//System.out.println("1: " + ItemNum);
					String MatDocNumId = MatName + "-" +ItemNum; // MGR20240411S00001-0001
					//System.out.println("2: " + MatDocNumId);
					String MovType = TTS_rs.getString("MovCode"); // GR101
					//System.out.println("3: " + MovType);
					String MovCode = MovType.substring(0, 2); // GR
					int Count = TTS_rs.getInt("Count"); // 32
					//System.out.println("4: " + Count);
					Double Price = 0.0;
					
					String MaterialCode = TTS_rs.getString("MatCode");
					String SlocCode = TTS_rs.getString("SLocCode");
					
					String PP_S_sql = "SELECT * FROM purprice WHERE MatCode = ?"; // purprice에서 해당하는 MatCode의 원가 가쟈오기
					PreparedStatement PP_S_pstmt = conn.prepareStatement(PP_S_sql);
					System.out.println("5: " + MatNum);
					PP_S_pstmt.setString(1, MatNum);
					ResultSet PP_S_rs = PP_S_pstmt.executeQuery();
					if(PP_S_rs.next()){
						System.out.println("성공");	
						Price = (double)PP_S_rs.getInt("PurPrices") /PP_S_rs.getInt("PriceBaseQty"); // 총 가격
					}
					int totalPrice = (int)Math.round(Price * Count);
					double LocAmount = 0.0;
					
					String LotNum = TTS_rs.getString("LotName"); // 자제 Lot 번호
					String MDate = TTS_rs.getString("MadeDate"); // 제조일자
					String EDate = TTS_rs.getString("DeadDate"); // 만료일자
					String PlusMinus = TTS_rs.getString("PlusMinus");
					if(PlusMinus != null){
						System.out.println("성공 : " + PlusMinus);	
					} else {
						System.out.println("실패");
					}
						
//					String RackBin = "X";
					System.out.println("MatDocNumId : " + MatDocNumId);
					System.out.println("YYMMdd : " + YYMMdd);
					System.out.println("MatName : " + MatName);
					C_pstmt.setString(1, MatDocNumId);
					C_pstmt.setString(2, YYMMdd);
					C_pstmt.setString(3, MatName);
					
					C_pstmt.setInt(4, TTS_rs.getInt("ItemNum"));
					
					C_pstmt.setString(5, MaterialCode);
					C_pstmt.setString(6, MatType);
					C_pstmt.setString(7, MovType);
					
					C_pstmt.setInt(8, Count);
					
					C_pstmt.setString(9, Unit);
					
					C_pstmt.setDouble(10, totalPrice);
					C_pstmt.setString(11, TraCurr);
					C_pstmt.setDouble(12, LocAmount);
					
					C_pstmt.setString(13, TraCurr);
					C_pstmt.setString(14, VendorCode);
					C_pstmt.setString(15, Pon);
					C_pstmt.setString(16, LotNum);
					C_pstmt.setString(17, MDate);
					C_pstmt.setString(18, EDate);
					C_pstmt.setString(19, SCode);
					C_pstmt.setString(20, RackBin);
					C_pstmt.setString(21, PlantCode);
					C_pstmt.setInt(22, UserId);
					C_pstmt.executeUpdate();
					
					String Total_H_SQL = "SELECT * FROM totalmaterial_head WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
					PreparedStatement H_Pstmt = conn.prepareStatement(Total_H_SQL);
					H_Pstmt.setString(1, YYMM); // 2024-04
					H_Pstmt.setString(2, ComCode); // E1000
					H_Pstmt.setString(3, MaterialCode); // 010201-00003
					
					ResultSet H_rs = H_Pstmt.executeQuery();
					
					if(!H_rs.next()){ // totalmaterial_head에서 YYMM, Com_Code, Material랑 중복되는 지 확인
					// 1. SELECT * FROM totalmaterial_head WHERE YYMM = ? AND Com_Code = ? AND Material = ?에 중복이 없음 --> 새삥 --> 새로 입력
						System.out.println("1. " + Total_H_SQL);
					
						String To_InH_sql = "INSERT INTO totalmaterial_head VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
						PreparedStatement InH_pstmt = conn.prepareStatement(To_InH_sql);
						
						int zero = 0;
						
						BigDecimal InvenCost = new BigDecimal(totalPrice / Count);
						BigDecimal EmptyCell = new BigDecimal("0.000");
						
						InH_pstmt.setString(1, YYMM); // 연-월
						InH_pstmt.setString(2, ComCode); // 회사코드
						InH_pstmt.setString(3, MaterialCode); // 자재코드
						InH_pstmt.setString(4, Empty); // plant
						InH_pstmt.setString(5, Empty); // Slocation
						InH_pstmt.setInt(6, zero); // 기초 수량
						InH_pstmt.setInt(7, zero); // 기초 금액
						
						String Check_Child_sql = "SELECT * FROM totalmaterial_child  WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
						PreparedStatement ChCh_pstmt = conn.prepareStatement(Check_Child_sql);
						ChCh_pstmt.setString(1, YYMM);
						ChCh_pstmt.setString(2, ComCode);
						ChCh_pstmt.setString(3, MaterialCode);
						ChCh_pstmt.setString(4, PlantCode);
						ChCh_pstmt.setString(5, SlocCode);
						
						ResultSet ChCh_rs = ChCh_pstmt.executeQuery();
							if(!ChCh_rs.next()){ // totalmaterial_child에 중복되는 지 확인
							 	// 1. 중복되는 데이터가 없음 --> 쌔삥 --> 새로 입력	
							 	System.out.println(Check_Child_sql);
								String To_InC_sql = "INSERT INTO totalmaterial_child VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
								PreparedStatement InC_pstmt = conn.prepareStatement(To_InC_sql);
							 	if(MovCode.equals("GR") && PlusMinus.equals("Plus")){
							 		System.out.println("PLUS : " + To_InC_sql);
							 		
									InH_pstmt.setInt(8, Count); // 구매입고 수량
									InH_pstmt.setInt(9, totalPrice); // 구매입고 금액
									InH_pstmt.setInt(10, zero); // 자재 출고 수량
									InH_pstmt.setInt(11, zero); // 자재 출고 금액
									InH_pstmt.setInt(12, zero); // 이체출고입고 수량
									InH_pstmt.setInt(13, zero); // 이체출고입고 금액
									InH_pstmt.setInt(14, Count); // 재고 수량
									InH_pstmt.setInt(15, totalPrice); // 재고 금액
									InH_pstmt.setBigDecimal(16, InvenCost); // 재고 단가
									InH_pstmt.setBigDecimal(17, EmptyCell); // 딘수차
									InH_pstmt.setString(18, Unit); // 재고 단위
									
									InC_pstmt.setString(1, YYMM); // 년-월
									InC_pstmt.setString(2, ComCode); // 회사코드
									InC_pstmt.setString(3, MaterialCode); // 자재코드
									InC_pstmt.setString(4, PlantCode); // Plant
									InC_pstmt.setString(5, SCode); // sLocation
									InC_pstmt.setInt(6, zero); // 기초 수량
									InC_pstmt.setInt(7, zero); // 기초 금액
									InC_pstmt.setInt(8, Count); // 구매입고 수량
									InC_pstmt.setInt(9, totalPrice); // 구매입고 금액
									InC_pstmt.setInt(10, zero); // 자재 출고 수량
									InC_pstmt.setInt(11, zero); // 자재 출고 금액
									InC_pstmt.setInt(12, zero); // 이체출고입고 수량
									InC_pstmt.setInt(13, zero); // 이체출고입고 금액
									InC_pstmt.setInt(14, Count); // 재고 수량
									InC_pstmt.setInt(15, totalPrice); // 재고 금액
									InC_pstmt.setBigDecimal(16, InvenCost); // 재고 단가
									InC_pstmt.setBigDecimal(17, EmptyCell); // 단수차
									InC_pstmt.setString(18, Unit); //재고 단위
							 	} else if(MovCode.equals("GR") && PlusMinus.equals("Minus")){
							 		System.out.println("Minus : " + To_InC_sql);
									InH_pstmt.setInt(8, -Count); // 구매입고 수량
									InH_pstmt.setInt(9, -totalPrice); // 구매입고 금액
									InH_pstmt.setInt(10, zero); // 자재 출고 수량
									InH_pstmt.setInt(11, zero); // 자재 출고 금액
									InH_pstmt.setInt(12, zero); // 이체출고입고 수량
									InH_pstmt.setInt(13, zero); // 이체출고입고 금액
									InH_pstmt.setInt(14, Count); // 재고 수량
									InH_pstmt.setInt(15, totalPrice); // 재고 금액
									InH_pstmt.setBigDecimal(16, InvenCost); // 재고 단가
									InH_pstmt.setBigDecimal(17, EmptyCell); // 딘수차
									InH_pstmt.setString(18, Unit); // 재고 단위
									
									InC_pstmt.setString(1, YYMM); // 년-월
									InC_pstmt.setString(2, ComCode); // 회사코드
									InC_pstmt.setString(3, MaterialCode); // 자재코드
									InC_pstmt.setString(4, PlantCode); // Plant
									InC_pstmt.setString(5, SCode); // sLocation
									InC_pstmt.setInt(6, zero); // 기초 수량
									InC_pstmt.setInt(7, zero); // 기초 금액
									InC_pstmt.setInt(8, Count); // 구매입고 수량
									InC_pstmt.setInt(9, totalPrice); // 구매입고 금액
									InC_pstmt.setInt(10, zero); // 자재 출고 수량
									InC_pstmt.setInt(11, zero); // 자재 출고 금액
									InC_pstmt.setInt(12, zero); // 이체출고입고 수량
									InC_pstmt.setInt(13, zero); // 이체출고입고 금액
									InC_pstmt.setInt(14, Count); // 재고 수량
									InC_pstmt.setBigDecimal(15, InvenCost); // 재고 금액
									InC_pstmt.setBigDecimal(16, EmptyCell); // 재고 단가
									InC_pstmt.setInt(17, zero); // 단수차
									InC_pstmt.setString(18, Unit); //재고 단위
								}
							 	InH_pstmt.executeUpdate();
								InC_pstmt.executeUpdate();
							} else{
							//SELECT * FROM totalmaterial_child  WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ? 를 검사했는데, 중복되는게 있음
								String Up_Ch_sql = "UPDATE totalmaterial_child SET Purchase_In = ?, Purchase_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ? WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ? ";
								PreparedStatement Up_Ch_pstmt = conn.prepareStatement(Up_Ch_sql);
								
								int O_Purchase_In = ChCh_rs.getInt("Purchase_In"); // 기존에 저장된 입고 수량
								int O_Purchase_Amt = ChCh_rs.getInt("Purchase_Amt"); // 기존에 저장된 입고 금액
								int O_Inventory_Qty = ChCh_rs.getInt("Inventory_Qty"); // 기존에 저장된 총 수량
								int O_Inventory_Amt = ChCh_rs.getInt("Inventory_Amt"); // 기존에 저장된 총 금액
								System.out.println(Up_Ch_sql);
							 	if(MovCode.equals("GR") && PlusMinus.equals("Plus")){
							 		System.out.println("Plus + Plus");
									InH_pstmt.setInt(8, Count); // 구매입고 수량
									InH_pstmt.setInt(9, totalPrice); // 구매입고 금액
									InH_pstmt.setInt(10, zero); // 자재 출고 수량
									InH_pstmt.setInt(11, zero); // 자재 출고 금액
									InH_pstmt.setInt(12, zero); // 이체출고입고 수량
									InH_pstmt.setInt(13, zero); // 이체출고입고 금액
									InH_pstmt.setInt(14, Count); // 재고 수량
									InH_pstmt.setInt(15, totalPrice); // 재고 금액
									InH_pstmt.setBigDecimal(16, InvenCost); // 재고 단가
									InH_pstmt.setBigDecimal(17, EmptyCell); // 딘수차
									InH_pstmt.setString(18, Unit); // 재고 단위
									
									int N_Purchase_In = O_Purchase_In + Count;
									int N_Purchase_Amt = O_Purchase_Amt + totalPrice;
									
									Up_Ch_pstmt.setInt(1, N_Purchase_In);
									Up_Ch_pstmt.setInt(2, N_Purchase_Amt);
									Up_Ch_pstmt.setInt(3, N_Purchase_In);
									Up_Ch_pstmt.setInt(4, N_Purchase_Amt);
									Up_Ch_pstmt.setString(5, YYMM);
									Up_Ch_pstmt.setString(6, ComCode);
									Up_Ch_pstmt.setString(7, MaterialCode);
									Up_Ch_pstmt.setString(8, PlantCode);
									Up_Ch_pstmt.setString(9, SCode);
							 	} else if(MovCode.equals("GR") && PlusMinus.equals("Minus")){
							 		System.out.println("Minus + Minus");
									InH_pstmt.setInt(8, -Count); // 구매입고 수량
									InH_pstmt.setInt(9, -totalPrice); // 구매입고 금액
									InH_pstmt.setInt(10, zero); // 자재 출고 수량
									InH_pstmt.setInt(11, zero); // 자재 출고 금액
									InH_pstmt.setInt(12, zero); // 이체출고입고 수량
									InH_pstmt.setInt(13, zero); // 이체출고입고 금액
									InH_pstmt.setInt(14, Count); // 재고 수량
									InH_pstmt.setInt(15, totalPrice); // 재고 금액
									InH_pstmt.setBigDecimal(16, InvenCost); // 재고 단가
									InH_pstmt.setBigDecimal(17, EmptyCell); // 딘수차
									InH_pstmt.setString(18, Unit); // 재고 단위
									
									int N_Purchase_In = (O_Purchase_In - Count)  < 0 ? -(O_Purchase_In - Count) : (O_Purchase_In - Count);
									int N_Purchase_Amt = (O_Purchase_Amt - totalPrice) < 0 ? -(O_Purchase_Amt - totalPrice) : (O_Purchase_Amt - totalPrice);
									
									Up_Ch_pstmt.setInt(1, N_Purchase_In);
									Up_Ch_pstmt.setInt(2, N_Purchase_Amt);
									Up_Ch_pstmt.setInt(3, N_Purchase_In);
									Up_Ch_pstmt.setInt(4, N_Purchase_Amt);
									Up_Ch_pstmt.setString(5, YYMM);
									Up_Ch_pstmt.setString(6, ComCode);
									Up_Ch_pstmt.setString(7, MaterialCode);
									Up_Ch_pstmt.setString(8, PlantCode);
									Up_Ch_pstmt.setString(9, SCode);
								}
							 	InH_pstmt.executeUpdate();
							 	Up_Ch_pstmt.executeUpdate();
							}
					} else {
					// SELECT * FROM totalmaterial_head WHERE YYMM = ? AND Com_Code = ? AND Material = ?에 중복이 있음 --> 업데이트 ㄱㄱ
						String Up_H_sql = "UPDATE totalMaterial_head SET Purchase_In = ?, Purchase_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ? WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
						PreparedStatement Up_H_pstmt = conn.prepareStatement(Up_H_sql);
						
						int Oh_Purchase_In = H_rs.getInt("Purchase_In"); // totalmaterial_head에 저장된 기존의 입고 수량
						int Oh_Purchase_Amt = H_rs.getInt("Purchase_Amt"); // totalmaterial_head에 저장된 기존의 입고 금액
						int Oh_Inventory_Qty = H_rs.getInt("Inventory_Qty"); // totalmaterial_head에 저장된 기존의 총 수량
						int Oh_Inventory_Amt = H_rs.getInt("Inventory_Amt");  // totalmaterial_head에 저장된 기존의 총 금액
						
						int zero = 0;
						
						BigDecimal InvenCost = new BigDecimal(totalPrice / Count);
						BigDecimal EmptyCell = new BigDecimal("0.000");
						
						String Check_Child_sql = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
						PreparedStatement ChCh_pstmt = conn.prepareStatement(Check_Child_sql);
						ChCh_pstmt.setString(1, YYMM);
						ChCh_pstmt.setString(2, ComCode);
						ChCh_pstmt.setString(3, MaterialCode);
						ChCh_pstmt.setString(4, PlantCode);
						ChCh_pstmt.setString(5, SlocCode);
						ResultSet ChCh_rs = ChCh_pstmt.executeQuery();
						System.out.println("2. " + Up_H_sql);
						if(!ChCh_rs.next()){
							String To_InC_sql ="INSERT INTO totalmaterial_child VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
							PreparedStatement InC_pstmt = conn.prepareStatement(To_InC_sql);
							if(MovCode.equals("GR") && PlusMinus.equals("Plus")){
								System.out.println(To_InC_sql + " Plus Plus");
								int Nh_Purchase_In = Oh_Purchase_In + Count;
								int Nh_Purchase_Amt = Oh_Purchase_Amt + totalPrice;
								
								Up_H_pstmt.setInt(1, Nh_Purchase_In);
								Up_H_pstmt.setInt(2, Nh_Purchase_Amt);
								Up_H_pstmt.setInt(3, Nh_Purchase_In);
								Up_H_pstmt.setInt(4, Nh_Purchase_Amt);
								Up_H_pstmt.setString(5, YYMM);
								Up_H_pstmt.setString(6, ComCode);
								Up_H_pstmt.setString(7, MaterialCode);
								
								InC_pstmt.setString(1, YYMM); // 년-월
								InC_pstmt.setString(2, ComCode); // 회사코드
								InC_pstmt.setString(3, MaterialCode); // 자재코드
								InC_pstmt.setString(4, PlantCode); // Plant
								InC_pstmt.setString(5, SCode); // sLocation
								InC_pstmt.setInt(6, zero); // 기초 수량
								InC_pstmt.setInt(7, zero); // 기초 금액
								InC_pstmt.setInt(8, Count); // 구매입고 수량
								InC_pstmt.setInt(9, totalPrice); // 구매입고 금액
								InC_pstmt.setInt(10, zero); // 자재 출고 수량
								InC_pstmt.setInt(11, zero); // 자재 출고 금액
								InC_pstmt.setInt(12, zero); // 이체출고입고 수량
								InC_pstmt.setInt(13, zero); // 이체출고입고 금액
								InC_pstmt.setInt(14, Count); // 재고 수량
								InC_pstmt.setInt(15, totalPrice); // 재고 금액
								InC_pstmt.setBigDecimal(16, InvenCost); // 재고 단가
								InC_pstmt.setBigDecimal(17, EmptyCell); // 단수차
								InC_pstmt.setString(18, Unit); //재고 단위
							} else if(MovCode.equals("GR") && PlusMinus.equals("Minus")){
								System.out.println(To_InC_sql + " Minus Minus");
								int Nh_Purchase_In = (Oh_Purchase_In - Count) < 0 ? -(Oh_Purchase_In - Count) : (Oh_Purchase_In - Count);
								int Nh_Purchase_Amt = (Oh_Purchase_Amt - totalPrice) < 0 ? -(Oh_Purchase_Amt - totalPrice) : (Oh_Purchase_Amt - totalPrice);
								
								Up_H_pstmt.setInt(1, Nh_Purchase_In);
								Up_H_pstmt.setInt(2, Nh_Purchase_Amt);
								Up_H_pstmt.setInt(3, Nh_Purchase_In);
								Up_H_pstmt.setInt(4, Nh_Purchase_Amt);
								Up_H_pstmt.setString(5, YYMM);
								Up_H_pstmt.setString(6, ComCode);
								Up_H_pstmt.setString(7, MaterialCode);
								
								InC_pstmt.setString(1, YYMM); // 년-월
								InC_pstmt.setString(2, ComCode); // 회사코드
								InC_pstmt.setString(3, MaterialCode); // 자재코드
								InC_pstmt.setString(4, PlantCode); // Plant
								InC_pstmt.setString(5, SCode); // sLocation
								InC_pstmt.setInt(6, zero); // 기초 수량
								InC_pstmt.setInt(7, zero); // 기초 금액
								InC_pstmt.setInt(8, Count); // 구매입고 수량
								InC_pstmt.setInt(9, totalPrice); // 구매입고 금액
								InC_pstmt.setInt(10, zero); // 자재 출고 수량
								InC_pstmt.setInt(11, zero); // 자재 출고 금액
								InC_pstmt.setInt(12, zero); // 이체출고입고 수량
								InC_pstmt.setInt(13, zero); // 이체출고입고 금액
								InC_pstmt.setInt(14, Count); // 재고 수량
								InC_pstmt.setInt(15, totalPrice); // 재고 금액
								InC_pstmt.setBigDecimal(16, InvenCost); // 재고 단가
								InC_pstmt.setBigDecimal(17, EmptyCell); // 단수차
								InC_pstmt.setString(18, Unit); //재고 단위
							}
							Up_H_pstmt.executeUpdate();
							InC_pstmt.executeUpdate();
						} else{
							String Up_Ch_sql = "UPDATE totalmaterial_child SET Purchase_In = ?, Purchase_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ? WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
							PreparedStatement Up_Ch_pstmt = conn.prepareStatement(Up_Ch_sql);
							
							if(MovCode.equals("GR") && PlusMinus.equals("Plus")){
								System.out.println(Up_Ch_sql + " Plus Plus");
								System.out.println("Oh_Purchase_In : " + Oh_Purchase_In);
								System.out.println("Count : " + Count);
								System.out.println("YYMM : " + YYMM);
								int Nh_Purchase_In = Oh_Purchase_In + Count;
								int Nh_Purchase_Amt = Oh_Purchase_Amt + totalPrice;
								
								Up_H_pstmt.setInt(1, Nh_Purchase_In);
								Up_H_pstmt.setInt(2, Nh_Purchase_Amt);
								Up_H_pstmt.setInt(3, Nh_Purchase_In);
								Up_H_pstmt.setInt(4, Nh_Purchase_Amt);
								Up_H_pstmt.setString(5, YYMM);
								Up_H_pstmt.setString(6, ComCode);
								Up_H_pstmt.setString(7, MaterialCode);
								
								Up_Ch_pstmt.setInt(1, Nh_Purchase_In);
								Up_Ch_pstmt.setInt(2, Nh_Purchase_Amt);
								Up_Ch_pstmt.setInt(3, Nh_Purchase_In);
								Up_Ch_pstmt.setInt(4, Nh_Purchase_Amt);
								Up_Ch_pstmt.setString(5, YYMM);
								Up_Ch_pstmt.setString(6, ComCode);
								Up_Ch_pstmt.setString(7, MaterialCode);
								Up_Ch_pstmt.setString(8, PlantCode);
								Up_Ch_pstmt.setString(9, SCode);
							} else if(MovCode.equals("GR") && PlusMinus.equals("Minus")){
								System.out.println(Up_Ch_sql + " Minus Minus");
								int Nh_Purchase_In = (Oh_Purchase_In - Count) < 0 ? -(Oh_Purchase_In - Count) : (Oh_Purchase_In - Count);
								int Nh_Purchase_Amt = (Oh_Purchase_Amt - totalPrice) < 0 ? -(Oh_Purchase_Amt - totalPrice) : (Oh_Purchase_Amt - totalPrice);
								
								Up_H_pstmt.setInt(1, Nh_Purchase_In);
								Up_H_pstmt.setInt(2, Nh_Purchase_Amt);
								Up_H_pstmt.setInt(3, Nh_Purchase_In);
								Up_H_pstmt.setInt(4, Nh_Purchase_Amt);
								Up_H_pstmt.setString(5, YYMM);
								Up_H_pstmt.setString(6, ComCode);
								Up_H_pstmt.setString(7, MaterialCode);
								
								Up_Ch_pstmt.setInt(1, Nh_Purchase_In);
								Up_Ch_pstmt.setInt(2, Nh_Purchase_Amt);
								Up_Ch_pstmt.setInt(3, Nh_Purchase_In);
								Up_Ch_pstmt.setInt(4, Nh_Purchase_Amt);
								Up_Ch_pstmt.setString(5, YYMM);
								Up_Ch_pstmt.setString(6, ComCode);
								Up_Ch_pstmt.setString(7, MaterialCode);
								Up_Ch_pstmt.setString(8, PlantCode);
								Up_Ch_pstmt.setString(9, SCode);
							}
								Up_H_pstmt.executeUpdate();
								Up_Ch_pstmt.executeUpdate();
						}
					}
					
				} // while(TTS_rs.next()){...}의 끝
			} //while(SD_rs.next()){...}의 끝
		} // if(SD_rs.next() && SD_rs.getRow() == 1 ){...}의 끝
	}catch(SQLException e){
	    e.printStackTrace();
	}finally {
        // 리소스 해제
		try{
			if(H_pstmt != null && !H_pstmt.isClosed()){
				H_pstmt.close();
			}
			if(C_pstmt != null && !C_pstmt.isClosed()){
				C_pstmt.close();
			}
		}catch(SQLException e){
			e.printStackTrace();
		}
    }
	
	response.sendRedirect("MatInput.jsp");
	
%>
</body>
</html>
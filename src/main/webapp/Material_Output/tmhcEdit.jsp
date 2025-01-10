<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../mydbcon.jsp" %>
<%
	String Count = request.getParameter("count"); // 새로 저장하는 출고 수량 1
	String Material = request.getParameter("matCode"); // 출고하는 자재 코드 010101-00001
	String Storage = request.getParameter("Storage"); // 출고 창고 testmk1
	String InputStorage = request.getParameter("Input"); // IR일 때, 입고 창고 V
	String movType = request.getParameter("giir").substring(0, 2); // Movement Type 종류 GI
	String ComCode = request.getParameter("ComPany"); // E2000
	String PlantCode = request.getParameter("Plant"); // 입고 창고 코드 V
	String OutPlant = request.getParameter("OutPlantCd"); // 출고 창고 코드
	String InputComCode = request.getParameter("InputComCd"); //V
	
	LocalDateTime now = LocalDateTime.now();
	String YYMM = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
	
	System.out.println("YYMM : " + YYMM);
	System.out.println("전달받은 수량 : " + Count);
	System.out.println("자재코드 : " + Material);
	System.out.println("MoveCode : " + movType);
	System.out.println("출고 Plant 코드 : " + OutPlant);
	System.out.println("출고 Plant의 Company 코드 : " + ComCode);
	System.out.println("출고 창고 코드 : " + Storage);
	System.out.println("------------------------------------");
	System.out.println("입고 Plant 코드 : " + PlantCode);
	System.out.println("입고할 창고의 Company 코드 : " + InputComCode);
	System.out.println("입고할 창고 코드 : " + InputStorage);
	
	String sql01 = "SELECT * FROM totalMaterial_head WHERE Material = ? AND Com_Code = ? AND YYMM = ?"; 
	String sql02 = "SELECT * FROM totalmaterial_child WHERE StorLoc = ? AND Material = ? AND Com_Code = ? AND YYMM = ? AND Plant = ?"; // 출고 또는 이체출고 시, 출고할 창고
	String sql03 = "SELECT * FROM totalmaterial_child WHERE StorLoc = ? AND Material = ? AND Com_Code = ? AND YYMM = ? AND Plant = ?"; // 이체출고 시, 입고할 창고
	
	String sql01_01 = "UPDATE totalMaterial_head SET Material_Out = ?, Material_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ?, Inventory_UnitPrice = ? WHERE Material = ? AND YYMM = ? AND Com_Code = ?";
	String sql02_01 = "UPDATE totalmaterial_child SET Material_Out = ?, Material_Amt = ?, Inventory_Qty = ?, Inventory_Amt = ? , Inventory_UnitPrice = ? WHERE StorLoc = ? AND Material = ? AND Com_Code = ? AND YYMM = ? AND Plant = ?";
	
	String sql03_01 = "UPDATE totalMaterial_head SET Transfer_InOut = ?, Inventory_Qty = ? WHERE Material = ? AND Com_Code = ? AND YYMM = ?"; // 이체출고할때, 출고할 창고의 Head 수정
	String sql04_01 = "UPDATE totalmaterial_child SET Transfer_InOut = ?, Inventory_Qty = ? WHERE StorLoc = ? AND Material = ? AND Com_Code = ? AND YYMM = ? AND Plant = ?"; // 이체출고할때, 출고할 창고의 Child 수정
	String sql05_01 = "UPDATE totalmaterial_child SET Transfer_InOut = ?, Inventory_Qty = ? WHERE StorLoc = ? AND Material = ? AND Com_Code = ? AND YYMM = ? AND Plant = ?";

	String IR_Insert = "INSERT INTO totalmaterial_child VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	PreparedStatement pstmt01 = conn.prepareStatement(sql01);
	pstmt01.setString(1, Material);
	pstmt01.setString(2, ComCode);
	pstmt01.setString(3, YYMM);
	ResultSet rs01 = pstmt01.executeQuery();
	
	PreparedStatement pstmt02 = conn.prepareStatement(sql02);
	pstmt02.setString(1, Storage);
	pstmt02.setString(2, Material);
	pstmt02.setString(3, ComCode);
	pstmt02.setString(4, YYMM);
	pstmt02.setString(5, OutPlant);
	ResultSet rs02 = pstmt02.executeQuery();
	
	PreparedStatement pstmt03 = conn.prepareStatement(sql03);
	pstmt03.setString(1, InputStorage);
	pstmt03.setString(2, Material);
	pstmt03.setString(3, InputComCode);
	pstmt03.setString(4, YYMM);
	pstmt03.setString(5, PlantCode);
	ResultSet rs03 = pstmt03.executeQuery();

	PreparedStatement pstmt01_01 = conn.prepareStatement(sql01_01);
	PreparedStatement pstmt02_01 = conn.prepareStatement(sql02_01);
	
	PreparedStatement IRnew = conn.prepareStatement(IR_Insert);//여기서부터
	
	PreparedStatement pstmt03_01 = conn.prepareStatement(sql03_01);
	PreparedStatement pstmt04_01 = conn.prepareStatement(sql04_01);
	PreparedStatement pstmt05_01 = conn.prepareStatement(sql05_01);
	
	boolean hasNext = rs03.next();
	boolean updated = false; // 새로 추가한 부분
	try{
	if(movType.equals("GI")){	
		if(rs01.next() && rs02.next()){
			System.out.println("1");
			int New_Count = Integer.parseInt(Count); //String타입으로 전달받은 Count를 Integer로 전환 , 새로 사용한 재료의 수 : 1개			
			/* totalMaterial_head START */
			BigDecimal H_IUprice = rs01.getBigDecimal("Inventory_UnitPrice"); // 재고단가 3.000원
			int H_MatOut = rs01.getInt("Material_Out"); //기존의 저장되어 있는 출고수량 : 1개
			int H_MatOutA = rs01.getInt("Material_Amt"); //기존의 저장되어 있는 출고금액 : 3원
			int H_IQTY = rs01.getInt("Inventory_Qty"); //기존의 저장되어 있는 재고수량 : 162개
			int H_IAMT = rs01.getInt("Inventory_Amt"); //기존의 저장되어 있는 재고금액 : 486원
			
			/* totalMaterial_child START */
			int C_MatOutQTY = rs02.getInt("Material_Out"); // 기존의 저장되어 있는 출고수량 : 1개
			int C_MatOutAMT = rs02.getInt("Material_Amt"); // 기존의 저장되어 있는 출고금액 : 3.000원
			int C_IQTY = rs02.getInt("Inventory_Qty"); // 기존의 저장되어 있는 재고수량 : 162개
			int C_IAMT = rs02.getInt("Inventory_Amt"); // 기존의 저장되어 있는 재고금액 Inventory_UnitPrice : 486원
			BigDecimal C_IUprice = rs02.getBigDecimal("Inventory_UnitPrice"); // 재고 단가 3.000원
			
			int Insert_MatQTY = C_MatOutQTY + New_Count; // Child에 입력할 기존의 출고 수량 + 새로운 출고 수량 -> 출고 수량 1 + 1 = 2개 Ok
			BigDecimal Insert_MatAMT = BigDecimal.valueOf(Insert_MatQTY).multiply(H_IUprice); // Child에 저장할 출고 금액(출고수량 * 재고단가) -> 출고 금액 2 * 3.000 = 6원 Ok
			int Insert_IvenQTY = rs02.getInt("Initial_Qty") + rs02.getInt("Purchase_In") - Insert_MatQTY - rs02.getInt("Transfer_InOut");//C_IQTY - New_Count, 기존의 재고수량 - 출고수량 -> 재고수량 162 - 1 = 161개 Ok 
			BigDecimal Insert_IvenAMT = BigDecimal.valueOf(C_IAMT).subtract(BigDecimal.valueOf(New_Count).multiply(H_IUprice)); // Child에 저장된 재고 금액 - 출고 금액 -> 재고금액 486 - 6 = 480원 X 483 
			H_IUprice = BigDecimal.valueOf(rs01.getInt("Purchase_Amt") + rs01.getInt("Initial_Amt")).divide(BigDecimal.valueOf(rs01.getInt("Initial_Qty") + rs01.getInt("Purchase_In")));
			// (489 + 0) / (0 + 163) = 3.0000
			pstmt01_01.setInt(1, Insert_MatQTY); // 2
			pstmt01_01.setBigDecimal(2, Insert_MatAMT); // 6
			pstmt01_01.setInt(3, Insert_IvenQTY); // 161
			pstmt01_01.setBigDecimal(4, Insert_IvenAMT); // 480 X
			pstmt01_01.setBigDecimal(5, H_IUprice); // 3.000
			pstmt01_01.setString(6, Material); // 010101-00001
			pstmt01_01.setString(7, YYMM);
			pstmt01_01.setString(8, ComCode);
			
			pstmt02_01.setInt(1, Insert_MatQTY);
			pstmt02_01.setBigDecimal(2, Insert_MatAMT);		
			pstmt02_01.setInt(3, Insert_IvenQTY);
			pstmt02_01.setBigDecimal(4, Insert_IvenAMT);
			pstmt02_01.setBigDecimal(5, H_IUprice);
			pstmt02_01.setString(6, Storage);
			pstmt02_01.setString(7, Material);
			pstmt02_01.setString(8, ComCode);
			pstmt02_01.setString(9, YYMM);
			pstmt02_01.setString(10, OutPlant);
			
			pstmt01_01.executeUpdate();
			pstmt02_01.executeUpdate();
			updated = true; // 새로 추가된 부분
			System.out.println("1.1");
		}
	} else if(movType.equals("IR") && (rs01.next() && rs02.next())){
		System.out.println("2");
		if(!hasNext){ // 이체출고 했는데, 입고할 창고(?)의 데이터가 DB에 없는 경우
			System.out.println("2.1");
			BigDecimal H_IUprice = rs01.getBigDecimal("Inventory_UnitPrice"); // 재고단가
			int H_TransInOut = rs01.getInt("Transfer_InOut"); //기존의 저장되어 있는 이체출고수량 : 0개
			int H_TransAMT = rs01.getInt("Transfer_Amt"); //기존의 저장되어 있는 이체출고금액 : 0원
			int H_IQTY = rs01.getInt("Inventory_Qty"); //기존의 저장되어 있는 재고수량 : 163개
			int H_IAMT = rs01.getInt("Inventory_Amt"); //기존의 저장되어 있는 재고금액 : 489원
			
			int C_TransinOut = rs02.getInt("Transfer_InOut"); // 기존의 저장되어 있는 이체출고수량 : 0개
			int C_TransAMT = rs02.getInt("Transfer_Amt"); // 기존의 저장되어 있는 이체출고금액 : 0원
			int C_IQTY = rs02.getInt("Inventory_Qty"); // 기존의 저장되어 있는 재고수량 : 163개
			int C_IAMT = rs02.getInt("Inventory_Amt"); // 기존의 저장되어 있는 재고금액 Inventory_UnitPrice : 489원
			BigDecimal C_IUprice = rs02.getBigDecimal("Inventory_UnitPrice"); // 재고 단가 3.000원
			
			int OutCount = Integer.parseInt(Count); // 출고창고에서 빠져나올 자재 수량 (+)
			int InCount = -Integer.parseInt(Count); // 입고창고로 들어갈 자재 수량 (-)
			
			int Insert_TransQTY = C_TransinOut + OutCount;// 출고창고
			int Out_TransQTY = C_TransinOut + InCount; // 입고창고
			int Up_IQTY = rs02.getInt("Initial_Qty") + rs02.getInt("Purchase_In") - rs02.getInt("Material_Out") - Insert_TransQTY; // 출고창고
			int New_IQTY = Out_TransQTY; // 입고 창고
			int zero = 0;
			BigDecimal Bigzero = BigDecimal.valueOf(zero); 
			
			pstmt03_01.setInt(1, Insert_TransQTY);
			pstmt03_01.setInt(2, Up_IQTY);
			pstmt03_01.setString(3, Material);
			pstmt03_01.setString(4, ComCode);
			pstmt03_01.setString(5, YYMM);
			
			pstmt04_01.setInt(1, Insert_TransQTY);
			pstmt04_01.setInt(2, Up_IQTY);
			pstmt04_01.setString(3, Storage);
			pstmt04_01.setString(4, Material);
			pstmt04_01.setString(5, ComCode);
			pstmt04_01.setString(6, YYMM);
			pstmt04_01.setString(7, OutPlant);
			
			IRnew.setString(1, YYMM);
			IRnew.setString(2, InputComCode);
			IRnew.setString(3, Material);
			IRnew.setString(4, PlantCode);
			IRnew.setString(5, InputStorage);
			IRnew.setInt(6, zero);
			IRnew.setInt(7, zero);
			IRnew.setInt(8, zero);
			IRnew.setInt(9, zero);
			IRnew.setInt(10, zero);
			IRnew.setInt(11, zero);
			IRnew.setInt(12, InCount);
			IRnew.setInt(13, zero);
			IRnew.setInt(14, -InCount);
			IRnew.setInt(15, zero);
			IRnew.setBigDecimal(16, Bigzero);
			IRnew.setBigDecimal(17, Bigzero);
			
			System.out.println("pstmt03_01 쿼리: " + pstmt03_01.toString());
			System.out.println("pstmt04_01 쿼리: " + pstmt04_01.toString());
			System.out.println("IRnew 쿼리: " + IRnew.toString());
			
			pstmt03_01.executeUpdate();
			pstmt04_01.executeUpdate();
			IRnew.executeUpdate();
			updated = true;
			System.out.println("2.2");
		} else if(hasNext){
			System.out.println("3");
			BigDecimal H_IUprice = rs01.getBigDecimal("Inventory_UnitPrice"); // 재고단가
			int H_TransInOut = rs01.getInt("Transfer_InOut"); //기존의 저장되어 있는 이체출고수량 : 1개
			int H_TransAMT = rs01.getInt("Transfer_Amt"); //기존의 저장되어 있는 이체출고금액 : 0원
			int H_IQTY = rs01.getInt("Inventory_Qty"); //기존의 저장되어 있는 재고수량 : 162개
			int H_IAMT = rs01.getInt("Inventory_Amt"); //기존의 저장되어 있는 재고금액 : 489원
			
			int C_TransinOut = rs02.getInt("Transfer_InOut"); // 기존의 저장되어 있는 이체출고수량 : 1개
			int C_TransAMT = rs02.getInt("Transfer_Amt"); // 기존의 저장되어 있는 이체출고금액 : 0원
			int C_IQTY = rs02.getInt("Inventory_Qty"); // 기존의 저장되어 있는 재고수량 : 162개
			int C_IAMT = rs02.getInt("Inventory_Amt"); // 기존의 저장되어 있는 재고금액 Inventory_UnitPrice : 489원
			BigDecimal C_IUprice = rs02.getBigDecimal("Inventory_UnitPrice"); // 재고 단가 3.000원
			
			int T_TransinOut = rs03.getInt("Transfer_InOut"); // 입고한 자재의 갯수 : -1개
			int T_IQTY = rs03.getInt("Inventory_Qty");
			
			int OutCount = Integer.parseInt(Count); // 출고창고에서 빠져나올 자재 수량 (+)
			int InCount = -Integer.parseInt(Count); // 입고창고로 들어갈 자재 수량 (-)
			
			int new_TransOutQTY = C_TransinOut + OutCount;
			int new_TransInQTY = T_TransinOut + InCount;
			int new_IOutQTY = rs02.getInt("Initial_Qty") + rs02.getInt("Purchase_In") - rs02.getInt("Material_Out") - new_TransOutQTY;
			int new_IInQTY = rs03.getInt("Initial_Qty") + rs03.getInt("Purchase_In") - rs03.getInt("Material_Out") - new_TransInQTY;
				if(new_IInQTY < 0){
					new_IInQTY = -new_IInQTY;
				}
			
			pstmt03_01.setInt(1, new_TransOutQTY);
			pstmt03_01.setInt(2, new_IOutQTY);
			pstmt03_01.setString(3, Material);
			pstmt03_01.setString(4, ComCode);
			pstmt03_01.setString(5, YYMM);
			
			pstmt04_01.setInt(1, new_TransOutQTY);
			pstmt04_01.setInt(2, new_IOutQTY);
			pstmt04_01.setString(3, Storage);
			pstmt04_01.setString(4, Material);
			pstmt04_01.setString(5, ComCode);
			pstmt04_01.setString(6, YYMM);
			pstmt04_01.setString(7, OutPlant);
			
			pstmt05_01.setInt(1, new_TransInQTY);
			pstmt05_01.setInt(2, new_IInQTY);
			pstmt05_01.setString(3, InputStorage);
			pstmt05_01.setString(4, Material);
			pstmt05_01.setString(5, InputComCode);
			pstmt05_01.setString(6, YYMM);
			pstmt05_01.setString(7, PlantCode);
			
			
			pstmt03_01.executeUpdate();
			pstmt04_01.executeUpdate();
			pstmt05_01.executeUpdate();
			updated = true;
			System.out.println("3.1");
		}
	}
	}catch(SQLException e){
		e.printStackTrace();
	}finally{
	    if(rs01 != null) {
	        try {
	            rs01.close();
	        } catch(SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    if(rs02 != null) {
	        try {
	            rs02.close();
	        } catch(SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    if(pstmt01 != null) {
	        try {
	            pstmt01.close();
	        } catch(SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    if(pstmt01_01 != null) {
	        try {
	            pstmt01_01.close();
	        } catch(SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    if(pstmt02 != null) {
	        try {
	            pstmt02.close();
	        } catch(SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    if(pstmt02_01 != null) {
	        try {
	            pstmt02_01.close();
	        } catch(SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    if(conn != null) {
	        try {
	            conn.close();
	        } catch(SQLException e) {
	            e.printStackTrace();
	        }
	    }
	}
	/* conn.close(); */
	
	response.setContentType("application/json"); // set the response type as JSON
	response.setCharacterEncoding("UTF-8"); // set the character encoding to UTF-8

	JSONObject jsonResponse = new JSONObject(); // create a new JSON object

	if(updated) { // 변경된 부분
	    jsonResponse.put("status", "success");
	    jsonResponse.put("message", "The database has been successfully updated.");
	} else {
	    jsonResponse.put("status", "error");
	    jsonResponse.put("message", "Failed to update the database.");
	}
	response.getWriter().write(jsonResponse.toJSONString()); // write the JSON response
%>
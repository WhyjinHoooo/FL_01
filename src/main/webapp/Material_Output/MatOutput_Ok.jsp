<%@page import="org.json.JSONObject"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.sql.*"%>
<%@page import="java.io.BufferedReader"%>
<%@ include file="../../mydbcon.jsp" %>
<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
	JSONObject dataToSend = new JSONObject(jsonString.toString());
	System.out.println(dataToSend);
	double UnitPrice = 0.0;
	
	String TxH_Sql = "INSERT INTO storehead VALUES(?,?,?,?,?,?,?,?,?,?)";
	PreparedStatement TxH_Pstmt = conn.prepareStatement(TxH_Sql);
	TxH_Pstmt.setString(1, dataToSend.getString("Doc_Num"));
	TxH_Pstmt.setString(2, dataToSend.getString("Out_date"));
	TxH_Pstmt.setString(3, "Null");
	TxH_Pstmt.setString(4, "Null");
	TxH_Pstmt.setString(5, dataToSend.getString("PlantCode"));
	TxH_Pstmt.setString(6, dataToSend.getString("StorageCode"));
	TxH_Pstmt.setString(7, "Null");
	TxH_Pstmt.setString(8, dataToSend.getString("Out_date"));
	
	String CountSql = "SELECT COUNT(Doc_Num) as Total FROM output_temtable WHERE Doc_Num = ?";
	PreparedStatement CountPstmt = conn.prepareStatement(CountSql);
	CountPstmt.setString(1, dataToSend.getString("Doc_Num"));
	ResultSet CountRs = CountPstmt.executeQuery();
	if(CountRs.next()){
		TxH_Pstmt.setString(9, CountRs.getString("Total"));
	}
	TxH_Pstmt.setString(10, dataToSend.getString("UserID"));
	TxH_Pstmt.executeUpdate();
	
	String InfoSql = "SELECT * FROM output_temtable WHERE Doc_Num = ?";
	PreparedStatement InfoPstmt = conn.prepareStatement(InfoSql);
	InfoPstmt.setString(1, dataToSend.getString("Doc_Num"));
	ResultSet InfoRs = InfoPstmt.executeQuery();
	while(InfoRs.next()){
		String TxC_Sql = "INSERT INTO storechild VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement TxC_Pstmt = conn.prepareStatement(TxC_Sql);
		TxC_Pstmt.setString(1, InfoRs.getString("KeyValue"));
		TxC_Pstmt.setString(2, dataToSend.getString("Out_date"));
		TxC_Pstmt.setString(3, InfoRs.getString("Doc_Num"));
		TxC_Pstmt.setString(4, InfoRs.getString("GINo"));
		TxC_Pstmt.setString(5, InfoRs.getString("MatCode"));
		TxC_Pstmt.setString(6, InfoRs.getString("MatDes"));
		
		String TypeSql = "SELECT * FROM purprice WHERE MatCode = ?";
		PreparedStatement TypePstmt = conn.prepareStatement(TypeSql);
		TypePstmt.setString(1, InfoRs.getString("MatCode"));
		ResultSet TypeRs = TypePstmt.executeQuery();
		if(TypeRs.next()){
			TxC_Pstmt.setString(7, TypeRs.getString("MatType"));
		}
		
		TxC_Pstmt.setString(8, dataToSend.getString("movCode"));
		TxC_Pstmt.setString(9, InfoRs.getString("OutCount"));
		TxC_Pstmt.setString(10, InfoRs.getString("OrderUnit"));
		
		String PriceSql = "SELECT * FROM purprice WHERE MatCode = ?";
		PreparedStatement Pricepstmt = conn.prepareStatement(PriceSql);
		Pricepstmt.setString(1, InfoRs.getString("MatCode"));
		ResultSet PriceRs = Pricepstmt.executeQuery();
		if(PriceRs.next()){
			TxC_Pstmt.setString(12, PriceRs.getString("PurCurr"));
			TxC_Pstmt.setString(14, PriceRs.getString("PurCurr"));
		}
		
		TxC_Pstmt.setDouble(11, 0);
		TxC_Pstmt.setDouble(13, 0);
		
		TxC_Pstmt.setString(15, null);
		TxC_Pstmt.setString(16, null);
		TxC_Pstmt.setString(17, InfoRs.getString("MatLotNo"));
		TxC_Pstmt.setString(18, InfoRs.getString("MakeDate"));
		TxC_Pstmt.setString(19, InfoRs.getString("DeadDete"));
		TxC_Pstmt.setString(20, InfoRs.getString("StorageCode"));
		TxC_Pstmt.setString(21, null);
		TxC_Pstmt.setString(22, InfoRs.getString("PlantCode"));
		TxC_Pstmt.setString(23, dataToSend.getString("UserID"));
		TxC_Pstmt.executeUpdate();
		
		String GIC_Scan_Sql = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
		String GIH_Scan_Sql = "SELECT * FROM totalmaterial_head WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
		PreparedStatement GIC_Scan_Pstmt = conn.prepareStatement(GIC_Scan_Sql);
		GIC_Scan_Pstmt.setString(1, dataToSend.getString("Out_date").substring(0,7));
		GIC_Scan_Pstmt.setString(2, dataToSend.getString("ComCode"));
		GIC_Scan_Pstmt.setString(3, InfoRs.getString("MatCode"));
		GIC_Scan_Pstmt.setString(4, InfoRs.getString("PlantCode"));
		GIC_Scan_Pstmt.setString(5, InfoRs.getString("StorageCode"));
		ResultSet GIC_Scan_Rs = GIC_Scan_Pstmt.executeQuery();
		
		PreparedStatement GIH_Scan_Pstmt = conn.prepareStatement(GIH_Scan_Sql);
		GIH_Scan_Pstmt.setString(1, dataToSend.getString("Out_date").substring(0,7));
		GIH_Scan_Pstmt.setString(2, dataToSend.getString("ComCode"));
		GIH_Scan_Pstmt.setString(3, InfoRs.getString("MatCode"));
		ResultSet GIH_Scan_Rs = GIH_Scan_Pstmt.executeQuery();
		if(dataToSend.getString("movCode").substring(0, 2).equals("GI")){
			switch(InfoRs.getString("PlusMinus")){
			case "Plus":
				if(GIC_Scan_Rs.next() && GIH_Scan_Rs.next()){
					int OUT_C_Initial_Qty = GIC_Scan_Rs.getInt("Initial_Qty");
					int OUT_C_Purchase_In = GIC_Scan_Rs.getInt("Purchase_In");
					int OUT_C_Material_Out = GIC_Scan_Rs.getInt("Material_Out");
					int OUT_C_Transfer_InOut = GIC_Scan_Rs.getInt("Transfer_InOut");
					int New_C_Inventory_Qty = 0;
				
					OUT_C_Material_Out += InfoRs.getInt("OutCount");
					New_C_Inventory_Qty = OUT_C_Initial_Qty + OUT_C_Purchase_In - OUT_C_Material_Out + OUT_C_Transfer_InOut;
					
					int OUT_H_Initial_Qty = GIH_Scan_Rs.getInt("Initial_Qty");
					int OUT_H_Purchase_In = GIH_Scan_Rs.getInt("Purchase_In");
					int OUT_H_Material_Out = GIH_Scan_Rs.getInt("Material_Out");
					int OUT_H_Transfer_InOut = GIH_Scan_Rs.getInt("Transfer_InOut");
					int New_H_Inventory_Qty = 0;
				
					OUT_H_Material_Out += InfoRs.getInt("OutCount");
					New_H_Inventory_Qty = OUT_H_Initial_Qty + OUT_H_Purchase_In - OUT_H_Material_Out + OUT_H_Transfer_InOut;
					
					String GIC_Up_Sql = "UPDATE totalmaterial_child SET "
		                    + "Material_Out = ?, Inventory_Qty = ? "
		                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
					PreparedStatement GIC_Up_Pstmt = conn.prepareStatement(GIC_Up_Sql);
					GIC_Up_Pstmt.setInt(1, OUT_C_Material_Out);
					GIC_Up_Pstmt.setInt(2, New_C_Inventory_Qty);
					GIC_Up_Pstmt.setString(3, dataToSend.getString("Out_date").substring(0,7));
					GIC_Up_Pstmt.setString(4, dataToSend.getString("ComCode"));
					GIC_Up_Pstmt.setString(5, InfoRs.getString("MatCode"));
					GIC_Up_Pstmt.setString(6, InfoRs.getString("PlantCode"));
					GIC_Up_Pstmt.setString(7, InfoRs.getString("StorageCode"));
					GIC_Up_Pstmt.executeUpdate();
					
					String GIH_Up_Sql = "UPDATE totalmaterial_head SET "
		                    + "Material_Out = ?, Inventory_Qty = ? "
		                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
					PreparedStatement GIH_Up_Pstmt = conn.prepareStatement(GIH_Up_Sql);
					GIH_Up_Pstmt.setInt(1, OUT_H_Material_Out);
					GIH_Up_Pstmt.setInt(2, New_H_Inventory_Qty);
					GIH_Up_Pstmt.setString(3, dataToSend.getString("Out_date").substring(0,7));
					GIH_Up_Pstmt.setString(4, dataToSend.getString("ComCode"));
					GIH_Up_Pstmt.setString(5, InfoRs.getString("MatCode"));
					GIH_Up_Pstmt.executeUpdate();
				}
				break;
			case "Minus":
				if(GIC_Scan_Rs.next() && GIH_Scan_Rs.next()){
					int OUT_C_Initial_Qty = GIC_Scan_Rs.getInt("Initial_Qty");
					int OUT_C_Purchase_In = GIC_Scan_Rs.getInt("Purchase_In");
					int OUT_C_Material_Out = GIC_Scan_Rs.getInt("Material_Out");
					int OUT_C_Transfer_InOut = GIC_Scan_Rs.getInt("Transfer_InOut");
					int New_C_Inventory_Qty = 0;
					
					if(OUT_C_Material_Out == 0){
						
						break;
					}
				
					OUT_C_Material_Out -= InfoRs.getInt("OutCount");
					New_C_Inventory_Qty = OUT_C_Initial_Qty + OUT_C_Purchase_In - OUT_C_Material_Out + OUT_C_Transfer_InOut;
					
					int OUT_H_Initial_Qty = GIH_Scan_Rs.getInt("Initial_Qty");
					int OUT_H_Purchase_In = GIH_Scan_Rs.getInt("Purchase_In");
					int OUT_H_Material_Out = GIH_Scan_Rs.getInt("Material_Out");
					int OUT_H_Transfer_InOut = GIH_Scan_Rs.getInt("Transfer_InOut");
					int New_H_Inventory_Qty = 0;
				
					OUT_H_Material_Out -= InfoRs.getInt("OutCount");
					New_H_Inventory_Qty = OUT_H_Initial_Qty + OUT_H_Purchase_In - OUT_H_Material_Out + OUT_H_Transfer_InOut;
					
					String GIC_Up_Sql = "UPDATE totalmaterial_child SET "
		                    + "Material_Out = ?, Inventory_Qty = ? "
		                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
					PreparedStatement GIC_Up_Pstmt = conn.prepareStatement(GIC_Up_Sql);
					GIC_Up_Pstmt.setInt(1, OUT_C_Material_Out);
					GIC_Up_Pstmt.setInt(2, New_C_Inventory_Qty);
					GIC_Up_Pstmt.setString(3, dataToSend.getString("Out_date").substring(0,7));
					GIC_Up_Pstmt.setString(4, dataToSend.getString("ComCode"));
					GIC_Up_Pstmt.setString(5, InfoRs.getString("MatCode"));
					GIC_Up_Pstmt.setString(6, InfoRs.getString("PlantCode"));
					GIC_Up_Pstmt.setString(7, InfoRs.getString("StorageCode"));
					GIC_Up_Pstmt.executeUpdate();
					
					String GIH_Up_Sql = "UPDATE totalmaterial_head SET "
		                    + "Material_Out = ?, Inventory_Qty = ? "
		                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
					PreparedStatement GIH_Up_Pstmt = conn.prepareStatement(GIH_Up_Sql);
					GIH_Up_Pstmt.setInt(1, OUT_H_Material_Out);
					GIH_Up_Pstmt.setInt(2, New_H_Inventory_Qty);
					GIH_Up_Pstmt.setString(3, dataToSend.getString("Out_date").substring(0,7));
					GIH_Up_Pstmt.setString(4, dataToSend.getString("ComCode"));
					GIH_Up_Pstmt.setString(5, InfoRs.getString("MatCode"));
					GIH_Up_Pstmt.executeUpdate();
				}
				break;
			}
		}else{
			String IRB_Scan_Sql = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
			String IRA_Scan_Sql = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND StorLoc = ?";
			
			String B_MatCode = InfoRs.getString("MatCode"); // B : Before
			String B_StCode = InfoRs.getString("StorageCode");
			String B_PlaCode = InfoRs.getString("PlantCode");
			String B_Out_date = InfoRs.getString("Out_date").substring(0, 7);
			String B_ComCode = InfoRs.getString("ComCode");
			String A_StCode = InfoRs.getString("InputStorage"); // A : After
			
			PreparedStatement IRB_Scan_Pstmt = conn.prepareStatement(IRB_Scan_Sql);
			IRB_Scan_Pstmt.setString(1, B_Out_date);
			IRB_Scan_Pstmt.setString(2, B_ComCode);
			IRB_Scan_Pstmt.setString(3, B_MatCode);
			IRB_Scan_Pstmt.setString(4, B_PlaCode);
			IRB_Scan_Pstmt.setString(5, B_StCode);
			ResultSet IRB_Scan_Rs = IRB_Scan_Pstmt.executeQuery();
			
			PreparedStatement IRA_Scan_Pstmt = conn.prepareStatement(IRA_Scan_Sql);
			IRA_Scan_Pstmt.setString(1, B_Out_date);
			IRA_Scan_Pstmt.setString(2, B_ComCode);
			IRA_Scan_Pstmt.setString(3, B_MatCode);
			IRA_Scan_Pstmt.setString(4, A_StCode);
			ResultSet IRA_Scan_Rs = IRA_Scan_Pstmt.executeQuery();
			
			if(IRB_Scan_Rs.next() && IRA_Scan_Rs.next()){
				int B_Initial_Qty = IRB_Scan_Rs.getInt("Initial_Qty");
				int B_Purchase_In = IRB_Scan_Rs.getInt("Purchase_In");
				double B_Purchase_Amt = IRB_Scan_Rs.getInt("Purchase_Amt");
				int B_Material_Out = IRB_Scan_Rs.getInt("Material_Out");
				int B_Transfer_InOut = IRB_Scan_Rs.getInt("Transfer_InOut");
				B_Transfer_InOut -= InfoRs.getInt("OutCount");
				
				int A_Initial_Qty = IRA_Scan_Rs.getInt("Initial_Qty");
				int A_Purchase_In = IRA_Scan_Rs.getInt("Purchase_In");
				double A_Purchase_Amt = IRA_Scan_Rs.getInt("Purchase_Amt");
				int A_Material_Out = IRA_Scan_Rs.getInt("Material_Out");
				int A_Transfer_InOut = IRA_Scan_Rs.getInt("Transfer_InOut");
				A_Transfer_InOut += InfoRs.getInt("OutCount");
				
				String IRB_Up_Sql = "UPDATE totalmaterial_child SET "
	                    + "Transfer_InOut = ?, Inventory_Qty = ? "
	                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
				PreparedStatement IRB_Up_Pstmt = conn.prepareStatement(IRB_Up_Sql);
				IRB_Up_Pstmt.setInt(1, B_Transfer_InOut);
				IRB_Up_Pstmt.setInt(2, B_Initial_Qty + B_Purchase_In - B_Material_Out + B_Transfer_InOut);
				IRB_Up_Pstmt.setString(3, B_Out_date);
				IRB_Up_Pstmt.setString(4, B_ComCode);
				IRB_Up_Pstmt.setString(5, B_MatCode);
				IRB_Up_Pstmt.setString(6, B_PlaCode);
				IRB_Up_Pstmt.setString(7, B_StCode);
				IRB_Up_Pstmt.executeUpdate();
				
				String IRA_Up_Sql = "UPDATE totalmaterial_child SET "
	                    + "Transfer_InOut = ?, Inventory_Qty = ? "
	                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND StorLoc = ?";
				PreparedStatement IRA_Up_Pstmt = conn.prepareStatement(IRA_Up_Sql);
				IRA_Up_Pstmt.setInt(1, A_Transfer_InOut);
				IRA_Up_Pstmt.setInt(2, A_Initial_Qty + A_Purchase_In - A_Material_Out + A_Transfer_InOut);
				IRA_Up_Pstmt.setString(3, B_Out_date);
				IRA_Up_Pstmt.setString(4, B_ComCode);
				IRA_Up_Pstmt.setString(5, B_MatCode);
				IRA_Up_Pstmt.setString(6, A_StCode);
				IRA_Up_Pstmt.executeUpdate();
			}
		}
	}
	
	out.println("Success");
	}catch(Exception e){
		e.printStackTrace();
	}
%>
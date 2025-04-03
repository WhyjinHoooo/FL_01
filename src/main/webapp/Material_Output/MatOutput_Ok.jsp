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
			UnitPrice = PriceRs.getInt("PurPrices") / Double.parseDouble(PriceRs.getString("PriceBaseQty")) ;
			TxC_Pstmt.setString(12, PriceRs.getString("PurCurr"));
			TxC_Pstmt.setString(14, PriceRs.getString("PurCurr"));
		}
		
		TxC_Pstmt.setDouble(11, UnitPrice * Integer.parseInt(InfoRs.getString("OutCount")));
		
		TxC_Pstmt.setDouble(13, UnitPrice * Integer.parseInt(InfoRs.getString("OutCount")));
		
		TxC_Pstmt.setString(15, "Null");
		TxC_Pstmt.setString(16, "Null");
		TxC_Pstmt.setString(17, InfoRs.getString("MatLotNo"));
		TxC_Pstmt.setString(18, InfoRs.getString("MakeDate"));
		TxC_Pstmt.setString(19, InfoRs.getString("DeadDete"));
		TxC_Pstmt.setString(20, InfoRs.getString("StorageCode"));
		TxC_Pstmt.setString(21, "Null");
		TxC_Pstmt.setString(22, InfoRs.getString("PlantCode"));
		TxC_Pstmt.setString(23, dataToSend.getString("UserID"));
		TxC_Pstmt.executeUpdate();
		
		if(dataToSend.getString("movCode").substring(0, 2).equals("GI")){
			switch(InfoRs.getString("PlusMinus")){
			case "Plus":
				String OTH_Scan_Sql = "SELECT * FROM totalmaterial_head WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
				PreparedStatement OTH_Scan_Pstmt = conn.prepareStatement(OTH_Scan_Sql);
				OTH_Scan_Pstmt.setString(1, dataToSend.getString("Out_date").substring(0,7));
				OTH_Scan_Pstmt.setString(2, dataToSend.getString("ComCode"));
				OTH_Scan_Pstmt.setString(3, InfoRs.getString("MatCode"));
				ResultSet OTH_Scan_Rs = OTH_Scan_Pstmt.executeQuery();
				if(OTH_Scan_Rs.next()){
					int Material_Out = OTH_Scan_Rs.getInt("Material_Out") + InfoRs.getInt("OutCount");
					double Material_Amt = OTH_Scan_Rs.getDouble("Material_Amt") + UnitPrice * Integer.parseInt(InfoRs.getString("OutCount"));
					
					int Transfer_InOut = OTH_Scan_Rs.getInt("Transfer_InOut");
					double Transfer_Amt = OTH_Scan_Rs.getDouble("Transfer_Amt");
					
					int Inventory_Qty = OTH_Scan_Rs.getInt("Inventory_Qty") - Material_Out;
					double Inventory_Amt = OTH_Scan_Rs.getDouble("Inventory_Amt") - Material_Amt;
					
					String OTH_Up_Sql = "UPDATE totalmaterial_head SET "
		                    + "Material_Out = ?, Material_Amt = ?, "
		                    + "Transfer_InOut = ?, Transfer_Amt = ?, "
		                    + "Inventory_Qty = ?, Inventory_Amt = ?, Inventory_UnitPrice = ?  "
		                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
					
					String OTC_Up_Sql = "UPDATE totalmaterial_child SET "
		                    + "Material_Out = ?, Material_Amt = ?, "
		                    + "Transfer_InOut = ?, Transfer_Amt = ?, "
		                    + "Inventory_Qty = ?, Inventory_Amt = ?, Inventory_UnitPrice = ? "
		                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
					
					PreparedStatement OTH_Up_Pstmt = conn.prepareStatement(OTH_Up_Sql);
					OTH_Up_Pstmt.setInt(1, Material_Out);
					OTH_Up_Pstmt.setString(2, null);
					OTH_Up_Pstmt.setInt(3, Transfer_InOut);
					OTH_Up_Pstmt.setString(4, null);
					OTH_Up_Pstmt.setInt(5, Inventory_Qty);
					OTH_Up_Pstmt.setString(6, null);
					OTH_Up_Pstmt.setDouble(7, Inventory_Amt / Inventory_Qty);
					OTH_Up_Pstmt.setString(8, dataToSend.getString("Out_date").substring(0,7));
					OTH_Up_Pstmt.setString(9, dataToSend.getString("ComCode"));
					OTH_Up_Pstmt.setString(10, InfoRs.getString("MatCode"));
					OTH_Up_Pstmt.executeUpdate();
					
					PreparedStatement OTC_Up_Pstmt = conn.prepareStatement(OTC_Up_Sql);
					OTC_Up_Pstmt.setInt(1, Material_Out);
					OTC_Up_Pstmt.setDouble(2, Material_Amt);
					OTC_Up_Pstmt.setInt(3, Transfer_InOut);
					OTC_Up_Pstmt.setDouble(4, Transfer_Amt);
					OTC_Up_Pstmt.setInt(5, Inventory_Qty);
					OTC_Up_Pstmt.setDouble(6, Inventory_Amt);
					OTC_Up_Pstmt.setDouble(7, Inventory_Amt / Inventory_Qty);
					OTC_Up_Pstmt.setString(8, dataToSend.getString("Out_date").substring(0,7));
					OTC_Up_Pstmt.setString(9, dataToSend.getString("ComCode"));
					OTC_Up_Pstmt.setString(10, InfoRs.getString("MatCode"));
					OTC_Up_Pstmt.setString(11, InfoRs.getString("PlantCode"));
					OTC_Up_Pstmt.setString(12, InfoRs.getString("StorageCode"));
					OTC_Up_Pstmt.executeUpdate();
					break;
				}
			}
		}else{
			String OTC_Scan_Sql = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
			String B_MatCode = InfoRs.getString("MatCode"); // B : Before
			String B_StCode = InfoRs.getString("StorageCode");
			String B_PlaCode = InfoRs.getString("PlantCode");
			String B_Out_date = InfoRs.getString("Out_date").substring(0, 7);
			String B_ComCode = InfoRs.getString("ComCode");
			String A_StCode = InfoRs.getString("InputStorage"); // A : After
			
			Pricepstmt.setString(1, InfoRs.getString("MatCode"));
			PriceRs = Pricepstmt.executeQuery();
			if(PriceRs.next()){
				UnitPrice = PriceRs.getDouble("PurPrices") ;
			}
			PreparedStatement OTC_Scan_Pstmt = conn.prepareStatement(OTC_Scan_Sql);
			OTC_Scan_Pstmt.setString(1, B_Out_date);
			OTC_Scan_Pstmt.setString(2, B_ComCode);
			OTC_Scan_Pstmt.setString(3, B_MatCode);
			OTC_Scan_Pstmt.setString(4, B_PlaCode);
			OTC_Scan_Pstmt.setString(5, B_StCode);
			ResultSet OTC_Scan_Rs = OTC_Scan_Pstmt.executeQuery();
			if(OTC_Scan_Rs.next()){
				int B_Purchase_In = OTC_Scan_Rs.getInt("Purchase_In");
				double B_Purchase_Amt = OTC_Scan_Rs.getInt("Purchase_Amt");
				
				int B_Material_Out = OTC_Scan_Rs.getInt("Material_Out");
				double B_Material_Amt = OTC_Scan_Rs.getInt("Material_Amt");

				int B_Transfer_InOut = OTC_Scan_Rs.getInt("Transfer_InOut");
				double B_Transfer_Amt = OTC_Scan_Rs.getInt("Transfer_InOut");
				
				B_Transfer_InOut -= InfoRs.getInt("OutCount");
				B_Transfer_Amt -= InfoRs.getInt("OutCount") * UnitPrice;
			}
			
		}
	}
	
	out.println("Success");
	}catch(Exception e){
		e.printStackTrace();
	}
%>
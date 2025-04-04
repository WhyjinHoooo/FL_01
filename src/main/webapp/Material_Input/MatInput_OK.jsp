<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.SQLException"%>
<%@page import="javax.imageio.plugins.tiff.ExifParentTIFFTagSet"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.math.RoundingMode"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../mydbcon.jsp" %>
<%
	StringBuilder jsonString = new StringBuilder();
	String line = null;
	try (BufferedReader reader = request.getReader()) {
	    while ((line = reader.readLine()) != null) {
	        jsonString.append(line);
	    }
	}
	try{
	JSONObject HeaderInfoList = new JSONObject(jsonString.toString());
	System.out.println("HeaderInfoList : " + HeaderInfoList);
	double UnitPrice = 0.0;
	int Quantity = 0;
	double TotalPrice = 0.0;
	int InitialCount = 0;
	String Tem_Sql = "SELECT COUNT(*) as OrderQuantity FROM input_temtable WHERE DocNum = ?";
	PreparedStatement Tem_Pstmt = conn.prepareStatement(Tem_Sql);
	Tem_Pstmt.setString(1, HeaderInfoList.getString("MatNum"));
	ResultSet Tem_Rs = Tem_Pstmt.executeQuery();
	
	String PriceSql = "SELECT * FROM purprice WHERE MatCode = ?";
	PreparedStatement Pricepstmt = conn.prepareStatement(PriceSql);
	ResultSet PriceRs = null;
	while(Tem_Rs.next()){
		int Limit = Tem_Rs.getInt("OrderQuantity");
		String SeaSql = "SELECT * FROM input_temtable WHERE DocNum = ?";
		PreparedStatement SeaPstmt = conn.prepareStatement(SeaSql);
		SeaPstmt.setString(1, HeaderInfoList.getString("MatNum"));
		ResultSet SeaRs = SeaPstmt.executeQuery();
		if(InitialCount < Limit){
			while(SeaRs.next()){
				String SCI_Sql = "INSERT INTO storechild VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement DCI_Pstmt = conn.prepareStatement(SCI_Sql);
				System.out.println("1. : " + SeaRs.getString("KeyValue"));
				DCI_Pstmt.setString(1, SeaRs.getString("KeyValue"));
				DCI_Pstmt.setString(2, HeaderInfoList.getString("date"));
				DCI_Pstmt.setString(3, SeaRs.getString("DocNum"));
				DCI_Pstmt.setString(4, SeaRs.getString("ItemNum"));
				DCI_Pstmt.setString(5, SeaRs.getString("MatCode"));
				DCI_Pstmt.setString(6, SeaRs.getString("MatDes"));
				DCI_Pstmt.setString(7, SeaRs.getString("MatType"));
				DCI_Pstmt.setString(8, SeaRs.getString("MovCode"));
				DCI_Pstmt.setString(9, SeaRs.getString("Count"));
				DCI_Pstmt.setString(10, SeaRs.getString("Unit"));
				
				Pricepstmt = conn.prepareStatement(PriceSql);
				Pricepstmt.setString(1, SeaRs.getString("MatCode"));
				PriceRs = Pricepstmt.executeQuery();
				if(PriceRs.next()){
					UnitPrice = PriceRs.getInt("PurPrices") / Double.parseDouble(PriceRs.getString("PriceBaseQty")) ;
				}
				DCI_Pstmt.setDouble(11, UnitPrice * Integer.parseInt(SeaRs.getString("Count")));
				DCI_Pstmt.setString(12, SeaRs.getString("Money"));
				DCI_Pstmt.setDouble(13, UnitPrice * Integer.parseInt(SeaRs.getString("Count")));
				DCI_Pstmt.setString(14, SeaRs.getString("Money"));
				DCI_Pstmt.setString(15, SeaRs.getString("VenCode"));
				DCI_Pstmt.setString(16, SeaRs.getString("PurOrdNo"));
				DCI_Pstmt.setString(17, SeaRs.getString("LotName"));
				DCI_Pstmt.setString(18, SeaRs.getString("MadeDate"));
				DCI_Pstmt.setString(19, SeaRs.getString("DeadDate"));
				DCI_Pstmt.setString(20, SeaRs.getString("SLocCode"));
				DCI_Pstmt.setString(21, "Null");
				DCI_Pstmt.setString(22, SeaRs.getString("PlantCode"));
				System.out.println(HeaderInfoList.getString("UserID"));
				DCI_Pstmt.setString(23, HeaderInfoList.getString("UserID"));
				DCI_Pstmt.executeUpdate();
				
				String POC_Sacn_Sql = "SELECT * FROM request_ord WHERE ActNumPO = ? AND MatCode = ?";
				PreparedStatement POC_Sacn_Pstmt = conn.prepareStatement(POC_Sacn_Sql);
				POC_Sacn_Pstmt.setString(1, SeaRs.getString("PurOrdNo"));
				POC_Sacn_Pstmt.setString(2, SeaRs.getString("MatCode"));
				ResultSet POC_Scan_Rs = POC_Sacn_Pstmt.executeQuery();
				if(POC_Scan_Rs.next()){
					int Count = POC_Scan_Rs.getInt("RecSumQty") + SeaRs.getInt("Count");
					int PO_Rem = POC_Scan_Rs.getInt("RegidQty") - SeaRs.getInt("Count");
					
					String POC_Up_Sql = "UPDATE request_ord SET RecSumQty = ?, RegidQty = ? WHERE ActNumPO = ? AND MatCode = ?";
					PreparedStatement POC_Up_Pstmt = conn.prepareStatement(POC_Up_Sql);
					POC_Up_Pstmt.setInt(1, Count);
					POC_Up_Pstmt.setInt(2, PO_Rem);
					POC_Up_Pstmt.setString(3, SeaRs.getString("PurOrdNo"));
					POC_Up_Pstmt.setString(4, SeaRs.getString("MatCode"));
					POC_Up_Pstmt.executeUpdate();
				}
				InitialCount++;
			}
		}
	}
	
	PriceRs.beforeFirst();
	int AddQuantity = 0; 
	String Scan_Sql = "SELECT * FROM input_temtable WHERE DocNum = ?";
	PreparedStatement Scan_Pstmt = conn.prepareStatement(Scan_Sql);
	Scan_Pstmt.setString(1, HeaderInfoList.getString("MatNum"));
	ResultSet Scan_Rs = Scan_Pstmt.executeQuery();
	while(Scan_Rs.next()){
		String ComCode = HeaderInfoList.getString("ComCode");
		String DateCode = HeaderInfoList.getString("date").substring(0,7);
		String PlantCode = HeaderInfoList.getString("PlantCode");
		String MatCode = Scan_Rs.getString("MatCode");
		String MatDes = Scan_Rs.getString("MatDes");
		String StgCode = Scan_Rs.getString("SLocCode");
		
		String OTH_Scan_Sql = "SELECT * FROM totalmaterial_head WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
		PreparedStatement OTH_Scan_Pstmt = conn.prepareStatement(OTH_Scan_Sql);
		OTH_Scan_Pstmt.setString(1, DateCode);
		OTH_Scan_Pstmt.setString(2, ComCode);
		OTH_Scan_Pstmt.setString(3, MatCode);
		ResultSet OTH_Scan_Rs = OTH_Scan_Pstmt.executeQuery();
		if(!OTH_Scan_Rs.next()){
			String OTH_Insert_Sql = "INSERT INTO totalmaterial_head VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement OTH_Insert_Pstmt = conn.prepareStatement(OTH_Insert_Sql);
			OTH_Insert_Pstmt.setString(1, DateCode);
			OTH_Insert_Pstmt.setString(2, ComCode);
			OTH_Insert_Pstmt.setString(3, MatCode);
			OTH_Insert_Pstmt.setString(4, MatDes);
			OTH_Insert_Pstmt.setString(5, "N/A");
			OTH_Insert_Pstmt.setString(6, "N/A");
			OTH_Insert_Pstmt.setString(7, "0");
			OTH_Insert_Pstmt.setString(8, "0");
			
			Pricepstmt = conn.prepareStatement(PriceSql);
			
			Pricepstmt.setString(1, MatCode);
			PriceRs = Pricepstmt.executeQuery();
			if(PriceRs.next()){
				UnitPrice = PriceRs.getDouble("PricePerUnit");
			}
			OTH_Insert_Pstmt.setString(9, Scan_Rs.getString("Count"));
			OTH_Insert_Pstmt.setDouble(10, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")));
			OTH_Insert_Pstmt.setString(11, "0");
			OTH_Insert_Pstmt.setString(12, "0");
			OTH_Insert_Pstmt.setString(13, "0");
			OTH_Insert_Pstmt.setString(14, "0");
			OTH_Insert_Pstmt.setString(15, Scan_Rs.getString("Count"));
			OTH_Insert_Pstmt.setDouble(16, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")));
			OTH_Insert_Pstmt.setDouble(17, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")) / Integer.parseInt(Scan_Rs.getString("Count")));
			OTH_Insert_Pstmt.setDouble(18, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")) / Integer.parseInt(Scan_Rs.getString("Count")));
			OTH_Insert_Pstmt.executeUpdate();
			
			String OTC_Insert_Sql = "INSERT INTO totalmaterial_child VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement OTC_Insert_Pstmt = conn.prepareStatement(OTC_Insert_Sql);
			OTC_Insert_Pstmt.setString(1, DateCode);
			OTC_Insert_Pstmt.setString(2, ComCode);
			OTC_Insert_Pstmt.setString(3, MatCode);
			OTC_Insert_Pstmt.setString(4, MatDes);
			OTC_Insert_Pstmt.setString(5, PlantCode);
			OTC_Insert_Pstmt.setString(6, StgCode);
			OTC_Insert_Pstmt.setString(7, "0");
			OTC_Insert_Pstmt.setString(8, "0");
			OTC_Insert_Pstmt.setString(9, Scan_Rs.getString("Count"));
			OTC_Insert_Pstmt.setDouble(10, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")));
			OTC_Insert_Pstmt.setString(11, "0");
			OTC_Insert_Pstmt.setString(12, "0");
			OTC_Insert_Pstmt.setString(13, "0");
			OTC_Insert_Pstmt.setString(14, "0");
			OTC_Insert_Pstmt.setString(15, Scan_Rs.getString("Count"));
			OTC_Insert_Pstmt.setDouble(16, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")));
			OTC_Insert_Pstmt.setDouble(17, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")) / Integer.parseInt(Scan_Rs.getString("Count")));
			OTC_Insert_Pstmt.setDouble(18, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")) / Integer.parseInt(Scan_Rs.getString("Count")));
			OTC_Insert_Pstmt.executeUpdate();
		}else{
			String OTC_Scan_Sql = "SELECT * FROM totalmaterial_child WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
			PreparedStatement OTC_Scan_Pstmt = conn.prepareStatement(OTC_Scan_Sql);
			OTC_Scan_Pstmt.setString(1, DateCode);
			OTC_Scan_Pstmt.setString(2, ComCode);
			OTC_Scan_Pstmt.setString(3, MatCode);
			OTC_Scan_Pstmt.setString(4, PlantCode);
			OTC_Scan_Pstmt.setString(5, StgCode);
			ResultSet OTC_Scan_Rs = OTC_Scan_Pstmt.executeQuery();
			if(OTC_Scan_Rs.next()){
				int Purchase_In = OTC_Scan_Rs.getInt("Purchase_In");
				double Purchase_Amt = OTC_Scan_Rs.getDouble("Purchase_Amt");
				
				int Material_Out = OTC_Scan_Rs.getInt("Material_Out");
				double Material_Amt = OTC_Scan_Rs.getDouble("Material_Amt");
				
				int Transfer_InOut = OTC_Scan_Rs.getInt("Transfer_InOut");
				double Transfer_Amt = OTC_Scan_Rs.getDouble("Transfer_Amt");
				
				int Inventory_Qty = OTC_Scan_Rs.getInt("Inventory_Qty");
				double Inventory_Amt = OTC_Scan_Rs.getDouble("Inventory_Amt");
				
				Pricepstmt.setString(1, MatCode);
				PriceRs = Pricepstmt.executeQuery();
				if(PriceRs.next()){
					UnitPrice = PriceRs.getInt("PurPrices") / Double.parseDouble(PriceRs.getString("PriceBaseQty")) ;
				}
				
				if(Scan_Rs.getString("PlusMinus").equals("Plus")){
					Purchase_In += Scan_Rs.getInt("Count");
					Purchase_Amt += Scan_Rs.getInt("Count") * UnitPrice;
					
					Inventory_Qty = Purchase_In - (Material_Out + Transfer_InOut);
					Inventory_Amt = Purchase_Amt - (Material_Amt + Transfer_Amt);
				}else{
					Purchase_In -= Scan_Rs.getInt("Count");
					Purchase_Amt -= Scan_Rs.getInt("Count") * UnitPrice;
					
					Inventory_Qty = Purchase_In - (Material_Out + Transfer_InOut);
					Inventory_Amt = Purchase_Amt - (Material_Amt + Transfer_Amt);
				}
				
				String OTH_Up_Sql = "UPDATE totalmaterial_head SET "
	                    + "Purchase_In = ?, Purchase_Amt = ?, "
	                    + "Material_Out = ?, Material_Amt = ?, "
	                    + "Transfer_InOut = ?, Transfer_Amt = ?, "
	                    + "Inventory_Qty = ?, Inventory_Amt = ?, Inventory_UnitPrice = ?  "
	                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
				
				String OTC_Up_Sql = "UPDATE totalmaterial_child SET "
	                    + "Purchase_In = ?, Purchase_Amt = ?, "
	                    + "Material_Out = ?, Material_Amt = ?, "
	                    + "Transfer_InOut = ?, Transfer_Amt = ?, "
	                    + "Inventory_Qty = ?, Inventory_Amt = ?, Inventory_UnitPrice = ? "
	                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ? AND Plant = ? AND StorLoc = ?";
				
				PreparedStatement OTH_Up_Pstmt = conn.prepareStatement(OTH_Up_Sql);
				OTH_Up_Pstmt.setInt(1, Purchase_In);
				OTH_Up_Pstmt.setDouble(2, Purchase_Amt);
				OTH_Up_Pstmt.setInt(3, Material_Out);
				OTH_Up_Pstmt.setString(4, null);
				OTH_Up_Pstmt.setInt(5, Transfer_InOut);
				OTH_Up_Pstmt.setString(6, null);
				OTH_Up_Pstmt.setInt(7, Inventory_Qty);
				OTH_Up_Pstmt.setString(8, null);
				OTH_Up_Pstmt.setDouble(9, Purchase_Amt / Purchase_In);
				OTH_Up_Pstmt.setString(10, DateCode);
				OTH_Up_Pstmt.setString(11, ComCode);
				OTH_Up_Pstmt.setString(12, MatCode);
				OTH_Up_Pstmt.executeUpdate();
				
				PreparedStatement OTC_Up_Pstmt = conn.prepareStatement(OTC_Up_Sql);
				OTC_Up_Pstmt.setInt(1, Purchase_In);
				OTC_Up_Pstmt.setDouble(2, Purchase_Amt);
				OTC_Up_Pstmt.setInt(3, Material_Out);
				OTC_Up_Pstmt.setString(4, null);
				OTC_Up_Pstmt.setInt(5, Transfer_InOut);
				OTC_Up_Pstmt.setString(6, null);
				OTC_Up_Pstmt.setInt(7, Inventory_Qty);
				OTC_Up_Pstmt.setString(8, null);
				OTC_Up_Pstmt.setDouble(9, Purchase_Amt / Purchase_In);
				OTC_Up_Pstmt.setString(10, DateCode);
				OTC_Up_Pstmt.setString(11, ComCode);
				OTC_Up_Pstmt.setString(12, MatCode);
				OTC_Up_Pstmt.setString(13, PlantCode);
				OTC_Up_Pstmt.setString(14, StgCode);
				OTC_Up_Pstmt.executeUpdate();
			}else{
				String OTC_Insert_Sql = "INSERT INTO totalmaterial_child VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement OTC_Insert_Pstmt = conn.prepareStatement(OTC_Insert_Sql);
				OTC_Insert_Pstmt.setString(1, DateCode);
				OTC_Insert_Pstmt.setString(2, ComCode);
				OTC_Insert_Pstmt.setString(3, MatCode);
				OTC_Insert_Pstmt.setString(4, MatDes);
				OTC_Insert_Pstmt.setString(5, PlantCode);
				OTC_Insert_Pstmt.setString(6, StgCode);
				OTC_Insert_Pstmt.setString(7, "0");
				OTC_Insert_Pstmt.setString(8, "0");
				OTC_Insert_Pstmt.setString(9, Scan_Rs.getString("Count"));
				OTC_Insert_Pstmt.setDouble(10, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")));
				OTC_Insert_Pstmt.setString(11, "0");
				OTC_Insert_Pstmt.setString(12, "0");
				OTC_Insert_Pstmt.setString(13, "0");
				OTC_Insert_Pstmt.setString(14, "0");
				OTC_Insert_Pstmt.setString(15, Scan_Rs.getString("Count"));
				OTC_Insert_Pstmt.setDouble(16, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")));
				OTC_Insert_Pstmt.setDouble(17, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")) % Integer.parseInt(Scan_Rs.getString("Count")));
				OTC_Insert_Pstmt.setDouble(18, UnitPrice * Integer.parseInt(Scan_Rs.getString("Count")) % Integer.parseInt(Scan_Rs.getString("Count")));
				OTC_Insert_Pstmt.executeUpdate();
				
				Pricepstmt.setString(1, MatCode);
				PriceRs = Pricepstmt.executeQuery();
				if(PriceRs.next()){
					UnitPrice = PriceRs.getDouble("PricePerUnit");
				}
				
				int Initial_Qty = OTH_Scan_Rs.getInt("Initial_Qty");
				double Initial_Amt = OTH_Scan_Rs.getDouble("Initial_Amt");
				
				int Purchase_In = OTH_Scan_Rs.getInt("Purchase_In");
				double Purchase_Amt = OTH_Scan_Rs.getDouble("Purchase_Amt");
				
				int Material_Out = OTH_Scan_Rs.getInt("Material_Out");
				
				int Transfer_InOut = OTH_Scan_Rs.getInt("Transfer_InOut");
				
				int Inventory_Qty = OTH_Scan_Rs.getInt("Inventory_Qty");
				
				Purchase_In += Scan_Rs.getInt("Count");
				Purchase_Amt += Scan_Rs.getInt("Count") * UnitPrice;
				
				String OTH_Up_Sql = "UPDATE totalmaterial_head SET "
	                    + "Purchase_In = ?, Purchase_Amt = ?, "
	                    + "Material_Out = ?, Material_Amt = ?, "
	                    + "Transfer_InOut = ?, Transfer_Amt = ?, "
	                    + "Inventory_Qty = ?, Inventory_Amt = ?, Inventory_UnitPrice = ?  "
	                    + "WHERE YYMM = ? AND Com_Code = ? AND Material = ?";
				
				PreparedStatement OTH_Up_Pstmt = conn.prepareStatement(OTH_Up_Sql);
				OTH_Up_Pstmt.setInt(1, Purchase_In);
				OTH_Up_Pstmt.setDouble(2, Purchase_Amt);
				OTH_Up_Pstmt.setInt(3, Material_Out);
				OTH_Up_Pstmt.setString(4, null);
				OTH_Up_Pstmt.setInt(5, Transfer_InOut);
				OTH_Up_Pstmt.setString(6, null);
				OTH_Up_Pstmt.setInt(7, Inventory_Qty);
				OTH_Up_Pstmt.setString(8, null);
				OTH_Up_Pstmt.setDouble(9, Purchase_Amt / Purchase_In);
				OTH_Up_Pstmt.setString(10, DateCode);
				OTH_Up_Pstmt.setString(11, ComCode);
				OTH_Up_Pstmt.setString(12, MatCode);
				OTH_Up_Pstmt.executeUpdate();
			}
		}
	}
	out.println("Success");
	}catch(Exception e){
	    e.printStackTrace();
	}
%>
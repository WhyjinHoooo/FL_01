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
	
	String Tem_Sql = "SELECT DISTINCT PurOrdNo, SLocCode, COUNT(*) as OrderQuantity FROM temtable WHERE DocNum = ? GROUP BY PurOrdNo";
	PreparedStatement Tem_Pstmt = conn.prepareStatement(Tem_Sql);
	Tem_Pstmt.setString(1, HeaderInfoList.getString("MatNum"));
	ResultSet Tem_Rs = Tem_Pstmt.executeQuery();
	
	while(Tem_Rs.next()){
		String SHI_Sql = "INSERT INTO storehead VALUES(?,?,?,?,?,?,?,?,?,?)";
		PreparedStatement SHI_Pstmt = conn.prepareStatement(SHI_Sql);
		SHI_Pstmt.setString(1, HeaderInfoList.getString("MatNum"));
		SHI_Pstmt.setString(2, HeaderInfoList.getString("date"));
		SHI_Pstmt.setString(3, Tem_Rs.getString("Tem_Rs"));
		SHI_Pstmt.setString(4, "Null");
		SHI_Pstmt.setString(5, HeaderInfoList.getString("PlantCode"));
		SHI_Pstmt.setString(6, Tem_Rs.getString("SLocCode"));
		SHI_Pstmt.setString(7, HeaderInfoList.getString("VendorCode"));
		SHI_Pstmt.setString(8, HeaderInfoList.getString("date"));
		SHI_Pstmt.setString(9, Tem_Rs.getString("OrderQuantity"));
		SHI_Pstmt.setString(10, HeaderInfoList.getString("UserID"));
		SHI_Pstmt.executeUpdate();
		
		String SeaSql = "SELECT * FROM temtable WHERE DocNum = ?";
		PreparedStatement SeaPstmt = conn.prepareStatement(SeaSql);
		SeaPstmt.setString(1, HeaderInfoList.getString("MatNum"));
		ResultSet SeaRs = SeaPstmt.executeQuery();
		while(SeaRs.next()){
			String SCI_Sql = "INSERT INTO storechild VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement DCI_Pstmt = conn.prepareStatement(SCI_Sql);
			DCI_Pstmt.setString(1, SeaRs.getString("KeyValue"));
			DCI_Pstmt.setString(2, HeaderInfoList.getString("date"));
			DCI_Pstmt.setString(3, SeaRs.getString("DocNum"));
			DCI_Pstmt.setString(4, SeaRs.getString("ItemNum"));
			DCI_Pstmt.setString(5, SeaRs.getString("MatCode"));
			DCI_Pstmt.setString(6, SeaRs.getString("MatType"));
			DCI_Pstmt.setString(7, SeaRs.getString("MovCode"));
			DCI_Pstmt.setString(8, SeaRs.getString("Count"));
			DCI_Pstmt.setString(9, SeaRs.getString("Unit"));
			
			String PriceSql = "SELECT * FROM purprice WHERE MatCode = ?";
			PreparedStatement Pricepstmt = conn.prepareStatement(PriceSql);
			Pricepstmt.setString(1, SeaRs.getString("MatCode"));
			ResultSet PriceRs = Pricepstmt.executeQuery();
			if(PriceRs.next()){
				UnitPrice = PriceRs.getInt("PurPrices") % Double.parseDouble(PriceRs.getString("PriceBaseQty")) ;
			}
			DCI_Pstmt.setDouble(10, UnitPrice * Integer.parseInt(SeaRs.getString("Count")));
			DCI_Pstmt.setString(11, SeaRs.getString("Money"));
			DCI_Pstmt.setDouble(12, UnitPrice * Integer.parseInt(SeaRs.getString("Count")));
			DCI_Pstmt.setString(13, SeaRs.getString("Money"));
			DCI_Pstmt.setString(14, SeaRs.getString("VenCode"));
			DCI_Pstmt.setString(15, SeaRs.getString("PurOrdNo"));
			DCI_Pstmt.setString(16, SeaRs.getString("LotName"));
			DCI_Pstmt.setString(17, SeaRs.getString("MadeDate"));
			DCI_Pstmt.setString(18, SeaRs.getString("DeadDate"));
			DCI_Pstmt.setString(19, SeaRs.getString("SLocCode"));
			DCI_Pstmt.setString(20, "Null");
			DCI_Pstmt.setString(21, SeaRs.getString("PlantCode"));
			DCI_Pstmt.setString(22, HeaderInfoList.getString("UserID"));
			DCI_Pstmt.executeUpdate();
			
		}
	}
	Tem_Rs.beforeFirst();
	while(Tem_Rs.next()){
		String TMH_Sql = "INSERT INTO totalmaterial_head VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
	}

	}catch(Exception e){
	    e.printStackTrace();
	}
%>
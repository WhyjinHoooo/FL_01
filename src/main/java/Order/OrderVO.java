package Order;

public class OrderVO {

	private String orderNum;/* Purchase Order Number, PO번호 */
	private int itenNum; /* Order Item Number, 아이템 번호 */
	private String matNum; /* ROH701-00023, 재료 번호 */
	private String madDes; /* Raw Material ROH701-00023 , 300*150*250 말통 20 Kg, 재료에 대한 설명 */
	private String matType; /* RAWM, 재료의 유형 */
	private int count; /* 500, 발주수량 */
	private String buyUnit; /* Kg, 구매 단위 */
	private double originPri; /* 300.05, 구입단가 */
	private String priUnit; /* JPY/Kg, 가격단위 */
	private double totalPri; /* 발주금액 */
	private String deal; /* 거래단위 */
	private String hopeDate; /* 납품희망일짜 */
	private String storaGe; /* 납품창고 */
	private String plantCode; /* plant코드 */

	public String getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(String orderNum) {
		this.orderNum = orderNum;
	}

	public int getItenNum() {
		return itenNum;
	}

	public void setItenNum(int itenNum) {
		this.itenNum = itenNum;
	}

	public String getMatNum() {
		return matNum;
	}

	public void setMatNum(String matNum) {
		this.matNum = matNum;
	}

	public String getMadDes() {
		return madDes;
	}

	public void setMadDes(String madDes) {
		this.madDes = madDes;
	}

	public String getMatType() {
		return matType;
	}

	public void setMatType(String matType) {
		this.matType = matType;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public String getBuyUnit() {
		return buyUnit;
	}

	public void setBuyUnit(String buyUnit) {
		this.buyUnit = buyUnit;
	}

	public double getOriginPri() {
		return originPri;
	}

	public void setOriginPri(double originPri) {
		this.originPri = originPri;
	}

	public String getPriUnit() {
		return priUnit;
	}

	public void setPriUnit(String priUnit) {
		this.priUnit = priUnit;
	}

	public double getTotalPri() {
		return totalPri;
	}

	public void setTotalPri(double totalPri) {
		this.totalPri = totalPri;
	}

	public String getDeal() {
		return deal;
	}

	public void setDeal(String deal) {
		this.deal = deal;
	}

	public String getHopeDate() {
		return hopeDate;
	}

	public void setHopeDate(String hopeDate) {
		this.hopeDate = hopeDate;
	}

	public String getStoraGe() {
		return storaGe;
	}

	public void setStoraGe(String storaGe) {
		this.storaGe = storaGe;
	}

	public String getPlantCode() {
		return plantCode;
	}

	public void setPlantCode(String plantCode) {
		this.plantCode = plantCode;
	}

}

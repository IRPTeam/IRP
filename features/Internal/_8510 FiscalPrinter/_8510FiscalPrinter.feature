#language: en
@tree
@Positive
@FiscalPrinter

Feature: check fiscal printer


Variables:
import "Variables.feature"

SalesReceiptXML1 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="200" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 12 with SLN (Main Company - different consignor for item key) PZU [8900008990900]" Quantity="1" PaymentMethod="4" PriceWithDiscount="200" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
	</Positions>
	<Payments Cash="300" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML2 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899877]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN ODS [345]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="720" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML3 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899877]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="120" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 4 with SLN UNIQ [899007790088]" Quantity="1" PaymentMethod="4" PriceWithDiscount="120" VATRate="18" VATAmount="18.31"/>
	</Positions>
	<Payments Cash="440" ElectronicPayment="400" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML4 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="118" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="4" PriceWithDiscount="118" VATRate="18" VATAmount="18"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="0" PrePayment="0" PostPayment="118" Barter="0"/>
</CheckPackage>
"""
SalesReceiptXML5 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="118" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="5" PriceWithDiscount="118" VATRate="18" VATAmount="18"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="0" PrePayment="0" PostPayment="118" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML6 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="210" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="4" PriceWithDiscount="210" VATRate="18" VATAmount="32.03"/>
	</Positions>
	<Payments Cash="10" ElectronicPayment="0" PrePayment="200" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML7 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="118" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="4" PriceWithDiscount="118" VATRate="18" VATAmount="18"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="0" PrePayment="0" PostPayment="118" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML8 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="520" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML9 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="442" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 11 with SLN (Main Company - Consignor 1) PZU [11111111111112]" Quantity="2" PaymentMethod="4" PriceWithDiscount="221" VATRate="18" VATAmount="67.42" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="101" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 13 without SLN (Main Company - different consignor for item key) M/Black" Quantity="1" PaymentMethod="4" PriceWithDiscount="101" VATRate="18" VATAmount="15.41" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="543" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML10 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899877]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="620" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML11 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="200" DiscountAmount="0" MarkingCode="11111111111111111111" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899877]" Quantity="1" PaymentMethod="4" PriceWithDiscount="200" VATRate="18" VATAmount="30.51"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="200" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML12 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 9 with SLN (control code string, without check) ODS [999999999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
	</Positions>
	<Payments Cash="100" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML13 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="112" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899880]" Quantity="1" PaymentMethod="4" PriceWithDiscount="112" VATRate="18" VATAmount="17.08"/>
	</Positions>
	<Payments Cash="120" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML14 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="112" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899880]" Quantity="1" PaymentMethod="4" PriceWithDiscount="112" VATRate="18" VATAmount="17.08"/>
	</Positions>
	<Payments Cash="112" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""
SalesReceiptXML15 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="113" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899880]" Quantity="1" PaymentMethod="4" PriceWithDiscount="113" VATRate="18" VATAmount="17.24"/>
	</Positions>
	<Payments Cash="113" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML16 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="113" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899880]" Quantity="1" PaymentMethod="4" PriceWithDiscount="113" VATRate="18" VATAmount="17.24"/>
	</Positions>
	<Payments Cash="113" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML17 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="500" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="10" Name="Certificate without denominal [99999999999]" Quantity="1" PaymentMethod="3" PriceWithDiscount="500" VATRate="18" VATAmount="76.27"/>
	</Positions>
	<Payments Cash="500" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML18 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
		<FiscalString AmountWithDiscount="200" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899880]" Quantity="1" PaymentMethod="4" PriceWithDiscount="200" VATRate="18" VATAmount="30.51"/>
	</Positions>
	<Payments Cash="20" ElectronicPayment="200" PrePayment="500" PostPayment="0" Barter="0"/>
</CheckPackage>
"""
SalesReceiptXML19 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
		<FiscalString AmountWithDiscount="200" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU [8908899880]" Quantity="1" PaymentMethod="4" PriceWithDiscount="200" VATRate="18" VATAmount="30.51"/>
	</Positions>
	<Payments Cash="120" ElectronicPayment="100" PrePayment="500" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML20 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="10" Name="Certificate without denominal [99999999998]" Quantity="1" PaymentMethod="3" PriceWithDiscount="300" VATRate="18" VATAmount="45.76"/>
	</Positions>
	<Payments Cash="300" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML21 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898790]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="300" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML22 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
			<GoodCodeData NotIdentified="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) ODS [9099009909999999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
			<GoodCodeData NotIdentified="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 2 with SLN UNIQ [0514]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76"/>
	</Positions>
	<Payments Cash="900" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML23 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
			<GoodCodeData NotIdentified="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) ODS [9099009909999999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
			<GoodCodeData NotIdentified="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 2 with SLN UNIQ [0514]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76"/>
	</Positions>
	<Payments Cash="900" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML24 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="301.11" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY3" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="301.11" VATRate="18" VATAmount="45.93" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY4" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) ODS [9099009909999999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="601.11" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML25 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="301.11" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY3" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="301.11" VATRate="18" VATAmount="45.93" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY4" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) ODS [9099009909999999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="601.11" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML26 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="401.11" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="4" PriceWithDiscount="401.11" VATRate="18" VATAmount="61.19">
			<GoodCodeData NotIdentified="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY8"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76">
			<GoodCodeData NotIdentified="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY9"/>
		</FiscalString>
	</Positions>
	<Payments Cash="701.11" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML27 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute=""/>
	<Positions>
		<FiscalString AmountWithDiscount="401.11" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="4" PriceWithDiscount="401.11" VATRate="18" VATAmount="61.19">
			<GoodCodeData NotIdentified="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY8"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="300" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU [57897909799]" Quantity="1" PaymentMethod="4" PriceWithDiscount="300" VATRate="18" VATAmount="45.76">
			<GoodCodeData NotIdentified="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY9"/>
		</FiscalString>
	</Positions>
	<Payments Cash="701.11" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML28 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute="715">
		<CorrectionData Type="0" Number="0" Description="wrong VAT rate" Date="2023-12-19T13:24:48"/>
	</Parameters>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) UNIQ [9000008]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) PZU [900889900900778]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress S/Yellow" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="700" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML29 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute="716">
		<CorrectionData Type="0" Number="0" Description="wrong VAT rate" Date="2023-12-19T13:24:48"/>
	</Parameters>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) UNIQ [9000008]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) PZU [900889900900778]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress S/Yellow" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="700" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML30 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute="717">
		<CorrectionData Type="0" Number="0" Description="wrong VAT rate" Date="2023-12-19T14:15:51"/>
	</Parameters>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) UNIQ [9000008]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) PZU [900889900900778]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress S/Yellow" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="0" ElectronicPayment="700" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML31 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute="718">
		<CorrectionData Type="0" Number="0" Description="wrong VAT rate" Date="2023-12-19T14:15:51"/>
	</Parameters>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) UNIQ [9000008]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) PZU [900889900900778]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress S/Yellow" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="0" ElectronicPayment="700" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML32 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute="719">
		<CorrectionData Type="0" Number="0" Description="wrong VAT rate" Date="2023-12-19T14:50:09"/>
	</Parameters>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) UNIQ [9000008]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) PZU [900889900900778]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress S/Yellow" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="700" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML33 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute="720">
		<CorrectionData Type="0" Number="0" Description="wrong VAT rate" Date="2023-12-19T14:50:09"/>
	</Parameters>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) UNIQ [9000008]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) PZU [900889900900778]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress S/Yellow" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="700" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML34 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0" AdditionalAttribute="721">
		<CorrectionData Type="0" Number="0" Description="wrong VAT rate" Date="2023-12-20T12:00:00"/>
	</Parameters>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) UNIQ [9000008]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) PZU [900889900900778]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress S/Yellow" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="0" ElectronicPayment="700" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""
SalesReceiptXML35 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0" AdditionalAttribute="722">
		<CorrectionData Type="0" Number="0" Description="wrong VAT rate" Date="2023-12-20T12:00:00"/>
	</Parameters>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN ODS [0909088998998898789]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product with Unique SLN PZU [0909088998998898791]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) UNIQ [9000008]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN (Main Company - Consignor 2) PZU [900889900900778]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="2222222222" VendorName="Consignor 2" VendorPhone="+9 (000) 000-00-02"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress S/Yellow" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 15 with SLN and code control (Main Company - Consignor 1) ODS [900999000009]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 16 with SLN and Good code data (Main Company - Consignor 1) PZU [89000008999]" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1111111111" VendorName="Consignor 1" VendorPhone="+9 (000) 000-00-01"/>
		</FiscalString>
	</Positions>
	<Payments Cash="0" ElectronicPayment="700" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _0850000 preparation (fiscal printer)
	When set True value to the constant
	When set True value to the constant Use consolidated retail sales
	When set True value to the constant Use commission trading
	* Load info
		When Create catalog BusinessUnits objects
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Partners and Payment type (Bank)
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog Partners objects (Customer)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog Agreements objects (commision trade, own companies)
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog SourceOfOrigins objects
		When Create PaymentType (advance)
		When Create catalog Users objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When create consignors Items with SLN
		When create consignors Items with control code string type (Good code data)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create POS cash account objects
		When Create catalog Countries objects
		When Create catalog Items objects (commission trade)
		When Create Certificate
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog UserGroups objects
	* Create payment terminal
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		And I click the button named "FormCreate"
		And I input "Payment terminal 01" text in the field named "Description_en"
		And I click "Save and close" button
	* Create PaymentTypes
		When Create catalog PaymentTypes objects
	* Bank terms
		When Create catalog BankTerms objects (for Shop 02)	
		When Create catalog BankTerms 03 and PaymentType Card 03 objects (for Shop 02)	
	* Workstation
		When Create catalog Workstations objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I select current line in "List" table
		And I change checkbox "Postpone with reserve"
		And I change checkbox "Postpone without reserve"
		And I click "Save and close" button				
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	
	* Comission trade
		When Create information register TaxSettings records (Concignor 1)
		When Create information register TaxSettings records (Concignor 2)
		When Create document PurchaseInvoice (comission trade, own Companies)
		When Create document SalesInvoice (trade, own Companies)
		When Create information register Barcodes records (marking code)
	* Post document
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(2200).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(2201).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(2202).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(2203).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(2206).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(2209).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2200).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2201).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Money transfer
		When Create document MoneyTransfer objects (for cash in)
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
		And I select current line in "List" table
		And I delete "$$MoneyTransfer11$$" variable
		And I save the window as "$$MoneyTransfer11$$" 
		And I close all client application windows
	* Consolidated retail sales
		When create ConsolidatedRetailSales and RetailSalesReceipt
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ConsolidatedRetailSales.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Setting for Company commission trade
		When settings for Company (commission trade)
	And I close all client application windows
	* Instal fiscal driver
		Given I open hyperlink "e1cib/list/Catalog.EquipmentDrivers"
		And I click the button named "FormCreate"
		And I input "KKT_3004" text in "Description" field
		And I input "AddIn.Modul_KKT_3004" text in "AddIn ID" field
		And I select external file "C:/AddComponents/KKT_3004.zip"
		And I click "Add file" button	
		And Delay 10
		And I click the button named "FormWrite"	
		And I click "Install" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click the button named "FormWriteAndClose"		
		And I close all client application windows
	* Instal acquiring driver
		Given I open hyperlink "e1cib/list/Catalog.EquipmentDrivers"
		And I click the button named "FormCreate"
		And I input "Acquiring" text in "Description" field
		And I input "AddIn.Modul_Acquiring_3007" text in "AddIn ID" field
		And I select external file "C:/AddComponents/Acquiring_3007.zip"
		And I click "Add file" button	
		And Delay 10
		And I click the button named "FormWrite"	
		And I click "Install" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click the button named "FormWriteAndClose"		
		And I close all client application windows
	* Add fiscal printer to the Hardware
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		And I click the button named "FormCreate"
		And I input "Fiscal printer" text in "Description" field
		And I select "Fiscal printer" exact value from "Types of Equipment" drop-down list
		And I set checkbox named "Log"	
		And I click Select button of "Driver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'KKT_3004'       |
		And I select current line in "List" table
		And I expand "Additional info" group
		And I input "Sale address" text in "Sale address" field
		And I input "Sale location" text in "Sale location" field	
		And I click "Save" button		
		And I click "Save and close" button
		Then "Hardware" window is opened
		And I go to line in "List" table
			| 'Description'       |
			| 'Fiscal printer'    |
		And I select current line in "List" table
		And in the table "DriverParameter" I click "Reload settings" button		
		And I go to line in "DriverParameter" table
			| 'Name'       |
			| 'LogFile'    |
		And I delete "$$LogPath$$" variable
		And I save the value of "Value" field of "DriverParameter" table as "$$LogPath$$"	
		And I click the button named "FormWriteAndClose"
	* Add acquiring terminal to the Hardware
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		And I click the button named "FormCreate"
		And I input "Acquiring terminal" text in "Description" field
		And I select "Acquiring" exact value from "Types of Equipment" drop-down list
		And I click Select button of "Driver" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Acquiring_3007'    |
		And I select current line in "List" table
		And I set checkbox named "Log"		
		And I expand "Additional info" group
		And I input "[cut]" text in the field named "Cutter"	
		And I click "Save" button		
		And I click "Save and close" button
		Then "Hardware" window is opened
		And I go to line in "List" table
			| 'Description'           |
			| 'Acquiring terminal'    |
		And I select current line in "List" table
		And in the table "DriverParameter" I click "Reload settings" button		
		And I go to line in "DriverParameter" table
			| 'Name'       |
			| 'LogFile'    |
		And I delete "$$LogPathAcquiring$$" variable
		And I save the value of "Value" field of "DriverParameter" table as "$$LogPathAcquiring$$"	
		And I click the button named "FormWriteAndClose"
	* Add fiscal printer to the workstation
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I select current line in "List" table	
	* Check add hardware
		* Fiscal printer
			And in the table "HardwareList" I click the button named "HardwareListAdd"
			And I click choice button of "Hardware" attribute in "HardwareList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Fiscal printer'     |
			And I select current line in "List" table
			And I activate "Enable" field in "HardwareList" table
			And I finish line editing in "HardwareList" table
			And I set "Enable" checkbox in "HardwareList" table
			And I finish line editing in "HardwareList" table
			And I click "Save" button
			And "HardwareList" table became equal
				| 'Enable'    | 'Hardware'           |
				| 'Yes'       | 'Fiscal printer'     |
		*Acquiring terminal
			And in the table "HardwareList" I click the button named "HardwareListAdd"
			And I click choice button of "Hardware" attribute in "HardwareList" table
			And I go to line in "List" table
				| 'Description'            |
				| 'Acquiring terminal'     |
			And I select current line in "List" table
			And I activate "Enable" field in "HardwareList" table
			And I finish line editing in "HardwareList" table
			And I set "Enable" checkbox in "HardwareList" table
			And I finish line editing in "HardwareList" table
			And I click "Save" button
			And "HardwareList" table became equal
				| 'Enable'    | 'Hardware'               |
				| 'Yes'       | 'Fiscal printer'         |
				| 'Yes'       | 'Acquiring terminal'     |
		And I click "Save and close" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	
	* Check fiscal printer status
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		And I go to line in "List" table
			| 'Description'       |
			| 'Fiscal printer'    |
		And I select current line in "List" table
		And I click "Connect" button
		Then the form attribute named "CommandResult" became equal to template
			| 'Fiscal printer connected.'    |
			| 'ID:KKT_3004*'                 |
		And I click "Disconnect" button
		Then the form attribute named "CommandResult" became equal to "Fiscal printer disconnected."
		And I click the button named "UpdateStatus"
		Then the form attribute named "CommandResult" became equal to "Fiscal printer NOT connected."						
	* Delete log file
		Then I delete '$$LogPath$$' file
	* Check fiscal printer connection
		And I click "Connect" button
		And Delay 5	
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"	
		And I check "$ParsingResult$" with "0" and method is "Open"
		And I close all client application windows
	* Check acquiring printer status
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		And I go to line in "List" table
			| 'Description'           |
			| 'Acquiring terminal'    |
		And I select current line in "List" table
		And I click "Connect" button
		Then the form attribute named "CommandResult" became equal to template
			| 'Acquiring terminal connected.'    |
			| 'ID:Acquiring_3007*'               |
		And I click "Disconnect" button
		Then the form attribute named "CommandResult" became equal to "Acquiring terminal disconnected."
		And I click the button named "UpdateStatus"
		Then the form attribute named "CommandResult" became equal to "Acquiring terminal NOT connected."						
	* Delete acquiring printer log file
		Then I delete '$$LogPathAcquiring$$' file
	* Check acquiring printer connection
		And I click "Connect" button
		And Delay 5	
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResultAcquiring"	
		And I check "$ParsingResultAcquiring$" with "0" and method is "Open"
	* Add acquiring printer to the POS account
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'     |
			| 'POS Terminal'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Acquiring"
		And I go to line in "List" table
			| 'Description'           |
			| 'Acquiring terminal'    |
		And I select current line in "List" table
		And I click "Save and close" button
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'       |
			| 'POS Terminal 2'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Acquiring"
		And I go to line in "List" table
			| 'Description'           |
			| 'Acquiring terminal'    |
		And I select current line in "List" table
		And I click "Save and close" button
		And I close all client application windows
	* Enable control code string for Product 6 with SLN and Product 1 with SLN
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b78db8d3fd6dff8b11ed7f8d992046ee"
		And I expand "Accounting settings" group
		And I move to "Accounting settings" tab
		And I set checkbox "Control code string"
		And I set checkbox "Check code string"
		And I select "Marking code" exact value from "Control code string type" drop-down list
		And I click "Save and close" button
		And I wait "Product * with SLN (Item) *" window closing in 5 seconds
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f"
		And I expand "Accounting settings" group
		And I move to "Accounting settings" tab
		And I set checkbox "Control code string"
		And I set checkbox "Check code string"
		And I select "Marking code" exact value from "Control code string type" drop-down list
		And I click "Save and close" button
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b7a0d8de1a1c04c611ee174b1c02bb67"
		And I expand "Accounting settings" group
		And I move to "Accounting settings" tab
		And I set checkbox "Control code string"
		And I select "Marking code" exact value from "Control code string type" drop-down list
		And I click "Save and close" button
		And I wait "Product * with SLN (Item) *" window closing in 5 seconds
						
		
Scenario: _0850001 check preparation
	When check preparation

Scenario: _0850002 open session
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	And I click "Open session" button
	If Recent TestClient message contains "Shift already opened." string Then
	* Temporally
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Open" exact value from the drop-down list named "Status"
		And I activate "Icon" field in "Documents" table
		And I click "Post and close" button
		And I close all client application windows
		And In the command interface I select "Retail" "Point of sale"
		And I click "Close session" button
		Then "Finish: Session closing" window is opened
		And I click "Close session" button		
		And Delay 2
		And I click "Open session" button
* Check fiscal log
	When I Check the steps for Exception
		| 'And I click "Open session" button'   |
	And I close all client application windows
	* Save number CRS
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to the last line in "List" table
		And I select current line in "List" table
		And I delete "$$NumberCRS11$$" variable
		And I save the value of the field named "Number" as "$$NumberCRS11$$"
	And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
	And I check "$ParsingResult$" with "0" and method is "OpenShift"
	And I check "$ParsingResult$" with "0" and data in "In.Parameter2" contains 'CashierName="Арина Браун"'
	And I check "$ParsingResult$" with "0" and data in "In.Parameter2" contains 'CashierINN="1111111111"'
	And I check "$ParsingResult$" with "0" and data in "In.Parameter2" contains 'SaleAddress="Sale address"'
	And I check "$ParsingResult$" with "0" and data in "In.Parameter2" contains 'SaleLocation="Sale location"'


Scenario: _0850010 create cash in
	And I close all client application windows
	* Open POS and open session		
		And In the command interface I select "Retail" "Point of sale"
	* Create cash in
		And I click "Create cash in" button		
		Then the number of "CashInList" table lines is "равно" 1
		And I go to line in "CashInList" table
			| 'Money transfer'        | 'Currency'   | 'Amount'      |
			| '$$MoneyTransfer11$$'   | 'TRY'        | '1 000,00'    |
	* Print cash in
		And in the table "CashInList" I click "Create and post" button	
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashReceipt"		
		And "List" table became equal
			| 'Amount'     | 'Company'        | 'Cash account'         | 'Currency'   | 'Transaction type'    |
			| '1 000,00'   | 'Main Company'   | 'Pos cash account 1'   | 'TRY'        | 'Cash in'             |
		Then the number of "List" table lines is "равно" 1
		When in opened panel I select "Point of sales"
		And in the table "CashInList" I click "Update money transfers" button
		Then the number of "CashInList" table lines is "равно" 0
		And I close all client application windows
	* Check fiscal log
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "CashInOutcome"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains "1 000"

Scenario: _0850011 create retail sales receipt from POS (consignor, cash)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select first item (scan by barcode, with serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "900999000009" text in the field named "Barcode"
		And I move to the next attribute
	* Scan control code
		Then "Code string check" window is opened
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"	
		And I move to the next attribute	
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Select second item (scan by barcode, with serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "8900008990900" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Cash (/)" button
		And I click the button named "Enter"
		And I close all client application windows
	* Check fiscal log
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML1"
		
				
Scenario: _0850015 create retail sales receipt from POS (own stock, card 02, items with codes)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select first item (scan by barcode, with serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "23455677788976667" text in the field named "Barcode"
		And I move to the next attribute
	* Scan control code
		Then "Code string check" window is opened
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Current row will decode to base64" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Select second item (scan by barcode, without serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I finish line editing in "ItemList" table
	* Select third item	with sln and code control (create sln)
		And I click "Search by barcode (F7)" button
		And I input "67789997777801" text in the field named "Barcode"
		And I move to the next attribute
		* Create sln
			Then "Select serial lot numbers" window is opened
			And I change checkbox "Auto create"
			And in the table "SerialLotNumbers" I click "Search by barcode (F7)" button
			Then "Barcode" window is opened
			And I input "345" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Ok" button			
			And I activate "Control code string state" field in "ItemList" table
			And I select current line in "ItemList" table
			Then "Code string check" window is opened
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table	
	* Change quantity and check marking data
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'   | 'Price'    | 'Quantity'   | 'Serials'      | 'Total'     |
			| 'Product 1 with SLN'   | 'PZU'        | '100,00'   | '1,000'      | '8908899877'   | '100,00'    |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I click "Payment (+)" button
		Then there are lines in TestClient message log
			| 'Quantity [2] does not match the quantity [1] by serial/lot numbers'    |
		And I activate "Serials" field in "ItemList" table
		And I click choice button of "Serials" attribute in "ItemList" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		* Check previous marking code
			And "CurrentCodes" table became equal
				| 'Scanned codes'                     | 'Approved' | 'Not check' | 'Type'         |
				| 'Current row will decode to base64' | 'Yes'      | 'No'        | 'Marking code' |
		* Scan marking data that already used	
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
			And I move to the next attribute
			Then there are lines in TestClient message log
				| 'Current barcode already use at document line: 3'    |
				| 'Current barcode already use at document line: 3'    |
			And I close current window
		And I go to line in "ItemList" table
			| 'Item'                 | 'Item key'    |
			| 'Product 1 with SLN'   | 'PZU'         |
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I activate "Serials" field in "ItemList" table
		And I click choice button of "Serials" attribute in "ItemList" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button										
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 02'      |
		And I select current line in "BankPaymentTypeList" table
		And I click the button named "Enter"
		And I close all client application windows	
	* Check fiscal log
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML2"
		// Then "1C:Enterprise" window is opened
		// And I click "OK" button
				
		
		
Scenario: _0850016 create retail sales receipt from POS (own stock, cash and card 02)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select first item (scan by barcode, with serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Select second item (scan by barcode, without serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I finish line editing in "ItemList" table
	* Select third item
		And I click "Search by barcode (F7)" button
		And I input "23455677788976667" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Current row will decode to base64" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Select fourth item
		And I click "Search by barcode (F7)" button
		And I input "19987897977" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "120,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 02'      |
		And I select current line in "BankPaymentTypeList" table
		And I activate field named "PaymentsAmountString" in "Payments" table
		And I select current line in "Payments" table
		And I click "4" button
		And I click "0" button
		And I click "0" button
		And I click "Cash (/)" button
		And I click the button named "Enter"
		And I close all client application windows	
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML3"

	
				
Scenario: _0850017 payment by payment agent from POS
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I click "Search customer" button
		And I input "002" text in "ID" field
		And I move to the next attribute
		And I click "OK" button
	* Select first item (scan by barcode, with serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Bank credit
		And I click "Payment (+)" button
		And I click "P\A" button
		And "Payments" table became equal
			| 'Payment type'   | 'Amount'    |
			| 'Bank credit'    | '118,00'    |
		And I click the button named "Enter"
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML5"


	
Scenario: _0850018 advance payment (cash)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I click "Search customer" button
		And I input "005" text in "ID" field
		And I move to the next attribute
		And I click "OK" button
	* Advance
		And I click the button named "Advance"
		Then "Payment" window is opened
		And I click "2" button
		And I click "0" button
		And I click "0" button
		And I click the button named "Enter"
	* Advance payment
		And I click "Search customer" button
		And I input "005" text in "ID" field
		And I move to the next attribute
		And I click "OK" button
		And I click "Search by barcode (F7)" button
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "210,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click the button named "Enter"
		And I move to the next attribute
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"		


Scenario: _08500181 advance payment (card)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select retail customer
		And I click "Search customer" button
		And I input "005" text in "ID" field
		And I move to the next attribute
		And I click "OK" button
	* Advance
		And I click the button named "Advance"
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 04'      |
		And I select current line in "BankPaymentTypeList" table
		And I click "1" button
		And I click "0" button
		And I click the button named "Enter"
		Then there are lines in TestClient message log
			|'Not all payment done.'|
		And I click "Pay" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to the next attribute
		And I click the button named "Enter"				
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'ElectronicPayment="10"'
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'PaymentMethod="3"'
	* Check acquiring log
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "PayByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОПЛАТА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '10.00'
		
Scenario: _0850019 create retail sales receipt from POS (own stock, card 03, use acquiring)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select first item (scan by barcode, with serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "23455677788976667" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Current row will decode to base64" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Select second item (scan by barcode, without serial lot number)
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I finish line editing in "ItemList" table
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 03'      |
		And I select current line in "BankPaymentTypeList" table
		And I click "Pay" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then "Payment" window is opened
		And I click the button named "Enter"
		And I close all client application windows	
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML10"
		And I check "$ParsingResult$" with "6" and method is "PrintTextDocument"
		And I check "$ParsingResult$" with "6" and data in "In.Parameter2" contains 'TextString Text="ОПЛАТА'
		And I check "$ParsingResult$" with "6" and data in "In.Parameter2" contains '620.00'
	* Check acquiring log
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "PayByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОПЛАТА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '620.00'
		
Scenario: _0850020 check auto payment form by acquiring (Enter)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select item
		And I click "Search by barcode (F7)" button
		And I input "23455677788976667" text in the field named "Barcode"
		And I move to the next attribute
		Then the form attribute named "isReturn" became equal to "No"
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "11111111111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check auto payment by card
		And I click "Payment (+)" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 04'      |
		And I select current line in "BankPaymentTypeList" table
		And I click "4" button
		And I click "0" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 03'      |
		And I select current line in "BankPaymentTypeList" table
		And I click the button named "Enter"
		And I click "OK" button
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Not all payment done.'|
			|'Not all payment done.'|
			|'Not all payment done.'|
		And I go to line in "Payments" table
			| 'Amount' | 'Payment done' | 'Payment type' |
			| '40,00'  | '⚪'            | 'Card 04'      |
		And I activate "Payment type" field in "Payments" table
		And I click "Pay" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to the next attribute
		And I go to line in "Payments" table
			| 'Amount' | 'Payment done' | 'Payment type' |
			| '60,00'  | '⚪'            | 'Card 03'      |
		And I click "Pay" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to the next attribute	
		And I click "OK" button	
		And Delay 10
	* Check fiscal log	
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'ElectronicPayment="100"'
		And I check "$ParsingResult$" with "7" and method is "PrintTextDocument"
		And I check "$ParsingResult$" with "7" and data in "In.Parameter2" contains 'TextString Text="ОПЛАТА'
		And I check "$ParsingResult$" with "7" and data in "In.Parameter2" contains '40.00'
		And I check "$ParsingResult$" with "6" and method is "PrintTextDocument"
		And I check "$ParsingResult$" with "6" and data in "In.Parameter2" contains 'TextString Text="ОПЛАТА'
		And I check "$ParsingResult$" with "6" and data in "In.Parameter2" contains '60.00'
	* Check acquiring log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "PayByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОПЛАТА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '60.00'	
		And I check "$ParsingResult1$" with "5" and method is "PayByPaymentCard"
		And I check "$ParsingResult1$" with "5" and data in "Out.Parameter8" contains 'ОПЛАТА'
		And I check "$ParsingResult1$" with "5" and data in "Out.Parameter8" contains '40.00'	
	* Check RRN
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Amount'         |
			| '100,00'    |
		And I select current line in "List" table
		And I move to "Payments" tab
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Bank term'      | 'Account'          | 'Percent'   | 'RRN Code'    |
			| '1'   | '40,00'    | '0,40'         | 'Card 04'        | ''                   | 'Bank term 03'   | 'POS Terminal 2'   | '1,00'      | '*'           |
			| '2'   | '60,00'    | '0,60'         | 'Card 03'        | ''                   | 'Bank term 03'   | 'POS Terminal'     | '1,00'      | '*'           |
		And I go to the first line in "Payments" table
		And I delete "$$RRN1$$" variable
		And I delete "$$RRN2$$" variable
		And I save the value of "RRN Code" field of "Payments" table as "$$RRN1$$"
		And I go to the last line in "Payments" table
		And I save the value of "RRN Code" field of "Payments" table as "$$RRN2$$"
		And I delete "$$NumberRetailSalesReceipt5$$" variable
		And I delete "$$RetailSalesReceipt5$$" variable
		And I save the value of "Number" field as "$$NumberRetailSalesReceipt5$$"
		And I save the window as "$$RetailSalesReceipt5$$"
	* Check control code string tab
		And I click "Show hidden tables" button
		Then "Edit hidden tables" window is opened
		And I move to "ControlCodeStrings (1)" tab
		And "ControlCodeStrings" table became equal
			| 'Key'   | 'Code string'            | 'Code is approved'    |
			| '*'     | '11111111111111111111'   | 'Yes'                 |
	And I close all client application windows
	
Scenario: _0850022 check than RRN not copy
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	And I go to line in "List" table
		| 'Number'                          |
		| '$$NumberRetailSalesReceipt5$$'   |
	And in the table "List" I click the button named "ListContextMenuCopy"
	And I click "OK" button
	Then "Retail sales receipt (create)" window is opened
	And I move to "Payments" tab
	And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Bank term'      | 'Account'          | 'Percent'   | 'RRN Code'    |
			| '1'   | '40,00'    | '0,40'         | 'Card 04'        | ''                   | 'Bank term 03'   | 'POS Terminal 2'   | '1,00'      | ''            |
			| '2'   | '60,00'    | '0,60'         | 'Card 03'        | ''                   | 'Bank term 03'   | 'POS Terminal'     | '1,00'      | ''            |
	And I close all client application windows
	
Scenario: _0850023 check return payment by card and cash (sales by card)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select basis document
		And I click the button named "Return"
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Retail sales receipt'       |
			| '$$RetailSalesReceipt5$$'    |
		And I select current line in "List" table
	* Check marking code from RSR
		And I activate "Control code string state" field in "ItemList" table
		And I select current line in "ItemList" table
		Then the form attribute named "isReturn" became equal to "Yes"
		And "CurrentCodes" table became equal
			| 'Type'         | 'Prefix' | 'Scanned codes'        | 'Approved' | 'Not check' |
			| 'Marking code' | ''       | '11111111111111111111' | 'No'       | 'No'        |
		And I close current window						
		And I click "Payment Return" button		
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 04'      |
		And I select current line in "BankPaymentTypeList" table
		Then "Payment" window is opened
		And I click "5" button
		And I click "0" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 03'      |
		And I select current line in "BankPaymentTypeList" table
		Then "Payment" window is opened
		And I click "4" button
		And I click "0" button
		And I click "Cash (/)" button
		And "Payments" table became equal
			| 'Payment done'   | 'Payment type'   | 'Amount'   | 'RRNCode'     |
			| '⚪'              | 'Card 04'        | '50,00'    | '$$RRN1$$'    |
			| '⚪'              | 'Card 03'        | '40,00'    | '$$RRN2$$'    |
			| ' '              | 'Cash'           | '10,00'    | ''            |
		And I go to line in "Payments" table
			| 'Amount'   | 'Payment done'   | 'Payment type'   | 'RRNCode'     |
			| '50,00'    | '⚪'              | 'Card 04'        | '$$RRN1$$'    |
		And I activate "Payment type" field in "Payments" table
		When I Check the steps for Exception
			| 'And I click "Revert" button'    |
		And I click "Return (in day)" button
		Then "Cancellation confirmation" window is opened
		And I change checkbox "Yes, I do know what am I doing"
		And I click the button named "OK"		
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then "Payment" window is opened		
		And I click the button named "Enter"
		Then there are lines in TestClient message log
			|'Not all payment done.'|
		And I go to line in "Payments" table
			| 'Amount' | 'Payment done' | 'Payment type' |
			| '40,00'  | '⚪'            | 'Card 03'      |
		And I activate "Payment type" field in "Payments" table
		And I click "Return (in day)" button
		Then "Cancellation confirmation" window is opened
		And I change checkbox "Yes, I do know what am I doing"
		And I click the button named "OK"	
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to the next attribute		
		And I click "OK" button
	* Check acquiring log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "CancelPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОТМЕНА ПЛАТЕЖА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '40.00'
		And I check "$ParsingResult1$" with "1" and data in "In.Parameter6" contains '$$RRN2$$'	
		And I check "$ParsingResult1$" with "5" and method is "CancelPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "5" and data in "Out.Parameter8" contains 'ОТМЕНА ПЛАТЕЖА'
		And I check "$ParsingResult1$" with "5" and data in "Out.Parameter8" contains '50.00'
		And I check "$ParsingResult1$" with "5" and data in "In.Parameter6" contains '$$RRN1$$'		
	* Check fiscal log
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'ElectronicPayment="90"'
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'Cash="10"'	
		And I check "$ParsingResult$" with "6" and method is "PrintTextDocument"
		And I check "$ParsingResult$" with "6" and data in "In.Parameter2" contains 'TextString Text="ОТМЕНА ПЛАТЕЖА'
		And I check "$ParsingResult$" with "6" and data in "In.Parameter2" contains '40.00'
		And I check "$ParsingResult$" with "7" and method is "PrintTextDocument"
		And I check "$ParsingResult$" with "7" and data in "In.Parameter2" contains 'TextString Text="ОТМЕНА ПЛАТЕЖА'
		And I check "$ParsingResult$" with "7" and data in "In.Parameter2" contains '50.00'
	And I close all client application windows
			
Scenario: _0850024 return by card without basis document (without RRN)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	And I click the button named "Return"
	* Select item
		And I click "Search by barcode (F7)" button
		And I input "23455677788976667" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "11111111111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Return
		And I click "Payment Return" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 03'      |
		And I select current line in "BankPaymentTypeList" table
		And "Payments" table became equal
			| 'Payment done'   | 'Payment type'   | 'Amount'   | 'RRNCode'    |
			| '⚪'              | 'Card 03'        | '200,00'   | ''           |
		Then "Payment" window is opened
		When I Check the steps for Exception
			| 'And I click "Revert" button'    |
		When I Check the steps for Exception
			| 'And I click "Return (in day)" button'    |
		And I click "Return" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click the button named "Enter" 
	* Check
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '200,00'    |
		And I select current line in "List" table
		And I move to "Payments" tab
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Postponed payment'   | 'Bank term'      | 'Account'        | 'Percent'   | 'RRN Code'    |
			| '1'   | '200,00'   | ''             | 'Card 03'        | ''                   | 'No'                  | 'Bank term 03'   | 'POS Terminal'   | '1,00'      | '*'           |
		And I click "Show hidden tables" button
		Then "Edit hidden tables" window is opened
		And I move to "ControlCodeStrings (1)" tab
		And "ControlCodeStrings" table became equal
			| 'Key'   | 'Code string'            | 'Code is approved'    |
			| '*'     | '11111111111111111111'   | 'Yes'                 |
		And I close all client application windows
	* Check acquiring log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "ReturnPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ВОЗВРАТ'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '200.00'
		And I check "$ParsingResult1$" with "1" and data in "In.Parameter6" contains ''
	* Check fiscal log
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML11"	

	
Scenario: _08500241 return by card without basis document (with RRN)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	And I click the button named "Return"
	* Select item
		And I click "Search by barcode (F7)" button
		And I input "23455677788976667" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "11111111111111111111" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "111,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Return
		And I click "Payment Return" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 03'      |
		And I select current line in "BankPaymentTypeList" table
		And "Payments" table became equal
			| 'Payment done'   | 'Payment type'   | 'Amount'   | 'RRNCode'    |
			| '⚪'              | 'Card 03'        | '111,00'   | ''           |
		And I activate "RRNCode" field in "Payments" table
		And I select current line in "Payments" table
		And I input "23457" text in "RRNCode" field of "Payments" table
		And I finish line editing in "Payments" table
		And I click the button named "Enter"
		Then there are lines in TestClient message log
			|'Not all payment done.'|
		When I Check the steps for Exception
			| 'And I click "Revert" button'    |
		When I Check the steps for Exception
			| 'And I click "Return (in day)" button'    |
		And I go to line in "Payments" table
			| 'Amount' | 'Payment done' | 'Payment type' |
			| '111,00'  | '⚪'            | 'Card 03'      |
		And I activate "Payment type" field in "Payments" table
		And I click "Return" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button				
		And I click "OK" button
	* Check
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Amount'    |
			| '111,00'    |
		And I select current line in "List" table
		And I move to "Payments" tab
		And "Payments" table became equal
			| '#'   | 'Amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'   | 'Postponed payment'   | 'Bank term'      | 'Account'        | 'Percent'   | 'RRN Code'    |
			| '1'   | '111,00'   | ''             | 'Card 03'        | ''                   | 'No'                  | 'Bank term 03'   | 'POS Terminal'   | '1,00'      | '*'           |
		And I close all client application windows
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "ReturnPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ВОЗВРАТ'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '111.00'
		And I check "$ParsingResult1$" with "1" and data in "In.Parameter6" contains '23457'	

		
					
Scenario: _0850028 check acquiring in BR
	And I close all client application windows
	* Create BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"	
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select "Payment from customer by POS" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'       |
			| 'POS Terminal 2'    |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Lomaniti'       |
		And I select current line in "List" table
		And I activate "Payment terminal" field in "PaymentList" table
		And I click choice button of "Payment terminal" attribute in "PaymentList" table
		And I select current line in "List" table
		And I activate "Payment type" field in "PaymentList" table
		And I click choice button of "Payment type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 03'        |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormWrite"
		And I click "Pay by card" button
		* Check logs
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to "Other" tab
		And I save the value of "RRN Code" field as "RRNBankReceipt2"		
	* Check acquiring log
		And Delay 10
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "PayByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОПЛАТА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '100.00'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter6" contains '$RRNBankReceipt2$'		
				
Scenario: _0850029 return retail customer advanve from POS (card)
		And I close all client application windows
		And In the command interface I select "Retail" "Point of sale"
		* Select retail customer
			And I click "Search customer" button
			And I input "005" text in "ID" field
			And I move to the next attribute
			And I click "OK" button
		* Return advance
			And I click the button named "Return"
			And I click the button named "Advance"
			And I click "Card (*)" button
			And I go to line in "BankPaymentTypeList" table
				| 'Reference'     |
				| 'Card 03'       |
			And I select current line in "BankPaymentTypeList" table		
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click the button named "Enter"
			Then there are lines in TestClient message log
				|'Not all payment done.'|
			And I click "Return" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button					
			And I click "OK" button			
		* Check acquiring log
			And Delay 10
			And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
			And I check "$ParsingResult1$" with "1" and method is "ReturnPaymentByPaymentCard"
			And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ВОЗВРАТ'
			And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '200.00'
		* Check fiscal log	
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
			And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'ElectronicPayment="200"'
			And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'PaymentMethod="3"'
			And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'OperationType="2"'

Scenario: _0850030 return retail customer advanve from POS (cash)
		And I close all client application windows
		And In the command interface I select "Retail" "Point of sale"
		* Select retail customer
			And I click "Search customer" button
			And I input "005" text in "ID" field
			And I move to the next attribute
			And I click "OK" button
		* Return advance
			And I click the button named "Return"
			And I click the button named "Advance"		
			And I click "2" button
			And I click "0" button
			And I click "0" button
			And I click the button named "Enter"		
		* Check acquiring log
			And Delay 10
			And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
			And I check "$ParsingResult1$" with "1" and method is "ReturnPaymentByPaymentCard"
			And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ВОЗВРАТ'
			And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '200.00'
		* Check fiscal log	
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
			And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'Cash="200"'
			And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'PaymentMethod="3"'
			And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'OperationType="2"'

Scenario: _0850025 print receipt from sales return (cash)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
	* Select Retail sales receipt
		And I go to line in "List" table
			| 'Amount'         |
			| '210,00'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
		Then the form attribute named "StatusType" became equal to "Completed"		
		And I click the button named "FormWrite"
	* Try print receipt (RRR unpost)
		And I click "Print receipt" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML6"'    |
	* Try Print receipt (RRR with deletion mark)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button	
		And I click "Print receipt" button	
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"		
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML6"'    |
	* Check Print receipt (RRR posted, status Canceled)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click the button named "FormPost"	
		And I select "Canceled" exact value from "Status type" drop-down list	
		And I click "Print receipt" button
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML6"'    |
	* Check Print receipt (RRR posted, status Postponed)
		And I select "Postponed" exact value from "Status type" drop-down list			
		And I click "Print receipt" button
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML6"'    |
	* Check Print receipt (RRR posted, status Postponed with reserve)
		And I select "Postponed with reserve" exact value from "Status type" drop-down list			
		And I click "Print receipt" button
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML6"'    |
	* Check Print receipt (RRR posted, status Completed)
		And I select "Completed" exact value from "Status type" drop-down list			
		And I click "Print receipt" button
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML6"
				
Scenario: _08500251 sales return (bank credit)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
	* Select Retail sales receipt
		And I go to line in "List" table
			| 'Amount'         |
			| '118,00'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
		And I click "Post" button
		And I click "Print receipt" button
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML7"
						
Scenario: _0850026 sales return (card)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
	* Select Retail sales receipt
		And I go to line in "List" table
			| 'Amount'         |
			| '620,00'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenerate"
		And I expand current line in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Row presentation'            |
			| 'Product 1 with SLN (PZU)'    |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I move to "Payments" tab
		And I activate field named "PaymentsAmount" in "Payments" table
		And I select current line in "Payments" table
		And I input "520,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post" button
		And I click "Print receipt" button
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML8"

Scenario: _0850030 print X report
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	And I click "Print X Report" button
	And Delay 5
	And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
	And I check "$ParsingResult$" with "0" and method is "PrintXReport"	



Scenario: _0260150 create cash out
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"	
	* Create cash out
		And I click "Create cash out" button
	* Check filling money transfer
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Shop 02"
		Then the form attribute named "Sender" became equal to "Pos cash account 1"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SenderCurrency" became equal to "TRY"
		Then the form attribute named "Receiver" became equal to "Cash desk №2"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiverCurrency" became equal to "TRY"
		And I input "1 000,00" text in "Send amount" field
		And I click "Create money transfer" button
		// Then in the TestClient message log contains lines by template:
		// 	|'Object Money transfer* created.'|		
	* Check creation
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Author'   | 'Company'        | 'Receive amount'   | 'Receive currency'   | 'Receiver'       | 'Send amount'   | 'Send currency'   | 'Sender'                |
			| 'CI'       | 'Main Company'   | '1 000,00'         | 'TRY'                | 'Cash desk №2'   | '1 000,00'      | 'TRY'             | 'Pos cash account 1'    |
		And I select current line in "List" table
		And I delete "$$NumberMoneyTransfer3$$" variable
		And I delete "$$MoneyTransfer3$$" variable
		And I save the value of "Number" field as "$$NumberMoneyTransfer3$$"
		And I save the window as "$$MoneyTransfer3$$"
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "CashInOutcome"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains '-1 000'
	* Create Cash receipt
		And I click "Cash receipt" button
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Cash in"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#'   | 'Total amount'   | 'Financial movement type'   | 'Money transfer'        |
			| '1'   | '1 000,00'       | 'Movement type 1'           | '$$MoneyTransfer3$$'    |
		Then the form attribute named "Branch" became equal to "Shop 02"
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "1 000,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I click "Post" button
		And I delete "$$NumberCashReceipt2$$" variable
		And I delete "$$CashReceipt2$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt2$$"
		And I save the window as "$$CashReceipt2$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And "List" table contains lines
			| 'Number'                   | 'Amount'     | 'Company'        | 'Cash account'   | 'Currency'   | 'Transaction type'   | 'Author'    |
			| '$$NumberCashReceipt2$$'   | '1 000,00'   | 'Main Company'   | 'Cash desk №2'   | 'TRY'        | 'Cash in'            | 'CI'        |
		And I close all client application windows		
		

Scenario: _0260150 check print cash in from Cash receipt form
	And I close all client application windows
	* Create cash receipt (cash in)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate" 
		And I select "Cash in" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'     |
			| 'TRY'        | 'Cash desk №4'    |
		And I select current line in "List" table
		And I click Select button of "Consolidated retail sales" field
		And I go to line in "List" table
			| 'Status'    |
			| 'Open'      |
		And I select current line in "List" table
		And in the table "PaymentList" I click "Add" button
		And I activate "Total amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "10,00" text in "Total amount" field of "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormWrite"
	* Try Print cash in (CR unposted)
		And I click "Print cash in" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		* Check fiscal log
			And Delay 2
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains "10"'    |
	* Try Print cash in (CR with deletion mark)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button	
		And I click "Print cash in" button	
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		* Check fiscal log
			And Delay 2
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains "10"'    |
	* Check Print cash in (CR posted)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click the button named "FormPost"	
		And I click "Print cash in" button
	* Check fiscal log
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "CashInOutcome"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains "10"
	* Check double click Print cash in
		And I click "Print cash in" button
		And I click "OK" button
		And I close all client application windows


Scenario: _0260151 check print cash out from Money transfer form
	And I close all client application windows
	* Create money transfer (cash out)
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I click the button named "FormCreate" 
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №3'    |
		And I select current line in "List" table
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table
		And I input "11,00" text in "Send amount" field		
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №2'    |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table
		And I input "11,00" text in "Receive amount" field	
		And I click Select button of "Send branch" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Shop 02'        |
		And I select current line in "List" table
		And I click Select button of "Receive branch" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Select button of "Consolidated retail sales" field
		And I go to line in "List" table
			| 'Status'    |
			| 'Open'      |
		And I select current line in "List" table
		And I click the button named "FormWrite"
	* Try Print cash out (MT unposted)
		And I click "Print cash out" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		* Check fiscal log
			And Delay 2
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains "11"'    |
	* Try Print cash out (MT with deletion mark)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button	
		And I click "Print cash out" button	
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		* Check fiscal log
			And Delay 2
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains "11"'    |
	* Check Print cash out (MT posted)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click the button named "FormPost"	
		And I click "Print cash out" button
	* Check fiscal log
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "CashInOutcome"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains "11"
	* Check double click Print cash out
		And I click "Print cash out" button
		And I click "OK" button
		And I close all client application windows


Scenario: _050055 check filling consignor in the RetailReturnReceipt from POS (select items)
		And I close all client application windows
	* Open POS and create RSR
		And In the command interface I select "Retail" "Point of sale"
		And I click the button named "Return"		
	* Add items
		And I expand a line in "ItemsPickup" table
			| 'Item'                                             |
			| 'Product 11 with SLN (Main Company - Consignor 1)' |
		And I go to line in "ItemsPickup" table
			| 'Item'                                                  |
			| 'Product 11 with SLN (Main Company - Consignor 1), PZU' |
		And I select current line in "ItemsPickup" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of the attribute named "SerialLotNumbersSerialLotNumber" in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner' | 'Serial number'  |
			| 'PZU'   | '11111111111112' |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "221,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I expand a line in "ItemsPickup" table
			| 'Item'                                                                     |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' |
		And I go to line in "ItemsPickup" table
			| 'Item'                                                                              |
			| 'Product 13 without SLN (Main Company - different consignor for item key), M/Black' |
		And I select current line in "ItemsPickup" table
		And I select current line in "ItemList" table
		And I input "101,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table		
		And I click "Payment Return" button
		And I click "Cash (/)" button		
		And I click the button named "Enter"
	* Check filling consignor
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"	
		And I go to line in "List" table
			| 'Amount'    |
			| '543,00'    |
		And I select current line in "List" table	
		And I click "Show row key" button
		And "ItemList" table became equal
			| 'Item'                                                                     | 'Consignor'   | 'Unit' | 'Item key' | 'Quantity' |
			| 'Product 11 with SLN (Main Company - Consignor 1)'                         | 'Consignor 1' | 'pcs'  | 'PZU'      | '2,000'    |
			| 'Product 13 without SLN (Main Company - different consignor for item key)' | 'Consignor 1' | 'pcs'  | 'M/Black'  | '1,000'    |
		And I close all client application windows
	* Check logs
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML9"



Scenario: _050056 return from previous Consolidated retail sales
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select basis document
		And I click the button named "Return"
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Retail sales receipt'                                |
			| 'Retail sales receipt 8 dated 10.05.2023 10:59:44'    |
		And I select current line in "List" table
	* Payment return
		And I click "Payment Return" button
		Then "Payment" window is opened
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference'    |
			| 'Card 04'      |
		And I select current line in "BankPaymentTypeList" table
		When I Check the steps for Exception
			| 'And I click "Cancel" button'    |
		And I click "Return" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click "OK" button
	* Check acquiring log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "ReturnPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ВОЗВРАТ'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '520.00'
	* Check fiscal log
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'ElectronicPayment="520"'
		And I check "$ParsingResult$" with "2" and method is "PrintTextDocument"
		And I check "$ParsingResult$" with "2" and data in "In.Parameter2" contains 'TextString Text="ВОЗВРАТ'
		And I check "$ParsingResult$" with "2" and data in "In.Parameter2" contains '520.00'
	And I close all client application windows	


Scenario: _0260154 Checking restrictions on Control State values in POS	
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"
	* Scan item with code
		And I click "Search by barcode (F7)" button
		And I input "89088088989" text in the field named "Barcode"
		And I move to the next attribute
		* Scan barcode instead of code 
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "89088088989" text in the field named "Barcode"
			And I move to the next attribute
			Then there are lines in TestClient message log
				| 'Scan control string barcode. Wrong barcode 89088088989'     |
		* Scan a code that is different from the one in the series
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "111111111111111111111112" text in the field named "Barcode"
			And I move to the next attribute
		* Add one more item and scan the same code (code frome another serial lot number)
			And I click "Search by barcode (F7)" button
			And I input "8908899880" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "111111111111111111111112" text in the field named "Barcode"
			And I move to the next attribute
			Then there are lines in TestClient message log
				| 'Current barcode already use at document line: 1'     |
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "111111111111111111111111" text in the field named "Barcode"
			And I move to the next attribute
			Then there are lines in TestClient message log
				| 'This is barcode used for Product 6 with SLN[PZU]'     |
		* Scan wrong code	
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "" text in the field named "Barcode"
			And I move to the next attribute
			Then the number of "CurrentCodes" table lines is "равно" 0
		* Scan correct code
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "11111111111111111111113" text in the field named "Barcode"
			And I move to the next attribute
	* Check
		And "ItemList" table became equal
			| 'Item'                 | 'Sales person'   | 'Item key'   | 'Serials'       | 'Price'   | 'Quantity'   | 'Offers'   | 'Total'    |
			| 'Product 6 with SLN'   | ''               | 'PZU'        | '89088088989'   | ''        | '1,000'      | ''         | ''         |
			| 'Product 1 with SLN'   | ''               | 'PZU'        | '8908899880'    | ''        | '1,000'      | ''         | ''         |
		And I delete all lines of "ItemList" table
				
	
Scenario: _0260155 disabling marking check in the Workstation
	And I close all client application windows
	* Disabling marking check
		Given I open hyperlink "e1cib/list/Catalog.Workstations"		
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I select current line in "List" table
		And I set checkbox "Ignore code string control"
		And I click "Save and close" button
	* Check 
		And In the command interface I select "Retail" "Point of sale"
	* Scan item with code
		And I click "Search by barcode (F7)" button
		And I input "89088088989" text in the field named "Barcode"
		And I move to the next attribute
		When I Check the steps for Exception
			| 'Then the form attribute named "DecorationInfo" became equal to "Scan control code"'    |
		When I Check the steps for Exception
			| 'Then the number of "CurrentCodes" table lines is "равно" 0'    |
		And I delete all lines of "ItemList" table
	* Enabling marking check
		Given I open hyperlink "e1cib/list/Catalog.Workstations"		
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I select current line in "List" table
		And I remove checkbox "Ignore code string control"
		And I click "Save and close" button
	* Check
		And In the command interface I select "Retail" "Point of sale"
		And I click "Search by barcode (F7)" button
		And I input "89088088989" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
		And I delete all lines of "ItemList" table
		
		
Scenario: _0260156 check marking code in the Retail sales receipt and Retail return receipt
	And I close all client application windows
	* Create RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "89088088989" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute	
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (1)" tab
		And "ControlCodeStrings" table became equal
			| 'Key'   | 'Code string'                                    | 'Code is approved'    |
			| '*'     | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0'   | 'Yes'                 |
		And I close current window
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Cash'           |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "100,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I activate "Account" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Currency'   | 'Description'     |
			| 'TRY'        | 'Cash desk №4'    |
		And I select current line in "List" table
		And I finish line editing in "Payments" table
		And I click "Post" button
	* Create RRR
		And I click "Sales return" button
		And I click "Ok" button
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (1)" tab
		And "ControlCodeStrings" table became equal
			| 'Key'   | 'Code string'                                    | 'Code is approved'    |
			| '*'     | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0'   | 'No'                  |
		And I close current window
	* Add one more item in RRR and check code
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "8908899880" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "11111111111111111111113" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Post" button
	* Check 
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (2)" tab	
		And "ControlCodeStrings" table became equal
			| 'Key'   | 'Code string'                                    | 'Code is approved'    |
			| '*'     | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0'   | 'No'                  |
			| '*'     | '11111111111111111111113'                        | 'Yes'                 |
		And I close all client application windows
		

Scenario: _0260157 check marking code when change item key in the RSR
		And I close all client application windows
	* Create RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "8908899880" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute	
	* Check marking code
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (1)" tab
		And "ControlCodeStrings" table became equal
			| 'Key'   | 'Code string'                                    | 'Code is approved'    |
			| '*'     | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0'   | 'Yes'                 |
		And I close current window
	* Change item key and check clean marking code
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'ODS'         |
		And I select current line in "List" table
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (0)" tab		
		Then the number of "ControlCodeStrings" table lines is "равно" 0
		And I close current window
	* Check marking code when change quantity
		And I delete all lines of "ItemList" table
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "8908899880" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute	
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (1)" tab
		Then the number of "ControlCodeStrings" table lines is "равно" 1
		And I close current window
				


Scenario: _0260158 check marking code when change item key in the RRR
		And I close all client application windows
	* Create RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "8908899880" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute	
	* Check marking code
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (1)" tab	
		And "ControlCodeStrings" table became equal
			| 'Key'   | 'Code string'                                    | 'Code is approved'    |
			| '*'     | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0'   | 'Yes'                 |
		And I close current window
	* Change item key and check clean marking code
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'ODS'         |
		And I select current line in "List" table
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (0)" tab	
		Then the number of "ControlCodeStrings" table lines is "равно" 0
		And I close current window
	* Check clean marking code when change quantity
		And I delete all lines of "ItemList" table
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "8908899880" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute	
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (1)" tab	
		Then the number of "ControlCodeStrings" table lines is "равно" 1
		And I close current window	
		And I close all client application windows	

Scenario: _0260159 check marking code without check code string
		And I close all client application windows
	* Create 
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		Then the form attribute named "StatusType" became equal to "Completed"	
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "999999999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
	* Check 
		And I click "Show hidden tables" button
		And I move to "ControlCodeStrings (1)" tab
		And "ControlCodeStrings" table contains lines
			| 'Key' | 'Code string' | 'Code is approved' | 'Not check' |
			| '*'   | '*'           | 'Yes'              | 'Yes'       |
	* Print RSR
		And I close current window
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Cash'        |
		And I select current line in "List" table
		And I activate "Account" field in "Payments" table
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №4' |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "100,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click the button named "FormWrite"
	* Try print receipt (RSR unpost)
		And I click "Print receipt" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML12"'    |
	* Try Print receipt (RSR with deletion mark)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button	
		And I click "Print receipt" button	
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML12"'    |
	* Check Print receipt (RSR posted, status Canceled)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click the button named "FormPost"	
		And I select "Canceled" exact value from "Status type" drop-down list		
		And I click "Print receipt" button
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML12"'    |
	* Check Print receipt (RSR posted, status Postponed)
		And I select "Postponed" exact value from "Status type" drop-down list			
		And I click "Print receipt" button
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML12"'    |
	* Check Print receipt (RSR posted, status Postponed with reserve)
		And I select "Postponed with reserve" exact value from "Status type" drop-down list			
		And I click "Print receipt" button
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
				| 'And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML12"'    |
	* Check Print receipt (RSR posted, status Completed)
		And I select "Completed" exact value from "Status type" drop-down list			
		And I click "Print receipt" button
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML12"		
		
Scenario: _0260160 check sale product control code string, without check, payment more than receipt sum
		And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Scan item with code
		And I click "Search by barcode (F7)" button
		And I input "8908899880" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Code string is missing" button
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "112,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		And I click "1" button
		And I click "2" button
		And I click "0" button
		And I click "OK" button
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML13"	

		
Scenario: _0260161 check return product control code string, without check
		And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Scan item with code
		And I click the button named "Return"
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Amount' |
			| '112,00' |
		And I select current line in "List" table
		And I activate "Control code string state" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click "Code string is missing" button
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML14"
				
	
Scenario: _0260162 receipt with marking code, return without marking code
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
	* Scan item with code
		And I click "Search by barcode (F7)" button
		And I input "8908899880" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "113,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML15"	
	* Return
		And I click the button named "Return"
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Amount' |
			| '113,00' |
		And I select current line in "List" table
		And I activate "Control code string state" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click "Code string is missing" button
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button	
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML16"

Scenario: _0260162 check button Print receipt (copy)
	And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to the last line in "List" table
		And I click "Print copy receipt" button
	* Check
		Then there are lines in TestClient message log
			|'Done'|
	* Check fiscal log
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "PrintCheckCopy"	
	And I close all client application windows

Scenario: _0260163 certificate sale (POS, without retail customer)
		And I close all client application windows
		And In the command interface I select "Retail" "Point of sale"	
	* Certificate sale
		And I click "Search by barcode (F7)" button
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check fiscal log			
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML17"


Scenario: _0260164 payment by certificate (POS)
		And I close all client application windows
		And In the command interface I select "Retail" "Point of sale"	
	* Select item
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "8908899880" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table		
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click the button named "SearchByBarcode"
		And I input "99999999999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Cash (/)" button
		And I click "2" button
		And I click "0" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference' |
			| 'Card 03'   |
		And I select current line in "BankPaymentTypeList" table
		And I click "Pay" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then "Payment" window is opened
		And I move to the next attribute	
		And I click "OK" button
	* Check fiscal log			
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML18"
	* Check acquiring log
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "PayByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОПЛАТА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '200.00'

Scenario: _0260165 Return of a product paid for with a certificate
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select RSR for return
		Then "Point of sales" window is opened
		And I click the button named "Return"
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to the first line in "List" table
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Item'               | 'Sales person' | 'Item key' | 'Serials'    | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress'              | ''             | 'XS/Blue'  | ''           | '520,00' | '1,000'    | ''       | '520,00' |
			| 'Product 1 with SLN' | ''             | 'PZU'      | '8908899880' | '200,00' | '1,000'    | ''       | '200,00' |
		And "BasisPayments" table contains lines
			| 'Payment type' | 'Amount' |
			| 'Certificate'  | '500,00' |
			| 'Cash'         | '20,00'  |
			| 'Card 03'      | '200,00' |
		Then the number of "BasisPayments" table lines is "равно" "3"
		And I go to line in "ItemList" table
			| 'Item'               |
			| 'Product 1 with SLN' |
		And I activate "Control code string state" field in "ItemList" table
		And I select current line in "ItemList" table
		And "CurrentCodes" table became equal
			| 'Type'         | 'Prefix' | 'Scanned codes'                                | 'Approved' | 'Not check' |
			| 'Marking code' | ''       | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0' | 'No'       | 'No'        |
		And I close current window		
		And I click "Payment Return" button
		Then "Payment" window is opened
		And "Payments" table became equal
			| 'Payment done' | 'Payment type' | 'Amount' | 'RRNCode' |
			| ' '            | 'Certificate'  | '500,00' | ''        |
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference' |
			| 'Card 03'   |
		And I select current line in "BankPaymentTypeList" table
		And I click "1" button
		And I click "0" button
		And I click "0" button
		And I click "Return (in day)" button
		Then "Cancellation confirmation" window is opened
		And I change checkbox "Yes, I do know what am I doing"
		And I click the button named "OK"	
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to the next attribute
		And I click "Cash (/)" button
		And I click "OK" button
	* Check fiscal log			
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML19"
	* Check acquiring log
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "CancelPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОТМЕНА ПЛАТЕЖА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '100.00'
				
		
Scenario: _0260166 return certificate
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"	
	* Sales
		And I click "Search by barcode (F7)" button
		And I input "99999999998" text in the field named "Barcode"
		And I move to the next attribute
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table	
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Return
		And I click the button named "Return"
		And I click "Search by barcode (F7)" button
		And I input "99999999998" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button				
	* Check fiscal log			
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML20"	
				
Scenario: _0260169 Good code data control sale (POS)
	And I close all client application windows
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"	
	* Sales
		And I click "Search by barcode (F7)" button
		And I input "89000008999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Search by barcode (F7)" button
		And I input "9099009909999999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Search by barcode (F7)" button
		And I input "899007788" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "SerialLotNumbers" I click "Add" button
		And I select "0514" from "Serial lot number" drop-down list by string in "SerialLotNumbers" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
		And I move to the next attribute
		And I save message text as "NumberRSR24"
		And I execute 1C:Enterprise script
        	| "Контекст.Insert("NumberRSR24", TrimR(Контекст["NumberRSR24"]))" | 
	* Check fiscal log
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML22"

Scenario: _02601691 check Good code data from RSR in the RRR (POS)
	And I close all client application windows
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"	
		And I click the button named "Return"
	* Select basis document
		And I move to "Return" tab
		And I click Select button of "Retail sales receipt (basis)" field	
		Then "Selection retail basis for return" window is opened
		And I go to line in "List" table
			| 'Amount' |
			| '900,00' |
		And I select current line in "List" table
	* Check Good code data filling
		And I go to line in "ItemList" table
			| 'Item'                                                                | 'Item key' | 'Price'  | 'Quantity' | 'Serials'     | 'Total'  |
			| 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | '300,00' | '1,000'    | '89000008999' | '300,00' |
		And I activate "Control code string state" field in "ItemList" table
		And I select current line in "ItemList" table
		Then the form attribute named "ControlCodeStringType" became equal to "Good code data"
		Then the form attribute named "isReturn" became equal to "Yes"	
		And "CurrentCodes" table became equal
			| 'Type'           | 'Prefix'        | 'Scanned codes'                                | 'Approved' | 'Not check' |
			| 'Good code data' | 'NotIdentified' | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1' | 'No'       | 'No'        |
		And I close current window
		And I go to line in "ItemList" table
			| 'Item'                                                                | 'Item key' | 'Price'  | 'Quantity' | 'Serials'          | 'Total'  |
			| 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'ODS'      | '300,00' | '1,000'    | '9099009909999999' | '300,00' |
		And I activate "Control code string state" field in "ItemList" table
		And I select current line in "ItemList" table
		Then the form attribute named "ControlCodeStringType" became equal to "Good code data"
		Then the form attribute named "isReturn" became equal to "Yes"
		And "CurrentCodes" table became equal
			| 'Type'           | 'Prefix'        | 'Scanned codes'                                | 'Approved' | 'Not check' |
			| 'Good code data' | 'NotIdentified' | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2' | 'No'       | 'No'        |
		And I close current window
	* Payment
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button
		And I move to the next attribute
		And I save message text as "NumberRRR"
		And I execute 1C:Enterprise script
        	| "Контекст.Insert("NumberRRR", TrimR(Контекст["NumberRRR"]))" |
		* Cancel RRR
			Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
			And I go to line in "List" table
				| 'Number'      |
				| '$NumberRRR$' |
			And I select current line in "List" table
			And I move to "Other" tab
			And I select "Canceled" exact value from "Status type" drop-down list
			And I click "Post and close" button
							
				

Scenario: _0260170 Good code data control return (POS)
	And I close all client application windows
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"	
		And I click the button named "Return"			
	* Return
		And I click "Search by barcode (F7)" button
		And I input "89000008999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Search by barcode (F7)" button
		And I input "9099009909999999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Search by barcode (F7)" button
		And I input "899007788" text in the field named "Barcode"
		And I move to the next attribute
		And in the table "SerialLotNumbers" I click "Add" button
		And I select "0514" from "Serial lot number" drop-down list by string in "SerialLotNumbers" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Select basis document
		And I move to "Return" tab
		And I click Select button of "Retail sales receipt (basis)" field	
		Then "Selection retail basis for return" window is opened
		And I go to line in "List" table
			| 'Amount' |
			| '900,00' |
		And I select current line in "List" table
	* Check Good code from RSR
		And I go to line in "ItemList" table
			| 'Item'                                                                | 'Item key' | 'Price'  | 'Quantity' | 'Serials'     | 'Total'  |
			| 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | '300,00' | '1,000'    | '89000008999' | '300,00' |
		And I activate "Control code string state" field in "ItemList" table
		And I select current line in "ItemList" table
		Then the form attribute named "ControlCodeStringType" became equal to "Good code data"
		Then the form attribute named "isReturn" became equal to "Yes"	
		And "CurrentCodes" table became equal
			| 'Type'           | 'Prefix'        | 'Scanned codes'                                | 'Approved' | 'Not check' |
			| 'Good code data' | 'NotIdentified' | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1' | 'No'       | 'No'        |
		And I close current window
		And I go to line in "ItemList" table
			| 'Item'                                                                | 'Item key' | 'Price'  | 'Quantity' | 'Serials'          | 'Total'  |
			| 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'ODS'      | '300,00' | '1,000'    | '9099009909999999' | '300,00' |
		And I activate "Control code string state" field in "ItemList" table
		And I select current line in "ItemList" table
		Then the form attribute named "ControlCodeStringType" became equal to "Good code data"
		Then the form attribute named "isReturn" became equal to "Yes"	
		And "CurrentCodes" table became equal
			| 'Type'           | 'Prefix'        | 'Scanned codes'                                | 'Approved' | 'Not check' |
			| 'Good code data' | 'NotIdentified' | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2' | 'No'       | 'No'        |
		And I close current window
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button
		And I move to the next attribute
	* Check fiscal log
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML23"
						
Scenario: _0260173 RSR and RRR for item with good code, scan marking code
	And I close all client application windows
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Add first item with with good code
		And I click "Search by barcode (F7)" button
		And I input "89000008999" text in the field named "Barcode"
		And I move to the next attribute
		Then the form attribute named "ControlCodeStringType" became equal to "Good code data"
		And I change "Control code string type" radio button value to "Marking code"
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY3" text in the field named "Barcode"
		And I move to the next attribute		
		And I input "301,11" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Search by barcode (F7)" button
		And I input "9099009909999999" text in the field named "Barcode"
		And I move to the next attribute
		Then the form attribute named "ControlCodeStringType" became equal to "Good code data"
		And I change "Control code string type" radio button value to "Marking code"
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY4" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
		And I move to the next attribute
	* Check fiscal log
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML24"	
	* Create RRR
		And I click the button named "Return"
		And I move to "Return" tab
		And I click Select button of "Retail sales receipt (basis)" field	
		Then "Selection retail basis for return" window is opened
		And I go to line in "List" table
			| 'Amount' |
			| '601,11' |
		And I select current line in "List" table
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button
		And I move to the next attribute
	* Check fiscal log
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML25"

						
Scenario: _0260174 RSR and RRR for item with marking code, scan good code
	And I close all client application windows
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Add first item with with good code
		And I click "Search by barcode (F7)" button
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		Then the form attribute named "ControlCodeStringType" became equal to "Marking code"
		And I change "Control code string type" radio button value to "Good code"
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY8" text in the field named "Barcode"
		And I move to the next attribute		
		And I input "401,11" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Search by barcode (F7)" button
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		Then the form attribute named "ControlCodeStringType" became equal to "Marking code"
		And I change "Control code string type" radio button value to "Good code"
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY9" text in the field named "Barcode"
		And I move to the next attribute
		And I select current line in "ItemList" table
		And I input "300,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
		And I move to the next attribute
	* Check fiscal log
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML26"	
	* Create RRR
		And I click the button named "Return"
		And I move to "Return" tab
		And I click Select button of "Retail sales receipt (basis)" field	
		Then "Selection retail basis for return" window is opened
		And I go to line in "List" table
			| 'Amount' |
			| '701,11' |
		And I select current line in "List" table
		And I click "Payment Return" button
		And I click "Cash (/)" button
		And I click "OK" button
		And I move to the next attribute
	* Check fiscal log
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML27"

Scenario: _0260175 check revert card payment for sales (POS)
	And I close all client application windows
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Add item
		And I click "Search by barcode (F7)" button
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		Then the form attribute named "ControlCodeStringType" became equal to "Marking code"
		And I change "Control code string type" radio button value to "Good code"
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY8" text in the field named "Barcode"
		And I move to the next attribute		
		And I input "401,11" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment by card
		And I click "Payment (+)" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference' |
			| 'Card 03'   |
		And I select current line in "BankPaymentTypeList" table
		When I Check the steps for Exception
			| 'And I click "Revert" button'    |
		And I click "Pay" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "PayByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОПЛАТА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '401.11'
		When I Check the steps for Exception
			| 'And I click "Pay" button'    |
	* Revert payment
		And I click "Revert" button
		Then "Cancellation confirmation" window is opened
		And I change checkbox "Yes, I do know what am I doing"
		And I click the button named "OK"
		And I click "OK" button
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "CancelPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОТМЕНА ПЛАТЕЖА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '401.11'
		When I Check the steps for Exception
			| 'And I click "Revert" button'    |
	* Try close receipt
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Not all payment done.'|
	* Payment
		And I click "Pay" button
		And I click "OK" button
		And I click "OK" button
		And I wait that in "ItemList" table number of lines will be "равно" 0 for 5 seconds
	* Check log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "PayByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОПЛАТА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '401.11'
		
Scenario: _0260176 check revert card payment for return (POS)
	And I close all client application windows
	* Preparation 
		If "Point of sales" window is opened Then
			And I delete all lines of "ItemList" table
		And In the command interface I select "Retail" "Point of sale"
	* Add item
		And I click the button named "Return"
		And I click "Search by barcode (F7)" button
		And I input "57897909799" text in the field named "Barcode"
		And I move to the next attribute
		Then the form attribute named "ControlCodeStringType" became equal to "Marking code"
		And I change "Control code string type" radio button value to "Good code"
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY8" text in the field named "Barcode"
		And I move to the next attribute		
		And I input "401,11" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Payment by card
		And I click "Payment Return" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference' |
			| 'Card 03'   |
		And I select current line in "BankPaymentTypeList" table
		When I Check the steps for Exception
			| 'And I click "Revert" button'    |
		And I click "Return" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "ReturnPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ВОЗВРАТ'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '401.11'
		When I Check the steps for Exception
			| 'And I click "Return" button'    |
	* Revert payment
		And I click "Revert" button
		Then "Cancellation confirmation" window is opened
		And I change checkbox "Yes, I do know what am I doing"
		And I click the button named "OK"
		And I click "OK" button
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "CancelPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ОТМЕНА ПЛАТЕЖА'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '401.11'
		When I Check the steps for Exception
			| 'And I click "Revert" button'    |
	* Try close receipt
		And I click "OK" button
		Then there are lines in TestClient message log
			|'Not all payment done.'|
	* Payment
		And I click "Return" button
		And I click "OK" button
		And I click "OK" button
		And I wait that in "ItemList" table number of lines will be "равно" 0 for 5 seconds
	* Check log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResult1"
		And I check "$ParsingResult1$" with "1" and method is "ReturnPaymentByPaymentCard"
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains 'ВОЗВРАТ'
		And I check "$ParsingResult1$" with "1" and data in "Out.Parameter8" contains '401.11'	

Scenario: _02602102 Retail receipt correction for RSR (cash, VAT rate correction)
	And I close all client application windows
	* Create RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click "Create" button
		* Consignor 1
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898789" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898791" text in the field named "Barcode"
			And I move to the next attribute
		* Consignor 2
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "9000008" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "900889900900778" text in the field named "Barcode"
			And I move to the next attribute
		* Own stock, without SLN
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283713" text in the field named "Barcode"
			And I move to the next attribute
		* Item with marking code
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "900999000009" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "11111111111111111111" text in the field named "Barcode"
			And I move to the next attribute
		* Item with good code data
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "89000008999" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2" text in the field named "Barcode"
			And I move to the next attribute
		And for each line of "ItemList" table I do
			And I input "100,00" text in "Price" field of "ItemList" table
		* Payment
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I select "cash" from "Payment type" drop-down list by string in "Payments" table
			And I activate "Account" field in "Payments" table
			And I select "Cash desk №4" from "Account" drop-down list by string in "Payments" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "700,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table
			And I click "Post" button
			And I save the window as "RSR02602102"
		* Fiscalize
			And I click "Print receipt" button
			Then there are lines in TestClient message log
				|'Done'|
	* Generate first Retail receipt correction (storno)
		And I click "Retail receipt correction" button
		* Check
			Then the form attribute named "Agreement" became equal to "Retail partner term"
			Then the form attribute named "Author" became equal to "CI"
			Then the form attribute named "BasisDocument" became equal to "$RSR02602102$"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the field named "ConsolidatedRetailSales" is filled
			Then the form attribute named "CorrectionDescription" became equal to ""
			And the editing text of form attribute named "CorrectionType" became equal to "Independent"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                                                | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Source of origins'  | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000008'             | 'pcs'  | ''           | 'Source of origin 8' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'PZU'      | 'Shop 02'            | 'No'                 | '900889900900778'     | 'pcs'  | ''           | 'Source of origin 9' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Own stocks'       | ''             | 'en description is empty' | 'Dress'                                                               | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                    | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 15 with SLN and code control (Main Company - Consignor 1)'   | 'ODS'      | 'Shop 02'            | 'No'                 | '900999000009'        | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '89000008999'         | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
			Then the form attribute named "Partner" became equal to "Retail customer"
			Then the form attribute named "PaymentMethod" became equal to "Full calculation"
			And "Payments" table became equal
				| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term' | 'Account'      | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
				| '1' | '700,00' | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | ''          | 'Cash desk №4' | ''        | ''         | ''                      | ''                         | ''                            |
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
			Then the form attribute named "StatusType" became equal to "Completed"
			Then the form attribute named "Store" became equal to "Store 01"
			Then the form attribute named "Workstation" became equal to "Workstation 01"
		* Fill correction description
			And I input "wrong VAT rate" text in "Correction description" field
			And I input "19.12.2023 13:24:48" text in the field named "Date"
			And I move to the next attribute
			And I click "Uncheck all" button
			And I click "OK" button	
			And I input "715" text in "Basis document fiscal number" field					
			And I click "Save" button
			And I save the window as "RRC1"
		* Fiscalize
			And I click "Print receipt" button
			Then there are lines in TestClient message log
				|'Done'| 
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And Delay 5
			And I check "$ParsingResult$" with "0" and method is "ProcessCorrectionCheck"
			And I check "$ParsingResult$" with "0" and data in "In.Parameter2" the same as "SalesReceiptXML28"
	* Generate second Retail receipt correction (change tax rate for two lines)
		And I click "Retail receipt correction" button
		And I go to line in "ItemList" table
			| 'Inventory origin' | 'Item'                    | 'Item key' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Consignor stocks' | 'Product with Unique SLN' | 'PZU'      | '15,25'      | '100,00'       | '18%' |
		And I select current line in "ItemList" table
		And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                             | 'Item key' | 'Net amount' | 'Unit' | 'VAT'         |
			| 'Product 16 with SLN (Main Company - Consignor 2)' | 'PZU'      | '100,00'     | 'pcs'  | 'Without VAT' |
		And I select current line in "ItemList" table
		And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check second Retail receipt correction
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "BasisDocument" became equal to "$RRC1$"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the field named "ConsolidatedRetailSales" is filled
		Then the form attribute named "CorrectionDescription" became equal to "wrong VAT rate"
		Then the form attribute named "Currency" became equal to "TRY"
		And "ItemList" table became equal
			| '#' | 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                                                | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Source of origins'  | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '2' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | ''           | ''                   | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '3' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000008'             | 'pcs'  | ''           | 'Source of origin 8' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '4' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'PZU'      | 'Shop 02'            | 'No'                 | '900889900900778'     | 'pcs'  | '15,25'      | 'Source of origin 9' | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '5' | 'Own stocks'       | ''             | 'en description is empty' | 'Dress'                                                               | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                    | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '6' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 15 with SLN and code control (Main Company - Consignor 1)'   | 'ODS'      | 'Shop 02'            | 'No'                 | '900999000009'        | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '7' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '89000008999'         | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term' | 'Account'      | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '700,00' | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | ''          | 'Cash desk №4' | ''        | ''         | ''                      | ''                         | ''                            |
		
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "StatusType" became equal to "Completed"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "UsePartnerTransactions" became equal to "No"
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		And I input "19.12.2023 13:24:48" text in the field named "Date"
		And I move to the next attribute
		And I click "Uncheck all" button
		And I click "OK" button	
		And I input "716" text in "Basis document fiscal number" field	
		And I click "Save" button
		And I save the window as "RRC2"
	* Fiscalize
		And I click "Print receipt" button
		Then there are lines in TestClient message log
			|'Done'|
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCorrectionCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter2" the same as "SalesReceiptXML29"

				
Scenario: _02602103 Retail receipt correction for RSR (card, VAT rate correction)
	And I close all client application windows
	* Create RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click "Create" button
		* Consignor 1
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898789" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898791" text in the field named "Barcode"
			And I move to the next attribute
		* Consignor 2
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "9000008" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "900889900900778" text in the field named "Barcode"
			And I move to the next attribute
		* Own stock, without SLN
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283713" text in the field named "Barcode"
			And I move to the next attribute
		* Item with marking code
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "900999000009" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "11111111111111111111" text in the field named "Barcode"
			And I move to the next attribute
		* Item with good code data
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "89000008999" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2" text in the field named "Barcode"
			And I move to the next attribute
		And for each line of "ItemList" table I do
			And I input "100,00" text in "Price" field of "ItemList" table
		* Payment
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I select "Card 02" from "Payment type" drop-down list by string in "Payments" table
			And I select "Bank term 02" from "Bank term" drop-down list by string in "Payments" table
			And I activate "Account" field in "Payments" table
			And I select "Transit Second" from "Account" drop-down list by string in "Payments" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "700,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table
			And I click "Post" button
			And I save the window as "RSR02602103"
		* Fiscalize
			And I click "Print receipt" button
			Then there are lines in TestClient message log
				|'Done'|
	* Generate first Retail receipt correction (storno)
		And I click "Retail receipt correction" button
		* Check
			Then the form attribute named "Agreement" became equal to "Retail partner term"
			Then the form attribute named "Author" became equal to "CI"
			Then the form attribute named "BasisDocument" became equal to "$RSR02602103$"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the field named "ConsolidatedRetailSales" is filled
			Then the form attribute named "CorrectionDescription" became equal to ""
			And the editing text of form attribute named "CorrectionType" became equal to "Independent"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                                                | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Source of origins'  | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000008'             | 'pcs'  | ''           | 'Source of origin 8' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'PZU'      | 'Shop 02'            | 'No'                 | '900889900900778'     | 'pcs'  | ''           | 'Source of origin 9' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Own stocks'       | ''             | 'en description is empty' | 'Dress'                                                               | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                    | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 15 with SLN and code control (Main Company - Consignor 1)'   | 'ODS'      | 'Shop 02'            | 'No'                 | '900999000009'        | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '89000008999'         | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
			Then the form attribute named "Partner" became equal to "Retail customer"
			Then the form attribute named "PaymentMethod" became equal to "Full calculation"
			And "Payments" table became equal
				| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'    | 'Account'        | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
				| '1' | '700,00' | '14,00'      | ''            | 'Card 02'      | ''                        | ''                                  | ''                 | 'Bank term 02' | 'Transit Second' | '2,00'    | ''         | ''                      | ''                         | ''                            |
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
			Then the form attribute named "StatusType" became equal to "Completed"
			Then the form attribute named "Store" became equal to "Store 01"
			Then the form attribute named "Workstation" became equal to "Workstation 01"
		* Fill correction description
			And I input "wrong VAT rate" text in "Correction description" field
			And I input "19.12.2023 14:15:51" text in the field named "Date"
			And I move to the next attribute
			And I click "Uncheck all" button
			And I click "OK" button
			And I input "717" text in "Basis document fiscal number" field		
			And I click "Save" button
			And I save the window as "RRC1"
		* Fiscalize
			And I click "Print receipt" button
			Then there are lines in TestClient message log
				|'Done'| 
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And Delay 5
			And I check "$ParsingResult$" with "0" and method is "ProcessCorrectionCheck"
			And I check "$ParsingResult$" with "0" and data in "In.Parameter2" the same as "SalesReceiptXML30"
	* Generate second Retail receipt correction (change tax rate for two lines)
		And I click "Retail receipt correction" button
		And I go to line in "ItemList" table
			| 'Inventory origin' | 'Item'                    | 'Item key' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Consignor stocks' | 'Product with Unique SLN' | 'PZU'      | '15,25'      | '100,00'       | '18%' |
		And I select current line in "ItemList" table
		And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                             | 'Item key' | 'Net amount' | 'Unit' | 'VAT'         |
			| 'Product 16 with SLN (Main Company - Consignor 2)' | 'PZU'      | '100,00'     | 'pcs'  | 'Without VAT' |
		And I select current line in "ItemList" table
		And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check second Retail receipt correction
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "BasisDocument" became equal to "$RRC1$"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the field named "ConsolidatedRetailSales" is filled
		Then the form attribute named "CorrectionDescription" became equal to "wrong VAT rate"
		Then the form attribute named "Currency" became equal to "TRY"
		And "ItemList" table became equal
			| '#' | 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                                                | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Source of origins'  | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '2' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | ''           | ''                   | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '3' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000008'             | 'pcs'  | ''           | 'Source of origin 8' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '4' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'PZU'      | 'Shop 02'            | 'No'                 | '900889900900778'     | 'pcs'  | '15,25'      | 'Source of origin 9' | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '5' | 'Own stocks'       | ''             | 'en description is empty' | 'Dress'                                                               | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                    | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '6' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 15 with SLN and code control (Main Company - Consignor 1)'   | 'ODS'      | 'Shop 02'            | 'No'                 | '900999000009'        | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '7' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '89000008999'         | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'    | 'Account'        | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '700,00' | '14,00'      | ''            | 'Card 02'      | ''                        | ''                                  | ''                 | 'Bank term 02' | 'Transit Second' | '2,00'    | ''         | ''                      | ''                         | ''                            |
		
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "StatusType" became equal to "Completed"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "UsePartnerTransactions" became equal to "No"
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		And I input "19.12.2023 14:15:51" text in the field named "Date"
		And I move to the next attribute
		And I click "Uncheck all" button
		And I click "OK" button	
		And I input "718" text in "Basis document fiscal number" field	
		And I click "Save" button
		And I save the window as "RRC2"
	* Fiscalize
		And I click "Print receipt" button
		Then there are lines in TestClient message log
			|'Done'|
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCorrectionCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter2" the same as "SalesReceiptXML31"					


Scenario: _02602104 Retail receipt correction for RRR (cash, VAT rate correction)
	And I close all client application windows
	* Create RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click "Create" button
		* Consignor 1
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898789" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898791" text in the field named "Barcode"
			And I move to the next attribute
		* Consignor 2
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "9000008" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "900889900900778" text in the field named "Barcode"
			And I move to the next attribute
		* Own stock, without SLN
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283713" text in the field named "Barcode"
			And I move to the next attribute
		* Item with marking code
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "900999000009" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "11111111111111111111" text in the field named "Barcode"
			And I move to the next attribute
		* Item with good code data
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "89000008999" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2" text in the field named "Barcode"
			And I move to the next attribute
		And for each line of "ItemList" table I do
			And I input "100,00" text in "Price" field of "ItemList" table
		And for each line of "ItemList" table I do
			And I input "10,00" text in "Landed cost" field of "ItemList" table
		* Payment
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I select "cash" from "Payment type" drop-down list by string in "Payments" table
			And I activate "Account" field in "Payments" table
			And I select "Cash desk №4" from "Account" drop-down list by string in "Payments" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "700,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table
			And I click "Post" button
			And I save the window as "RRR02602104"
		* Fiscalize
			And I click "Print receipt" button
	* Generate first Retail receipt correction (storno)
		And I click "Retail receipt correction" button
		* Check
			Then the form attribute named "Agreement" became equal to "Retail partner term"
			Then the form attribute named "Author" became equal to "CI"
			Then the form attribute named "BasisDocument" became equal to "$RRR02602104$"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the field named "ConsolidatedRetailSales" is filled
			Then the form attribute named "CorrectionDescription" became equal to ""
			And the editing text of form attribute named "CorrectionType" became equal to "Independent"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                                                | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Source of origins'  | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000008'             | 'pcs'  | ''           | 'Source of origin 8' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'PZU'      | 'Shop 02'            | 'No'                 | '900889900900778'     | 'pcs'  | ''           | 'Source of origin 9' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Own stocks'       | ''             | 'en description is empty' | 'Dress'                                                               | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                    | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 15 with SLN and code control (Main Company - Consignor 1)'   | 'ODS'      | 'Shop 02'            | 'No'                 | '900999000009'        | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '89000008999'         | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
			Then the form attribute named "Partner" became equal to "Retail customer"
			Then the form attribute named "PaymentMethod" became equal to "Full calculation"
			And "Payments" table became equal
				| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term' | 'Account'      | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
				| '1' | '700,00' | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | ''          | 'Cash desk №4' | ''        | ''         | ''                      | ''                         | ''                            |
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
			Then the form attribute named "StatusType" became equal to "Completed"
			Then the form attribute named "Store" became equal to "Store 01"
			Then the form attribute named "Workstation" became equal to "Workstation 01"
		* Fill correction description
			And I input "wrong VAT rate" text in "Correction description" field
			And I input "19.12.2023 14:50:09" text in the field named "Date"
			And I move to the next attribute
			And I click "Uncheck all" button
			And I click "OK" button	
			And I input "719" text in "Basis document fiscal number" field	
			And I click "Save" button
			And I save the window as "RRC1"
		* Fiscalize
			And I click "Print receipt" button
			Then there are lines in TestClient message log
				|'Done'| 
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And Delay 5
			And I check "$ParsingResult$" with "0" and method is "ProcessCorrectionCheck"
			And I check "$ParsingResult$" with "0" and data in "In.Parameter2" the same as "SalesReceiptXML32"
	* Generate second Retail receipt correction (change tax rate for two lines)
		And I click "Retail receipt correction" button
		And I go to line in "ItemList" table
			| 'Inventory origin' | 'Item'                    | 'Item key' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Consignor stocks' | 'Product with Unique SLN' | 'PZU'      | '15,25'      | '100,00'       | '18%' |
		And I select current line in "ItemList" table
		And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                             | 'Item key' | 'Net amount' | 'Unit' | 'VAT'         |
			| 'Product 16 with SLN (Main Company - Consignor 2)' | 'PZU'      | '100,00'     | 'pcs'  | 'Without VAT' |
		And I select current line in "ItemList" table
		And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check second Retail receipt correction
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "BasisDocument" became equal to "$RRC1$"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the field named "ConsolidatedRetailSales" is filled
		Then the form attribute named "CorrectionDescription" became equal to "wrong VAT rate"
		Then the form attribute named "Currency" became equal to "TRY"
		And "ItemList" table became equal
			| '#' | 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                                                | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Source of origins'  | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '2' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | ''           | ''                   | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '3' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000008'             | 'pcs'  | ''           | 'Source of origin 8' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '4' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'PZU'      | 'Shop 02'            | 'No'                 | '900889900900778'     | 'pcs'  | '15,25'      | 'Source of origin 9' | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '5' | 'Own stocks'       | ''             | 'en description is empty' | 'Dress'                                                               | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                    | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '6' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 15 with SLN and code control (Main Company - Consignor 1)'   | 'ODS'      | 'Shop 02'            | 'No'                 | '900999000009'        | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '7' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '89000008999'         | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term' | 'Account'      | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '700,00' | ''           | ''            | 'Cash'         | ''                        | ''                                  | ''                 | ''          | 'Cash desk №4' | ''        | ''         | ''                      | ''                         | ''                            |
		
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "StatusType" became equal to "Completed"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "UsePartnerTransactions" became equal to "No"
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		And I input "19.12.2023 14:50:09" text in the field named "Date"
		And I move to the next attribute
		And I click "Uncheck all" button
		And I click "OK" button
		And I input "720" text in "Basis document fiscal number" field	
		And I click "Save" button
		And I save the window as "RRC2"
	* Fiscalize
		And I click "Print receipt" button
		Then there are lines in TestClient message log
			|'Done'|
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCorrectionCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter2" the same as "SalesReceiptXML33"

				
Scenario: _02602105 Retail receipt correction for RRR (card, VAT rate correction)
	And I close all client application windows
	* Create RSR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click "Create" button
		* Consignor 1
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898789" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "0909088998998898791" text in the field named "Barcode"
			And I move to the next attribute
		* Consignor 2
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "9000008" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "900889900900778" text in the field named "Barcode"
			And I move to the next attribute
		* Own stock, without SLN
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "2202283713" text in the field named "Barcode"
			And I move to the next attribute
		* Item with marking code
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "900999000009" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "11111111111111111111" text in the field named "Barcode"
			And I move to the next attribute
		* Item with good code data
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "89000008999" text in the field named "Barcode"
			And I move to the next attribute
			And I click "Search by barcode" button
			And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY2" text in the field named "Barcode"
			And I move to the next attribute
		And for each line of "ItemList" table I do
			And I input "100,00" text in "Price" field of "ItemList" table
		And for each line of "ItemList" table I do
			And I input "10,00" text in "Landed cost" field of "ItemList" table
		* Payment
			And I move to "Payments" tab
			And in the table "Payments" I click the button named "PaymentsAdd"
			And I activate "Payment type" field in "Payments" table
			And I select current line in "Payments" table
			And I select "Card 02" from "Payment type" drop-down list by string in "Payments" table
			And I select "Bank term 02" from "Bank term" drop-down list by string in "Payments" table
			And I activate "Account" field in "Payments" table
			And I select "Transit Second" from "Account" drop-down list by string in "Payments" table
			And I activate field named "PaymentsAmount" in "Payments" table
			And I input "700,00" text in the field named "PaymentsAmount" of "Payments" table
			And I finish line editing in "Payments" table
			And I click "Post" button
			And I save the window as "RSR02602105"
		* Fiscalize
			And I click "Print receipt" button
	* Generate first Retail receipt correction (storno)
		And I click "Retail receipt correction" button
		* Check
			Then the form attribute named "Agreement" became equal to "Retail partner term"
			Then the form attribute named "Author" became equal to "CI"
			Then the form attribute named "BasisDocument" became equal to "$RSR02602105$"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the field named "ConsolidatedRetailSales" is filled
			Then the form attribute named "CorrectionDescription" became equal to ""
			And the editing text of form attribute named "CorrectionType" became equal to "Independent"
			And "ItemList" table became equal
				| 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                                                | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Source of origins'  | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000008'             | 'pcs'  | ''           | 'Source of origin 8' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'PZU'      | 'Shop 02'            | 'No'                 | '900889900900778'     | 'pcs'  | ''           | 'Source of origin 9' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Own stocks'       | ''             | 'en description is empty' | 'Dress'                                                               | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                    | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 15 with SLN and code control (Main Company - Consignor 1)'   | 'ODS'      | 'Shop 02'            | 'No'                 | '900999000009'        | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
				| 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '89000008999'         | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			Then the form attribute named "LegalName" became equal to "Company Retail customer"
			Then the form attribute named "Partner" became equal to "Retail customer"
			Then the form attribute named "PaymentMethod" became equal to "Full calculation"
			And "Payments" table became equal
				| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'    | 'Account'        | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
				| '1' | '700,00' | '14,00'      | ''            | 'Card 02'      | ''                        | ''                                  | ''                 | 'Bank term 02' | 'Transit Second' | '2,00'    | ''         | ''                      | ''                         | ''                            |
			Then the form attribute named "PriceIncludeTax" became equal to "Yes"
			Then the form attribute named "StatusType" became equal to "Completed"
			Then the form attribute named "Store" became equal to "Store 01"
			Then the form attribute named "Workstation" became equal to "Workstation 01"
		* Fill correction description
			And I input "wrong VAT rate" text in "Correction description" field
			And I input "20.12.2023 12:00:00" text in the field named "Date"
			And I move to the next attribute
			And I click "Uncheck all" button
			And I click "OK" button
			And I input "721" text in "Basis document fiscal number" field	
			And I click "Save" button
			And I save the window as "RRC1"
		* Fiscalize
			And I click "Print receipt" button
			Then there are lines in TestClient message log
				|'Done'| 
		* Check fiscal log
			And Delay 5
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And Delay 5
			And I check "$ParsingResult$" with "0" and method is "ProcessCorrectionCheck"
			And I check "$ParsingResult$" with "0" and data in "In.Parameter2" the same as "SalesReceiptXML34"
	* Generate second Retail receipt correction (change tax rate for two lines)
		And I click "Retail receipt correction" button
		And I go to line in "ItemList" table
			| 'Inventory origin' | 'Item'                    | 'Item key' | 'Tax amount' | 'Total amount' | 'VAT' |
			| 'Consignor stocks' | 'Product with Unique SLN' | 'PZU'      | '15,25'      | '100,00'       | '18%' |
		And I select current line in "ItemList" table
		And I select "Without VAT" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'                                             | 'Item key' | 'Net amount' | 'Unit' | 'VAT'         |
			| 'Product 16 with SLN (Main Company - Consignor 2)' | 'PZU'      | '100,00'     | 'pcs'  | 'Without VAT' |
		And I select current line in "ItemList" table
		And I select "18%" exact value from "VAT" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check second Retail receipt correction
		Then the form attribute named "Agreement" became equal to "Retail partner term"
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "BasisDocument" became equal to "$RRC1$"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the field named "ConsolidatedRetailSales" is filled
		Then the form attribute named "CorrectionDescription" became equal to "wrong VAT rate"
		Then the form attribute named "Currency" became equal to "TRY"
		And "ItemList" table became equal
			| '#' | 'Inventory origin' | 'Sales person' | 'Price type'              | 'Item'                                                                | 'Item key' | 'Profit loss center' | 'Dont calculate row' | 'Serial lot numbers'  | 'Unit' | 'Tax amount' | 'Source of origins'  | 'Quantity' | 'Price'  | 'VAT'         | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Detail' | 'Sales order' | 'Revenue type' |
			| '1' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'ODS'      | 'Shop 02'            | 'No'                 | '0909088998998898789' | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '2' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product with Unique SLN'                                             | 'PZU'      | 'Shop 02'            | 'No'                 | '0909088998998898791' | 'pcs'  | ''           | ''                   | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '3' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'UNIQ'     | 'Shop 02'            | 'No'                 | '9000008'             | 'pcs'  | ''           | 'Source of origin 8' | '1,000'    | '100,00' | 'Without VAT' | ''              | '100,00'     | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '4' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN (Main Company - Consignor 2)'                    | 'PZU'      | 'Shop 02'            | 'No'                 | '900889900900778'     | 'pcs'  | '15,25'      | 'Source of origin 9' | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '5' | 'Own stocks'       | ''             | 'en description is empty' | 'Dress'                                                               | 'S/Yellow' | 'Shop 02'            | 'No'                 | ''                    | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '6' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 15 with SLN and code control (Main Company - Consignor 1)'   | 'ODS'      | 'Shop 02'            | 'No'                 | '900999000009'        | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
			| '7' | 'Consignor stocks' | ''             | 'en description is empty' | 'Product 16 with SLN and Good code data (Main Company - Consignor 1)' | 'PZU'      | 'Shop 02'            | 'No'                 | '89000008999'         | 'pcs'  | '15,25'      | ''                   | '1,000'    | '100,00' | '18%'         | ''              | '84,75'      | '100,00'       | ''                    | 'Store 01' | ''       | ''            | ''             |
		
		Then the form attribute named "LegalName" became equal to "Company Retail customer"
		Then the form attribute named "Partner" became equal to "Retail customer"
		Then the form attribute named "PaymentMethod" became equal to "Full calculation"
		And "Payments" table became equal
			| '#' | 'Amount' | 'Commission' | 'Certificate' | 'Payment type' | 'Financial movement type' | 'Payment agent legal name contract' | 'Payment terminal' | 'Bank term'    | 'Account'        | 'Percent' | 'RRN Code' | 'Payment agent partner' | 'Payment agent legal name' | 'Payment agent partner terms' |
			| '1' | '700,00' | '14,00'      | ''            | 'Card 02'      | ''                        | ''                                  | ''                 | 'Bank term 02' | 'Transit Second' | '2,00'    | ''         | ''                      | ''                         | ''                            |
		
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "StatusType" became equal to "Completed"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "UsePartnerTransactions" became equal to "No"
		Then the form attribute named "Workstation" became equal to "Workstation 01"
		And I input "20.12.2023 12:00:00" text in the field named "Date"
		And I move to the next attribute
		And I click "Uncheck all" button
		And I click "OK" button
		And I input "722" text in "Basis document fiscal number" field	
		And I click "Save" button
		And I save the window as "RRC2"
	* Fiscalize
		And I click "Print receipt" button
		Then there are lines in TestClient message log
			|'Done'|
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And Delay 5
		And I check "$ParsingResult$" with "0" and method is "ProcessCorrectionCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter2" the same as "SalesReceiptXML35"

Scenario: _0260211 try mark for deletion printed RSR
	And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Status'  |
			| 'Printed' |
	* Try mark for deletion printed RSR
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then in the TestClient message log contains lines by template:
			|'Error! Receipt is already printed:*'|

				
Scenario: _0260212 try mark for deletion printed RRR
	And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Status'  |
			| 'Printed' |
	* Try mark for deletion printed RRR
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then in the TestClient message log contains lines by template:
			|'Error! Receipt is already printed:*'|

Scenario: _0260213 try unpost printed RSR
	And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Status'  |
			| 'Printed' |
	* Try unpost printed RSR
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then in the TestClient message log contains lines by template:
			|'Error! Receipt is already printed:*'|

Scenario: _0260214 try unpost printed RRR
	And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Status'  | 'Status type' |
			| 'Printed' | 'Completed'   |
	* Try mark for deletion printed RRR
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then in the TestClient message log contains lines by template:
			|'Error! Receipt is already printed:*'|

Scenario: _0260215 try card payment without amount
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"
	* Add item
		And I click "Search by barcode (F7)" button		
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
	* Payment
		And I click "Payment (+)" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference' |
			| 'Card 03'   |
		And I select current line in "BankPaymentTypeList" table
		And I activate field named "PaymentsAmountString" in "Payments" table
		And I select current line in "Payments" table
		And I click "⌫" button
		And I click "Pay" button
		Then there are lines in TestClient message log
			|'Row: 1. Payment amount is zero'|
		And I click "5" button
		And I click "2" button
		And I click "0" button
		And I click "OK" button
		And I click "Pay" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to the next attribute
		And I click "OK" button
	And I close all client application windows

Scenario: _0260152 close session
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"	
	* Close session
		And I click "Close session" button
		And I set checkbox named "CashConfirm"
		And I set checkbox named "TerminalConfirm"
		And I set checkbox named "CashConfirm"
		And I move to the next attribute		
		And I click "Close session" button
		And Delay 5
	* Check fiscal log
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "CloseShift"	
				
Scenario: _02601521 open and close session without sales
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"	
	* Open and close session
		And I click "Open session" button
		And I click "Close session" button
		And Delay 5
		And I set checkbox named "CashConfirm"
		And I set checkbox named "TerminalConfirm"
		And I set checkbox named "CashConfirm"
		And I move to the next attribute		
		And I click "Close session" button
	* Сheck that Money transfer is not created 
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And "List" table does not contain lines
			| 'Send amount' | 'Receive amount' |
			| ''            | ''               |
		And I close all client application windows
		
		

Scenario: _0260153 check hardware parameter saving
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		* Create hardware
			And I click "Create" button
			And I input "Test" text in the field named "Description"
			And I select "Fiscal printer" exact value from "Types of Equipment" drop-down list
			And I click Choice button of the field named "Driver"
			And I go to line in "List" table
				| 'Description'     |
				| 'KKT_3004'        |
			And I select current line in "List" table
			And I expand "Additional info" group
			And I input "Sale address" text in "Sale address" field
			And I input "Sale location" text in "Sale location" field		
			And I click "Save" button
			And I move to "Driver settings" tab
			And in the table "DriverParameter" I click "Reload settings" button
			And I move to "Predefined settings" tab
			And in the table "ConnectParameters" I click "Load settings" button
			And "ConnectParameters" table became equal
				| '#'    | 'Name'    | 'Value'     |
				| '1'    | 'Show'    | 'Yes'       |
		* Check parameter saving
			And I activate field named "ConnectParametersValue" in "ConnectParameters" table
			And I select current line in "ConnectParameters" table
			And I go to line in "" table
				| ''            |
				| 'Boolean'     |
			And I select current line in "" table
			And I click choice button of the attribute named "ConnectParametersValue" in "ConnectParameters" table
			And I select current line in "" table
			And I select "No" exact value from the drop-down list named "ConnectParametersValue" in "ConnectParameters" table
			And I activate field named "ConnectParametersName" in "ConnectParameters" table
			And I finish line editing in "ConnectParameters" table
			And I click "Save" button
			And in the table "ConnectParameters" I click "Write settings" button
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Description'     |
				| 'Test'            |
			And I select current line in "List" table
			And "ConnectParameters" table became equal
				| '#'    | 'Name'    | 'Value'     |
				| '1'    | 'Show'    | 'No'        |
			And I close all client application windows
				
					
Scenario: _0260160 check Get Last Error button
	And I close all client application windows
	* Open hardware
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		And I go to line in "List" table
			| 'Description'    |
			| 'Fiscal printer' |
		And I select current line in "List" table
	* Check button Get Last Error	
		And I click "Get last error" button
		Then there are lines in TestClient message log
			|'Fiscal printer: '|
		And I close all client application windows
												


Scenario: _0260180 check fiscal logs
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.HardwareLog"
	Then the number of "List" table lines is "равно" "928"	
	* Check log records form
		And I go to the first line in "List" table
		And I select current line in "List" table
		Then the form attribute named "User" became equal to "CI"
		Then the form attribute named "Hardware" became equal to "Fiscal printer"
	And I close all client application windows

Scenario: _0260182 check print X report when session closed
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"
	* Check X report
		Then "Point of sales" window is opened
		And I click "Print X Report" button
	* Check fiscal log
		And Delay 3
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "PrintXReport"	
	And I close all client application windows				 

Scenario: _0260185 print settlement from the terminal
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"
	* Check settlement
		And I click "Settlement (without shift close)" button
		And I click "Get settlement" button
		And I click "Print last settlement" button
	* Check log
		And Delay 3
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "PrintTextDocument"	
		And I parsed the log of the fiscal emulator by the path '$$LogPathAcquiring$$' into the variable "ParsingResultAcquiring"	
		And I check "$ParsingResultAcquiring$" with "1" and method is "Settlement"


Scenario: _0260186 check show fiscal transaction from POS
	And I close all client application windows
	* Open POS		
		And In the command interface I select "Retail" "Point of sale"
	* Show transaction
		And I click "Show transactions" button
		Then the form attribute named "Period" became equal to "Today"
		Then the form attribute named "TimeZone" became equal to "2"
		Then the form attribute named "Hardware" became equal to "Acquiring terminal"
		Then the form attribute named "FiscalPrinter" became equal to "Fiscal printer"
		Then the number of "TransactionList" table lines is "больше" "0"
	And I close all client application windows



				
Scenario: _0260190 check numbers and fiscal status in the RSR and RRR list forms
	And I close all client application windows
	* Open RSR list form
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And "List" table contains lines 
			| 'Amount'      | 'Company'      | 'Check number' | 'Status'  | 'Store'    | 'Consolidated retail sales' |
			| '300,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '720,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '840,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '118,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '210,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '620,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '100,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '100,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '112,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '113,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '500,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '720,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
			| '300,00' | 'Main Company' | '*'            | 'Printed' | 'Store 01' | '*'                         |
	* Open RRR list form
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And "List" table contains lines
			| 'Partner'         | 'Amount' | 'Company'      | 'Check number' | 'Status'  | 'Legal name'              | 'Currency' | 'Store'    | 'Author' |
			| 'Retail customer' | '100,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '200,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '111,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '210,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Customer'        | '118,00' | 'Main Company' | '*'            | 'Printed' | 'Customer'                | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '520,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '543,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '520,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '112,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '113,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '720,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
			| 'Retail customer' | '300,00' | 'Main Company' | '*'            | 'Printed' | 'Company Retail customer' | 'TRY'      | 'Store 01' | 'CI'     |
		And I close all client application windows
		
				
Scenario: _0260191 check session open and close from CRS
	And I close all client application windows
	* Create CRS
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Cash account" drop-down list by "Pos cash account 1" string
		And I select from the drop-down list named "Status" by "new" string
		And I input current date in "Opening date" field
		And I select from "Fiscal printer" drop-down list by "fiscal" string
		And I select from the drop-down list named "Branch" by "Shop 02" string
		And I click the button named "FormWrite"	
	* Try open session (CRS unpost)
		And I click "Open session" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"	
		* Check log
			And Delay 3
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			When I Check the steps for Exception
			| 'And I check "$ParsingResult$" with "0" and method is "OpenShift"'    |
	* Post CRS
		And I click the button named "FormPost"
	* Try Close session
		And I click "Close session" button
		Then there are lines in TestClient message log
			|'Cash shift can only be closed for a document with the status "Open".'|
		And I select from the drop-down list named "Status" by "open" string
		And I click "Close session" button
		Then there are lines in TestClient message log
			|'Shift already closed.'|		
		* Check log
			And Delay 3
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			// And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'ShiftState="1"'
	* Try open session (status open)
		And I select from the drop-down list named "Status" by "open" string
		And I click "Open session" button
		Then there are lines in TestClient message log
			|'Cash shift can only be opened for a document with the status "New".'|
		* Check log
			And Delay 3
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And I check "$ParsingResult$" with "0" and method is "GetCurrentStatus"
	* Try open session (status cancel)
		And I select from the drop-down list named "Status" by "cancel" string
		And I click "Open session" button
		Then there are lines in TestClient message log
			|'Cash shift can only be opened for a document with the status "New".'|
		* Check log
			And Delay 3
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And I check "$ParsingResult$" with "0" and method is "GetCurrentStatus"
	* Try open session (status close)
		And I select from the drop-down list named "Status" by "close" string
		And I click "Open session" button
		Then there are lines in TestClient message log
			|'Cash shift can only be opened for a document with the status "New".'|
		* Check log
			And Delay 3
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And I check "$ParsingResult$" with "0" and method is "GetCurrentStatus"
	* Try open session (CRS with deletion mark)
		And I select from the drop-down list named "Status" by "new" string
		And I click the button named "FormPost"
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click "Open session" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"	
		* Check log
			And Delay 3
			And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
			And I check "$ParsingResult$" with "0" and method is "GetCurrentStatus"			
	* Try open session (CRS without deletion mark, status new)
		And I click "Mark for deletion / Unmark for deletion" button
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click the button named "FormPost"
		And I select from the drop-down list named "Status" by "new" string
		And I click "Open session" button	
		And I click "Reread" button
		Then the form attribute named "Status" became equal to "Open"
	* Check log
		And Delay 3
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "OpenShift"			
	* Close session
		And I click "Close session" button	
		And I set checkbox named "CashConfirm"
		And I set checkbox named "TerminalConfirm"
		And I set checkbox named "CashConfirm"
		And I move to the next attribute
		And I click "Close session" button
	* Check log
		And Delay 3
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "CloseShift"
	And I close all client application windows
	
// Scenario: _0260188 check of retrieving the previous consolidated sales receipt when opening a cash session
// 	And I close all client application windows
// 	* Create Consolidated retail sales with status New
// 		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
// 		And I click the button named "FormCreate"	
// 		And I select from the drop-down list named "Company" by "Main Company" string
// 		And I select from "Cash account" drop-down list by "Pos cash account 1" string
// 		And I select "New" exact value from the drop-down list named "Status"
// 		And I input current date in "Opening date" field
// 		And I select "Fiscal printer" exact value from "Fiscal printer" drop-down list
// 		And I move to "Other" tab
// 		And I click Choice button of the field named "Branch"
// 		And I go to line in "List" table
// 			| 'Description' |
// 			| 'Shop 01'     |
// 		And I select current line in "List" table
// 		And I click the button named "FormPost"
// 		And I delete "$$NumberNumberCSR88$$" variable
// 		And I save the value of "Number" field as "$$NumberCSR88$$"
// 		And I click "Post and close" button
// 		And I close all client application windows
// 	* Try open cash session and check retrieving the previous consolidated sales
// 		And In the command interface I select "Retail" "Point of sale"
// 		And I click "Open session" button
// 	* Check 
// 		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
// 		And "List" table contains lines
// 			| 'Number'          | 'Status' |
// 			| '$$NumberCSR88$$' | 'Open'   |
		


Scenario: _0260187 add one more Acquiring terminal and check open and close session
	And I close all client application windows
	* Create one more Acquiring terminal
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		And I go to line in "List" table
			| 'Description'        | 'Equipment API module' | 'Types of Equipment' |
			| 'Acquiring terminal' | 'Acquiring Common API' | 'Acquiring'          |
		And in the table "List" I click the button named "ListContextMenuCopy"
		And I input "Acquiring terminal 2" text in the field named "Description"
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'          |
			| 'Acquiring terminal 2' |
	* Add one more Acquiring terminal to the workstation 1
		Given I open hyperlink "e1cib/list/Catalog.Workstations"        
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I select current line in "List" table
		And in the table "HardwareList" I click "Add" button
		And I click choice button of "Hardware" attribute in "HardwareList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Acquiring terminal 2' |
		And I select current line in "List" table
		And I set "Enable" checkbox in "HardwareList" table
		And I finish line editing in "HardwareList" table
		And I click "Save and close" button
		And I wait "Workstation * (Workstation) *" window closing in 5 seconds
	* Open session
		And In the command interface I select "Retail" "Point of sale"
		And I click "Open session" button
	* Close session
		And I click "Close session" button
		And Delay 2
		And I set checkbox named "CashConfirm"
		And I set checkbox named "TerminalConfirm"
		And I set checkbox named "CashConfirm"
		And I move to the next attribute		
		And I click "Close session" button
	* Check log
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
		And I go to line in "List" table
			| 'Description'        |
			| 'Acquiring terminal' |
		And I go to line in "List" table and invert selection:
			|"Description"|
			| "Acquiring terminal 2" | 
		And I click "Analyze log" button
		And "TransactionList" table contains lines
			| 'Period' | 'Hardware'             | 'Method'     | 'Result' |
			| '*'      | 'Acquiring terminal'   | 'Settlement' | 'Yes'    |
			| '*'      | 'Acquiring terminal 2' | 'Settlement' | 'Yes'    |
			| '*'      | 'Acquiring terminal'   | 'Settlement' | 'Yes'    |
			| '*'      | 'Acquiring terminal 2' | 'Settlement' | 'Yes'    |
	And I close all client application windows


Scenario: _0260189 print X report from CRS
	And I close all client application windows
	* Create CRS and open session
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Cash account" drop-down list by "Pos cash account 1" string
		And I select from the drop-down list named "Status" by "new" string
		And I input current date in "Opening date" field
		And I select from "Fiscal printer" drop-down list by "fiscal" string
		And I select from the drop-down list named "Branch" by "Shop 02" string
		And I click the button named "FormPost"
		And I click "Open session" button
	* Print X report
		And I click "X report" button
	* Check log
		And Delay 3
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "PrintXReport"	
	* Print X report
		And I click "X report" button
	* Check log
		And Delay 3
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "PrintXReport"	
		And I check "$ParsingResult$" with "1" and method is "PrintXReport"
	* Close session and check print X report
		And I click "Close session" button
		And Delay 2
		And I set checkbox named "CashConfirm"
		And I set checkbox named "TerminalConfirm"
		And I set checkbox named "CashConfirm"
		And I move to the next attribute		
		And I click "Close session" button
		And I click "X report" button
	* Check log
		And Delay 3
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "PrintXReport"	
	And I close all client application windows
	

Scenario: _0260190 check reconnect fiscal printer from payment form
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"	
		And I click "Open session" button
	* Add items and open payment form
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
	* Reconnect fiscal printer
		Then "Payment" window is opened
		And I click "Reconnect fiscal printer" button
		Then there are lines in TestClient message log
			|'Done'|
		Given I open hyperlink "e1cib/list/InformationRegister.HardwareLog"
		And I go to the last line in "List" table
		And the current line of "List" table is equal to
			| 'Method' |
			| 'Open' |
		And I go to the previous line in "List" table
		And the current line of "List" table is equal to
			| 'Method' |
			| 'Open' |
		And I go to the previous line in "List" table
		And the current line of "List" table is equal to
			| 'Method' |
			| 'SetParameter' |
		And I go to the previous line in "List" table
		And the current line of "List" table is equal to
			| 'Method' |
			| 'SetParameter' |
		And I go to the previous line in "List" table
		And the current line of "List" table is equal to
			| 'Method' |
			| 'Close' |
		And I go to the previous line in "List" table
		And the current line of "List" table is equal to
			| 'Method' |
			| 'Close' |
		And I close current window
		And I close "Payment" window
		And I click "Clear current receipt" button

Scenario: _0260193 check timeout
	And I close all client application windows
	* Add timeout
		Given I open hyperlink "e1cib/list/Catalog.Hardware"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Fiscal printer' |
		And I select current line in "List" table
		And I click Open button of the field named "Driver"
		And I input "5" text in "Sleep after (sec)" field
		And I click "Save and close" button
		And I click "Save" button
		And I click the button named "Disconnect"
		And I click the button named "Connect"
		And I click the button named "UpdateStatus"
		And I save the value of the field named "CommandResult" as "CommandResult1"
		And Delay 7
	* Create RSR
		And I close all client application windows
		And In the command interface I select "Retail" "Point of sale"		
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute	
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button	
	* Check info about timeout in the fiscal printer
		Given I open hyperlink "e1cib/list/Catalog.Hardware"		
		And I go to line in "List" table
			| 'Description'    |
			| 'Fiscal printer' |
		And I select current line in "List" table
		And I click the button named "UpdateStatus"
		And I save the value of the field named "CommandResult" as "CommandResult2"
		And 1C:Enterprise language expression "not $CommandResult1$ = $CommandResult2$" is true

Scenario: _0260195 check consignor from SLN
	And I close all client application windows
	* Open POS
		And In the command interface I select "Retail" "Point of sale"	
	* Add items and open payment form
		And I click "Search by barcode (F7)" button
		And I input "0909088998998898789" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "0909088998998898790" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "0909088998998898791" text in the field named "Barcode"
		And I move to the next attribute
		And for each line of "ItemList" table I do
			And I input "100,00" text in "Price" field of "ItemList" table
	* Payment
		And I click "Payment (+)" button
		And I click "Cash (/)" button
		And I click "OK" button
	* Check 
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML21"
			
Scenario: _0260200 click reconect hardware without fiscal printer
	And I close all client application windows
	* Select Workstation 02
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 02'    |	
		And I click "Set current workstation" button
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
		And I click "Open session" button
		And I expand a line in "ItemsPickup" table
			| 'Item'          |
			| '(10004) Boots' |
		And I go to line in "ItemsPickup" table
			| 'Item'                   |
			| '(10004) Boots, 37/18SD' |
		And I select current line in "ItemsPickup" table
		And I click "Payment (+)" button
		Then "Payment" window is opened
	* Check button reconnect fiscal printer
		And I click "Reconnect fiscal printer" button
		Then there are lines in TestClient message log
			|'Hardware not found'|
		And I close "Payment" window
		And I click "Clear current receipt" button		
	And I close all client application windows

Scenario: _0260210 on double click in CRS
	And I close all client application windows
	* Preparation
		* Create CR (without fiscalization)
			Given I open hyperlink "e1cib/list/Document.CashReceipt"
			And I go to line in "List" table
				| 'Amount'   |
				| '1 000,00' |	
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click Select button of "Consolidated retail sales" field
			And I go to line in "List" table
				| 'Number'          |
				| '$$NumberCRS11$$' |
			And I select current line in "List" table
			And I click "Post" button
			And I delete "$$CR11$$" variable
			And I save the window as "$$CR11$$" 
			And I click "Post and close" button
		* Create BR (without fiscalization)
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			And I go to line in "List" table
				| 'Amount' |
				| '10,00'  |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click Select button of "Consolidated retail sales" field
			And I go to line in "List" table
				| 'Number'          |
				| '$$NumberCRS11$$' |
			And I select current line in "List" table
			And I click "Post" button
			And I delete "$$BR11$$" variable
			And I save the window as "$$BR11$$" 
			And I click "Post and close" button	
		* Create CP (without fiscalization)
			Given I open hyperlink "e1cib/list/Document.CashPayment"
			And I go to line in "List" table
				| 'Amount' |
				| '200,00' |	
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click Select button of "Consolidated retail sales" field
			And I go to line in "List" table
				| 'Number'          |
				| '$$NumberCRS11$$' |
			And I select current line in "List" table
			And I click "Post" button
			And I delete "$$CP11$$" variable
			And I save the window as "$$CP11$$" 
			And I click "Post and close" button
		* Create BP (without fiscalization)
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I go to line in "List" table
				| 'Amount' |
				| '200,00' |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click Select button of "Consolidated retail sales" field
			And I go to line in "List" table
				| 'Number'          |
				| '$$NumberCRS11$$' |
			And I select current line in "List" table
			And I click "Post" button
			And I delete "$$BP11$$" variable
			And I save the window as "$$BP11$$" 
			And I click "Post and close" button
		* Create MT (without fiscalization)
			Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
			And I go to line in "List" table
				| 'Send amount' |
				| '11,00'       |
			And in the table "List" I click the button named "ListContextMenuCopy"
			And I click Select button of "Consolidated retail sales" field
			And I go to line in "List" table
				| 'Number'          |
				| '$$NumberCRS11$$' |
			And I select current line in "List" table
			And I click "Post" button
			And I delete "$$MT11$$" variable
			And I save the window as "$$MT11$$" 
			And I click "Post and close" button
	* Select CRS
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		And I go to line in "List" table
			| 'Number'          |
			| '$$NumberCRS11$$' |
		And I select current line in "List" table
	* Check filling documents with fiscalization
		And "Documents" table contains lines
			| 'Document'                 | 'Company'      | 'Amount' | 'Branch'  | 'Currency' | 'Author' | 'Receipt' | 'Send' |
			| 'Cash receipt*'            | 'Main Company' | '1 000'  | 'Shop 02' | 'TRY'      | 'CI'     | '1 000'   | ''     |
			| 'Retail sales receipt*'    | 'Main Company' | '300'    | 'Shop 02' | 'TRY'      | 'CI'     | '300'     | ''     |
			| 'Bank receipt*'            | 'Main Company' | '10'     | 'Shop 02' | 'TRY'      | 'CI'     | '10'      | ''     |
			| 'Retail return receipt 1*' | 'Main Company' | '-100'   | 'Shop 02' | 'TRY'      | 'CI'     | ''        | '100'  |
			| 'Bank payment 1*'          | 'Main Company' | '-200'   | 'Shop 02' | 'TRY'      | 'CI'     | ''        | '200'  |
			| 'Cash payment 1*'          | 'Main Company' | '-200'   | 'Shop 02' | 'TRY'      | 'CI'     | ''        | '200'  |
			| 'Retail return receipt 4*' | 'Main Company' | '-210'   | 'Shop 02' | 'TRY'      | 'CI'     | ''        | '210'  |
			| 'Retail return receipt 5*' | 'Main Company' | '-118'   | 'Shop 02' | 'TRY'      | 'CI'     | ''        | '118'  |
			| 'Retail return receipt 6*' | 'Main Company' | '-520'   | 'Shop 02' | 'TRY'      | 'CI'     | ''        | '520'  |
			| 'Money transfer 13*'       | 'Main Company' | '1 000'  | ''        | 'TRY'      | 'CI'     | '1 000'   | ''     |
		And "Documents" table contains lines
			| 'Document'                                          |
			| '$$MT11$$'                                          |
			| '$$CR11$$'                                          |
			| '$$CP11$$'                                          |
			| '$$BP11$$'                                          |
			| '$$BR11$$'                                          |
	* Double click RSR
		And I go to line in "Documents" table
			| 'Amount' | 'Author' | 'Branch'  | 'Company'      | 'Currency' | 'Receipt' |
			| '720'    | 'CI'     | 'Shop 02' | 'Main Company' | 'TRY'      | '720'     |
		And I select current line in "Documents" table
		Then system warning window does not appear
		And I close all client application windows	

Scenario: _0260212 manual payment by card (block Pay button)
	And I close all client application windows
	And In the command interface I select "Retail" "Point of sale"
	* Select items
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
	* Payment
		And I click "Payment (+)" button
		And I click "Card (*)" button
		And I go to line in "BankPaymentTypeList" table
			| 'Reference' |
			| 'Card 03'   |
		And I select current line in "BankPaymentTypeList" table
		And I activate "Payment type" field in "Payments" table
		And in the table "Payments" I click "Set payment check" button
		And "Payments" table became equal
			| 'Payment done' | 'Payment type' | 'Amount' |
			| '✔'            | 'Card 03'      | '520,00' |		
		When I Check the steps for Exception
			| 'And I click "Pay" button'    |
		And I select current line in "Payments" table
		And in the table "Payments" I click "Set payment uncheck" button	
		And "Payments" table became equal
			| 'Payment done' | 'Payment type' | 'Amount' |
			| '⚪'            | 'Card 03'      | '520,00' |		
		And I click "Pay" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I move to the next attribute
		And I click "OK" button	
	And I close all client application windows			
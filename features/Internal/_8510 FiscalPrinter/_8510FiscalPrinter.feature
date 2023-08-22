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
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2" VendorName="Consignor 2" VendorPhone=""/>
		</FiscalString>
		<FiscalString AmountWithDiscount="200" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 3 with SLN UNIQ" Quantity="1" PaymentMethod="4" PriceWithDiscount="200" VATRate="18" VATAmount="30.51"/>
	</Positions>
	<Payments Cash="300" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML2 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN ODS" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="720" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML3 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="120" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 4 with SLN UNIQ" Quantity="1" PaymentMethod="4" PriceWithDiscount="120" VATRate="18" VATAmount="18.31"/>
	</Positions>
	<Payments Cash="440" ElectronicPayment="400" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML4 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="118" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="118" VATRate="18" VATAmount="18"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="0" PrePayment="0" PostPayment="118" Barter="0"/>
</CheckPackage>
"""
SalesReceiptXML5 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="118" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="118" VATRate="18" VATAmount="18"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="0" PrePayment="0" PostPayment="118" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML6 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="210" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="210" VATRate="18" VATAmount="32.03"/>
	</Positions>
	<Payments Cash="10" ElectronicPayment="0" PrePayment="200" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML7 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="118" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 6 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="118" VATRate="18" VATAmount="18"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="0" PrePayment="0" PostPayment="118" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML8 =
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0"/>
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
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 7 with SLN (new row) ODS" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25" CalculationAgent="5">
			<VendorData VendorINN="1" VendorName="Consignor 1" VendorPhone=""/>
		</FiscalString>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 7 with SLN (new row) ODS" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2" VendorName="Consignor 2" VendorPhone=""/>
		</FiscalString>
		<FiscalString AmountWithDiscount="200" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 8 with SLN (new row) UNIQ" Quantity="1" PaymentMethod="4" PriceWithDiscount="200" VATRate="0" VATAmount="0" CalculationAgent="5">
			<VendorData VendorINN="2" VendorName="Consignor 2" VendorPhone=""/>
		</FiscalString>
		<FiscalString AmountWithDiscount="120" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 4 with SLN ODS" Quantity="1" PaymentMethod="4" PriceWithDiscount="120" VATRate="18" VATAmount="18.31"/>
	</Positions>
	<Payments Cash="520" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML10 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
		<FiscalString AmountWithDiscount="520" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Dress XS/Blue" Quantity="1" PaymentMethod="4" PriceWithDiscount="520" VATRate="18" VATAmount="79.32"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="620" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML11 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="200" DiscountAmount="0" MarkingCode="11111111111111111111" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="200" VATRate="18" VATAmount="30.51"/>
	</Positions>
	<Payments Cash="0" ElectronicPayment="200" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML12 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="100" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 9 with SLN (control code string, without check) ODS" Quantity="1" PaymentMethod="4" PriceWithDiscount="100" VATRate="18" VATAmount="15.25"/>
	</Positions>
	<Payments Cash="100" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML13 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="112" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="112" VATRate="18" VATAmount="17.08"/>
	</Positions>
	<Payments Cash="120" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML14 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="112" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="112" VATRate="18" VATAmount="17.08"/>
	</Positions>
	<Payments Cash="112" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""
SalesReceiptXML15 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="1" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="113" DiscountAmount="0" MarkingCode="Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="113" VATRate="18" VATAmount="17.24"/>
	</Positions>
	<Payments Cash="113" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

SalesReceiptXML16 = 
"""xml
<?xml version="1.0" encoding="UTF-8"?>
<CheckPackage>
	<Parameters CashierName="Арина Браун" CashierINN="1111111111" SaleAddress="Sale address" SaleLocation="Sale location" OperationType="2" TaxationSystem="0"/>
	<Positions>
		<FiscalString AmountWithDiscount="113" DiscountAmount="0" MeasureOfQuantity="255" CalculationSubject="1" Name="Product 1 with SLN PZU" Quantity="1" PaymentMethod="4" PriceWithDiscount="113" VATRate="18" VATAmount="17.24"/>
	</Positions>
	<Payments Cash="113" ElectronicPayment="0" PrePayment="0" PostPayment="0" Barter="0"/>
</CheckPackage>
"""

Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _0850000 preparation (fiscal printer)
	When set True value to the constant
	When set True value to the constant Use consolidated retail sales
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When update ItemKeys
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create POS cash account objects
		When Create catalog Countries objects
		When Data preparation (comission stock)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create information register UserSettings records (Retail)
		When Create catalog ExpenseAndRevenueTypes objects
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
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
		When Data preparation (consignment from serial lot number)
		When Create information register Barcodes records (marking code)
	* Post document
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(2200).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);"    |
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
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(598).GetObject().Write(DocumentWriteMode.Posting);"    |
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
	* Add test extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description"                 |
				| "AdditionalFunctionality"     |
			When add Additional Functionality extension
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
		And I click "Save and close" button
		And I wait "Product * with SLN (Item) *" window closing in 5 seconds
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f"
		And I expand "Accounting settings" group
		And I move to "Accounting settings" tab
		And I set checkbox "Control code string"
		And I set checkbox "Check code string"
		And I click "Save and close" button
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=b7a0d8de1a1c04c611ee174b1c02bb67"
		And I expand "Accounting settings" group
		And I move to "Accounting settings" tab
		And I set checkbox "Control code string"
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
		And I input "57897909799" text in the field named "Barcode"
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
		And I input "09987897977893" text in the field named "Barcode"
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
	* Change quantity and check marking data clean
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
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Current row will decode to base64" text in the field named "Barcode"
		And I move to the next attribute
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
		And I click "Payment (+)" button
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "Current row will decode to base64" text in the field named "Barcode"
		And I move to the next attribute											
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
			| 'Σ'         |
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
		And I expand "ControlCodeStrings [1]" group
		And I move to "ControlCodeStrings [1]" tab
		And I activate "Code string" field in "ControlCodeStrings" table
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
	* Code scan
		And I click "Payment Return" button
		Then the form attribute named "isReturn" became equal to "Yes"	
		And I click "Search by barcode" button
		Then "Barcode" window is opened
		And I input "11111111111111111111" text in the field named "Barcode"
		And I move to the next attribute
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
			| 'And I click "Return" button'    |
		And I click "Cancel" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click the button named "Enter"
		Then there are lines in TestClient message log
			|'Not all payment done.'|
		And I go to line in "Payments" table
			| 'Amount' | 'Payment done' | 'Payment type' |
			| '40,00'  | '⚪'            | 'Card 03'      |
		And I activate "Payment type" field in "Payments" table
		And I click "Cancel" button
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
			| 'And I click "Cancel" button'    |
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
			| '1'   | '200,00'   | ''             | 'Card 03'        | ''                   | 'No'                  | 'Bank term 03'   | 'POS Terminal'   | '1,00'      | ''            |
		And I click "Show hidden tables" button
		Then "Edit hidden tables" window is opened
		And I expand "ControlCodeStrings [1]" group
		And I move to "ControlCodeStrings [1]" tab
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
			| '1'   | '111,00'   | ''             | 'Card 03'        | ''                   | 'No'                  | 'Bank term 03'   | 'POS Terminal'   | '1,00'      | '23457'       |
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
		And I click "Post" button
		And I click "Pay by card" button
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

Scenario: _0850025 sales return (cash)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
	* Select Retail sales receipt
		And I go to line in "List" table
			| 'Σ'         |
			| '210,00'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenarate"
		And I expand current line in "BasisesTree" table
		And I click "Ok" button
		And I click "Post" button
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
			| 'Σ'         |
			| '118,00'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenarate"
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
			| 'Σ'         |
			| '620,00'    |
		And I click the button named "FormDocumentRetailReturnReceiptGenarate"
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
		And I click "Post" button
	* Check Print cash in
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
		And I click "Post" button
	* Check Print cash out
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


Scenario: _050055 check filling consignor from serial lot number in the RetailSalesReceipt from POS (scan barcode)
		And I close all client application windows
	* Preparation
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(200).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Open POS and create RSR
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
	* Add items
		And I click "Search by barcode (F7)" button
		And I input "09999900989900" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "09999900989901" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "090998897898979998" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode (F7)" button
		And I input "89900779008908" text in the field named "Barcode"
		And I move to the next attribute
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click "Cash (/)" button		
		And I click the button named "Enter"
	* Check filling consignor
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
		And I go to line in "List" table
			| 'Σ'         |
			| '520,00'    |
		And I select current line in "List" table	
		And I click "Show row key" button
		And in the table "ItemList" I click "Edit quantity in base unit" button	
		And "ItemList" table became equal
			| 'Store'      | 'Stock quantity'   | 'Use serial lot number'   | '#'   | 'Inventory origin'   | 'Price type'          | 'Item'                           | 'Consignor'     | 'Dont calculate row'   | 'Tax amount'   | 'Serial lot numbers'   | 'Unit'   | 'Profit loss center'   | 'Item key'   | 'Is service'   | 'Quantity'   | 'Price'    | 'VAT'           | 'Net amount'   | 'Total amount'    |
			| 'Store 01'   | '1,000'            | 'Yes'                     | '1'   | 'Consignor stocks'   | 'Basic Price Types'   | 'Product 7 with SLN (new row)'   | 'Consignor 1'   | 'No'                   | '15,25'        | '09999900989900'       | 'pcs'    | 'Shop 02'              | 'ODS'        | 'No'           | '1,000'      | '100,00'   | '18%'           | '84,75'        | '100,00'          |
			| 'Store 01'   | '1,000'            | 'Yes'                     | '2'   | 'Consignor stocks'   | 'Basic Price Types'   | 'Product 7 with SLN (new row)'   | 'Consignor 2'   | 'No'                   | ''             | '09999900989901'       | 'pcs'    | 'Shop 02'              | 'ODS'        | 'No'           | '1,000'      | '100,00'   | 'Without VAT'   | '100,00'       | '100,00'          |
			| 'Store 01'   | '1,000'            | 'Yes'                     | '3'   | 'Consignor stocks'   | 'Basic Price Types'   | 'Product 8 with SLN (new row)'   | 'Consignor 2'   | 'No'                   | ''             | '090998897898979998'   | 'pcs'    | 'Shop 02'              | 'UNIQ'       | 'No'           | '1,000'      | '200,00'   | 'Without VAT'   | '200,00'       | '200,00'          |
			| 'Store 01'   | '1,000'            | 'Yes'                     | '4'   | 'Own stocks'         | 'Basic Price Types'   | 'Product 4 with SLN'             | ''              | 'No'                   | '18,31'        | '899007790088'         | 'pcs'    | 'Shop 02'              | 'ODS'        | 'No'           | '1,000'      | '120,00'   | '18%'           | '101,69'       | '120,00'          |
		And I close all client application windows
	* Check logs
		And Delay 2
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" the same as "SalesReceiptXML9"



Scenario: return from previous Consolidated retail sales
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
		And I expand "ControlCodeStrings [1]" group
		And I move to "ControlCodeStrings [1]" tab		
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
		And I expand "ControlCodeStrings [1]" group
		And I move to "ControlCodeStrings [1]" tab		
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
		And I expand "ControlCodeStrings [2]" group
		And I move to "ControlCodeStrings [2]" tab		
		And "ControlCodeStrings" table became equal
			| 'Key'   | 'Code string'                                    | 'Code is approved'    |
			| '*'     | 'Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0'   | 'No'                  |
			| '*'     | '11111111111111111111113'                        | 'Yes'                 |
		And I close all client application windows
		

Scenario: _0260157 check marking code clean when change item key in the RSR
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
		And I expand "ControlCodeStrings [1]" group
		And I move to "ControlCodeStrings [1]" tab		
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
		And I expand "ControlCodeStrings [0]" group
		And I move to "ControlCodeStrings [0]" tab		
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
		And I expand "ControlCodeStrings [0]" group
		And I move to "ControlCodeStrings [0]" tab		
		Then the number of "ControlCodeStrings" table lines is "равно" 0
		And I close current window
				


Scenario: _0260158 check marking code clean when change item key in the RRR
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
		And I expand "ControlCodeStrings [1]" group
		And I move to "ControlCodeStrings [1]" tab		
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
		And I expand "ControlCodeStrings [0]" group
		And I move to "ControlCodeStrings [0]" tab		
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
		And I expand "ControlCodeStrings [0]" group
		And I move to "ControlCodeStrings [0]" tab		
		Then the number of "ControlCodeStrings" table lines is "равно" 0
		And I close current window	
		And I close all client application windows	

Scenario: _0260159 check marking code without check code string
		And I close all client application windows
	* Create 
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "999999999" text in the field named "Barcode"
		And I move to the next attribute
		And I click "Search by barcode" button
		And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"
		And I move to the next attribute
	* Check 
		And I click "Show hidden tables" button
		And I expand "ControlCodeStrings [1]" group
		And I move to "ControlCodeStrings [1]" tab	
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
		And I click "Post" button
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

Scenario: _0260163 payment by Certificate
	And I close all client application windows
	* Create RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click the button named "SearchByBarcode"	
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
	* Payment
		And I move to "Payments" tab
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I activate "Payment type" field in "Payments" table
		And I select current line in "Payments" table
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Certificate' |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "500,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I activate "Payment type" field in "Payments" table
		And I select "cash" from "Payment type" drop-down list by string in "Payments" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "50,00" text in the field named "PaymentsAmount" of "Payments" table
		And I finish line editing in "Payments" table
		And I click "Post" button
		And I click "Print receipt" button
		Then there are lines in TestClient message log
			|'Done'|
	* Check fiscal log
		And Delay 5
		And I parsed the log of the fiscal emulator by the path '$$LogPath$$' into the variable "ParsingResult"
		And I check "$ParsingResult$" with "0" and method is "ProcessCheck"
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'PrePayment="500"'
		And I check "$ParsingResult$" with "0" and data in "In.Parameter3" contains 'Cash="50"'
				


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
	Then the number of "List" table lines is "равно" "620"	
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


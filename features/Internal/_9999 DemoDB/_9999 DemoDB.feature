#language: en
@tree
@Positive
@DemoDataBase

Functionality: filling in demo data base


Variables:
import "Variables.feature"

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _999901 filling in demo data base
	When set True value to the constant(DemoDB)
	When Create catalog ExternalDataProc objects(DemoDB)
	* Add ExternalDataProc
		* Discount
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I go to line in "List" table
					| 'Description'            |
					| 'DocumentDiscount'       |
			And I select current line in "List" table
			And I select external file "$Path$/DataProcessor/DocumentDiscount.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I click "Save and close" button
			And I wait "Plugins (create)" window closing in 5 seconds
	When Create catalog AddAttributeAndPropertySets objects (DemoDB)
	When Create catalog AddAttributeAndPropertyValues objects (DemoDB)
	// When Create catalog RowIDs objects(DemoDB)
	When Create catalog CancelReturnReasons objects(DemoDB)
	When Create catalog BusinessUnits objects(DemoDB)
	When Create catalog CashAccounts objects(DemoDB)
	When Create document CashStatement objects(DemoDB)
	When Create catalog Companies objects(DemoDB)
	When Create catalog ConfigurationMetadata objects(DemoDB)
	When Create catalog Countries objects(DemoDB)
	When Create catalog SalaryCalculationType objects(DemoDB)
	When Create catalog Currencies objects(DemoDB)
	When Create catalog PaymentTerminals objects(DemoDB)
	When Create catalog BankTerms objects(DemoDB)
	When Create catalog Workstations objects(DemoDB)
	When Create information register BranchBankTerms records(DemoDB)
	When Create catalog ExpenseAndRevenueTypes objects(DemoDB)
	When Create catalog IntegrationSettings objects(DemoDB)
	When Create catalog ItemKeys objects(DemoDB)
	When Create catalog ItemTypes objects(DemoDB)
	When Create catalog Units objects(DemoDB)
	When Create catalog Items objects(DemoDB)
	When Create catalog ObjectStatuses objects (DemoDB)
	When Create catalog CurrencyMovementSets objects(DemoDB)
	When Create catalog Agreements objects(DemoDB)
	When Create catalog Partners objects(DemoDB)
	When Create catalog PaymentTypes objects(DemoDB)
	When Create catalog PriceTypes objects(DemoDB)
	When Create catalog RetailCustomers objects(DemoDB)	
	When Create catalog SpecialOfferTypes objects(DemoDB)
	When Create catalog SpecialOffers objects(DemoDB)
	When Create catalog Specifications objects(DemoDB)
	When Create catalog Stores objects(DemoDB)
	When Create catalog TaxRates objects(DemoDB)
	When Create catalog Taxes objects(DemoDB)
	When Create catalog SerialLotNumbers objects(DemoDB)
	When Create information register Taxes records(DemoDB)
	When Create catalog AccrualAndDeductionTypes objects(DemoDB)
	When Create catalog EmployeePositions objects(DemoDB)
	When Create catalog EmployeeSchedule objects(DemoDB)
	* Tax settings
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
			| 'Description'           |
			| 'My German Company LLC' |
		And I select current line in "List" table
		And I move to "Tax types" tab
		And I go to line in "CompanyTaxes" table
			| 'Tax'       |
			| 'VAT'       |
		And I select current line in "CompanyTaxes" table
		And I click Open button of "Tax" field
		And I select "VAT" exact value from the drop-down list named "Kind"
		And I click "Save and close" button
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
			| 'Description'            |
			| 'My Turkish Company LLC' |
		And I select current line in "List" table
		And I move to "Tax types" tab
		And I go to line in "CompanyTaxes" table
			| 'Tax'       |
			| 'VAT'       |
		And I select current line in "CompanyTaxes" table
		And I click Open button of "Tax" field
		And I select "VAT" exact value from the drop-down list named "Kind"
		And I click "Save and close" button
		And I close all client application windows
	When Create catalog AccessGroups objects(DemoDB)
	When Create catalog AccessProfiles objects(DemoDB)
	When Create catalog UserGroups objects(DemoDB)
	When Create catalog Users objects(DemoDB)
	When Create catalog CashStatementStatuses objects(DemoDB)
	When Create document BankPayment objects(DemoDB)
	When Create document BankReceipt objects(DemoDB)
	When Create document CashPayment objects(DemoDB)
	When Create document CashReceipt objects(DemoDB)
	When Create document CreditNote objects(DemoDB)
	When Create document DebitNote objects(DemoDB)
	When Create document EmployeeCashAdvance objects(DemoDB)
	When Create document InventoryTransfer objects(DemoDB)
	When Create document CalculationMovementCosts objects(DemoDB)
	When Create document PhysicalInventory objects(DemoDB)
	When Create document PriceList objects(DemoDB)
	When Create document RetailSalesReceipt objects(DemoDB)
	When Create document SalesOrder objects(DemoDB)
	When Create document PurchaseOrder objects(DemoDB)
	When Create document PurchaseInvoice objects(DemoDB)
	When Create document GoodsReceipt objects(DemoDB)
	When Create document SalesInvoice objects(DemoDB)
	When Create document ShipmentConfirmation objects(DemoDB)
	When Create document StockAdjustmentAsSurplus objects(DemoDB)
	When Create document StockAdjustmentAsWriteOff objects(DemoDB)
	When Create document CashStatement objects(DemoDB)
	When Create document SalesReturn objects(DemoDB)
	When Create document PurchaseReturn objects(DemoDB)
	When Create chart of characteristic types AddAttributeAndProperty objects(DemoDB)
	When Create chart of characteristic types CurrencyMovementType objects(DemoDB)
	When Create information register CurrencyRates records(DemoDB)
	When Create information register Barcodes records(DemoDB)
	When Create information register TaxSettings records(DemoDB)
	When Create document ForeignCurrencyRevaluation objects(DemoDB)
	When Create document MoneyTransfer objects(DemoDB)
	* Additional table control
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"	
		And I go to line in "FunctionalOptions" table
			| "Option"                                |
			| "Use additional table control document" |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
	* Posting documents
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseReturn.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |	
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(9).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |

		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(9).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(9).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
	
		

		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(9).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(6).GetObject().Write(DocumentWriteMode.Posting);"    |

		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(7).GetObject().Write(DocumentWriteMode.Posting);"    |

	* Posting Purchase order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting Purchase invoice
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "5"
	* Posting Sales order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting Shipment confirmation
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting BankReceipt
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting BankPayment
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "10"
	* Posting Sales invoice
			And I execute 1C:Enterprise script at server
				| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting Inventory transfer
			Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting Goods receipt
			Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting PhysicalInventory
			Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting Stock adjustment as surplus
			Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting Stock adjustment as write off
			Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting CashReceipt
			Given I open hyperlink "e1cib/list/Document.CashReceipt"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting CashPayment
			Given I open hyperlink "e1cib/list/Document.CashPayment"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting CreditNote
			Given I open hyperlink "e1cib/list/Document.CreditNote"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting DebitNote
			Given I open hyperlink "e1cib/list/Document.DebitNote"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting RetailSalesReceipt
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting SalesReturn
			Given I open hyperlink "e1cib/list/Document.SalesReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting PurchaseReturn
			Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting PriceList
			Given I open hyperlink "e1cib/list/Document.PriceList"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting MoneyTransfer
			Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting CalculationMovementCosts
			Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting ForeignCurrencyRevaluation
			Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	* Posting CashStatement
			Given I open hyperlink "e1cib/list/Document.CashStatement"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	* Posting EmployeeCashAdvance
			Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
	 		And Delay "3"
	When set False value to the constant DisableLinkedRowsIntegrity
	* Change password for CI
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Description' |
			| 'CI'          |
		And I select current line in "List" table
		And I click "Set password" button
		And I input "#KeyPDemo#" text in "Password" field
		And I input "#KeyPDemo#" text in "Confirm password" field
		And I click "Ok" button
		And I click "Save and close" button	
	* Change data base status
		Given I open hyperlink "e1cib/list/Catalog.DataBaseStatus"
		And I go to line in "List" table
			| 'is Product server'  |
			| 'Yes'                |	
		And I select current line in "List" table
		And I activate "Connection string" field in "ConnectionSettings" table
		And I select current line in "ConnectionSettings" table
		And I input "File_\"D__IRPDB\"_" text in "Connection string" field of "ConnectionSettings" table
		And I finish line editing in "ConnectionSettings" table
		And I click "Save and close" button
	And I close all client application windows



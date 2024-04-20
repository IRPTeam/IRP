#language: en
@tree
@Positive
@TestDataBase

Functionality: filling in test data base


Variables:
import "Variables.feature"

Background:
		Given I open new TestClient session or connect the existing one


Scenario: _970001 filling in test data base
When set True value to the constant
When set True value to the constant Use consolidated retail sales
When set True value to the constant Use commission trading
When set True value to the constant Use accounting
When set True value to the constant Use salary
When set True value to the constant Use retail orders
When set True value to the constant Use fixed assets
When Create catalog ExternalDataProc objects (test data base)
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
		* Contact info
				Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
				And I go to line in "List" table
						| 'Description'       |
						| 'Address'           |
				And I select current line in "List" table
				And I select external file "$Path$/DataProcessor/InputAddress.epf"
				And I click the button named "FormAddExtDataProc"
				And I input "" text in "Path to plugin for test" field
				And I click "Save and close" button
				And I wait "Plugins (create)" window closing in 5 seconds
When Create catalog AddAttributeAndPropertySets objects (test data base)
When Create catalog AddAttributeAndPropertyValues objects (test data base)
When Create catalog IDInfoAddresses objects (test data base)
When Create catalog RowIDs objects (test data base)
When Create catalog BankTerms objects (test data base)
When Create catalog BusinessUnits objects (test data base)
When Create catalog CancelReturnReasons objects (test data base)
When Create catalog CashStatementStatuses objects (test data base)
When Create catalog CashAccounts objects (test data base)
When Create catalog BillOfMaterials objects (test data base)
When Create catalog Companies objects (test data base)
When Create catalog ConfigurationMetadata objects (test data base)
When Create catalog IDInfoSets objects (test data base)
When Create catalog Countries objects (test data base)
When Create catalog Currencies objects (test data base)
When Create catalog DataBaseStatus objects (test data base)
When Create catalog ExpenseAndRevenueTypes objects (test data base)
When Create catalog IntegrationSettings objects (test data base)
When Create catalog ItemKeys objects (test data base)
When Create catalog ItemTypes objects (test data base)
When Create catalog Units objects (test data base)
When Create catalog Items objects (test data base)
When Create catalog CurrencyMovementSets objects (test data base)
When Create catalog ObjectStatuses objects (test data base)
When Create catalog PartnerSegments objects (test data base)
When Create catalog Agreements objects (test data base)
When Create catalog Partners objects (test data base)
When Create catalog PartnersBankAccounts objects (test data base)
When Create catalog PaymentTerminals objects (test data base)
When Create catalog PaymentSchedules objects (test data base)
When Create catalog PaymentTypes objects (test data base)
When Create catalog PriceTypes objects (test data base)
When Create catalog RetailCustomers objects (test data base)	
When Create catalog SpecialOfferTypes objects (test data base)
When Create catalog SpecialOffers objects (test data base)
When Create catalog Specifications objects (test data base)
When Create catalog Stores objects (test data base)
When Create catalog TaxRates objects (test data base)
When Create catalog Taxes objects (test data base)
When Create catalog SerialLotNumbers objects (test data base)
When Create information register Taxes records (test data base)
When Create catalog AccrualAndDeductionTypes objects (test data base)
When Create catalog EmployeePositions objects (test data base)
When Create catalog FixedAssetsLedgerTypes objects (test data base)
When Create catalog DepreciationSchedules objects (test data base)
When Create catalog FixedAssets objects (test data base)
When Create catalog ItemSegments objects (test data base)
When Create catalog EmployeeSchedule objects (test data base)
When Create catalog LegalNameContracts objects (test data base)
When Create catalog Projects objects (test data base)
When Create catalog UnitsOfMeasurement objects (test data base)
When Create catalog Vehicles objects (test data base)
* Tax settings
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
						| 'Description'         |
						| 'Own company 2'       |
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
When Create catalog InterfaceGroups objects (test data base)
When Create catalog AccessGroups objects (test data base)
When Create catalog AccessProfiles objects (test data base)
When Create catalog UserGroups objects (test data base)
When Create catalog Users objects (test data base)
When Create catalog Workstations objects (test data base)
When Create catalog PlanningPeriods objects (test data base)
When Create document BankPayment objects (test data base)
When Create document CashTransferOrder objects (test data base)
When Create document BankReceipt objects (test data base)
When Create document Bundling objects (test data base)
When Create document CashExpense objects (test data base)
When Create document CashPayment objects (test data base)
When Create document CashReceipt objects (test data base)
When Create document CashRevenue objects (test data base)
When Create document CreditNote objects (test data base)
When Create document DebitNote objects (test data base)
When Create document GoodsReceipt objects (test data base)
When Create document IncomingPaymentOrder objects (test data base)
When Create document InternalSupplyRequest objects (test data base)
When Create document InventoryTransfer objects (test data base)
When Create document InventoryTransferOrder objects (test data base)
When Create document OpeningEntry objects (test data base)
When Create document OutgoingPaymentOrder objects (test data base)
When Create document PhysicalCountByLocation objects (test data base)
When Create document CommissioningOfFixedAsset objects (test data base)
When Create document DepreciationCalculation objects (test data base)
When Create document CalculationMovementCosts objects (test data base)
When Create document PhysicalInventory objects (test data base)
When Create document PlannedReceiptReservation objects (test data base)
When Create document PriceList objects (test data base)
When Create document PurchaseInvoice objects (test data base)
When Create document PurchaseOrder objects (test data base)
When Create document PurchaseOrderClosing objects (test data base)
When Create document PurchaseReturn objects (test data base)
When Create document ReconciliationStatement objects (test data base)
When Create document RetailReturnReceipt objects (test data base)
When Create document RetailSalesReceipt objects (test data base)
When Create document SalesInvoice objects (test data base)
When Create document SalesOrder objects (test data base)
When Create document WorkOrder objects (test data base)
When Create document WorkSheet objects (test data base)
When Create document SalesReturn objects (test data base)
When Create document SalesReturnOrder objects (test data base)
When Create document ShipmentConfirmation objects (test data base)
When Create document StockAdjustmentAsSurplus objects (test data base)
When Create document StockAdjustmentAsWriteOff objects (test data base)
When Create document Unbundling objects (test data base)
When Create document ItemStockAdjustment objects  (test data base)
When Create document PurchaseReturnOrder objects (test data base)
When Create chart of characteristic types AddAttributeAndProperty objects (test data base)
When Create chart of characteristic types IDInfoTypes objects (test data base)
When Create chart of characteristic types CustomUserSettings objects (test data base)
When Create chart of characteristic types CurrencyMovementType objects (test data base)
When Create information register BundleContents records (test data base)
When Create information register BranchBankTerms records (test data base)
When Create information register CurrencyRates records (test data base)
When Create information register Barcodes records (test data base)
When Create information register PartnerSegments records (test data base)
When Create information register TaxSettings records (test data base)
When Create information register UserSettings records (test data base)
When Create document CashStatement objects  (test data base)
When Create document ForeignCurrencyRevaluation objects (test data base)
When Create document MoneyTransfer objects (test data base)
When Create catalog PartnerItems objects (test data base)
When Create document CustomersAdvancesClosing objects (test data base)
When Create document VendorsAdvancesClosing objects (test data base)
When Create document EmployeeCashAdvance objects (test data base)
When Create document SalesReportFromTradeAgent objects (test data base)
When Create document SalesReportToConsignor objects (test data base)
When Create document ConsolidatedRetailSales objects (test data base)
* Load data for Salary system
	When Create document EmployeeHiring objects (test data base)
	When Create document EmployeeVacation objects (test data base)
	When Create document EmployeeSickLeave objects (test data base)
	When Create document EmployeeTransfer objects (test data base)
	When Create information register T9530S_WorkDays records (test data base)
	When Create document TimeSheet objects (test data base)
	When Create document AdditionalDeduction objects (test data base)
	When Create document AdditionalAccrual objects (test data base)
	When Create document Payroll objects (test data base)
* Load data for Accounting system
	When Create chart of characteristic types AccountingExtraDimensionTypes objects (test data base)
	When Create chart of accounts Basic objects with LedgerTypeVariants (Basic LTV) (test data base)
	When Create information register T9011S_AccountsCashAccount records (Basic LTV) (test data base)
	When Create information register T9014S_AccountsExpenseRevenue records (Basic LTV) (test data base)
	When Create information register T9010S_AccountsItemKey records (Basic LTV) (test data base)
	When Create information register T9012S_AccountsPartner records (Basic LTV) (test data base)
	When Create information register T9013S_AccountsTax records (Basic LTV) (test data base)
* Hardware
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
		And I click "Set current" button
		And I click "Save and close" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	
	* Add acquiring printer to the POS account
		Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
		And I go to line in "List" table
			| 'Description'  |
			| 'POS account'  |
		And I select current line in "List" table
		And I click Choice button of the field named "Acquiring"
		And I go to line in "List" table
			| 'Description'           |
			| 'Acquiring terminal'    |
		And I select current line in "List" table
		And I click "Save and close" button
* Open session
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
* Posting first documents
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
* Posting Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		Then "Opening entries" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
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
* Posting WorkOrder
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting WorkSheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CashTransferOrder
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting BankPayment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting BankReceipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Sales invoice
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 And Delay "3"
* Posting Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
		And I close all client application windows
* Posting Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting PurchaseReturnOrder
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
		And I close all client application windows
* Posting Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
		And I close all client application windows
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
* Posting Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting PurchaseOrderClosing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting SalesOrderClosing
		When Create document SalesOrderClosing objects (test data base)
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting PlannedReceiptReservation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CashPayment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CashReceipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting CashExpense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting CashRevenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
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
* Posting ReconciliationStatement
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting IncomingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting OutgoingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
 		And Delay "3"
* Posting ItemStockAdjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting RetailSalesReceipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting RetailReturnReceipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting PriceList
		Given I open hyperlink "e1cib/list/Document.PriceList"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting CashStatement
		Given I open hyperlink "e1cib/list/Document.CashStatement"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting SalesReturn
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting MoneyTransfer
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting CommissioningOfFixedAsset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting DepreciationCalculation
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting CalculationMovementCosts
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting CustomersAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting VendorsAdvancesClosing
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting ConsolidatedRetailSales
		Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting SalesReportFromTradeAgent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting SalesReportToConsignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting EmployeeHiring
		Given I open hyperlink "e1cib/list/Document.EmployeeHiring"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting EmployeeVacation
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting EmployeeSickLeave
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting EmployeeTransfer
		Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting TimeSheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting AdditionalDeduction
		Given I open hyperlink "e1cib/list/Document.AdditionalDeduction"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting AdditionalAccrual
		Given I open hyperlink "e1cib/list/Document.AdditionalAccrual"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
* Posting Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
When set False value to the constant DisableLinkedRowsIntegrity
And I close all client application windows



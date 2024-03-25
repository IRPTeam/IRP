#language: en
@tree
@Positive
@MovementsPartnersBalance

Functionality: check Partner Balance register


Variables:
import "Variables.feature"

Background:
		Given I open new TestClient session or connect the existing one


Scenario: _52001 preparation (Partner Balance register)
	When set True value to the constant
	When set True value to the constant Use consolidated retail sales
	When set True value to the constant Use commission trading
	When set True value to the constant Use accounting
	When set True value to the constant Use salary
	When set True value to the constant Use retail orders
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
	When Create document ConsolidatedRetailSales objects (test data base)
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
	When Create document BankReceipt objects (test data base)
	When Create document Bundling objects (test data base)
	When Create document CashExpense objects (test data base)
	When Create document CashPayment objects (test data base)
	When Create document CashReceipt objects (test data base)
	When Create document CashRevenue objects (test data base)
	When Create document CashTransferOrder objects (test data base)
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
	When Create catalog ReportOptions objects (R5020_PartnersBalance)
	When Create document SalesReportFromTradeAgent objects (test data base)
	When Create document SalesReportToConsignor objects (test data base)
	* Load data for Accounting system
		When Create chart of characteristic types AccountingExtraDimensionTypes objects (test data base)
		When Create chart of accounts Basic objects with LedgerTypeVariants (Basic LTV) (test data base)
		When Create information register T9011S_AccountsCashAccount records (Basic LTV) (test data base)
		When Create information register T9014S_AccountsExpenseRevenue records (Basic LTV) (test data base)
		When Create information register T9010S_AccountsItemKey records (Basic LTV) (test data base)
		When Create information register T9012S_AccountsPartner records (Basic LTV) (test data base)
		When Create information register T9013S_AccountsTax records (Basic LTV) (test data base)
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
	* Posting BankPayment
			Given I open hyperlink "e1cib/list/Document.BankPayment"
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
	* Posting CashTransferOrder
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
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
	And I close all client application windows

Scenario: _52002 check preparation
	When check preparation

Scenario: _52003 SI - CR (AR - by documents, CR - payment from customer, IsAdvance = False)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "24.02.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 1 (3 partner terms)" string		
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                   | ''                                                        | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                   | 'Legal name'                                              | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                  | 'Agreement'                                               | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                             | ''                                                        | ''         | ''                             | '950,00'  | '950,00'  | ''        | ''        | ''        | ''        | '950,00'  | '950,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 1 (3 partner terms)'              | 'Client 1'                                                | ''         | ''                             | '950,00'  | '950,00'  | ''        | ''        | ''        | ''        | '950,00'  | '950,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 2 dated 24.02.2023 10:18:20' | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '950,00'  | ''        | '950,00'  | ''        | ''        | ''        | '950,00'  | ''        | '950,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Cash receipt 1 dated 10.03.2023 00:00:00'  | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | ''        | '950,00'  | ''        | ''        | ''        | ''        | ''        | '950,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                     | ''                                                        | ''         | ''                             | '950,00'  | '950,00'  | ''        | ''        | ''        | ''        | '950,00'  | '950,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		
				
Scenario: _52004 SI - BR (AR - by documents, BR - payment from customer, IsAdvance = True, without customer advance closing)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "30.03.2023" text in the field named "DateBegin"
		And I input "01.04.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 1 (3 partner terms)" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                   | ''                                                        | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                   | 'Legal name'                                              | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                  | 'Agreement'                                               | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                             | ''                                                        | ''         | ''                             | '520,00'  | '350,00'  | '170,00'  | ''        | '350,00'  | '-350,00' | '520,00'  | ''        | '520,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 1 (3 partner terms)'              | 'Client 1'                                                | ''         | ''                             | '520,00'  | '350,00'  | '170,00'  | ''        | '350,00'  | '-350,00' | '520,00'  | ''        | '520,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 3 dated 30.03.2023 12:23:56' | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '480,00'  | ''        | '480,00'  | ''        | ''        | ''        | '480,00'  | ''        | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 3 dated 01.04.2023 13:53:41'  | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | ''        | '350,00'  | '130,00'  | ''        | '350,00'  | '-350,00' | ''        | ''        | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
	And I close all client application windows
	
			
Scenario: _52005 PI-PR-CP-BR (AP - by partner terms, BR - return from vendor, IsAdvance = False)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "24.02.2023" text in the field named "DateBegin"
		And I input "10.08.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Vendor 1 (1 partner term)" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                      | ''                                                                                                              | ''         | ''                             | 'Amount'  | ''          | ''           | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''          | ''           | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                                                                                    | ''         | ''                             | 'Receipt' | 'Expense'   | 'Closing'    | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense'   | 'Closing'    | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                                                                                     | 'Currency' | 'Multi currency movement type' | ''        | ''          | ''           | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''          | ''           | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                                                                              | ''         | ''                             | '500,00'  | '13 490,05' | '-12 990,05' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '500,00'  | '13 490,05' | '-12 990,05' | ''        | ''        | ''        |
			| 'Vendor 1 (1 partner term)'                    | 'Vendor 1'                                                                                                      | ''         | ''                             | '500,00'  | '13 490,05' | '-12 990,05' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '500,00'  | '13 490,05' | '-12 990,05' | ''        | ''        | ''        |
			| 'Purchase invoice 1 dated 24.02.2023 10:04:33' | 'Partner term with vendor 1'                                                                                    | 'TRY'      | 'Legal currency, TRY'          | ''        | '13 720,05' | '-13 720,05' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '13 720,05' | '-13 720,05' | ''        | ''        | ''        |
			| 'Purchase return 2 dated 24.02.2023 10:25:20'  | 'Partner term with vendor 1'                                                                                    | 'TRY'      | 'Legal currency, TRY'          | ''        | '-110,00'   | '-13 610,05' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '-110,00'   | '-13 610,05' | ''        | ''        | ''        |
			| 'Cash payment 1 dated 24.02.2023 10:50:30'     | 'Partner term with vendor 1'                                                                                    | 'TRY'      | 'Legal currency, TRY'          | '500,00'  | ''          | '-13 110,05' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '500,00'  | ''          | '-13 110,05' | ''        | ''        | ''        |
			| 'Purchase return 1 dated 24.02.2023 17:01:27'  | 'Partner term with vendor 1'                                                                                    | 'TRY'      | 'Legal currency, TRY'          | ''        | '-220,00'   | '-12 890,05' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '-220,00'   | '-12 890,05' | ''        | ''        | ''        |
			| 'Bank receipt 8 dated 10.08.2023 12:00:00'     | 'Partner term with vendor 1'                                                                                    | 'TRY'      | 'Legal currency, TRY'          | ''        | '100,00'    | '-12 990,05' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'    | '-12 990,05' | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                                                                              | ''         | ''                             | '500,00'  | '13 490,05' | '-12 990,05' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '500,00'  | '13 490,05' | '-12 990,05' | ''        | ''        | ''        |			
	And I close all client application windows					
			

Scenario: _52006 PI-BP-CP (AP - by documents, BP - payment to vendor, BP-IsAdvance = False, CP,BP-IsAdvance = True, without vendor advance closing )
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.12.2023" text in the field named "DateBegin"
		And I input "02.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer and vendor" string
		And I click "Generate" button
	* Check PI-BP (BP-IsAdvance = False)
		And "Result" spreadsheet document contains lines:
			| 'Company'                                      | ''                                                                                                        | ''         | ''                             | 'Amount'   | ''         | ''          | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'       | ''         | ''          | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                                                                              | ''         | ''                             | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                                                                               | 'Currency' | 'Multi currency movement type' | ''         | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''          | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                                                                        | ''         | ''                             | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |
			| 'Customer and vendor'                          | 'Client and vendor'                                                                                       | ''         | ''                             | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |
			| 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'Partner term with vendor (advance payment by document)'                                                  | 'TRY'      | 'Legal currency, TRY'          | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        |
			| 'Bank payment 8 dated 02.12.2023 16:00:00'     | 'Partner term with vendor (advance payment by document)'                                                  | 'TRY'      | 'Legal currency, TRY'          | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                                                                        | ''         | ''                             | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |	
	* Check PI-BP-CP (BP, CP - IsAdvance = False, without vendor advance closing)
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.12.2023" text in the field named "DateBegin"
		And I input "03.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer and vendor" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:
			| 'Company'                                      | ''                                                                                                        | ''         | ''                             | 'Amount'   | ''         | ''          | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'       | ''        | ''         | 'VT'       | ''         | ''          | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                                                                              | ''         | ''                             | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt'  | 'Expense' | 'Closing'  | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                                                                               | 'Currency' | 'Multi currency movement type' | ''         | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''        | ''         | ''         | ''         | ''          | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                                                                        | ''         | ''                             | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | ''        | '1 200,00' | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |
			| 'Customer and vendor'                          | 'Client and vendor'                                                                                       | ''         | ''                             | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | ''        | '1 200,00' | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |
			| 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'Partner term with vendor (advance payment by document)'                                                  | 'TRY'      | 'Legal currency, TRY'          | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''        | ''         | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        |
			| 'Bank payment 8 dated 02.12.2023 16:00:00'     | 'Partner term with vendor (advance payment by document)'                                                  | 'TRY'      | 'Legal currency, TRY'          | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''        | ''         | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Cash payment 5 dated 03.12.2023 12:00:00'     | 'Partner term with vendor (advance payment by document)'                                                  | 'TRY'      | 'Legal currency, TRY'          | '1 000,00' | ''         | '-4 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 000,00' | ''        | '1 000,00' | ''         | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Bank payment 9 dated 03.12.2023 12:30:00'     | 'Partner term with vendor (advance payment by document)'                                                  | 'TRY'      | 'Legal currency, TRY'          | '200,00'   | ''         | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'   | ''        | '1 200,00' | ''         | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                                                                        | ''         | ''                             | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | ''        | '1 200,00' | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |
		And I close all client application windows
		

Scenario: _52007 SR-BP (AP - by documents, IsAdvance = False)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "10.08.2023" text in the field named "DateBegin"
		And I input "11.08.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 1 (3 partner terms)" string
		And I click "Generate" button
	* Check				
		And "Result" spreadsheet document contains lines:
			| 'Company'                                  | ''                                                        | ''         | ''                             | 'Amount'  | ''        | ''         | 'CA'      | ''        | ''        | 'CT'      | ''        | ''         | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                  | 'Legal name'                                              | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing'  | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing'  | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                 | 'Agreement'                                               | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''         | ''        | ''        | ''        | ''        | ''        | ''         | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                            | ''                                                        | ''         | ''                             | ''        | ''        | '1 670,00' | ''        | ''        | '-900,00' | ''        | ''        | '2 570,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 1 (3 partner terms)'             | 'Client 1'                                                | ''         | ''                             | ''        | ''        | '1 670,00' | ''        | ''        | '-900,00' | ''        | ''        | '2 570,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 4 dated 10.08.2023 12:00:00' | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '-100,00' | ''        | '1 570,00' | ''        | ''        | '-900,00' | '-100,00' | ''        | '2 470,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 3 dated 11.08.2023 12:00:00' | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '100,00'  | ''        | '1 670,00' | ''        | ''        | '-900,00' | '100,00'  | ''        | '2 570,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows
		
Scenario: _52008 SI-BR (AP - by documents, BR - PaymentFromCustomerByPOS IsAdvance = True, IsAdvance = False, without customer advance closing)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.12.2023" text in the field named "DateBegin"
		And I input "02.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 3" string
		And I click "Generate" button
	* Check				
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                                                                                    | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '750,00'  | '750,00'  | ''        | ''        | '250,00'  | '-250,00' | '750,00'  | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 3'                                 | 'Client 3'                                                                                                            | ''         | ''                             | '750,00'  | '750,00'  | ''        | ''        | '250,00'  | '-250,00' | '750,00'  | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 11 dated 02.12.2023 14:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 12 dated 02.12.2023 15:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '250,00'  | ''        | ''        | '250,00'  | '-250,00' | ''        | ''        | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '750,00'  | '750,00'  | ''        | ''        | '250,00'  | '-250,00' | '750,00'  | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows				

Scenario: _52009 SI-BR-SR-BP (AP - by documents, BP - Return to customer, BR- Payment from customer, IsAdvance = True, IsAdvance = False, without customer advance closing)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.12.2023" text in the field named "DateBegin"
		And I input "05.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 3" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                        | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                              | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                               | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                        | ''         | ''                             | '750,00'  | '750,00'  | ''        | '150,00'  | '250,00'  | '-100,00' | '600,00'  | '500,00'  | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 3'                                 | 'Client 3'                                                | ''         | ''                             | '750,00'  | '750,00'  | ''        | '150,00'  | '250,00'  | '-100,00' | '600,00'  | '500,00'  | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 11 dated 02.12.2023 14:00:00'  | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 12 dated 02.12.2023 15:00:00'  | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | ''        | '250,00'  | ''        | ''        | '250,00'  | '-250,00' | ''        | ''        | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 7 dated 04.12.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '-300,00' | ''        | '-300,00' | ''        | ''        | '-250,00' | '-300,00' | ''        | '-50,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 11 dated 04.12.2023 16:00:00'  | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '150,00'  | ''        | '-150,00' | '150,00'  | ''        | '-100,00' | ''        | ''        | '-50,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 12 dated 05.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '150,00'  | ''        | ''        | ''        | ''        | '-100,00' | '150,00'  | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                        | ''         | ''                             | '750,00'  | '750,00'  | ''        | '150,00'  | '250,00'  | '-100,00' | '600,00'  | '500,00'  | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows

Scenario: _52010 BP (OtherPartner)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "22.03.2024" text in the field named "DateBegin"
		And I input "22.03.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Other partner" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:
			| 'Company'                                   | ''                                                                                                                       | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                   | 'Legal name'                                                                                                             | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                  | 'Agreement'                                                                                                              | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                             | ''                                                                                                                       | ''         | ''                             | '9,80'    | ''        | '9,80'    | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '9,80'    | ''        | '9,80'    |
			| 'Other partner'                             | 'Other partner'                                                                                                          | ''         | ''                             | '9,80'    | ''        | '9,80'    | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '9,80'    | ''        | '9,80'    |
			| 'Bank payment 13 dated 22.03.2024 10:51:11' | 'Other partner term'                                                                                                     | 'TRY'      | 'Legal currency, TRY'          | '9,80'    | ''        | '9,80'    | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '9,80'    | ''        | '9,80'    |
			| 'Total'                                     | ''                                                                                                                       | ''         | ''                             | '9,80'    | ''        | '9,80'    | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '9,80'    | ''        | '9,80'    |
	And I close all client application windows
	

Scenario: _52011 BR (OtherPartner)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "11.01.2024" text in the field named "DateBegin"
		And I input "11.01.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Other partner" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:				
			| 'Company'                                   | ''                                                                                                                       | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                   | 'Legal name'                                                                                                             | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                  | 'Agreement'                                                                                                              | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                             | ''                                                                                                                       | ''         | ''                             | ''        | '490,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '490,00'  | ''        |
			| 'Other partner'                             | 'Other partner'                                                                                                          | ''         | ''                             | ''        | '490,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '490,00'  | ''        |
			| 'Bank receipt 14 dated 11.01.2024 10:00:00' | 'Other partner term'                                                                                                     | 'TRY'      | 'Legal currency, TRY'          | ''        | '490,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '490,00'  | ''        |
			| 'Total'                                     | ''                                                                                                                       | ''         | ''                             | ''        | '490,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '490,00'  | ''        |
		And I close all client application windows

Scenario: _52011 CR (OtherPartner)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.12.2023" text in the field named "DateBegin"
		And I input "02.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Other partner" string
		And I click "Generate" button
		
		And I close all client application windows

Scenario: _52012 BR (AP - by documents, BR - ReturnFromVendor, IsAdvance = True, without vendor advance closing)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "01.12.2023" text in the field named "DateBegin"
		And I input "05.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer and vendor" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:
			| 'Company'                                      | ''                                                                                                                             | ''         | ''                             | 'Amount'   | ''         | ''          | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'       | ''        | ''         | 'VT'       | ''         | ''          | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                                                                                                   | ''         | ''                             | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt'  | 'Expense' | 'Closing'  | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                                                                                                    | 'Currency' | 'Multi currency movement type' | ''         | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''        | ''         | ''         | ''         | ''          | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                                                                                             | ''         | ''                             | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | '50,00'   | '1 150,00' | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |
			| 'Customer and vendor'                          | 'Client and vendor'                                                                                                            | ''         | ''                             | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | '50,00'   | '1 150,00' | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |
			| 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''        | ''         | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        |
			| 'Bank payment 8 dated 02.12.2023 16:00:00'     | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''        | ''         | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Cash payment 5 dated 03.12.2023 12:00:00'     | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | '1 000,00' | ''         | '-4 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 000,00' | ''        | '1 000,00' | ''         | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Bank payment 9 dated 03.12.2023 12:30:00'     | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | '200,00'   | ''         | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'   | ''        | '1 200,00' | ''         | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Bank receipt 13 dated 05.12.2023 10:00:00'    | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | ''         | '50,00'    | '-4 535,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | '50,00'   | '1 150,00' | ''         | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                                                                                             | ''         | ''                             | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | '50,00'   | '1 150,00' | '4 000,00' | '9 685,00' | '-5 685,00' | ''        | ''        | ''        |
		And I close all client application windows
		
Scenario: _52013 ECA (is Purchase)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "22.03.2024" text in the field named "DateBegin"
		And I input "22.03.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Vendor 1 (1 partner term)" string
		And I click "Generate" button
		Then "Result" spreadsheet document is equal
			| 'Company'                                           | ''                           | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                           | 'Legal name'                 | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                          | 'Agreement'                  | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                                     | ''                           | ''         | ''                             | '200,00'  | ''        | '*'       | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | ''        | '*'       | ''        | ''        | ''        |
			| 'Vendor 1 (1 partner term)'                         | 'Vendor 1'                   | ''         | ''                             | '200,00'  | ''        | '*'       | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | ''        | '*'       | ''        | ''        | ''        |
			| 'Employee cash advance 3 dated 22.03.2024 11:52:17' | 'Partner term with vendor 1' | 'TRY'      | 'Legal currency, TRY'          | '200,00'  | ''        | '*'       | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | ''        | '*'       | ''        | ''        | ''        |
		And I close all client application windows
		
Scenario: _52014 RSR - RRR - BR (StatusType = Completed, UsePartnerTransactions, BR - Payment from customer by POS, IsAdvance = True)
	And I close all client application windows
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.02.2024" text in the field named "DateBegin"
		And I input "02.02.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 3" string
		And I click "Generate" button
		Then "Result" spreadsheet document is equal
			| 'Company'                                           | ''                                                                                                                    | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                           | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                          | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                                     | ''                                                                                                                    | ''         | ''                             | ''        | '100,00'  | '-100,00' | ''        | '100,00'  | '-200,00' | ''        | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 3'                                        | 'Client 3'                                                                                                            | ''         | ''                             | ''        | '100,00'  | '-100,00' | ''        | '100,00'  | '-200,00' | ''        | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Retail sales receipt 4 dated 02.02.2024 00:00:05'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '490,00'  | '490,00'  | ''        | ''        | ''        | '-100,00' | '490,00'  | '490,00'  | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 15 dated 02.02.2024 10:00:00'         | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '100,00'  | '-100,00' | ''        | '100,00'  | '-200,00' | ''        | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-490,00' | '-490,00' | '-100,00' | ''        | ''        | '-200,00' | '-490,00' | '-490,00' | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                             | ''                                                                                                                    | ''         | ''                             | ''        | '100,00'  | '-100,00' | ''        | '100,00'  | '-200,00' | ''        | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |	
		And I close all client application windows



Scenario: _52030 BR - SI - DN (AR - by documents, BR - payment from customer, IsAdvance = True, with customer advance closing)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"		
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Number' |
			| '4'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Number' |
			| '5'      |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "30.03.2023" text in the field named "DateBegin"
		And I input "01.04.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 1 (3 partner terms)" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                   | ''                                                        | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                   | 'Legal name'                                              | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                  | 'Agreement'                                               | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                             | ''                                                        | ''         | ''                             | '560,00'  | '390,00'  | '170,00'  | '40,00'   | '350,00'  | '-310,00' | '520,00'  | '40,00'   | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 1 (3 partner terms)'              | 'Client 1'                                                | ''         | ''                             | '560,00'  | '390,00'  | '170,00'  | '40,00'   | '350,00'  | '-310,00' | '520,00'  | '40,00'   | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 3 dated 30.03.2023 12:23:56' | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '480,00'  | ''        | '480,00'  | ''        | ''        | ''        | '480,00'  | ''        | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 3 dated 01.04.2023 13:53:41'  | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | ''        | '350,00'  | '130,00'  | ''        | '350,00'  | '-350,00' | ''        | ''        | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Debit note 2 dated 01.04.2023 14:10:35'    | 'Partner term with customer (by document + credit limit)' | 'TRY'      | 'Legal currency, TRY'          | '80,00'   | '40,00'   | '170,00'  | '40,00'   | ''        | '-310,00' | '40,00'   | '40,00'   | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                     | ''                                                        | ''         | ''                             | '560,00'  | '390,00'  | '170,00'  | '40,00'   | '350,00'  | '-310,00' | '520,00'  | '40,00'   | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows

Scenario: _52031 PI-BP-CP (AP - by documents, CP,BP-IsAdvance = True, with vendor advance closing )
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"		
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.12.2023" text in the field named "DateBegin"
		And I input "03.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer and vendor" string
		And I click "Generate" button
	* Check				
		And "Result" spreadsheet document contains lines:
			| 'Company'                                      | ''                                                       | ''         | ''                             | 'Amount'   | ''         | ''          | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'       | ''         | ''        | 'VT'       | ''         | ''          | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                             | ''         | ''                             | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt'  | 'Expense'  | 'Closing' | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                              | 'Currency' | 'Multi currency movement type' | ''         | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | ''         | ''         | ''          | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                       | ''         | ''                             | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | '1 200,00' | ''        | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        |
			| 'Customer and vendor'                          | 'Client and vendor'                                      | ''         | ''                             | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | '1 200,00' | ''        | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        |
			| 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'Partner term with vendor (advance payment by document)' | 'TRY'      | 'Legal currency, TRY'          | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        |
			| 'Bank payment 8 dated 02.12.2023 16:00:00'     | 'Partner term with vendor (advance payment by document)' | 'TRY'      | 'Legal currency, TRY'          | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Cash payment 5 dated 03.12.2023 12:00:00'     | 'Partner term with vendor (advance payment by document)' | 'TRY'      | 'Legal currency, TRY'          | '1 000,00' | ''         | '-4 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 000,00' | '1 000,00' | ''        | '1 000,00' | ''         | '-4 685,00' | ''        | ''        | ''        |
			| 'Bank payment 9 dated 03.12.2023 12:30:00'     | 'Partner term with vendor (advance payment by document)' | 'TRY'      | 'Legal currency, TRY'          | '200,00'   | ''         | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'   | '200,00'   | ''        | '200,00'   | ''         | '-4 485,00' | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                       | ''         | ''                             | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 200,00' | '1 200,00' | ''        | '5 200,00' | '9 685,00' | '-4 485,00' | ''        | ''        | ''        |
		And I close all client application windows

Scenario: _52032 SI-BR-SR-BP (AP - by documents, BP - Return to customer, BR- Payment from customer, IsAdvance = True, IsAdvance = False, with customer advance closing)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"		
		And I go to line in "List" table
			| 'Number' |
			| '12'     |
		And in the table "List" I click the button named "ListContextMenuPost"
	* Open report R5020_PartnersBalance and select option
		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option'  |
			| 'For test'       |
		And I select current line in "OptionsList" table
	* Select partner, period and currency movement type
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "02.12.2023" text in the field named "DateBegin"
		And I input "05.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 3" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                                                                                    | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '750,00'  | '750,00'  | ''        | '550,00'  | '550,00'  | ''        | '600,00'  | '600,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 3'                                 | 'Client 3'                                                                                                            | ''         | ''                             | '750,00'  | '750,00'  | ''        | '550,00'  | '550,00'  | ''        | '600,00'  | '600,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 11 dated 02.12.2023 14:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 12 dated 02.12.2023 15:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '250,00'  | ''        | '250,00'  | '250,00'  | ''        | ''        | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 7 dated 04.12.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-300,00' | ''        | '-300,00' | ''        | '300,00'  | '-300,00' | '-300,00' | '-300,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 11 dated 04.12.2023 16:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '150,00'  | ''        | '-150,00' | '150,00'  | ''        | '-150,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 12 dated 05.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '150,00'  | ''        | ''        | '150,00'  | ''        | ''        | '150,00'  | '150,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '750,00'  | '750,00'  | ''        | '550,00'  | '550,00'  | ''        | '600,00'  | '600,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |		
		And I close all client application windows


// Scenario: _52013 BR (AP - by documents, BR - ReturnFromVendor, IsAdvance = True, with vendor advance closing)
// 	And I close all client application windows
// 	* Open report R5020_PartnersBalance and select option
// 		Given I open hyperlink "e1cib/app/Report.R5020_PartnersBalance"
// 		And I click "Select option..." button
// 		Then "Load form" window is opened
// 		And I go to line in "OptionsList" table
// 			| 'Report option'  |
// 			| 'For test'       |
// 		And I select current line in "OptionsList" table
// 	* Select partner, period and currency movement type
// 		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
// 		And I input "11.01.2024" text in the field named "DateBegin"
// 		And I input "11.01.2024" text in the field named "DateEnd"
// 		And I click the button named "Select"
// 		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
// 		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Other partner" string
// 		And I click "Generate" button
		
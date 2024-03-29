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
	
			
Scenario: _52005 PI-PR-CP-DN-BR (AP - by partner terms, BR - return from vendor, IsAdvance = False)
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

Scenario: _52012 CR (OtherPartner)
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
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Other partner 2" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:	
			| 'Company'                                  | ''                                                                                                                         | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                  | 'Legal name'                                                                                                               | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                 | 'Agreement'                                                                                                                | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                            | ''                                                                                                                         | ''         | ''                             | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'  | ''        |
			| 'Other partner 2'                          | 'Other partner 2'                                                                                                          | ''         | ''                             | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'  | ''        |
			| 'Cash receipt 5 dated 02.12.2023 09:00:00' | 'Other partner term 2'                                                                                                     | 'TRY'      | 'Legal currency, TRY'          | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'  | ''        |
			| 'Total'                                    | ''                                                                                                                         | ''         | ''                             | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'  | ''        |
		And I close all client application windows

Scenario: _52013 CP (OtherPartner)
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
		And I input "01.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Other partner 2" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:	
			| 'Company'                                  | ''                                                                                                                         | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                  | 'Legal name'                                                                                                               | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                 | 'Agreement'                                                                                                                | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                            | ''                                                                                                                         | ''         | ''                             | '100,00'  | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'  | ''        | '100,00'  |
			| 'Other partner 2'                          | 'Other partner 2'                                                                                                          | ''         | ''                             | '100,00'  | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'  | ''        | '100,00'  |
			| 'Cash payment 6 dated 01.12.2023 10:00:00' | 'Other partner term 2'                                                                                                     | 'TRY'      | 'Legal currency, TRY'          | '100,00'  | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'  | ''        | '100,00'  |
			| 'Total'                                    | ''                                                                                                                         | ''         | ''                             | '100,00'  | ''        | '100,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '100,00'  | ''        | '100,00'  |	
		And I close all client application windows

Scenario: _52014 BR (AP - by documents, BR - ReturnFromVendor, IsAdvance = True, without vendor advance closing)
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
		
Scenario: _52015 ECA (is Purchase)
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
		And I input "01.02.2024" text in the field named "DateBegin"
		And I input "22.03.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Vendor 4 (1 partner term)" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:
			| 'Company'                                           | ''                                                                                                                                   | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                           | 'Legal name'                                                                                                                         | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                          | 'Agreement'                                                                                                                          | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                                     | ''                                                                                                                                   | ''         | ''                             | '200,00'  | '240,00'  | '-40,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '240,00'  | '-40,00'  | ''        | ''        | ''        |
			| 'Vendor 4 (1 partner term)'                         | 'Vendor 4'                                                                                                                           | ''         | ''                             | '200,00'  | '240,00'  | '-40,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '240,00'  | '-40,00'  | ''        | ''        | ''        |
			| 'Purchase invoice 6 dated 01.02.2024 12:00:00'      | 'Vendor 4 (partner term) '                                                                                                           | 'TRY'      | 'Legal currency, TRY'          | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        |
			| 'Employee cash advance 3 dated 22.03.2024 11:52:17' | 'Vendor 4 (partner term) '                                                                                                           | 'TRY'      | 'Legal currency, TRY'          | '200,00'  | ''        | '-40,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | ''        | '-40,00'  | ''        | ''        | ''        |
			| 'Total'                                             | ''                                                                                                                                   | ''         | ''                             | '200,00'  | '240,00'  | '-40,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '240,00'  | '-40,00'  | ''        | ''        | ''        |		
		And I close all client application windows
		
Scenario: _52016 RSR - RRR - BR (StatusType = Completed, UsePartnerTransactions, BR - Payment from customer by POS, IsAdvance = True)
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
		And "Result" spreadsheet document contains lines:
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

Scenario: _52017 SI - SR - CP (Return to customer, IsAdvance = True, IsAdvance = False, without customer advance closing)
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
		And I input "01.08.2023" text in the field named "DateBegin"
		And I input "22.03.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 4" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                                                                                    | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '760,00'  | ''        | '760,00'  | '190,00'  | ''        | '190,00'  | '570,00'  | ''        | '570,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 4'                                 | 'Client 4'                                                                                                            | ''         | ''                             | '760,00'  | ''        | '760,00'  | '190,00'  | ''        | '190,00'  | '570,00'  | ''        | '570,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 13 dated 01.08.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '760,00'  | ''        | '760,00'  | ''        | ''        | ''        | '760,00'  | ''        | '760,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 8 dated 02.08.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-380,00' | ''        | '380,00'  | ''        | ''        | ''        | '-380,00' | ''        | '380,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 9 dated 10.08.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-190,00' | ''        | '190,00'  | ''        | ''        | ''        | '-190,00' | ''        | '190,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Cash payment 9 dated 22.03.2024 12:24:16'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '380,00'  | ''        | '570,00'  | ''        | ''        | ''        | '380,00'  | ''        | '570,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Cash payment 10 dated 22.03.2024 12:25:12'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '190,00'  | ''        | '760,00'  | '190,00'  | ''        | '190,00'  | ''        | ''        | '570,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '760,00'  | ''        | '760,00'  | '190,00'  | ''        | '190,00'  | '570,00'  | ''        | '570,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows
		
Scenario: _52018 PR - CR (Return from vendor, IsAdvance = True, IsAdvance = False, without vendor advance closing)
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
		And I input "10.12.2023" text in the field named "DateBegin"
		And I input "14.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Vendor 3 (1 partner term)" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                     | ''                                                                                                                                   | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                     | 'Legal name'                                                                                                                         | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                    | 'Agreement'                                                                                                                          | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                               | ''                                                                                                                                   | ''         | ''                             | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '200,00'  | ''        | '-200,00' | '-200,00' | ''        | ''        | ''        |
			| 'Vendor 3 (1 partner term)'                   | 'Vendor 3'                                                                                                                           | ''         | ''                             | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '200,00'  | ''        | '-200,00' | '-200,00' | ''        | ''        | ''        |
			| 'Purchase return 3 dated 10.12.2023 12:00:00' | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '-264,00' | '264,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '400,00'  | ''        | '-264,00' | '-136,00' | ''        | ''        | ''        |
			| 'Cash receipt 6 dated 11.12.2023 12:00:00'    | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '200,00'  | '64,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '200,00'  | ''        | ''        | '-136,00' | ''        | ''        | ''        |
			| 'Cash receipt 7 dated 14.12.2023 12:00:00'    | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '64,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | ''        | '64,00'   | '-200,00' | ''        | ''        | ''        |
			| 'Total'                                       | ''                                                                                                                                   | ''         | ''                             | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '200,00'  | ''        | '-200,00' | '-200,00' | ''        | ''        | ''        |	
		And I close all client application windows

Scenario: _52019 CR-SI (PaymentFromCustomer, IsAdvance = True, without customer advance closing)
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
		And I input "03.12.2023" text in the field named "DateBegin"
		And I input "03.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 5" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                                                                                    | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '450,00'  | '100,00'  | '350,00'  | ''        | '100,00'  | '-100,00' | '450,00'  | ''        | '450,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 5'                                 | 'Customer 5'                                                                                                          | ''         | ''                             | '450,00'  | '100,00'  | '350,00'  | ''        | '100,00'  | '-100,00' | '450,00'  | ''        | '450,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Cash receipt 8 dated 03.12.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '100,00'  | '-100,00' | ''        | '100,00'  | '-100,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 15 dated 03.12.2023 17:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '450,00'  | ''        | '350,00'  | ''        | ''        | '-100,00' | '450,00'  | ''        | '450,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '450,00'  | '100,00'  | '350,00'  | ''        | '100,00'  | '-100,00' | '450,00'  | ''        | '450,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |	
		And I close all client application windows

Scenario: _52020 Sales report from trade agent (Amount)
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
		And I input "25.03.2023" text in the field named "DateBegin"
		And I input "25.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Trade agent" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                                   | ''                                                                                                                     | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                                   | 'Legal name'                                                                                                           | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                                  | 'Agreement'                                                                                                            | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                                             | ''                                                                                                                     | ''         | ''                             | '500,00'  | ''        | '500,00'  | ''        | ''        | ''        | '500,00'  | ''        | '500,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Trade agent'                                               | 'Trade agent'                                                                                                          | ''         | ''                             | '500,00'  | ''        | '500,00'  | ''        | ''        | ''        | '500,00'  | ''        | '500,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales report from trade agent 1 dated 25.03.2023 12:00:01' | 'Partner term with trade agent'                                                                                        | 'TRY'      | 'Legal currency, TRY'          | '500,00'  | ''        | '500,00'  | ''        | ''        | ''        | '500,00'  | ''        | '500,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                                     | ''                                                                                                                     | ''         | ''                             | '500,00'  | ''        | '500,00'  | ''        | ''        | ''        | '500,00'  | ''        | '500,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows	

Scenario: _52021 Sales report to consignor (Amount)
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
		And I input "10.03.2023" text in the field named "DateBegin"
		And I input "10.03.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Consignor 1 (without VAT)" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                               | ''                                                                                                                                   | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                               | 'Legal name'                                                                                                                         | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                              | 'Agreement'                                                                                                                          | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                                         | ''                                                                                                                                   | ''         | ''                             | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        |
			| 'Consignor 1 (without VAT)'                             | 'Consignor 1'                                                                                                                        | ''         | ''                             | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        |
			| 'Sales report to consignor 1 dated 10.03.2023 12:00:00' | 'Partner term Consignor 1'                                                                                                           | 'TRY'      | 'Legal currency, TRY'          | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        |
			| 'Total'                                                 | ''                                                                                                                                   | ''         | ''                             | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '240,00'  | '-240,00' | ''        | ''        | ''        |
		And I close all client application windows

Scenario: _52022 SI-BR-SR-BP (PaymentFromCustomerByPOS, ReturnToCustomerByPOS, IsAdvance = True, IsAdvance = False, without customer advance closing)
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
		And I input "25.12.2023" text in the field named "DateBegin"
		And I input "30.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 6" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                                                                                    | ''         | ''                             | 'Amount'    | ''         | ''          | 'CA'      | ''        | ''        | 'CT'        | ''         | ''         | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt'   | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' | 'Receipt'   | 'Expense'  | 'Closing'  | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''          | ''         | ''          | ''        | ''        | ''        | ''          | ''         | ''         | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '1 400,00'  | '1 400,00' | ''          | '400,00'  | '400,00'  | ''        | '1 000,00'  | '1 000,00' | ''         | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 6'                                 | 'Customer 6'                                                                                                          | ''         | ''                             | '1 400,00'  | '1 400,00' | ''          | '400,00'  | '400,00'  | ''        | '1 000,00'  | '1 000,00' | ''         | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 16 dated 25.12.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '1 000,00'  | ''         | '1 000,00'  | ''        | ''        | ''        | '1 000,00'  | ''         | '1 000,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 16 dated 26.12.2023 17:29:14'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''          | '1 000,00' | ''          | ''        | ''        | ''        | ''          | '1 000,00' | ''         | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 17 dated 26.12.2023 17:30:34' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '400,00'    | ''         | '400,00'    | ''        | ''        | ''        | '400,00'    | ''         | '400,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 17 dated 26.12.2023 17:32:09'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''          | '400,00'   | ''          | ''        | '400,00'  | '-400,00' | ''          | ''         | '400,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 10 dated 28.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-1 000,00' | ''         | '-1 000,00' | ''        | ''        | '-400,00' | '-1 000,00' | ''         | '-600,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 14 dated 28.12.2023 17:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '1 000,00'  | ''         | ''          | ''        | ''        | '-400,00' | '1 000,00'  | ''         | '400,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 11 dated 29.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-400,00'   | ''         | '-400,00'   | ''        | ''        | '-400,00' | '-400,00'   | ''         | ''         | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 15 dated 30.12.2023 17:48:36'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '400,00'    | ''         | ''          | '400,00'  | ''        | ''        | ''          | ''         | ''         | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '1 400,00'  | '1 400,00' | ''          | '400,00'  | '400,00'  | ''        | '1 000,00'  | '1 000,00' | ''         | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows



Scenario: _52040 check Bank payment movements by the Register  "R5020 Partners balance" (PaymentToVendor, IsAdvance = False)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 8 dated 02.12.2023 16:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''                                             | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''                                             | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''                                             | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                    | ''                  | ''                                                       | ''                                             | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'             | 'Legal name'        | 'Agreement'                                              | 'Document'                                     | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Receipt'     | '02.12.2023 16:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '02.12.2023 16:00:00' | '130,67'    | ''                     | ''                 | '130,67'             | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '02.12.2023 16:00:00' | '4 000'     | ''                     | ''                 | '4 000'              | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '02.12.2023 16:00:00' | '4 000'     | ''                     | ''                 | '4 000'              | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '02.12.2023 16:00:00' | '4 000'     | ''                     | ''                 | '4 000'              | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				
Scenario: _52041 check Bank payment movements by the Register  "R5020 Partners balance" (PaymentToVendor, IsAdvance = True)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 9 dated 03.12.2023 12:30:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                    | ''                  | ''                                                       | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'             | 'Legal name'        | 'Agreement'                                              | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Receipt'     | '03.12.2023 12:30:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '03.12.2023 12:30:00' | '6,53'      | ''                     | ''                 | ''                   | '6,53'           | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '03.12.2023 12:30:00' | '200'       | ''                     | ''                 | ''                   | '200'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '03.12.2023 12:30:00' | '200'       | ''                     | ''                 | ''                   | '200'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '03.12.2023 12:30:00' | '200'       | ''                     | ''                 | ''                   | '200'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
						
Scenario: _52043 check Bank payment movements by the Register  "R5020 Partners balance" (ReturnToCustomer, IsAdvance = True)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 11 dated 04.12.2023 16:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Receipt'     | '04.12.2023 16:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '04.12.2023 16:00:00' | '4,9'       | ''                     | '4,9'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '04.12.2023 16:00:00' | '150'       | ''                     | '150'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '04.12.2023 16:00:00' | '150'       | ''                     | '150'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '04.12.2023 16:00:00' | '150'       | ''                     | '150'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52044 check Bank payment movements by the Register  "R5020 Partners balance" (ReturnToCustomer, IsAdvance = False)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '12'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 12 dated 05.12.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document'                                 | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Receipt'     | '05.12.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 7 dated 04.12.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '05.12.2023 12:00:00' | '4,9'       | '4,9'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 7 dated 04.12.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '05.12.2023 12:00:00' | '150'       | '150'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 7 dated 04.12.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '05.12.2023 12:00:00' | '150'       | '150'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 7 dated 04.12.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '05.12.2023 12:00:00' | '150'       | '150'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 7 dated 04.12.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
		
Scenario: _52044 check Bank payment movements by the Register  "R5020 Partners balance" (ReturnToCustomerByPOS, IsAdvance = True)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '15'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 15 dated 30.12.2023 17:48:36' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Receipt'     | '30.12.2023 17:48:36' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '30.12.2023 17:48:36' | '12,66'     | ''                     | '12,66'            | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '30.12.2023 17:48:36' | '400'       | ''                     | '400'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '30.12.2023 17:48:36' | '400'       | ''                     | '400'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '30.12.2023 17:48:36' | '400'       | ''                     | '400'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				
Scenario: _52044 check Bank payment movements by the Register  "R5020 Partners balance" (ReturnToCustomerByPOS, IsAdvance = False)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 14 dated 28.12.2023 17:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                          | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                          | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                          | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''                                          | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document'                                  | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Receipt'     | '28.12.2023 17:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales return 10 dated 28.12.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '28.12.2023 17:00:00' | '31,64'     | '31,64'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales return 10 dated 28.12.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '28.12.2023 17:00:00' | '1 000'     | '1 000'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales return 10 dated 28.12.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '28.12.2023 17:00:00' | '1 000'     | '1 000'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales return 10 dated 28.12.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '28.12.2023 17:00:00' | '1 000'     | '1 000'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales return 10 dated 28.12.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52045 check Bank payment movements by the Register  "R5020 Partners balance" (OtherPartner)
		And I close all client application windows
	* Select Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '13'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank payment 13 dated 22.03.2024 10:51:11' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''              | ''              | ''                   | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''              | ''              | ''                   | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''              | ''              | ''                   | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''              | ''              | ''                   | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'       | 'Legal name'    | 'Agreement'          | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Receipt'     | '22.03.2024 10:51:11' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '22.03.2024 10:51:11' | '0,3'       | ''                     | ''                 | ''                   | ''               | '0,3'               | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '22.03.2024 10:51:11' | '9,8'       | ''                     | ''                 | ''                   | ''               | '9,8'               | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '22.03.2024 10:51:11' | '9,8'       | ''                     | ''                 | ''                   | ''               | '9,8'               | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '22.03.2024 10:51:11' | '9,8'       | ''                     | ''                 | ''                   | ''               | '9,8'               | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			
Scenario: _52046 check Bank receipt movements by the Register  "R5020 Partners balance" (PaymentFromCustomer, IsAdvance = True)
		And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 3 dated 01.04.2023 13:53:41' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                             | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                      | 'Legal name' | 'Agreement'                                               | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Expense'     | '01.04.2023 13:53:41' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '01.04.2023 13:53:41' | '16,83'     | ''                     | '16,83'            | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '01.04.2023 13:53:41' | '350'       | ''                     | '350'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '01.04.2023 13:53:41' | '350'       | ''                     | '350'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '01.04.2023 13:53:41' | '350'       | ''                     | '350'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52047 check Bank receipt movements by the Register  "R5020 Partners balance" (PaymentFromCustomer, IsAdvance = False)
		And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '6'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 6 dated 11.09.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                             | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                      | 'Legal name' | 'Agreement'                                               | 'Document'                                   | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Expense'     | '11.09.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 11 dated 10.09.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '11.09.2023 12:00:00' | '25,37'     | '25,37'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 11 dated 10.09.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '11.09.2023 12:00:00' | '750'       | '750'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 11 dated 10.09.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '11.09.2023 12:00:00' | '750'       | '750'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 11 dated 10.09.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '11.09.2023 12:00:00' | '750'       | '750'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 11 dated 10.09.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				
Scenario: _52048 check Bank receipt movements by the Register  "R5020 Partners balance" (ReturnFromVendor, IsAdvance = True)
		And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '13'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 13 dated 05.12.2023 10:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                    | ''                  | ''                                                       | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                    | ''                  | ''                                                       | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'             | 'Legal name'        | 'Agreement'                                              | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Expense'     | '05.12.2023 10:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '05.12.2023 10:00:00' | '1,63'      | ''                     | ''                 | ''                   | '1,63'           | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '05.12.2023 10:00:00' | '50'        | ''                     | ''                 | ''                   | '50'             | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '05.12.2023 10:00:00' | '50'        | ''                     | ''                 | ''                   | '50'             | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '05.12.2023 10:00:00' | '50'        | ''                     | ''                 | ''                   | '50'             | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer and vendor' | 'Client and vendor' | 'Partner term with vendor (advance payment by document)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52049 check Bank receipt movements by the Register  "R5020 Partners balance" (ReturnFromVendor, IsAdvance = False)
		And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 8 dated 10.08.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''                           | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''                           | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''                           | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''                           | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement'                  | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Expense'     | '10.08.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | 'Partner term with vendor 1' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.08.2023 12:00:00' | '3,92'      | ''                     | ''                 | '3,92'               | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | 'Partner term with vendor 1' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.08.2023 12:00:00' | '100'       | ''                     | ''                 | '100'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | 'Partner term with vendor 1' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.08.2023 12:00:00' | '100'       | ''                     | ''                 | '100'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | 'Partner term with vendor 1' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.08.2023 12:00:00' | '100'       | ''                     | ''                 | '100'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | 'Partner term with vendor 1' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52050 check Bank receipt movements by the Register  "R5020 Partners balance" (PaymentFromCustomerByPOS, IsAdvance = True)
		And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '15'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 15 dated 02.02.2024 10:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Expense'     | '02.02.2024 10:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '02.02.2024 10:00:00' | '3,06'      | ''                     | '3,06'             | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '02.02.2024 10:00:00' | '100'       | ''                     | '100'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '02.02.2024 10:00:00' | '100'       | ''                     | '100'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '02.02.2024 10:00:00' | '100'       | ''                     | '100'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52051 check Bank receipt movements by the Register  "R5020 Partners balance" (PaymentFromCustomerByPOS, IsAdvance = False)
		And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '16'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 16 dated 26.12.2023 17:29:14' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document'                                   | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Expense'     | '26.12.2023 17:29:14' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 16 dated 25.12.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '26.12.2023 17:29:14' | '31,64'     | '31,64'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 16 dated 25.12.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '26.12.2023 17:29:14' | '1 000'     | '1 000'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 16 dated 25.12.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '26.12.2023 17:29:14' | '1 000'     | '1 000'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 16 dated 25.12.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '26.12.2023 17:29:14' | '1 000'     | '1 000'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 6' | 'Customer 6' | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 16 dated 25.12.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
				
		
Scenario: _52052 check Bank receipt movements by the Register  "R5020 Partners balance" (OtherPartner)
		And I close all client application windows
	* Select Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Bank receipt 14 dated 11.01.2024 10:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''              | ''              | ''                   | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''              | ''              | ''                   | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''              | ''              | ''                   | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''              | ''              | ''                   | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'       | 'Legal name'    | 'Agreement'          | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Expense'     | '11.01.2024 10:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '11.01.2024 10:00:00' | '14,98'     | ''                     | ''                 | ''                   | ''               | '14,98'             | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '11.01.2024 10:00:00' | '490'       | ''                     | ''                 | ''                   | ''               | '490'               | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '11.01.2024 10:00:00' | '490'       | ''                     | ''                 | ''                   | ''               | '490'               | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Expense'     | '11.01.2024 10:00:00' | '490'       | ''                     | ''                 | ''                   | ''               | '490'               | 'Own company 2' | 'Business unit 3' | 'Other partner' | 'Other partner' | 'Other partner term' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				
Scenario: _52053 check Cash payment movements by the Register  "R5020 Partners balance" (PaymentToVendor, IsAdvance = True)
		And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '7'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 7 dated 06.12.2023 12:03:11' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement' | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Receipt'     | '06.12.2023 12:03:11' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '06.12.2023 12:03:11' | '13,07'     | ''                     | ''                 | ''                   | '13,07'          | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '06.12.2023 12:03:11' | '400'       | ''                     | ''                 | ''                   | '400'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '06.12.2023 12:03:11' | '400'       | ''                     | ''                 | ''                   | '400'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '06.12.2023 12:03:11' | '400'       | ''                     | ''                 | ''                   | '400'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				
Scenario: _520531 check Cash payment movements by the Register  "R5020 Partners balance" (PaymentToVendor, IsAdvance = False)
	And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '8'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 8 dated 07.12.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                             | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                             | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                             | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''          | ''                                             | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement' | 'Document'                                     | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Receipt'     | '07.12.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '07.12.2023 12:00:00' | '4,18'      | ''                     | ''                 | '4,18'               | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '07.12.2023 12:00:00' | '128'       | ''                     | ''                 | '128'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '07.12.2023 12:00:00' | '128'       | ''                     | ''                 | '128'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '07.12.2023 12:00:00' | '128'       | ''                     | ''                 | '128'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				

Scenario: _52054 check Cash payment movements by the Register  "R5020 Partners balance" (ReturnToCustomer, IsAdvance = True)
	And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '10'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 10 dated 22.03.2024 12:25:12' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                          | 'Receipt'     | '22.03.2024 12:25:12' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '22.03.2024 12:25:12' | '5,81'      | ''                     | '5,81'             | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '22.03.2024 12:25:12' | '190'       | ''                     | '190'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '22.03.2024 12:25:12' | '190'       | ''                     | '190'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                          | 'Receipt'     | '22.03.2024 12:25:12' | '190'       | ''                     | '190'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				

Scenario: _52055 check Cash payment movements by the Register  "R5020 Partners balance" (ReturnToCustomer, IsAdvance = False)
	And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '9'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 9 dated 22.03.2024 12:24:16' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document'                                 | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Receipt'     | '22.03.2024 12:24:16' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '22.03.2024 12:24:16' | '11,62'     | '11,62'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '22.03.2024 12:24:16' | '380'       | '380'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '22.03.2024 12:24:16' | '380'       | '380'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '22.03.2024 12:24:16' | '380'       | '380'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				

Scenario: _52056 check Cash payment movements by the Register  "R5020 Partners balance" (OtherPartner)
	And I close all client application windows
	* Select Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number'    |
			| '6'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash payment 6 dated 01.12.2023 10:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                | ''                | ''                     | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                | ''                | ''                     | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                | ''                | ''                     | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                | ''                | ''                     | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'         | 'Legal name'      | 'Agreement'            | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Receipt'     | '01.12.2023 10:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '01.12.2023 10:00:00' | '3,27'      | ''                     | ''                 | ''                   | ''               | '3,27'              | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '01.12.2023 10:00:00' | '100'       | ''                     | ''                 | ''                   | ''               | '100'               | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '01.12.2023 10:00:00' | '100'       | ''                     | ''                 | ''                   | ''               | '100'               | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '01.12.2023 10:00:00' | '100'       | ''                     | ''                 | ''                   | ''               | '100'               | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				
Scenario: _52057 check Cash receipt movements by the Register  "R5020 Partners balance" (PaymentFromCustomer, IsAdvance = True)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '8'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 8 dated 03.12.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Expense'     | '03.12.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 5' | 'Customer 5' | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '03.12.2023 12:00:00' | '3,27'      | ''                     | '3,27'             | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 5' | 'Customer 5' | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '03.12.2023 12:00:00' | '100'       | ''                     | '100'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 5' | 'Customer 5' | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '03.12.2023 12:00:00' | '100'       | ''                     | '100'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 5' | 'Customer 5' | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '03.12.2023 12:00:00' | '100'       | ''                     | '100'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 5' | 'Customer 5' | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				
Scenario: _52058 check Cash receipt movements by the Register  "R5020 Partners balance" (PaymentFromCustomer, IsAdvance = False)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '1'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 1 dated 10.03.2023 00:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                          | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                          | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                          | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                             | ''           | ''                                                        | ''                                          | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                      | 'Legal name' | 'Agreement'                                               | 'Document'                                  | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 2 dated 24.02.2023 10:18:20' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)'  | 'Client 2'   | 'Individual partner term 1 (by partner term)'             | ''                                          | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | '19,96'     | '19,96'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)'  | 'Client 2'   | 'Individual partner term 1 (by partner term)'             | ''                                          | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | '47,41'     | '47,41'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 2 dated 24.02.2023 10:18:20' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | '400'       | '400'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)'  | 'Client 2'   | 'Individual partner term 1 (by partner term)'             | ''                                          | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | '400'       | '400'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)'  | 'Client 2'   | 'Individual partner term 1 (by partner term)'             | ''                                          | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | '400'       | '400'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 2 (2 partner term)'  | 'Client 2'   | 'Individual partner term 1 (by partner term)'             | ''                                          | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | '950'       | '950'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 2 dated 24.02.2023 10:18:20' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | '950'       | '950'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 2 dated 24.02.2023 10:18:20' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '10.03.2023 00:00:00' | '950'       | '950'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 2 dated 24.02.2023 10:18:20' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
				


Scenario: _52059 check Cash receipt movements by the Register  "R5020 Partners balance" (ReturnFromVendor, IsAdvance = True)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '6'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 6 dated 11.12.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement' | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Expense'     | '11.12.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '11.12.2023 12:00:00' | '6,53'      | ''                     | ''                 | ''                   | '6,53'           | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '11.12.2023 12:00:00' | '200'       | ''                     | ''                 | ''                   | '200'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '11.12.2023 12:00:00' | '200'       | ''                     | ''                 | ''                   | '200'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |		
			| ''                                         | 'Expense'     | '11.12.2023 12:00:00' | '200'       | ''                     | ''                 | ''                   | '200'            | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |		

Scenario: _52060 check Cash receipt movements by the Register  "R5020 Partners balance" (ReturnFromVendor, IsAdvance = False)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '7'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 7 dated 14.12.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                            | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                            | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                            | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''          | ''                                            | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement' | 'Document'                                    | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Expense'     | '14.12.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '14.12.2023 12:00:00' | '2,09'      | ''                     | ''                 | '2,09'               | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '14.12.2023 12:00:00' | '64'        | ''                     | ''                 | '64'                 | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '14.12.2023 12:00:00' | '64'        | ''                     | ''                 | '64'                 | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '14.12.2023 12:00:00' | '64'        | ''                     | ''                 | '64'                 | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |		


Scenario: _52061 check Cash receipt movements by the Register  "R5020 Partners balance" (OtherPartner)
	And I close all client application windows
	* Select Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '5'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash receipt 5 dated 02.12.2023 09:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                | ''                | ''                     | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                | ''                | ''                     | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                | ''                | ''                     | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                | ''                | ''                     | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'         | 'Legal name'      | 'Agreement'            | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Expense'     | '02.12.2023 09:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '02.12.2023 09:00:00' | '3,27'      | ''                     | ''                 | ''                   | ''               | '3,27'              | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '02.12.2023 09:00:00' | '100'       | ''                     | ''                 | ''                   | ''               | '100'               | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '02.12.2023 09:00:00' | '100'       | ''                     | ''                 | ''                   | ''               | '100'               | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Expense'     | '02.12.2023 09:00:00' | '100'       | ''                     | ''                 | ''                   | ''               | '100'               | 'Own company 2' | 'Business unit 1' | 'Other partner 2' | 'Other partner 2' | 'Other partner term 2' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |			


Scenario: _52062 check Purchase invoice movements by the Register  "R5020 Partners balance" (IsPurchase)
	And I close all client application windows
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'   |
			| '7'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 7 dated 05.12.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                             | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                             | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                             | ''         | ''                             | ''                     | ''                 |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''          | ''                                             | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement' | 'Document'                                     | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                             | 'Expense'     | '05.12.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                             | 'Expense'     | '05.12.2023 12:00:00' | '17,25'     | ''                     | ''                 | '17,25'              | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                             | 'Expense'     | '05.12.2023 12:00:00' | '528'       | ''                     | ''                 | '528'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                             | 'Expense'     | '05.12.2023 12:00:00' | '528'       | ''                     | ''                 | '528'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                             | 'Expense'     | '05.12.2023 12:00:00' | '528'       | ''                     | ''                 | '528'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase invoice 7 dated 05.12.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52063 check Sales invoice movements by the Register  "R5020 Partners balance" (IsSales)
	And I close all client application windows
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'   |
			| '12'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 12 dated 02.12.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'         | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | ''                 |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''                                           | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document'                                   | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                           | 'Receipt'     | '02.12.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                           | 'Receipt'     | '02.12.2023 12:00:00' | '24,5'      | '24,5'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                           | 'Receipt'     | '02.12.2023 12:00:00' | '750'       | '750'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                           | 'Receipt'     | '02.12.2023 12:00:00' | '750'       | '750'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                           | 'Receipt'     | '02.12.2023 12:00:00' | '750'       | '750'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52064 check Purchase return movements by the Register  "R5020 Partners balance" (IsPurchase)
	And I close all client application windows
	* Select Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'   |
			| '3'       |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase return 3 dated 10.12.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                            | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                            | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'          | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''                                            | ''         | ''                             | ''                     | ''                 |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''          | ''                                            | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                            | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement' | 'Document'                                    | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                            | 'Expense'     | '10.12.2023 12:00:00' | '-264'      | ''                     | ''                 | '-264'               | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                            | 'Expense'     | '10.12.2023 12:00:00' | '-264'      | ''                     | ''                 | '-264'               | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                            | 'Expense'     | '10.12.2023 12:00:00' | '-264'      | ''                     | ''                 | '-264'               | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                            | 'Expense'     | '10.12.2023 12:00:00' | '-8,62'     | ''                     | ''                 | '-8,62'              | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                            | 'Expense'     | '10.12.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 3 (1 partner term)' | 'Vendor 3'   | '№31-92'    | 'Purchase return 3 dated 10.12.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
		
Scenario: _52065 check Sales return movements by the Register  "R5020 Partners balance" (IsSales)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'   |
			| '8'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 8 dated 02.08.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'       | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | ''                 |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''                                         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document'                                 | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                         | 'Receipt'     | '02.08.2023 12:00:00' | '-380'      | '-380'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '02.08.2023 12:00:00' | '-380'      | '-380'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '02.08.2023 12:00:00' | '-380'      | '-380'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '02.08.2023 12:00:00' | '-14,91'    | '-14,91'               | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                         | 'Receipt'     | '02.08.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 4' | 'Client 4'   | 'Partner term with customer (by document + credit limit)' | 'Sales return 8 dated 02.08.2023 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
		
Scenario: _52066 check Retail sales receipt movements by the Register  "R5020 Partners balance" (UsePartnerTransactions)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '4'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                                 | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                   | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                                 | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'               | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                                 | ''         | ''                             | ''                     | ''                 |
			| ''                                                 | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''                                                 | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                                 | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document'                                         | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                                 | 'Receipt'     | '02.02.2024 00:00:05' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                 | 'Receipt'     | '02.02.2024 00:00:05' | '14,98'     | '14,98'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                 | 'Receipt'     | '02.02.2024 00:00:05' | '490'       | '490'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                                 | 'Receipt'     | '02.02.2024 00:00:05' | '490'       | '490'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                                 | 'Receipt'     | '02.02.2024 00:00:05' | '490'       | '490'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                                 | 'Expense'     | '02.02.2024 00:00:05' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                 | 'Expense'     | '02.02.2024 00:00:05' | '14,98'     | '14,98'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                 | 'Expense'     | '02.02.2024 00:00:05' | '490'       | '490'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                                 | 'Expense'     | '02.02.2024 00:00:05' | '490'       | '490'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                                 | 'Expense'     | '02.02.2024 00:00:05' | '490'       | '490'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail sales receipt 4 dated 02.02.2024 00:00:05' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52067 check Retail return receipt movements by the Register  "R5020 Partners balance" (UsePartnerTransactions)
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '2'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 2 dated 02.02.2024 16:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                                  | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                                  | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'                | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''           | ''           | ''                                                        | ''                                                  | ''         | ''                             | ''                     | ''                 |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''           | ''           | ''                                                        | ''                                                  | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                                  | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'    | 'Legal name' | 'Agreement'                                               | 'Document'                                          | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                                  | 'Receipt'     | '02.02.2024 16:00:00' | '-490'      | '-490'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '02.02.2024 16:00:00' | '-490'      | '-490'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '02.02.2024 16:00:00' | '-490'      | '-490'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '02.02.2024 16:00:00' | '-14,98'    | '-14,98'               | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '02.02.2024 16:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Expense'     | '02.02.2024 16:00:00' | '-490'      | '-490'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                                  | 'Expense'     | '02.02.2024 16:00:00' | '-490'      | '-490'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Expense'     | '02.02.2024 16:00:00' | '-490'      | '-490'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Expense'     | '02.02.2024 16:00:00' | '-14,98'    | '-14,98'               | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Expense'     | '02.02.2024 16:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 3' | 'Client 3'   | 'Partner term with customer (by document + credit limit)' | 'Retail return receipt 2 dated 02.02.2024 16:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
		
Scenario: _52068 check Employee cash advance movements by the Register  "R5020 Partners balance" (IsPurchase)
	And I close all client application windows
	* Select Employee cash advance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number'   |
			| '3'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Employee cash advance 3 dated 22.03.2024 11:52:17' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''                         | ''                                             | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''                         | ''                                             | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'                | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''                         | ''                                             | ''         | ''                             | ''                     | ''                 |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''                         | ''                                             | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                                  | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement'                | 'Document'                                     | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                                  | 'Receipt'     | '22.03.2024 11:52:17' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 4 (1 partner term)' | 'Vendor 4'   | 'Vendor 4 (partner term) ' | 'Purchase invoice 6 dated 01.02.2024 12:00:00' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '22.03.2024 11:52:17' | '6,12'      | ''                     | ''                 | '6,12'               | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 4 (1 partner term)' | 'Vendor 4'   | 'Vendor 4 (partner term) ' | 'Purchase invoice 6 dated 01.02.2024 12:00:00' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '22.03.2024 11:52:17' | '200'       | ''                     | ''                 | '200'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 4 (1 partner term)' | 'Vendor 4'   | 'Vendor 4 (partner term) ' | 'Purchase invoice 6 dated 01.02.2024 12:00:00' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '22.03.2024 11:52:17' | '200'       | ''                     | ''                 | '200'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 4 (1 partner term)' | 'Vendor 4'   | 'Vendor 4 (partner term) ' | 'Purchase invoice 6 dated 01.02.2024 12:00:00' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '22.03.2024 11:52:17' | '200'       | ''                     | ''                 | '200'                | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 4 (1 partner term)' | 'Vendor 4'   | 'Vendor 4 (partner term) ' | 'Purchase invoice 6 dated 01.02.2024 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52069 check Sales report from trade agent movements by the Register  "R5020 Partners balance" (IsPurchase)
	And I close all client application windows
	* Select Sales report from trade agent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I go to line in "List" table
			| 'Number'   |
			| '1'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales report from trade agent 1 dated 25.03.2023 12:00:01' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''            | ''            | ''                              | ''                                                          | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                            | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''            | ''            | ''                              | ''                                                          | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'                        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''            | ''            | ''                              | ''                                                          | ''         | ''                             | ''                     | ''                 |
			| ''                                                          | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''            | ''            | ''                              | ''                                                          | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                                          | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'     | 'Legal name'  | 'Agreement'                     | 'Document'                                                  | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                                          | 'Receipt'     | '25.03.2023 12:00:01' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Trade agent' | 'Trade agent' | 'Partner term with trade agent' | 'Sales report from trade agent 1 dated 25.03.2023 12:00:01' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                          | 'Receipt'     | '25.03.2023 12:00:01' | '24,74'     | '24,74'                | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Trade agent' | 'Trade agent' | 'Partner term with trade agent' | 'Sales report from trade agent 1 dated 25.03.2023 12:00:01' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                          | 'Receipt'     | '25.03.2023 12:00:01' | '500'       | '500'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Trade agent' | 'Trade agent' | 'Partner term with trade agent' | 'Sales report from trade agent 1 dated 25.03.2023 12:00:01' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                                          | 'Receipt'     | '25.03.2023 12:00:01' | '500'       | '500'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Trade agent' | 'Trade agent' | 'Partner term with trade agent' | 'Sales report from trade agent 1 dated 25.03.2023 12:00:01' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                                          | 'Receipt'     | '25.03.2023 12:00:01' | '500'       | '500'                  | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Trade agent' | 'Trade agent' | 'Partner term with trade agent' | 'Sales report from trade agent 1 dated 25.03.2023 12:00:01' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52070 check Sales report to consignor movements by the Register  "R5020 Partners balance" (IsPurchase)
	And I close all client application windows
	* Select Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I go to line in "List" table
			| 'Number'   |
			| '1'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales report to consignor 1 dated 10.03.2023 12:00:00' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''            | ''                         | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''            | ''                         | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'                    | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''            | ''                         | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''            | ''                         | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                                      | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name'  | 'Agreement'                | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                                      | 'Expense'     | '10.03.2023 12:00:00' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Consignor 1 (without VAT)' | 'Consignor 1' | 'Partner term Consignor 1' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                      | 'Expense'     | '10.03.2023 12:00:00' | '11,98'     | ''                     | ''                 | '11,98'              | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Consignor 1 (without VAT)' | 'Consignor 1' | 'Partner term Consignor 1' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                                      | 'Expense'     | '10.03.2023 12:00:00' | '240'       | ''                     | ''                 | '240'                | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Consignor 1 (without VAT)' | 'Consignor 1' | 'Partner term Consignor 1' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                                      | 'Expense'     | '10.03.2023 12:00:00' | '240'       | ''                     | ''                 | '240'                | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Consignor 1 (without VAT)' | 'Consignor 1' | 'Partner term Consignor 1' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                                      | 'Expense'     | '10.03.2023 12:00:00' | '240'       | ''                     | ''                 | '240'                | ''               | ''                  | 'Own company 2' | 'Business unit 2' | 'Consignor 1 (without VAT)' | 'Consignor 1' | 'Partner term Consignor 1' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |

Scenario: _52071 check Debit note movements by the Register  "R5020 Partners balance" (IsVendor, IsAdvance = True)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'   |
			| '1'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 1 dated 24.02.2023 11:03:25' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'         | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'     | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                       | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                          | ''           | ''          | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                       | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                   | 'Legal name' | 'Agreement' | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                       | 'Expense'     | '24.02.2023 11:03:25' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | ''          | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                       | 'Expense'     | '24.02.2023 11:03:25' | '1,25'      | ''                     | ''                 | ''                   | '1,25'           | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | ''          | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                       | 'Expense'     | '24.02.2023 11:03:25' | '25'        | ''                     | ''                 | ''                   | '25'             | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | ''          | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                       | 'Expense'     | '24.02.2023 11:03:25' | '25'        | ''                     | ''                 | ''                   | '25'             | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | ''          | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                       | 'Expense'     | '24.02.2023 11:03:25' | '25'        | ''                     | ''                 | ''                   | '25'             | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 1 (1 partner term)' | 'Vendor 1'   | ''          | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
Scenario: _52072 check Debit note movements by the Register  "R5020 Partners balance" (IsCustomer, IsAdvance = False)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number'   |
			| '2'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Debit note 2 dated 01.04.2023 14:10:35' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                       | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'         | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                       | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'     | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''                                       | ''         | ''                             | ''                     | ''                 |
			| ''                                       | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                             | ''           | ''                                                        | ''                                       | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                       | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                      | 'Legal name' | 'Agreement'                                               | 'Document'                               | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                       | 'Receipt'     | '01.04.2023 14:10:35' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Debit note 2 dated 01.04.2023 14:10:35' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                       | 'Receipt'     | '01.04.2023 14:10:35' | '1,92'      | '1,92'                 | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Debit note 2 dated 01.04.2023 14:10:35' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                       | 'Receipt'     | '01.04.2023 14:10:35' | '40'        | '40'                   | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Debit note 2 dated 01.04.2023 14:10:35' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                       | 'Receipt'     | '01.04.2023 14:10:35' | '40'        | '40'                   | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Debit note 2 dated 01.04.2023 14:10:35' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                       | 'Receipt'     | '01.04.2023 14:10:35' | '40'        | '40'                   | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | 'Debit note 2 dated 01.04.2023 14:10:35' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				
Scenario: _52073 check Credit note movements by the Register  "R5020 Partners balance" (IsCustomer, IsAdvance = True)
	And I close all client application windows
	* Select Credit note
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I go to line in "List" table
			| 'Number'   |
			| '2'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Credit note 2 dated 07.05.2023 12:00:01' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'      | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''                             | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | ''                 |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''                             | ''           | ''                                                        | ''         | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                        | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'                      | 'Legal name' | 'Agreement'                                               | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                        | 'Expense'     | '07.05.2023 12:00:01' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                        | 'Expense'     | '07.05.2023 12:00:01' | '2,4'       | ''                     | '2,4'              | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                        | 'Expense'     | '07.05.2023 12:00:01' | '50'        | ''                     | '50'               | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                        | 'Expense'     | '07.05.2023 12:00:01' | '50'        | ''                     | '50'               | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                        | 'Expense'     | '07.05.2023 12:00:01' | '50'        | ''                     | '50'               | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Customer 1 (3 partner terms)' | 'Client 1'   | 'Partner term with customer (by document + credit limit)' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
				

Scenario: _52074 check Credit note to consignor movements by the Register  "R5020 Partners balance" (IsVendor, IsAdvance = False)
	And I close all client application windows
	* Select Credit note
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I go to line in "List" table
			| 'Number'   |
			| '3'        |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Credit note 3 dated 27.03.2024 14:45:40' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''         | ''           | ''                                                       | ''                                        | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''         | ''           | ''                                                       | ''                                        | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'      | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''              | ''                | ''         | ''           | ''                                                       | ''                                        | ''         | ''                             | ''                     | ''                 |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'    | ''                | ''         | ''           | ''                                                       | ''                                        | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                        | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'       | 'Branch'          | 'Partner'  | 'Legal name' | 'Agreement'                                              | 'Document'                                | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                        | 'Receipt'     | '27.03.2024 14:45:40' | ''          | ''                     | ''                 | ''                   | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 5' | 'Vendor 5'   | 'Partner term with vendor (advance payment by document)' | 'Credit note 3 dated 27.03.2024 14:45:40' | 'EUR'      | 'Budgeting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                        | 'Receipt'     | '27.03.2024 14:45:40' | '1,53'      | ''                     | ''                 | '1,53'               | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 5' | 'Vendor 5'   | 'Partner term with vendor (advance payment by document)' | 'Credit note 3 dated 27.03.2024 14:45:40' | 'EUR'      | 'Reporting currency, EUR'      | 'TRY'                  | ''                 |
			| ''                                        | 'Receipt'     | '27.03.2024 14:45:40' | '50'        | ''                     | ''                 | '50'                 | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 5' | 'Vendor 5'   | 'Partner term with vendor (advance payment by document)' | 'Credit note 3 dated 27.03.2024 14:45:40' | 'TRY'      | 'Legal currency, TRY'          | 'TRY'                  | ''                 |
			| ''                                        | 'Receipt'     | '27.03.2024 14:45:40' | '50'        | ''                     | ''                 | '50'                 | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 5' | 'Vendor 5'   | 'Partner term with vendor (advance payment by document)' | 'Credit note 3 dated 27.03.2024 14:45:40' | 'TRY'      | 'Agreement currency, TRY'      | 'TRY'                  | ''                 |
			| ''                                        | 'Receipt'     | '27.03.2024 14:45:40' | '50'        | ''                     | ''                 | '50'                 | ''               | ''                  | 'Own company 2' | 'Business unit 1' | 'Vendor 5' | 'Vendor 5'   | 'Partner term with vendor (advance payment by document)' | 'Credit note 3 dated 27.03.2024 14:45:40' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |
		
				

Scenario: _52080 post customer advance closing and vendor advance closing
	And I close all client application windows
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
	

Scenario: _52081 SI - BR - DN (AR - by documents, BR - payment from customer, IsAdvance = True, with customer advance closing)
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
			| 'Company'                                   | ''                                                                                                                                      | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                   | 'Legal name'                                                                                                                            | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                  | 'Agreement'                                                                                                                             | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                             | ''                                                                                                                                      | ''         | ''                             | '520,00'  | '350,00'  | '170,00'  | '350,00'  | '350,00'  | ''        | '520,00'  | '350,00'  | '170,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 1 (3 partner terms)'              | 'Client 1'                                                                                                                              | ''         | ''                             | '520,00'  | '350,00'  | '170,00'  | '350,00'  | '350,00'  | ''        | '520,00'  | '350,00'  | '170,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 3 dated 30.03.2023 12:23:56' | 'Partner term with customer (by document + credit limit)'                                                                               | 'TRY'      | 'Legal currency, TRY'          | '480,00'  | ''        | '480,00'  | ''        | ''        | ''        | '480,00'  | ''        | '480,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 3 dated 01.04.2023 13:53:41'  | 'Partner term with customer (by document + credit limit)'                                                                               | 'TRY'      | 'Legal currency, TRY'          | ''        | '350,00'  | '130,00'  | '350,00'  | '350,00'  | ''        | ''        | '350,00'  | '130,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Debit note 2 dated 01.04.2023 14:10:35'    | 'Partner term with customer (by document + credit limit)'                                                                               | 'TRY'      | 'Legal currency, TRY'          | '40,00'   | ''        | '170,00'  | ''        | ''        | ''        | '40,00'   | ''        | '170,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                     | ''                                                                                                                                      | ''         | ''                             | '520,00'  | '350,00'  | '170,00'  | '350,00'  | '350,00'  | ''        | '520,00'  | '350,00'  | '170,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |	
		And I close all client application windows

Scenario: _52082 PI-BP-CP (AP - by documents, CP,BP-IsAdvance = True, with vendor advance closing )
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

Scenario: _52083 SI-BR-SR-BP (AP - by documents, BP - Return to customer, BR- Payment from customer, IsAdvance = True, IsAdvance = False, with customer advance closing)
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
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '750,00'  | '750,00'  | ''        | '400,00'  | '400,00'  | ''        | '750,00'  | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 3'                                 | 'Client 3'                                                                                                            | ''         | ''                             | '750,00'  | '750,00'  | ''        | '400,00'  | '400,00'  | ''        | '750,00'  | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 11 dated 02.12.2023 14:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 12 dated 02.12.2023 15:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '250,00'  | ''        | '250,00'  | '250,00'  | ''        | ''        | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 7 dated 04.12.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-300,00' | ''        | '-300,00' | ''        | ''        | ''        | '-300,00' | ''        | '-300,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 11 dated 04.12.2023 16:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '150,00'  | ''        | '-150,00' | '150,00'  | '150,00'  | ''        | '150,00'  | ''        | '-150,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 12 dated 05.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '150,00'  | ''        | ''        | ''        | ''        | ''        | '150,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '750,00'  | '750,00'  | ''        | '400,00'  | '400,00'  | ''        | '750,00'  | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows

Scenario: _52084 SI-BR (AP - by documents, BR - PaymentFromCustomerByPOS IsAdvance = True, IsAdvance = False, with customer advance closing)
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
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '750,00'  | '750,00'  | ''        | '250,00'  | '250,00'  | ''        | '750,00'  | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 3'                                 | 'Client 3'                                                                                                            | ''         | ''                             | '750,00'  | '750,00'  | ''        | '250,00'  | '250,00'  | ''        | '750,00'  | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 12 dated 02.12.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | '750,00'  | ''        | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 11 dated 02.12.2023 14:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | '500,00'  | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 12 dated 02.12.2023 15:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '250,00'  | ''        | '250,00'  | '250,00'  | ''        | ''        | '250,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '750,00'  | '750,00'  | ''        | '250,00'  | '250,00'  | ''        | '750,00'  | '750,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |	
		And I close all client application windows

Scenario: _52085 BR (AP - by documents, BR - ReturnFromVendor, IsAdvance = True, with vendor advance closing)
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
			| 'Company'                                      | ''                                                                                                                             | ''         | ''                             | 'Amount'   | ''         | ''          | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'       | ''         | ''        | 'VT'       | ''         | ''          | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                                                                                                   | ''         | ''                             | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt'  | 'Expense'  | 'Closing' | 'Receipt'  | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                                                                                                    | 'Currency' | 'Multi currency movement type' | ''         | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | ''         | ''         | ''          | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                                                                                             | ''         | ''                             | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 250,00' | '1 250,00' | ''        | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        |
			| 'Customer and vendor'                          | 'Client and vendor'                                                                                                            | ''         | ''                             | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 250,00' | '1 250,00' | ''        | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        |
			| 'Purchase invoice 5 dated 02.12.2023 12:30:00' | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | ''         | '9 685,00' | '-9 685,00' | ''        | ''        | ''        |
			| 'Bank payment 8 dated 02.12.2023 16:00:00'     | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''         | ''         | ''        | '4 000,00' | ''         | '-5 685,00' | ''        | ''        | ''        |
			| 'Cash payment 5 dated 03.12.2023 12:00:00'     | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | '1 000,00' | ''         | '-4 685,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 000,00' | '1 000,00' | ''        | '1 000,00' | ''         | '-4 685,00' | ''        | ''        | ''        |
			| 'Bank payment 9 dated 03.12.2023 12:30:00'     | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | '200,00'   | ''         | '-4 485,00' | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'   | '200,00'   | ''        | '200,00'   | ''         | '-4 485,00' | ''        | ''        | ''        |
			| 'Bank receipt 13 dated 05.12.2023 10:00:00'    | 'Partner term with vendor (advance payment by document)'                                                                       | 'TRY'      | 'Legal currency, TRY'          | ''         | '50,00'    | '-4 535,00' | ''        | ''        | ''        | ''        | ''        | ''        | '50,00'    | '50,00'    | ''        | ''         | '50,00'    | '-4 535,00' | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                                                                                             | ''         | ''                             | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        | ''        | ''        | ''        | '1 250,00' | '1 250,00' | ''        | '5 200,00' | '9 735,00' | '-4 535,00' | ''        | ''        | ''        |	
		And I close all client application windows		
	
Scenario: _52086 SI - SR - CP (Return to customer, IsAdvance = True, IsAdvance = False, with customer advance closing)
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
		And I input "01.08.2023" text in the field named "DateBegin"
		And I input "22.03.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 4" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                                                                                    | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '760,00'  | ''        | '760,00'  | '190,00'  | '190,00'  | ''        | '760,00'  | ''        | '760,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 4'                                 | 'Client 4'                                                                                                            | ''         | ''                             | '760,00'  | ''        | '760,00'  | '190,00'  | '190,00'  | ''        | '760,00'  | ''        | '760,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 13 dated 01.08.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '760,00'  | ''        | '760,00'  | ''        | ''        | ''        | '760,00'  | ''        | '760,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 8 dated 02.08.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-380,00' | ''        | '380,00'  | ''        | ''        | ''        | '-380,00' | ''        | '380,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 9 dated 10.08.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-190,00' | ''        | '190,00'  | ''        | ''        | ''        | '-190,00' | ''        | '190,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Cash payment 9 dated 22.03.2024 12:24:16'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '380,00'  | ''        | '570,00'  | ''        | ''        | ''        | '380,00'  | ''        | '570,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Cash payment 10 dated 22.03.2024 12:25:12'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '190,00'  | ''        | '760,00'  | '190,00'  | '190,00'  | ''        | '190,00'  | ''        | '760,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '760,00'  | ''        | '760,00'  | '190,00'  | '190,00'  | ''        | '760,00'  | ''        | '760,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |	
		And I close all client application windows

Scenario: _52087 PI - CP- PR - CR (Return from vendor, IsAdvance = True, IsAdvance = False, with vendor advance closing)
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
		And I input "05.12.2023" text in the field named "DateBegin"
		And I input "14.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Vendor 3 (1 partner term)" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                      | ''                                                                                                                                   | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                                                                                                         | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                                                                                                          | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                                                                                                   | ''         | ''                             | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '600,00'  | '600,00'  | ''        | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        |
			| 'Vendor 3 (1 partner term)'                    | 'Vendor 3'                                                                                                                           | ''         | ''                             | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '600,00'  | '600,00'  | ''        | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        |
			| 'Purchase invoice 7 dated 05.12.2023 12:00:00' | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '528,00'  | '-528,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '528,00'  | '-528,00' | ''        | ''        | ''        |
			| 'Cash payment 7 dated 06.12.2023 12:03:11'     | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | '400,00'  | ''        | '-128,00' | ''        | ''        | ''        | ''        | ''        | ''        | '400,00'  | '400,00'  | ''        | '400,00'  | ''        | '-128,00' | ''        | ''        | ''        |
			| 'Cash payment 8 dated 07.12.2023 12:00:00'     | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | '128,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '128,00'  | ''        | ''        | ''        | ''        | ''        |
			| 'Purchase return 3 dated 10.12.2023 12:00:00'  | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '-264,00' | '264,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '-264,00' | '264,00'  | ''        | ''        | ''        |
			| 'Cash receipt 6 dated 11.12.2023 12:00:00'     | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '200,00'  | '64,00'   | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '200,00'  | ''        | ''        | '200,00'  | '64,00'   | ''        | ''        | ''        |
			| 'Cash receipt 7 dated 14.12.2023 12:00:00'     | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '64,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '64,00'   | ''        | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                                                                                                   | ''         | ''                             | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '600,00'  | '600,00'  | ''        | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        |	
		And I close all client application windows

Scenario: _52088 CR - SI (PaymentFromCustomer, IsAdvance = True, with customer advance closing)
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
		And I input "03.12.2023" text in the field named "DateBegin"
		And I input "03.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 5" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                                                                                    | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '450,00'  | '100,00'  | '350,00'  | '100,00'  | '100,00'  | ''        | '450,00'  | '100,00'  | '350,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 5'                                 | 'Customer 5'                                                                                                          | ''         | ''                             | '450,00'  | '100,00'  | '350,00'  | '100,00'  | '100,00'  | ''        | '450,00'  | '100,00'  | '350,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Cash receipt 8 dated 03.12.2023 12:00:00'   | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '100,00'  | '-100,00' | ''        | '100,00'  | '-100,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 15 dated 03.12.2023 17:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '450,00'  | ''        | '350,00'  | '100,00'  | ''        | ''        | '450,00'  | '100,00'  | '350,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '450,00'  | '100,00'  | '350,00'  | '100,00'  | '100,00'  | ''        | '450,00'  | '100,00'  | '350,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |	
		And I close all client application windows

Scenario: _52089 SI-BR-SR-BP (PaymentFromCustomerByPOS, ReturnToCustomerByPOS, IsAdvance = True, IsAdvance = False, with customer advance closing)
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
		And I input "25.12.2023" text in the field named "DateBegin"
		And I input "30.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 6" string
		And I click "Generate" button
	* Check
		And "Result" spreadsheet document contains lines:
			| 'Company'                                    | ''                                                                                                                    | ''         | ''                             | 'Amount'    | ''         | ''          | 'CA'       | ''        | ''        | 'CT'        | ''         | ''          | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                          | ''         | ''                             | 'Receipt'   | 'Expense'  | 'Closing'   | 'Receipt'  | 'Expense' | 'Closing' | 'Receipt'   | 'Expense'  | 'Closing'   | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                           | 'Currency' | 'Multi currency movement type' | ''          | ''         | ''          | ''         | ''        | ''        | ''          | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                    | ''         | ''                             | '1 400,00'  | '1 400,00' | ''          | '1 200,00' | '400,00'  | '800,00'  | '1 000,00'  | '1 800,00' | '-800,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 6'                                 | 'Customer 6'                                                                                                          | ''         | ''                             | '1 400,00'  | '1 400,00' | ''          | '1 200,00' | '400,00'  | '800,00'  | '1 000,00'  | '1 800,00' | '-800,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 16 dated 25.12.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '1 000,00'  | ''         | '1 000,00'  | ''         | ''        | ''        | '1 000,00'  | ''         | '1 000,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 16 dated 26.12.2023 17:29:14'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''          | '1 000,00' | ''          | ''         | ''        | ''        | ''          | '1 000,00' | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 17 dated 26.12.2023 17:30:34' | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '400,00'    | ''         | '400,00'    | ''         | ''        | ''        | '400,00'    | ''         | '400,00'    | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 17 dated 26.12.2023 17:32:09'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | ''          | '400,00'   | ''          | '400,00'   | '400,00'  | ''        | ''          | '400,00'   | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 10 dated 28.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-1 000,00' | ''         | '-1 000,00' | ''         | ''        | ''        | '-1 000,00' | ''         | '-1 000,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 14 dated 28.12.2023 17:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '1 000,00'  | ''         | ''          | ''         | ''        | ''        | '1 000,00'  | ''         | ''          | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 11 dated 29.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '-400,00'   | ''         | '-400,00'   | ''         | ''        | ''        | '-400,00'   | ''         | '-400,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 15 dated 30.12.2023 17:48:36'  | 'Partner term with customer (by document + credit limit)'                                                             | 'TRY'      | 'Legal currency, TRY'          | '400,00'    | ''         | ''          | '800,00'   | ''        | '800,00'  | ''          | '400,00'   | '-800,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                    | ''         | ''                             | '1 400,00'  | '1 400,00' | ''          | '1 200,00' | '400,00'  | '800,00'  | '1 000,00'  | '1 800,00' | '-800,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
		And I close all client application windows

Scenario: _52098 check Report R5020 PartnersBalance in the different currencies
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
		And I input "05.12.2023" text in the field named "DateBegin"
		And I input "14.12.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Legal currency, TRY" string
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Vendor 3 (1 partner term)" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:
			| 'Company'                                      | ''                                                                                                                                   | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                                                                                                         | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                                                                                                          | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                                                                                                   | ''         | ''                             | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '600,00'  | '600,00'  | ''        | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        |
			| 'Vendor 3 (1 partner term)'                    | 'Vendor 3'                                                                                                                           | ''         | ''                             | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '600,00'  | '600,00'  | ''        | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        |
			| 'Purchase invoice 7 dated 05.12.2023 12:00:00' | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '528,00'  | '-528,00' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '528,00'  | '-528,00' | ''        | ''        | ''        |
			| 'Cash payment 7 dated 06.12.2023 12:03:11'     | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | '400,00'  | ''        | '-128,00' | ''        | ''        | ''        | ''        | ''        | ''        | '400,00'  | '400,00'  | ''        | '400,00'  | ''        | '-128,00' | ''        | ''        | ''        |
			| 'Cash payment 8 dated 07.12.2023 12:00:00'     | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | '128,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '128,00'  | ''        | ''        | ''        | ''        | ''        |
			| 'Purchase return 3 dated 10.12.2023 12:00:00'  | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '-264,00' | '264,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '-264,00' | '264,00'  | ''        | ''        | ''        |
			| 'Cash receipt 6 dated 11.12.2023 12:00:00'     | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '200,00'  | '64,00'   | ''        | ''        | ''        | ''        | ''        | ''        | '200,00'  | '200,00'  | ''        | ''        | '200,00'  | '64,00'   | ''        | ''        | ''        |
			| 'Cash receipt 7 dated 14.12.2023 12:00:00'     | '№31-92'                                                                                                                             | 'TRY'      | 'Legal currency, TRY'          | ''        | '64,00'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '64,00'   | ''        | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                                                                                                   | ''         | ''                             | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '600,00'  | '600,00'  | ''        | '528,00'  | '528,00'  | ''        | ''        | ''        | ''        |	
	* Reporting currency, EUR - Vendor
		And I select from the drop-down list named "SettingsComposerUserSettingsItem1Value" by "Reporting currency, EUR" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:	
			| 'Company'                                      | ''                                                                                                                                       | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                      | 'Legal name'                                                                                                                             | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                     | 'Agreement'                                                                                                                              | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                                | ''                                                                                                                                       | ''         | ''                             | '17,25'   | '17,25'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '19,60'   | '19,60'   | ''        | '17,25'   | '17,25'   | ''        | ''        | ''        | ''        |
			| 'Vendor 3 (1 partner term)'                    | 'Vendor 3'                                                                                                                               | ''         | ''                             | '17,25'   | '17,25'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '19,60'   | '19,60'   | ''        | '17,25'   | '17,25'   | ''        | ''        | ''        | ''        |
			| 'Purchase invoice 7 dated 05.12.2023 12:00:00' | '№31-92'                                                                                                                                 | 'EUR'      | 'Reporting currency, EUR'      | ''        | '17,25'   | '-17,25'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '17,25'   | '-17,25'  | ''        | ''        | ''        |
			| 'Cash payment 7 dated 06.12.2023 12:03:11'     | '№31-92'                                                                                                                                 | 'EUR'      | 'Reporting currency, EUR'      | '13,07'   | ''        | '-4,18'   | ''        | ''        | ''        | ''        | ''        | ''        | '13,07'   | '13,07'   | ''        | '13,07'   | ''        | '-4,18'   | ''        | ''        | ''        |
			| 'Cash payment 8 dated 07.12.2023 12:00:00'     | '№31-92'                                                                                                                                 | 'EUR'      | 'Reporting currency, EUR'      | '4,18'    | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '4,18'    | ''        | ''        | ''        | ''        | ''        |
			| 'Purchase return 3 dated 10.12.2023 12:00:00'  | '№31-92'                                                                                                                                 | 'EUR'      | 'Reporting currency, EUR'      | ''        | '-8,62'   | '8,62'    | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '-8,62'   | '8,62'    | ''        | ''        | ''        |
			| 'Cash receipt 6 dated 11.12.2023 12:00:00'     | '№31-92'                                                                                                                                 | 'EUR'      | 'Reporting currency, EUR'      | ''        | '6,53'    | '2,09'    | ''        | ''        | ''        | ''        | ''        | ''        | '6,53'    | '6,53'    | ''        | ''        | '6,53'    | '2,09'    | ''        | ''        | ''        |
			| 'Cash receipt 7 dated 14.12.2023 12:00:00'     | '№31-92'                                                                                                                                 | 'EUR'      | 'Reporting currency, EUR'      | ''        | '2,09'    | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '2,09'    | ''        | ''        | ''        | ''        |
			| 'Total'                                        | ''                                                                                                                                       | ''         | ''                             | '17,25'   | '17,25'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | '19,60'   | '19,60'   | ''        | '17,25'   | '17,25'   | ''        | ''        | ''        | ''        |		
	* Reporting currency, EUR - Customer
		And I remove checkbox named "SettingsComposerUserSettingsItem0Use"
		And I select from the drop-down list named "SettingsComposerUserSettingsItem2Value" by "Customer 6" string
		And I click "Generate" button
		And "Result" spreadsheet document contains lines:	
			| 'Company'                                    | ''                                                                                                                        | ''         | ''                             | 'Amount'  | ''        | ''        | 'CA'      | ''        | ''        | 'CT'      | ''        | ''        | 'VA'      | ''        | ''        | 'VT'      | ''        | ''        | 'Other'   | ''        | ''        |
			| 'Partner'                                    | 'Legal name'                                                                                                              | ''         | ''                             | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' | 'Receipt' | 'Expense' | 'Closing' |
			| 'Recorder'                                   | 'Agreement'                                                                                                               | 'Currency' | 'Multi currency movement type' | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Own company 2'                              | ''                                                                                                                        | ''         | ''                             | '44,30'   | '44,30'   | ''        | '37,98'   | '12,66'   | '25,32'   | '31,64'   | '56,96'   | '-25,32'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Customer 6'                                 | 'Customer 6'                                                                                                              | ''         | ''                             | '44,30'   | '44,30'   | ''        | '37,98'   | '12,66'   | '25,32'   | '31,64'   | '56,96'   | '-25,32'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 16 dated 25.12.2023 12:00:00' | 'Partner term with customer (by document + credit limit)'                                                                 | 'EUR'      | 'Reporting currency, EUR'      | '31,64'   | ''        | '31,64'   | ''        | ''        | ''        | '31,64'   | ''        | '31,64'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 16 dated 26.12.2023 17:29:14'  | 'Partner term with customer (by document + credit limit)'                                                                 | 'EUR'      | 'Reporting currency, EUR'      | ''        | '31,64'   | ''        | ''        | ''        | ''        | ''        | '31,64'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales invoice 17 dated 26.12.2023 17:30:34' | 'Partner term with customer (by document + credit limit)'                                                                 | 'EUR'      | 'Reporting currency, EUR'      | '12,66'   | ''        | '12,66'   | ''        | ''        | ''        | '12,66'   | ''        | '12,66'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank receipt 17 dated 26.12.2023 17:32:09'  | 'Partner term with customer (by document + credit limit)'                                                                 | 'EUR'      | 'Reporting currency, EUR'      | ''        | '12,66'   | ''        | '12,66'   | '12,66'   | ''        | ''        | '12,66'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 10 dated 28.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)'                                                                 | 'EUR'      | 'Reporting currency, EUR'      | '-31,64'  | ''        | '-31,64'  | ''        | ''        | ''        | '-31,64'  | ''        | '-31,64'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 14 dated 28.12.2023 17:00:00'  | 'Partner term with customer (by document + credit limit)'                                                                 | 'EUR'      | 'Reporting currency, EUR'      | '31,64'   | ''        | ''        | ''        | ''        | ''        | '31,64'   | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Sales return 11 dated 29.12.2023 12:00:00'  | 'Partner term with customer (by document + credit limit)'                                                                 | 'EUR'      | 'Reporting currency, EUR'      | '-12,66'  | ''        | '-12,66'  | ''        | ''        | ''        | '-12,66'  | ''        | '-12,66'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Bank payment 15 dated 30.12.2023 17:48:36'  | 'Partner term with customer (by document + credit limit)'                                                                 | 'EUR'      | 'Reporting currency, EUR'      | '12,66'   | ''        | ''        | '25,32'   | ''        | '25,32'   | ''        | '12,66'   | '-25,32'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
			| 'Total'                                      | ''                                                                                                                        | ''         | ''                             | '44,30'   | '44,30'   | ''        | '37,98'   | '12,66'   | '25,32'   | '31,64'   | '56,96'   | '-25,32'  | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        | ''        |
	And I close all client application windows
	
					
				
				
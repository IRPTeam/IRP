﻿#language: en
@tree
@Positive
@Accounting


Feature: accounting setings

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _099100 preparation
	When set True value to the constant
	When set True value to the constant Use accounting
	When set True value to the constant Use salary
	When set True value to the constant Use fixed assets
	* Load info (TestDB)
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
		When Create catalog EmployeePositions objects (test data base)
		When Create catalog EmployeeSchedule objects (test data base)
		When Create catalog AccrualAndDeductionTypes objects (test data base)
		When Create catalog Units objects (test data base)
		When Create catalog Items objects (test data base)
		When Create catalog CurrencyMovementSets objects (test data base)
		When Create catalog ObjectStatuses objects (test data base)
		When Create catalog PartnerSegments objects (test data base)
		When Create catalog LegalNameContracts objects (test data base)
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
		When Create document ExpenseAccruals objects (test data base)
		When Create document RevenueAccruals objects (test data base)
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
		When Create document MoneyTransfer objects (test data base)
		When Create document IncomingPaymentOrder objects (test data base)
		When Create document InternalSupplyRequest objects (test data base)
		When Create document InventoryTransfer objects (test data base)
		When Create document InventoryTransferOrder objects (test data base)
		When Create document OpeningEntry objects (test data base)
		When Create document OutgoingPaymentOrder objects (test data base)
		When Create document PhysicalCountByLocation objects (test data base)
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
		When Create document CommissioningOfFixedAsset objects (test data base)
		When Create document DepreciationCalculation objects (test data base)
		When Create document CalculationMovementCosts objects (test data base)
		When Create document EmployeeCashAdvance objects (test data base)
		When Create document CustomersAdvancesClosing objects (test data base)
		When Create document VendorsAdvancesClosing objects (test data base)
		When Create document ForeignCurrencyRevaluation objects (test data base)
		When Create document SI, SR, PI, PR objects (accounting, return service)
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
		When Create catalog PartnerItems objects (test data base)
		When Create catalog FixedAssetsLedgerTypes objects (test data base)
		When Create catalog DepreciationSchedules objects (test data base)
		When Create catalog FixedAssets objects (test data base)
		When Create document ForeignCurrencyRevaluation objects (test data base)
		When import data for debit credit note (accounting)
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
		When Create information register T9016S_AccountsEmployee records (test data base)
		When Create information register T9015S_AccountsFixedAsset records (test data base)
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
	* Post Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
	* Post Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
	* Post RSR
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
	* Posting EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
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
	And I close all client application windows
							
	
Scenario: _0991001 check preparation
	When check preparation

Scenario: _0991002 filling accounting operation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.AccountingOperations"
	And I click "Fill default descriptions" button
	And I click "Refresh" button
	And I click "List" button		
	And "List" table contains lines
		| 'Predefined data item name'                                                                                  | 'Description'                                                                                                    |
		| 'Document_BankPayment'                                                                                       | 'Bank payment'                                                                                                   |
		| 'Document_BankReceipt'                                                                                       | 'Bank receipt'                                                                                                   |
		| 'Document_PurchaseInvoice'                                                                                   | 'Purchase invoice'                                                                                               |
		| 'Document_RetailSalesReceipt'                                                                                | 'Retail sales receipt'                                                                                           |
		| 'Document_SalesInvoice'                                                                                      | 'Sales invoice'                                                                                                  |
		| 'Document_ForeignCurrencyRevaluation'                                                                        | 'Foreign currency revaluation'                                                                                   |
		| 'Document_CashPayment'                                                                                       | 'Cash payment'                                                                                                   |
		| 'Document_CashReceipt'                                                                                       | 'Cash receipt'                                                                                                   |
		| 'Document_CashExpense'                                                                                       | 'Cash expense'                                                                                                   |
		| 'Document_CashRevenue'                                                                                       | 'Cash revenue'                                                                                                   |
		| 'Document_DebitNote'                                                                                         | 'Debit note'                                                                                                     |
		| 'Document_CreditNote'                                                                                        | 'Credit note'                                                                                                    |
		| 'Document_MoneyTransfer'                                                                                     | 'Money transfer'                                                                                                 |
		| 'Document_CommissioningOfFixedAsset'                                                                         | 'Commissioning of fixed asset'                                                                                   |
		| 'Document_ModernizationOfFixedAsset'                                                                         | 'Modernization of fixed asset'                                                                                   |
		| 'Document_DecommissioningOfFixedAsset'                                                                       | 'Decommissioning of fixed asset'                                                                                 |
		| 'Document_FixedAssetTransfer'                                                                                | 'Fixed asset transfer'                                                                                           |
		| 'Document_DepreciationCalculation'                                                                           | 'Depreciation calculation'                                                                                       |
		| 'Document_Payroll'                                                                                           | 'Payroll'                                                                                                        |
		| 'Document_DebitCreditNote'                                                                                   | 'Debit/Credit note'                                                                                              |
		| 'Document_ExpenseAccruals'                                                                                   | 'Expense accruals'                                                                                               |
		| 'Document_RevenueAccruals'                                                                                   | 'Revenue accruals'                                                                                               |
		| 'Document_EmployeeCashAdvance'                                                                               | 'Employee cash advance'                                                                                          |
		| 'BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand'                    | 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)'                    |
		| 'BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                      | 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                      |
		| 'BankPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand'              | 'BankPayment DR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) CR (R3010B_CashOnHand)'              |
		| 'BankPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers'                                | 'BankPayment DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                                |
		| 'BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder'                         | 'BankPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Cash transfer)'                           |
		| 'BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange'                          | 'BankPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Currency exchange)'                       |
		| 'BankPayment_DR_R5015B_OtherPartnersTransactions_CR_R3010B_CashOnHand'                                       | 'BankPayment DR (R5015B_OtherPartnersTransactions) CR (R3010B_CashOnHand)'                                       |
		| 'BankPayment_DR_R5022T_Expenses_CR_R3010B_CashOnHand'                                                        | 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)'                                                        |
		| 'BankPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand'                                                   | 'BankPayment DR (R9510B_SalaryPayment) CR (R3010B_CashOnHand)'                                                   |
		| 'BankPayment_DR_R3027B_EmployeeCashAdvance_CR_R3010B_CashOnHand'                                             | 'BankPayment DR (R3027B_EmployeeCashAdvance) CR (R3010B_CashOnHand)'                                             |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions'              | 'BankReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)'              |
		| 'BankReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions'                                | 'BankReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                                |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions'                    | 'BankReceipt DR (R3010B_CashOnHand) CR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions)'                    |
		| 'BankReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions'                                      | 'BankReceipt DR (R1020B_AdvancesToVendors) CR (R1021B_VendorsTransactions)'                                      |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder'                         | 'BankReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Cash transfer)'                           |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CurrencyExchange'                          | 'BankReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Currency exchange)'                       |
		| 'BankReceipt_DR_R3021B_CashInTransit_CR_R5021T_Revenues'                                                     | 'BankReceipt DR (R3021B_CashInTransit) CR (R5021T_Revenues)'                                                     |
		| 'BankReceipt_DR_R5022T_Expenses_CR_R3021B_CashInTransit'                                                     | 'BankReceipt DR (R5022T_Expenses) CR (R3021B_CashInTransit)'                                                     |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R5015B_OtherPartnersTransactions'                                       | 'BankReceipt DR (R3010B_CashOnHand) CR (R5015B_OtherPartnersTransactions)'                                       |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R5021_Revenues'                                                         | 'BankReceipt DR (R3010B_CashOnHand) CR (R5021_Revenues)'                                                         |
		| 'PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions'                     | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)'                     |
		| 'PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                  | 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                  |
		| 'PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions'                                      | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                                      |
		| 'RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory'                                             | 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                             |
		| 'SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues'                                            | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)'                                            |
		| 'SalesInvoice_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming'                                       | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)'                                       |
		| 'SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory'                                                   | 'SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                                   |
		| 'SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions'                               | 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                               |
		| 'ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues'                              | 'ForeignCurrencyRevaluation DR (R2020B_AdvancesFromCustomers) CR (R5021T_Revenues)'                              |
		| 'ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers'                              | 'ForeignCurrencyRevaluation DR (R5022T_Expenses) CR (R2020B_AdvancesFromCustomers)'                              |
		| 'CashPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand'                    | 'CashPayment DR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions) CR (R3010B_CashOnHand)'                    |
		| 'CashPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                      | 'CashPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                      |
		| 'CashPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand'              | 'CashPayment DR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) CR (R3010B_CashOnHand)'              |
		| 'CashPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers'                                | 'CashPayment DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                                |
		| 'CashPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder'                         | 'CashPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Cash transfer)'                           |
		| 'CashPayment_DR_R5015B_OtherPartnersTransactions_CR_R3010B_CashOnHand'                                       | 'CashPayment DR (R5015B_OtherPartnersTransactions) CR (R3010B_CashOnHand)'                                       |
		| 'CashPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand'                                                   | 'CashPayment DR (R9510B_SalaryPayment) CR (R3010B_CashOnHand)'                                                   |
		| 'CashPayment_DR_R3027B_EmployeeCashAdvance_CR_R3010B_CashOnHand'                                             | 'CashPayment DR (R3027B_EmployeeCashAdvance) CR (R3010B_CashOnHand)'                                             |
		| 'CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions'              | 'CashReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)'              |
		| 'CashReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions'                                | 'CashReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                                |
		| 'CashReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions'                    | 'CashReceipt DR (R3010B_CashOnHand) CR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions)'                    |
		| 'CashReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions'                                      | 'CashReceipt DR (R1020B_AdvancesToVendors) CR (R1021B_VendorsTransactions)'                                      |
		| 'CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder'                         | 'CashReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Cash transfer)'                           |
		| 'CashReceipt_DR_R3010B_CashOnHand_CR_R5015B_OtherPartnersTransactions'                                       | 'CashReceipt DR (R3010B_CashOnHand) CR (R5015B_OtherPartnersTransactions)'                                       |
		| 'CashExpense_DR_R5022T_Expenses_CR_R3010B_CashOnHand'                                                        | 'CashExpense DR (R5022T_Expenses) CR (R3010B_CashOnHand)'                                                        |
		| 'CashRevenue_DR_R3010B_CashOnHand_CR_R5021_Revenues'                                                         | 'CashRevenue DR (R3010B_CashOnHand) CR (R5021_Revenues)'                                                         |
		| 'DebitNote_DR_R1021B_VendorsTransactions_CR_R5021_Revenues'                                                  | 'DebitNote DR (R1021B_VendorsTransactions) CR (R5021_Revenues)'                                                  |
		| 'DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                        | 'DebitNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                        |
		| 'DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues'                                                | 'DebitNote DR (R2021B_CustomersTransactions) CR (R5021_Revenues)'                                                |
		| 'DebitNote_DR_R5015B_OtherPartnersTransactions_CR_R5021_Revenues'                                            | 'DebitNote DR (R5015B_OtherPartnersTransactions) CR (R5021_Revenues)'                                            |
		| 'CreditNote_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions'                                              | 'CreditNote DR (R5022T_Expenses) CR (R2021B_CustomersTransactions)'                                              |
		| 'CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions'                                 | 'CreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                                 |
		| 'CreditNote_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions'                                                | 'CreditNote DR (R5022T_Expenses) CR (R1021B_VendorsTransactions)'                                                |
		| 'CreditNote_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions'                                          | 'CreditNote DR (R5022T_Expenses) CR (R5015B_OtherPartnersTransactions)'                                          |
		| 'CreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                       | 'CreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                       |
		| 'MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand'                                                    | 'MoneyTransfer DR (R3010B_CashOnHand) CR (R3010B_CashOnHand)'                                                    |
		| 'MoneyTransfer_DR_R3021B_CashInTransit_CR_R3010B_CashOnHand'                                                 | 'MoneyTransfer DR (R3021B_CashInTransit) CR (R3010B_CashOnHand)'                                                 |
		| 'MoneyTransfer_DR_R3010B_CashOnHand_CR_R3021B_CashInTransit'                                                 | 'MoneyTransfer DR (R3010B_CashOnHand) CR (R3021B_CashInTransit)'                                                 |
		| 'MoneyTransfer_DR_R3021B_CashInTransit_CR_R5021T_Revenues'                                                   | 'MoneyTransfer DR (R3021B_CashInTransit) CR (R5021T_Revenues)'                                                   |
		| 'MoneyTransfer_DR_R5022T_Expenses_CR_R3021B_CashInTransit'                                                   | 'MoneyTransfer DR (R5022T_Expenses) CR (R3021B_CashInTransit)'                                                   |
		| 'CommissioningOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory'                         | 'CommissioningOfFixedAsset DR (R8510B_BookValueOfFixedAsset) CR (R4050B_StockInventory)'                         |
		| 'ModernizationOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory'                         | 'ModernizationOfFixedAsset DR (R8510B_BookValueOfFixedAsset) CR (R4050B_StockInventory)'                         |
		| 'ModernizationOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset'                         | 'ModernizationOfFixedAsset DR (R4050B_StockInventory) CR (R8510B_BookValueOfFixedAsset)'                         |
		| 'DecommissioningOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset'                       | 'DecommissioningOfFixedAsset DR (R4050B_StockInventory) CR (R8510B_BookValueOfFixedAsset)'                       |
		| 'FixedAssetTransfer_DR_R8510B_BookValueOfFixedAsset_CR_R8510B_BookValueOfFixedAsset'                         | 'FixedAssetTransfer DR (R8510B_BookValueOfFixedAsset) CR (R8510B_BookValueOfFixedAsset)'                         |
		| 'DepreciationCalculation_DR_R5022T_Expenses_CR_DepreciationFixedAsset'                                       | 'DepreciationCalculation DR (R5022T_Expenses) CR (DepreciationFixedAsset)'                                       |
		| 'Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Accrual'                                                 | 'Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Accrual)'                                               |
		| 'Payroll_DR_R9510B_SalaryPayment_CR_R5015B_OtherPartnersTransactions_Taxes'                                  | 'Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)'                                |
		| 'Payroll_DR_R9510B_SalaryPayment_CR_R5021T_Revenues_Deduction_IsRevenue'                                     | 'Payroll DR (R9510B_SalaryPayment) CR (R5021T_Revenues) (Deduction Is Revenue)'                                  |
		| 'Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Deduction_IsNotRevenue'                                  | 'Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Deduction Is Not Revenue)'                              |
		| 'Payroll_DR_R9510B_SalaryPayment_CR_R3027B_EmployeeCashAdvance'                                              | 'Payroll DR (R9510B_SalaryPayment) CR (R3027B_EmployeeCashAdvance)'                                              |
		| 'Payroll_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions_Taxes'                                       | 'Payroll DR (R5022T_Expenses) CR (R5015B_OtherPartnersTransactions) (Taxes)'                                     |
		| 'DebitCreditNote_R5020B_PartnersBalance'                                                                     | 'DebitCreditNote (R5020B_PartnersBalance)'                                                                       |
		| 'DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset'                     | 'DebitCreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions) (Offset)'                   |
		| 'DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset'                           | 'DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)'                         |
		| 'ExpenseAccruals_DR_R5022T_Expenses_CR_R6070T_OtherPeriodsExpenses'                                          | 'ExpenseAccruals DR (R5022T_Expenses) CR (R6070T_OtherPeriodsExpenses)'                                          |
		| 'ExpenseAccruals_DR_R6070T_OtherPeriodsExpenses_CR_R5022T_Expenses'                                          | 'ExpenseAccruals DR (R6070T_OtherPeriodsExpenses) CR (R5022T_Expenses)'                                          |
		| 'RevenueAccruals_DR_R6080T_OtherPeriodsRevenues_CR_R5021T_Revenues'                                          | 'RevenueAccruals DR (R6080T_OtherPeriodsRevenues) CR (R5021T_Revenues)'                                          |
		| 'RevenueAccruals_DR_R5021T_Revenues_CR_R6080T_OtherPeriodsRevenues'                                          | 'RevenueAccruals DR (R5021T_Revenues) CR (R6080T_OtherPeriodsRevenues)'                                          |
		| 'EmployeeCashAdvance_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance'                                       | 'EmployeeCashAdvance DR (R5022T_Expenses) CR (R3027B_EmployeeCashAdvance)'                                       |
		| 'EmployeeCashAdvance_DR_R1021B_VendorsTransactions_CR_R3027B_EmployeeCashAdvance'                            | 'EmployeeCashAdvance DR (R1021B_VendorsTransactions) CR (R3027B_EmployeeCashAdvance)'                            |
		
	And I close all client application windows
		
		
Scenario: _0991003 create ledger type
	And I close all client application windows
	* Open accounting operations catalog
		Given I open hyperlink "e1cib/list/Catalog.LedgerTypes"	
	* Create new element			
		And I click the button named "FormCreate"
		And I input "Manager analitics" text in "ENG" field
		And I click Select button of "Currency movement type" field
		Then "Multi currency movement types" window is opened
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'         | 'Source'          | 'Type'  |
			| 'TRY'      | 'No'                   | 'Legal currency, TRY' | 'Currency rate 1' | 'Legal' |
		And I select current line in "List" table
		And I click Choice button of the field named "LedgerTypeVariant"
		And I click "Create" button
		And I input "Manager analitics" text in "ENG" field
		And I click "Save" button
		And I delete "$$UniqueIDManagerLT$$" variable
		And I save the value of the field named "UniqueID" as "$$UniqueIDManagerLT$$"
		And I click "Save and close" button
		And I wait "Ledger type variants (create) *" window closing in 20 seconds
		Then "Ledger type variants" window is opened
		And I click "Select" button
		* Filling dates
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                                | 'Use' |
				| 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                              | 'Use' |
				| 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                                      | 'Use' |
				| 'BankReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                    | 'Use' |
				| 'BankReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                               | 'Use' |
				| 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                                      | 'Use' |
				| 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                              | 'Use' |
				| 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                       | 'Use' |
				| 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                        | 'Use' |
				| 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                             | 'Use' |
				| 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                 | 'Use' |
				| 'SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                     | 'Use' |
				| 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                      | 'Use' |
				| 'ForeignCurrencyRevaluation DR (R2020B_AdvancesFromCustomers) CR (R5021T_Revenues)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                      | 'Use' |
				| 'ForeignCurrencyRevaluation DR (R5022T_Expenses) CR (R2020B_AdvancesFromCustomers)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I click "Save" button
		* Check
			And "OperationsTree" table contains lines
				| 'Presentation'                                                                                                   | 'Use' | 'Period'     |
				| 'Bank payment'                                                                                                   | 'No'  | ''           |
				| 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)'                    | 'Yes' | '01.01.2021' |
				| 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                      | 'Yes' | '01.01.2021' |
				| 'Bank receipt'                                                                                                   | 'No'  | ''           |
				| 'BankReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)'              | 'Yes' | '01.01.2021' |
				| 'BankReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                                | 'Yes' | '01.01.2021' |
				| 'Purchase invoice'                                                                                               | 'No'  | ''           |
				| 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)'                     | 'Yes' | '01.01.2021' |
				| 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                  | 'Yes' | '01.01.2021' |
				| 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                                      | 'Yes' | '01.01.2021' |
				| 'Retail sales receipt'                                                                                           | 'No'  | ''           |
				| 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                             | 'Yes' | '01.01.2021' |
				| 'Sales invoice'                                                                                                  | 'No'  | ''           |
				| 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)'                                            | 'Yes' | '01.01.2021' |
				| 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)'                                       | 'Yes' | '01.01.2021' |
				| 'SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                                   | 'Yes' | '01.01.2021' |
				| 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                               | 'Yes' | '01.01.2021' |
				| 'Foreign currency revaluation'                                                                                   | 'No'  | ''           |
				| 'ForeignCurrencyRevaluation DR (R2020B_AdvancesFromCustomers) CR (R5021T_Revenues)'                              | 'Yes' | '01.01.2021' |
				| 'ForeignCurrencyRevaluation DR (R5022T_Expenses) CR (R2020B_AdvancesFromCustomers)'                              | 'Yes' | '01.01.2021' |		
			And I click "Save and close" button
		* Check creation
			And "List" table contains lines
				| 'Description'       | 'Currency movement type' | 'Currency' | 'Type'  | 'Ledger type variant' |
				| 'Manager analitics' | 'Legal currency, TRY'    | 'TRY'      | 'Legal' | 'Manager analitics'   |
			And I close all client application windows
			

Scenario: _0991004 create ledger type variant with account charts code mask
	And I close all client application windows
	* Open Ledger type variants
		Given I open hyperlink "e1cib/list/Catalog.LedgerTypeVariants"
	* Create Ledger type variant
		And I click the button named "FormCreate"
		And I input "LTV with account charts code mask" text in "ENG" field
		And I input "@@@.@@.@@@" text in "Account charts code mask" field
		And I click "Save" button	
		Then the field named "UniqueID" is filled
		And I delete "$$UniqueID$$" variable
		And I save the value of the field named "UniqueID" as "$$UniqueID$$"
		And I click "Save and close" button
		And I wait "Ledger type variants (create) *" window closing in 20 seconds	
	* Check
		And "List" table contains lines
			| 'Description'                       |
			| 'LTV with account charts code mask' |
	And I close all client application windows

Scenario: _0991005 change ledger type variant for ledger type
	And I close all client application windows
	* Open ledger type list
		Given I open hyperlink "e1cib/list/Catalog.LedgerTypes"
		And I go to line in "List" table
			| 'Description'       |
			| 'Manager analitics' |
		ANd I select current line in "List" table
	* Change ledger type variant 
		And I select from "Ledger type variant" drop-down list by "LTV" string
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And I click "Save and close" button
		And I wait "Manager analitics (Ledger type) *" window closing in 20 seconds

Scenario: _0991006 create AccountingExtraDimensionTypes - test element 
	And I close all client application windows
	* Open AccountingExtraDimensionTypes
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AccountingExtraDimensionTypes"		
	* Create AccountingExtraDimensionType
		And I click the button named "FormCreate"
		And I input "Test element" text in "ENG" field
		And I click Select button of "Value type" field
		Then "Edit data type" window is opened
		And I go to line in "" table
			| ''              |
			| 'Business unit' |
		And I click "OK" button
		And I click "Save" button
	* Check filling
		Then the form attribute named "Description_en" became equal to "Test element"
		Then the field named "UniqueID" is filled
	* Change UniqueID
		And I click "Edit unique ID" button
		And I input "1111" text in "Unique ID" field
		And I click "Save" button
		Then the form attribute named "UniqueID" became equal to "1111"
		And I click "Save and close" button	
	* Check
		And "List" table contains lines
			| 'Description'  |
			| 'Test element' |
	And I close all client application windows	
				

Scenario: _0991008 create Account charts (Basic) - group and assets account
	And I close all client application windows
	* Open 	Account charts
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I change the radio button named "LedgerTypeVariantFilter" value to "LTV with account charts code mask"			
	* Create Group
		And I click the button named "FormCreate"
		And I input "405" text in the field named "Code"
		And I input "10" text in the field named "Order"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And I input "Group Assets acccount" text in "ENG" field
		And I set checkbox "Not used for records"
		And I set checkbox named "Quantity"
		And I click "Save" button
		Then the form attribute named "SearchCode" became equal to "405"
		Then the form attribute named "Order" became equal to "10"				
		And I click "Save and close" button
		* Check creation
			And "List" table contains lines
				| 'Code'                   | 'Order' | 'Description'           | 'Type' | 'Ext. Dim 2' | 'Q.'  | 'Ext. Dim 3' | 'C.' | 'Ledger type variant'               | 'Ext. Dim 1' | 'Off-balance' |
				| '405'                    | '10'    | 'Group Assets acccount' | 'AP'   | ''           | 'Yes' | ''           | 'No' | 'LTV with account charts code mask' | ''           | 'No'          |
	* Create first account (assets)	
		And I click the button named "FormCreate"
		And I input "40501" text in the field named "Code"
		And the editing text of form attribute named "Code" became equal to "405.01.   "
		And I click "Save" button
		Then the form attribute named "Order" became equal to "40501"				
		And the editing text of form attribute named "SearchCode" became equal to "40501"		
		And I input "Assets acccount" text in "ENG" field
		And I select "Assets" exact value from the drop-down list named "Type"
		And I select from "Ledger type variant" drop-down list by "ltv" string	
		And I set checkbox named "Quantity"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I select current line in "ExtDimensionTypes" table
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'   | 'Value type'    |
			| 'Item'          | 'Item'          |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		Then "Accounting extra dimensions" window is opened
		And I go to line in "List" table
			| 'Description'   | 'Value type'    |
			| 'Item key'      | 'Item key'      |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'   |  'Value type'    |
			| 'Store'         |  'Store'         |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And I click "Save and close" button
		And I wait "Account chart (Basic) (create) *" window closing in 20 seconds	
		* Check 
			And "List" table contains lines
				| 'Code'                   | 'Order' | 'Description'           | 'Type' | 'Ext. Dim 2' | 'Q.'  | 'Ext. Dim 3' | 'C.' | 'Ledger type variant'               | 'Ext. Dim 1' | 'Off-balance' |
				| '405'                    | '10'    | 'Group Assets acccount' | 'AP'   | ''           | 'Yes' | ''           | 'No' | 'LTV with account charts code mask' | ''           | 'No'          |
				| '405.01'                 | '40501' | 'Assets acccount'       | 'A'    | 'Item key'   | 'Yes' | 'Store'      | 'No' | 'LTV with account charts code mask' | 'Item'       | 'No'          |					

Scenario: _0991009 create Account charts (Basic) - liabilities account without group
	And I close all client application windows
	* Open 	Account charts
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I change the radio button named "LedgerTypeVariantFilter" value to "LTV with account charts code mask"
	* Create liabilities account
		And I click "Create" button
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"			
		And I input "1021311" text in the field named "Code"
		And I click "Save" button
		And the editing text of form attribute named "Code" became equal to "102.13.11 "
		Then the form attribute named "SearchCode" became equal to "1021311"
		Then the form attribute named "Order" became equal to "1021311"						
		And I input "Liabilities account" text in "ENG" field
		And I select "Liabilities" exact value from the drop-down list named "Type"
		And I set checkbox named "Currency"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Partner'        |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Partner term'    |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Legal name contract'     |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check 
		And "List" table contains lines
			| 'Code'                   | 'Order'   | 'Description'         | 'Type' | 'Ext. Dim 2'   | 'Q.' | 'Ext. Dim 3'          | 'C.'  | 'Ledger type variant'               | 'Ext. Dim 1' | 'Off-balance' |
			| '102.13.11'              | '1021311' | 'Liabilities account' | 'P'    | 'Partner term' | 'No' | 'Legal name contract' | 'Yes' | 'LTV with account charts code mask' | 'Partner'    | 'No'          |
		
Scenario: _0991010 create Account charts (Basic) - Assets/Liabilities account, Off-balance
	And I close all client application windows
	* Open 	Account charts
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I change the radio button named "LedgerTypeVariantFilter" value to "LTV with account charts code mask"
	* Create liabilities account
		And I click "Create" button
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"			
		And I input "7021311" text in the field named "Code"
		And I click "Save" button
		And the editing text of form attribute named "Code" became equal to "702.13.11 "
		Then the form attribute named "SearchCode" became equal to "7021311"
		Then the form attribute named "Order" became equal to "7021311"						
		And I input "Assets/Liabilities account (Off-balance)" text in "ENG" field
		And I select "Assets/Liabilities" exact value from the drop-down list named "Type"
		And I set checkbox named "OffBalance"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I select "revenue" from "Extra dimension type" drop-down list by string in "ExtDimensionTypes" table
		And I set "Turnovers only" checkbox in "ExtDimensionTypes" table
		And I finish line editing in "ExtDimensionTypes" table	
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I select "store" from "Extra dimension type" drop-down list by string in "ExtDimensionTypes" table
		And I finish line editing in "ExtDimensionTypes" table
		And I click "Save" button
		And "ExtDimensionTypes" table became equal
			| 'Extra dimension type'     | 'Turnovers only' | 'Quantity' | 'Currency' | 'Amount' |
			| 'Expense and revenue type' | 'Yes'            | 'No'       | 'No'       | 'Yes'    |
			| 'Store'                    | 'No'             | 'No'       | 'No'       | 'Yes'    |				
		And I click "Save and close" button
	* Check 
		And "List" table contains lines
			| 'Code'                   | 'Order'   | 'Description'                              | 'Type' | 'Ext. Dim 2'   | 'Q.'  | 'Ext. Dim 3'          | 'C.'  | 'Ledger type variant'               | 'Ext. Dim 1'                       | 'Off-balance' |
			| '702.13.11'              | '7021311' | 'Assets/Liabilities account (Off-balance)' | 'AP'   | 'Store'        | 'No'  | ''                    | 'No'  | 'LTV with account charts code mask' | 'Expense and revenue type (turn.)' | 'Yes'         |
		And I close all client application windows
		
Scenario: _0991013 check account charts code mask
	And I close all client application windows
	* Open 	Account charts
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I change the radio button named "LedgerTypeVariantFilter" value to "LTV with account charts code mask"
	* Create liabilities account
		And I click "Create" button 
	* Check charts code mask (@@@.@@.@@@)
		And I input "898.99.008" text in the field named "Code"
		And the editing text of form attribute named "Code" became equal to "898.99.008"
		And I input "89899008" text in the field named "Code"		
		And the editing text of form attribute named "Code" became equal to "898.99.008"
		And I input "898990089" text in the field named "Code"
		And the editing text of form attribute named "Code" became equal to "898.99.008"
		And I input "898*90089" text in the field named "Code"
		And the editing text of form attribute named "Code" became equal to "898.  .   "
		And I input "898 90089" text in the field named "Code"		
		And the editing text of form attribute named "Code" became equal to "898.9 .008"
	And I close all client application windows
	
Scenario: _0991015 check load charts of accounts (correct data)
	And I close all client application windows
	* Open form load charts of accounts 
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I click "Load charts of accounts" button
	* Select Descraption language
		And I move to "Description" tab
		And I go to line in "Languages" table
			| 'Value' |
			| 'EN'    |	
		And I set "Check" checkbox in "Languages" table
		And I finish line editing in "Languages" table
		And I move to "Description" tab
	* Filling load data table
		* Group
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C1" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "$$UniqueID$$"
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C2" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C4" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "908990"
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C5" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "Test group"
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C6" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C7" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "P"
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C8" cell
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C10" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "130"
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C13" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R2C14" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
		* Assets account
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C1" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "$$UniqueID$$"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C4" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "90878699"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C5" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "Test assets account"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C7" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "A"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C8" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C10" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "127"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C13" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C14" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C15" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "128"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C16" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C17" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C20" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "127"
			And in "SpreadsheetDocument" spreadsheet document I move to "R3C21" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
		* Liabilities account with owner
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C1" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "$$UniqueID$$"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C3" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "908990"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C4" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "10878699"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C5" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "Test liabilities account"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C7" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "P"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C8" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C10" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "127"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C13" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C14" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C15" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "128"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C16" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C17" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C20" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "127"
			And in "SpreadsheetDocument" spreadsheet document I move to "R4C21" cell
			And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
			And in "SpreadsheetDocument" spreadsheet document I input text "True"
			And I click "Load" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			When in opened panel I select "Account charts (Basic)"
			Then "Account charts (Basic)" window is opened
			And I click "Refresh" button
	* Check
		And "List" table contains lines
			| 'Code'                   | 'Order'    | 'Description'         | 'Type' | 'Ext. Dim 2'       | 'Q.'  | 'Ext. Dim 3'          | 'C.'  | 'Ledger type variant'               | 'Ext. Dim 1' | 'Off-balance' |
			| '90878699'               | '90878699' | 'Test assets account' | 'A'    | 'Item key (turn.)' | 'Yes' | 'Fixed asset (turn.)' | 'No'  | 'LTV with account charts code mask' | 'Item'       | 'No'          |
			| '908990'                 | '908990'   | 'Test group'          | 'P'    | ''                 | 'No'  | ''                    | 'Yes' | 'LTV with account charts code mask' | 'Partner'    | 'No'          |
		* Liabilities account
			And I go to line in "List" table
				| 'C.' | 'Code'      | 'Description'              | 'Ext. Dim 1' | 'Ext. Dim 2'       | 'Ext. Dim 3'          | 'Ledger type variant'               | 'Off-balance' | 'Order'     | 'Q.'  | 'Type' |
				| 'No' | '10878699'  | 'Test liabilities account' | 'Item'       | 'Item key (turn.)' | 'Fixed asset (turn.)' | 'LTV with account charts code mask' | 'No'          | '10878699'  | 'Yes' | 'P'    |
			And I select current line in "List" table
			And the editing text of form attribute named "Code" became equal to "108.78.699"
			Then the form attribute named "Currency" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Test liabilities account"
			And "ExtDimensionTypes" table became equal
				| 'Extra dimension type' | 'Currency' | 'Turnovers only' | 'Quantity' | 'Amount' |
				| 'Item'                 | 'Yes'      | 'No'             | 'No'       | 'Yes'    |
				| 'Item key'             | 'No'       | 'Yes'            | 'Yes'      | 'No'     |
				| 'Fixed asset'          | 'No'       | 'Yes'            | 'No'       | 'No'     |
			
			Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
			Then the form attribute named "NotUsedForRecords" became equal to "No"
			Then the form attribute named "OffBalance" became equal to "No"
			Then the form attribute named "Order" became equal to "10878699"
			Then the form attribute named "Parent" became equal to "908990"
			Then the form attribute named "Quantity" became equal to "Yes"
			Then the form attribute named "SearchCode" became equal to "10878699"
			Then the form attribute named "Type" became equal to "Liabilities"
			And I close current window
		* Assets account
			And I go to line in "List" table
				| 'C.' | 'Code'     | 'Description'         | 'Ext. Dim 1' | 'Ext. Dim 2'       | 'Ext. Dim 3'          | 'Ledger type variant'               | 'Off-balance' | 'Order'    | 'Q.'  | 'Type' |
				| 'No' | '90878699' | 'Test assets account' | 'Item'       | 'Item key (turn.)' | 'Fixed asset (turn.)' | 'LTV with account charts code mask' | 'No'          | '90878699' | 'Yes' | 'A'    |
			And I select current line in "List" table
			And the editing text of form attribute named "Code" became equal to "908.78.699"
			Then the form attribute named "Currency" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Test assets account"
			And "ExtDimensionTypes" table became equal
				| 'Extra dimension type' | 'Currency' | 'Turnovers only' | 'Quantity' | 'Amount' |
				| 'Item'                 | 'Yes'      | 'No'             | 'No'       | 'Yes'    |
				| 'Item key'             | 'No'       | 'Yes'            | 'Yes'      | 'No'     |
				| 'Fixed asset'          | 'No'       | 'Yes'            | 'No'       | 'No'     |
			
			Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
			Then the form attribute named "NotUsedForRecords" became equal to "No"
			Then the form attribute named "OffBalance" became equal to "No"
			Then the form attribute named "Order" became equal to "90878699"
			Then the form attribute named "Parent" became equal to ""
			Then the form attribute named "Quantity" became equal to "Yes"
			Then the form attribute named "SearchCode" became equal to "90878699"
			Then the form attribute named "Type" became equal to "Assets"
			And I close current window
		* Group
			And I go to line in "List" table
				| 'C.'  | 'Code'   | 'Description' | 'Ext. Dim 1' | 'Ledger type variant'               | 'Off-balance' | 'Order'  | 'Q.' | 'Type' |
				| 'Yes' | '908990' | 'Test group'  | 'Partner'    | 'LTV with account charts code mask' | 'No'          | '908990' | 'No' | 'P'    |
			And I select current line in "List" table
			And the editing text of form attribute named "Code" became equal to "908.99.0  "
			Then the form attribute named "Currency" became equal to "Yes"
			Then the form attribute named "Description_en" became equal to "Test group"
			And "ExtDimensionTypes" table became equal
				| 'Extra dimension type' | 'Currency' | 'Turnovers only' | 'Quantity' | 'Amount' |
				| 'Partner'              | 'Yes'      | 'No'             | 'No'       | 'Yes'    |
			Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
			Then the form attribute named "NotUsedForRecords" became equal to "Yes"
			Then the form attribute named "OffBalance" became equal to "No"
			Then the form attribute named "Order" became equal to "908990"
			Then the form attribute named "Parent" became equal to ""
			Then the form attribute named "Quantity" became equal to "No"
			Then the form attribute named "SearchCode" became equal to "908990"
			Then the form attribute named "Type" became equal to "Liabilities"
	
				
	
Scenario: _0991016 check load charts of accounts (incorrect data)	
	And I close all client application windows					
	* Open form load charts of accounts 
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I click "Load charts of accounts" button
	* Select Descraption language
		And I move to "Description" tab
		And I go to line in "Languages" table
			| 'Value' |
			| 'EN'    |	
		And I set "Check" checkbox in "Languages" table
		And I finish line editing in "Languages" table
		And I move to "Description" tab
	* Try load account without ledger type variant
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C1" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text " "
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C4" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "50878997"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C5" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "Test account (manager analytics)"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C7" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "A"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C8" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C10" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "127"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C13" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C14" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C15" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "128"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C16" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C17" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C20" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "127"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C21" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
	* Try load
		And I click "Load" button
		When in opened panel I select "Account charts (Basic)"
		And "List" table does not contain lines	
			| 'Description'                      |
			| 'Test account (manager analytics)' |
		When in opened panel I select "Load chart of accounts"
	* Fill ledger type, delete account number
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C1" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "$$UniqueIDManagerLT$$"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C4" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text " "
	* Try load
		And I click "Load" button
		When in opened panel I select "Account charts (Basic)"
		And "List" table does not contain lines	
			| 'Description'                      |
			| 'Test account (manager analytics)' |
		When in opened panel I select "Load chart of accounts"
	* Fill account, delete description
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C4" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "50878997"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C5" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text " "
	* Try load
		And I click "Load" button
		When in opened panel I select "Account charts (Basic)"
		And "List" table does not contain lines	
			| 'Description'                      |
			| 'Test account (manager analytics)' |
		When in opened panel I select "Load chart of accounts"
	* Fill description and load sccount
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C5" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "Test account (manager analytics)"	
		And I click "Load" button					
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check
		When in opened panel I select "Account charts (Basic)"	
		And I click "Refresh" button
		And "List" table contains lines	
			| 'Description'                      |
			| 'Test account (manager analytics)' |
		And I close all client application windows

Scenario: _0991017 retrying to upload the same account
	And I close all client application windows					
	* Open form load charts of accounts 
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I click "Load charts of accounts" button
	* Select Description language
		And I move to "Description" tab
		And I go to line in "Languages" table
			| 'Value' |
			| 'EN'    |	
		And I set "Check" checkbox in "Languages" table
		And I finish line editing in "Languages" table
		And I move to "Description" tab
	* Try load account without ledger type variant
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C1" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "$$UniqueIDManagerLT$$"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C4" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "50878997"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C5" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "Test account (manager analytics)"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C7" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "A"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C8" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C10" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "127"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C13" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C14" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C15" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "128"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C16" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C17" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C20" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "127"
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C21" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "True"
		And I click "Load" button					
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check
		When in opened panel I select "Account charts (Basic)"	
		And I click "Refresh" button
		And I change the radio button named "LedgerTypeVariantFilter" value to "Manager analitics"
		Then the number of "List" table lines is "меньше или равно" "2"		
		And "List" table contains lines	
			| 'Description'                      |
			| 'Test account (manager analytics)' |
	* Load description for RU Language
		When in opened panel I select "Load chart of accounts"
		* Select Description language
			And I move to "Description" tab
			And I go to line in "Languages" table
				| 'Value' |
				| 'EN'    |	
			And I remove "Check" checkbox in "Languages" table
			And I go to line in "Languages" table
				| 'Value' |
				| 'RU'    |	
			And I set "Check" checkbox in "Languages" table
			And I finish line editing in "Languages" table
			And I move to "Description" tab
		And in "SpreadsheetDocument" spreadsheet document I move to "R2C5" cell
		And in "SpreadsheetDocument" spreadsheet document I double-click the current cell
		And in "SpreadsheetDocument" spreadsheet document I input text "Тестовый счет (manager analytics)"		
		And I click "Load" button					
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check
		When in opened panel I select "Account charts (Basic)"	
		And I go to line in "List" table
			| 'Description'                      |
			| 'Test account (manager analytics)' |
		And I select current line in "List" table
		And I click Open button of "ENG" field
		Then the form attribute named "Description_ru" became equal to "Тестовый счет (manager analytics)"
		Then the form attribute named "Description_en" became equal to "Test account (manager analytics)"
		And I close all client application windows

Scenario: _0991021 accounts settings for Cash account (general for company)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9011S_AccountsCashAccount"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		* Try saving without filling main fields
			And I click "Save and close" button
			Then there are lines in TestClient message log
				|'"Company" is a required field.'|
				|'"Ledger type variant" is a required field.'|
				|'"Account" is a required field.'|			
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'   |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "RecordType" became equal to "All"
		And I click Select button of "Account transit" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Assets acccount' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Ledger type variant'               | 'Account' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | '405.01'  |
	And I close all client application windows
	
		
Scenario: _0991022 accounts settings for Cash account (for Cash account)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9011S_AccountsCashAccount"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I change the radio button named "RecordType" value to "Cash/Bank account"
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I click Select button of "Cash/Bank account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash, TRY' |
		And I select current line in "List" table		
		And I input "01.02.2022" text in the field named "Period"
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Own company 2"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.02.2022"
		Then the form attribute named "CashAccount" became equal to "Cash, TRY"	
		And I click Select button of "Account transit" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Assets acccount' |
		And I select current line in "List" table	
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Ledger type variant'               | 'Cash/Bank account' | 'Account' |
			| '01.02.2022' | 'Own company 2' | 'LTV with account charts code mask' | 'Cash, TRY'         | '405.01'  |
	And I close all client application windows			

Scenario: _0991026 accounts settings for Bank account (for Bank account)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9011S_AccountsCashAccount"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Own company 2" string
		And I change the radio button named "RecordType" value to "Cash/Bank account"
		And I click Select button of "Cash/Bank account" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, EUR' |
		And I select current line in "List" table		
		And I input "01.02.2022" text in the field named "Period"
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Own company 2"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.02.2022"
		Then the form attribute named "CashAccount" became equal to "Bank account, EUR"	
		And I click Select button of "Account transit" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Assets acccount' |
		And I select current line in "List" table	
		And I click "Save and close" button	
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Ledger type variant'               | 'Cash/Bank account' | 'Account' |
			| '01.02.2022' | 'Own company 2' | 'LTV with account charts code mask' | 'Bank account, EUR' | '405.01'  |
	And I close all client application windows

Scenario: _0991027 accounts settings for Expense/Revenue (general for company)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9014S_AccountsExpenseRevenue"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		* Try saving without filling main fields
			And I click "Save and close" button
			Then there are lines in TestClient message log
				|'"Company" is a required field.'|
				|'"Ledger type variant" is a required field.'|
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I set checkbox named "Expense"
		And I set checkbox named "Revenue"
		And I select from "Account (expense)" drop-down list by "40501" string
		And I select from "Account (revenue)" drop-down list by "40501" string		
		Then the form attribute named "AccountExpense" became equal to "405.01"
		Then the form attribute named "AccountRevenue" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "RecordType" became equal to "All"
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Ledger type variant'               | 'Expense / Revenue' | 'Account (expense)' | 'Account (revenue)' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | ''                  | '405.01'            | '405.01'            |
	And I close all client application windows

Scenario: _0991028 accounts settings for Expense/Revenue
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9014S_AccountsExpenseRevenue"	
	* Create new element for expense			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'   |
		And I select current line in "List" table
		And I change the radio button named "RecordType" value to "Expense/Revenue"
		And I click Select button of "Expense / Revenue" field
		And I go to line in "List" table
			| 'Description'   |
			| 'Other expence' |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I set checkbox named "Expense"
		And I select from "Account (expense)" drop-down list by "90878699" string	
		Then the form attribute named "AccountExpense" became equal to "90878699"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "ExpenseRevenue" became equal to "Other expence"	
		And I click "Save and close" button
	* Create new element for revenue
			And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'   |
		And I select current line in "List" table
		And I change the radio button named "RecordType" value to "Expense/Revenue"
		And I select from "Expense / Revenue" drop-down list by "Other revenues" string	
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I set checkbox named "Revenue"
		And I select from "Account (revenue)" drop-down list by "10878699" string	
		Then the form attribute named "AccountRevenue" became equal to "10878699"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "ExpenseRevenue" became equal to "Other revenues"	
		And I click "Save and close" button
			
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Ledger type variant'               | 'Expense / Revenue' | 'Account (expense)' | 'Account (revenue)' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | 'Other expence'     | '90878699'          | ''                  |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | 'Other revenues'    | ''                  | '10878699'          |
	And I close all client application windows

Scenario: _0991029 accounts settings for item key (general for company)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9010S_AccountsItemKey"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		* Try saving without filling main fields
			And I click "Save and close" button
			Then there are lines in TestClient message log
				|'"Company" is a required field.'|
				|'"Ledger type variant" is a required field.'|
				|'"Account" is a required field.'|
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "RecordType" became equal to "All"
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Ledger type variant'               | 'Item key' | 'Item' | 'Item type' | 'Type of item type' | 'Account' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | ''         | ''     | ''          | ''                  | '405.01'  |		
	And I close all client application windows

Scenario: _0991030 accounts settings for item key
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9010S_AccountsItemKey"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I change the radio button named "RecordType" value to "Item key"	
		And I click Select button of "Item key" field
		And I go to line in "List" table
			| 'Item'               | 'Item key'  |
			| 'Item with item key' | 'S/Color 1' |
		And I select current line in "List" table
		And I select from "Item key" drop-down list by "XS/Color 2" string	
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "ItemKey" became equal to "XS/Color 2"		
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Ledger type variant'               | 'Item key' | 'Item' | 'Item type' | 'Type of item type' | 'Account' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | 'XS/Color 2'  | ''     | ''          | ''                  | '405.01'  |
	And I close all client application windows

Scenario: _0991031 accounts settings for item
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9010S_AccountsItemKey"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I change the radio button named "RecordType" value to "Item"	
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Item with item key'       |
		And I select current line in "List" table
		And I select from "Item" drop-down list by "Item without item key (pcs)" string	
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "Item" became equal to "Item without item key (pcs)"		
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Ledger type variant'               | 'Item key' | 'Item'      | 'Item type' | 'Type of item type' | 'Account' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | ''         | 'Item without item key (pcs)'     | ''          | ''                  | '405.01'  |
	And I close all client application windows

Scenario: _0991032 accounts settings for item type
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9010S_AccountsItemKey"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I change the radio button named "RecordType" value to "Item type"	
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Item (with size and color)'     |
		And I select current line in "List" table
		And I select from "Item type" drop-down list by "Item (without item key)" string	
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "ItemType" became equal to "Item (without item key)"		
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Ledger type variant'               | 'Item key' | 'Item' | 'Item type' | 'Type of item type' | 'Account' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | ''         | ''     | 'Item (without item key)'     | ''                  | '405.01'  |
	And I close all client application windows

Scenario: _0991033 accounts settings for item types
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9010S_AccountsItemKey"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I change the radio button named "RecordType" value to "Item types"	
		And I select "Certificate" exact value from "Type of item type" drop-down list		
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "90878699" string
		Then the form attribute named "Account" became equal to "90878699"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "TypeOfItemType" became equal to "Certificate"			
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Ledger type variant'               | 'Item key' | 'Item' | 'Item type' | 'Type of item type' | 'Account'  |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | ''         | ''     | ''          | 'Certificate'       | '90878699' |
	And I close all client application windows

Scenario: _0991034 accounts settings for partner (general for company)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9012S_AccountsPartner"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		* Try saving without filling main fields
			And I click "Save and close" button
			Then there are lines in TestClient message log
				|'"Company" is a required field.'|
				|'"Ledger type variant" is a required field.'|
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I set checkbox named "Vendor"
		And I set checkbox named "Customer"
		And I set checkbox named "Other"
		* Try saving without filling accounts
			And I click "Save" button
			Then there are lines in TestClient message log
				|'"Advances" is a required field.'|
				|'"Transactions" is a required field.'|
				|'"Advances" is a required field.'|
				|'"Transactions" is a required field.'|
				|'"Advances" is a required field.'|
				|'"Transactions" is a required field.'|				
		And I select from the drop-down list named "AccountAdvancesVendor" by "40501" string
		And I select from the drop-down list named "AccountTransactionsVendor" by "9087" string
		And I select from the drop-down list named "AccountAdvancesCustomer" by "40501" string
		And I select from the drop-down list named "AccountTransactionsCustomer" by "9087" string
		And I select from the drop-down list named "AccountTransactionsOther" by "9087" string
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Partner' | 'Ledger type variant'               | 'Agreement' | 'Vendor' | 'Customer' | 'Transactions' | 'Other' | 'Advances' |
			| '01.01.2022' | 'Own company 1' | ''        | 'LTV with account charts code mask' | ''          | 'Yes'    | 'Yes'      | '90878699'     | 'Yes'   | '405.01'   |	
	And I close all client application windows

Scenario: _0991035 accounts settings for partner (vendor)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9012S_AccountsPartner"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I set checkbox named "Vendor"
		And field "AccountAdvancesCustomer" is not present on the form
		And field "AccountTransactionsCustomer" is not present on the form
		And field "AccountAdvancesOther" is not present on the form
		And field "AccountTransactionsOther" is not present on the form
		And I select from the drop-down list named "AccountAdvancesVendor" by "40501" string
		And I select from the drop-down list named "AccountTransactionsVendor" by "9087" string
		And I change the radio button named "RecordType" value to "Partner"
		And I select from the drop-down list named "Partner" by "Customer 1 (3 partner terms)" string
		Then the form attribute named "AccountAdvancesVendor" became equal to "405.01"
		Then the form attribute named "AccountTransactionsVendor" became equal to "90878699"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "Customer" became equal to "No"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		Then the form attribute named "Other" became equal to "No"
		Then the form attribute named "Partner" became equal to "Customer 1 (3 partner terms)"
		Then the form attribute named "RecordType" became equal to "Partner"
		Then the form attribute named "Vendor" became equal to "Yes"
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Partner'                     | 'Ledger type variant'               | 'Agreement' | 'Vendor' | 'Customer' | 'Transactions' | 'Other' | 'Advances' |
			| '01.01.2022' | 'Own company 1' | 'Customer 1 (3 partner terms)' | 'LTV with account charts code mask' | ''          | 'Yes'    | 'No'       | ''             | 'No'    | ''         |
	And I close all client application windows

Scenario: _0991036 accounts settings for partner (customer)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9012S_AccountsPartner"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I set checkbox named "Customer"
		And field "AccountAdvancesVendor" is not present on the form
		And field "AccountTransactionsVendor" is not present on the form
		And field "AccountAdvancesOther" is not present on the form
		And field "AccountTransactionsOther" is not present on the form
		And I select from the drop-down list named "AccountAdvancesCustomer" by "40501" string
		And I select from the drop-down list named "AccountTransactionsCustomer" by "9087" string
		And I change the radio button named "RecordType" value to "Partner"
		And I select from the drop-down list named "Partner" by "Customer 2 (2 partner term)" string
		Then the form attribute named "AccountAdvancesCustomer" became equal to "405.01"
		Then the form attribute named "AccountTransactionsCustomer" became equal to "90878699"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "Customer" became equal to "Yes"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		Then the form attribute named "Other" became equal to "No"
		Then the form attribute named "Partner" became equal to "Customer 2 (2 partner term)"
		Then the form attribute named "RecordType" became equal to "Partner"
		Then the form attribute named "Vendor" became equal to "No"
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Partner'                      | 'Ledger type variant'               | 'Agreement' | 'Vendor' | 'Currency' | 'Customer' | 'Transactions' | 'Other' | 'Advances' |
			| '01.01.2022' | 'Own company 1' | 'Customer 2 (2 partner term)'  | 'LTV with account charts code mask' | ''          | 'No'     | ''         | 'Yes'      | ''             | 'No'    | '405.01'   |		
	And I close all client application windows
				

Scenario: _0991037 accounts settings for partner (partner term)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9012S_AccountsPartner"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I change the radio button named "RecordType" value to "Partner term"	
		And I set checkbox named "Customer"
		And I select from the drop-down list named "Agreement" by "Partner term with customer (by document + credit limit)" string
		And I select from the drop-down list named "AccountAdvancesCustomer" by "40501" string
		And I select from the drop-down list named "AccountTransactionsCustomer" by "9087" string		
		Then the form attribute named "AccountAdvancesCustomer" became equal to "405.01"
		Then the form attribute named "AccountTransactionsCustomer" became equal to "90878699"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		Then the form attribute named "Agreement" became equal to "Partner term with customer (by document + credit limit)"
		Then the form attribute named "RecordType" became equal to "Agreement"
		Then the form attribute named "AccountAdvancesCustomer" became equal to "405.01"
		Then the form attribute named "AccountTransactionsCustomer" became equal to "90878699"
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Partner'                      | 'Ledger type variant'               | 'Agreement'                                               | 'Vendor' | 'Currency' | 'Customer' | 'Transactions' | 'Other' | 'Advances' |
			| '01.01.2022' | 'Own company 1' | ''                             | 'LTV with account charts code mask' | 'Partner term with customer (by document + credit limit)' | 'No'     | ''         | 'Yes'      | ''             | 'No'    | '405.01'   |
	And I close all client application windows	

Scenario: _0991038 accounts settings for tax (general for company)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9013S_AccountsTax"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		* Try saving without filling main fields
			And I click "Save and close" button
			Then there are lines in TestClient message log
				|'"Company" is a required field.'|
				|'"Ledger type variant" is a required field.'|
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from "Incoming account" drop-down list by "4050" string
		And I select from "Outgoing account" drop-down list by "9087" string		
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Ledger type variant'               | 'Tax' | 'Vat rate' | 'Incoming account' | 'Outgoing account' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | ''    | ''         | '405.01'           | '90878699'         |		
	And I close all client application windows			

Scenario: _0991038 accounts settings for tax type and rate
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9013S_AccountsTax"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I change the radio button named "RecordType" value to "Tax type"
		And I select from the drop-down list named "Tax" by "vat" string
		And I select from "Vat rate" drop-down list by "20" string
		And I select from "Incoming account" drop-down list by "4050" string
		And I select from "Outgoing account" drop-down list by "9087" string		
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Ledger type variant'               | 'Tax' | 'Vat rate' | 'Incoming account' | 'Outgoing account' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | 'VAT' | '20%'      | '405.01'           | '90878699'         |
	And I close all client application windows

Scenario: _0991040 check account priority for service (ExpenseType, CostRevenueCenter) for PI
	And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Vendor 2 (1 partner term)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "service" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "10,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
	* Check account (expense type not filled)
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table contains lines
				| 'Debit' | 'Partner'                   | 'Business unit' | 'Partner term'               | 'Credit' | 'Operation'                                                                                  |
				| '420.5' | 'Vendor 2 (1 partner term)' | ''              | 'Partner term with vendor 2' | '5201'   | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' |
		And I close current window
	* Check account (CostRevenueCenter empty, ExpenseType filled)
		And I activate "Expense type" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "other" from "Expense type" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table contains lines
			| 'Credit' | 'Debit' | 'Operation'                                                                                  | 'Partner'                   | 'Partner term'               |
			| '5201'   | '420.2' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Vendor 2 (1 partner term)' | 'Partner term with vendor 2' |
		And I close current window
	* Check account (CostRevenueCenter filled, ExpenseType filled)
		And I select "Expence and revenue 1" from "Expense type" drop-down list by string in "ItemList" table
		And I select "Business unit 2" from "Profit loss center" drop-down list by string in "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button			
		And "AccountingAnalytics" table contains lines
			| 'Credit' | 'Debit' | 'Operation'                                                                                  | 'Partner'                   | 'Partner term'               |
			| '5201'   | '420.3' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Vendor 2 (1 partner term)' | 'Partner term with vendor 2' |					
		And I close current window
	* Select another CostRevenueCenter and check account
		And I select "Business unit 3" from "Profit loss center" drop-down list by string in "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button			
		And "AccountingAnalytics" table contains lines
			| 'Credit' | 'Debit' | 'Operation'                                                                                  | 'Partner'                   | 'Partner term'               |
			| '5201'   | '420.4' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Vendor 2 (1 partner term)' | 'Partner term with vendor 2' |								
		And I close current window
	* Check account (CostRevenueCenter filled, ExpenseType empty)
		And I select "Business unit 2" from "Profit loss center" drop-down list by string in "ItemList" table
		And I input "" text in "Expense type" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table contains lines
			| 'Credit' | 'Debit' | 'Operation'                                                                                  | 'Partner'                   | 'Partner term'               |
			| '5201'   | '420.3' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Vendor 2 (1 partner term)' | 'Partner term with vendor 2' |								
		And I close all client application windows


Scenario: _0991041 check account priority for service (ExpenseType, CostRevenueCenter) for SI
	And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Partner" by "Customer 2 (2 partner term)" string
		And I select from the drop-down list named "Agreement" by "Individual partner term 1 (by partner term)" string
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "service" from "Item" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "10,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
	* Check account (revenue type not filled)
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table contains lines
			| "Debit" | "Partner"                     | "Business unit" | "Partner term"                                | "Credit" | "Operation"                                                                        |
			| "5202"  | "Customer 2 (2 partner term)" | ""              | "Individual partner term 1 (by partner term)" | "4010"   | "SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)" |
			| "4010"  | ""                            | ""              | ""                                            | "9100"   | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)"              |
			| "4010"  | "VAT"                         | ""              | ""                                            | "5302"   | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)"         |	
		And I close current window
	* Check account (CostRevenueCenter filled, RevenueType filled)
		And I select "Expence and revenue 1" from "Revenue type" drop-down list by string in "ItemList" table
		And I select "Business unit 2" from "Profit loss center" drop-down list by string in "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button			
		And "AccountingAnalytics" table contains lines
			| "Debit" | "Partner"                     | "Business unit" | "Partner term"                                | "Credit" | "Operation"                                                                        |
			| "5202"  | "Customer 2 (2 partner term)" | ""              | "Individual partner term 1 (by partner term)" | "4010"   | "SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)" |
			| "4010"  | "Business unit 2"             | ""              | ""                                            | "9102"   | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)"              |
			| "4010"  | "VAT"                         | ""              | "Business unit 2"                             | "5302"   | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)"         |	
		And I close current window
	* Check account (CostRevenueCenter empty, RevenueType filled)
		And I input "" text in "Profit loss center" field of "ItemList" table
		And I activate "Revenue type" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Other revenues" from "Revenue type" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table contains lines
			| "Debit" | "Partner"                     | "Business unit" | "Partner term"                                | "Credit" | "Operation"                                                                        |
			| "5202"  | "Customer 2 (2 partner term)" | ""              | "Individual partner term 1 (by partner term)" | "4010"   | "SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)" |
			| "4010"  | ""                            | ""              | ""                                            | "9100"   | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)"              |
			| "4010"  | "VAT"                         | ""              | ""                                            | "5302"   | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)"         |	
		And I close current window
	* Select another CostRevenueCenter and check account
		And I select "Business unit 3" from "Profit loss center" drop-down list by string in "ItemList" table
		And I input "Expence and revenue 1" text in "Revenue type" field of "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button			
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                     | "Business unit" | "Partner term"                                | "Credit" | "Operation"                                                                        |
			| "5202"  | "Customer 2 (2 partner term)" | ""              | "Individual partner term 1 (by partner term)" | "4010"   | "SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)" |
			| "4010"  | "Business unit 3"             | ""              | ""                                            | "9101"   | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)"              |
			| "4010"  | "VAT"                         | ""              | "Business unit 3"                             | "5302"   | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)"         |		
		And I close current window
	* Check account (CostRevenueCenter filled, RevenueType empty)
		And I select "Business unit 2" from "Profit loss center" drop-down list by string in "ItemList" table
		And I input "" text in "Revenue type" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table contains lines
			| 'Debit' | 'Partner'                     | 'Business unit'   | 'Partner term'                                | 'Credit' | 'Operation'                                                                                            |
			| '4010'  | 'Business unit 2'             | ''                | ''                                            | '9100'   | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)'                                  |
			| '4010'  | 'VAT'                         | ''                | 'Business unit 2'                             | '5302'   | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)'                                          |
		And I close all client application windows

Scenario: _0991058 create journal entry for one PI
	And I close all client application windows
	* Open PI list
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Select PI and create journal entry
		And I go to line in "List" table
			| 'Amount'    | 'Company'       | 'Partner'                   |
			| '13 720,05' | 'Own company 2' | 'Vendor 1 (1 partner term)' |		
		And I click "Journal entry" button
		And I click "Save" button
	* Check journal entry
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "Basis" became equal to "Purchase invoice 1 dated 24.02.2023 10:04:33"
		Then the form attribute named "Company" became equal to "Own company 2"
		Then the form attribute named "Date" became equal to "24.02.2023 10:04:33"
		Then the form attribute named "LedgerType" became equal to "Basic LTV"
		Then the form attribute named "LedgerTypeCurrencyMovementTypeCurrency" became equal to "TRY"
		Then the form attribute named "Number" became equal to "1"
		And "RegisterRecords" table contains lines
			| 'Period'              | 'Account Dr' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'                                   | 'Debit amount' | 'Extra dimension2 Dr'   | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'          | 'Operation'                                                                                  | 'Extra dimension2 Cr'        | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 10:04:33' | '3540'       | '633,33'   | '4'             | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '633,33'       | 'XS/Color 2'            | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '633,33'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '126,67'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '126,67'       | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '126,67'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '2 500,00' | '20'            | 'Yes'      | 'TRY'             | 'Item without item key (pcs)'                       | '2 500'        | 'Item without item key' | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '2 500'         | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '500,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '500'          | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '500'           | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '1 541,67' | '10'            | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '1 541,67'     | 'S/Color 2'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '1 541,67'      | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '308,33'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '308,33'       | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '308,33'        | ''                    |
			| '24.02.2023 10:04:33' | '3540'       | '1 200,00' | '8'             | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '1 200'        | 'S/Color 2'             | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '1 200'         | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '240,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '240'          | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '240'           | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '4 583,33' | '50'            | 'Yes'      | 'TRY'             | 'Item with item key'                                | '4 583,33'     | 'S/Color 1'             | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '4 583,33'      | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '916,67'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '916,67'       | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '916,67'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '100,00'   | '1'             | 'Yes'      | 'TRY'             | 'Item 4 with unique serial lot number'              | '100'          | 'S/Color 1'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '100'           | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '20,00'    | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '20'           | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '20'            | ''                    |
			| '24.02.2023 10:04:33' | '3540'       | '875,00'   | '10'            | 'Yes'      | 'TRY'             | 'Item with item key'                                | '875'          | 'S/Color 1'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '875'           | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '175,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '175'          | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '175'           | ''                    |
		Then the number of "RegisterRecords" table lines is "равно" "14"		
		Then the form attribute named "UserDefined" became equal to "No"
		And I click "Save and close" button	
	* Check Journal entry creation
		Given I open hyperlink "e1cib/list/Document.JournalEntry"
		And "List" table contains lines
			| 'User defined' | 'Date'                | 'Company'       | 'Ledger type' | 'Basis'                                        |
			| 'No'           | '24.02.2023 10:04:33' | 'Own company 2' | 'Basic LTV'   | 'Purchase invoice 1 dated 24.02.2023 10:04:33' |
		
							
Scenario: _0991059 create journal entry for two PI
	And I close all client application windows
	* Open PI list
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Select PI and create journal entry
		And I go to line in "List" table
			| 'Amount'    | 'Company'       | 'Partner'                   |
			| '2 200,00'  | 'Own company 2' | 'Vendor 2 (1 partner term)' |	
		And I move one line down in "List" table and select line	
		And I click "Journal entry (multiple documents)" button
		And I go to line in "JournalEntries" table
			| 'Ledger type' | 'Use' |
			| 'Basic LTV'   | 'No'  |	
		And I set "Use" checkbox in "JournalEntries" table
		And I finish line editing in "JournalEntries" table
		And I click "Ok" button	
	* Check journal entry
		Given I open hyperlink "e1cib/list/Document.JournalEntry"
		And "List" table contains lines
			| 'User defined' | 'Date'                | 'Company'       | 'Ledger type' | 'Basis'                                        |
			| 'No'           | '22.07.2023 09:38:02' | 'Own company 2' | 'Basic LTV'   | 'Purchase invoice 2 dated 22.07.2023 09:38:02' |
			| 'No'           | '30.11.2023 16:01:04' | 'Own company 2' | 'Basic LTV'   | 'Purchase invoice 3 dated 30.11.2023 16:01:04' |
			
				
Scenario: _0991070 check Bank receipt accounting movements (Payment from customer)
	And I close all client application windows
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account'           | 'Company'                                     | 'Business unit'   | 'Partner'                     | 'Credit' | 'Partner term'                                | 'Operation'                                                                                         |
			| '3250'  | 'Bank account, TRY'           | 'Client 2'                                    | 'Business unit 1' | 'Customer 2 (2 partner term)' | '4010'   | 'Individual partner term 1 (by partner term)' | 'BankReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)' |
			| '5202'  | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | 'Business unit 1' | 'Customer 2 (2 partner term)' | '4010'   | 'Individual partner term 1 (by partner term)' | 'BankReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                   |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'   | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'            | 'Operation'                                                                                         | 'Extra dimension2 Cr'                         | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 10:49:55' | '3250'       | '1' | '1 000,00' | ''              | 'Yes'      | 'TRY'             | 'Bank account, TRY' | '1 000'        | 'Client 2'            | ''                | 'Business unit 1'     | 'TRY'            | '4010'       | 'Customer 2 (2 partner term)' | 'BankReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)' | 'Individual partner term 1 (by partner term)' | '1 000'         | 'Business unit 1'     |	
	And I close all client application windows

Scenario: _0991071 check Bank payment accounting movements (Payment to the vendor)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'                   | 'Business unit'   | 'Company'                    | 'Partner term'               | 'Credit' | 'Cash/Bank account'         | 'Operation'                                                                                   |
			| '5201'  | 'Vendor 2 (1 partner term)' | 'Business unit 1' | 'Vendor 2'                   | 'Partner term with vendor 2' | '3250'   | 'Bank account, TRY'         | 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)' |
			| '5201'  | 'Vendor 2 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 2' | 'Partner term with vendor 2' | '4020.2' | 'Vendor 2 (1 partner term)' | 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                   |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'           | 'Debit amount' | 'Extra dimension2 Dr'        | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                                                   | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 10:51:48' | '5201'       | '1' | '700,00' | ''              | 'Yes'      | 'TRY'             | 'Vendor 2 (1 partner term)' | '700'          | 'Partner term with vendor 2' | ''                | 'Business unit 1'     | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)' | 'Vendor 2'            | '700'           | 'Business unit 1'     |		
	And I close all client application windows

				
Scenario: _0991072 check Bank payment accounting movements (Payment to the vendor)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'                   | 'Business unit'   | 'Company'                    | 'Partner term'               | 'Credit' | 'Cash/Bank account'         | 'Operation'                                                                                   |
			| '5201'  | 'Vendor 2 (1 partner term)' | 'Business unit 1' | 'Vendor 2'                   | 'Partner term with vendor 2' | '3250'   | 'Bank account, TRY'         | 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)' |
			| '5201'  | 'Vendor 2 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 2' | 'Partner term with vendor 2' | '4020.2' | 'Vendor 2 (1 partner term)' | 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                   |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'           | 'Debit amount' | 'Extra dimension2 Dr'        | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                                                   | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 10:51:48' | '5201'       | '1' | '700,00' | ''              | 'Yes'      | 'TRY'             | 'Vendor 2 (1 partner term)' | '700'          | 'Partner term with vendor 2' | ''                | 'Business unit 1'     | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)' | 'Vendor 2'            | '700'           | 'Business unit 1'     |		
	And I close all client application windows	

Scenario: _0991073 check Bank payment accounting movements (Cash transfer order)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '4'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account' | 'Company' | 'Partner' | 'Business unit' | 'Credit' | 'Operation'                                                                            |
			| '3221'  | 'Bank account, TRY' | ''        | ''        | ''              | '3250'   | 'BankPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Cash transfer)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                                            | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '01.04.2023 12:00:00' | '3221'       | '1' | '100,00' | ''              | 'Yes'      | 'TRY'             | 'Cash, TRY'       | '100'          | ''                    | ''                | ''                    | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Cash transfer)' | ''                    | '100'           | ''                    |		
	And I close all client application windows	

Scenario: _0991074 check Bank receipt accounting movements (Cash transfer order)
	And I close all client application windows
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account' | 'Company' | 'Business unit' | 'Partner' | 'Credit' | 'Operation'                                                                            |
			| '3250'  | 'Bank account, TRY' | ''        | ''              | ''        | '3221'   | 'BankReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Cash transfer)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                                            | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 11:01:13' | '3250'       | '1' | '150,00' | ''              | 'Yes'      | 'TRY'             | 'Cash, TRY'       | '150'          | ''                    | ''                | ''                    | 'TRY'            | '3221'       | 'Bank account, TRY' | 'BankReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Cash transfer)' | ''                    | '150'           | ''                    |		
	And I close all client application windows			

Scenario: _0991075 check Bank payment accounting movements (Currency exchange)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account' | 'Company' | 'Partner' | 'Business unit' | 'Credit' | 'Operation'                                                                                |
			| '3221'  | 'Bank account, TRY' | ''        | ''        | ''              | '3250'   | 'BankPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Currency exchange)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                                                | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 11:00:05' | '3221'       | '1' | '1 100,00' | ''              | 'Yes'      | 'TRY'             | 'Transit, TRY'    | '1 100'        | ''                    | ''                | ''                    | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Currency exchange)' | ''                    | '1 100'         | ''                    |		
	And I close all client application windows			


Scenario: _0991076 check Bank receipt accounting movements (Currency exchange)
	And I close all client application windows
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '7'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account' | 'Company'       | 'Partner' | 'Business unit' | 'Credit' | ' ' | 'Operation'                                                                                |
			| '3221'  | 'Transit, TRY'      | 'Own company 2' | ''        | ''              | '9100'   | ''  | 'BankReceipt DR (R3021B_CashInTransit) CR (R5021T_Revenues)'                               |
			| '420.5' | ''                  | 'Own company 2' | ''        | 'Transit, TRY'  | '3221'   | ''  | 'BankReceipt DR (R5022T_Expenses) CR (R3021B_CashInTransit)'                               |
			| '3250'  | 'Bank account, TRY' | ''              | ''        | 'Transit, TRY'  | '3221'   | ''  | 'BankReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Currency exchange)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table contains lines
			| 'Period'              | 'Account Dr' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'   | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                                                | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '25.02.2023 12:00:00' | '420.5'      | '17,97'    | ''              | 'Yes'      | 'TRY'             | ''                  | '17,97'        | ''                    | ''                | ''                    | 'TRY'            | '3221'       | 'Transit, TRY'     | 'BankReceipt DR (R5022T_Expenses) CR (R3021B_CashInTransit)'                               | 'Own company 2'       | '17,97'         | ''                    |
			| '25.02.2023 12:00:00' | '3250'       | '1 082,03' | ''              | 'Yes'      | 'EUR'             | 'Bank account, TRY' | '54'           | ''                    | ''                | ''                    | 'EUR'            | '3221'       | 'Transit, TRY'     | 'BankReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Currency exchange)' | ''                    | '54'            | ''                    |
		Then the number of "RegisterRecords" table lines is "равно" "2"
	And I close all client application windows			


Scenario: _0991077 check Bank payment accounting movements (Return to customer)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'                      | 'Business unit'   | 'Company'                                                 | 'Partner term'                                            | 'Credit' | 'Cash/Bank account'            | 'Operation'                                                                                         |
			| '4010'  | 'Customer 1 (3 partner terms)' | 'Business unit 1' | 'Client 1'                                                | 'Partner term with customer (by document + credit limit)' | '3250'   | 'Bank account, TRY'            | 'BankPayment DR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) CR (R3010B_CashOnHand)' |
			| '4010'  | 'Customer 1 (3 partner terms)' | 'Business unit 1' | 'Partner term with customer (by document + credit limit)' | 'Partner term with customer (by document + credit limit)' | '5202'   | 'Customer 1 (3 partner terms)' | 'BankPayment DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                   |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'              | 'Debit amount' | 'Extra dimension2 Dr'                                     | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                                                         | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '11.08.2023 12:00:00' | '4010'       | '1' | '100,00' | ''              | 'Yes'      | 'TRY'             | 'Customer 1 (3 partner terms)' | '100'          | 'Partner term with customer (by document + credit limit)' | ''                | 'Business unit 1'     | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) CR (R3010B_CashOnHand)' | 'Client 1'            | '100'           | 'Business unit 1'     |		
	And I close all client application windows

Scenario: _0991078 check Bank receipt accounting movements (Return from vendor)
	And I close all client application windows
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '13'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit'  | 'Cash/Bank account'   | 'Company'                                                | 'Business unit' | 'Partner'             | 'Credit' | 'Partner term'                                           | 'Operation'                                                                                   |
			| '3250'   | 'Bank account, TRY'   | 'Client and vendor'                                      | ''              | 'Customer and vendor' | '4020.2' | 'Partner term with vendor (advance payment by document)' | 'BankReceipt DR (R3010B_CashOnHand) CR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions)' |
			| '4020.2' | 'Customer and vendor' | 'Partner term with vendor (advance payment by document)' | ''              | 'Customer and vendor' | '5201'   | 'Partner term with vendor (advance payment by document)' | 'BankReceipt DR (R1020B_AdvancesToVendors) CR (R1021B_VendorsTransactions)'                   |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table contains lines
			| 'Period'              | 'Account Dr' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'     | 'Debit amount' | 'Extra dimension2 Dr'                                    | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'    | 'Operation'                                                                                   | 'Extra dimension2 Cr'                                    | 'Credit amount' | 'Extra dimension3 Cr' |
			| '05.12.2023 10:00:00' | '3250'       | '50,00'  | ''              | 'Yes'      | 'TRY'             | 'Bank account, TRY'   | '50'           | 'Client and vendor'                                      | ''                | ''                    | 'TRY'            | '4020.2'     | 'Customer and vendor' | 'BankReceipt DR (R3010B_CashOnHand) CR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions)' | 'Partner term with vendor (advance payment by document)' | '50'            | ''                    |
		Then the number of "RegisterRecords" table lines is "равно" "2"
	And I close all client application windows

Scenario: _0991079 check Bank receipt accounting movements (Other partner)
	And I close all client application windows
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '14'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| "Debit" | "Cash/Bank account" | "Company"       | "Business unit" | "Partner"       | "Credit" | "Operation"                                                                |
			| "3250"  | "Bank account, TRY" | "Other partner" | ""              | "Other partner" | "9200"   | "BankReceipt DR (R3010B_CashOnHand) CR (R5015B_OtherPartnersTransactions)" |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'   | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                                | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '11.01.2024 10:00:00' | '3250'       | '1' | '490,00' | ''              | 'Yes'      | 'TRY'             | 'Bank account, TRY' | '490'          | 'Other partner'       | ''                | ''                    | 'TRY'            | '9200'       | ''                 | 'BankReceipt DR (R3010B_CashOnHand) CR (R5015B_OtherPartnersTransactions)' | 'Other partner'       | '490'           | 'Other partner'       |
	And I close all client application windows

Scenario: _0991081 check Bank receipt accounting movements (Other income)
	And I close all client application windows
	* Select BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '18'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account' | 'Company' | 'Business unit'   | 'Credit' | ' ' | 'Operation'                                              |
			| '3250'  | 'Bank account, TRY' | ''        | 'Business unit 3' | '9100'   | ''  | 'BankReceipt DR (R3010B_CashOnHand) CR (R5021_Revenues)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'   | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                              | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '03.02.2024 12:00:00' | '3250'       | '1' | '490,00' | ''              | 'Yes'      | 'TRY'             | 'Bank account, TRY' | '490'          | ''                    | ''                | 'Business unit 3'     | 'TRY'            | '9100'       | 'Business unit 3'  | 'BankReceipt DR (R3010B_CashOnHand) CR (R5021_Revenues)' | ''                    | '490'           | ''                    |		
	And I close all client application windows


Scenario: _0991082 check Bank payment accounting movements (Other partners)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '13'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Business unit' | 'Company'       | 'Partner'       | 'Credit' | 'Cash/Bank account' | 'Operation'                                                                |
			| '9200'  | ''              | 'Other partner' | 'Other partner' | '3250'   | 'Bank account, TRY' | 'BankPayment DR (R5015B_OtherPartnersTransactions) CR (R3010B_CashOnHand)' |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                                | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '22.03.2024 10:51:11' | '9200'       | '1' | '9,80'   | ''              | 'Yes'      | 'TRY'             | ''                | '9,8'          | 'Other partner'       | ''                | 'Other partner'       | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R5015B_OtherPartnersTransactions) CR (R3010B_CashOnHand)' | 'Other partner'       | '9,8'           | ''                    |		
	And I close all client application windows


Scenario: _0991083 check Bank payment accounting movements (Other expense)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '16'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner' | 'Business unit'   | 'Company' | 'Expense and revenue type' | 'Credit' | 'Cash/Bank account' | 'Operation'                                               |
			| '420.2' | ''        | 'Business unit 3' | ''        | 'Other expence'            | '3250'   | 'Bank account, TRY' | 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                               | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '18.04.2024 12:27:16' | '420.2'      | '1' | '10,00'  | ''              | 'Yes'      | 'TRY'             | ''                | '10'           | 'Business unit 3'     | ''                | 'Other expence'       | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)' | ''                    | '10'            | 'Business unit 3'     |		
	And I close all client application windows


Scenario: _0991084 check Bank payment accounting movements (Salary)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '17'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | ' ' | 'Credit' | 'Cash/Bank account' | 'Company' | 'Business unit' | 'Operation'                                                    |
			| '5401'  | ''  | '3250'   | 'Bank account, TRY' | ''        | ''              | 'BankPayment DR (R9510B_SalaryPayment) CR (R3010B_CashOnHand)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'    | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                    | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '02.02.2023 15:00:00' | '5401'       | '1' | '14 460,46' | ''              | 'Yes'      | 'TRY'             | ''                | '14 460,46'    | ''                    | ''                | ''                    | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R9510B_SalaryPayment) CR (R3010B_CashOnHand)' | ''                    | '14 460,46'     | ''                    |
			| '02.02.2023 15:00:00' | '5401'       | '2' | '12 172,73' | ''              | 'Yes'      | 'TRY'             | ''                | '12 172,73'    | ''                    | ''                | ''                    | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R9510B_SalaryPayment) CR (R3010B_CashOnHand)' | ''                    | '12 172,73'     | ''                    |		
	And I close all client application windows


Scenario: _0991085 check Bank payment accounting movements (Employee cash advance)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '5'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit'  | 'Partner'    | 'Business unit' | 'Company' | ' ' | 'Credit' | 'Cash/Bank account' | 'Operation'                                                          |
			| '4020.1' | 'Employee 1' | ''              | ''        | ''  | '3250'   | 'Bank account, TRY' | 'BankPayment DR (R3027B_EmployeeCashAdvance) CR (R3010B_CashOnHand)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                          | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '01.04.2023 12:00:01' | '4020.1'     | '1' | '500,00' | ''              | 'Yes'      | 'TRY'             | 'Employee 1'      | '500'          | ''                    | ''                | ''                    | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R3027B_EmployeeCashAdvance) CR (R3010B_CashOnHand)' | ''                    | '500'           | ''                    |		
	And I close all client application windows


Scenario: _0991086 check Bank payment accounting movements (Other expense)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '16'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner' | 'Business unit'   | 'Company' | 'Expense and revenue type' | 'Credit' | 'Cash/Bank account' | 'Operation'                                               |
			| '420.2' | ''        | 'Business unit 3' | ''        | 'Other expence'            | '3250'   | 'Bank account, TRY' | 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                               | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '18.04.2024 12:27:16' | '420.2'      | '1' | '10,00'  | ''              | 'Yes'      | 'TRY'             | ''                | '10'           | 'Business unit 3'     | ''                | 'Other expence'       | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)' | ''                    | '10'            | 'Business unit 3'     |		
	And I close all client application windows


Scenario: _0991087 check Bank payment accounting movements (Salary)
	And I close all client application windows
	* Select BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '16'     |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner' | 'Business unit'   | 'Company' | 'Expense and revenue type' | 'Credit' | 'Cash/Bank account' | 'Operation'                                               |
			| '420.2' | ''        | 'Business unit 3' | ''        | 'Other expence'            | '3250'   | 'Bank account, TRY' | 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                               | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '18.04.2024 12:27:16' | '420.2'      | '1' | '10,00'  | ''              | 'Yes'      | 'TRY'             | ''                | '10'           | 'Business unit 3'     | ''                | 'Other expence'       | 'TRY'            | '3250'       | 'Bank account, TRY' | 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)' | ''                    | '10'            | 'Business unit 3'     |		
	And I close all client application windows

Scenario: _0991080 check Purchase invoice accounting movements
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'                   | 'Business unit'   | 'Partner term'               | 'Credit' | 'Operation'                                                                                                      |
			| '5201'  | 'Vendor 1 (1 partner term)' | ''                | 'Partner term with vendor 1' | '4020.2' | 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                  |
			| '3540'  | 'Vendor 1 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 1' | '5201'   | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)'                     |
			| '5301'  | 'Vendor 1 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 1' | '5201'   | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                                      |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table contains lines
			| 'Period'              | 'Account Dr' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'                                   | 'Debit amount' | 'Extra dimension2 Dr'   | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'          | 'Operation'                                                                                  | 'Extra dimension2 Cr'        | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 10:04:33' | '3540'       | '633,33'   | '4'             | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '633,33'       | 'XS/Color 2'            | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '633,33'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '126,67'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '126,67'       | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '126,67'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '2 500,00' | '20'            | 'Yes'      | 'TRY'             | 'Item without item key (pcs)'                       | '2 500'        | 'Item without item key' | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '2 500'         | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '500,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '500'          | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '500'           | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '1 541,67' | '10'            | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '1 541,67'     | 'S/Color 2'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '1 541,67'      | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '308,33'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '308,33'       | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '308,33'        | ''                    |
			| '24.02.2023 10:04:33' | '3540'       | '1 200,00' | '8'             | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '1 200'        | 'S/Color 2'             | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '1 200'         | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '240,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '240'          | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '240'           | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '4 583,33' | '50'            | 'Yes'      | 'TRY'             | 'Item with item key'                                | '4 583,33'     | 'S/Color 1'             | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '4 583,33'      | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '916,67'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '916,67'       | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '916,67'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '100,00'   | '1'             | 'Yes'      | 'TRY'             | 'Item 4 with unique serial lot number'              | '100'          | 'S/Color 1'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '100'           | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '20,00'    | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '20'           | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '20'            | ''                    |
			| '24.02.2023 10:04:33' | '3540'       | '875,00'   | '10'            | 'Yes'      | 'TRY'             | 'Item with item key'                                | '875'          | 'S/Color 1'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '875'           | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '175,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '175'          | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '175'           | ''                    |
		Then the number of "RegisterRecords" table lines is "равно" "14"
	And I close all client application windows	

Scenario: _0991090 check Sales invoice accounting movements (product and service)
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table contains lines
			| 'Debit' | 'Partner'                      | 'Business unit'   | 'Partner term'                                            | 'Credit' | 'Operation'                                                                                            |
			| '5202'  | 'Customer 1 (3 partner terms)' | ''                | 'Partner term with customer (by document + credit limit)' | '4010'   | 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                     |
			| '4010'  | 'Business unit 1'              | ''                | ''                                                        | '9100'   | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)'                                  |
			| '4010'  | 'VAT'                          | ''                | 'Business unit 1'                                         | '5302'   | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)'                                          |
			| '420.1' | 'Item with item key'           | 'Business unit 1' | 'S/Color 1'                                               | '3540'   | 'SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                         |
		Then the number of "AccountingAnalytics" table lines is "равно" "4"
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button	
		And "RegisterRecords" table contains lines
			| "Period"              | "Account Dr" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"              | "Debit amount" | "Extra dimension2 Dr"                                     | "Credit quantity" | "Extra dimension3 Dr"        | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"   | "Operation"                                                                | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "30.03.2023 12:23:56" | "4010"       | "63,33"  | ""              | "Yes"      | "TRY"             | "Customer 1 (3 partner terms)" | "63,33"        | "Partner term with customer (by document + credit limit)" | ""                | "Business unit 1"            | "TRY"            | "5302"       | "VAT"                | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)" | "Business unit 1"     | "63,33"         | ""                    |
			| "30.03.2023 12:23:56" | "4010"       | "16,67"  | ""              | "Yes"      | "TRY"             | "Customer 1 (3 partner terms)" | "16,67"        | "Partner term with customer (by document + credit limit)" | ""                | "Business unit 1"            | "TRY"            | "5302"       | "VAT"                | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)" | "Business unit 1"     | "16,67"         | ""                    |
			| "30.03.2023 12:23:56" | "4010"       | "316,67" | ""              | "Yes"      | "TRY"             | "Customer 1 (3 partner terms)" | "316,67"       | "Partner term with customer (by document + credit limit)" | ""                | "Business unit 1"            | "TRY"            | "9100"       | "Business unit 1"    | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)"      | ""                    | "316,67"        | ""                    |
			| "30.03.2023 12:23:56" | "4010"       | "83,33"  | ""              | "Yes"      | "TRY"             | "Customer 1 (3 partner terms)" | "83,33"        | "Partner term with customer (by document + credit limit)" | ""                | "Business unit 1"            | "TRY"            | "9100"       | "Business unit 1"    | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)"      | ""                    | "83,33"         | ""                    |
			| "30.03.2023 12:23:56" | "420.1"      | "100,00" | ""              | "Yes"      | "TRY"             | "Item with item key"           | "100"          | "Business unit 1"                                         | "2"               | "Purchase of goods for sale" | "TRY"            | "3540"       | "Item with item key" | "SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)"             | "S/Color 1"           | "100"           | "Business unit 1"     |	
		Then the number of "RegisterRecords" table lines is "равно" "5"
	And I close all client application windows

Scenario: _0991091 check Sales invoice accounting movements (product)
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'                     | 'Business unit'   | 'Partner term'                                | 'Credit' | 'Operation'                                                                                            |
			| '5202'  | 'Customer 2 (2 partner term)' | ''                | 'Individual partner term 1 (by partner term)' | '4010'   | 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                     |
			| '4010'  | 'Business unit 1'             | ''                | ''                                            | '9100'   | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)'                                  |
			| '4010'  | 'VAT'                         | ''                | 'Business unit 1'                             | '5302'   | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)'                                          |
			| '420.1' | 'Item with item key'          | 'Business unit 1' | 'S/Color 1'                                   | '3540'   | 'SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                         |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button	
		And "RegisterRecords" table contains lines
			| "Period"              | "Account Dr" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"             | "Debit amount" | "Extra dimension2 Dr"                         | "Credit quantity" | "Extra dimension3 Dr"        | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"            | "Operation"                                                                | "Extra dimension2 Cr"   | "Credit amount" | "Extra dimension3 Cr" |
			| "24.02.2023 10:14:47" | "4010"       | "126,67" | ""              | "Yes"      | "TRY"             | "Customer 2 (2 partner term)" | "126,67"       | "Individual partner term 1 (by partner term)" | ""                | "Business unit 1"            | "TRY"            | "5302"       | "VAT"                         | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)" | "Business unit 1"       | "126,67"        | ""                    |
			| "24.02.2023 10:14:47" | "4010"       | "75,00"  | ""              | "Yes"      | "TRY"             | "Customer 2 (2 partner term)" | "75"           | "Individual partner term 1 (by partner term)" | ""                | "Business unit 1"            | "TRY"            | "5302"       | "VAT"                         | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R2040B_TaxesIncoming)" | "Business unit 1"       | "75"            | ""                    |
			| "24.02.2023 10:14:47" | "4010"       | "633,33" | ""              | "Yes"      | "TRY"             | "Customer 2 (2 partner term)" | "633,33"       | "Individual partner term 1 (by partner term)" | ""                | "Business unit 1"            | "TRY"            | "9100"       | "Business unit 1"             | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)"      | ""                      | "633,33"        | ""                    |
			| "24.02.2023 10:14:47" | "4010"       | "375,00" | ""              | "Yes"      | "TRY"             | "Customer 2 (2 partner term)" | "375"          | "Individual partner term 1 (by partner term)" | ""                | "Business unit 1"            | "TRY"            | "9100"       | "Business unit 1"             | "SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)"      | ""                      | "375"           | ""                    |
			| "24.02.2023 10:14:47" | "420.1"      | "200,00" | ""              | "Yes"      | "TRY"             | "Item with item key"          | "200"          | "Business unit 1"                             | "4"               | "Purchase of goods for sale" | "TRY"            | "3540"       | "Item with item key"          | "SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)"             | "S/Color 1"             | "200"           | "Business unit 1"     |
			| "24.02.2023 10:14:47" | "420.1"      | "50,00"  | ""              | "Yes"      | "TRY"             | "Item without item key (pcs)" | "50"           | "Business unit 1"                             | "1"               | "Purchase of goods for sale" | "TRY"            | "3540"       | "Item without item key (pcs)" | "SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)"             | "Item without item key" | "50"            | "Business unit 1"     |
		Then the number of "RegisterRecords" table lines is "равно" "6"
	And I close all client application windows


Scenario: _0991093 check Sales return accounting movements (product)
	And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button	
		And "RegisterRecords" table became equal
			| 'Period'              | '#' | 'Activity' | 'Account Dr' | 'Ext. Dim. Debit'    | 'Extra dimension2 Dr' | 'Extra dimension3 Dr'        | 'Debit currency' | 'Debit amount' | 'DebitQuantity' | 'Account Cr' | 'Ext. Dim. Credit'            | 'Extra dimension2 Cr'                         | 'Extra dimension3 Cr' | 'Credit currency' | 'Credit amount' | 'Credit quantity' | 'Amount' | 'Operation'                                                               |
			| '02.03.2023 15:00:00' | '1' | 'Yes'      | '9100'       | 'Business unit 1'    | ''                    | ''                           | 'TRY'            | '158,33'       | ''              | '4010'       | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | 'Business unit 1'     | 'TRY'             | '158,33'        | ''                | '158,33' | 'SalesReturn DR (R5021T_Revenues) CR (R2021B_CustomersTransactions)'      |
			| '02.03.2023 15:00:00' | '2' | 'Yes'      | '5304'       | ''                   | ''                    | ''                           | 'TRY'            | '31,67'        | ''              | '4010'       | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | 'Business unit 1'     | 'TRY'             | '31,67'         | ''                | '31,67'  | 'SalesReturn DR (R1040B_TaxesOutgoing) CR (R2021B_CustomersTransactions)' |
			| '02.03.2023 15:00:00' | '3' | 'Yes'      | '420.1'      | 'Item with item key' | 'Business unit 1'     | 'Purchase of goods for sale' | 'TRY'            | '-50'          | ''              | '3540'       | 'Item with item key'          | 'S/Color 1'                                   | 'Business unit 1'     | 'TRY'             | '-50'           | '-1'              | '-50,00' | 'SalesReturn DR (R5022T_Expenses) CR (R4050B_StockInventory)'             |		
		Then the number of "RegisterRecords" table lines is "равно" "3"
	And I close all client application windows

Scenario: _0991094 check Sales return accounting movements (service)
	And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number' |
			| '112'    |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button	
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit" | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"            | "Operation"                                                               | "Extra dimension2 Cr"                         | "Credit amount" | "Extra dimension3 Cr" |
			| "20.03.2024 11:27:09" | "9100"       | "8,33"   | ""              | "Yes"      | "TRY"             | "Business unit 2" | "8,33"         | ""                    | ""                | ""                    | "TRY"            | "4010"       | "Customer 2 (2 partner term)" | "SalesReturn DR (R5021T_Revenues) CR (R2021B_CustomersTransactions)"      | "Individual partner term 1 (by partner term)" | "8,33"          | "Business unit 2"     |
			| "20.03.2024 11:27:09" | "5304"       | "1,67"   | ""              | "Yes"      | "TRY"             | ""                | "1,67"         | ""                    | ""                | ""                    | "TRY"            | "4010"       | "Customer 2 (2 partner term)" | "SalesReturn DR (R1040B_TaxesOutgoing) CR (R2021B_CustomersTransactions)" | "Individual partner term 1 (by partner term)" | "1,67"          | "Business unit 2"     |
		Then the number of "RegisterRecords" table lines is "равно" "2"
	And I close all client application windows

Scenario: _0991095 check Purchase return accounting movements (product)
	And I close all client application windows
	* Select PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button	
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"           | "Debit amount" | "Extra dimension2 Dr"        | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"   | "Operation"                                                                 | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "24.02.2023 17:01:27" | "5201"       | "1" | "183,33" | ""              | "Yes"      | "TRY"             | "Vendor 1 (1 partner term)" | "183,33"       | "Partner term with vendor 1" | "2"               | "Business unit 1"     | "TRY"            | "3540"       | "Item with item key" | "PurchaseReturn DR (R1021B_VendorsTransactions) CR (R4050B_StockInventory)" | "S/Color 1"           | "183,33"        | "Business unit 1"     |		
			| "24.02.2023 17:01:27" | "5201"       | "2" | "36,67"  | ""              | "Yes"      | "TRY"             | "Vendor 1 (1 partner term)" | "36,67"        | "Partner term with vendor 1" | ""                | "Business unit 1"     | "TRY"            | "5303"       | ""                   | "PurchaseReturn DR (R1021B_VendorsTransactions) CR (R2040B_TaxesIncoming)"  | ""                    | "36,67"         | ""                    |
		Then the number of "RegisterRecords" table lines is "равно" "2"
	And I close all client application windows

Scenario: _0991096 check Purchase return accounting movements (service and product)
	And I close all client application windows
	* Select PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '112'    |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button	
		And "RegisterRecords" table contains lines
			| "Period"              | "Account Dr" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit" | "Debit amount" | "Extra dimension2 Dr"                                    | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"   | "Operation"                                                                 | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "20.03.2024 11:28:01" | "5201"       | "33,33"  | ""              | "Yes"      | "TRY"             | "Vendor 6"        | "33,33"        | "Partner term with vendor (advance payment by document)" | ""                | ""                    | "TRY"            | "5303"       | ""                   | "PurchaseReturn DR (R1021B_VendorsTransactions) CR (R2040B_TaxesIncoming)"  | ""                    | "33,33"         | ""                    |
			| "20.03.2024 11:28:01" | "5201"       | "8,33"   | ""              | "Yes"      | "TRY"             | "Vendor 6"        | "8,33"         | "Partner term with vendor (advance payment by document)" | ""                | "Business unit 2"     | "TRY"            | "5303"       | ""                   | "PurchaseReturn DR (R1021B_VendorsTransactions) CR (R2040B_TaxesIncoming)"  | ""                    | "8,33"          | ""                    |
			| "20.03.2024 11:28:01" | "5201"       | "166,67" | ""              | "Yes"      | "TRY"             | "Vendor 6"        | "166,67"       | "Partner term with vendor (advance payment by document)" | "1"               | ""                    | "TRY"            | "3540"       | "Item with item key" | "PurchaseReturn DR (R1021B_VendorsTransactions) CR (R4050B_StockInventory)" | "S/Color 1"           | "166,67"        | ""                    |
			| "20.03.2024 11:28:01" | "5201"       | "41,67"  | ""              | "Yes"      | "TRY"             | "Vendor 6"        | "41,67"        | "Partner term with vendor (advance payment by document)" | ""                | "Business unit 2"     | "TRY"            | "3250"       | ""                   | "PurchaseReturn DR (R1021B_VendorsTransactions) CR (R4050B_StockInventory)" | "Own company 2"       | "41,67"         | "Business unit 2"     |
		Then the number of "RegisterRecords" table lines is "равно" "4"
	And I close all client application windows

Scenario: _0991100 check Cash payment accounting movements
	And I close all client application windows
	* Select CP
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'                   | 'Business unit'   | 'Company'                    | 'Partner term'               | 'Credit' | 'Cash/Bank account'         | 'Operation'                                                                                   |
			| '5201'  | 'Vendor 1 (1 partner term)' | 'Business unit 1' | 'Vendor 1'                   | 'Partner term with vendor 1' | '3240'   | 'Cash, TRY'                 | 'CashPayment DR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions) CR (R3010B_CashOnHand)' |
			| '5201'  | 'Business unit 1'           | 'Business unit 1' | 'Partner term with vendor 1' | 'Partner term with vendor 1' | '4020.2' | 'Vendor 1 (1 partner term)' | 'CashPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                   |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'           | 'Debit amount' | 'Extra dimension2 Dr'        | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                                                   | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr'       |
			| '24.02.2023 10:50:30' | '5201'       | '1' | '500,00' | ''              | 'Yes'      | 'TRY'             | 'Vendor 1 (1 partner term)' | '500'          | 'Partner term with vendor 1' | ''                | 'Business unit 1'     | 'TRY'            | '3240'       | 'Cash, TRY'        | 'CashPayment DR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions) CR (R3010B_CashOnHand)' | 'Vendor 1'            | '500'           | 'Vendor 1 (1 partner term)' |		
	And I close all client application windows	
						
Scenario: _0991110 check Cash receipt accounting movements
	And I close all client application windows
	* Select CR
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account'            | 'Company'                                                 | 'Partner'                      | 'Business unit'   | 'Credit' | 'Partner term'                                            | 'Operation'                                                                                         |
			| '3240'  | 'Cash, TRY'                    | 'Client 1'                                                | 'Customer 1 (3 partner terms)' | 'Business unit 1' | '4010'   | 'Partner term with customer (by document + credit limit)' | 'CashReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)' |
			| '5202'  | 'Customer 1 (3 partner terms)' | 'Partner term with customer (by document + credit limit)' | 'Customer 1 (3 partner terms)' | 'Business unit 1' | '4010'   | 'Partner term with customer (by document + credit limit)' | 'CashReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                   |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr'          | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'             | 'Operation'                                                                                         | 'Extra dimension2 Cr'                                     | 'Credit amount' | 'Extra dimension3 Cr' |
			| '10.03.2023 00:00:00' | '3240'       | '1' | '950,00' | ''              | 'Yes'      | 'TRY'             | 'Cash, TRY'       | '950'          | 'Client 1'            | ''                | 'Customer 1 (3 partner terms)' | 'TRY'            | '4010'       | 'Customer 1 (3 partner terms)' | 'CashReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)' | 'Partner term with customer (by document + credit limit)' | '950'           | 'Business unit 1'     |
			| '10.03.2023 00:00:00' | '3240'       | '2' | '400,00' | ''              | 'Yes'      | 'TRY'             | 'Cash, TRY'       | '400'          | 'Client 2'            | ''                | 'Customer 2 (2 partner term)'  | 'TRY'            | '4010'       | 'Customer 2 (2 partner term)'  | 'CashReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)' | 'Individual partner term 1 (by partner term)'             | '400'           | 'Business unit 1'     |		
	And I close all client application windows

Scenario: _0991120 check Cash expense accounting movements
	And I close all client application windows
	* Select CE
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner' | 'Business unit'   | 'Company'       | 'Expense and revenue type' | 'Credit' | 'Cash/Bank account' | 'Operation'                                               |
			| '420.2' | ''        | 'Business unit 1' | 'Own company 2' | 'Other expence'            | '3240'   | 'Cash, TRY'         | 'CashExpense DR (R5022T_Expenses) CR (R3010B_CashOnHand)' |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                               | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 10:52:43' | '420.2'      | '1' | '180,00' | ''              | 'Yes'      | 'TRY'             | ''                | '180'          | 'Business unit 1'     | ''                | 'Other expence'       | 'TRY'            | '3240'       | 'Cash, TRY'        | 'CashExpense DR (R5022T_Expenses) CR (R3010B_CashOnHand)' | 'Own company 2'       | '180'           | ''                    |		
	And I close all client application windows

Scenario: _0991130 check Cash revenue accounting movements
	And I close all client application windows
	* Select CR
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account' | 'Company'       | 'Partner' | 'Business unit'   | 'Credit' | ' ' | 'Operation'                                              |
			| '3240'  | 'Cash, TRY'         | 'Own company 2' | ''        | 'Business unit 1' | '9100'   | ''  | 'CashRevenue DR (R3010B_CashOnHand) CR (R5021_Revenues)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                              | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 10:53:15' | '3240'       | '1' | '12,00'  | ''              | 'Yes'      | 'TRY'             | 'Cash, TRY'       | '12'           | 'Own company 2'       | ''                | ''                    | 'TRY'            | '9100'       | 'Business unit 1'  | 'CashRevenue DR (R3010B_CashOnHand) CR (R5021_Revenues)' | 'Own company 2'       | '12'            | ''                    |			
	And I close all client application windows

Scenario: _0991140 check Debit note accounting movements (Vendor)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "Transactions" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'                   | 'Business unit'             | 'Company'                    | 'Partner term'               | 'Credit' | ' '               | 'Operation'                                                               |
			| '5201'  | 'Vendor 1 (1 partner term)' | 'Business unit 1'           | 'Vendor 1'                   | 'Partner term with vendor 1' | '9100'   | ''                | 'DebitNote DR (R1021B_VendorsTransactions) CR (R5021_Revenues)'           |
			| '5201'  | 'Vendor 1 (1 partner term)' | 'Vendor 1 (1 partner term)' | 'Partner term with vendor 1' | 'Partner term with vendor 1' | '4020.2' | 'Business unit 1' | 'DebitNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'           | 'Debit amount' | 'Extra dimension2 Dr'        | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                     | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 11:03:25' | '5201'       | '1' | '25,00'  | ''              | 'Yes'      | 'TRY'             | 'Vendor 1 (1 partner term)' | '25'           | 'Partner term with vendor 1' | ''                | 'Business unit 1'     | 'TRY'            | '9100'       | 'Business unit 1'  | 'DebitNote DR (R1021B_VendorsTransactions) CR (R5021_Revenues)' | 'Vendor 1'            | '25'            | ''                    |		
	And I close all client application windows

Scenario: _0991141 check Debit note accounting movements (Customer)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'              | 'Debit amount' | 'Extra dimension2 Dr'                                     | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                       | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '01.04.2023 14:10:35' | '4010'       | '1' | '40,00'  | ''              | 'Yes'      | 'TRY'             | 'Customer 1 (3 partner terms)' | '40'           | 'Partner term with customer (by document + credit limit)' | ''                | 'Business unit 1'     | 'TRY'            | '9100'       | 'Business unit 1'  | 'DebitNote DR (R2021B_CustomersTransactions) CR (R5021_Revenues)' | 'Client 1'            | '40'            | ''                    |	
	And I close all client application windows

Scenario: _0991142 check Debit note accounting movements (Other)
	And I close all client application windows
	* Select Debit note
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I go to line in "List" table
			| 'Number' |
			| '6'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "Transactions" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Business unit'   | 'Company'         | 'Partner'        | 'Credit' | 'Operation'                                                           |
			| '9200'  | 'Business unit 3' | 'Other partner 2' | 'Other partner 2'| '9100'   | 'DebitNote DR (R5015B_OtherPartnersTransactions) CR (R5021_Revenues)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                           | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '21.04.2024 20:40:55' | '9200'       | '1' | '150,00' | ''              | 'Yes'      | 'TRY'             | 'Business unit 3' | '150'          | 'Other partner 2'     | ''                | 'Other partner 2'     | 'TRY'            | '9100'       | 'Business unit 3'  | 'DebitNote DR (R5015B_OtherPartnersTransactions) CR (R5021_Revenues)' | 'Other partner 2'     | '150'           | ''                    |
	And I close all client application windows

Scenario: _0991145 check Credit note accounting movements (Customer)
	And I close all client application windows
	* Select Credit note
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "Transactions" I click "Edit accounting" button		
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'                     | 'Business unit'   | 'Expense and revenue type' | 'Partner term'                                | 'Credit' | 'Operation'                                                                      |
			| '420.2' | 'Customer 2 (2 partner term)' | 'Business unit 1' | 'Other expence'            | 'Individual partner term 1 (by partner term)' | '4010'   | 'CreditNote DR (R5022T_Expenses) CR (R2021B_CustomersTransactions)'              |
			| '5202'  | 'Customer 2 (2 partner term)' | 'Business unit 1' | 'Business unit 1'          | 'Individual partner term 1 (by partner term)' | '4010'   | 'CreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'             | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'            | 'Operation'                                                         | 'Extra dimension2 Cr'                         | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 11:02:48' | '420.2'      | '1' | '15,00'  | ''              | 'Yes'      | 'TRY'             | 'Customer 2 (2 partner term)' | '15'           | 'Business unit 1'     | ''                | 'Other expence'       | 'TRY'            | '4010'       | 'Customer 2 (2 partner term)' | 'CreditNote DR (R5022T_Expenses) CR (R2021B_CustomersTransactions)' | 'Individual partner term 1 (by partner term)' | '15'            | 'Business unit 1'     |		
	And I close all client application windows

Scenario: _0991146 check Credit note accounting movements (Vendor)
	And I close all client application windows
	* Select Credit note
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "Transactions" I click "Edit accounting" button		
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'  | 'Business unit'   | 'Expense and revenue type' | 'Partner term'                                           | 'Credit' | 'Operation'                                                                |
			| '420.2' | 'Vendor 5' | 'Business unit 1' | 'Other expence'            | 'Partner term with vendor (advance payment by document)' | '5201'   | 'CreditNote DR (R5022T_Expenses) CR (R1021B_VendorsTransactions)'          |
			| '5201'  | 'Vendor 5' | 'Business unit 1' | 'Business unit 1'          | 'Partner term with vendor (advance payment by document)' | '4020.2' | 'CreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                       | 'Extra dimension2 Cr'                                    | 'Credit amount' | 'Extra dimension3 Cr' |
			| '27.03.2024 14:45:40' | '420.2'      | '1' | '50,00'  | ''              | 'Yes'      | 'TRY'             | 'Vendor 5'        | '50'           | 'Business unit 1'     | ''                | 'Other expence'       | 'TRY'            | '5201'       | 'Vendor 5'         | 'CreditNote DR (R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor (advance payment by document)' | '50'            | 'Business unit 1'     |		
	And I close all client application windows

Scenario: _0991147 check Credit note accounting movements (Other)
	And I close all client application windows
	* Select Credit note
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '6'      |
		And in the table "List" I click the button named "ListContextMenuPost"		
		And I select current line in "List" table
	* Check accounting movements
		And in the table "Transactions" I click "Edit accounting" button		
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'       | 'Business unit'   | 'Company'       | 'Expense and revenue type' | 'Credit' | 'Partner'       | 'Operation'                                                             |
			| '420.2' | 'Other partner' | 'Business unit 1' | 'Other partner' | 'Other expence'            | '9200'   | 'Other partner' | 'CreditNote DR (R5022T_Expenses) CR (R5015B_OtherPartnersTransactions)' |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '21.03.2024 12:00:00' | '420.2'      | '1' | '100,00' | ''              | 'Yes'      | 'TRY'             | 'Other partner'   | '100'          | 'Business unit 1'     | ''                | 'Other expence'       | 'TRY'            | '9200'       | 'Business unit 1'  | 'CreditNote DR (R5022T_Expenses) CR (R5015B_OtherPartnersTransactions)' | 'Other partner'       | '100'           | 'Other partner'       |
	And I close all client application windows

Scenario: _0991150 check Retail sales receipt accounting movements
	And I close all client application windows
	* Select RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
	* Check accounting movements
		And in the table "ItemList" I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Item'               | 'Business unit'   | 'Expense and revenue type'   | 'Credit' | 'Item key'   | 'Operation'                                                          |
			| '420.1' | 'Item with item key' | 'Business unit 3' | 'Purchase of goods for sale' | '3540'   | 'XS/Color 2' | 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'    | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr'        | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'   | 'Operation'                                                          | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '25.02.2023 15:00:00' | '420.1'      | '1' | '100,00' | ''              | 'Yes'      | 'TRY'             | 'Item with item key' | '100'          | 'Business unit 3'     | '2'               | 'Purchase of goods for sale' | 'TRY'            | '3540'       | 'Item with item key' | 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)' | 'XS/Color 2'          | '100'           | 'Business unit 3'     |			
			| '25.02.2023 15:00:00' | '420.1'      | '2' | '50,00'  | ''              | 'Yes'      | 'TRY'             | 'Item with item key' | '50'           | 'Business unit 3'     | '1'               | 'Purchase of goods for sale' | 'TRY'            | '3540'       | 'Item with item key' | 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)' | 'S/Color 1'           | '50'            | 'Business unit 3'     |
	And I close all client application windows

Scenario: _0991160 check Employee cash advance accounting movements (with PI and VAT)
	And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"    | "Business unit"   | "Partner term"             | "Credit" | " " | "Operation"                                                                           |
			| "5201"  | "Employee 1" | "Business unit 1" | "Vendor 4 (partner term) " | "4020.1" | ""  | "EmployeeCashAdvance DR (R1021B_VendorsTransactions) CR (R3027B_EmployeeCashAdvance)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'           | 'Debit amount' | 'Extra dimension2 Dr'      | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                                           | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '22.03.2024 11:52:17' | '5201'       | '1' | '200,00' | ''              | 'Yes'      | 'TRY'             | 'Vendor 4 (1 partner term)' | '200'          | 'Vendor 4 (partner term) ' | ''                | 'Business unit 1'     | 'TRY'            | '4020.1'     | 'Employee 1'       | 'EmployeeCashAdvance DR (R1021B_VendorsTransactions) CR (R3027B_EmployeeCashAdvance)' | 'Business unit 1'     | '200'           | ''                    |
		And I close all client application windows

Scenario: _0991161 check Employee cash advance accounting movements (without PI, VAT)
	And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"    | "Business unit"   | "Expense and revenue type" | "Credit" | " " | "Operation"                                                                     |
			| "420.2" | "Employee 1" | "Business unit 1" | "Other expence"            | "4020.1" | ""  | "EmployeeCashAdvance DR (R5022T_Expenses) CR (R3027B_EmployeeCashAdvance)"      |
			| "5301"  | "Employee 1" | "Business unit 1" | ""                         | "4020.1" | ""  | "EmployeeCashAdvance DR (R1040B_TaxesOutgoing) CR (R3027B_EmployeeCashAdvance)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit" | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit" | "Operation"                                                                     | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "01.07.2023 00:00:00" | "420.2"      | "1" | "833,33" | ""              | "Yes"      | "TRY"             | "Employee 1"      | "833,33"       | "Business unit 1"     | ""                | "Other expence"       | "TRY"            | "4020.1"     | "Employee 1"       | "EmployeeCashAdvance DR (R5022T_Expenses) CR (R3027B_EmployeeCashAdvance)"      | "Business unit 1"     | "833,33"        | ""                    |		
			| "01.07.2023 00:00:00" | "5301"       | "2" | "166,67" | ""              | "Yes"      | "TRY"             | "VAT"             | "166,67"       | "Business unit 1"     | ""                | ""                    | "TRY"            | "4020.1"     | "Employee 1"       | "EmployeeCashAdvance DR (R1040B_TaxesOutgoing) CR (R3027B_EmployeeCashAdvance)" | "Business unit 1"     | "166,67"        | ""                    |
		And I close all client application windows

Scenario: _0991162 check Employee cash advance accounting movements (without PI and VAT)
	And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "PaymentList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"    | "Business unit"   | "Expense and revenue type" | "Credit" | " " | "Operation"                                                                     |
			| "420.2" | "Employee 2" | "Business unit 1" | "Other expence"            | "4020.1" | ""  | "EmployeeCashAdvance DR (R5022T_Expenses) CR (R3027B_EmployeeCashAdvance)"      |
			| "5301"  | "Employee 2" | "Business unit 1" | ""                         | "4020.1" | ""  | "EmployeeCashAdvance DR (R1040B_TaxesOutgoing) CR (R3027B_EmployeeCashAdvance)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit" | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit" | "Operation"                                                                | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "01.08.2023 12:00:00" | "420.2"      | "1" | "500,00" | ""              | "Yes"      | "TRY"             | "Employee 2"      | "500"          | "Business unit 1"     | ""                | "Other expence"       | "TRY"            | "4020.1"     | "Employee 2"       | "EmployeeCashAdvance DR (R5022T_Expenses) CR (R3027B_EmployeeCashAdvance)" | "Business unit 1"     | "500"           | ""                    |		
		And I close all client application windows
	

Scenario: _0991170 check Expense accruals accounting movements (without basis)
	And I close all client application windows
	* Select ExpenseAccruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "CostList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner' | 'Business unit'   | 'Expense and revenue type' | 'Credit' | ' ' | 'Operation'                                                             |
			| '420.5' | ''        | 'Business unit 1' | 'Rent'                     | '970.1'  | ''  | 'ExpenseAccruals DR (R5022T_Expenses) CR (R6070T_OtherPeriodsExpenses)' |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'    | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '30.01.2024 00:00:00' | '420.5'      | '1' | '32 704,90' | ''              | 'Yes'      | 'EUR'             | ''                | '1 000'        | 'Business unit 1'     | ''                | 'Rent'                | 'EUR'            | '970.1'      | ''                 | 'ExpenseAccruals DR (R5022T_Expenses) CR (R6070T_OtherPeriodsExpenses)' | ''                    | '1 000'         | ''                    |
		And I close all client application windows

Scenario: _0991171 check Expense accruals accounting movements (basis - Expense accrual, Void)
	And I close all client application windows
	* Select ExpenseAccruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "CostList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner' | 'Business unit'   | 'Expense and revenue type' | 'Credit' | ' ' | 'Operation'                                                             |
			| '420.5' | ''        | 'Business unit 1' | 'Rent'                     | '970.1'  | ''  | 'ExpenseAccruals DR (R5022T_Expenses) CR (R6070T_OtherPeriodsExpenses)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'     | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '01.02.2024 12:00:00' | '420.5'      | '1' | '-32 704,90' | ''              | 'Yes'      | 'EUR'             | ''                | '-1 000'       | 'Business unit 1'     | ''                | 'Rent'                | 'EUR'            | '970.1'      | ''                 | 'ExpenseAccruals DR (R5022T_Expenses) CR (R6070T_OtherPeriodsExpenses)' | ''                    | '-1 000'        | ''                    |		
		And I close all client application windows

Scenario: _0991172 check Expense accruals accounting movements (basis - Expense accrual, Reverse)
	And I close all client application windows
	* Select ExpenseAccruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number' |
			| '4'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "CostList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | ' ' | 'Credit' | 'Partner' | 'Business unit'   | 'Expense and revenue type' | 'Operation'                                                             |
			| '970.1' | ''  | '420.5'  | ''        | 'Business unit 1' | 'Rent'                     | 'ExpenseAccruals DR (R6070T_OtherPeriodsExpenses) CR (R5022T_Expenses)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'    | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '01.03.2024 12:00:00' | '970.1'      | '1' | '35 975,39' | ''              | 'Yes'      | 'EUR'             | ''                | '1 100'        | ''                    | ''                | ''                    | 'EUR'            | '420.5'      | ''                 | 'ExpenseAccruals DR (R6070T_OtherPeriodsExpenses) CR (R5022T_Expenses)' | 'Business unit 1'     | '1 100'         | 'Rent'                |
		Then the form attribute named "Basis" became equal to "Expense accrual 4 dated 01.03.2024 12:00:00"
		Then the form attribute named "Company" became equal to "Own company 2"
		Then the form attribute named "LedgerType" became equal to "Basic LTV"						
		And I close all client application windows

Scenario: _0991173 check Expense accruals accounting movements (basis - Purchase invoice)
	And I close all client application windows
	* Select ExpenseAccruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number' |
			| '5'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "CostList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner' | 'Business unit'   | 'Expense and revenue type' | 'Credit' | ' ' | 'Operation'                                                             |
			| '420.5' | ''        | 'Business unit 1' | 'Rent'                     | '970.1'  | ''  | 'ExpenseAccruals DR (R5022T_Expenses) CR (R6070T_OtherPeriodsExpenses)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '28.02.2024 12:00:00' | '420.5'      | '1' | '2 500,00' | ''              | 'Yes'      | 'TRY'             | ''                | '2 500'        | 'Business unit 1'     | ''                | 'Rent'                | 'TRY'            | '970.1'      | ''                 | 'ExpenseAccruals DR (R5022T_Expenses) CR (R6070T_OtherPeriodsExpenses)' | ''                    | '2 500'         | ''                    |	
		Then the form attribute named "Company" became equal to "Own company 2"
		Then the form attribute named "LedgerType" became equal to "Basic LTV"						
		And I close all client application windows

Scenario: _0991174 check Revenue accruals accounting movements (without basis)
	And I close all client application windows
	* Select RevenueAccruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "CostList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | ' ' | 'Credit' | 'Business unit'   | 'Company'       | 'Operation'                                                             |
			| '980.1' | ''  | '9100'   | 'Business unit 1' | 'Own company 2' | 'RevenueAccruals DR (R6080T_OtherPeriodsRevenues) CR (R5021T_Revenues)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '30.01.2024 12:00:00' | '980.1'      | '1' | '1 000,00' | ''              | 'Yes'      | 'TRY'             | ''                | '1 000'        | ''                    | ''                | ''                    | 'TRY'            | '9100'       | 'Business unit 1'  | 'RevenueAccruals DR (R6080T_OtherPeriodsRevenues) CR (R5021T_Revenues)' | 'Own company 2'       | '1 000'         | ''                    |
		And I close all client application windows

Scenario: _0991175 check Revenue accruals accounting movements (basis - Revenue accrual, Reverse)
	And I close all client application windows
	* Select RevenueAccruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "CostList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Business unit'   | 'Company'       | ' ' | 'Credit' | 'Operation'                                                             |
			| '9100'  | 'Business unit 1' | 'Own company 2' | ''  | '980.1'  | 'RevenueAccruals DR (R5021T_Revenues) CR (R6080T_OtherPeriodsRevenues)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '01.02.2024 12:00:00' | '9100'       | '1' | '1 000,00' | ''              | 'Yes'      | 'TRY'             | 'Business unit 1' | '1 000'        | 'Own company 2'       | ''                | ''                    | 'TRY'            | '980.1'      | ''                 | 'RevenueAccruals DR (R5021T_Revenues) CR (R6080T_OtherPeriodsRevenues)' | ''                    | '1 000'         | ''                    |
		And I close all client application windows

Scenario: _0991176 check Revenue accruals accounting movements (basis - Revenue accrual, Void)
	And I close all client application windows
	* Select RevenueAccruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number' |
			| '4'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "CostList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | ' ' | 'Credit' | 'Business unit'   | 'Company'       | 'Operation'                                                             |
			| '980.1' | ''  | '9100'   | 'Business unit 1' | 'Own company 2' | 'RevenueAccruals DR (R6080T_OtherPeriodsRevenues) CR (R5021T_Revenues)' |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'    | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '01.03.2024 12:00:00' | '980.1'      | '1' | '-1 000,00' | ''              | 'Yes'      | 'TRY'             | ''                | '-1 000'       | ''                    | ''                | ''                    | 'TRY'            | '9100'       | 'Business unit 1'  | 'RevenueAccruals DR (R6080T_OtherPeriodsRevenues) CR (R5021T_Revenues)' | 'Own company 2'       | '-1 000'        | ''                    |
		Then the form attribute named "Basis" became equal to "Revenue accrual 4 dated 01.03.2024 12:00:00"
		Then the form attribute named "Company" became equal to "Own company 2"
		Then the form attribute named "LedgerType" became equal to "Basic LTV"						
		And I close all client application windows

Scenario: _0991177 check Revenue accruals accounting movements (basis - Sales invoice)
	And I close all client application windows
	* Select RevenueAccruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number' |
			| '5'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "CostList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | ' ' | 'Credit' | 'Business unit' | 'Company'       | 'Operation'                                                             |
			| '980.1' | ''  | '9100'   | ''              | 'Own company 2' | 'RevenueAccruals DR (R6080T_OtherPeriodsRevenues) CR (R5021T_Revenues)' |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                             | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '28.02.2024 12:00:00' | '980.1'      | '1' | '2 500,00' | ''              | 'Yes'      | 'TRY'             | ''                | '2 500'        | ''                    | ''                | ''                    | 'TRY'            | '9100'       | ''                 | 'RevenueAccruals DR (R6080T_OtherPeriodsRevenues) CR (R5021T_Revenues)' | 'Own company 2'       | '2 500'         | ''                    |		
		Then the form attribute named "Company" became equal to "Own company 2"
		Then the form attribute named "LedgerType" became equal to "Basic LTV"						
		And I close all client application windows

Scenario: _0991190 check Money transfer accounting movements (Currency exchange)
	And I close all client application windows
	* Select MT
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click the button named "EditAccounting"
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Cash/Bank account' | 'Company'       | 'Business unit'   | 'Credit' | 'Operation'                                                      |
			| '3250'  | 'Bank account, TRY' | 'Own company 2' | 'Business unit 3' | '3250'   | 'MoneyTransfer DR (R3010B_CashOnHand) CR (R3010B_CashOnHand)'    |
			| '3221'  | 'Bank account, TRY' | 'Own company 2' | 'Business unit 3' | '3250'   | 'MoneyTransfer DR (R3021B_CashInTransit) CR (R3010B_CashOnHand)' |
			| '3250'  | 'Transit, TRY'      | 'Own company 2' | ''                | '3221'   | 'MoneyTransfer DR (R3010B_CashOnHand) CR (R3021B_CashInTransit)' |
			| '3221'  | 'Business unit 3'   | 'Own company 2' | ''                | '9101'   | 'MoneyTransfer DR (R3021B_CashInTransit) CR (R5021T_Revenues)'   |
			| '420.5' | 'Transit, TRY'      | 'Own company 2' | ''                | '3221'   | 'MoneyTransfer DR (R5022T_Expenses) CR (R3021B_CashInTransit)'   |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table contains lines
			| 'Period'              | 'Account Dr' | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'   | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'  | 'Operation'                                                      | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '10.02.2023 12:00:00' | '3221'       | '1 000,00' | ''              | 'Yes'      | 'TRY'             | 'Transit, TRY'      | '1 000'        | 'Own company 2'       | ''                | ''                    | 'TRY'            | '3250'       | 'Bank account, TRY' | 'MoneyTransfer DR (R3021B_CashInTransit) CR (R3010B_CashOnHand)' | 'Own company 2'       | '1 000'         | 'Business unit 3'     |
			| '10.02.2023 12:00:00' | '3250'       | '1 011,57' | ''              | 'Yes'      | 'EUR'             | 'Bank account, EUR' | '50'           | 'Own company 2'       | ''                | 'Business unit 3'     | 'EUR'            | '3221'       | 'Transit, TRY'      | 'MoneyTransfer DR (R3010B_CashOnHand) CR (R3021B_CashInTransit)' | 'Own company 2'       | '50'            | ''                    |
			| '10.02.2023 12:00:00' | '3221'       | '11,57'    | ''              | 'Yes'      | 'TRY'             | 'Transit, TRY'      | '11,57'        | 'Own company 2'       | ''                | ''                    | 'TRY'            | '9101'       | 'Business unit 3'   | 'MoneyTransfer DR (R3021B_CashInTransit) CR (R5021T_Revenues)'   | 'Own company 2'       | '11,57'         | ''                    |
		Then the number of "RegisterRecords" table lines is "равно" "3"
	And I close all client application windows

Scenario: _0991195 check Payroll accounting movements (acruals, deductions, taxes)
	And I close all client application windows
	* Select Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table contains lines
			| "Period"              | "Account Dr" | "Amount"    | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit" | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr"   | "Debit currency" | "Account Cr" | "Ext. Dim. Credit" | "Operation"                                                                         | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "31.01.2023 12:00:00" | "420.3"      | "3 272,73"  | ""              | "Yes"      | "TRY"             | "Employee 2"      | "3 272,73"     | "Business unit 2"     | ""                | "Salary (expense)"      | "TRY"            | "9200"       | "Business unit 2"  | "Payroll DR (R5022T_Expenses) CR (R5015B_OtherPartnersTransactions) (Taxes)"        | "Own company 2"       | "3 272,73"      | "Tax authority"       |
			| "31.01.2023 12:00:00" | "420.3"      | "3 660,36"  | ""              | "Yes"      | "TRY"             | "Employee 1"      | "3 660,36"     | "Business unit 2"     | ""                | "Salary (expense)"      | "TRY"            | "9200"       | "Business unit 2"  | "Payroll DR (R5022T_Expenses) CR (R5015B_OtherPartnersTransactions) (Taxes)"        | "Own company 2"       | "3 660,36"      | "Tax authority"       |
			| "31.01.2023 12:00:00" | "420.2"      | "16 363,64" | ""              | "Yes"      | "TRY"             | "Employee 2"      | "16 363,64"    | "Business unit 2"     | ""                | "Other expence"         | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Accrual)"                  | ""                    | "16 363,64"     | ""                    |
			| "31.01.2023 12:00:00" | "420.2"      | "19 090,91" | ""              | "Yes"      | "TRY"             | "Employee 1"      | "19 090,91"    | "Business unit 2"     | ""                | "Other expence"         | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Accrual)"                  | ""                    | "19 090,91"     | ""                    |
			| "31.01.2023 12:00:00" | "420.3"      | "120,00"    | ""              | "Yes"      | "TRY"             | "Employee 1"      | "120"          | "Business unit 2"     | ""                | "Expence and revenue 1" | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Accrual)"                  | ""                    | "120"           | ""                    |
			| "31.01.2023 12:00:00" | "420.3"      | "-100,00"   | ""              | "Yes"      | "TRY"             | "Employee 1"      | "-100"         | "Business unit 2"     | ""                | "Expence and revenue 1" | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Deduction Is Not Revenue)" | ""                    | "-100"          | ""                    |
			| "31.01.2023 12:00:00" | "420.3"      | "-100,00"   | ""              | "Yes"      | "TRY"             | "Employee 2"      | "-100"         | "Business unit 2"     | ""                | "Expence and revenue 1" | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Deduction Is Not Revenue)" | ""                    | "-100"          | ""                    |
			| "31.01.2023 12:00:00" | "5401"       | "2 745,27"  | ""              | "Yes"      | "TRY"             | ""                | "2 745,27"     | ""                    | ""                | ""                      | "TRY"            | "9200"       | ""                 | "Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)"   | "Own company 2"       | "2 745,27"      | "Tax authority"       |
			| "31.01.2023 12:00:00" | "5401"       | "1 830,18"  | ""              | "Yes"      | "TRY"             | ""                | "1 830,18"     | ""                    | ""                | ""                      | "TRY"            | "9200"       | ""                 | "Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)"   | "Own company 2"       | "1 830,18"      | "Tax authority"       |
			| "31.01.2023 12:00:00" | "5401"       | "2 454,55"  | ""              | "Yes"      | "TRY"             | ""                | "2 454,55"     | ""                    | ""                | ""                      | "TRY"            | "9200"       | ""                 | "Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)"   | "Own company 2"       | "2 454,55"      | "Tax authority"       |
			| "31.01.2023 12:00:00" | "5401"       | "1 636,36"  | ""              | "Yes"      | "TRY"             | ""                | "1 636,36"     | ""                    | ""                | ""                      | "TRY"            | "9200"       | ""                 | "Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)"   | "Own company 2"       | "1 636,36"      | "Tax authority"       |
		Then the number of "RegisterRecords" table lines is "равно" "11"
	And I close all client application windows

Scenario: _0991196 check Payroll accounting movements (cash advance deduction)
	And I close all client application windows
	* Select Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I go to line in "List" table
			| 'Number' |
			| '4'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements (cash advance deduction)
		And I move to "Cash advance deduction" tab
		And in the table "CashAdvanceDeductionList" I click "Edit accounting cash advance deduction" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | ' ' | 'Credit' | 'Partner'    | 'Business unit' | 'Operation'                                                         |
			| '5401'  | ''  | '4020.1' | 'Employee 1' | ''              | 'Payroll DR (R9510B_SalaryPayment) CR (R3027B_EmployeeCashAdvance)' |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table contains lines
			| "Period"              | "Account Dr" | "Amount"    | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit" | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr"   | "Debit currency" | "Account Cr" | "Ext. Dim. Credit" | "Operation"                                                                         | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "30.04.2024 10:36:50" | "420.3"      | "3 600,00"  | ""              | "Yes"      | "TRY"             | "Employee 2"      | "3 600"        | "Business unit 2"     | ""                | "Salary (expense)"      | "TRY"            | "9200"       | "Business unit 2"  | "Payroll DR (R5022T_Expenses) CR (R5015B_OtherPartnersTransactions) (Taxes)"        | "Own company 2"       | "3 600"         | "Tax authority"       |
			| "30.04.2024 10:36:50" | "420.3"      | "4 100,00"  | ""              | "Yes"      | "TRY"             | "Employee 1"      | "4 100"        | "Business unit 2"     | ""                | "Salary (expense)"      | "TRY"            | "9200"       | "Business unit 2"  | "Payroll DR (R5022T_Expenses) CR (R5015B_OtherPartnersTransactions) (Taxes)"        | "Own company 2"       | "4 100"         | "Tax authority"       |
			| "30.04.2024 10:36:50" | "420.2"      | "19 475,00" | ""              | "Yes"      | "TRY"             | "Employee 1"      | "19 475"       | "Business unit 2"     | ""                | "Other expence"         | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Accrual)"                  | ""                    | "19 475"        | ""                    |
			| "30.04.2024 10:36:50" | "420.2"      | "18 000,00" | ""              | "Yes"      | "TRY"             | "Employee 2"      | "18 000"       | "Business unit 2"     | ""                | "Other expence"         | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Accrual)"                  | ""                    | "18 000"        | ""                    |
			| "30.04.2024 10:36:50" | "420.3"      | "-100,00"   | ""              | "Yes"      | "TRY"             | "Employee 1"      | "-100"         | "Business unit 2"     | ""                | "Expence and revenue 1" | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Deduction Is Not Revenue)" | ""                    | "-100"          | ""                    |
			| "30.04.2024 10:36:50" | "420.3"      | "-100,00"   | ""              | "Yes"      | "TRY"             | "Employee 2"      | "-100"         | "Business unit 2"     | ""                | "Expence and revenue 1" | "TRY"            | "5401"       | ""                 | "Payroll DR (R5022T_Expenses) CR (R9510B_SalaryPayment) (Deduction Is Not Revenue)" | ""                    | "-100"          | ""                    |
			| "30.04.2024 10:36:50" | "5401"       | "50,00"     | ""              | "Yes"      | "TRY"             | ""                | "50"           | ""                    | ""                | ""                      | "TRY"            | "4020.1"     | "Employee 1"       | "Payroll DR (R9510B_SalaryPayment) CR (R3027B_EmployeeCashAdvance)"                 | ""                    | "50"            | ""                    |
			| "30.04.2024 10:36:50" | "5401"       | "3 100,00"  | ""              | "Yes"      | "TRY"             | ""                | "3 100"        | ""                    | ""                | ""                      | "TRY"            | "9200"       | ""                 | "Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)"   | "Own company 2"       | "3 100"         | "Tax authority"       |
			| "30.04.2024 10:36:50" | "5401"       | "2 050,00"  | ""              | "Yes"      | "TRY"             | ""                | "2 050"        | ""                    | ""                | ""                      | "TRY"            | "9200"       | ""                 | "Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)"   | "Own company 2"       | "2 050"         | "Tax authority"       |
			| "30.04.2024 10:36:50" | "5401"       | "2 400,00"  | ""              | "Yes"      | "TRY"             | ""                | "2 400"        | ""                    | ""                | ""                      | "TRY"            | "9200"       | ""                 | "Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)"   | "Own company 2"       | "2 400"         | "Tax authority"       |
			| "30.04.2024 10:36:50" | "5401"       | "1 600,00"  | ""              | "Yes"      | "TRY"             | ""                | "1 600"        | ""                    | ""                | ""                      | "TRY"            | "9200"       | ""                 | "Payroll DR (R9510B_SalaryPayment) CR (R5015B_OtherPartnersTransactions) (Taxes)"   | "Own company 2"       | "1 600"         | "Tax authority"       |
		Then the number of "RegisterRecords" table lines is "равно" "11"
		And I close all client application windows

Scenario: _0991197 check CommissioningOfFixedAsset movements
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Number'  |
			| '14'      |	
		And in the table "List" I click the button named "ListContextMenuPost"
	* Select CommissioningOfFixedAsset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements (cash advance deduction)
		And in the table "ItemList" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Fixed asset'             | 'Business unit'   | ' ' | 'Item'          | 'Credit' | 'Item key'      | 'Operation'                                                                              |
			| '2020'  | 'Manufacturing Equipment' | 'Business unit 2' | ''  | 'Fixed asset 1' | '3540'   | 'Fixed asset 1' | 'CommissioningOfFixedAsset DR (R8510B_BookValueOfFixedAsset) CR (R4050B_StockInventory)' |			
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'         | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                                              | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '02.02.2024 00:00:00' | '2020'       | '1' | '200,00' | ''              | 'Yes'      | 'TRY'             | 'Manufacturing Equipment' | '200'          | 'Business unit 2'     | ''                | ''                    | 'TRY'            | '3540'       | 'Fixed asset 1'    | 'CommissioningOfFixedAsset DR (R8510B_BookValueOfFixedAsset) CR (R4050B_StockInventory)' | 'Fixed asset 1'       | '200'           | 'Business unit 2'     |		
		And I close all client application windows

Scenario: _0991198 check DepreciationCalculation movements
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Number'  |
			| '14'      |	
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay 5
	* Select DepreciationCalculation
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And in the table "Calculations" I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner' | 'Business unit'   | 'Expense and revenue type' | 'Credit' | ' ' | 'Operation'                                                                |
			| '420.3' | ''        | 'Business unit 2' | 'Expence and revenue 1'    | '7501'   | ''  | 'DepreciationCalculation DR (R5022T_Expenses) CR (DepreciationFixedAsset)' |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#' | 'Amount' | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit' | 'Debit amount' | 'Extra dimension2 Dr' | 'Credit quantity' | 'Extra dimension3 Dr'   | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit' | 'Operation'                                                                | 'Extra dimension2 Cr' | 'Credit amount' | 'Extra dimension3 Cr' |
			| '31.03.2024 00:00:00' | '420.3'      | '1' | '4,17'   | ''              | 'Yes'      | 'TRY'             | ''                | '4,17'         | 'Business unit 2'     | ''                | 'Expence and revenue 1' | 'TRY'            | '7501'       | ''                 | 'DepreciationCalculation DR (R5022T_Expenses) CR (DepreciationFixedAsset)' | ''                    | '4,17'          | ''                    |		
		And I close all client application windows	

Scenario: _0991212 check DebitCreditNote movements (CT-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit"  | "Partner"                            | "Business unit"   | "Partner term"          | "Credit" | "Operation"                                                                              |
			| "4020.2" | "Vendor and Customer (by documents)" | "Business unit 2" | "Partner term, TRY"     | "4010"   | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"   | "Vendor and Customer (by documents)" | "Business unit 2" | "Vendor (by documents)" | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                    | "Debit amount" | "Extra dimension2 Dr"   | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                   | "Operation"                                | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "23.02.2024 12:00:00" | "4020.2"     | "1" | "20,00"  | ""              | "Yes"      | "TRY"             | "Vendor and Customer (by documents)" | "1"            | "Vendor (by documents)" | ""                | "Business unit 2"     | "EUR"            | "4010"       | "Vendor and Customer (by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Partner term, TRY"   | "20"            | "Business unit 2"     |		
		And I close all client application windows	

Scenario: _0991213 check DebitCreditNote movements (CA-CT, by documents, same partner, Agreement currency - EURO, invoice and payment TRY)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                            | "Business unit"   | "Partner term"      | "Credit" | "Operation"                                                                                    |
			| "5202"  | "Vendor and Customer (by documents)" | "Business unit 2" | "Partner term, EUR" | "4010"   | "DebitCreditNote (R5020B_PartnersBalance)"                                                     |
			| "5202"  | "Vendor and Customer (by documents)" | "Business unit 2" | "Partner term, EUR" | "4010"   | "DebitCreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                    | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                   | "Operation"                                | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "20.02.2024 13:27:56" | "5202"       | "1" | "1 000,00" | ""              | "Yes"      | "EUR"             | "Vendor and Customer (by documents)" | "30,57"        | "Partner term, EUR"   | ""                | "Business unit 2"     | "EUR"            | "4010"       | "Vendor and Customer (by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Partner term, EUR"   | "30,57"         | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991214 check DebitCreditNote movements (CA-CA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                            | "Business unit"   | "Partner term"      | "Credit" | "Operation"                                                                                    |
			| "5202"  | "Vendor and Customer (by documents)" | "Business unit 2" | "Partner term, TRY" | "5202"   | "DebitCreditNote (R5020B_PartnersBalance)"                                                     |
			| "5202"  | "Vendor and Customer (by documents)" | "Business unit 2" | "Partner term, TRY" | "4010"   | "DebitCreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions) (Offset)" |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                    | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                   | "Operation"                                | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "30.03.2024 11:34:17" | "5202"       | "1" | "327,05" | ""              | "Yes"      | "TRY"             | "Vendor and Customer (by documents)" | "10"           | "Partner term, EUR"   | ""                | "Business unit 2"     | "EUR"            | "5202"       | "Vendor and Customer (by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Partner term, TRY"   | "380"           | "Business unit 2"     |		
		And I close all client application windows	

Scenario: _0991215 check DebitCreditNote movements (VA-VA, by documents, same partner)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '4'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit"  | "Partner"                            | "Business unit"   | "Partner term"            | "Credit" | "Operation"                                                                              |
			| "4020.2" | "Vendor and Customer (by documents)" | "Business unit 2" | "Vendor (by documents)"   | "4020.2" | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"   | "Vendor and Customer (by documents)" | "Business unit 2" | "Vendor (by documents) 2" | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                    | "Debit amount" | "Extra dimension2 Dr"     | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                   | "Operation"                                | "Extra dimension2 Cr"   | "Credit amount" | "Extra dimension3 Cr" |
			| "01.04.2024 11:48:58" | "4020.2"     | "1" | "2 616,39" | ""              | "Yes"      | "EUR"             | "Vendor and Customer (by documents)" | "80"           | "Vendor (by documents) 2" | ""                | "Business unit 2"     | "EUR"            | "4020.2"     | "Vendor and Customer (by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Vendor (by documents)" | "80"            | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991216 check DebitCreditNote movements (CT-CT, by partner terms, same partner, different branches)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '5'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                                   | "Business unit"   | "Partner term"                              | "Credit" | "Operation"                                                                                    |
			| "4010"  | "Customer (Transactions, by partner terms)" | "Business unit 3" | "Customer (Transacrions, by partner terms)" | "4010"   | "DebitCreditNote (R5020B_PartnersBalance)"                                                     |
			| "5202"  | "Customer (Transactions, by partner terms)" | "Business unit 3" | "Customer (Transacrions, by partner terms)" | "4010"   | "DebitCreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                           | "Debit amount" | "Extra dimension2 Dr"                       | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                          | "Operation"                                | "Extra dimension2 Cr"                       | "Credit amount" | "Extra dimension3 Cr" |
			| "02.04.2024 13:06:46" | "4010"       | "1" | "65,41"  | ""              | "Yes"      | "EUR"             | "Customer (Transactions, by partner terms)" | "2"            | "Customer (Transacrions, by partner terms)" | ""                | "Business unit 3"     | "EUR"            | "4010"       | "Customer (Transactions, by partner terms)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Customer (Transacrions, by partner terms)" | "2"             | "Business unit 3"     |		
		And I close all client application windows

Scenario: _0991217 check DebitCreditNote movements (VT-VT, by partner terms, same partner, different branches)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '6'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                                | "Business unit"   | "Partner term"                        | "Credit" | "Operation"                                                                              |
			| "5201"  | "Vendor (Transactions, by partner term)" | "Business unit 3" | "Vendor, transaction by partner term" | "5201"   | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"  | "Vendor (Transactions, by partner term)" | "Business unit 3" | "Vendor, transaction by partner term" | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                        | "Debit amount" | "Extra dimension2 Dr"                 | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                       | "Operation"                                | "Extra dimension2 Cr"                 | "Credit amount" | "Extra dimension3 Cr" |
			| "26.04.2024 13:20:20" | "5201"       | "1" | "3 564,83" | ""              | "Yes"      | "EUR"             | "Vendor (Transactions, by partner term)" | "109"          | "Vendor, transaction by partner term" | ""                | "Business unit 3"     | "EUR"            | "5201"       | "Vendor (Transactions, by partner term)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Vendor, transaction by partner term" | "109"           | "Business unit 3"     |		
		And I close all client application windows

Scenario: _0991218 check DebitCreditNote movements (VA-VT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '7'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                             | "Business unit"   | "Partner term"                        | "Credit" | "Operation"                                                                              |
			| "5201"  | "Vendor (Advance, by documents)"      | "Business unit 2" | "Vendor (Advance, by documents)"      | "4020.2" | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"  | "Vendor (Transactions, by documents)" | "Business unit 2" | "Vendor (Transactions, by documents)" | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                     | "Debit amount" | "Extra dimension2 Dr"                 | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"               | "Operation"                                | "Extra dimension2 Cr"            | "Credit amount" | "Extra dimension3 Cr" |
			| "26.04.2024 13:31:41" | "5201"       | "1" | "21,00"  | ""              | "Yes"      | "TRY"             | "Vendor (Transactions, by documents)" | "21"           | "Vendor (Transactions, by documents)" | ""                | "Business unit 2"     | "TRY"            | "4020.2"     | "Vendor (Advance, by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Vendor (Advance, by documents)" | "21"            | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991219 check DebitCreditNote movements (VT-CA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '8'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                          | "Business unit"   | "Partner term"               | "Credit" | "Operation"                                                                                    |
			| "5201"  | "Customer (Advance, by documents)" | "Business unit 2" | "Advance, by documents, EUR" | "5202"   | "DebitCreditNote (R5020B_PartnersBalance)"                                                     |
			| "5202"  | "Customer (Advance, by documents)" | "Business unit 2" | "Advance, by documents, EUR" | "4010"   | "DebitCreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                     | "Debit amount" | "Extra dimension2 Dr"                 | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                 | "Operation"                                | "Extra dimension2 Cr"        | "Credit amount" | "Extra dimension3 Cr" |
			| "03.04.2024 14:19:17" | "5201"       | "1" | "60,00"  | ""              | "Yes"      | "EUR"             | "Vendor (Transactions, by documents)" | "60"           | "Vendor (Transactions, by documents)" | ""                | "Business unit 2"     | "TRY"            | "5202"       | "Customer (Advance, by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Advance, by documents, EUR" | "2"             | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991220 check DebitCreditNote movements (VT-CT, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '9'      |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                               | "Business unit"   | "Partner term"                          | "Credit" | "Operation"                                                                                    |
			| "5201"  | "Customer (Transactions, by documents)" | "Business unit 2" | "Customer (Transactions, by documents)" | "4010"   | "DebitCreditNote (R5020B_PartnersBalance)"                                                     |
			| "5202"  | "Customer (Transactions, by documents)" | "Business unit 2" | "Customer (Transactions, by documents)" | "4010"   | "DebitCreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions) (Offset)" |
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                     | "Debit amount" | "Extra dimension2 Dr"                 | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                      | "Operation"                                | "Extra dimension2 Cr"                   | "Credit amount" | "Extra dimension3 Cr" |
			| "26.04.2024 16:15:09" | "5201"       | "1" | "51,00"  | ""              | "Yes"      | "TRY"             | "Vendor (Transactions, by documents)" | "51"           | "Vendor (Transactions, by documents)" | ""                | "Business unit 2"     | "TRY"            | "4010"       | "Customer (Transactions, by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Customer (Transactions, by documents)" | "51"            | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991221 check DebitCreditNote movements (CT-VA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '10'     |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit"  | "Partner"                               | "Business unit"   | "Partner term"                          | "Credit" | "Operation"                                                                              |
			| "4020.2" | "Customer (Transactions, by documents)" | "Business unit 2" | "Customer (Transactions, by documents)" | "4010"   | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"   | "Vendor (Advance, by documents)"        | "Business unit 2" | "Vendor (Advance, by documents)"        | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                | "Debit amount" | "Extra dimension2 Dr"            | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                      | "Operation"                                | "Extra dimension2 Cr"                   | "Credit amount" | "Extra dimension3 Cr" |
			| "26.04.2024 17:51:11" | "4020.2"     | "1" | "74,00"  | ""              | "Yes"      | "TRY"             | "Vendor (Advance, by documents)" | "74"           | "Vendor (Advance, by documents)" | ""                | "Business unit 2"     | "TRY"            | "4010"       | "Customer (Transactions, by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Customer (Transactions, by documents)" | "74"            | "Business unit 2"     |	
		And I close all client application windows

Scenario: _0991222 check DebitCreditNote movements (CT-VA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '11'     |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                        | "Business unit"   | "Partner term"                   | "Credit" | "Operation"                                                                              |
			| "5202"  | "Vendor (Advance, by documents)" | "Business unit 2" | "Vendor (Advance, by documents)" | "4020.2" | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"  | "Vendor (Advance, by documents)" | "Business unit 2" | "Vendor (Advance, by documents)" | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |	
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                  | "Debit amount" | "Extra dimension2 Dr"        | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"               | "Operation"                                | "Extra dimension2 Cr"            | "Credit amount" | "Extra dimension3 Cr" |
			| "29.04.2024 10:25:38" | "5202"       | "1" | "327,05" | ""              | "Yes"      | "TRY"             | "Customer (Advance, by documents)" | "10"           | "Advance, by documents, EUR" | ""                | "Business unit 2"     | "EUR"            | "4020.2"     | "Vendor (Advance, by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Vendor (Advance, by documents)" | "320"           | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991223 check DebitCreditNote movements (CT-VT, by partner terms, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '12'     |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                                   | "Business unit"   | "Partner term"                              | "Credit" | "Operation"                                                                              |
			| "5201"  | "Customer (Transactions, by partner terms)" | "Business unit 2" | "Customer (Transacrions, by partner terms)" | "4010"   | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"  | "Vendor (Transactions, by partner term)"    | "Business unit 2" | "Vendor, transaction by partner term"       | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                        | "Debit amount" | "Extra dimension2 Dr"                 | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                          | "Operation"                                | "Extra dimension2 Cr"                       | "Credit amount" | "Extra dimension3 Cr" |
			| "29.04.2024 10:42:01" | "5201"       | "1" | "1 400,00" | ""              | "Yes"      | "EUR"             | "Vendor (Transactions, by partner term)" | "42,8"         | "Vendor, transaction by partner term" | ""                | "Business unit 2"     | "EUR"            | "4010"       | "Customer (Transactions, by partner terms)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Customer (Transacrions, by partner terms)" | "42,8"          | "Business unit 2"     |	
		And I close all client application windows

Scenario: _0991224 check DebitCreditNote movements (VA-VA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '13'     |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit"  | "Partner"                            | "Business unit"   | "Partner term"                   | "Credit" | "Operation"                                                                              |
			| "4020.2" | "Vendor (Advance, by documents)"     | "Business unit 2" | "Vendor (Advance, by documents)" | "4020.2" | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"   | "Vendor and Customer (by documents)" | "Business unit 2" | "Vendor (by documents) 2"        | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                    | "Debit amount" | "Extra dimension2 Dr"     | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"               | "Operation"                                | "Extra dimension2 Cr"            | "Credit amount" | "Extra dimension3 Cr" |
			| "29.04.2024 11:06:59" | "4020.2"     | "1" | "20,00"  | ""              | "Yes"      | "TRY"             | "Vendor and Customer (by documents)" | "20"           | "Vendor (by documents) 2" | ""                | "Business unit 2"     | "TRY"            | "4020.2"     | "Vendor (Advance, by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Vendor (Advance, by documents)" | "20"            | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991225 check DebitCreditNote movements (СA-СA, by documents, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '14'     |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                            | "Business unit"   | "Partner term"      | "Credit" | "Operation"                                                                                    |
			| "5202"  | "Vendor and Customer (by documents)" | "Business unit 2" | "Partner term, EUR" | "5202"   | "DebitCreditNote (R5020B_PartnersBalance)"                                                     |
			| "5202"  | "Vendor and Customer (by documents)" | "Business unit 2" | "Partner term, EUR" | "4010"   | "DebitCreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                  | "Debit amount" | "Extra dimension2 Dr"        | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                   | "Operation"                                | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "29.04.2024 11:15:01" | "5202"       | "1" | "654,10" | ""              | "Yes"      | "EUR"             | "Customer (Advance, by documents)" | "20"           | "Advance, by documents, EUR" | ""                | "Business unit 2"     | "EUR"            | "5202"       | "Vendor and Customer (by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Partner term, EUR"   | "20"            | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991226 check DebitCreditNote movements (СT-СT, by documents and partner terms, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '15'     |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                                   | "Business unit"   | "Partner term"                              | "Credit" | "Operation"                                                                                    |
			| "4010"  | "Customer (Transactions, by documents)"     | "Business unit 2" | "Customer (Transactions, by documents)"     | "4010"   | "DebitCreditNote (R5020B_PartnersBalance)"                                                     |
			| "5202"  | "Customer (Transactions, by partner terms)" | "Business unit 2" | "Customer (Transacrions, by partner terms)" | "4010"   | "DebitCreditNote DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                           | "Debit amount" | "Extra dimension2 Dr"                       | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                      | "Operation"                                | "Extra dimension2 Cr"                   | "Credit amount" | "Extra dimension3 Cr" |
			| "29.04.2024 11:21:10" | "4010"       | "1" | "60,00"  | ""              | "Yes"      | "TRY"             | "Customer (Transactions, by partner terms)" | "2"            | "Customer (Transacrions, by partner terms)" | ""                | "Business unit 2"     | "EUR"            | "4010"       | "Customer (Transactions, by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Customer (Transactions, by documents)" | "60"            | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991227 check DebitCreditNote movements (VT-VT, by partner terms, different partners)
	And I close all client application windows
	* Select DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I go to line in "List" table
			| 'Number' |
			| '16'     |	
		And I select current line in "List" table
		And I click "Post" button		
	* Check accounting movements
		And I click "Edit accounting" button	
		And "AccountingAnalytics" table became equal
			| "Debit" | "Partner"                             | "Business unit"   | "Partner term"                        | "Credit" | "Operation"                                                                              |
			| "5201"  | "Vendor (Transactions, by documents)" | "Business unit 2" | "Vendor (Transactions, by documents)" | "5201"   | "DebitCreditNote (R5020B_PartnersBalance)"                                               |
			| "5201"  | "Vendor (Transactions, by documents)" | "Business unit 2" | "Vendor (Transactions, by documents)" | "4020.2" | "DebitCreditNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors) (Offset)" |		
		And I close current window
	* Check JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"                        | "Debit amount" | "Extra dimension2 Dr"                 | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"                    | "Operation"                                | "Extra dimension2 Cr"                 | "Credit amount" | "Extra dimension3 Cr" |
			| "29.04.2024 12:14:25" | "5201"       | "1" | "1 635,25" | ""              | "Yes"      | "TRY"             | "Vendor (Transactions, by partner term)" | "50"           | "Vendor, transaction by partner term" | ""                | "Business unit 2"     | "EUR"            | "5201"       | "Vendor (Transactions, by documents)" | "DebitCreditNote (R5020B_PartnersBalance)" | "Vendor (Transactions, by documents)" | "1 500"         | "Business unit 2"     |		
		And I close all client application windows

Scenario: _0991199 check create JE from Data processor fix document problems
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/app/DataProcessor.FixDocumentProblems"
	* Fill documents
		And I click Choice button of the field named "Period"
		And I input "01.01.2022" text in the field named "DateBegin"
		And I input "31.03.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		And in the table "DocumentList" I click "Fill documents" button
		Then the number of "DocumentList" table lines is "больше" "10"


Scenario: _0991200 write empty JE with problems (without accounting settings)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |	
		And in the table "List" I click the button named "ListContextMenuCopy"
		And Delay 5
		Then "Update item list info" window is opened
		And I click "Uncheck all" button
		And I click "OK" button
		And I select from the drop-down list named "Company" by "Own company 3" string
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click "Post" button
	* Create JE
		And I click "Journal entry" button
		Then "Journal entry (create)" window is opened
		And I click "Save" button
		And "Errors" table contains rows by template:
			| "#" | "Error"                                                                                                                              |
			| "1" | "Debit is empty [SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)] *" |
			| "2" | "Debit is empty [SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)] *" |		
		And I save the value of "Number" field as "NumberEmptyJE"
		And I click the button named "FormWriteAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.JournalEntry"
		And "List" table contains lines
			| 'Number'             |
			| '$NumberEmptyJE$'    |
		And I close all client application windows

Scenario: _0991210 edit accounting manualy (document with tabular part)
	And I close all client application windows
	* Select document
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '7'      |
		And I select current line in "List" table	
	* Create JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"    | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"          | "Operation"                                                                                  | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "05.12.2023 12:00:00" | "3540"       | "1" | "440,00" | "4"             | "Yes"      | "TRY"             | "Item with item key" | "440"          | "S/Color 1"           | ""                | ""                    | "TRY"            | "5201"       | "Vendor 3 (1 partner term)" | "PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)" | "№31-92"              | "440"           | ""                    |
			| "05.12.2023 12:00:00" | "5301"       | "2" | "88,00"  | ""              | "Yes"      | "TRY"             | "VAT"                | "88"           | ""                    | ""                | ""                    | "TRY"            | "5201"       | "Vendor 3 (1 partner term)" | "PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)"                  | "№31-92"              | "88"            | ""                    |	
	* Edit accounting in document
		When in opened panel I select "Purchase invoice 7 dated 05.12.2023 12:00:00"
		* First
			And in the table "ItemList" I click "Edit accounting" button
			And I go to line in "AccountingAnalytics" table
				| "Credit" | "Debit" |
				| "5201"   | "3540"  |
			And I select current line in "AccountingAnalytics" table
			And I select "3530" from "Debit" drop-down list by string in "AccountingAnalytics" table
			And I finish line editing in "AccountingAnalytics" table
			And I click "Ok" button
			And I click "Post" button
			When in opened panel I select "JE Purchase invoice 7 dated 05.12.2023 12:00:00"
			Then "JE Purchase invoice * dated *" window is opened
			And I click "Save" button
			And "RegisterRecords" table became equal
				| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"    | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"          | "Operation"                                                                                  | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
				| "05.12.2023 12:00:00" | "3530"       | "1" | "440,00" | "4"             | "Yes"      | "TRY"             | "Item with item key" | "440"          | "S/Color 1"           | ""                | ""                    | "TRY"            | "5201"       | "Vendor 3 (1 partner term)" | "PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)" | "№31-92"              | "440"           | ""                    |
				| "05.12.2023 12:00:00" | "5301"       | "2" | "88,00"  | ""              | "Yes"      | "TRY"             | "VAT"                | "88"           | ""                    | ""                | ""                    | "TRY"            | "5201"       | "Vendor 3 (1 partner term)" | "PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)"                  | "№31-92"              | "88"            | ""                    |		
		* Second
			When in opened panel I select "Purchase invoice 7 dated 05.12.2023 12:00:00"	
			And in the table "ItemList" I click "Edit accounting" button
			Then "Edit accounting" window is opened
			And I go to line in "AccountingAnalytics" table
				| "Credit" | "Debit" |
				| "5201"   | "5301"  |	
			And I select current line in "AccountingAnalytics" table
			And I select "5302" from "Debit" drop-down list by string in "AccountingAnalytics" table
			And I finish line editing in "AccountingAnalytics" table
			And I click "Ok" button
			And I click "Post" button
			When in opened panel I select "JE Purchase invoice 7 dated 05.12.2023 12:00:00"
			Then "JE Purchase invoice * dated *" window is opened
			And I click "Save" button
			And "RegisterRecords" table became equal
				| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"    | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"          | "Operation"                                                                                  | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
				| "05.12.2023 12:00:00" | "3530"       | "1" | "440,00" | "4"             | "Yes"      | "TRY"             | "Item with item key" | "440"          | "S/Color 1"           | ""                | ""                    | "TRY"            | "5201"       | "Vendor 3 (1 partner term)" | "PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)" | "№31-92"              | "440"           | ""                    |		
				| "05.12.2023 12:00:00" | "5302"       | "2" | "88,00"  | ""              | "Yes"      | "TRY"             | "VAT"                | "88"           | ""                    | ""                | ""                    | "TRY"            | "5201"       | "Vendor 3 (1 partner term)" | "PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)"                  | "№31-92"              | "88"            | ""                    |
		* Reset	
			When in opened panel I select "Purchase invoice 7 dated 05.12.2023 12:00:00"
			And in the table "ItemList" I click "Edit accounting" button
			And I click "Refresh" button
			And I click "Ok" button
			And I click "Post" button
			When in opened panel I select "JE Purchase invoice 7 dated 05.12.2023 12:00:00"
			And I click "Save" button
			And "RegisterRecords" table became equal
			| "Period"              | "Account Dr" | "#" | "Amount" | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"    | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr" | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"          | "Operation"                                                                                  | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "05.12.2023 12:00:00" | "3540"       | "1" | "440,00" | "4"             | "Yes"      | "TRY"             | "Item with item key" | "440"          | "S/Color 1"           | ""                | ""                    | "TRY"            | "5201"       | "Vendor 3 (1 partner term)" | "PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)" | "№31-92"              | "440"           | ""                    |
			| "05.12.2023 12:00:00" | "5301"       | "2" | "88,00"  | ""              | "Yes"      | "TRY"             | "VAT"                | "88"           | ""                    | ""                | ""                    | "TRY"            | "5201"       | "Vendor 3 (1 partner term)" | "PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)"                  | "№31-92"              | "88"            | ""                    |
		And I close all client application windows

Scenario: _0991211 edit accounting manualy (document without tabular part)
	And I close all client application windows
	* Select document
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And I select current line in "List" table	
	* Create JE
		And I click "Journal entry" button
		And I click "Save" button
		And "RegisterRecords" table contains lines
			| "Period"              | "Account Dr" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"   | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr"     | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"  | "Operation"                                                      | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
			| "11.03.2023 14:34:06" | "3250"       | "1 921,27" | ""              | "Yes"      | "USD"             | "Bank account, USD" | "102"          | "Own company 2"       | ""                | "Business unit 3"         | "USD"            | "3221"       | "Transit, TRY"      | "MoneyTransfer DR (R3010B_CashOnHand) CR (R3021B_CashInTransit)" | "Own company 2"       | "102"           | ""                    |
			| "11.03.2023 14:34:06" | "3221"       | "2 003,76" | ""              | "Yes"      | "EUR"             | "Transit, TRY"      | "100"          | "Own company 2"       | ""                | ""                        | "EUR"            | "3250"       | "Bank account, EUR" | "MoneyTransfer DR (R3021B_CashInTransit) CR (R3010B_CashOnHand)" | "Own company 2"       | "100"           | "Business unit 3"     |
			| "11.03.2023 14:34:06" | "420.5"      | "82,49"    | ""              | "Yes"      | "TRY"             | ""                  | "82,49"        | "Business unit 3"     | ""                | "Foreign exchange losses" | "TRY"            | "3221"       | "Transit, TRY"      | "MoneyTransfer DR (R5022T_Expenses) CR (R3021B_CashInTransit)"   | "Own company 2"       | "82,49"         | ""                    |
	* Edit accounting in document
		When in opened panel I select "Money transfer 2 dated 11.03.2023 14:34:06"
		* First
			And I click the button named "EditAccounting"				
			And I go to line in "AccountingAnalytics" table
				| "Credit" | "Debit" |
				| "3221"   | "3250"  |
			And I select current line in "AccountingAnalytics" table
			And I select "3240" from "Debit" drop-down list by string in "AccountingAnalytics" table
			And I finish line editing in "AccountingAnalytics" table
			And I click "Ok" button
			And I click "Post" button
			When in opened panel I select "JE Money transfer 2 dated 11.03.2023 14:34:06"
			And I click "Save" button
			And "RegisterRecords" table contains lines
				| "Period"              | "Account Dr" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"   | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr"     | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"  | "Operation"                                                      | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
				| "11.03.2023 14:34:06" | "3240"       | "1 921,27" | ""              | "Yes"      | "USD"             | "Bank account, USD" | "102"          | "Own company 2"       | ""                | ""                        | "USD"            | "3221"       | "Transit, TRY"      | "MoneyTransfer DR (R3010B_CashOnHand) CR (R3021B_CashInTransit)" | "Own company 2"       | "102"           | ""                    |
				| "11.03.2023 14:34:06" | "3221"       | "2 003,76" | ""              | "Yes"      | "EUR"             | "Transit, TRY"      | "100"          | "Own company 2"       | ""                | ""                        | "EUR"            | "3250"       | "Bank account, EUR" | "MoneyTransfer DR (R3021B_CashInTransit) CR (R3010B_CashOnHand)" | "Own company 2"       | "100"           | "Business unit 3"     |
				| "11.03.2023 14:34:06" | "420.5"      | "82,49"    | ""              | "Yes"      | "TRY"             | ""                  | "82,49"        | "Business unit 3"     | ""                | "Foreign exchange losses" | "TRY"            | "3221"       | "Transit, TRY"      | "MoneyTransfer DR (R5022T_Expenses) CR (R3021B_CashInTransit)"   | "Own company 2"       | "82,49"         | ""                    |
		* Second
			When in opened panel I select "Money transfer 2 dated 11.03.2023 14:34:06"	
			And I click the button named "EditAccounting"	
			Then "Edit accounting" window is opened
			And I go to line in "AccountingAnalytics" table
				| "Credit" | "Debit" |
				| "3250"   | "3221"  |	
			And I select current line in "AccountingAnalytics" table
			And I select "3260" from "Debit" drop-down list by string in "AccountingAnalytics" table
			And I finish line editing in "AccountingAnalytics" table
			And I click "Ok" button
			And I click "Post" button
			When in opened panel I select "JE Money transfer 2 dated 11.03.2023 14:34:06"
			And I click "Save" button
			And "RegisterRecords" table contains lines
				| "Period"              | "Account Dr" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"   | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr"     | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"  | "Operation"                                                      | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
				| "11.03.2023 14:34:06" | "3240"       | "1 921,27" | ""              | "Yes"      | "USD"             | "Bank account, USD" | "102"          | "Own company 2"       | ""                | ""                        | "USD"            | "3221"       | "Transit, TRY"      | "MoneyTransfer DR (R3010B_CashOnHand) CR (R3021B_CashInTransit)" | "Own company 2"       | "102"           | ""                    |
				| "11.03.2023 14:34:06" | "3260"       | "2 003,76" | ""              | "Yes"      | "EUR"             | ""                  | "100"          | "Own company 2"       | ""                | ""                        | "EUR"            | "3250"       | "Bank account, EUR" | "MoneyTransfer DR (R3021B_CashInTransit) CR (R3010B_CashOnHand)" | "Own company 2"       | "100"           | "Business unit 3"     |
				| "11.03.2023 14:34:06" | "420.5"      | "82,49"    | ""              | "Yes"      | "TRY"             | ""                  | "82,49"        | "Business unit 3"     | ""                | "Foreign exchange losses" | "TRY"            | "3221"       | "Transit, TRY"      | "MoneyTransfer DR (R5022T_Expenses) CR (R3021B_CashInTransit)"   | "Own company 2"       | "82,49"         | ""                    |
		* Reset	
			When in opened panel I select "Money transfer 2 dated 11.03.2023 14:34:06"
			And I click the button named "EditAccounting"	
			And I click "Refresh" button
			And I click "Ok" button
			And I click "Post" button
			When in opened panel I select "JE Money transfer 2 dated 11.03.2023 14:34:06"
			And I click "Save" button
			And "RegisterRecords" table contains lines
				| "Period"              | "Account Dr" | "Amount"   | "DebitQuantity" | "Activity" | "Credit currency" | "Ext. Dim. Debit"   | "Debit amount" | "Extra dimension2 Dr" | "Credit quantity" | "Extra dimension3 Dr"     | "Debit currency" | "Account Cr" | "Ext. Dim. Credit"  | "Operation"                                                      | "Extra dimension2 Cr" | "Credit amount" | "Extra dimension3 Cr" |
				| "11.03.2023 14:34:06" | "3250"       | "1 921,27" | ""              | "Yes"      | "USD"             | "Bank account, USD" | "102"          | "Own company 2"       | ""                | "Business unit 3"         | "USD"            | "3221"       | "Transit, TRY"      | "MoneyTransfer DR (R3010B_CashOnHand) CR (R3021B_CashInTransit)" | "Own company 2"       | "102"           | ""                    |
				| "11.03.2023 14:34:06" | "3221"       | "2 003,76" | ""              | "Yes"      | "EUR"             | "Transit, TRY"      | "100"          | "Own company 2"       | ""                | ""                        | "EUR"            | "3250"       | "Bank account, EUR" | "MoneyTransfer DR (R3021B_CashInTransit) CR (R3010B_CashOnHand)" | "Own company 2"       | "100"           | "Business unit 3"     |
				| "11.03.2023 14:34:06" | "420.5"      | "82,49"    | ""              | "Yes"      | "TRY"             | ""                  | "82,49"        | "Business unit 3"     | ""                | "Foreign exchange losses" | "TRY"            | "3221"       | "Transit, TRY"      | "MoneyTransfer DR (R5022T_Expenses) CR (R3021B_CashInTransit)"   | "Own company 2"       | "82,49"         | ""                    |
		And I close all client application windows
					
				
				

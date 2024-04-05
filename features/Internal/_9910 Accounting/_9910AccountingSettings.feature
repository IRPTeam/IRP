#language: en
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
		When Create document CalculationMovementCosts objects (test data base)
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
	* Load data for Accounting system
		When Create chart of characteristic types AccountingExtraDimensionTypes objects (test data base)
		When Create chart of accounts Basic objects with LedgerTypeVariants (Basic LTV) (test data base)
		When Create information register T9011S_AccountsCashAccount records (Basic LTV) (test data base)
		When Create information register T9014S_AccountsExpenseRevenue records (Basic LTV) (test data base)
		When Create information register T9010S_AccountsItemKey records (Basic LTV) (test data base)
		When Create information register T9012S_AccountsPartner records (Basic LTV) (test data base)
		When Create information register T9013S_AccountsTax records (Basic LTV) (test data base)
	* Post OE
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
	* Post PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
	* Post SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
	* Post RSR
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
	* Post RRR
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "3"
	* Post CalculationMovementCosts
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
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
		| 'BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand'                    | 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)'                    |
		| 'BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                      | 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                      |
		| 'BankPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand'              | 'BankPayment DR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) CR (R3010B_CashOnHand)'              |
		| 'BankPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers'                                | 'BankPayment DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                                |
		| 'BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder'                         | 'BankPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Cash transfer)'                           |
		| 'BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange'                          | 'BankPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Currency exchange)'                       |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions'              | 'BankReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)'              |
		| 'BankReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions'                                | 'BankReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                                |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions'                    | 'BankReceipt DR (R3010B_CashOnHand) CR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions)'                    |
		| 'BankReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions'                                      | 'BankReceipt DR (R1020B_AdvancesToVendors) CR (R1021B_VendorsTransactions)'                                      |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder'                         | 'BankReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Cash transfer)'                           |
		| 'BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CurrencyExchange'                          | 'BankReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Currency exchange)'                       |
		| 'BankReceipt_DR_R3021B_CashInTransit_CR_R5021T_Revenues'                                                     | 'BankReceipt DR (R3021B_CashInTransit) CR (R5021T_Revenues)'                                                     |
		| 'BankReceipt_DR_R5022T_Expenses_CR_R3021B_CashInTransit'                                                     | 'BankReceipt DR (R5022T_Expenses) CR (R3021B_CashInTransit)'                                                     |
		| 'PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions'                     | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)'                     |
		| 'PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                  | 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                  |
		| 'PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions'                                      | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                                      |
		| 'PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_CurrencyRevaluation'              | 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors_CurrencyRevaluation)'              |
		| 'PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions_CurrencyRevaluation' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions_CurrencyRevaluation)' |
		| 'RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory'                                             | 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                             |
		| 'SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues'                                            | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)'                                            |
		| 'SalesInvoice_DR_R5021T_Revenues_CR_R2040B_TaxesIncoming'                                                    | 'SalesInvoice DR (R5021T_Revenues) CR (R2040B_TaxesIncoming)'                                                    |
		| 'SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory'                                                   | 'SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                                   |
		| 'SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions'                               | 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                               |
		| 'SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_CurrencyRevaluation'           | 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions_CurrencyRevaluation)'           |
		| 'SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues_CurrencyRevaluation'                        | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues_CurrencyRevaluation)'                        |
		| 'ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues'                              | 'ForeignCurrencyRevaluation DR (R2020B_AdvancesFromCustomers) CR (R5021T_Revenues)'                              |
		| 'ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers'                              | 'ForeignCurrencyRevaluation DR (R5022T_Expenses) CR (R2020B_AdvancesFromCustomers)'                              |
		| 'CashPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand'                    | 'CashPayment DR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions) CR (R3010B_CashOnHand)'                    |
		| 'CashPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                      | 'CashPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                      |
		| 'CashPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand'              | 'CashPayment DR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) CR (R3010B_CashOnHand)'              |
		| 'CashPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers'                                | 'CashPayment DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                                |
		| 'CashPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder'                         | 'CashPayment DR (R3021B_CashInTransitIncoming) CR (R3010B_CashOnHand) (Cash transfer)'                           |
		| 'CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions'              | 'CashReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)'              |
		| 'CashReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions'                                | 'CashReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                                |
		| 'CashReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions'                    | 'CashReceipt DR (R3010B_CashOnHand) CR (R1020B_AdvancesToVendors_R1021B_VendorsTransactions)'                    |
		| 'CashReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions'                                      | 'CashReceipt DR (R1020B_AdvancesToVendors) CR (R1021B_VendorsTransactions)'                                      |
		| 'CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder'                         | 'CashReceipt DR (R3010B_CashOnHand) CR (R3021B_CashInTransitIncoming) (Cash transfer)'                           |
		| 'CashExpense_DR_R5022T_Expenses_CR_R3010B_CashOnHand'                                                        | 'CashExpense DR (R5022T_Expenses) CR (R3010B_CashOnHand)'                                                        |
		| 'CashRevenue_DR_R3010B_CashOnHand_CR_R5021_Revenues'                                                         | 'CashRevenue DR (R3010B_CashOnHand) CR (R5021_Revenues)'                                                         |
		| 'DebitNote_DR_R1020B_AdvancesToVendors_CR_R5021_Revenues'                                                    | 'DebitNote DR (R1020B_AdvancesToVendors) CR (R5021_Revenues)'                                                    |
		| 'DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                        | 'DebitNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                        |
		| 'DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues'                                                | 'DebitNote DR (R2021B_CustomersTransactions) CR (R5021_Revenues)'                                                |
		| 'CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R5022T_Expenses'                                              | 'CreditNote DR (R2020B_AdvancesFromCustomers) CR (R5022T_Expenses)'                                              |
		| 'CreditNote_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers'                                 | 'CreditNote DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                                 |
		| 'CreditNote_DR_R1021B_VendorsTransactions_CR_R5022T_Expenses'                                                | 'CreditNote DR (R1021B_VendorsTransactions CR (R5022T_Expenses)'                                                 |
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
		| 'DepreciationCalculation_DR_DepreciationFixedAsset_CR_R8510B_BookValueOfFixedAsset'                          | 'DepreciationCalculation DR (DepreciationFixedAsset) CR (R8510B_BookValueOfFixedAsset)'                          |
		| 'DepreciationCalculation_DR_R5022T_Expenses_CR_DepreciationFixedAsset'                                       | 'DepreciationCalculation DR (R5022T_Expenses) CR (DepreciationFixedAsset)'                                       |	
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
				| 'Presentation'                                                                                      | 'Use' |
				| 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors_CurrencyRevaluation)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                                                   | 'Use' |
				| 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions_CurrencyRevaluation)' | 'No'  |
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
				| 'Presentation'                                                | 'Use' |
				| 'SalesInvoice DR (R5021T_Revenues) CR (R2040B_TaxesIncoming)' | 'No'  |
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
				| 'Presentation'                                                                                         | 'Use' |
				| 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions_CurrencyRevaluation)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                            | 'Use' |
				| 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues_CurrencyRevaluation)' | 'No'  |
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
				| 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors_CurrencyRevaluation)'              | 'Yes' | '01.01.2021' |
				| 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions_CurrencyRevaluation)' | 'Yes' | '01.01.2021' |
				| 'Retail sales receipt'                                                                                           | 'No'  | ''           |
				| 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                             | 'Yes' | '01.01.2021' |
				| 'Sales invoice'                                                                                                  | 'No'  | ''           |
				| 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)'                                            | 'Yes' | '01.01.2021' |
				| 'SalesInvoice DR (R5021T_Revenues) CR (R2040B_TaxesIncoming)'                                                    | 'Yes' | '01.01.2021' |
				| 'SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                                   | 'Yes' | '01.01.2021' |
				| 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                               | 'Yes' | '01.01.2021' |
				| 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions_CurrencyRevaluation)'           | 'Yes' | '01.01.2021' |
				| 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues_CurrencyRevaluation)'                        | 'Yes' | '01.01.2021' |
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
				| 'Account charts (Basic)' | ''      | ''                      | ''     | ''           | ''    | ''           | ''   | ''                                  | ''           | ''            |
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
				| 'Account charts (Basic)' | ''      | ''                      | ''     | ''           | ''    | ''           | ''   | ''                                  | ''           | ''            |
				| '405'                    | '10'    | 'Group Assets acccount' | 'AP'   | ''           | 'Yes' | ''           | 'No' | 'LTV with account charts code mask' | ''           | 'No'          |
				| '405.01'                 | '40501' | 'Assets acccount'       | 'A'    | 'Item key'   | 'Yes' | 'Store'      | 'No' | 'LTV with account charts code mask' | 'Item'       | 'No'          |					

Scenario: _0991009 create Account charts (Basic) - liabilities account without group
	And I close all client application windows
	* Open 	Account charts
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I change the radio button named "LedgerTypeVariantFilter" value to "LTV with account charts code mask"
	* Create liabilities account
		And I go to line in "List" table
			| 'Code'                      |
			| 'Account charts (Basic)'    |
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
			| 'Account charts (Basic)' | ''        | ''                    | ''     | ''             | ''   | ''                    | ''    | ''                                  | ''           | ''            |
			| '102.13.11'              | '1021311' | 'Liabilities account' | 'P'    | 'Partner term' | 'No' | 'Legal name contract' | 'Yes' | 'LTV with account charts code mask' | 'Partner'    | 'No'          |
		
Scenario: _0991010 create Account charts (Basic) - Assets/Liabilities account, Off-balance
	And I close all client application windows
	* Open 	Account charts
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"
		And I change the radio button named "LedgerTypeVariantFilter" value to "LTV with account charts code mask"
	* Create liabilities account
		And I go to line in "List" table
			| 'Code'                      |
			| 'Account charts (Basic)'    |
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
		And I go to line in "List" table
			| 'Code'                      |
			| 'Account charts (Basic)'    |
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
			| 'Account charts (Basic)' | ''         | ''                    | ''     | ''                 | ''    | ''                    | ''    | ''                                  | ''           | ''            |
			| '90878699'               | '90878699' | 'Test assets account' | 'A'    | 'Item key (turn.)' | 'Yes' | 'Fixed asset (turn.)' | 'No'  | 'LTV with account charts code mask' | 'Item'       | 'No'          |
			| '908990'                 | '908990'   | 'Test group'          | 'P'    | ''                 | 'No'  | ''                    | 'Yes' | 'LTV with account charts code mask' | 'Partner'    | 'No'          |
		And I expand a line in "List" table
			| 'C.'  | 'Code'   | 'Description' | 'Ext. Dim 1' | 'Ledger type variant'               | 'Off-balance' | 'Order'  | 'Q.' | 'Type' |
			| 'Yes' | '908990' | 'Test group'  | 'Partner'    | 'LTV with account charts code mask' | 'No'          | '908990' | 'No' | 'P'    |
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
			| 'Period'     | 'Company'      | 'Ledger type variant'               | 'Expense / Revenue' | 'Account' |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | ''                  | '405.01'  |
	And I close all client application windows

Scenario: _0991028 accounts settings for Expense/Revenue
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9014S_AccountsExpenseRevenue"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Own company 1'    |
		And I select current line in "List" table
		And I change the radio button named "RecordType" value to "Expense and revenue type"
		And I click Select button of "Expense / Revenue" field
		And I go to line in "List" table
			| 'Description'   |
			| 'Other expence' |
		And I select current line in "List" table
		And I select from "Expense / Revenue" drop-down list by "Other revenues" string	
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "90878699" string
		Then the form attribute named "Account" became equal to "90878699"
		Then the form attribute named "Company" became equal to "Own company 1"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "ExpenseRevenue" became equal to "Other revenues"		
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'       | 'Ledger type variant'               | 'Expense / Revenue' | 'Account'  |
			| '01.01.2022' | 'Own company 1' | 'LTV with account charts code mask' | 'Other revenues'    | '90878699' |
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
		And I select from the drop-down list named "AccountAdvancesOther" by "40501" string
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
			| 'Period'     | 'Company'       | 'Partner' | 'Ledger type variant'               | 'Agreement' | 'Vendor' | 'Customer' | 'Transactions' | 'Other' | 'Advances' |
			| '01.01.2022' | 'Own company 1' | 'Customer 2 (2 partner term)'   | 'LTV with account charts code mask' | ''          | 'No'     | 'Yes'      | ''             | 'No'    | ''         |
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
			| 'Period'     | 'Company'       | 'Partner' | 'Ledger type variant'               | 'Agreement'                                               | 'Vendor' | 'Customer' | 'Transactions' | 'Other' | 'Advances' |
			| '01.01.2022' | 'Own company 1' | ''        | 'LTV with account charts code mask' | 'Partner term with customer (by document + credit limit)' | 'No'     | 'Yes'      | ''             | 'No'    | ''         |
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
		And "RegisterRecords" table became equal
			| 'Period'              | 'Account Dr' | '#'  | 'Amount'   | 'DebitQuantity' | 'Activity' | 'Credit currency' | 'Ext. Dim. Debit'                                   | 'Debit amount' | 'Extra dimension2 Dr'   | 'Credit quantity' | 'Extra dimension3 Dr' | 'Debit currency' | 'Account Cr' | 'Ext. Dim. Credit'          | 'Operation'                                                                                  | 'Extra dimension2 Cr'        | 'Credit amount' | 'Extra dimension3 Cr' |
			| '24.02.2023 10:04:33' | '3540'       | '1'  | '633,33'   | '4'             | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '633,33'       | 'XS/Color 2'            | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '633,33'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '2'  | '126,67'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '126,67'       | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '126,67'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '3'  | '2 500,00' | '20'            | 'Yes'      | 'TRY'             | 'Item without item key (pcs)'                       | '2 500'        | 'Item without item key' | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '2 500'         | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '4'  | '500,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '500'          | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '500'           | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '5'  | '1 541,67' | '10'            | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '1 541,67'     | 'S/Color 2'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '1 541,67'      | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '6'  | '308,33'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '308,33'       | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '308,33'        | ''                    |
			| '24.02.2023 10:04:33' | '3540'       | '7'  | '1 200,00' | '8'             | 'Yes'      | 'TRY'             | 'Item 1 with serial lot number (use line grouping)' | '1 200'        | 'S/Color 2'             | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '1 200'         | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '8'  | '240,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '240'          | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '240'           | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '9'  | '4 583,33' | '50'            | 'Yes'      | 'TRY'             | 'Item with item key'                                | '4 583,33'     | 'S/Color 1'             | ''                | 'Business unit 1'     | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '4 583,33'      | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '5301'       | '10' | '916,67'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '916,67'       | 'Business unit 1'       | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '916,67'        | 'Business unit 1'     |
			| '24.02.2023 10:04:33' | '3540'       | '11' | '100,00'   | '1'             | 'Yes'      | 'TRY'             | 'Item 4 with unique serial lot number'              | '100'          | 'S/Color 1'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '100'           | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '12' | '20,00'    | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '20'           | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '20'            | ''                    |
			| '24.02.2023 10:04:33' | '3540'       | '13' | '875,00'   | '10'            | 'Yes'      | 'TRY'             | 'Item with item key'                                | '875'          | 'S/Color 1'             | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)' | 'Partner term with vendor 1' | '875'           | ''                    |
			| '24.02.2023 10:04:33' | '5301'       | '14' | '175,00'   | ''              | 'Yes'      | 'TRY'             | 'VAT'                                               | '175'          | ''                      | ''                | ''                    | 'TRY'            | '5201'       | 'Vendor 1 (1 partner term)' | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                  | 'Partner term with vendor 1' | '175'           | ''                    |	
		And "Totals" table became equal
			| '#' | 'Chart of account' | 'Amount Debit' | 'Amount Credit' |
			| '1' | '3540'             | '11 433,33'    | ''              |
			| '2' | '5201'             | ''             | '13 720,00'     |
			| '3' | '5301'             | '2 286,67'     | ''              |
		Then the form attribute named "UserDefined" became equal to "No"
		And I click "Save and close" button	
	* Check Journal entry creation
		Given I open hyperlink "e1cib/list/Document.JournalEntry"
		And "List" table contains lines
			| 'User defined' | 'Date'                | 'Company'       | 'Ledger type' | 'Basis'                                        | 'Description' |
			| 'No'           | '24.02.2023 10:04:33' | 'Own company 2' | 'Basic LTV'   | 'Purchase invoice 1 dated 24.02.2023 10:04:33' | ''            |
		
							
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
			| 'User defined' | 'Date'                | 'Company'       | 'Ledger type' | 'Basis'                                        | 'Description' |
			| 'No'           | '22.07.2023 09:38:02' | 'Own company 2' | 'Basic LTV'   | 'Purchase invoice 2 dated 22.07.2023 09:38:02' | ''            |
			| 'No'           | '30.11.2023 16:01:04' | 'Own company 2' | 'Basic LTV'   | 'Purchase invoice 3 dated 30.11.2023 16:01:04' | ''            |
			
						
Scenario: _0991059 create journal entry for two PI
	And I close all client application windows
	* Open journal entry list
		Given I open hyperlink "e1cib/list/Document.JournalEntry"
		Then "Journal entry" window is opened
		And I click "Create documents" button
		And I go to line in "TableDocuments" table
			| 'Presentation'     | 'Use' |
			| 'Purchase invoice' | 'No'  |
		And I change "Use" checkbox in "TableDocuments" table
		And I finish line editing in "TableDocuments" table
		And I go to line in "TableDocuments" table
			| 'Presentation'  | 'Use' |
			| 'Sales invoice' | 'No'  |
		And I change "Use" checkbox in "TableDocuments" table
		And I finish line editing in "TableDocuments" table
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'   |
			| 'Own company 2' |
		And I select current line in "List" table
		And I click Select button of "Ledger type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic LTV'   |
		And I select current line in "List" table
		And I click "Create documents" button
	* Check journal entry
		Given I open hyperlink "e1cib/list/Document.JournalEntry"
		And I click "Create documents" button		
		And I click Choice button of the field named "Period"
		And I input "01.01.2021" text in the field named "DateBegin"
		And I input "01.01.2024" text in the field named "DateEnd"
		And I click the button named "Select"
		Then "Create documents" window is opened
		And I click "Create documents" button
		And I close "Create documents" window
		Then "Journal entry" window is opened
		And I click "Refresh" button
				
						
				
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
			| '4010'  | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | 'Business unit 1' | 'Customer 2 (2 partner term)' | '4020'   | 'Individual partner term 1 (by partner term)' | 'BankReceipt DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                   |
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
			| '5201'  | 'Vendor 2 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 2' | 'Partner term with vendor 2' | '5202'   | 'Vendor 2 (1 partner term)' | 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                   |		
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
			| '5201'  | 'Vendor 2 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 2' | 'Partner term with vendor 2' | '5202'   | 'Vendor 2 (1 partner term)' | 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                   |		
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
			| '5201'  | 'Vendor 1 (1 partner term)' | ''                | 'Partner term with vendor 1' | '5202'   | 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                  |
			| '5201'  | 'Vendor 1 (1 partner term)' | ''                | 'Partner term with vendor 1' | '5202'   | 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors_CurrencyRevaluation)'              |
			| '3540'  | 'Vendor 1 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 1' | '5201'   | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)'                     |
			| '5301'  | 'Vendor 1 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 1' | '5201'   | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                                      |
			| '3540'  | 'Vendor 1 (1 partner term)' | 'Business unit 1' | 'Partner term with vendor 1' | '5201'   | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions_CurrencyRevaluation)' |
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
			| '5201'  | 'Business unit 1'           | 'Business unit 1' | 'Partner term with vendor 1' | 'Partner term with vendor 1' | '5202'   | 'Vendor 1 (1 partner term)' | 'CashPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                   |		
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
			| '4010'  | 'Customer 1 (3 partner terms)' | 'Partner term with customer (by document + credit limit)' | 'Customer 1 (3 partner terms)' | 'Business unit 1' | '4020'   | 'Partner term with customer (by document + credit limit)' | 'CashReceipt DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                   |		
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
			| '3240'  | 'Cash, TRY'         | 'Own company 2' | ''        | 'Business unit 1' | '650'    | ''  | 'CashRevenue DR (R3010B_CashOnHand) CR (R5021_Revenues)' |		
	And I close all client application windows

Scenario: _0991140 check Debit note accounting movements
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
			| '5202'  | 'Vendor 1 (1 partner term)' | 'Business unit 1'           | 'Vendor 1'                   | 'Partner term with vendor 1' | '650'    | ''                | 'DebitNote DR (R1020B_AdvancesToVendors) CR (R5021_Revenues)'             |
			| '5201'  | 'Vendor 1 (1 partner term)' | 'Vendor 1 (1 partner term)' | 'Partner term with vendor 1' | 'Partner term with vendor 1' | '5202'   | 'Business unit 1' | 'DebitNote DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)' |
			| '4010'  | 'Vendor 1 (1 partner term)' | 'Business unit 1'           | 'Vendor 1'                   | 'Partner term with vendor 1' | '650'    | ''                | 'DebitNote DR (R2021B_CustomersTransactions) CR (R5021_Revenues)'         |		
	And I close all client application windows

Scenario: _0991145 check Credit note accounting movements
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
			| 'Debit' | 'Partner'                     | 'Business unit'                               | 'Partner term'                                | 'Expense and revenue type' | 'Credit' | 'Operation'                                                                      |
			| '4020'  | 'Customer 2 (2 partner term)' | 'Business unit 1'                             | 'Individual partner term 1 (by partner term)' | 'Other expence'            | '420.2'  | 'CreditNote DR (R2020B_AdvancesFromCustomers) CR (R5022T_Expenses)'              |
			| '4010'  | 'Customer 2 (2 partner term)' | 'Individual partner term 1 (by partner term)' | 'Individual partner term 1 (by partner term)' | 'Business unit 1'          | '4020'   | 'CreditNote DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)' |
			| '5201'  | 'Customer 2 (2 partner term)' | 'Business unit 1'                             | 'Individual partner term 1 (by partner term)' | 'Other expence'            | '420.2'  | 'CreditNote DR (R1021B_VendorsTransactions CR (R5022T_Expenses)'                 |
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
	And I close all client application windows
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
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog BusinessUnits objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create catalog CancelReturnReasons objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog ExpenseAndRevenueTypes objects
		When update ItemKeys
		When Create information register Taxes records (VAT)
	* Load data for Accounting system
		When Create chart of characteristic types AccountingExtraDimensionTypes objects

							
	
Scenario: _0991001 check preparation
	When check preparation

Scenario: _0991002 filling accounting operation
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.AccountingOperations"
	And I click "Fill default descriptions" button
	And I click "Refresh" button
	And I click "List" button		
	And "List" table became equal
		| 'Order' | 'Predefined data item name'                                                                                  | 'Description'                                                                                                    |
		| ''      | 'Document_BankPayment'                                                                                       | 'Bank payment'                                                                                                   |
		| ''      | 'Document_BankReceipt'                                                                                       | 'Bank receipt'                                                                                                   |
		| ''      | 'Document_PurchaseInvoice'                                                                                   | 'Purchase invoice'                                                                                               |
		| ''      | 'Document_RetailSalesReceipt'                                                                                | 'Retail sales receipt'                                                                                           |
		| ''      | 'Document_SalesInvoice'                                                                                      | 'Sales invoice'                                                                                                  |
		| ''      | 'Document_ForeignCurrencyRevaluation'                                                                        | 'Foreign currency revaluation'                                                                                   |
		| ''      | 'BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand'                    | 'BankPayment DR (R1020B_AdvancesToVendors R1021B_VendorsTransactions) CR (R3010B_CashOnHand)'                    |
		| ''      | 'BankPayment_DR_R5022T_Expenses_CR_R3010B_CashOnHand'                                                        | 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)'                                                        |
		| ''      | 'BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                      | 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                      |
		| ''      | 'BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions'              | 'BankReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)'              |
		| ''      | 'BankReceipt_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers'                                | 'BankReceipt DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                                |
		| ''      | 'PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions'                     | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions)'                     |
		| ''      | 'PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors'                                  | 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                  |
		| ''      | 'PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions'                                      | 'PurchaseInvoice DR (R1040B_TaxesOutgoing) CR (R1021B_VendorsTransactions)'                                      |
		| ''      | 'PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_CurrencyRevaluation'              | 'PurchaseInvoice DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors_CurrencyRevaluation)'              |
		| ''      | 'PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions_CurrencyRevaluation' | 'PurchaseInvoice DR (R4050B_StockInventory_R5022T_Expenses) CR (R1021B_VendorsTransactions_CurrencyRevaluation)' |
		| ''      | 'RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory'                                             | 'RetailSalesReceipt DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                             |
		| ''      | 'SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues'                                            | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues)'                                            |
		| ''      | 'SalesInvoice_DR_R5021T_Revenues_CR_R2040B_TaxesIncoming'                                                    | 'SalesInvoice DR (R5021T_Revenues) CR (R2040B_TaxesIncoming)'                                                    |
		| ''      | 'SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory'                                                   | 'SalesInvoice DR (R5022T_Expenses) CR (R4050B_StockInventory)'                                                   |
		| ''      | 'SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions'                               | 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions)'                               |
		| ''      | 'SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_CurrencyRevaluation'           | 'SalesInvoice DR (R2020B_AdvancesFromCustomers) CR (R2021B_CustomersTransactions_CurrencyRevaluation)'           |
		| ''      | 'SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues_CurrencyRevaluation'                        | 'SalesInvoice DR (R2021B_CustomersTransactions) CR (R5021T_Revenues_CurrencyRevaluation)'                        |
		| ''      | 'ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues'                              | 'ForeignCurrencyRevaluation DR (R2020B_AdvancesFromCustomers) CR (R5021T_Revenues)'                              |
		| ''      | 'ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers'                              | 'ForeignCurrencyRevaluation DR (R5022T_Expenses) CR (R2020B_AdvancesFromCustomers)'                              |
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
			| 'Currency'   | 'Deferred calculation'   | 'Description'      | 'Source'         | 'Type'     |
			| 'TRY'        | 'No'                     | 'Local currency'   | 'Forex Seling'   | 'Legal'    |
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
				| 'Presentation'                                            | 'Use' |
				| 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)' | 'No'  |
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
				| 'BankReceipt DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)' | 'No'  |
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
				| 'BankPayment DR (R5022T_Expenses) CR (R3010B_CashOnHand)'                                                        | 'Yes' | '01.01.2021' |
				| 'BankPayment DR (R1021B_VendorsTransactions) CR (R1020B_AdvancesToVendors)'                                      | 'Yes' | '01.01.2021' |
				| 'Bank receipt'                                                                                                   | 'No'  | ''           |
				| 'BankReceipt DR (R3010B_CashOnHand) CR (R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions)'              | 'Yes' | '01.01.2021' |
				| 'BankReceipt DR (R2021B_CustomersTransactions) CR (R2020B_AdvancesFromCustomers)'                                | 'Yes' | '01.01.2021' |
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
				| 'Manager analitics' | 'Local currency'         | 'TRY'      | 'Legal' | 'Manager analitics'   |
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
		Then the form attribute named "Order" became equal to "405"				
		And I click "Save and close" button
		* Check creation
			And "List" table contains lines
				| 'Code'                   | 'Order' | 'Description'           | 'Type' | 'Ext. Dim 2' | 'Q.'  | 'Ext. Dim 3' | 'C.' | 'Ledger type variant'               | 'Ext. Dim 1' | 'Off-balance' |
				| 'Account charts (Basic)' | ''      | ''                      | ''     | ''           | ''    | ''           | ''   | ''                                  | ''           | ''            |
				| '405'                    | '405'   | 'Group Assets acccount' | 'AP'   | ''           | 'Yes' | ''           | 'No' | 'LTV with account charts code mask' | ''           | 'No'          |
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
				| '405'                    | '405'   | 'Group Assets acccount' | 'AP'   | ''           | 'Yes' | ''           | 'No' | 'LTV with account charts code mask' | ''           | 'No'          |
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
			And in "SpreadsheetDocument" spreadsheet document I input text "908786997"
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
			| 'Code'                   | 'Order'     | 'Description'         | 'Type' | 'Ext. Dim 2'       | 'Q.'  | 'Ext. Dim 3'       | 'C.'  | 'Ledger type variant'               | 'Ext. Dim 1' | 'Off-balance' |
			| 'Account charts (Basic)' | ''          | ''                    | ''     | ''                 | ''    | ''                 | ''    | ''                                  | ''           | ''            |
			| '90878699'               | '90878699'  | 'Test assets account' | 'A'    | 'Item key (turn.)' | 'Yes' | 'Tax type (turn.)' | 'No'  | 'LTV with account charts code mask' | 'Item'       | 'No'          |
			| '908990'                 | '908990'    | 'Test group'          | 'P'    | ''                 | 'No'  | ''                 | 'Yes' | 'LTV with account charts code mask' | 'Partner'    | 'No'          |
		And I expand a line in "List" table
			| 'C.'  | 'Code'   | 'Description' | 'Ext. Dim 1' | 'Ledger type variant'               | 'Off-balance' | 'Order'  | 'Q.' | 'Type' |
			| 'Yes' | '908990' | 'Test group'  | 'Partner'    | 'LTV with account charts code mask' | 'No'          | '908990' | 'No' | 'P'    |
		* Liabilities account
			And I go to line in "List" table
				| 'C.' | 'Code'      | 'Description'              | 'Ext. Dim 1' | 'Ext. Dim 2'       | 'Ext. Dim 3'       | 'Ledger type variant'               | 'Off-balance' | 'Order'     | 'Q.'  | 'Type' |
				| 'No' | '10878699'  | 'Test liabilities account' | 'Item'       | 'Item key (turn.)' | 'Tax type (turn.)' | 'LTV with account charts code mask' | 'No'          | '108786997' | 'Yes' | 'P'    |
			And I select current line in "List" table
			And the editing text of form attribute named "Code" became equal to "108.78.699"
			Then the form attribute named "Currency" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Test liabilities account"
			And "ExtDimensionTypes" table became equal
				| 'Extra dimension type' | 'Currency' | 'Turnovers only' | 'Quantity' | 'Amount' |
				| 'Item'                 | 'Yes'      | 'No'             | 'No'       | 'Yes'    |
				| 'Item key'             | 'No'       | 'Yes'            | 'Yes'      | 'No'     |
				| 'Tax type'             | 'No'       | 'Yes'            | 'No'       | 'No'     |
			
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
				| 'C.' | 'Code'      | 'Description'         | 'Ext. Dim 1' | 'Ext. Dim 2'       | 'Ext. Dim 3'       | 'Ledger type variant'               | 'Off-balance' | 'Order'     | 'Q.'  | 'Type' |
				| 'No' | '90878699'  | 'Test assets account' | 'Item'       | 'Item key (turn.)' | 'Tax type (turn.)' | 'LTV with account charts code mask' | 'No'          | '908786997' | 'Yes' | 'A'    |
			And I select current line in "List" table
			Then the form attribute named "Code" became equal to "90878699"
			And the editing text of form attribute named "Code" became equal to "908.78.699"
			Then the form attribute named "Currency" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Test assets account"
			And "ExtDimensionTypes" table became equal
				| 'Extra dimension type' | 'Currency' | 'Turnovers only' | 'Quantity' | 'Amount' |
				| 'Item'                 | 'Yes'      | 'No'             | 'No'       | 'Yes'    |
				| 'Item key'             | 'No'       | 'Yes'            | 'Yes'      | 'No'     |
				| 'Tax type'             | 'No'       | 'Yes'            | 'No'       | 'No'     |
			
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
				| 'Yes' | '908990' | 'Test group'  | 'Partner'    | 'LTV with account charts code mask' | 'No'          | '908990' | 'No' | 'A'    |
			And I select current line in "List" table
			Then the form attribute named "Code" became equal to "908990"
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
	
		
								
								
							
								
						
									
						

						
	
				

				

// Scenario: _0991016 create accounts (cash account) - for Company
// 	And I close all client application windows
// 	* Open T9011S_AccountsCashAccount
// 		Given I open hyperlink "e1cib/list/InformationRegister.T9011S_AccountsCashAccount"
// 		And I click "Create" button
// 		And I input "01.12.2023" text in the field named "Period"
// 		And I select from the drop-down list named "Company" by "main" string
// 		And I select from "Ledger type variant" drop-down list by "manager" string
// 		And I click Choice button of the field named "Account"
	And I close all client application windows
	
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
		Then the form attribute named "Description_en" became equal to "Test account (manager analytics)"		
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
		And I close all client application windows

Scenario: _0991021 accounts settings for Cash account (general for company)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9011S_AccountsCashAccount"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2022" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.01.2022"
		Then the form attribute named "RecordType" became equal to "All"
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Ledger type variant'               | 'Cash account' | 'Account' |
			| '01.01.2022' | 'Main Company' | 'LTV with account charts code mask' | ''             | '405.01'  |
	And I close all client application windows
	
		
Scenario: _0991022 accounts settings for Cash account (for Cash account)
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9011S_AccountsCashAccount"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I change the radio button named "RecordType" value to "Cash/Bank account"
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №4' |
		And I select current line in "List" table		
		And I input "01.02.2022" text in the field named "Period"
		And I select from the drop-down list named "Company" by "main" string
		And I select from "Ledger type variant" drop-down list by "ltv" string
		And I select from the drop-down list named "Account" by "40501" string
		Then the form attribute named "Account" became equal to "405.01"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "LedgerTypeVariant" became equal to "LTV with account charts code mask"
		And the editing text of form attribute named "Period" became equal to "01.02.2022"
		Then the form attribute named "CashAccount" became equal to "Cash desk №4"		
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Ledger type variant'               | 'Cash account' | 'Account' |
			| '01.01.2022' | 'Main Company' | 'LTV with account charts code mask' | ''             | '405.01'  |
			| '01.02.2022' | 'Main Company' | 'LTV with account charts code mask' | 'Cash desk №4' | '405.01'  |
	And I close all client application windows			
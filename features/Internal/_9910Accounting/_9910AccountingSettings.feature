#language: en
@tree
@Positive
@Accounting


Feature: accounting


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _099100 preparation
	When set True value to the constant
	And I set "True" value to the constant "UseAccounting"
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
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create chart of characteristic types AccountingExtraDimensionTypes objects
	

Scenario: _099101 filling accounting operation
		And I close all client application windows
	* Open accounting operations catalog
		Given I open hyperlink "e1cib/list/Catalog.AccountingOperations"
	* Filling
		* Purchase invoice
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name' |
				| '5'    | 'Document_PurchaseInvoice'  |
			And I select current line in "List" table
			And I input "Purchase invoice" text in "ENG" field
			And I click "Save and close" button
			And I expand a line in "List" table
				| 'Code' | 'Description'      | 'Predefined data item name' |
				| '5'    | 'Purchase invoice' | 'Document_PurchaseInvoice'  |
			And I wait "en description is empty (Accounting operations) *" window closing in 20 seconds
			Then "Accounting operations" window is opened
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'                  |
				| '6'    | 'PurchaseInvoice_DR_R4050B_R5022T_CR_R1021B' |
			And I select current line in "List" table
			And I input "PurchaseInvoice_DR_R4050B (Stock inventory)_R5022T(Expenses)_CR_R1021B (Vendors transaction)" text in "ENG" field
			And I click "Save and close" button
			Then "Accounting operations" window is opened
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'           |
				| '7'    | 'PurchaseInvoice_DR_R1021B_CR_R1020B' |
			And I select current line in "List" table
			And I input "PurchaseInvoice_DR_R1021B (Vendors transaction)_CR_R1020B (Advances to vendors)" text in "ENG" field
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'           |
				| '8'    | 'PurchaseInvoice_DR_R1040B_CR_R1021B' |
			And I select current line in "List" table
			And I input "PurchaseInvoice_DR_R1040B (Taxes outgoing) _CR_R1021B (Vendors transaction)" text in "ENG" field
			And I click "Save and close" button
			Then "Accounting operations" window is opened
		* Retail sales receipt
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'   |
				| '11'   | 'Document_RetailSalesReceipt' |
			And I select current line in "List" table
			And I input "Retail sales receipt" text in "ENG" field
			And I click "Save and close" button
			And I expand current line in "List" table
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'              |
				| '12'   | 'RetailSalesReceipt_DR_R5022T_CR_R4050B' |
			And I select current line in "List" table
			And I input "RetailSalesReceipt_DR_R5022T (Expenses) _CR_R4050B (Stock inventory)" text in "ENG" field
			And I click "Save and close" button
		* Bank payment
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name' |
				| '1'    | 'Document_BankPayment'      |
			And I select current line in "List" table
			And I input "Bank payment" text in "ENG" field
			And I click "Save and close" button
			And I expand current line in "List" table
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'              |
				| '3'    | 'BankPayment_DR_R1020B_R1021B_CR_R3010B' |
			And I select current line in "List" table
			And I input "BankPayment_DR_R1020B (Advances to vendors) _R1021B (Vendors transaction) _CR_R3010B (Cash on hand)" text in "ENG" field
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'       |
				| '9'    | 'BankPayment_DR_R5022T_CR_R3010B' |
			And I select current line in "List" table
			And I input "BankPayment_DR_R5022T (Expenses)_CR_R3010B (cash on hand)" text in "ENG" field
			And I click "Save and close" button
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'       |
				| '10'   | 'BankPayment_DR_R1021B_CR_R1020B' |
			And I select current line in "List" table
			And I input "BankPayment_DR_R1021B (Vendors transaction) _CR_R1020B (Advances to vendors)" text in "ENG" field
			And I click "Save and close" button
		* Bank receipt
			And I expand a line in "List" table
				| 'Code' | 'Predefined data item name' | 'Reference'               |
				| '2'    | 'Document_BankReceipt'      | 'en description is empty' |
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name' | 'Reference'               |
				| '2'    | 'Document_BankReceipt'      | 'en description is empty' |
			And I select current line in "List" table
			And I input "Bank receipt" text in "ENG" field
			And I click "Save and close" button
			And I wait "en description is empty (Accounting operations) *" window closing in 20 seconds
			Then "Accounting operations" window is opened
			And I go to line in "List" table
				| 'Code' | 'Predefined data item name'       |
				| '4'    | 'BankReceipt_DR_R3010B_CR_R2021B' |
			And I select current line in "List" table
			And I input "BankReceipt_DR_R3010B (Cash on hand) _CR_R2021B (Customer transaction)" text in "ENG" field
			And I click "Save and close" button
	* Check 
		And "List" table became equal
			| 'Code'                  | 'Order' | 'Predefined data item name'                  | 'Description'                                                                                         | 'Reference'                                                                                           |
			| 'Accounting operations' | ''      | ''                                           | ''                                                                                                    | ''                                                                                                    |
			| '1'                     | ''      | 'Document_BankPayment'                       | 'Bank payment'                                                                                        | 'Bank payment'                                                                                        |
			| '3'                     | ''      | 'BankPayment_DR_R1020B_R1021B_CR_R3010B'     | 'BankPayment_DR_R1020B (Advances to vendors) _R1021B (Vendors transaction) _CR_R3010B (Cash on hand)' | 'BankPayment_DR_R1020B (Advances to vendors) _R1021B (Vendors transaction) _CR_R3010B (Cash on hand)' |
			| '9'                     | ''      | 'BankPayment_DR_R5022T_CR_R3010B'            | 'BankPayment_DR_R5022T (Expenses)_CR_R3010B (cash on hand)'                                           | 'BankPayment_DR_R5022T (Expenses)_CR_R3010B (cash on hand)'                                           |
			| '10'                    | ''      | 'BankPayment_DR_R1021B_CR_R1020B'            | 'BankPayment_DR_R1021B (Vendors transaction) _CR_R1020B (Advances to vendors)'                        | 'BankPayment_DR_R1021B (Vendors transaction) _CR_R1020B (Advances to vendors)'                        |
			| '2'                     | ''      | 'Document_BankReceipt'                       | 'Bank receipt'                                                                                        | 'Bank receipt'                                                                                        |
			| '4'                     | ''      | 'BankReceipt_DR_R3010B_CR_R2021B'            | 'BankReceipt_DR_R3010B (Cash on hand) _CR_R2021B (Customer transaction)'                              | 'BankReceipt_DR_R3010B (Cash on hand) _CR_R2021B (Customer transaction)'                              |
			| '5'                     | ''      | 'Document_PurchaseInvoice'                   | 'Purchase invoice'                                                                                    | 'Purchase invoice'                                                                                    |
			| '6'                     | ''      | 'PurchaseInvoice_DR_R4050B_R5022T_CR_R1021B' | 'PurchaseInvoice_DR_R4050B (Stock inventory)_R5022T(Expenses)_CR_R1021B (Vendors transaction)'        | 'PurchaseInvoice_DR_R4050B (Stock inventory)_R5022T(Expenses)_CR_R1021B (Vendors transaction)'        |
			| '7'                     | ''      | 'PurchaseInvoice_DR_R1021B_CR_R1020B'        | 'PurchaseInvoice_DR_R1021B (Vendors transaction)_CR_R1020B (Advances to vendors)'                     | 'PurchaseInvoice_DR_R1021B (Vendors transaction)_CR_R1020B (Advances to vendors)'                     |
			| '8'                     | ''      | 'PurchaseInvoice_DR_R1040B_CR_R1021B'        | 'PurchaseInvoice_DR_R1040B (Taxes outgoing) _CR_R1021B (Vendors transaction)'                         | 'PurchaseInvoice_DR_R1040B (Taxes outgoing) _CR_R1021B (Vendors transaction)'                         |
			| '11'                    | ''      | 'Document_RetailSalesReceipt'                | 'Retail sales receipt'                                                                                | 'Retail sales receipt'                                                                                |
			| '12'                    | ''      | 'RetailSalesReceipt_DR_R5022T_CR_R4050B'     | 'RetailSalesReceipt_DR_R5022T (Expenses) _CR_R4050B (Stock inventory)'                                | 'RetailSalesReceipt_DR_R5022T (Expenses) _CR_R4050B (Stock inventory)'                                |		
		And I close all client application windows
		
		
Scenario: _099102 create ledger type
	And I close all client application windows
	* Open accounting operations catalog
		Given I open hyperlink "e1cib/list/Catalog.LedgerTypes"	
	* Create new element			
		And I click the button named "FormCreate"
		And I input "Management" text in "ENG" field
		And I click Select button of "Currency movement type" field
		Then "Multi currency movement types" window is opened
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
			| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
		And I select current line in "List" table
		And I click Choice button of the field named "Variant"
		And I click "Create" button
		And I input "Management analitics" text in "ENG" field
		And I click "Save and close" button
		And I wait "Ledger type variants (create) *" window closing in 20 seconds
		Then "Ledger type variants" window is opened
		And I click "Select" button
		* Filling dates
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                                        | 'Use' |
				| 'BankPayment_DR_R1020B (Advances to vendors) _R1021B (Vendors transaction) _CR_R3010B (Cash on hand)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                              | 'Use' |
				| 'BankPayment_DR_R5022T (Expenses)_CR_R3010B (cash on hand)' | 'No'  |
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                 | 'Use' |
				| 'BankPayment_DR_R1021B (Vendors transaction) _CR_R1020B (Advances to vendors)' | 'No'  |
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                           | 'Use' |
				| 'BankReceipt_DR_R3010B (Cash on hand) _CR_R2021B (Customer transaction)' | 'No'  |
			And I select current line in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'     | 'Use' |
				| 'Purchase invoice' | 'No'  |
			And I activate "Presentation" field in "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                                 | 'Use' |
				| 'PurchaseInvoice_DR_R4050B (Stock inventory)_R5022T(Expenses)_CR_R1021B (Vendors transaction)' | 'No'  |
			And I activate "Period" field in "OperationsTree" table
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                    | 'Use' |
				| 'PurchaseInvoice_DR_R1021B (Vendors transaction)_CR_R1020B (Advances to vendors)' | 'No'  |
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                                | 'Use' |
				| 'PurchaseInvoice_DR_R1040B (Taxes outgoing) _CR_R1021B (Vendors transaction)' | 'No'  |
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I go to line in "OperationsTree" table
				| 'Presentation'                                                         | 'Use' |
				| 'RetailSalesReceipt_DR_R5022T (Expenses) _CR_R4050B (Stock inventory)' | 'No'  |
			And I select current line in "OperationsTree" table
			And I input "01.01.2021" text in "Period" field of "OperationsTree" table
			And I finish line editing in "OperationsTree" table
			And I click "Save and close" button
		* Check creation
			And "List" table became equal
				| 'Description' | 'Currency movement type' | 'Currency' | 'Type'  | 'Variant'              | 'Reference'  |
				| 'Management'  | 'Local currency'         | 'TRY'      | 'Legal' | 'Management analitics' | 'Management' |
			And I close all client application windows
			
Scenario: _099103 create account charts
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/ChartOfAccounts.Basic"	
	* Create new element (4050)			 
		And I click the button named "FormCreate"
		Then "Account chart (Basic) (create)" window is opened
		And I input "4050" text in the field named "Code"
		And I input "10" text in the field named "Order"
		And I input "Stock inventory" text in "ENG" field
		And I select "Assets" exact value from the drop-down list named "Type"
		And I click Choice button of the field named "Variant"
		And I go to line in "List" table
				| 'Description'          |
				| 'Management analitics' |
		And I select current line in "List" table
		And I set checkbox named "Quantity"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I select current line in "ExtDimensionTypes" table
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' | 'Reference' | 'Value type' |
			| 'Item'        | 'Item'      | 'Item'       |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		Then "Accounting extra dimensions" window is opened
		And I go to line in "List" table
			| 'Description' | 'Reference' | 'Value type' |
			| 'Item key'    | 'Item key'  | 'Item key'   |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' | 'Reference' | 'Value type' |
			| 'Store'       | 'Store'     | 'Store'      |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And I click "Save and close" button
		And I wait "Account chart (Basic) (create) *" window closing in 20 seconds
	* Create new element (5022)	
		And I go to line in "List" table
			| 'Code'                   |
			| 'Account charts (Basic)' |
		And I change "Variant" radio button value to "Management analitics"
		And I click "Create" button
		Then the form attribute named "Variant" became equal to "Management analitics"		
		And I input "5022" text in the field named "Code"
		And I input "70" text in the field named "Order"
		And I input "Service (expense)" text in "ENG" field
		And I select "Liabilities" exact value from the drop-down list named "Type"
		And I set checkbox named "Currency"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' | 'Reference' | 'Value type' |
			| 'Item'        | 'Item'      | 'Item'       |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'  | 'Reference'    | 'Value type'               |
			| 'Expense type' | 'Expense type' | 'Expense and revenue type' |
		And I select current line in "List" table
		Then "Account chart (Basic) (create) *" window is opened
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'   | 'Reference'     | 'Value type'    |
			| 'Business unit' | 'Business unit' | 'Business unit' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create new element (1021)	
		And I go to line in "List" table
			| 'Code'                   |
			| 'Account charts (Basic)' |
		And I click "Create" button
		Then the form attribute named "Variant" became equal to "Management analitics"		
		And I input "1021" text in the field named "Code"
		And I input "30" text in the field named "Order"
		And I input "Due to vendors" text in "ENG" field
		And I select "Liabilities" exact value from the drop-down list named "Type"
		And I set checkbox named "Currency"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner'     |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Partner term' |
		And I select current line in "List" table
		Then "Account chart (Basic) (create) *" window is opened
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Legal name'  |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create new element (1020)	
		And I go to line in "List" table
			| 'Code'                   |
			| 'Account charts (Basic)' |
		And I click "Create" button
		Then the form attribute named "Variant" became equal to "Management analitics"		
		And I input "1020" text in the field named "Code"
		And I input "31" text in the field named "Order"
		And I input "Vendors advances" text in "ENG" field
		And I select "Liabilities" exact value from the drop-down list named "Type"
		And I set checkbox named "Currency"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner'     |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Partner term' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create new element (2021)	
		And I go to line in "List" table
			| 'Code'                   |
			| 'Account charts (Basic)' |
		And I click "Create" button
		Then the form attribute named "Variant" became equal to "Management analitics"		
		And I input "2021" text in the field named "Code"
		And I input "40" text in the field named "Order"
		And I input "Customers due" text in "ENG" field
		And I select "Liabilities" exact value from the drop-down list named "Type"
		And I set checkbox named "Currency"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner'     |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Partner term' |
		And I select current line in "List" table
		Then "Account chart (Basic) (create) *" window is opened
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Legal name'  |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create new element (2020)	
		And I go to line in "List" table
			| 'Code'                   |
			| 'Account charts (Basic)' |
		And I click "Create" button
		Then the form attribute named "Variant" became equal to "Management analitics"		
		And I input "2020" text in the field named "Code"
		And I input "41" text in the field named "Order"
		And I input "Customers advances" text in "ENG" field
		And I select "Liabilities" exact value from the drop-down list named "Type"
		And I set checkbox named "Currency"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Partner'     |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Legal name'  |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create new element (1040)	
		And I go to line in "List" table
			| 'Code'                   |
			| 'Account charts (Basic)' |
		And I click "Create" button
		Then the form attribute named "Variant" became equal to "Management analitics"		
		And I input "1040" text in the field named "Code"
		And I input "50" text in the field named "Order"
		And I input "Tax outgoing" text in "ENG" field
		And I select "Liabilities" exact value from the drop-down list named "Type"
		And I set checkbox named "Currency"
		And in the table "ExtDimensionTypes" I click the button named "ExtDimensionTypesAdd"
		And I click choice button of "Extra dimension type" attribute in "ExtDimensionTypes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Tax type'     |
		And I select current line in "List" table
		And I finish line editing in "ExtDimensionTypes" table
		And I click "Save and close" button
		
				
Scenario: _099104 create account for item key
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9010S_AccountsItemKey"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2021" text in the field named "Period"
		And I change the radio button named "RecordType" value to "Item types"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Variant"
		And I go to line in "List" table
			| 'Description'          |
			| 'Management analitics' |
		And I select current line in "List" table
		And I select "Product" exact value from "Type of item type" drop-down list
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| '4050' | 'Stock inventory' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create new element for service			 
		And I click the button named "FormCreate"
		And I input "01.01.2021" text in the field named "Period"	
		And I change the radio button named "RecordType" value to "Item types"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Variant"
		And I go to line in "List" table
			| 'Description'          |
			| 'Management analitics' |
		And I select current line in "List" table
		And I select "Service" exact value from "Type of item type" drop-down list
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| '5022' | 'Service (expense)' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check
		And "List" table became equal
			| 'Period'     | 'Company'      | 'Variant'              | 'Item' | 'Item key' | 'Item type' | 'Type of item type' | 'Account' |
			| '01.01.2021' | 'Main Company' | 'Management analitics' | ''     | ''         | ''          | 'Service'           | '5022'    |
			| '01.01.2021' | 'Main Company' | 'Management analitics' | ''     | ''         | ''          | 'Product'           | '4050'    |
		

Scenario: _099105 create account for partner
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9012S_AccountsPartner"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I input "01.01.2021" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Variant"
		And I go to line in "List" table
			| 'Description'          |
			| 'Management analitics' |
		And I select current line in "List" table
		And I click Select button of "Account Vendor (advances)" field
		And I go to line in "List" table
			| 'Code' | 'Currency' | 'Description'      | 'Off-balance' | 'Order' | 'Quantity' | 'Reference' | 'Type' | 'Variant'              |
			| '1020' | 'Yes'      | 'Vendors advances' | 'No'          | '31'    | 'No'       | '1020'      | 'P'    | 'Management analitics' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I click Select button of "Account Vendor (transactions)" field
		And I go to line in "List" table
			| 'Code' | 'Currency' | 'Description'    | 'Off-balance' | 'Order' | 'Quantity' | 'Reference' | 'Type' | 'Variant'              |
			| '1021' | 'Yes'      | 'Due to vendors' | 'No'          | '30'    | 'No'       | '1021'      | 'P'    | 'Management analitics' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I click Select button of "Account Customer (advances)" field
		And I go to line in "List" table
			| 'Code' | 'Currency' | 'Description'        | 'Off-balance' | 'Order' | 'Quantity' | 'Reference' | 'Type' | 'Variant'              |
			| '2020' | 'Yes'      | 'Customers advances' | 'No'          | '41'    | 'No'       | '2020'      | 'P'    | 'Management analitics' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I click Select button of "Account Customer (transactions)" field
		And I go to line in "List" table
			| 'Code' | 'Currency' | 'Description'   | 'Off-balance' | 'Order' | 'Quantity' | 'Reference' | 'Type' | 'Variant'              |
			| '2021' | 'Yes'      | 'Customers due' | 'No'          | '40'    | 'No'       | '2021'      | 'P'    | 'Management analitics' |
		And I activate field named "Description" in "List" table
		And I select current line in "List" table
		And I click "Save and close" button
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Partner' | 'Variant'              | 'Agreement' | 'Account Vendor (transactions)' | 'Account Customer (advances)' | 'Account Vendor (advances)' | 'Account Customer (transactions)' |
			| '01.01.2021' | 'Main Company' | ''        | 'Management analitics' | ''          | '1021'                          | '2020'                        | '1020'                      | '2021'                            |
		And I close all client application windows
		
		
Scenario: _099106 create account for tax
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/InformationRegister.T9013S_AccountsTax"	
	* Create new element for product			 
		And I click the button named "FormCreate"
		And I change the radio button named "RecordType" value to "Tax type"	
		And I input "01.01.2021" text in the field named "Period"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Variant"
		And I go to line in "List" table
			| 'Description'          |
			| 'Management analitics' |
		And I select current line in "List" table	
		And I click Choice button of the field named "Tax"
		And I go to line in "List" table
			| 'Description'  |
			| 'VAT' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| '1040' | 'Tax outgoing' |
		And I select current line in "List" table
		And I click "Save and close" button	
	* Check
		And "List" table contains lines
			| 'Period'     | 'Company'      | 'Variant'              | 'Tax' | 'Account' |
			| '01.01.2021' | 'Main Company' | 'Management analitics' | 'VAT' | '1040'    |
		And I close all client application windows
		
Scenario: _099115 select ledger type for Company
	And I close all client application windows
	* Open list form
		Given I open hyperlink "e1cib/list/Catalog.Companies"
	* Select Company
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Ledger types settings
		And I move to "Ledger types" tab
		And in the table "CompanyLedgerTypes" I click the button named "CompanyLedgerTypesAdd"
		And I input "01.01.2021" text in the field named "CompanyLedgerTypesPeriod" of "CompanyLedgerTypes" table
		And I activate "Ledger type" field in "CompanyLedgerTypes" table
		And I click choice button of "Ledger type" attribute in "CompanyLedgerTypes" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Management' |
		And I select current line in "List" table
		And I click "Save and close" button	
	* Check
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And "CompanyLedgerTypes" table became equal
			| 'Period'     | 'Use' | 'Ledger type' |
			| '01.01.2021' | 'Yes' | 'Management'  |
		And I close all client application windows
		
					

Scenario: _0991020 check Purchase invoice accounting movements
		And I close all client application windows
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"	
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'  |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'AP/AR posting detail' | 'Description'        | 'Kind'    |
			| 'By documents'         | 'Vendor Ferron, TRY' | 'Regular' |
		And I select current line in "List" table
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click choice button of the attribute named "ItemListStore" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
	* Chack accounting transaction
		And in the table "ItemList" I click "Edit accounting" button
		Then the form attribute named "LedgerType" became equal to "Management"
		And "AccountingAnalytics" table became equal
			| 'Debit' | 'Partner'   | 'Partner term'       | 'Legal name'        | 'Credit' | ' '                 | 'Operation'                                                                                    |
			| '1021'  | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' | '1020'   | ''                  | 'PurchaseInvoice_DR_R1021B (Vendors transaction)_CR_R1020B (Advances to vendors)'              |
			| '4050'  | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Store 02'          | '1021'   | 'Company Ferron BP' | 'PurchaseInvoice_DR_R4050B (Stock inventory)_R5022T(Expenses)_CR_R1021B (Vendors transaction)' |
			| '1040'  | 'Ferron BP' | 'Vendor Ferron, TRY' | ''                  | '1021'   | 'Company Ferron BP' | 'PurchaseInvoice_DR_R1040B (Taxes outgoing) _CR_R1021B (Vendors transaction)'                  |
		And I close all client application windows
		
		
				
		
				
		
				
		
				

							


		
				
		
				
		
				
		
		
				
		
						

						
		
				
		
				
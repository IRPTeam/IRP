#language: en
@tree
@Positive
@StandartAgreement

Feature: accounting of receivables / payables under Standard type Partner terms

As an accountant
I want to settle general Partner terms for all partners.


Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _060000 preparation
	* Constants
		When set True value to the constant
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
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Countries objects
		When Create catalog BusinessUnits objects 
	* Tax settings
		When filling in Tax settings for company


Scenario: _060002 create Sales invoice with the type of settlements under standard Partner terms and check its movements
	* Create Sales invoice №601
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'     |
			And I select current line in "List" table
		// * Change the sales invoice number to 601
		// 	And I move to "Other" tab
		// 	And I expand "More" group
		// 	And I input "601" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "601" text in "Number" field
		* Adding items to Sales Invoice
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "20,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberSalesInvoice060002$$"
			And I save the window as "$$SalesInvoice060002$$"
		* Check filling in sales invoice
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'Basic Price Types' | 'pcs'  | '*'          | '*'          | '11 000,00'    | 'Store 01' |
			And I click "Post and close" button
	* Check movements Sales Invoice by register PartnerArTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'               | 'Legal name'        | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type' |
		| 'TRY'      | '$$SalesInvoice060002$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'TRY'                          |
		| 'TRY'      | '$$SalesInvoice060002$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'Local currency'               |
		| 'USD'      | '$$SalesInvoice060002$$' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'     | 'Nicoletta' | 'Reporting currency'           |
		| 'TRY'      | '$$SalesInvoice060002$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'en description is empty'      |
	And I close all client application windows

Scenario: _060003 create Cash reciept with the type of settlements under standard Partner terms and check its movements
	* Create Cash reciept №601
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №2' |
			And I select current line in "List" table
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code' |
				| 'TRY'  |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                            |
				| 'Posting by Standard Partner term Customer' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		// * Change the document number to 601
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "601" text in "Number" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberCashReceipt060003$$"
		And I save the window as "$$CashReceipt060003$$"
		And I click "Post and close" button
	* Check movements by register PartnerArTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | '$$CashReceipt060003$$' | 'Company Nicoletta' | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en description is empty' |
		And I close all client application windows

Scenario: _060004 check the offset of the advance for Sales invoice with the type of settlement under standard Partner terms and check its movements
	And I delete "$$NumberSalesInvoice060004$$" variable
	And I delete "$$SalesInvoice060004$$" variable
	And I delete "$$NumberBankReceipt060004$$" variable
	And I delete "$$BankReceipt060004$$" variable
	* Create Bank reciept №602
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, TRY' |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "12 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I select current line in "PaymentList" table
			And I click Clear button of "Partner term" field
			And I finish line editing in "PaymentList" table
		// * Change the document number to 602
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "602" text in "Number" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBankReceipt060004$$"
		And I save the window as "$$BankReceipt060004$$"
		And I click "Post and close" button
	* Check movements Bank Receipt by register AdvanceFromCustomers
		Given I open hyperlink "e1cib/list/AccumulationRegister.AdvanceFromCustomers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Legal name'        | 'Company'      | 'Receipt document'      | 'Partner'   | 'Multi currency movement type' | 'Amount'    |
		| 'TRY'      | '$$BankReceipt060004$$' | 'Company Nicoletta' | 'Main Company' | '$$BankReceipt060004$$' | 'Nicoletta' | 'en description is empty'      | '12 000,00' |
		And I close all client application windows
	* Create Sales invoice with the type of settlements under standard Partner terms
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'     |
			And I select current line in "List" table
		// * Change the sales invoice number to 602
		// 	And I move to "Other" tab
		// 	And I expand "More" group
		// 	And I input "602" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "602" text in "Number" field
		* Adding items to Sales Invoice
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "20,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberSalesInvoice060004$$"
			And I save the window as "$$SalesInvoice060004$$"
			And I click "Post and close" button
	* Check movements SalesInvoice by register PartnerArTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'               | 'Legal name'        | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type' |
		| 'TRY'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'TRY'                          |
		| 'TRY'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'Local currency'               |
		| 'USD'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'     | 'Nicoletta' | 'Reporting currency'           |
		| 'TRY'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'TRY'                          |
		| 'TRY'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'Local currency'               |
		| 'USD'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'     | 'Nicoletta' | 'Reporting currency'           |
		| 'TRY'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'en description is empty'      |
		| 'TRY'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Nicoletta' | 'en description is empty'      |
	* Check movements SalesInvoice by register AdvanceFromCustomers
		Given I open hyperlink "e1cib/list/AccumulationRegister.AdvanceFromCustomers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'               | 'Legal name'        | 'Company'      | 'Receipt document'      | 'Partner'   | 'Multi currency movement type' | 'Amount'    | 'Deferred calculation' |
		| 'TRY'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | 'Main Company' | '$$BankReceipt060004$$' | 'Nicoletta' | 'Local currency'               | '11 000,00' | 'No'                   |
		| 'USD'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | 'Main Company' | '$$BankReceipt060004$$' | 'Nicoletta' | 'Reporting currency'           | '1 883,56'  | 'No'                   |
		| 'TRY'      | '$$SalesInvoice060004$$' | 'Company Nicoletta' | 'Main Company' | '$$BankReceipt060004$$' | 'Nicoletta' | 'en description is empty'      | '11 000,00' | 'No'                   |

Scenario: _060005 create Purchase invoice with the type of settlements under standard contracts and check its movements
	* Create Purchase invoice №601
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'     |
			And I select current line in "List" table
		// * Change the document number to 601
		// 	And I move to "Other" tab
		// 	And I input "601" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "601" text in "Number" field
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "20,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "550,00" text in "Price" field of "ItemList" table
		* Check filling in purchase invoice
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'en description is empty' | 'pcs'  | '1 677,97'   | '9 322,03'   | '11 000,00'    | 'Store 01' |
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberPurchaseInvoice060005$$"
			And I save the window as "$$PurchaseInvoice060005$$"
	* Check movements Purchase Invoice by register PartnerApTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                  | 'Legal name'       | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner' | 'Multi currency movement type' |
		| 'TRY'      | '$$PurchaseInvoice060005$$' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Veritas' | 'TRY'                          |
		| 'TRY'      | '$$PurchaseInvoice060005$$' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Veritas' | 'Local currency'               |
		| 'USD'      | '$$PurchaseInvoice060005$$' | 'Company Veritas ' | ''               | 'Main Company' | '1 883,56'  | 'Standard'     | 'Veritas' | 'Reporting currency'           |
		| 'TRY'      | '$$PurchaseInvoice060005$$' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Veritas' | 'en description is empty'      |
		And I close all client application windows
	
Scenario: _060006 create Cash payment with the type of settlements under standard contracts and check its movements
	* Create Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №2' |
			And I select current line in "List" table
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code' |
				| 'TRY'  |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                            |
				| 'Posting by Standard Partner term (Veritas)' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		// * Change the document number to 601
			// And I input "0" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "601" text in "Number" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberCashPayment060006$$"
			And I save the window as "$$CashPayment060006$$"
		And I click "Post and close" button
	* Check movements by register PartnerArTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Legal name'      | 'Company'      | 'Amount'    | 'Partner term' | 'Partner' | 'Multi currency movement type' |
		| 'TRY'      | '$$CashPayment060006$$' | 'Company Veritas' | 'Main Company' | '11 000,00' | 'Standard'     | 'Veritas' | 'en description is empty'      |
		And I close all client application windows

Scenario: _060007 check the offset of Purchase invoice advance with the type of settlement under standard contracts and check its movements
	* Create Bank payment №602
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, TRY' |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'   |
			And I select current line in "List" table
			And I click Clear button of "Partner term" field
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "12 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		// * Change the document number to 602
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "602" text in "Number" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBankPayment060007$$"
		And I save the window as "$$BankPayment060007$$"
		And I click "Post and close" button
	* Check movements Bank Payment by register AdvanceToSuppliers
		Given I open hyperlink "e1cib/list/AccumulationRegister.AdvanceToSuppliers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'              | 'Legal name'       | 'Company'      | 'Partner' | 'Payment document'      | 'Multi currency movement type' | 'Amount'    | 'Deferred calculation' |
			| 'TRY'      | '$$BankPayment060007$$' | 'Company Veritas ' | 'Main Company' | 'Veritas' | '$$BankPayment060007$$' | 'Local currency'               | '12 000,00' | 'No'                   |
			| 'USD'      | '$$BankPayment060007$$' | 'Company Veritas ' | 'Main Company' | 'Veritas' | '$$BankPayment060007$$' | 'Reporting currency'           | '2 054,79'  | 'No'                   |
			| 'TRY'      | '$$BankPayment060007$$' | 'Company Veritas ' | 'Main Company' | 'Veritas' | '$$BankPayment060007$$' | 'en description is empty'      | '12 000,00' | 'No'                   |
		And I close all client application windows
	* Create Purchase Invoice №602
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'     |
			And I select current line in "List" table
		// * Change the document number to 602
		// 	And I move to "Other" tab
		// 	And I input "602" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "602" text in "Number" field
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "20,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "550,00" text in "Price" field of "ItemList" table
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberPurchaseInvoice060007$$"
			And I save the window as "$$PurchaseInvoice060007$$"
	* Check movements PurchaseInvoice by register PartnerApTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                  | 'Legal name'       | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner' | 'Multi currency movement type' |
		| 'TRY'      | '$$PurchaseInvoice060007$$' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Veritas' | 'TRY'                          |
		| 'TRY'      | '$$PurchaseInvoice060007$$' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Veritas' | 'Local currency'               |
		| 'USD'      | '$$PurchaseInvoice060007$$' | 'Company Veritas ' | ''               | 'Main Company' | '1 883,56'  | 'Standard'     | 'Veritas' | 'Reporting currency'           |
		| 'TRY'      | '$$PurchaseInvoice060007$$' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'     | 'Veritas' | 'en description is empty'      |
		And I close all client application windows
	* Check movements Purchase Invoice by register AdvanceFromCustomers
		Given I open hyperlink "e1cib/list/AccumulationRegister.AdvanceToSuppliers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                  | 'Legal name'       | 'Company'      | 'Partner' | 'Payment document'      | 'Multi currency movement type' | 'Amount'    | 'Deferred calculation' |
		| 'TRY'      | '$$PurchaseInvoice060007$$' | 'Company Veritas ' | 'Main Company' | 'Veritas' | '$$BankPayment060007$$' | 'Local currency'               | '11 000,00' | 'No'                   |
		| 'USD'      | '$$PurchaseInvoice060007$$' | 'Company Veritas ' | 'Main Company' | 'Veritas' | '$$BankPayment060007$$' | 'Reporting currency'           | '1 883,56'  | 'No'                   |
		| 'TRY'      | '$$PurchaseInvoice060007$$' | 'Company Veritas ' | 'Main Company' | 'Veritas' | '$$BankPayment060007$$' | 'en description is empty'      | '11 000,00' | 'No'                   |



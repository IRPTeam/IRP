#language: en
@tree
@Positive
Feature: accounting of receivables / payables under Standard type Partner terms

As an accountant
I want to settle general Partner terms for all partners.


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _060001 preparation
	* Create a test segment of Standard clients
		Given I open hyperlink "e1cib/list/Catalog.PartnerSegments"
		And I click the button named "FormCreate"
		And I input "Standard" text in "ENG" field
		And I click "Save and close" button
	* Create vendor (Veritas) and client (Nicoletta)
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Nicoletta" text in "ENG" field
		And I change checkbox "Vendor"
		And I change checkbox "Customer"
		And I change checkbox "Shipment confirmations before sales invoice"
		And I change checkbox "Goods receipt before purchase invoice"
		And I click "Save" button
		And In this window I click command interface button "Partner segments content"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		And I go to line in "List" table
			| 'Description' |
			| 'Standard'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Partner segments content (create) *" window closing in 20 seconds
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
		And I input "Company Nicoletta" text in "ENG" field
		And I click Select button of "Country" field
		And I go to line in "List" table
			| 'Description' |
			| 'Turkey'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Veritas" text in "ENG" field
		And I change checkbox "Vendor"
		And I change checkbox "Shipment confirmations before sales invoice"
		And I change checkbox "Goods receipt before purchase invoice"
		And I click "Save" button
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
		And I input "Company Veritas " text in "ENG" field
		And I click Select button of "Country" field
		And I go to line in "List" table
			| 'Description' |
			| 'Turkey'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Create Partner term Standard
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And I change "Kind" radio button value to "Standard"
		And I input "Standard" text in "ENG" field
		And I input "01.12.2019" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Currency' |
			| 'TRY'      |
		And I select current line in "List" table
		And I input "01.12.2019" text in "Start using" field
		And I click "Save and close" button
	* Create an individual Partner term for the vendor with the type of settlements Standard 
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And I input "Posting by Standard Partner term (Veritas)" text in "ENG" field
		And I change "Type" radio button value to "Vendor"
		And I input "01.12.2019" text in "Date" field
		And I change "AP/AR posting detail" radio button value to "By standard partner term"
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Currency' |
			| 'TRY'      |
		And I select current line in "List" table
		And I click Select button of "Standard Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Standard'    |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Veritas'     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Vendor price, TRY' |
		And I select current line in "List" table
		And I change checkbox "Price include tax"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And I click "Save and close" button
	* Create an individual Partner term for the customer with the type of settlements Standard
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And I input "Posting by Standard Partner term Customer" text in "ENG" field
		And I change "Type" radio button value to "Customer"
		And I input "01.12.2019" text in "Date" field
		And I change "AP/AR posting detail" radio button value to "By standard partner term"
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Currency' |
			| 'TRY'      |
		And I select current line in "List" table
		And I click Select button of "Standard Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Standard'    |
		And I select current line in "List" table
		And I click Select button of "Partner segment" field
		And I go to line in "List" table
			| 'Description' |
			| 'Standard'     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Basic Price Types' |
		And I select current line in "List" table
		And I change checkbox "Price include tax"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And I click "Save and close" button

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
		* Change the sales invoice number to 601
			And I move to "Other" tab
			And I expand "More" group
			And I input "601" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "601" text in "Number" field
		* Adding items to Sales Invoice
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
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
		* Check filling in sales invoice
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'Basic Price Types' | 'pcs'  | '*'          | '*'          | '11 000,00'    | 'Store 01' |
			And I click "Post and close" button
	* Check movements Sales Invoice by register PartnerArTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 601*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en descriptions is empty' |
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
		* Change the document number to 601
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "601" text in "Number" field
		And I click "Post and close" button
	* Check movements by register PartnerArTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | 'Cash receipt 601*' | 'Company Nicoletta' | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en descriptions is empty' |
		And I close all client application windows

Scenario: _060004 check the offset of the advance for Sales invoice with the type of settlement under standard Partner terms and check its movements
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
		* Change the document number to 602
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "602" text in "Number" field
		And I click "Post and close" button
	* Check movements Bank Receipt by register AdvanceFromCustomers
		Given I open hyperlink "e1cib/list/AccumulationRegister.AdvanceFromCustomers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Receipt document'  | 'Partner'   | 'Multi currency movement type'   | 'Amount'    |
		| 'TRY'      | 'Bank receipt 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'en descriptions is empty' | '12 000,00' |
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
		* Change the sales invoice number to 602
			And I move to "Other" tab
			And I expand "More" group
			And I input "602" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "602" text in "Number" field
		* Adding items to Sales Invoice
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
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
			And I click "Post and close" button
	* Check movements SalesInvoice by register PartnerArTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'TRY'                      |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'Local currency'           |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Nicoletta' | 'Reporting currency'       |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en descriptions is empty' |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Nicoletta' | 'en descriptions is empty' |
	* Check movements SalesInvoice by register AdvanceFromCustomers
		Given I open hyperlink "e1cib/list/AccumulationRegister.AdvanceFromCustomers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'           | 'Legal name'        | 'Company'      | 'Receipt document'  | 'Partner'   | 'Multi currency movement type'   | 'Amount'    | 'Deferred calculation' |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'Local currency'           | '11 000,00' | 'No'                   |
		| 'USD'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'Reporting currency'       | '1 883,56'  | 'No'                   |
		| 'TRY'      | 'Sales invoice 602*' | 'Company Nicoletta' | 'Main Company' | 'Bank receipt 602*' | 'Nicoletta' | 'en descriptions is empty' | '11 000,00' | 'No'                   |

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
		* Change the document number to 601
			And I move to "Other" tab
			And I input "601" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "601" text in "Number" field
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
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
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'en descriptions is empty' | 'pcs'  | '1 677,97'   | '9 322,03'   | '11 000,00'    | 'Store 01' |
			And I click "Post" button
	* Check movements Purchase Invoice by register PartnerApTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner' | 'Multi currency movement type'   |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'TRY'                      |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'Local currency'           |
		| 'USD'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Veritas' | 'Reporting currency'       |
		| 'TRY'      | 'Purchase invoice 601*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'en descriptions is empty' |
		And I close all client application windows
	
Scenario: _060006 create Cash payment with the type of settlements under standard contracts and check its movements
	* Create Cash payment №601
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
		* Change the document number to 601
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "601" text in "Number" field
		And I click "Post and close" button
	* Check movements by register PartnerArTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'          | 'Legal name'        | 'Company'      | 'Amount'    | 'Partner term' | 'Partner'   | 'Multi currency movement type'   |
		| 'TRY'      | 'Cash payment 601*' | 'Company Veritas'   | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas'   | 'en descriptions is empty' |
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
		* Change the document number to 602
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "602" text in "Number" field
		And I click "Post and close" button
	* Check movements Bank Payment by register AdvanceToSuppliers
		Given I open hyperlink "e1cib/list/AccumulationRegister.AdvanceToSuppliers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'          | 'Legal name'       | 'Company'      | 'Partner' | 'Payment document'  | 'Multi currency movement type'   | 'Amount'    | 'Deferred calculation' |
			| 'TRY'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Local currency'           | '12 000,00' | 'No'                   |
			| 'USD'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Reporting currency'       | '2 054,79'  | 'No'                   |
			| 'TRY'      | 'Bank payment 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'en descriptions is empty' | '12 000,00' | 'No'                   |
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
		* Change the document number to 602
			And I move to "Other" tab
			And I input "602" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "602" text in "Number" field
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
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
	* Check movements PurchaseInvoice by register PartnerApTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Basis document' | 'Company'      | 'Amount'    | 'Partner term' | 'Partner' | 'Multi currency movement type'   |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'TRY'                      |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'Local currency'           |
		| 'USD'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '1 883,56'  | 'Standard'  | 'Veritas' | 'Reporting currency'       |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | ''               | 'Main Company' | '11 000,00' | 'Standard'  | 'Veritas' | 'en descriptions is empty' |
		And I close all client application windows
	* Check movements Purchase Invoice by register AdvanceFromCustomers
		Given I open hyperlink "e1cib/list/AccumulationRegister.AdvanceToSuppliers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Legal name'       | 'Company'      | 'Partner' | 'Payment document'  | 'Multi currency movement type'   | 'Amount'    | 'Deferred calculation' |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Local currency'           | '11 000,00' | 'No'                   |
		| 'USD'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'Reporting currency'       | '1 883,56'  | 'No'                   |
		| 'TRY'      | 'Purchase invoice 602*' | 'Company Veritas ' | 'Main Company' | 'Veritas' | 'Bank payment 602*' | 'en descriptions is empty' | '11 000,00' | 'No'                   |



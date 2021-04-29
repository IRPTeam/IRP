#language: en
@tree
@Positive
@LinkedTransaction

Feature: buttons for selecting base documents



Background:
	Given I launch TestClient opening script or connect the existing one


# Crystal partners

Scenario: _2050001 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
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
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
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
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
	When Create document PurchaseInvoice objects (linked)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.PurchaseInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
	* Save PI numbers
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '101' |
		And I select current line in "List" table	
		And I delete "$$PurchaseInvoice2040005$$" variable
		And I delete "$$NumberPurchaseInvoice2040005$$" variable
		And I save the window as "$$PurchaseInvoice2040005$$"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice2040005$$"
		And I close current window
		And I go to line in "List" table
			| 'Number'    |
			| '102' |
		And I select current line in "List" table	
		And I delete "$$PurchaseInvoice20400051$$" variable
		And I delete "$$NumberPurchaseInvoice20400051$$" variable
		And I save the window as "$$PurchaseInvoice20400051$$"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice20400051$$"
		And I close all client application windows
	When Create document SalesInvoice objects (linked)
	And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);" |
	* Save SI numbers
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '101' |
		And I select current line in "List" table	
		And I delete "$$SalesInvoice20400022$$" variable
		And I delete "$$NumberSalesInvoice20400022$$" variable
		And I save the window as "$$SalesInvoice20400022$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice20400022$$"
		And I close current window
		And I go to line in "List" table
			| 'Number'    |
			| '102' |
		And I select current line in "List" table	
		And I delete "$$SalesInvoice2040002$$" variable
		And I delete "$$NumberSalesInvoice2040002$$" variable
		And I save the window as "$$SalesInvoice2040002$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice2040002$$"
		And I close current window
		And I go to line in "List" table
			| 'Number'    |
			| '103' |
		And I select current line in "List" table	
		And I delete "$$SalesInvoice20400021$$" variable
		And I delete "$$NumberSalesInvoice20400021$$" variable
		And I save the window as "$$SalesInvoice20400021$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice20400021$$"
		And I close all client application windows
	* Create Bank payment without reference to the partner term and the document
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		* Filling in the details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description    |
				| Bank account, TRY |
			And I select current line in "List" table
			And I input begin of the current month date in "Date" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I click "List" button		
			And I go to line in "List" table
				| Description |
				| Crystal   |
			And I select current line in "List" table
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "1000,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$BankPayment2050001$$" variable
		And I delete "$$NumberBankPayment2050001$$" variable
		And I save the window as "$$BankPayment2050001$$"
		And I save the value of "Number" field as "$$NumberBankPayment2050001$$"
		And I click the button named "FormPostAndClose"
	* Create Bank receipt without reference to the partner term and the document
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		* Filling in the details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description    |
				| Bank account, TRY |
			And I select current line in "List" table
			And I input begin of the current month date in "Date" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Crystal   |
			And I select current line in "List" table
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "20000,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$BankReceipt2050001$$" variable
		And I delete "$$NumberBankReceipt2050001$$" variable
		And I save the window as "$$BankReceipt2050001$$"
		And I save the value of "Number" field as "$$NumberBankReceipt2050001$$"
		And I click the button named "FormPostAndClose"
	* Create Cash receipt linked by document
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		* Filling in the details of the document
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code | Description  |
				| TRY  | Turkish lira |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №3 |
			And I select current line in "List" table
			And I input begin of the current month date in "Date" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Crystal   |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			# temporarily
			And Delay 2
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			And Delay 2
			And I go to line in "List" table
				| 'Legal name'   | 'Partner' |
				| 'Company Adel' | 'Crystal' |
			And I click "Select" button
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "5000,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$CashReceipt2050001$$" variable
		And I delete "$$NumberCashReceipt2050001$$" variable
		And I save the window as "$$CashReceipt2050001$$"
		And I save the value of "Number" field as "$$NumberCashReceipt2050001$$"
		And I click the button named "FormPostAndClose"
	* Create Cash payment without reference to the partner term and the document
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		* Filling in the details of the document
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code | Description  |
				| TRY  | Turkish lira |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №3 |
			And I select current line in "List" table
			And I input begin of the current month date in "Date" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Crystal   |
			And I select current line in "List" table
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "5000,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$CashPayment2050001$$" variable
		And I delete "$$NumberCashPayment2050001$$" variable
		And I save the window as "$$CashPayment2050001$$"
		And I save the value of "Number" field as "$$NumberCashPayment2050001$$"
		And I click the button named "FormPostAndClose"
	* Check or create PurchaseReturn300301
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseReturn300301$$" |
			When create PurchaseReturn300301
	* Check or create SalesReturn30001
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesReturn30001$$" |
			When create SalesReturn30001
	

Scenario: 2050002 check filling in Reconcilation statement
	* Open a creation form Reconcilation statement
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I click the button named "FormCreate"
	* Fill in a document header
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Begin period" field
		And I input "01.03.2020" text in "Begin period" field		
		And I input end of the current month date in "End period" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Crystal' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Company Adel' |
		And I select current line in "List" table
	* Check filling in tabular part
		And in the table "Transactions" I click "Fill" button
		And "Transactions" table contains lines
		| 'Date' | 'Document'                    | 'Credit'    | 'Debit'     |
		| '*'    | '$$CashPayment2050001$$*'     | ''          | '5 000,00'  |
		| '*'    | '$$CashReceipt2050001$$*'     | '5 000,00'  | ''          |
		| '*'    | '$$BankPayment2050001$$*'     | ''          | '1 000,00'  |
		| '*'    | '$$BankReceipt2050001$$*'     | '20 000,00' | ''          |
		| '*'    | '$$SalesInvoice20400022$$'    | ''          | '20 980,00' |
		| '*'    | '$$SalesInvoice2040002$$'     | ''          | '1 740,00'  |
		| '*'    | '$$SalesInvoice20400021$$'    | ''          | '28 686,30' |
		| '*'    | '$$PurchaseInvoice2040005$$'  | '40 544,80' | ''          |
	* Check document
		And I click the button named "FormPost"
	* Clear movements
		And I click "Clear posting" button
		And I close all client application windows






Scenario: _2050007 check the movements of the Invoice match document with the client when transferring the amount from document to document
	* Open a creation form Invoice match
		Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
		And I click the button named "FormCreate"
	* Filling the document header
		And I select "With customer" exact value from "Operation type" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "PartnerArTransactionsBasisDocument"
		And I go to line in "" table
			| 'Column1'       |
			| 'Sales invoice' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number' | 'Partner' |
			| '$$NumberSalesInvoice20400022$$'  | 'Crystal' |
		And I activate "Partner" field in "List" table
		And I select current line in "List" table
	* Filling in the tabular part Transaction
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of the attribute named "TransactionsPartnerArTransactionsBasisDocument" in "Transactions" table
		And I go to line in "" table
			| ''              |
			| 'Sales invoice' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesInvoice2040002$$'  |
		And I select current line in "List" table
		And I activate field named "TransactionsPartner" in "Transactions" table
		And I click choice button of the attribute named "TransactionsPartner" in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I activate field named "TransactionsLegalName" in "Transactions" table
		And I click choice button of the attribute named "TransactionsLegalName" in "Transactions" table
		And I select current line in "List" table
		And I activate field named "TransactionsAgreement" in "Transactions" table
		And I click choice button of the attribute named "TransactionsAgreement" in "Transactions" table
		And I go to line in "List" table
			| 'AP/AR posting detail' | 'Description'           | 'Kind'    |
			| 'By documents'         | 'Basic Partner terms, TRY' | 'Regular' |
		And I select current line in "List" table
		And I activate field named "TransactionsCurrency" in "Transactions" table
		And I click choice button of the attribute named "TransactionsCurrency" in "Transactions" table
		And I go to line in "List" table
			| 'Code' | 'Description'  |
			| 'TRY'  | 'Turkish lira' |
		And I select current line in "List" table
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "2 000,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I activate field named "TransactionsClosingAmount" in "Transactions" table
		And I select current line in "Transactions" table
		And I input "2 000,00" text in the field named "TransactionsClosingAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
	* Check movements
		And I click the button named "FormPost"
		And I delete "$$InvoiceMatch2050007$$" variable
		And I delete "$$NumberInvoiceMatch2050007$$" variable
		And I save the window as "$$InvoiceMatch2050007$$"
		And I save the value of "Number" field as "$$NumberInvoiceMatch2050007$$"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$InvoiceMatch2050007$$'             | ''            | ''       | ''          | ''             | ''                         | ''        | ''             | ''                         | ''         | ''                             | ''                     |
		| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                         | ''        | ''             | ''                         | ''         | ''                             | ''                     |
		| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''                         | ''        | ''             | ''                         | ''         | ''                             | ''                     |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''        | ''             | ''                         | ''         | ''                             | 'Attributes'           |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner' | 'Legal name'   | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | '$$SalesInvoice2040002$$'  | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | '$$SalesInvoice2040002$$'  | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | '$$SalesInvoice2040002$$'  | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-342,4'   | 'Main Company' | '$$SalesInvoice2040002$$'  | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '342,4'    | 'Main Company' | '$$SalesInvoice20400022$$' | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | '$$SalesInvoice20400022$$' | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | '$$SalesInvoice20400022$$' | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | '$$SalesInvoice20400022$$' | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                          | 'No'                   |
		And I close all client application windows

Scenario: _2050008 check of movements in case of cancellation and re-post of Invoice match №3
	* Select Invoice match
		Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInvoiceMatch2050007$$'     |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Check for no movement
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document does not contain values
		| Register  "R2021 Customer transactions" |
		And I close current window
	* Re-post and check movements
		Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberInvoiceMatch2050007$$'     |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$InvoiceMatch2050007$$'             | ''            | ''       | ''          | ''             | ''                         | ''        | ''             | ''                         | ''         | ''                             | ''                     |
		| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                         | ''        | ''             | ''                         | ''         | ''                             | ''                     |
		| 'Register  "R2021 Customer transactions"' | ''            | ''       | ''          | ''             | ''                         | ''        | ''             | ''                         | ''         | ''                             | ''                     |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''        | ''             | ''                         | ''         | ''                             | 'Attributes'           |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner' | 'Legal name'   | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | '$$SalesInvoice2040002$$'  | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | '$$SalesInvoice2040002$$'  | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-2 000'    | 'Main Company' | '$$SalesInvoice2040002$$'  | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '-342,4'   | 'Main Company' | '$$SalesInvoice2040002$$'  | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '342,4'    | 'Main Company' | '$$SalesInvoice20400022$$' | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | '$$SalesInvoice20400022$$' | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | '$$SalesInvoice20400022$$' | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                                    | 'Expense'     | '*'      | '2 000'     | 'Main Company' | '$$SalesInvoice20400022$$' | 'Crystal' | 'Company Adel' | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                          | 'No'                   |
		And I close all client application windows

Scenario: _2050008 check the availability of Purchase return and Sales return choices in the Invoice match document
	* Open a creation form Invoice match
		Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
		And I click the button named "FormCreate"
	* Filling the document header (transaction type - with customer)
		And I select "With customer" exact value from "Operation type" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "PartnerArTransactionsBasisDocument"
		And I go to line in "" table
			| 'Column1'       |
			| 'Purchase return' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number' | 'Partner' |
			| '$$NumberPurchaseReturn300301$$'      | 'Ferron BP' |
		And I select current line in "List" table
		Then the form attribute named "PartnerArTransactionsBasisDocument" became equal to "$$PurchaseReturn300301$$" template
	* Filling the document header (transaction type - with vendor)
		And I select "With vendor" exact value from "Operation type" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "PartnerApTransactionsBasisDocument"
		And I go to line in "" table
			| 'Column1'       |
			| 'Sales return' |
		And I select current line in "" table
		And I go to line in "List" table
			| 'Number' | 'Partner' |
			| '$$NumberSalesReturn30001$$'      | 'Kalipso' |
		And I select current line in "List" table
		Then the form attribute named "PartnerApTransactionsBasisDocument" became equal to "$$SalesReturn30001$$" template
	And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session


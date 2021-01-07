#language: en
@tree
@Positive
@CashManagement

Feature: expense and income planning


As a financier
I want to create documents Incoming payment order and Outgoing payment order
For expense and income planning



Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _080000 preparation (Incoming payment order and Outgoing payment order)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog Companies objects (partners company)
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	

Scenario: _080001 create Incoming payment order
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	And I click Select button of "Account" field
	And I go to line in "List" table
		| Description         |
		| Bank account, USD |
	And I select current line in "List" table
	And I click Select button of "Currency" field
	And I go to line in "List" table
		| Code | Description     |
		| USD  | American dollar |
	And I select current line in "List" table
	And I input begin of the next month date in "Planning date" field
	* Filling in tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Lomaniti    |
		And I select current line in "List" table
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description     |
			| Company Lomaniti |
		And I select current line in "List" table
		And I activate "Amount" field in "PaymentList" table
		And I input "1 000,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
	And I click the button named "FormPost"
	And I delete "$$NumberIncomingPaymentOrder080001$$" variable
	And I delete "$$IncomingPaymentOrder080001$$" variable
	And I save the value of "Number" field as "$$NumberIncomingPaymentOrder080001$$"
	And I save the window as "$$IncomingPaymentOrder080001$$"
	And I click the button named "FormPostAndClose"
	And "List" table contains lines
		| 'Number'                               | 'Company'      | 'Account'           | 'Currency' |
		| '$$NumberIncomingPaymentOrder080001$$' | 'Main Company' | 'Bank account, USD' | 'USD'      |
	And I close all client application windows

Scenario: _080002 check Incoming payment order movements
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                       | 'Basis document'                 | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Amount'   |
			| 'USD'      | '$$IncomingPaymentOrder080001$$' | '$$IncomingPaymentOrder080001$$' | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | '1 000,00' |
		And I close all client application windows
	* Clear movements and check that there is no movement on the registers
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberIncomingPaymentOrder080001$$'      |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table does not contain lines
			| 'Currency' | 'Recorder'                       | 'Basis document'                 | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Amount'   |
			| 'USD'      | '$$IncomingPaymentOrder080001$$' | '$$IncomingPaymentOrder080001$$' | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | '1 000,00' |
		And I close all client application windows
	* Re-posting the document and checking movements on the registers
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberIncomingPaymentOrder080001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                  | 'Basis document'             | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'    |
			| 'USD'      | '$$IncomingPaymentOrder080001$$' | '$$IncomingPaymentOrder080001$$'  | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti'  | 'Company Lomaniti'   | '1 000,00'  |
		And I close all client application windows
	

Scenario: _080003 check connection to Incoming payment order of the Registration report
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberIncomingPaymentOrder080001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And I select "Planing cash transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$IncomingPaymentOrder080001$$'             | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''                  | ''         | ''                    | ''         | ''                | ''                         | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | '$$IncomingPaymentOrder080001$$' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'en description is empty' | 'No'                   |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | '$$IncomingPaymentOrder080001$$' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Reporting currency'       | 'No'                   |
		| ''                                      | '*'      | '5 627,5'  | 'Main Company' | '$$IncomingPaymentOrder080001$$' | 'Bank account, USD' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Local currency'           | 'No'                   |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberIncomingPaymentOrder080001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And I select "Planing cash transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$IncomingPaymentOrder080001$$'        | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''         | ''                | ''                             | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''         | ''                | ''                             | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''         | ''                | ''                             | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                               | ''                  | ''         | ''                    | ''         | ''                | ''                             | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'                 | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'      | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | '$$IncomingPaymentOrder080001$$' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'en description is empty'      | 'No'                   |
		| ''                                      | '*'      | '1 000'     | 'Main Company' | '$$IncomingPaymentOrder080001$$' | 'Bank account, USD' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Reporting currency'           | 'No'                   |
		| ''                                      | '*'      | '5 627,5'  | 'Main Company' | '$$IncomingPaymentOrder080001$$' | 'Bank account, USD' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Local currency'               | 'No'                   |
	And I close all client application windows

Scenario: _080004 check Description in IncomingPaymentOrder
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	When check Description
	And I close all client application windows

Scenario: _080005 create Bank receipt based on Incoming payment order
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberIncomingPaymentOrder080001$$'      |
	* Create Bank receipt from Incoming Payment Order
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
		And I activate "Amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "250,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0800051$$" variable
		And I delete "$$BankReceipt080005$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0800051$$"
		And I save the window as "$$BankReceipt080005$$"
		And I click the button named "FormPostAndClose"
	* Create one more Bank receipt from Incoming Payment Order list form
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberIncomingPaymentOrder080001$$'      |
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
		And I activate "Amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "250,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0800051$$" variable
		And I delete "$$BankReceipt0800051$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0800051$$"
		And I save the window as "$$BankReceipt0800051$$"
		And I click the button named "FormPostAndClose"
	* Check movements by register Planing cash transactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Basis document'                 | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'  | 'Legal name' | 'Amount'  |
		| 'USD'      | '$$BankReceipt080005$$' | '$$IncomingPaymentOrder080001$$' | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti' | '*'          | '-250,00' |
		| 'USD'      | '$$BankReceipt0800051$$' | '$$IncomingPaymentOrder080001$$' | 'Main Company' | 'Bank account, USD' | 'Incoming'            | 'Lomaniti' | '*'          | '-250,00' |
	

Scenario: _080006 create Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	And I click Select button of "Account" field
	And I go to line in "List" table
		| Description         |
		| Bank account, TRY |
	And I select current line in "List" table
	And I click Select button of "Currency" field
	And I go to line in "List" table
		| Code |
		| TRY  |
	And I select current line in "List" table
	And I input begin of the next month date in "Planning date" field
	* Change status
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Ferron BP    |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And I activate "Amount" field in "PaymentList" table
		And I input "3 000,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
	And I click the button named "FormPost"
	And I delete "$$NumberOutgoingPaymentOrder080006$$" variable
	And I delete "$$OutgoingPaymentOrder080006$$" variable
	And I save the value of "Number" field as "$$NumberOutgoingPaymentOrder080006$$"
	And I save the window as "$$OutgoingPaymentOrder080006$$"
	And I click the button named "FormPostAndClose"
	And "List" table contains lines
		| Number | Company       | Account           | Currency |
		| 1      |  Main Company |  Bank account, TRY | TRY      |
	And I close all client application windows

Scenario: _080007 check Outgoing payment order movements
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                       | 'Basis document'                 | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'   |
		| 'TRY'      | '$$OutgoingPaymentOrder080006$$' | '$$OutgoingPaymentOrder080006$$' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '3 000,00' |
		And I close all client application windows
	* Clear movements and check that there is no movement on the registers
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberOutgoingPaymentOrder080006$$'      |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table does not contain lines
			| 'Currency' | 'Recorder'                       | 'Basis document'                 | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'   |
			| 'TRY'      | '$$OutgoingPaymentOrder080006$$' | '$$OutgoingPaymentOrder080006$$' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '3 000,00' |
		And I close all client application windows
	* * Re-posting the document and checking movements on the registers
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberOutgoingPaymentOrder080006$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                       | 'Basis document'                 | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'   |
			| 'TRY'      | '$$OutgoingPaymentOrder080006$$' | '$$OutgoingPaymentOrder080006$$' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '3 000,00' |
		And I close all client application windows

	
Scenario: _080008 check connection to Outgoing payment order of the Registration report
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberOutgoingPaymentOrder080006$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$OutgoingPaymentOrder080006$$'        | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''          | ''                  | ''                             | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''          | ''                  | ''                             | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''          | ''                  | ''                             | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                               | ''                  | ''         | ''                    | ''          | ''                  | ''                             | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'                 | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | '*'      | '513,6'     | 'Main Company' | '$$OutgoingPaymentOrder080006$$' | 'Bank account, TRY' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'           | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | '$$OutgoingPaymentOrder080006$$' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en description is empty'      | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | '$$OutgoingPaymentOrder080006$$' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'               | 'No'                   |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberOutgoingPaymentOrder080006$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$OutgoingPaymentOrder080006$$'        | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''          | ''                  | ''                             | ''                     |
		| 'Document registrations records'        | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''          | ''                  | ''                             | ''                     |
		| 'Register  "Planing cash transactions"' | ''       | ''          | ''             | ''                               | ''                  | ''         | ''                    | ''          | ''                  | ''                             | ''                     |
		| ''                                      | 'Period' | 'Resources' | 'Dimensions'   | ''                               | ''                  | ''         | ''                    | ''          | ''                  | ''                             | 'Attributes'           |
		| ''                                      | ''       | 'Amount'    | 'Company'      | 'Basis document'                 | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | '*'      | '513,6'     | 'Main Company' | '$$OutgoingPaymentOrder080006$$' | 'Bank account, TRY' | 'USD'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Reporting currency'           | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | '$$OutgoingPaymentOrder080006$$' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'en description is empty'      | 'No'                   |
		| ''                                      | '*'      | '3 000'     | 'Main Company' | '$$OutgoingPaymentOrder080006$$' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | 'Local currency'               | 'No'                   |
	And I close all client application windows

Scenario: _080009 check Description in Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	When check Description
	And I close all client application windows

Scenario: _080010 create Bank payment based on Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberOutgoingPaymentOrder080006$$'      |
	* Create Bank payment from Outgoing payment order
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
		And I activate "Amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "250,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment08000101$$" variable
		And I delete "$$BankPayment08000101$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment08000101$$"
		And I save the window as "$$BankPayment08000101$$"
		And I click the button named "FormPostAndClose"
	* Create Bank payment from Outgoing payment order list
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberOutgoingPaymentOrder080006$$'      |
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
		And I activate "Amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "250,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment08000102$$" variable
		And I delete "$$BankPayment08000102$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment08000102$$"
		And I save the window as "$$BankPayment08000102$$"
		And I click the button named "FormPostAndClose"
	* Check movements by register Planing cash transactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                | 'Basis document'                 | 'Company'      | 'Account'           | 'Cash flow direction' | 'Partner'   | 'Legal name'        | 'Amount'  |
		| 'TRY'      | '$$BankPayment08000101$$' | '$$OutgoingPaymentOrder080006$$' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '-250,00' |
		| 'TRY'      | '$$BankPayment08000102$$' | '$$OutgoingPaymentOrder080006$$' | 'Main Company' | 'Bank account, TRY' | 'Outgoing'            | 'Ferron BP' | 'Company Ferron BP' | '-250,00' |
		And I close all client application windows


# Filters

Scenario: _080011 filter check by own companies in the document Incoming payment order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	When check the filter by own company
	
Scenario: _080012 check Description in Incoming payment order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	When check filling in Description


Scenario: _080013 filter check by own companies in the document Outgoing payment order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	When check the filter by own company

Scenario: _080014 check Description in Outgoing payment order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	When check filling in Description

# EndFilters

Scenario: _080015 check the display of the header of the collapsible group in Incoming payment order
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	When check the display of the header of the collapsible group in planned incoming/outgoing documents
	And I input current date in the field named "PlaningDate"
	And I move to the next attribute
	Then the field named "DecorationGroupTitleUncollapsedLabel" value contains "Company: Main Company   Account: Cash desk №2   Currency: TRY   Planning date:" text
	And I close all client application windows

Scenario: _080016 check the display of the header of the collapsible group in Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	When check the display of the header of the collapsible group in planned incoming/outgoing documents
	And I input current date in the field named "PlaningDate"
	And I move to the next attribute
	Then the field named "DecorationGroupTitleUncollapsedLabel" value contains "Company: Main Company   Account: Cash desk №2   Currency: TRY   Planning date:" text
	And I close all client application windows



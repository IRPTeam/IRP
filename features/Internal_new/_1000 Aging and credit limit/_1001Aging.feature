#language: en
@tree
@Positive
@AgingAndCreditLimit

Feature: payment terms



Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _1000000 preparation (payment terms)
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
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check previous movements for Kalipso
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table contains lines Then
			| "Partner" |
			| "Kalipso" |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		If "List" table contains lines Then
			| 'Number' |
			| '1' |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		If "List" table contains lines Then
			| 'Number' |
			| '1' |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close all client application windows

Scenario: _1000001 filling in payment terms
	Given I open hyperlink "e1cib/list/Catalog.PaymentSchedules"
	* Post-shipment credit (7 days)
		And I click the button named "FormCreate"
		And I input "7 days" text in "ENG" field
		And I activate "Proportion of payment" field in "StagesOfPayment" table
		And in the table "StagesOfPayment" I click the button named "StagesOfPaymentAdd"
		And I select "Post-shipment credit" exact value from "Calculation type" drop-down list in "StagesOfPayment" table
		And I move to the next attribute
		And I input "100,00" text in "Proportion of payment" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I activate "Due period, days" field in "StagesOfPayment" table
		And I select current line in "StagesOfPayment" table
		And I input "7" text in "Due period, days" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I click "Save and close" button		
	* Post-shipment credit (14 days)
		And I click the button named "FormCreate"
		And I input "14 days" text in "ENG" field
		And in the table "StagesOfPayment" I click the button named "StagesOfPaymentAdd"
		And I select "Post-shipment credit" exact value from "Calculation type" drop-down list in "StagesOfPayment" table
		And I move to the next attribute
		And I input "100,00" text in "Proportion of payment" field of "StagesOfPayment" table
		And I activate "Due period, days" field in "StagesOfPayment" table
		And I input "14" text in "Due period, days" field of "StagesOfPayment" table
		And I finish line editing in "StagesOfPayment" table
		And I click "Save and close" button


Scenario: _1000002 filling in payment terms in the Partner term
	Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Basic Partner terms, TRY (7 days)
		And I go to line in "List" table
			| 'Description'              |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab				
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description' |
			| '7 days'      |
		And I select current line in "List" table
		And I click "Save and close" button
	* Basic Partner terms, without VAT (14 days)
		And I go to line in "List" table
			| 'Description'                      |
			| 'Basic Partner terms, without VAT' |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description' |
			| '14 days'     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click "Save and close" button

Scenario: _1000003 create Sales invoice and check Aging tab
	* Create first test SI
		When create SalesInvoice024016 (Shipment confirmation does not used)
		* Check aging tab
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number' |
					| '$$NumberSalesInvoice024016$$'|
			And I select current line in "List" table
			And I move to "Aging" tab
			And "PaymentTerms" table contains lines
				| 'Calculation type'     | 'Date'       | 'Due period, days' | 'Proportion of payment' | 'Amount' |
				| 'Post-shipment credit' | '*'          | '14'               | '100,00'                | '550,00' |
		* Check payment date calculation
			And I move to "Other" tab
			And I input "20.10.2020 00:00:00" text in "Date" field
			And I move to "Aging" tab
			Then "Update item list info" window is opened
			And I click "OK" button
			And "PaymentTerms" table contains lines
				| 'Calculation type'     | 'Date'         | 'Due period, days' | 'Proportion of payment' | 'Amount' |
				| 'Post-shipment credit' | '03.11.2020'   | '14'               | '100,00'                | '550,00' |
		* Manualy change payment date
			And I move to "Aging" tab
			And I select current line in "PaymentTerms" table
			And I input "04.11.2020" text in "Date" field of "PaymentTerms" table
			And I finish line editing in "PaymentTerms" table
			And "PaymentTerms" table contains lines
				| 'Calculation type'     | 'Date'         | 'Due period, days' | 'Proportion of payment' | 'Amount' |
				| 'Post-shipment credit' | '04.11.2020'   | '15'               | '100,00'                | '550,00' |
		* Manualy change 'Due period, days'
			And I select current line in "PaymentTerms" table
			And I input "16" text in "Due period, days" field of "PaymentTerms" table
			And I finish line editing in "PaymentTerms" table
			And "PaymentTerms" table contains lines
				| 'Calculation type'     | 'Date'         | 'Due period, days' | 'Proportion of payment' | 'Amount' |
				| 'Post-shipment credit' | '05.11.2020'   | '16'               | '100,00'                | '550,00' |
			And I click the button named "FormPost"
			And I delete "$$SalesInvoice0240162$$" variable
			And I delete "$$DateSalesInvoice0240162$$" variable
			And I save the window as "$$SalesInvoice0240162$$"
			And I save the value of the field named "Date" as "$$DateSalesInvoice0240162$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number' |
					| '$$NumberSalesInvoice024016$$'|
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice0240162$$'             | ''            | ''                            | ''          | ''             | ''                        | ''                                 | ''                        | ''                                 | ''         | ''                             | ''                     | '' | '' |
				| 'Document registrations records'      | ''            | ''                            | ''          | ''             | ''                        | ''                                 | ''                        | ''                                 | ''         | ''                             | ''                     | '' | '' |
				| 'Register  "Partner AR transactions"' | ''            | ''                            | ''          | ''             | ''                        | ''                                 | ''                        | ''                                 | ''         | ''                             | ''                     | '' | '' |
				| ''                                    | 'Record type' | 'Period'                      | 'Resources' | 'Dimensions'   | ''                        | ''                                 | ''                        | ''                                 | ''         | ''                             | 'Attributes'           | '' | '' |
				| ''                                    | ''            | ''                            | 'Amount'    | 'Company'      | 'Basis document'          | 'Partner'                          | 'Legal name'              | 'Partner term'                     | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
				| ''                                    | 'Receipt'     | '$$DateSalesInvoice0240162$$' | '94,18'     | 'Main Company' | '$$SalesInvoice0240162$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
				| ''                                    | 'Receipt'     | '$$DateSalesInvoice0240162$$' | '550'       | 'Main Company' | '$$SalesInvoice0240162$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
				| ''                                    | 'Receipt'     | '$$DateSalesInvoice0240162$$' | '550'       | 'Main Company' | '$$SalesInvoice0240162$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
				| ''                                    | 'Receipt'     | '$$DateSalesInvoice0240162$$' | '550'       | 'Main Company' | '$$SalesInvoice0240162$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
				| ''                                    | ''            | ''                            | ''          | ''             | ''                        | ''                                 | ''                        | ''                                 | ''         | ''                             | ''                     | '' | '' |
				| 'Register  "Aging"'                   | ''            | ''                            | ''          | ''             | ''                        | ''                                 | ''                        | ''                                 | ''         | ''                             | ''                     | '' | '' |
				| ''                                    | 'Record type' | 'Period'                      | 'Resources' | 'Dimensions'   | ''                        | ''                                 | ''                        | ''                                 | ''         | ''                             | ''                     | '' | '' |
				| ''                                    | ''            | ''                            | 'Amount'    | 'Company'      | 'Partner'                 | 'Agreement'                        | 'Invoice'                 | 'Payment date'                     | 'Currency' | ''                             | ''                     | '' | '' |
				| ''                                    | 'Receipt'     | '$$DateSalesInvoice0240162$$' | '550'       | 'Main Company' | 'Kalipso'                 | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240162$$' | '05.11.2020 00:00:00'              | 'TRY'      | ''                             | ''                     | '' | '' |
				| ''                                    | ''            | ''                            | ''          | ''             | ''                        | ''                                 | ''                        | ''                                 | ''         | ''                             | ''                     | '' | '' |
			And I close all client application windows
	* Create second test SI
		When create SalesInvoice024016 (Shipment confirmation does not used)
	* Save payment terms date
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesInvoice024016$$'|
		And I select current line in "List" table
		And I move to "Aging" tab
		And I select current line in "PaymentTerms" table
		And I delete "$$DatePaymentTermsSalesInvoice0240161$$" variable
		And I save the value of "PaymentTermsDate" field of "PaymentTerms" table as "$$DatePaymentTermsSalesInvoice0240161$$"
		And I click the button named "FormPostAndClose"
	* Check Aging movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.Aging"
		And "List" table contains lines
		| 'Period'                      | 'Recorder'                | 'Currency' | 'Company'      | 'Partner' | 'Amount' | 'Agreement'                        | 'Invoice'                 | 'Payment date'                            |
		| '$$DateSalesInvoice024016$$'  | '$$SalesInvoice024016$$'  | 'TRY'      | 'Main Company' | 'Kalipso' | '550,00' | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$'  | '$$DatePaymentTermsSalesInvoice0240161$$' |
		| '$$DateSalesInvoice0240162$$' | '$$SalesInvoice0240162$$' | 'TRY'      | 'Main Company' | 'Kalipso' | '550,00' | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240162$$' | '05.11.2020'                              |
		And I close all client application windows
		
Scenario: _1000009 create Cash receipt and check Aging register moovements
	* Create Cash receipt
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
				| 'Kalipso'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'              |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'      | 'Partner' | 'Document'               |
				| '550,00'          | 'Main Company' | 'Company Kalipso' | 'Kalipso' | '$$SalesInvoice0240162$$' |
			And I click "Select" button
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "550,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt1000009$$" variable
		And I delete "$$CashReceipt1000009$$" variable
		And I delete "$$DateCashReceipt1000009$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt1000009$$"
		And I save the window as "$$CashReceipt1000009$$"
		And I save the value of the field named "Date" as "$$DateCashReceipt1000009$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberCashReceipt1000009$$'  |
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$CashReceipt1000009$$'               | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Document registrations records'       | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'  | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | 'Attributes'           |
		| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'                          | 'Legal name'                   | 'Partner term'                     | 'Currency'        | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '$$DateCashReceipt1000009$$' | '94,18'                | 'Main Company'   | '$$SalesInvoice0240162$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'USD'             | 'Reporting currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '$$DateCashReceipt1000009$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240162$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'             | 'Local currency'               | 'No'                   |
		| ''                                     | 'Expense'     | '$$DateCashReceipt1000009$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240162$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'             | 'TRY'                          | 'No'                   |
		| ''                                     | 'Expense'     | '$$DateCashReceipt1000009$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240162$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'             | 'en description is empty'      | 'No'                   |
		| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Aging"'                    | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Partner'                | 'Agreement'                        | 'Invoice'                      | 'Payment date'                     | 'Currency'        | ''                             | ''                     |
		| ''                                     | 'Expense'     | '$$DateCashReceipt1000009$$' | '550'                  | 'Main Company'   | 'Kalipso'                | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240162$$'       | '05.11.2020 00:00:00'              | 'TRY'             | ''                             | ''                     |
		| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Accounts statement"'       | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | ''               | ''                       | ''                                 | 'Dimensions'                   | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'                   | 'Company'                      | 'Partner'                          | 'Legal name'      | 'Basis document'               | 'Currency'             |
		| ''                                     | 'Expense'     | '$$DateCashReceipt1000009$$' | ''                     | ''               | ''                       | '550'                              | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso' | '$$SalesInvoice0240162$$'       | 'TRY'                  |
		| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'                         | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Expense'     | '$$DateCashReceipt1000009$$' | '550'                  | 'Main Company'   | 'Company Kalipso'        | 'TRY'                              | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Account balance"'          | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | 'Attributes'                       | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Account'                | 'Currency'                         | 'Multi currency movement type' | 'Deferred calculation'             | ''                | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '$$DateCashReceipt1000009$$' | '94,18'                | 'Main Company'   | 'Cash desk №2'           | 'USD'                              | 'Reporting currency'           | 'No'                               | ''                | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '$$DateCashReceipt1000009$$' | '550'                  | 'Main Company'   | 'Cash desk №2'           | 'TRY'                              | 'Local currency'               | 'No'                               | ''                | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '$$DateCashReceipt1000009$$' | '550'                  | 'Main Company'   | 'Cash desk №2'           | 'TRY'                              | 'en description is empty'      | 'No'                               | ''                | ''                             | ''                     |
		And I close all client application windows

Scenario: _1000015 create Bank receipt and check Aging register moovements
	* Create Bank receipt
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
				| 'Kalipso'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'              |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'      | 'Partner' | 'Document'               |
				| '550,00'          | 'Main Company' | 'Company Kalipso' | 'Kalipso' | '$$SalesInvoice024016$$' |
			And I click "Select" button
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt1000015$$" variable
		And I delete "$$BankReceipt1000015$$" variable
		And I delete "$$DateBankReceipt1000015$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt1000015$$"
		And I save the window as "$$BankReceipt1000015$$"
		And I save the value of the field named "Date" as "$$DateBankReceipt1000015$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt1000015$$'  |
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$BankReceipt1000015$$'               | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Document registrations records'       | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'  | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | 'Attributes'           |
		| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'                          | 'Legal name'                   | 'Partner term'                     | 'Currency'        | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '$$DateBankReceipt1000015$$' | '34,25'                | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'USD'             | 'Reporting currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '$$DateBankReceipt1000015$$' | '200'                  | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'             | 'Local currency'               | 'No'                   |
		| ''                                     | 'Expense'     | '$$DateBankReceipt1000015$$' | '200'                  | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'             | 'TRY'                          | 'No'                   |
		| ''                                     | 'Expense'     | '$$DateBankReceipt1000015$$' | '200'                  | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'             | 'en description is empty'      | 'No'                   |
		| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Aging"'                    | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Partner'                | 'Agreement'                        | 'Invoice'                      | 'Payment date'                     | 'Currency'        | ''                             | ''                     |
		| ''                                     | 'Expense'     | '$$DateBankReceipt1000015$$' | '200'                  | 'Main Company'   | 'Kalipso'                | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$'       | '*'                                | 'TRY'             | ''                             | ''                     |
		| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Accounts statement"'       | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | ''               | ''                       | ''                                 | 'Dimensions'                   | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'                   | 'Company'                      | 'Partner'                          | 'Legal name'      | 'Basis document'               | 'Currency'             |
		| ''                                     | 'Expense'     | '$$DateBankReceipt1000015$$' | ''                     | ''               | ''                       | '200'                              | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso' | ' $$SalesInvoice024016$$'      | 'TRY'                  |
		| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'                         | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Expense'     | '$$DateBankReceipt1000015$$' | '200'                  | 'Main Company'   | 'Company Kalipso'        | 'TRY'                              | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| 'Register  "Account balance"'          | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | 'Attributes'                       | ''                | ''                             | ''                     |
		| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Account'                | 'Currency'                         | 'Multi currency movement type' | 'Deferred calculation'             | ''                | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '$$DateBankReceipt1000015$$' | '34,25'                | 'Main Company'   | 'Bank account, TRY'      | 'USD'                              | 'Reporting currency'           | 'No'                               | ''                | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '$$DateBankReceipt1000015$$' | '200'                  | 'Main Company'   | 'Bank account, TRY'      | 'TRY'                              | 'Local currency'               | 'No'                               | ''                | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '$$DateBankReceipt1000015$$' | '200'                  | 'Main Company'   | 'Bank account, TRY'      | 'TRY'                              | 'en description is empty'      | 'No'                               | ''                | ''                             | ''                     |
		And I close all client application windows


Scenario: _1000020 create Credit note and check Aging register moovements
	* Create document
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the basis document for debt write-offs
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'       |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Kalipso' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
		* Check the selection of basis documents for the specified partner
			And delay 2
			And I go to line in "List" table
				| 'Reference' |
				| '$$SalesInvoice024016$$'  |
			And I select current line in "List" table
			And I click the button named "FormCommandSelect" 
			And I activate field named "TransactionsAmount" in "Transactions" table
			And I input "100,00" text in the field named "TransactionsAmount" of "Transactions" table
			And I finish line editing in "Transactions" table
	* Check movements
		And I click the button named "FormPost"
		And I delete "$$CreditNote1000020$$" variable
		And I delete "$$CreditNoteDate1000020$$" variable
		And I save the window as "$$CreditNote1000020$$"
		And I save the value of "Date" field as "$$CreditNoteDate1000020$$"
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:	
		| '$$CreditNote1000020$$'                | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Document registrations records'       | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'  | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'               | 'Period'                    | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | 'Attributes'           |
		| ''                                     | ''                          | ''                          | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'                          | 'Legal name'             | 'Partner term'                     | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                     | 'Receipt'                   | '$$CreditNoteDate1000020$$' | '-100'                 | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'        | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                     | 'Receipt'                   | '$$CreditNoteDate1000020$$' | '-100'                 | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'        | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                     | 'Receipt'                   | '$$CreditNoteDate1000020$$' | '-100'                 | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'        | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                     | 'Receipt'                   | '$$CreditNoteDate1000020$$' | '-17,12'               | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'        | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                     | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Aging"'                    | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'               | 'Period'                    | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | ''                          | ''                          | 'Amount'               | 'Company'        | 'Partner'                | 'Agreement'                        | 'Invoice'                | 'Payment date'                     | 'Currency'                     | ''                             | ''                     |
		| ''                                     | 'Expense'                   | '$$CreditNoteDate1000020$$' | '100'                  | 'Main Company'   | 'Kalipso'                | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$' | '*'                                | 'TRY'                          | ''                             | ''                     |
		| ''                                     | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Expenses turnovers"'       | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Period'                    | 'Resources'                 | 'Dimensions'           | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | 'Attributes'                   | ''                     |
		| ''                                     | ''                          | 'Amount'                    | 'Company'              | 'Business unit'  | 'Expense type'           | 'Item key'                         | 'Currency'               | 'Additional analytic'              | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                     | '$$CreditNoteDate1000020$$' | '17,12'                     | 'Main Company'         | ''               | ''                       | ''                                 | 'USD'                    | ''                                 | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                     | '$$CreditNoteDate1000020$$' | '100'                       | 'Main Company'         | ''               | ''                       | ''                                 | 'TRY'                    | ''                                 | 'Local currency'               | 'No'                           | ''                     |
		| ''                                     | '$$CreditNoteDate1000020$$' | '100'                       | 'Main Company'         | ''               | ''                       | ''                                 | 'TRY'                    | ''                                 | 'TRY'                          | 'No'                           | ''                     |
		| ''                                     | '$$CreditNoteDate1000020$$' | '100'                       | 'Main Company'         | ''               | ''                       | ''                                 | 'TRY'                    | ''                                 | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                     | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'       | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'               | 'Period'                    | 'Resources'            | ''               | ''                       | ''                                 | 'Dimensions'             | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | ''                          | ''                          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'                   | 'Company'                | 'Partner'                          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                     | 'Receipt'                   | '$$CreditNoteDate1000020$$' | ''                     | ''               | ''                       | '-100'                             | 'Main Company'           | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice024016$$'       | 'TRY'                  |
		| ''                                     | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"' | ''                          | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'               | 'Period'                    | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | ''                          | ''                          | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'                         | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Expense'                   | '$$CreditNoteDate1000020$$' | '100'                  | 'Main Company'   | 'Company Kalipso'        | 'TRY'                              | ''                       | ''                                 | ''                             | ''                             | ''                     |
	And I close all client application windows
			

Scenario: _1000030 create Debit note and check Aging register moovements
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the basis document for debt write-offs
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'       |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Kalipso' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
		* Check the selection of basis documents for the specified partner
			And delay 2
			And I go to line in "List" table
				| 'Reference' |
				| '$$SalesInvoice024016$$'  |
			And I select current line in "List" table
			And I click the button named "FormCommandSelect" 
			And I activate field named "TransactionsAmount" in "Transactions" table
			And I input "50,00" text in the field named "TransactionsAmount" of "Transactions" table
			And I finish line editing in "Transactions" table
	* Check movements
		And I click the button named "FormPost"
		And I delete "$$DebitNote1000030$$" variable
		And I delete "$$DebitNoteDate1000030$$" variable
		And I save the window as "$$DebitNote1000030$$"
		And I save the value of "Date" field as "$$DebitNoteDate1000030$$"
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:	
		| '$$DebitNote1000030$$'                 | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Document registrations records'       | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'  | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'              | 'Period'                    | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | 'Attributes'           |
		| ''                                     | ''                         | ''                          | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'                          | 'Legal name'             | 'Partner term'                     | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                     | 'Receipt'                  | '$$DebitNoteDate1000030$$'  | '8,56'                 | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'        | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$DebitNoteDate1000030$$'  | '50'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'        | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$DebitNoteDate1000030$$'  | '50'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'        | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                     | 'Receipt'                  | '$$DebitNoteDate1000030$$'  | '50'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'        | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                     | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'       | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'              | 'Period'                    | 'Resources'            | ''               | ''                       | ''                                 | 'Dimensions'             | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | ''                         | ''                          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'                   | 'Company'                | 'Partner'                          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                     | 'Receipt'                  | '$$DebitNoteDate1000030$$'  | ''                     | ''               | ''                       | '50'                               | 'Main Company'           | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice024016$$'       | 'TRY'                  |
		| ''                                     | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"' | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'              | 'Period'                    | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | ''                         | ''                          | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'                         | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Receipt'                  | '$$DebitNoteDate1000030$$'  | '50'                   | 'Main Company'   | 'Company Kalipso'        | 'TRY'                              | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| 'Register  "Revenues turnovers"'       | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Period'                   | 'Resources'                 | 'Dimensions'           | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | 'Attributes'                   | ''                     |
		| ''                                     | ''                         | 'Amount'                    | 'Company'              | 'Business unit'  | 'Revenue type'           | 'Item key'                         | 'Currency'               | 'Additional analytic'              | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                     | '$$DebitNoteDate1000030$$' | '8,56'                      | 'Main Company'         | ''               | ''                       | ''                                 | 'USD'                    | ''                                 | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                     | '$$DebitNoteDate1000030$$' | '50'                        | 'Main Company'         | ''               | ''                       | ''                                 | 'TRY'                    | ''                                 | 'Local currency'               | 'No'                           | ''                     |
		| ''                                     | '$$DebitNoteDate1000030$$' | '50'                        | 'Main Company'         | ''               | ''                       | ''                                 | 'TRY'                    | ''                                 | 'TRY'                          | 'No'                           | ''                     |
		| ''                                     | '$$DebitNoteDate1000030$$' | '50'                        | 'Main Company'         | ''               | ''                       | ''                                 | 'TRY'                    | ''                                 | 'en description is empty'      | 'No'                           | ''                     |
		| 'Register  "Aging"'                    | ''                         | ''                          | ''                     | ''               | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | 'Record type'              | 'Period'                    | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                       | ''                                 | ''                             | ''                             | ''                     |
		| ''                                     | ''                         | ''                          | 'Amount'               | 'Company'        | 'Partner'                | 'Agreement'                        | 'Invoice'                | 'Payment date'                     | 'Currency'                     | ''                             | ''                     |
		| ''                                     | 'Receipt'                  | '$$DebitNoteDate1000030$$'  | '50'                   | 'Main Company'   | 'Kalipso'                | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$' | '*'                                | 'TRY'                          | ''                             | ''                     |
	And I close all client application windows
				
Scenario: _1000050 check the offset of Sales invoice advance (type of settlement by documents)
	* Advance after invoice (Bank receipt without basis document)
		* Create Bank receipt
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
					| 'Kalipso'   |
				And I select current line in "List" table
				And I input "80,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankReceipt1000050$$" variable
			And I delete "$$BankReceipt1000050$$" variable
			And I delete "$$DateBankReceipt1000050$$" variable
			And I save the value of "Number" field as "$$NumberBankReceipt1000050$$"
			And I save the window as "$$BankReceipt1000050$$"
			And I save the value of the field named "Date" as "$$DateBankReceipt1000050$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberBankReceipt1000050$$'  |
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$BankReceipt1000050$$'               | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Document registrations records'       | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Partner AR transactions"'  | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | 'Attributes'           |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'                          | 'Legal name'                   | 'Partner term'                     | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '13,7'                 | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                   |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Aging"'                    | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Partner'                | 'Agreement'                        | 'Invoice'                      | 'Payment date'                     | 'Currency'                     | ''                             | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | 'Kalipso'                | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$'       | '*'                                | 'TRY'                          | ''                             | ''                     |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Accounts statement"'       | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | ''               | ''                       | ''                                 | 'Dimensions'                   | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'                   | 'Company'                      | 'Partner'                          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt1000050$$' | ''                     | ''               | '80'                     | ''                                 | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | ''                             | 'TRY'                  |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | ''                     | ''               | ''                       | '80'                               | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice024016$$'       | 'TRY'                  |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | ''                     | ''               | '80'                     | ''                                 | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice024016$$'       | 'TRY'                  |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Reconciliation statement"' | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'                         | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | 'Company Kalipso'        | 'TRY'                              | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Advance from customers"'   | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | 'Attributes'                   | ''                     |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Partner'                | 'Legal name'                       | 'Currency'                     | 'Receipt document'                 | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt1000050$$' | '13,7'                 | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'USD'                          | '$$BankReceipt1000050$$'           | 'Reporting currency'           | 'No'                           | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$BankReceipt1000050$$'           | 'Local currency'               | 'No'                           | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$BankReceipt1000050$$'           | 'en description is empty'      | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '13,7'                 | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'USD'                          | '$$BankReceipt1000050$$'           | 'Reporting currency'           | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$BankReceipt1000050$$'           | 'Local currency'               | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$BankReceipt1000050$$'           | 'en description is empty'      | 'No'                           | ''                     |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Account balance"'          | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | 'Attributes'                       | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Account'                | 'Currency'                         | 'Multi currency movement type' | 'Deferred calculation'             | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt1000050$$' | '13,7'                 | 'Main Company'   | 'Bank account, TRY'      | 'USD'                              | 'Reporting currency'           | 'No'                               | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | 'Bank account, TRY'      | 'TRY'                              | 'Local currency'               | 'No'                               | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt1000050$$' | '80'                   | 'Main Company'   | 'Bank account, TRY'      | 'TRY'                              | 'en description is empty'      | 'No'                               | ''                             | ''                             | ''                     |
			And I close all client application windows
		* Create Cash receipt
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
					| 'Cash desk №4' |
				And I select current line in "List" table
			* Filling in the tabular part
				And in the table "PaymentList" I click the button named "PaymentListAdd"
				And I click choice button of "Partner" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Kalipso'   |
				And I select current line in "List" table
				And I input "50,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashReceipt1000050$$" variable
			And I delete "$$CashReceipt1000050$$" variable
			And I delete "$$DateCashReceipt1000050$$" variable
			And I save the value of "Number" field as "$$NumberCashReceipt1000050$$"
			And I save the window as "$$CashReceipt1000050$$"
			And I save the value of the field named "Date" as "$$DateCashReceipt1000050$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberCashReceipt1000050$$'  |
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$CashReceipt1000050$$'              | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Document registrations records'       | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Partner AR transactions"'  | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | 'Attributes'           |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'                          | 'Legal name'                   | 'Partner term'                     | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '8,56'                 | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                   |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Aging"'                    | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Partner'                | 'Agreement'                        | 'Invoice'                      | 'Payment date'                     | 'Currency'                     | ''                             | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | 'Kalipso'                | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$'       | '*'                                | 'TRY'                          | ''                             | ''                     |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Accounts statement"'       | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | ''               | ''                       | ''                                 | 'Dimensions'                   | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'                   | 'Company'                      | 'Partner'                          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt1000050$$' | ''                     | ''               | '50'                     | ''                                 | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | ''                             | 'TRY'                  |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | ''                     | ''               | ''                       | '50'                               | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice024016$$'       | 'TRY'                  |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | ''                     | ''               | '50'                     | ''                                 | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice024016$$'       | 'TRY'                  |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Reconciliation statement"' | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'                         | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | 'Company Kalipso'        | 'TRY'                              | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Advance from customers"'   | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | 'Attributes'                   | ''                     |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Partner'                | 'Legal name'                       | 'Currency'                     | 'Receipt document'                 | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt1000050$$' | '8,56'                 | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'USD'                          | '$$CashReceipt1000050$$'          | 'Reporting currency'           | 'No'                           | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$CashReceipt1000050$$'          | 'Local currency'               | 'No'                           | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$CashReceipt1000050$$'          | 'en description is empty'      | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '8,56'                 | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'USD'                          | '$$CashReceipt1000050$$'          | 'Reporting currency'           | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$CashReceipt1000050$$'          | 'Local currency'               | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$CashReceipt1000050$$'          | 'en description is empty'      | 'No'                           | ''                     |
				| ''                                     | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Account balance"'          | ''            | ''                           | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                     | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | 'Attributes'                       | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                           | 'Amount'               | 'Company'        | 'Account'                | 'Currency'                         | 'Multi currency movement type' | 'Deferred calculation'             | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt1000050$$' | '8,56'                 | 'Main Company'   | 'Cash desk №4'           | 'USD'                              | 'Reporting currency'           | 'No'                               | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | 'Cash desk №4'           | 'TRY'                              | 'Local currency'               | 'No'                               | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt1000050$$' | '50'                   | 'Main Company'   | 'Cash desk №4'           | 'TRY'                              | 'en description is empty'      | 'No'                               | ''                             | ''                             | ''                     |
			And I close all client application windows	
	* Advance before invoice (Bank receipt without basis document)
		* Create Bank receipt (advance + closed the remainder of the invoice)
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
					| 'Kalipso'   |
				And I select current line in "List" table
				And I input "550,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankReceipt10000501$$" variable
			And I delete "$$BankReceipt10000501$$" variable
			And I delete "$$DateBankReceipt10000501$$" variable
			And I save the value of "Number" field as "$$NumberBankReceipt10000501$$"
			And I save the window as "$$BankReceipt10000501$$"
			And I save the value of the field named "Date" as "$$DateBankReceipt10000501$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberBankReceipt10000501$$'  |
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$BankReceipt10000501$$'              | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Document registrations records'       | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Partner AR transactions"'  | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | 'Attributes'           |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'                          | 'Legal name'                   | 'Partner term'                     | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '20,55'                | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '120'                  | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '120'                  | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '120'                  | 'Main Company'   | '$$SalesInvoice024016$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                   |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Aging"'                    | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Partner'                | 'Agreement'                        | 'Invoice'                      | 'Payment date'                     | 'Currency'                     | ''                             | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '120'                  | 'Main Company'   | 'Kalipso'                | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$'       | '*'                                | 'TRY'                          | ''                             | ''                     |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Accounts statement"'       | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | ''               | ''                       | ''                                 | 'Dimensions'                   | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR'                   | 'Company'                      | 'Partner'                          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt10000501$$' | ''                     | ''               | '550'                    | ''                                 | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | ''                             | 'TRY'                  |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | ''                     | ''               | ''                       | '120'                              | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice024016$$'       | 'TRY'                  |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | ''                     | ''               | '120'                    | ''                                 | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice024016$$'       | 'TRY'                  |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Reconciliation statement"' | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'                         | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '550'                  | 'Main Company'   | 'Company Kalipso'        | 'TRY'                              | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Advance from customers"'   | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | ''                                 | ''                             | 'Attributes'                   | ''                     |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Partner'                | 'Legal name'                       | 'Currency'                     | 'Receipt document'                 | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt10000501$$' | '94,18'                | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'USD'                          | '$$BankReceipt10000501$$'          | 'Reporting currency'           | 'No'                           | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt10000501$$' | '550'                  | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$BankReceipt10000501$$'          | 'Local currency'               | 'No'                           | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt10000501$$' | '550'                  | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$BankReceipt10000501$$'          | 'en description is empty'      | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '20,55'                | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'USD'                          | '$$BankReceipt10000501$$'          | 'Reporting currency'           | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '120'                  | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$BankReceipt10000501$$'          | 'Local currency'               | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateBankReceipt10000501$$' | '120'                  | 'Main Company'   | 'Kalipso'                | 'Company Kalipso'                  | 'TRY'                          | '$$BankReceipt10000501$$'          | 'en description is empty'      | 'No'                           | ''                     |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Account balance"'          | ''            | ''                            | ''                     | ''               | ''                       | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                       | ''                                 | ''                             | 'Attributes'                       | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Account'                | 'Currency'                         | 'Multi currency movement type' | 'Deferred calculation'             | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt10000501$$' | '94,18'                | 'Main Company'   | 'Bank account, TRY'      | 'USD'                              | 'Reporting currency'           | 'No'                               | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt10000501$$' | '550'                  | 'Main Company'   | 'Bank account, TRY'      | 'TRY'                              | 'Local currency'               | 'No'                               | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateBankReceipt10000501$$' | '550'                  | 'Main Company'   | 'Bank account, TRY'      | 'TRY'                              | 'en description is empty'      | 'No'                               | ''                             | ''                             | ''                     |
			And I close all client application windows
	* Create Sales invoice
			When create SalesInvoice024016 (Shipment confirmation does not used)
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number' |
					| '$$NumberSalesInvoice024016$$'|
			And I select current line in "List" table
			And I click the button named "FormPost"
			And I delete "$$SalesInvoice0240164$$" variable
			And I delete "$$DateSalesInvoice0240164$$" variable
			And I delete "$$NumberSalesInvoice0240164$$" variable
			And I save the window as "$$SalesInvoice0240164$$"
			And I save the value of the field named "Date" as "$$DateSalesInvoice0240164$$"
			And I save the value of the field named "Number" as "$$NumberSalesInvoice0240164$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesInvoice0240164$$'  |
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice0240164$$'                    | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Document registrations records'             | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Partner AR transactions"'        | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | 'Attributes'                   | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Amount'               | 'Company'        | 'Basis document'          | 'Partner'                          | 'Legal name'              | 'Partner term'                     | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240164$$' | '94,18'                | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240164$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240164$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240164$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '73,63'                | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '430'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '430'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '430'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Inventory balance"'              | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Quantity'             | 'Company'        | 'Item key'                | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '1'                    | 'Main Company'   | 'L/Green'                 | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Aging"'                          | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Amount'               | 'Company'        | 'Partner'                 | 'Agreement'                        | 'Invoice'                 | 'Payment date'                     | 'Currency'                     | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240164$$' | '550'                  | 'Main Company'   | 'Kalipso'                 | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240164$$' | '*'                                | 'TRY'                          | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '430'                  | 'Main Company'   | 'Kalipso'                 | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240164$$' | '*'                                | 'TRY'                          | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Taxes turnovers"'                | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Period'                      | 'Resources'                   | ''                     | ''               | 'Dimensions'              | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
				| ''                                           | ''                            | 'Amount'                      | 'Manual amount'        | 'Net amount'     | 'Document'                | 'Tax'                              | 'Analytics'               | 'Tax rate'                         | 'Include to total amount'      | 'Row key'                      | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '14,37'                       | '14,37'                | '79,81'          | '$$SalesInvoice0240164$$' | 'VAT'                              | ''                        | '18%'                              | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '83,9'                        | '83,9'                 | '466,1'          | '$$SalesInvoice0240164$$' | 'VAT'                              | ''                        | '18%'                              | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '83,9'                        | '83,9'                 | '466,1'          | '$$SalesInvoice0240164$$' | 'VAT'                              | ''                        | '18%'                              | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '83,9'                        | '83,9'                 | '466,1'          | '$$SalesInvoice0240164$$' | 'VAT'                              | ''                        | '18%'                              | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Accounts statement"'             | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | ''               | ''                        | ''                                 | 'Dimensions'              | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'  | 'Transaction AR'                   | 'Company'                 | 'Partner'                          | 'Legal name'                   | 'Basis document'               | 'Currency'                     | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240164$$' | ''                     | ''               | ''                        | '550'                              | 'Main Company'            | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice0240164$$'      | 'TRY'                          | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | ''                     | ''               | ''                        | '430'                              | 'Main Company'            | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice0240164$$'      | 'TRY'                          | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | ''                     | ''               | '430'                     | ''                                 | 'Main Company'            | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice0240164$$'      | 'TRY'                          | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Stock reservation"'              | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Quantity'             | 'Store'          | 'Item key'                | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '1'                    | 'Store 01'       | 'L/Green'                 | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Sales turnovers"'                | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Period'                      | 'Resources'                   | ''                     | ''               | ''                        | 'Dimensions'                       | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
				| ''                                           | ''                            | 'Quantity'                    | 'Amount'               | 'Net amount'     | 'Offers amount'           | 'Company'                          | 'Sales invoice'           | 'Currency'                         | 'Item key'                     | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number'            | 'Deferred calculation' |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '1'                           | '94,18'                | '79,81'          | ''                        | 'Main Company'                     | '$$SalesInvoice0240164$$' | 'USD'                              | 'L/Green'                      | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '1'                           | '550'                  | '466,1'          | ''                        | 'Main Company'                     | '$$SalesInvoice0240164$$' | 'TRY'                              | 'L/Green'                      | '*'                            | 'Local currency'               | ''                             | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '1'                           | '550'                  | '466,1'          | ''                        | 'Main Company'                     | '$$SalesInvoice0240164$$' | 'TRY'                              | 'L/Green'                      | '*'                            | 'TRY'                          | ''                             | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '1'                           | '550'                  | '466,1'          | ''                        | 'Main Company'                     | '$$SalesInvoice0240164$$' | 'TRY'                              | 'L/Green'                      | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Reconciliation statement"'       | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Amount'               | 'Company'        | 'Legal name'              | 'Currency'                         | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240164$$' | '550'                  | 'Main Company'   | 'Company Kalipso'         | 'TRY'                              | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Revenues turnovers"'             | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Period'                      | 'Resources'                   | 'Dimensions'           | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | 'Amount'                      | 'Company'              | 'Business unit'  | 'Revenue type'            | 'Item key'                         | 'Currency'                | 'Additional analytic'              | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '79,81'                       | 'Main Company'         | ''               | ''                        | 'L/Green'                          | 'USD'                     | ''                                 | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '466,1'                       | 'Main Company'         | ''               | ''                        | 'L/Green'                          | 'TRY'                     | ''                                 | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '466,1'                       | 'Main Company'         | ''               | ''                        | 'L/Green'                          | 'TRY'                     | ''                                 | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | '$$DateSalesInvoice0240164$$' | '466,1'                       | 'Main Company'         | ''               | ''                        | 'L/Green'                          | 'TRY'                     | ''                                 | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Advance from customers"'         | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Amount'               | 'Company'        | 'Partner'                 | 'Legal name'                       | 'Currency'                | 'Receipt document'                 | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '73,63'                | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'USD'                     | '$$BankReceipt10000501$$'          | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '430'                  | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'TRY'                     | '$$BankReceipt10000501$$'          | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '430'                  | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'TRY'                     | '$$BankReceipt10000501$$'          | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Stock balance"'                  | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Quantity'             | 'Store'          | 'Item key'                | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '1'                    | 'Store 01'       | 'L/Green'                 | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Shipment confirmation schedule"' | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Quantity'             | 'Company'        | 'Order'                   | 'Store'                            | 'Item key'                | 'Row key'                          | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240164$$' | '1'                    | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Store 01'                         | 'L/Green'                 | '*'                                | '*'                            | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240164$$' | '1'                    | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Store 01'                         | 'L/Green'                 | '*'                                | '*'                            | ''                             | ''                             | ''                             | ''                     |
	* Create Cash receipt (advance + closed the remainder of the invoice)
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
					| 'Cash desk №4' |
				And I select current line in "List" table
			* Filling in the tabular part
				And in the table "PaymentList" I click the button named "PaymentListAdd"
				And I click choice button of "Partner" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Kalipso'   |
				And I select current line in "List" table
				And I input "550,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashReceipt10000505$$" variable
			And I delete "$$CashReceipt10000505$$" variable
			And I delete "$$DateCashReceipt10000505$$" variable
			And I save the value of "Number" field as "$$NumberCashReceipt10000505$$"
			And I save the window as "$$CashReceipt10000505$$"
			And I save the value of the field named "Date" as "$$DateCashReceipt10000505$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberCashReceipt10000505$$'  |
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$CashReceipt10000505$$'              | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Document registrations records'       | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Partner AR transactions"'  | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | 'Attributes'           |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Basis document'          | 'Partner'                          | 'Legal name'                   | 'Partner term'                     | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '20,55'                | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '120'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '120'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                   |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '120'                  | 'Main Company'   | '$$SalesInvoice0240164$$' | 'Kalipso'                          | 'Company Kalipso'              | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                   |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Aging"'                    | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Partner'                 | 'Agreement'                        | 'Invoice'                      | 'Payment date'                     | 'Currency'                     | ''                             | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '120'                  | 'Main Company'   | 'Kalipso'                 | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240164$$'      | '*'                                | 'TRY'                          | ''                             | ''                     |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Accounts statement"'       | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | ''               | ''                        | ''                                 | 'Dimensions'                   | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'  | 'Transaction AR'                   | 'Company'                      | 'Partner'                          | 'Legal name'                   | 'Basis document'               | 'Currency'             |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt10000505$$' | ''                     | ''               | '550'                     | ''                                 | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | ''                             | 'TRY'                  |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | ''                     | ''               | ''                        | '120'                              | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice0240164$$'      | 'TRY'                  |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | ''                     | ''               | '120'                     | ''                                 | 'Main Company'                 | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice0240164$$'      | 'TRY'                  |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Reconciliation statement"' | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Legal name'              | 'Currency'                         | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '550'                  | 'Main Company'   | 'Company Kalipso'         | 'TRY'                              | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Advance from customers"'   | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                             | ''                                 | ''                             | 'Attributes'                   | ''                     |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Partner'                 | 'Legal name'                       | 'Currency'                     | 'Receipt document'                 | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt10000505$$' | '94,18'                | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'USD'                          | '$$CashReceipt10000505$$'          | 'Reporting currency'           | 'No'                           | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt10000505$$' | '550'                  | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'TRY'                          | '$$CashReceipt10000505$$'          | 'Local currency'               | 'No'                           | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt10000505$$' | '550'                  | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'TRY'                          | '$$CashReceipt10000505$$'          | 'en description is empty'      | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '20,55'                | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'USD'                          | '$$CashReceipt10000505$$'          | 'Reporting currency'           | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '120'                  | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'TRY'                          | '$$CashReceipt10000505$$'          | 'Local currency'               | 'No'                           | ''                     |
				| ''                                     | 'Expense'     | '$$DateCashReceipt10000505$$' | '120'                  | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'TRY'                          | '$$CashReceipt10000505$$'          | 'en description is empty'      | 'No'                           | ''                     |
				| ''                                     | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| 'Register  "Account balance"'          | ''            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                             | ''                                 | ''                             | ''                             | ''                     |
				| ''                                     | 'Record type' | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                             | 'Attributes'                       | ''                             | ''                             | ''                     |
				| ''                                     | ''            | ''                            | 'Amount'               | 'Company'        | 'Account'                 | 'Currency'                         | 'Multi currency movement type' | 'Deferred calculation'             | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt10000505$$' | '94,18'                | 'Main Company'   | 'Cash desk №4'            | 'USD'                              | 'Reporting currency'           | 'No'                               | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt10000505$$' | '550'                  | 'Main Company'   | 'Cash desk №4'            | 'TRY'                              | 'Local currency'               | 'No'                               | ''                             | ''                             | ''                     |
				| ''                                     | 'Receipt'     | '$$DateCashReceipt10000505$$' | '550'                  | 'Main Company'   | 'Cash desk №4'            | 'TRY'                              | 'en description is empty'      | 'No'                               | ''                             | ''                             | ''                     |
			And I close all client application windows
	* Create Sales invoice
			When create SalesInvoice024016 (Shipment confirmation does not used)
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number' |
					| '$$NumberSalesInvoice024016$$'|
			And I select current line in "List" table
			And I click the button named "FormPost"
			And I delete "$$SalesInvoice0240165$$" variable
			And I delete "$$DateSalesInvoice0240165$$" variable
			And I delete "$$NumberSalesInvoice0240165$$" variable
			And I save the window as "$$SalesInvoice0240165$$"
			And I save the value of the field named "Date" as "$$DateSalesInvoice0240165$$"
			And I save the value of the field named "Number" as "$$NumberSalesInvoice0240165$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesInvoice0240165$$'  |
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice0240165$$'                    | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Document registrations records'             | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Partner AR transactions"'        | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | 'Attributes'                   | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Amount'               | 'Company'        | 'Basis document'          | 'Partner'                          | 'Legal name'              | 'Partner term'                     | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240165$$' | '94,18'                | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240165$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240165$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240165$$' | '550'                  | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '65,07'                | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '380'                  | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '380'                  | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '380'                  | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Kalipso'                          | 'Company Kalipso'         | 'Basic Partner terms, without VAT' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Inventory balance"'              | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Quantity'             | 'Company'        | 'Item key'                | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '1'                    | 'Main Company'   | 'L/Green'                 | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Aging"'                          | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Amount'               | 'Company'        | 'Partner'                 | 'Agreement'                        | 'Invoice'                 | 'Payment date'                     | 'Currency'                     | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240165$$' | '550'                  | 'Main Company'   | 'Kalipso'                 | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240165$$' | '*'                                | 'TRY'                          | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '380'                  | 'Main Company'   | 'Kalipso'                 | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240165$$' | '*'                                | 'TRY'                          | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Taxes turnovers"'                | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Period'                      | 'Resources'                   | ''                     | ''               | 'Dimensions'              | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
				| ''                                           | ''                            | 'Amount'                      | 'Manual amount'        | 'Net amount'     | 'Document'                | 'Tax'                              | 'Analytics'               | 'Tax rate'                         | 'Include to total amount'      | 'Row key'                      | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '14,37'                       | '14,37'                | '79,81'          | '$$SalesInvoice0240165$$' | 'VAT'                              | ''                        | '18%'                              | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '83,9'                        | '83,9'                 | '466,1'          | '$$SalesInvoice0240165$$' | 'VAT'                              | ''                        | '18%'                              | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '83,9'                        | '83,9'                 | '466,1'          | '$$SalesInvoice0240165$$' | 'VAT'                              | ''                        | '18%'                              | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '83,9'                        | '83,9'                 | '466,1'          | '$$SalesInvoice0240165$$' | 'VAT'                              | ''                        | '18%'                              | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Accounts statement"'             | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | ''               | ''                        | ''                                 | 'Dimensions'              | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'  | 'Transaction AR'                   | 'Company'                 | 'Partner'                          | 'Legal name'                   | 'Basis document'               | 'Currency'                     | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240165$$' | ''                     | ''               | ''                        | '550'                              | 'Main Company'            | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice0240165$$'      | 'TRY'                          | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | ''                     | ''               | ''                        | '380'                              | 'Main Company'            | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice0240165$$'      | 'TRY'                          | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | ''                     | ''               | '380'                     | ''                                 | 'Main Company'            | 'Kalipso'                          | 'Company Kalipso'              | '$$SalesInvoice0240165$$'      | 'TRY'                          | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Stock reservation"'              | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Quantity'             | 'Store'          | 'Item key'                | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '1'                    | 'Store 01'       | 'L/Green'                 | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Sales turnovers"'                | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Period'                      | 'Resources'                   | ''                     | ''               | ''                        | 'Dimensions'                       | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
				| ''                                           | ''                            | 'Quantity'                    | 'Amount'               | 'Net amount'     | 'Offers amount'           | 'Company'                          | 'Sales invoice'           | 'Currency'                         | 'Item key'                     | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number'            | 'Deferred calculation' |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '1'                           | '94,18'                | '79,81'          | ''                        | 'Main Company'                     | '$$SalesInvoice0240165$$' | 'USD'                              | 'L/Green'                      | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '1'                           | '550'                  | '466,1'          | ''                        | 'Main Company'                     | '$$SalesInvoice0240165$$' | 'TRY'                              | 'L/Green'                      | '*'                            | 'Local currency'               | ''                             | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '1'                           | '550'                  | '466,1'          | ''                        | 'Main Company'                     | '$$SalesInvoice0240165$$' | 'TRY'                              | 'L/Green'                      | '*'                            | 'TRY'                          | ''                             | 'No'                   |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '1'                           | '550'                  | '466,1'          | ''                        | 'Main Company'                     | '$$SalesInvoice0240165$$' | 'TRY'                              | 'L/Green'                      | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Reconciliation statement"'       | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Amount'               | 'Company'        | 'Legal name'              | 'Currency'                         | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240165$$' | '550'                  | 'Main Company'   | 'Company Kalipso'         | 'TRY'                              | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Revenues turnovers"'             | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Period'                      | 'Resources'                   | 'Dimensions'           | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | 'Amount'                      | 'Company'              | 'Business unit'  | 'Revenue type'            | 'Item key'                         | 'Currency'                | 'Additional analytic'              | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '79,81'                       | 'Main Company'         | ''               | ''                        | 'L/Green'                          | 'USD'                     | ''                                 | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '466,1'                       | 'Main Company'         | ''               | ''                        | 'L/Green'                          | 'TRY'                     | ''                                 | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '466,1'                       | 'Main Company'         | ''               | ''                        | 'L/Green'                          | 'TRY'                     | ''                                 | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | '$$DateSalesInvoice0240165$$' | '466,1'                       | 'Main Company'         | ''               | ''                        | 'L/Green'                          | 'TRY'                     | ''                                 | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Advance from customers"'         | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Amount'               | 'Company'        | 'Partner'                 | 'Legal name'                       | 'Currency'                | 'Receipt document'                 | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '65,07'                | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'USD'                     | '$$CashReceipt10000505$$'          | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '380'                  | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'TRY'                     | '$$CashReceipt10000505$$'          | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '380'                  | 'Main Company'   | 'Kalipso'                 | 'Company Kalipso'                  | 'TRY'                     | '$$CashReceipt10000505$$'          | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Stock balance"'                  | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Quantity'             | 'Store'          | 'Item key'                | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '1'                    | 'Store 01'       | 'L/Green'                 | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| 'Register  "Shipment confirmation schedule"' | ''                            | ''                            | ''                     | ''               | ''                        | ''                                 | ''                        | ''                                 | ''                             | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Record type'                 | 'Period'                      | 'Resources'            | 'Dimensions'     | ''                        | ''                                 | ''                        | ''                                 | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | ''                            | ''                            | 'Quantity'             | 'Company'        | 'Order'                   | 'Store'                            | 'Item key'                | 'Row key'                          | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Receipt'                     | '$$DateSalesInvoice0240165$$' | '1'                    | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Store 01'                         | 'L/Green'                 | '*'                                | '*'                            | ''                             | ''                             | ''                             | ''                     |
				| ''                                           | 'Expense'                     | '$$DateSalesInvoice0240165$$' | '1'                    | 'Main Company'   | '$$SalesInvoice0240165$$' | 'Store 01'                         | 'L/Green'                 | '*'                                | '*'                            | ''                             | ''                             | ''                             | ''                     |
			And I close all client application windows
			
				
		
			

		
				
	
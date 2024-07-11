#language: en
@tree
@Positive
@AgingAndCreditLimit

Feature: payment terms

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _1000000 preparation (payment terms)
	When set True value to the constant
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
		When Create catalog BusinessUnits objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
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
		When Create information register Taxes records (VAT)
	* Check previous movements for Kalipso
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table contains lines Then
			| "Partner"    |
			| "Kalipso"    |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		If "List" table contains lines Then
			| 'Number'    |
			| '1'         |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		If "List" table contains lines Then
			| 'Number'    |
			| '1'         |
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close all client application windows
	* Load customers advance closing document
		When Create document CustomersAdvancesClosing objects (without branch)
	* Post all customers advance closing
		Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"	
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"	
		And in the table "List" I click the button named "ListContextMenuPost"		
		And Delay 5
		And I close all client application windows
	* Load Opening entry, Bank receipt
		When Create document OpeningEntry objects (aging)
		When Create document BankReceipt objects (aging, Opening entry)
		And I close all client application windows
	* Load SO (aging)
		When Create document SalesOrder objects (aging)
		
Scenario: _10000001 check preparation
	When check preparation
	
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
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab				
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description'    |
			| '7 days'         |
		And I select current line in "List" table
		And I click "Save and close" button
	* Basic Partner terms, without VAT (14 days)
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description'    |
			| '14 days'        |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click "Save and close" button

Scenario: _1000003 create Sales invoice and check Aging tab
	* Create first test SI
		When create SalesInvoice024016 (Shipment confirmation does not used)
		* Check aging tab
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number'                            |
					| '$$NumberSalesInvoice024016$$'      |
			And I select current line in "List" table
			And I move to "Aging" tab
			And "PaymentTerms" table contains lines
				| 'Calculation type'        | 'Date'    | 'Due period, days'    | 'Proportion of payment'    | 'Amount'     |
				| 'Post-shipment credit'    | '*'       | '14'                  | '100,00'                   | '550,00'     |
		* Check payment date calculation
			And I move to "Other" tab
			And I input "03.11.2020" text in "Date" field
			And I move to "Aging" tab
			Then "Update item list info" window is opened
			And I click "OK" button
			And "PaymentTerms" table contains lines
				| 'Calculation type'        | 'Date'          | 'Due period, days'    | 'Proportion of payment'    | 'Amount'     |
				| 'Post-shipment credit'    | '17.11.2020'    | '14'                  | '100,00'                   | '550,00'     |
		* Manualy change payment date
			And I move to "Aging" tab
			And I select current line in "PaymentTerms" table
			And I input "04.11.2020" text in "Date" field of "PaymentTerms" table
			And I finish line editing in "PaymentTerms" table
			And "PaymentTerms" table contains lines
				| 'Calculation type'        | 'Date'          | 'Due period, days'    | 'Proportion of payment'    | 'Amount'     |
				| 'Post-shipment credit'    | '04.11.2020'    | '1'                   | '100,00'                   | '550,00'     |
		* Manualy change 'Due period, days'
			And I select current line in "PaymentTerms" table
			And I input "16" text in "Due period, days" field of "PaymentTerms" table
			And I finish line editing in "PaymentTerms" table
			And "PaymentTerms" table contains lines
				| 'Calculation type'        | 'Date'          | 'Due period, days'    | 'Proportion of payment'    | 'Amount'     |
				| 'Post-shipment credit'    | '19.11.2020'    | '16'                  | '100,00'                   | '550,00'     |
			And I click the button named "FormPost"
			And I delete "$$SalesInvoice0240162$$" variable
			And I delete "$$DateSalesInvoice0240162$$" variable
			And I save the window as "$$SalesInvoice0240162$$"
			And I save the value of the field named "Date" as "$$DateSalesInvoice0240162$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number'                            |
					| '$$NumberSalesInvoice024016$$'      |
			And I click "Registrations report" button
			And I select "R2021 Customer transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice0240162$$'                    | ''               | ''                               | ''             | ''                | ''          | ''                                | ''            | ''                        | ''                   | ''           | ''                                    | ''                           | ''         | ''         | ''                        | ''                               |
				| 'Document registrations records'             | ''               | ''                               | ''             | ''                | ''          | ''                                | ''            | ''                        | ''                   | ''           | ''                                    | ''                           | ''         | ''         | ''                        | ''                               |
				| 'Register  "R2021 Customer transactions"'    | ''               | ''                               | ''             | ''                | ''          | ''                                | ''            | ''                        | ''                   | ''           | ''                                    | ''                           | ''         | ''         | ''                        | ''                               |
				| ''                                           | 'Record type'    | 'Period'                         | 'Resources'    | 'Dimensions'      | ''          | ''                                | ''            | ''                        | ''                   | ''           | ''                                    | ''                           | ''         | ''         | 'Attributes'              | ''                               |
				| ''                                           | ''               | ''                               | 'Amount'       | 'Company'         | 'Branch'    | 'Multi currency movement type'    | 'Currency'    | 'Transaction currency'    | 'Legal name'         | 'Partner'    | 'Agreement'                           | 'Basis'                      | 'Order'    | 'Project'  | 'Deferred calculation'    | 'Customers advances closing'     |
				| ''                                           | 'Receipt'        | '$$DateSalesInvoice0240162$$'    | '94,16'        | 'Main Company'    | ''          | 'Reporting currency'              | 'USD'         | 'TRY'                     | 'Company Kalipso'    | 'Kalipso'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice0240162$$'    | ''         | ''         | 'No'                      | ''                               |
				| ''                                           | 'Receipt'        | '$$DateSalesInvoice0240162$$'    | '550'          | 'Main Company'    | ''          | 'Local currency'                  | 'TRY'         | 'TRY'                     | 'Company Kalipso'    | 'Kalipso'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice0240162$$'    | ''         | ''         | 'No'                      | ''                               |
				| ''                                           | 'Receipt'        | '$$DateSalesInvoice0240162$$'    | '550'          | 'Main Company'    | ''          | 'en description is empty'         | 'TRY'         | 'TRY'                     | 'Company Kalipso'    | 'Kalipso'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice0240162$$'    | ''         | ''         | 'No'                      | ''                               |
			And I select "R5011 Customers aging" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice0240162$$'              | ''               | ''                               | ''             | ''                | ''          | ''            | ''                                    | ''           | ''                           | ''                       | ''                  |
				| 'Document registrations records'       | ''               | ''                               | ''             | ''                | ''          | ''            | ''                                    | ''           | ''                           | ''                       | ''                  |
				| 'Register  "R5011 Customers aging"'    | ''               | ''                               | ''             | ''                | ''          | ''            | ''                                    | ''           | ''                           | ''                       | ''                  |
				| ''                                     | 'Record type'    | 'Period'                         | 'Resources'    | 'Dimensions'      | ''          | ''            | ''                                    | ''           | ''                           | ''                       | 'Attributes'        |
				| ''                                     | ''               | ''                               | 'Amount'       | 'Company'         | 'Branch'    | 'Currency'    | 'Agreement'                           | 'Partner'    | 'Invoice'                    | 'Payment date'           | 'Aging closing'     |
				| ''                                     | 'Receipt'        | '$$DateSalesInvoice0240162$$'    | '550'          | 'Main Company'    | ''          | 'TRY'         | 'Basic Partner terms, without VAT'    | 'Kalipso'    | '$$SalesInvoice0240162$$'    | '19.11.2020 00:00:00'    | ''                  |
			And I close all client application windows
	* Create second test SI
		When create SalesInvoice024016 (Shipment confirmation does not used)
	* Save payment terms date
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
				| 'Number'                           |
				| '$$NumberSalesInvoice024016$$'     |
		And I select current line in "List" table
		And I move to "Aging" tab
		And I select current line in "PaymentTerms" table
		And I delete "$$DatePaymentTermsSalesInvoice0240161$$" variable
		And I save the value of "PaymentTermsDate" field of "PaymentTerms" table as "$$DatePaymentTermsSalesInvoice0240161$$"
		And I click the button named "FormPostAndClose"
	* Check Aging movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.R5011B_CustomersAging"
		And "List" table contains lines
		| 'Period'                       | 'Recorder'                 | 'Currency'  | 'Company'       | 'Branch'  | 'Partner'  | 'Amount'  | 'Agreement'                         | 'Invoice'                  | 'Payment date'                              |
		| '$$DateSalesInvoice024016$$'   | '$$SalesInvoice024016$$'   | 'TRY'       | 'Main Company'  | ''        | 'Kalipso'  | '550,00'  | 'Basic Partner terms, without VAT'  | '$$SalesInvoice024016$$'   | '$$DatePaymentTermsSalesInvoice0240161$$'   |
		| '$$DateSalesInvoice0240162$$'  | '$$SalesInvoice0240162$$'  | 'TRY'       | 'Main Company'  | ''        | 'Kalipso'  | '550,00'  | 'Basic Partner terms, without VAT'  | '$$SalesInvoice0240162$$'  | '19.11.2020'                                |
		And I close all client application windows
		
Scenario: _1000009 create Cash receipt and check Aging register movements
	* Create Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash desk №2'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code'     |
				| 'TRY'      |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Kalipso'         |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                          |
				| 'Basic Partner terms, without VAT'     |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'    | 'Company'         | 'Legal name'         | 'Partner'    | 'Document'                    |
				| '550,00'    | 'Main Company'    | 'Company Kalipso'    | 'Kalipso'    | '$$SalesInvoice0240162$$'     |
			And I click "Select" button
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "550,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
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
			| 'Number'                          |
			| '$$NumberCashReceipt1000009$$'    |
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And I select "R5011 Customers aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$CashReceipt1000009$$'            |
			| 'Document registrations records'    |
		And I close all client application windows
	* Post customers advance closing document
		Given I open hyperlink 'e1cib/list/Document.CustomersAdvancesClosing'
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
		And in the table "List" I click the button named "ListContextMenuPost"	
	* Check movements
		Given I open hyperlink 'e1cib/list/AccumulationRegister.R5011B_CustomersAging'
		And "List" table contains lines
			| 'Period'                        | 'Recorder'                  | 'Currency'   | 'Company'        | 'Branch'   | 'Partner'   | 'Amount'   | 'Agreement'                          | 'Invoice'                   | 'Payment date'                              | 'Aging closing'                   |
			| '$$DateSalesInvoice0240162$$'   | '$$SalesInvoice0240162$$'   | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '550,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice0240162$$'   | '19.11.2020'                                | ''                                |
			| '$$DateSalesInvoice024016$$'    | '$$SalesInvoice024016$$'    | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '550,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice024016$$'    | '$$DatePaymentTermsSalesInvoice0240161$$'   | ''                                |
			| '$$DateCashReceipt1000009$$'    | '$$CashReceipt1000009$$'    | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '550,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice0240162$$'   | '19.11.2020'                                | 'Customers advance closing 4*'    |
		Then the number of "List" table lines is "равно" "3"
		And I close all client application windows
		



Scenario: _1000015 create Bank receipt and check Aging register movements
		* Create Bank receipt
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| Description       |
					| Main Company      |
				And I select current line in "List" table
			* Filling in the details of the document
				And I click Select button of "Account" field
				And I go to line in "List" table
					| 'Description'            |
					| 'Bank account, TRY'      |
				And I select current line in "List" table
			* Filling in the tabular part
				And in the table "PaymentList" I click the button named "PaymentListAdd"
				And I click choice button of "Partner" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Kalipso'          |
				And I select current line in "List" table
				And I activate "Partner term" field in "PaymentList" table
				And I click choice button of "Partner term" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'                           |
					| 'Basic Partner terms, without VAT'      |
				And I select current line in "List" table
			* Filling in basis documents in a tabular part
				And I finish line editing in "PaymentList" table
				And I activate "Basis document" field in "PaymentList" table
				And I select current line in "PaymentList" table
				And I go to line in "List" table
					| 'Amount'     | 'Company'          | 'Legal name'          | 'Partner'     | 'Document'                    |
					| '550,00'     | 'Main Company'     | 'Company Kalipso'     | 'Kalipso'     | '$$SalesInvoice024016$$'      |
				And I click "Select" button
				And I activate field named "PaymentListTotalAmount" in "PaymentList" table
				And I input "200,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
				And in the table "PaymentList" I click the button named "PaymentListAdd"
				And I click choice button of "Partner" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Kalipso'          |
				And I select current line in "List" table
				And I click choice button of "Partner term" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Basic Partner terms, without VAT'          |
				And I select current line in "List" table
				And I input "250,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
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
				| 'Number'                           |
				| '$$NumberBankReceipt1000015$$'     |
			And I click "Registrations report" button
			And I select "R2021 Customer transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And I select "R5011 Customers aging" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| '$$BankReceipt1000015$$'             |
				| 'Document registrations records'     |
			And I close all client application windows
		* Post customers advance closing document
			Given I open hyperlink 'e1cib/list/Document.CustomersAdvancesClosing'
			And I go to line in "List" table
				| 'Number'     |
				| '3'          |
			And in the table "List" I click the button named "ListContextMenuPost"
			And I go to line in "List" table
				| 'Number'     |
				| '4'          |
			And in the table "List" I click the button named "ListContextMenuPost"	
		* Check movements
			Given I open hyperlink 'e1cib/list/AccumulationRegister.R5011B_CustomersAging'
			And "List" table contains lines
				| 'Period'                         | 'Recorder'                   | 'Currency'    | 'Company'         | 'Branch'    | 'Partner'    | 'Amount'    | 'Agreement'                           | 'Invoice'                    | 'Payment date'                               | 'Aging closing'                    |
				| '$$DateSalesInvoice0240162$$'    | '$$SalesInvoice0240162$$'    | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '550,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice0240162$$'    | '19.11.2020'                                 | ''                                 |
				| '$$DateSalesInvoice024016$$'     | '$$SalesInvoice024016$$'     | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '550,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice024016$$'     | '$$DatePaymentTermsSalesInvoice0240161$$'    | ''                                 |
				| '$$DateCashReceipt1000009$$'     | '$$CashReceipt1000009$$'     | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '550,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice0240162$$'    | '19.11.2020'                                 | 'Customers advance closing 4*'     |
				| '$$DateBankReceipt1000015$$'     | '$$BankReceipt1000015$$'     | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '200,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice024016$$'     | '$$DatePaymentTermsSalesInvoice0240161$$'    | 'Customers advance closing 4*'     |
				| '$$DateBankReceipt1000015$$'     | '$$BankReceipt1000015$$'     | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '250,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice024016$$'     | '$$DatePaymentTermsSalesInvoice0240161$$'    | 'Customers advance closing 4*'     |
			Then the number of "List" table lines is "равно" "5"
			And I close all client application windows


Scenario: _1000020 create Credit note and check Aging register movements
	* Create document
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in the basis document for debt write-offs
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Company Kalipso'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "150,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
		And I click the button named "FormPost"
		And I delete "$$CreditNote1000020$$" variable
		And I delete "$$CreditNoteDate1000020$$" variable
		And I save the window as "$$CreditNote1000020$$"
		And I save the value of the field named "Date" as  "$$CreditNoteDate1000020$$"
		And I click "Registrations report" button
		* Check movements
			And I select "R5011 Customers aging" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| '$$CreditNote1000020$$'              |
				| 'Document registrations records'     |
			And I close all client application windows
		* Post customers advance closing document
			Given I open hyperlink 'e1cib/list/Document.CustomersAdvancesClosing'
			And I go to line in "List" table
				| 'Number'     |
				| '3'          |
			And in the table "List" I click the button named "ListContextMenuPost"
			And I go to line in "List" table
				| 'Number'     |
				| '4'          |
			And in the table "List" I click the button named "ListContextMenuPost"	
		* Check movements
			Given I open hyperlink 'e1cib/list/AccumulationRegister.R5011B_CustomersAging'
			And "List" table contains lines
				| 'Period'                         | 'Recorder'                   | 'Currency'    | 'Company'         | 'Branch'    | 'Partner'    | 'Amount'    | 'Agreement'                           | 'Invoice'                    | 'Payment date'                               | 'Aging closing'                    |
				| '$$DateSalesInvoice0240162$$'    | '$$SalesInvoice0240162$$'    | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '550,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice0240162$$'    | '19.11.2020'                                 | ''                                 |
				| '$$DateSalesInvoice024016$$'     | '$$SalesInvoice024016$$'     | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '550,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice024016$$'     | '$$DatePaymentTermsSalesInvoice0240161$$'    | ''                                 |
				| '$$DateCashReceipt1000009$$'     | '$$CashReceipt1000009$$'     | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '550,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice0240162$$'    | '19.11.2020'                                 | 'Customers advance closing 4*'     |
				| '$$DateBankReceipt1000015$$'     | '$$BankReceipt1000015$$'     | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '250,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice024016$$'     | '$$DatePaymentTermsSalesInvoice0240161$$'    | 'Customers advance closing 4*'     |
				| '$$DateBankReceipt1000015$$'     | '$$BankReceipt1000015$$'     | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '200,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice024016$$'     | '$$DatePaymentTermsSalesInvoice0240161$$'    | 'Customers advance closing 4*'     |
				| '$$CreditNoteDate1000020$$'      | '$$CreditNote1000020$$'      | 'TRY'         | 'Main Company'    | ''          | 'Kalipso'    | '100,00'    | 'Basic Partner terms, without VAT'    | '$$SalesInvoice024016$$'     | '$$DatePaymentTermsSalesInvoice0240161$$'    | 'Customers advance closing 4*'     |
			Then the number of "List" table lines is "равно" "6"
	And I close all client application windows
			

Scenario: _1000030 create Debit note and check Aging register movements
	* Create document
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in the basis document for debt write-offs
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I click choice button of "Partner" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Company Kalipso'    |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
		And I activate field named "TransactionsAmount" in "Transactions" table
		And I input "50,00" text in the field named "TransactionsAmount" of "Transactions" table
		And I finish line editing in "Transactions" table
	* Check movements
		And I click the button named "FormPost"
		And I delete "$$DebitNote1000030$$" variable
		And I delete "$$DebitNoteDate1000030$$" variable
		And I save the window as "$$DebitNote1000030$$"
		And I save the value of the field named "Date" as  "$$DebitNoteDate1000030$$"
		And I click "Registrations report" button
		And I select "R5011 Customers aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$DebitNote1000030$$'                | ''              | ''                           | ''            | ''               | ''         | ''           | ''                                   | ''          | ''                       | ''               | ''                 |
			| 'Document registrations records'      | ''              | ''                           | ''            | ''               | ''         | ''           | ''                                   | ''          | ''                       | ''               | ''                 |
			| 'Register  "R5011 Customers aging"'   | ''              | ''                           | ''            | ''               | ''         | ''           | ''                                   | ''          | ''                       | ''               | ''                 |
			| ''                                    | 'Record type'   | 'Period'                     | 'Resources'   | 'Dimensions'     | ''         | ''           | ''                                   | ''          | ''                       | ''               | 'Attributes'       |
			| ''                                    | ''              | ''                           | 'Amount'      | 'Company'        | 'Branch'   | 'Currency'   | 'Agreement'                          | 'Partner'   | 'Invoice'                | 'Payment date'   | 'Aging closing'    |
			| ''                                    | 'Receipt'       | '$$DebitNoteDate1000030$$'   | '50'          | 'Main Company'   | ''         | 'TRY'        | 'Basic Partner terms, without VAT'   | 'Kalipso'   | '$$DebitNote1000030$$'   | '*'              | ''                 |
		And I close all client application windows
	* Post customers advance closing document
		Given I open hyperlink 'e1cib/list/Document.CustomersAdvancesClosing'
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
		And in the table "List" I click the button named "ListContextMenuPost"	
	* Check movements
		Given I open hyperlink 'e1cib/list/AccumulationRegister.R5011B_CustomersAging'
		And "List" table contains lines
			| 'Period'                        | 'Recorder'                  | 'Currency'   | 'Company'        | 'Branch'   | 'Partner'   | 'Amount'   | 'Agreement'                          | 'Invoice'                   | 'Payment date'                              | 'Aging closing'                   |
			| '$$DateSalesInvoice0240162$$'   | '$$SalesInvoice0240162$$'   | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '550,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice0240162$$'   | '19.11.2020'                                | ''                                |
			| '$$DateSalesInvoice024016$$'    | '$$SalesInvoice024016$$'    | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '550,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice024016$$'    | '$$DatePaymentTermsSalesInvoice0240161$$'   | ''                                |
			| '$$DateCashReceipt1000009$$'    | '$$CashReceipt1000009$$'    | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '550,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice0240162$$'   | '19.11.2020'                                | 'Customers advance closing 4*'    |
			| '$$DateBankReceipt1000015$$'    | '$$BankReceipt1000015$$'    | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '250,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice024016$$'    | '$$DatePaymentTermsSalesInvoice0240161$$'   | 'Customers advance closing 4*'    |
			| '$$DateBankReceipt1000015$$'    | '$$BankReceipt1000015$$'    | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '200,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice024016$$'    | '$$DatePaymentTermsSalesInvoice0240161$$'   | 'Customers advance closing 4*'    |
			| '$$CreditNoteDate1000020$$'     | '$$CreditNote1000020$$'     | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '100,00'   | 'Basic Partner terms, without VAT'   | '$$SalesInvoice024016$$'    | '$$DatePaymentTermsSalesInvoice0240161$$'   | 'Customers advance closing 4*'    |
			| '$$DebitNoteDate1000030$$'      | '$$DebitNote1000030$$'      | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '50,00'    | 'Basic Partner terms, without VAT'   | '$$DebitNote1000030$$'      | '*'                                         | ''                                |
			| '$$DebitNoteDate1000030$$'      | '$$DebitNote1000030$$'      | 'TRY'        | 'Main Company'   | ''         | 'Kalipso'   | '50,00'    | 'Basic Partner terms, without VAT'   | '$$DebitNote1000030$$'      | '*'                                         | 'Customers advance closing 4*'    |
		Then the number of "List" table lines is "равно" "8"
	And I close all client application windows
				
Scenario: _1000050 check the offset of Sales invoice advance (type of settlement by documents)
	* Advance after invoice (Bank receipt without basis document)
		* Create Bank receipt
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| Description       |
					| Main Company      |
				And I select current line in "List" table
			* Filling in the details of the document
				And I click Select button of "Account" field
				And I go to line in "List" table
					| 'Description'            |
					| 'Bank account, TRY'      |
				And I select current line in "List" table
			* Filling in the tabular part
				And in the table "PaymentList" I click the button named "PaymentListAdd"
				And I click choice button of "Partner" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Kalipso'          |
				And I select current line in "List" table
				And I input "80,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankReceipt1000050$$" variable
			And I delete "$$BankReceipt1000050$$" variable
			And I delete "$$DateBankReceipt1000050$$" variable
			And I save the value of "Number" field as "$$NumberBankReceipt1000050$$"
			And I save the window as "$$BankReceipt1000050$$"
			And I save the value of the field named "Date" as "$$DateBankReceipt1000050$$"
			And I click the button named "FormPostAndClose"
			And I close all client application windows
		* Create Cash receipt
			Given I open hyperlink "e1cib/list/Document.CashReceipt"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| 'Description'       |
					| 'Main Company'      |
				And I select current line in "List" table
			* Filling in the details of the document
				And I click Select button of "Cash account" field
				And I go to line in "List" table
					| 'Description'       |
					| 'Cash desk №4'      |
				And I select current line in "List" table
			* Filling in the tabular part
				And in the table "PaymentList" I click the button named "PaymentListAdd"
				And I click choice button of "Partner" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Kalipso'          |
				And I select current line in "List" table
				And I input "50,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashReceipt1000050$$" variable
			And I delete "$$CashReceipt1000050$$" variable
			And I delete "$$DateCashReceipt1000050$$" variable
			And I save the value of "Number" field as "$$NumberCashReceipt1000050$$"
			And I save the window as "$$CashReceipt1000050$$"
			And I save the value of the field named "Date" as "$$DateCashReceipt1000050$$"
			And I click the button named "FormPostAndClose"
	* Advance before invoice (Bank receipt without basis document)
		* Create Bank receipt (advance + closed the remainder of the invoice)
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| Description       |
					| Main Company      |
				And I select current line in "List" table
			* Filling in the details of the document
				And I click Select button of "Account" field
				And I go to line in "List" table
					| 'Description'            |
					| 'Bank account, TRY'      |
				And I select current line in "List" table
			* Filling in the tabular part
				And in the table "PaymentList" I click the button named "PaymentListAdd"
				And I click choice button of "Partner" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Kalipso'          |
				And I select current line in "List" table
				And I input "550,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankReceipt10000501$$" variable
			And I delete "$$BankReceipt10000501$$" variable
			And I delete "$$DateBankReceipt10000501$$" variable
			And I save the value of "Number" field as "$$NumberBankReceipt10000501$$"
			And I save the window as "$$BankReceipt10000501$$"
			And I save the value of the field named "Date" as "$$DateBankReceipt10000501$$"
			And I click the button named "FormPostAndClose"
	* Create Sales invoice
			When create SalesInvoice024016 (Shipment confirmation does not used)
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number'                            |
					| '$$NumberSalesInvoice024016$$'      |
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
				| 'Number'                            |
				| '$$NumberSalesInvoice0240164$$'     |
			And I click "Registrations report" button
			And I select "R5011 Customers aging" exact value from "Register" drop-down list
			And I click "Generate report" button			
			And "ResultTable" spreadsheet document contains lines:
				| 'Document registrations records'       | ''               | ''                               | ''             | ''                | ''          | ''            | ''                                    | ''           | ''                           | ''                | ''                  |
				| 'Register  "R5011 Customers aging"'    | ''               | ''                               | ''             | ''                | ''          | ''            | ''                                    | ''           | ''                           | ''                | ''                  |
				| ''                                     | 'Record type'    | 'Period'                         | 'Resources'    | 'Dimensions'      | ''          | ''            | ''                                    | ''           | ''                           | ''                | 'Attributes'        |
				| ''                                     | ''               | ''                               | 'Amount'       | 'Company'         | 'Branch'    | 'Currency'    | 'Agreement'                           | 'Partner'    | 'Invoice'                    | 'Payment date'    | 'Aging closing'     |
				| ''                                     | 'Receipt'        | '$$DateSalesInvoice0240164$$'    | '550'          | 'Main Company'    | ''          | 'TRY'         | 'Basic Partner terms, without VAT'    | 'Kalipso'    | '$$SalesInvoice0240164$$'    | '*'               | ''                  |
	* Create Cash receipt (advance + closed the remainder of the invoice)
			Given I open hyperlink "e1cib/list/Document.CashReceipt"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| Description       |
					| Main Company      |
				And I select current line in "List" table
			* Filling in the details of the document
				And I click Select button of "Cash account" field
				And I go to line in "List" table
					| 'Description'       |
					| 'Cash desk №4'      |
				And I select current line in "List" table
			* Filling in the tabular part
				And in the table "PaymentList" I click the button named "PaymentListAdd"
				And I click choice button of "Partner" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Kalipso'          |
				And I select current line in "List" table
				And I input "550,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashReceipt10000505$$" variable
			And I delete "$$CashReceipt10000505$$" variable
			And I delete "$$DateCashReceipt10000505$$" variable
			And I save the value of "Number" field as "$$NumberCashReceipt10000505$$"
			And I save the window as "$$CashReceipt10000505$$"
			And I save the value of the field named "Date" as "$$DateCashReceipt10000505$$"
			And I click the button named "FormPostAndClose"
			And I close all client application windows
	* Create Sales invoice
			When create SalesInvoice024016 (Shipment confirmation does not used)
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number'                            |
					| '$$NumberSalesInvoice024016$$'      |
			And I select current line in "List" table
			And I click the button named "FormPost"
			And I delete "$$SalesInvoice0240175$$" variable
			And I delete "$$DateSalesInvoice0240175$$" variable
			And I delete "$$NumberSalesInvoice0240175$$" variable
			And I save the window as "$$SalesInvoice0240175$$"
			And I save the value of the field named "Date" as "$$DateSalesInvoice0240175$$"
			And I save the value of the field named "Number" as "$$NumberSalesInvoice0240175$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
					| 'Number'                             |
					| '$$NumberSalesInvoice0240175$$'      |
			And I select current line in "List" table	
			And I click "Registrations report" button
			And I select "R5011 Customers aging" exact value from "Register" drop-down list
			And I click "Generate report" button		
			And "ResultTable" spreadsheet document contains lines:	
				| '$$SalesInvoice0240175$$'              | ''               | ''                               | ''             | ''                | ''          | ''            | ''                                    | ''           | ''                           | ''                | ''                  |
				| 'Document registrations records'       | ''               | ''                               | ''             | ''                | ''          | ''            | ''                                    | ''           | ''                           | ''                | ''                  |
				| 'Register  "R5011 Customers aging"'    | ''               | ''                               | ''             | ''                | ''          | ''            | ''                                    | ''           | ''                           | ''                | ''                  |
				| ''                                     | 'Record type'    | 'Period'                         | 'Resources'    | 'Dimensions'      | ''          | ''            | ''                                    | ''           | ''                           | ''                | 'Attributes'        |
				| ''                                     | ''               | ''                               | 'Amount'       | 'Company'         | 'Branch'    | 'Currency'    | 'Agreement'                           | 'Partner'    | 'Invoice'                    | 'Payment date'    | 'Aging closing'     |
				| ''                                     | 'Receipt'        | '$$DateSalesInvoice0240175$$'    | '550'          | 'Main Company'    | ''          | 'TRY'         | 'Basic Partner terms, without VAT'    | 'Kalipso'    | '$$SalesInvoice0240175$$'    | '*'               | ''                  |
		* Post customers advance closing document
			Given I open hyperlink 'e1cib/list/Document.CustomersAdvancesClosing'
			And I go to line in "List" table
				| 'Number'     |
				| '3'          |
			And in the table "List" I click the button named "ListContextMenuPost"
			And I go to line in "List" table
				| 'Number'     |
				| '4'          |
			And in the table "List" I click the button named "ListContextMenuPost"	
		* Check movements
			Given I open hyperlink 'e1cib/list/AccumulationRegister.R5011B_CustomersAging'
			And "List" table contains lines:
				| 'Recorder'                | 'Currency' | 'Company'      | 'Branch' | 'Partner' | 'Amount' | 'Agreement'                        | 'Invoice'                 | 'Payment date' | 'Aging closing'                |
				| '$$SalesInvoice0240164$$' | 'TRY'      | 'Main Company' | ''       | 'Kalipso' | '550,00' | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240164$$' | '*'            | ''                             |
				| '$$SalesInvoice0240164$$' | 'TRY'      | 'Main Company' | ''       | 'Kalipso' | '50,00'  | 'Basic Partner terms, without VAT' | '$$SalesInvoice0240164$$' | '*'            | 'Customers advance closing 4*' |
				| '$$SalesInvoice024016$$'  | 'TRY'      | 'Main Company' | ''       | 'Kalipso' | '550,00' | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$'  | '*'            | ''                             |
				| '$$SalesInvoice024016$$'  | 'TRY'      | 'Main Company' | ''       | 'Kalipso' | '50,00'  | 'Basic Partner terms, without VAT' | '$$SalesInvoice024016$$'  | '*'            | 'Customers advance closing 4*' |
			And I close all client application windows	

Scenario: _1000055 check Aging sum when delete row from SI
	* Create SI
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice" 
		And I click the button named "FormCreate" 
		* Filling in customer information
			And I click Select button of "Partner" field 
			And I go to line in "List" table 
					| 'Description'      |
					| 'Kalipso'          |
			And I select current line in "List" table 
			And I click Select button of "Partner term" field 
			And I go to line in "List" table 
					| 'Description'                           |
					| 'Basic Partner terms, without VAT'      |
			And I select current line in "List" table 
		* Select store
			And I click Select button of "Store" field 
			And I go to line in "List" table 
					| 'Description'      |
					| 'Store 01'         |
			And I select current line in "List" table 
			And I click Select button of "Legal name" field 
			And I activate "Description" field in "List" table 
			And I select current line in "List" table 
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd" 
			And I click choice button of "Item" attribute in "ItemList" table 
			And I go to line in "List" table 
					| 'Description'      |
					| 'Dress'            |
			And I select current line in "List" table 
			And I activate "Item key" field in "ItemList" table 
			And I click choice button of "Item key" attribute in "ItemList" table 
			And I go to line in "List" table 
					| 'Item key'      |
					| 'L/Green'       |
			And I select current line in "List" table 
			And I activate "Quantity" field in "ItemList" table 
			And I input "1,000" text in "Quantity" field of "ItemList" table 
			And I finish line editing in "ItemList" table 
			And I activate field named "ItemListItemKey" in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
			And I go to line in "ItemList" table 
					| '#'     | 'Item'       |
					| '2'     | 'Dress'      |
			And I activate "Price" field in "ItemList" table
			And I input "900,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And "PaymentTerms" table contains lines
				| 'Amount'      | 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'     |
				| '1 612,00'    | 'Post-shipment credit'    | '14'                  | '100,00'                    |
		* Delete first string and check Aging sum
			And I go to line in "ItemList" table 
				| '#'    | 'Item'      |
				| '1'    | 'Dress'     |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And "PaymentTerms" table contains lines
				| 'Amount'      | 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'     |
				| '1 062,00'    | 'Post-shipment credit'    | '14'                  | '100,00'                    |
		* Add string and check aging sum
			And I go to line in "ItemList" table 
				| '#'    | 'Item'      |
				| '1'    | 'Dress'     |
			And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
			And "PaymentTerms" table contains lines
				| 'Amount'      | 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'     |
				| '2 124,00'    | 'Post-shipment credit'    | '14'                  | '100,00'                    |
		* Post SI, delete string and check aging sum
			And I click "Post" button			
			And I go to line in "ItemList" table 
				| '#'    | 'Item'      |
				| '1'    | 'Dress'     |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And "PaymentTerms" table contains lines
				| 'Amount'      | 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'     |
				| '1 062,00'    | 'Post-shipment credit'    | '14'                  | '100,00'                    |
			And I close all client application windows
			

Scenario: _1000056 check aging  date in the SI (created based on SC)
		And I close all client application windows
	* Create SO
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesOrder" 
		And I click the button named "FormCreate" 
		* Filling in customer information
			And I click Select button of "Partner" field 
			And I go to line in "List" table 
					| 'Description'      |
					| 'Kalipso'          |
			And I select current line in "List" table 
			And I click Select button of "Partner term" field 
			And I go to line in "List" table 
					| 'Description'                           |
					| 'Basic Partner terms, without VAT'      |
			And I select current line in "List" table 
		* Select store
			And I click Select button of "Store" field 
			And I go to line in "List" table 
					| 'Description'      |
					| 'Store 01'         |
			And I select current line in "List" table 
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd" 
			And I click choice button of "Item" attribute in "ItemList" table 
			And I go to line in "List" table 
					| 'Description'      |
					| 'Dress'            |
			And I select current line in "List" table 
			And I activate "Item key" field in "ItemList" table 
			And I click choice button of "Item key" attribute in "ItemList" table 
			And I go to line in "List" table 
					| 'Item key'      |
					| 'L/Green'       |
			And I select current line in "List" table 
			And I activate "Quantity" field in "ItemList" table 
			And I input "1,000" text in "Quantity" field of "ItemList" table 
			And I finish line editing in "ItemList" table 
			And I activate field named "ItemListItemKey" in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
			And I go to line in "ItemList" table 
					| '#'     | 'Item'       |
					| '2'     | 'Dress'      |
			And I activate "Price" field in "ItemList" table
			And I input "900,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "01.10.2022 00:00:00" text in the field named "Date"
			And I move to the next attribute
			Then "Update item list info" window is opened
			And I change checkbox "Do you want to replace filled price types with price type Basic Price without VAT?"
			And I change checkbox "Do you want to update filled prices?"
			And I change checkbox "Do you want to update payment term?"
			And I click "OK" button	
			And I click "Post" button
		* Create SC
			And I click "Shipment confirmation" button
			And I expand current line in "BasisesTree" table
			And I click "Ok" button
			And I click "Post" button
		* Create SI
			And I click "Sales invoice" button
			Then "Add linked document rows" window is opened
			And I expand current line in "BasisesTree" table
			And I click "Ok" button
			And I move to "Aging" tab
			And "PaymentTerms" table became equal
				| '#'    | 'Date'                                                    | 'Amount'      | 'Calculation type'        | 'Due period, days'    | 'Proportion of payment'     |
				| '1'    | '{Format(CurrentDate() + 14 * 24 * 60 * 60, "DLF=D")}'    | '1 612,00'    | 'Post-shipment credit'    | '14'                  | '100,00'                    |
			And I close all client application windows
			
Scenario: _1000057 create BR based on SO (Prepaid)
	And I close all client application windows
	* Prepaid
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1115).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder" 
		And I go to line in "List" table
			| 'Number'    |
			| '1 115'     |
	* Create BR based on SO
		Then "Sales orders" window is opened
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And "PaymentList" table became equal
			| 'Partner' | '#' | 'Commission' | 'Payer'           | 'Partner term' | 'Legal name contract' | 'Basis document' | 'Order'                                       | 'Total amount' | 'Financial movement type' | 'Profit loss center' | 'Cash flow center' | 'Planning transaction basis' | 'Additional analytic' | 'Commission percent' | 'Expense type' |
			| 'Kalipso' | '1' | ''           | 'Company Kalipso' | ''             | ''                    | ''               | 'Sales order 1 115 dated 04.01.2024 11:43:06' | '864,41'       | ''                        | ''                   | ''                 | ''                           | ''                    | ''                   | ''             |
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
	* Try select SO in BR
		And I activate "Partner term" field in "PaymentList" table
		And I delete a line in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table		
		And I activate "Order" field in "PaymentList" table
		And I click choice button of "Order" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Document'                                    | 'Company'      | 'Partner' | 'Legal name'      | 'Partner term'                     | 'Currency' | 'Amount' |
			| 'Sales order 1 115 dated 04.01.2024 11:43:06' | 'Main Company' | 'Kalipso' | 'Company Kalipso' | 'Basic Partner terms, without VAT' | 'TRY'      | '864,41' |
		And I click "Select" button
		And "PaymentList" table became equal
			| 'Partner' | '#' | 'Commission' | 'Payer'           | 'Partner term' | 'Legal name contract' | 'Basis document' | 'Order'                                       | 'Total amount' | 'Financial movement type' | 'Profit loss center' | 'Cash flow center' | 'Planning transaction basis' | 'Additional analytic' | 'Commission percent' | 'Expense type' |
			| 'Kalipso' | '1' | ''           | 'Company Kalipso' | ''             | ''                    | ''               | 'Sales order 1 115 dated 04.01.2024 11:43:06' | '864,41'       | ''                        | ''                   | ''                 | ''                           | ''                    | ''                   | ''             |
	And I close all client application windows
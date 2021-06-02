#language: en
@tree
@Positive
@IgnoreOnCIMainBuild
@AgingAndCreditLimit

Feature: vendors aging



Background:
	Given I launch TestClient opening script or connect the existing one

	

Scenario: _1002000 preparation (vendors aging)
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
		When Create catalog PaymentSchedules objects
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
	* Load vendors advance closing document
		When Create document VendorsAdvancesClosing objects
		Given I open hyperlink 'e1cib/list/Document.VendorsAdvancesClosing'
		And I go to line in "List" table
			| 'Number' |
			| '4'  |
		And I select current line in "List" table
		And I input current date in the field named "BeginOfPeriod"
		And I input current date in the field named "EndOfPeriod"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number' |
			| '1'  |
		And I select current line in "List" table
		And I input "20.05.2021" text in "Begin of period" field
		And I input "20.05.2021" text in "End of period" field
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Load PO
		When Create document PurchaseOrder objects (with aging, prepaid, post-shipment credit)

Scenario: _1002002 filling in payment terms in the Partner term
	Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Vendor Ferron, TRY (7 days)
		And I go to line in "List" table
			| 'Description'              |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I move to "Credit limit & Aging" tab				
		And I click Select button of "Payment term" field
		And I go to line in "List" table
			| 'Description' |
			| '7 days'      |
		And I select current line in "List" table
		And I click "Save and close" button
	* Partner term Maxim (14 days)
		And I go to line in "List" table
			| 'Description'                      |
			| 'Partner term Maxim' |
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

Scenario: _1002003 check Aging tab in the Purchase invoice
	* Create first test PI
		When create purchase invoice without order (Vendor Ferron, TRY)
		* Check aging tab
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I go to line in "List" table
					| 'Number' |
					| '$$NumberPurchaseInvoiceAging$$'|
			And I select current line in "List" table
			And I move to "Aging" tab
			And "PaymentTerms" table contains lines
				| 'Calculation type'     | 'Date' | 'Due period, days' | 'Proportion of payment' | 'Amount'   |
				| 'Post-shipment credit' | '*'    | '7'                | '100,00'                | '4 000,00' |
		* Check payment date calculation
			And I move to "Other" tab
			And I input "03.11.2020" text in "Date" field
			And I move to "Aging" tab
			Then "Update item list info" window is opened
			And I remove checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I remove checkbox "Do you want to update filled prices?"
			And I remove checkbox "Do you want to update payment term?"			
			And I click "OK" button
			And "PaymentTerms" table contains lines
				| 'Calculation type'     | 'Date'       | 'Due period, days' | 'Proportion of payment' | 'Amount'   |
				| 'Post-shipment credit' | '10.11.2020' | '7'                | '100,00'                | '4 000,00' |
		* Manualy change payment date
			And I move to "Aging" tab
			And I select current line in "PaymentTerms" table
			And I input "04.11.2020" text in "Date" field of "PaymentTerms" table
			And I finish line editing in "PaymentTerms" table
			And "PaymentTerms" table contains lines
				| 'Calculation type'     | 'Date'         | 'Due period, days' | 'Proportion of payment' | 'Amount' |
				| 'Post-shipment credit' | '04.11.2020'   | '1'               | '100,00'                | '4 000,00' |
		* Manualy change 'Due period, days'
			And I select current line in "PaymentTerms" table
			And I input "16" text in "Due period, days" field of "PaymentTerms" table
			And I finish line editing in "PaymentTerms" table
			And "PaymentTerms" table contains lines
				| 'Calculation type'     | 'Date'         | 'Due period, days' | 'Proportion of payment' | 'Amount' |
				| 'Post-shipment credit' | '*'   | '16'               | '100,00'                | '4 000,00' |
			And I click the button named "FormPost"
			And I delete "$$PurchaseInvoiceAging1$$" variable
			And I delete "$$DatePurchaseInvoiceAging1$$" variable
			And I delete "$$NumberPurchaseInvoiceAging1$$" variable
			And I save the window as "$$PurchaseInvoiceAging1$$"
			And I save the value of the field named "Date" as "$$DatePurchaseInvoiceAging1$$"
			And I save the value of "Number" field as "$$NumberPurchaseInvoiceAging1$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I go to line in "List" table
					| 'Number' |
					| '$$NumberPurchaseInvoiceAging1$$'|
			And I click "Registrations report" button
			And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$PurchaseInvoiceAging1$$'              | ''            | ''                              | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                          | ''                     | ''                         |
				| 'Document registrations records'         | ''            | ''                              | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                          | ''                     | ''                         |
				| 'Register  "R1021 Vendors transactions"' | ''            | ''                              | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                   | ''                          | ''                     | ''                         |
				| ''                                       | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                   | ''                          | 'Attributes'           | ''                         |
				| ''                                       | ''            | ''                              | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Basis'                     | 'Deferred calculation' | 'Vendors advances closing' |
				| ''                                       | 'Receipt'     | '$$DatePurchaseInvoiceAging1$$' | '684,8'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | 'No'                   | ''                         |
				| ''                                       | 'Receipt'     | '$$DatePurchaseInvoiceAging1$$' | '4 000'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | 'No'                   | ''                         |
				| ''                                       | 'Receipt'     | '$$DatePurchaseInvoiceAging1$$' | '4 000'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | 'No'                   | ''                         |
				| ''                                       | 'Receipt'     | '$$DatePurchaseInvoiceAging1$$' | '4 000'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | 'No'                   | ''                         |
			And I select "R5012 Vendors aging" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$PurchaseInvoiceAging1$$'       | ''            | ''                              | ''          | ''             | ''         | ''                   | ''          | ''                          | ''             | ''              |
				| 'Document registrations records'  | ''            | ''                              | ''          | ''             | ''         | ''                   | ''          | ''                          | ''             | ''              |
				| 'Register  "R5012 Vendors aging"' | ''            | ''                              | ''          | ''             | ''         | ''                   | ''          | ''                          | ''             | ''              |
				| ''                                | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'   | ''         | ''                   | ''          | ''                          | ''             | 'Attributes'    |
				| ''                                | ''            | ''                              | 'Amount'    | 'Company'      | 'Currency' | 'Agreement'          | 'Partner'   | 'Invoice'                   | 'Payment date' | 'Aging closing' |
				| ''                                | 'Receipt'     | '$$DatePurchaseInvoiceAging1$$' | '4 000'     | 'Main Company' | 'TRY'      | 'Vendor Ferron, TRY' | 'Ferron BP' | '$$PurchaseInvoiceAging1$$' | '*'            | ''              |
			And I close all client application windows
	* Create second test PI
		When create purchase invoice without order (Vendor Ferron, TRY)
	* Save payment terms date
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
				| 'Number' |
				| '$$NumberPurchaseInvoiceAging$$'|
		And I select current line in "List" table
		And I move to "Aging" tab
		And I select current line in "PaymentTerms" table
		And I delete "$$DatePaymentTermsPurchaseInvoiceAging$$" variable
		And I save the value of "PaymentTermsDate" field of "PaymentTerms" table as "$$DatePaymentTermsPurchaseInvoiceAging$$"
		And I click the button named "FormPostAndClose"
	


Scenario: _1002009 create Cash payment and check Aging register movements
	* Create Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
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
				| 'Ferron BP'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'              |
				| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'   | 'Company'      | 'Legal name'        | 'Partner'   | 'Document'                  |
				| '4 000,00' | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' | '$$PurchaseInvoiceAging1$$' |
			And I click "Select" button
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "4 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment1002009$$" variable
		And I delete "$$CashPayment1002009$$" variable
		And I delete "$$DateCashPayment1002009$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment1002009$$"
		And I save the window as "$$CashPayment1002009$$"
		And I save the value of the field named "Date" as "$$DateCashPayment1002009$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberCashPayment1002009$$'  |
		And I click "Registrations report" button
		And I select "R5012 Vendors aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$CashPayment1002009$$' |
			| 'Document registrations records'           |
		And I close all client application windows
	* Post Vendors advance closing document
		Given I open hyperlink 'e1cib/list/Document.VendorsAdvancesClosing'
		And I go to line in "List" table
			| 'Number' |
			| '1'  |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Number' |
			| '4'  |
		And in the table "List" I click the button named "ListContextMenuPost"	
	* Check movements
		Given I open hyperlink 'e1cib/list/AccumulationRegister.R5012B_VendorsAging'
		And "List" table contains lines
			| 'Period'                        | 'Recorder'                  | 'Currency' | 'Company'      | 'Partner'   | 'Amount'   | 'Agreement'          | 'Invoice'                   | 'Payment date'                             | 'Aging closing'                                        |
			| '$$DatePurchaseInvoiceAging1$$' | '$$PurchaseInvoiceAging1$$' | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | '*'                                        | ''                                                     |
			| '*'                             | '$$PurchaseInvoiceAging$$'  | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '$$DatePaymentTermsPurchaseInvoiceAging$$' | ''                                                     |
			| '$$DateCashPayment1002009$$'    | '$$CashPayment1002009$$'    | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | '*'                                        | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		Then the number of "List" table lines is "равно" "3"
		And I close all client application windows
		



	Scenario: _1002015 create Bank payment and check Aging register movements
		* Create Bank payment
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Main Company' |
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
					| 'Ferron BP'   |
				And I select current line in "List" table
				And I activate "Partner term" field in "PaymentList" table
				And I click choice button of "Partner term" attribute in "PaymentList" table
				And I go to line in "List" table
					| 'Description'              |
					| 'Vendor Ferron, TRY' |
				And I select current line in "List" table
			* Filling in basis documents in a tabular part
				And I finish line editing in "PaymentList" table
				And I activate "Basis document" field in "PaymentList" table
				And I select current line in "PaymentList" table
				And I go to line in "List" table
					| 'Amount' | 'Company'      | 'Legal name'      | 'Partner' | 'Document'               |
					| '4 000,00' | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' | '$$PurchaseInvoiceAging$$' |
				And I click "Select" button
				And I activate field named "PaymentListAmount" in "PaymentList" table
				And I input "200,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankPayment1002015$$" variable
			And I delete "$$BankPayment1002015$$" variable
			And I delete "$$DateBankPayment1002015$$" variable
			And I save the value of "Number" field as "$$NumberBankPayment1002015$$"
			And I save the window as "$$BankPayment1002015$$"
			And I save the value of the field named "Date" as "$$DateBankPayment1002015$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberBankPayment1002015$$'  |
			And I click "Registrations report" button
			And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And I select "R5012 Vendors aging" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| '$$BankPayment1002015$$' |
				| 'Document registrations records'           |
			And I close all client application windows
		* Post Vendors advance closing document
			Given I open hyperlink 'e1cib/list/Document.VendorsAdvancesClosing'
			And I go to line in "List" table
				| 'Number' |
				| '1'  |
			And in the table "List" I click the button named "ListContextMenuPost"
			And I go to line in "List" table
				| 'Number' |
				| '4'  |
			And in the table "List" I click the button named "ListContextMenuPost"	
		* Check movements
			Given I open hyperlink 'e1cib/list/AccumulationRegister.R5012B_VendorsAging'
			And "List" table contains lines
				| 'Period'                        | 'Recorder'                  | 'Currency' | 'Company'      | 'Partner'   | 'Amount'   | 'Agreement'          | 'Invoice'                   | 'Payment date'                             | 'Aging closing'                                        |
				| '$$DatePurchaseInvoiceAging1$$' | '$$PurchaseInvoiceAging1$$' | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | '*'                                        | ''                                                     |
				| '*'                             | '$$PurchaseInvoiceAging$$'  | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '$$DatePaymentTermsPurchaseInvoiceAging$$' | ''                                                     |
				| '$$DateCashPayment1002009$$'    | '$$CashPayment1002009$$'    | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | '*'                                        | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
				| '$$DateBankPayment1002015$$'    | '$$BankPayment1002015$$'    | 'TRY'      | 'Main Company' | 'Ferron BP' | '200,00'   | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '$$DatePaymentTermsPurchaseInvoiceAging$$' | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			Then the number of "List" table lines is "равно" "4"
			And I close all client application windows


Scenario: _1002020 create Credit note and check Aging register movements
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
			| 'Ferron BP'       |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
		* Check the selection of basis documents for the specified partner
			And delay 2
			And I go to line in "List" table
				| 'Document' |
				| '$$PurchaseInvoiceAging$$'  |
			And I select current line in "List" table
			And I click the button named "FormCommandSelect" 
			And I activate field named "TransactionsAmount" in "Transactions" table
			And I input "100,00" text in the field named "TransactionsAmount" of "Transactions" table
			And I finish line editing in "Transactions" table
			And I click the button named "FormPost"
			And I delete "$$CreditNote1002020$$" variable
			And I delete "$$CreditNoteDate1002020$$" variable
			And I save the window as "$$CreditNote1002020$$"
			And I save the value of the field named "Date" as  "$$CreditNoteDate1002020$$"
			And I click "Registrations report" button
		* Check movements
			And I select "R5012 Vendors aging" exact value from "Register" drop-down list
			And I click "Generate report" button
			Then "ResultTable" spreadsheet document is equal
				| '$$CreditNote1002020$$'           | ''            | ''                          | ''          | ''             | ''         | ''                   | ''          | ''                            | ''             | ''              |
				| 'Document registrations records'  | ''            | ''                          | ''          | ''             | ''         | ''                   | ''          | ''                            | ''             | ''              |
				| 'Register  "R5012 Vendors aging"' | ''            | ''                          | ''          | ''             | ''         | ''                   | ''          | ''                            | ''             | ''              |
				| ''                                | 'Record type' | 'Period'                    | 'Resources' | 'Dimensions'   | ''         | ''                   | ''          | ''                            | ''             | 'Attributes'    |
				| ''                                | ''            | ''                          | 'Amount'    | 'Company'      | 'Currency' | 'Agreement'          | 'Partner'   | 'Invoice'                     | 'Payment date' | 'Aging closing' |
				| ''                                | 'Receipt'     | '$$CreditNoteDate1002020$$' | '100'       | 'Main Company' | 'TRY'      | 'Vendor Ferron, TRY' | 'Ferron BP' | '$$PurchaseInvoiceAging$$' | '*'            | ''              |
			And I close all client application windows
		* Post Vendors advance closing document
			Given I open hyperlink 'e1cib/list/Document.VendorsAdvancesClosing'
			And I go to line in "List" table
				| 'Number' |
				| '1'  |
			And in the table "List" I click the button named "ListContextMenuPost"
			And I go to line in "List" table
				| 'Number' |
				| '4'  |
			And in the table "List" I click the button named "ListContextMenuPost"	
		* Check movements
			Given I open hyperlink 'e1cib/list/AccumulationRegister.R5012B_VendorsAging'
			And "List" table contains lines
				| 'Period'                        | 'Recorder'                  | 'Currency' | 'Company'      | 'Partner'   | 'Amount'   | 'Agreement'          | 'Invoice'                   | 'Payment date'                             | 'Aging closing'                                        |
				| '$$DatePurchaseInvoiceAging1$$' | '$$PurchaseInvoiceAging1$$' | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | '*'                                        | ''                                                     |
				| '*'                             | '$$PurchaseInvoiceAging$$'  | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '$$DatePaymentTermsPurchaseInvoiceAging$$' | ''                                                     |
				| '$$DateCashPayment1002009$$'    | '$$CashPayment1002009$$'    | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | '*'                                        | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
				| '$$DateBankPayment1002015$$'    | '$$BankPayment1002015$$'    | 'TRY'      | 'Main Company' | 'Ferron BP' | '200,00'   | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '$$DatePaymentTermsPurchaseInvoiceAging$$' | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
				| '$$CreditNoteDate1002020$$'     | '$$CreditNote1002020$$'     | 'TRY'      | 'Main Company' | 'Ferron BP' | '100,00'   | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '*'                                        | ''                                                     |
			Then the number of "List" table lines is "равно" "5"
	And I close all client application windows
			

Scenario: _1020030 create Debit note and check Aging register movements
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
			| 'Ferron BP'       |
		And I select current line in "List" table
		And I click choice button of "Legal name" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "Transactions" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And in "Transactions" table I move to the next cell
		* Check the selection of basis documents for the specified partner
			And delay 2
			And I go to line in "List" table
				| 'Document' |
				| '$$PurchaseInvoiceAging$$'  |
			And I select current line in "List" table
			And I click the button named "FormCommandSelect" 
			And I activate field named "TransactionsAmount" in "Transactions" table
			And I input "3850,00" text in the field named "TransactionsAmount" of "Transactions" table
			And I finish line editing in "Transactions" table
			And I move to "Other" tab
			And I set checkbox "Due as advance"	
	* Check movements
		And I click the button named "FormPost"
		And I delete "$$DebitNote1020030$$" variable
		And I delete "$$DebitNoteDate1000030$$" variable
		And I save the window as "$$DebitNote1020030$$"
		And I save the value of the field named "Date" as  "$$DebitNoteDate1000030$$"
		And I click "Registrations report" button
		And I select "R5012 Vendors aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$DebitNote1020030$$' |
			| 'Document registrations records'           |
		And I close all client application windows
	* Post Vendors advance closing document
		Given I open hyperlink 'e1cib/list/Document.VendorsAdvancesClosing'
		And I go to line in "List" table
			| 'Number' |
			| '1'  |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I go to line in "List" table
			| 'Number' |
			| '4'  |
		And in the table "List" I click the button named "ListContextMenuPost"	
	* Check movements
		Given I open hyperlink 'e1cib/list/AccumulationRegister.R5012B_VendorsAging'
		And "List" table contains lines
			| 'Period'                        | 'Recorder'                  | 'Currency' | 'Company'      | 'Partner'   | 'Amount'   | 'Agreement'          | 'Invoice'                   | 'Payment date'                             | 'Aging closing'                                        |
			| '$$DatePurchaseInvoiceAging1$$' | '$$PurchaseInvoiceAging1$$' | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | '*'                                        | ''                                                     |
			| '*'                             | '$$PurchaseInvoiceAging$$'  | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '$$DatePaymentTermsPurchaseInvoiceAging$$' | ''                                                     |
			| '$$DateCashPayment1002009$$'    | '$$CashPayment1002009$$'    | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging1$$' | '*'                                        | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '$$DateBankPayment1002015$$'    | '$$BankPayment1002015$$'    | 'TRY'      | 'Main Company' | 'Ferron BP' | '200,00'   | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '$$DatePaymentTermsPurchaseInvoiceAging$$' | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '$$CreditNoteDate1002020$$'     | '$$CreditNote1002020$$'     | 'TRY'      | 'Main Company' | 'Ferron BP' | '100,00'   | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '*'                                        | ''                                                     |
			| '$$DebitNoteDate1000030$$'      | '$$DebitNote1020030$$'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '100,00'   | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '*'                                        | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			| '$$DebitNoteDate1000030$$'      | '$$DebitNote1020030$$'      | 'TRY'      | 'Main Company' | 'Ferron BP' | '3 750,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoiceAging$$'  | '*'                                        | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
		Then the number of "List" table lines is "равно" "7"
	And I close all client application windows
				
Scenario: _1020050 check the offset of Purchase invoice advance (type of settlement by documents)
	* Advance after invoice (Bank payment without basis document)
		* Create Bank payment
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Main Company' |
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
					| 'Ferron BP'   |
				And I select current line in "List" table
				And I input "80,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankPayment1000050$$" variable
			And I delete "$$BankPayment1000050$$" variable
			And I delete "$$DateBankPayment1000050$$" variable
			And I save the value of "Number" field as "$$NumberBankPayment1000050$$"
			And I save the window as "$$BankPayment1000050$$"
			And I save the value of the field named "Date" as "$$DateBankPayment1000050$$"
			And I click the button named "FormPostAndClose"
			And I close all client application windows
		* Create Cash payment
			Given I open hyperlink "e1cib/list/Document.CashPayment"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Main Company' |
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
					| 'Ferron BP'   |
				And I select current line in "List" table
				And I input "50,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashPayment1000050$$" variable
			And I delete "$$CashPayment1000050$$" variable
			And I delete "$$DateCashPayment1000050$$" variable
			And I save the value of "Number" field as "$$NumberCashPayment1000050$$"
			And I save the window as "$$CashPayment1000050$$"
			And I save the value of the field named "Date" as "$$DateCashPayment1000050$$"
			And I click the button named "FormPostAndClose"
	* Advance before invoice (Bank payment without basis document)
		* Create Bank payment (advance + closed the remainder of the invoice)
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Main Company' |
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
					| 'Ferron BP'   |
				And I select current line in "List" table
				And I input "550,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankPayment10000501$$" variable
			And I delete "$$BankPayment10000501$$" variable
			And I delete "$$DateBankPayment10000501$$" variable
			And I save the value of "Number" field as "$$NumberBankPayment10000501$$"
			And I save the window as "$$BankPayment10000501$$"
			And I save the value of the field named "Date" as "$$DateBankPayment10000501$$"
			And I click the button named "FormPostAndClose"
	* Create Purchase invoice
			When create purchase invoice without order (Vendor Ferron, TRY)
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I go to line in "List" table
					| 'Number' |
					| '$$NumberPurchaseInvoiceAging$$'|
			And I select current line in "List" table
			And I click the button named "FormPost"
			And I delete "$$PurchaseInvoice0240164$$" variable
			And I delete "$$DatePurchaseInvoice0240164$$" variable
			And I delete "$$NumberPurchaseInvoice0240164$$" variable
			And I save the window as "$$PurchaseInvoice0240164$$"
			And I save the value of the field named "Date" as "$$DatePurchaseInvoice0240164$$"
			And I save the value of the field named "Number" as "$$NumberPurchaseInvoice0240164$$"
			And I click the button named "FormPostAndClose"
		* Check movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberPurchaseInvoice0240164$$'  |
			And I click "Registrations report" button
			And I select "R5012 Vendors aging" exact value from "Register" drop-down list
			And I click "Generate report" button			
			And "ResultTable" spreadsheet document contains lines:
				| '$$PurchaseInvoice0240164$$'      | ''            | ''                               | ''          | ''             | ''         | ''                   | ''          | ''                           | ''                                                  | ''              |
				| 'Document registrations records'  | ''            | ''                               | ''          | ''             | ''         | ''                   | ''          | ''                           | ''                                                  | ''              |
				| 'Register  "R5012 Vendors aging"' | ''            | ''                               | ''          | ''             | ''         | ''                   | ''          | ''                           | ''                                                  | ''              |
				| ''                                | 'Record type' | 'Period'                         | 'Resources' | 'Dimensions'   | ''         | ''                   | ''          | ''                           | ''                                                  | 'Attributes'    |
				| ''                                | ''            | ''                               | 'Amount'    | 'Company'      | 'Currency' | 'Agreement'          | 'Partner'   | 'Invoice'                    | 'Payment date'                                      | 'Aging closing' |
				| ''                                | 'Receipt'     | '$$DatePurchaseInvoice0240164$$' | '4 000'     | 'Main Company' | 'TRY'      | 'Vendor Ferron, TRY' | 'Ferron BP' | '$$PurchaseInvoice0240164$$' | '$$DatePaymentTermsPurchaseInvoiceAging$$ 00:00:00' | ''              |
	* Create Cash payment (advance + closed the remainder of the invoice)
			Given I open hyperlink "e1cib/list/Document.CashPayment"
			And I click the button named "FormCreate"
			* Select company
				And I click Select button of "Company" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Main Company' |
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
					| 'Ferron BP'   |
				And I select current line in "List" table
				And I input "8000,00" text in the field named "PaymentListAmount" of "PaymentList" table
				And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashPayment10000505$$" variable
			And I delete "$$CashPayment10000505$$" variable
			And I delete "$$DateCashPayment10000505$$" variable
			And I save the value of "Number" field as "$$NumberCashPayment10000505$$"
			And I save the window as "$$CashPayment10000505$$"
			And I save the value of the field named "Date" as "$$DateCashPayment10000505$$"
			And I click the button named "FormPostAndClose"
			And I close all client application windows
		* Post Vendors advance closing document
			Given I open hyperlink 'e1cib/list/Document.VendorsAdvancesClosing'
			And I go to line in "List" table
				| 'Number' |
				| '1'  |
			And in the table "List" I click the button named "ListContextMenuPost"
			And I go to line in "List" table
				| 'Number' |
				| '4'  |
			And in the table "List" I click the button named "ListContextMenuPost"	
		* Check movements
			Given I open hyperlink 'e1cib/list/AccumulationRegister.R5012B_VendorsAging'
			And "List" table contains lines:
				| 'Period'                         | 'Recorder'                   | 'Currency' | 'Company'      | 'Partner'   | 'Amount'   | 'Agreement'          | 'Invoice'                    | 'Payment date'                             | 'Aging closing'                                        |
				| '$$DatePurchaseInvoice0240164$$' | '$$PurchaseInvoice0240164$$' | 'TRY'      | 'Main Company' | 'Ferron BP' | '4 000,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoice0240164$$' | '$$DatePaymentTermsPurchaseInvoiceAging$$' | ''                                                     |
				| '$$DateCashPayment10000505$$'    | '$$CashPayment10000505$$'    | 'TRY'      | 'Main Company' | 'Ferron BP' | '3 370,00' | 'Vendor Ferron, TRY' | '$$PurchaseInvoice0240164$$' | '$$DatePaymentTermsPurchaseInvoiceAging$$' | 'Vendors advances closing 4 dated 28.04.2021 22:00:00' |
			And I close all client application windows	

Scenario: _1020040 check Purchase order Aging tab filling
	* Select PO
		Given I open hyperlink 'e1cib/list/Document.PurchaseOrder'
		And I go to line in "List" table
			| 'Number' |
			| '323'  |
		And I select current line in "List" table
	* Change Aging tab
		And I move to "Aging" tab
		And I activate "Date" field in "PaymentTerms" table
		And I select current line in "PaymentTerms" table
		And I input "15.06.2021" text in "Date" field of "PaymentTerms" table
		And I finish line editing in "PaymentTerms" table
		And "PaymentTerms" table became equal
			| '#' | 'Date'       | 'Amount'   | 'Calculation type' | 'Due period, days' | 'Proportion of payment' |
			| '1' | '15.06.2021' | '1 170,00' | 'Prepaid'          | '16'               | '100,00'                |
		And I activate "Due period, days" field in "PaymentTerms" table
		And I select current line in "PaymentTerms" table
		And I input "10" text in "Due period, days" field of "PaymentTerms" table
		And I finish line editing in "PaymentTerms" table
		And "PaymentTerms" table became equal
			| '#' | 'Date'       | 'Amount'   | 'Calculation type' | 'Due period, days' | 'Proportion of payment' |
			| '1' | '09.06.2021' | '1 170,00' | 'Prepaid'          | '10'               | '100,00'                |
	* Change PO date and check aging tab
		And I move to "Other" tab
		And I input "31.05.2021 00:00:00" text in the field named "Date"
		And I move to "Aging" tab
		Then "Update item list info" window is opened
		And I remove checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
		And I remove checkbox "Do you want to update filled prices?"		
		And I click "OK" button
		And "PaymentTerms" table became equal
			| '#' | 'Date'       | 'Amount'   | 'Calculation type' | 'Due period, days' | 'Proportion of payment' |
			| '1' | '10.06.2021' | '1 170,00' | 'Prepaid'          | '10'               | '100,00'                |
		And I close all client application windows



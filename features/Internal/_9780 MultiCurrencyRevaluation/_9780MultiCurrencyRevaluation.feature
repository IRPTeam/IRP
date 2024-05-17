#language: en
@tree
@Positive
@MultiCurrencyRevaluation

Functionality: foreign currency revaluation

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _0978001 preparation (foreign currency revaluation)
	When set True value to the constant
	When set True value to the constant Use commission trading
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create OtherPartners objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create catalog LegalNameContracts objects
	When Create catalog CancelReturnReasons objects
	When Create catalog CashAccounts objects
	When Create catalog SerialLotNumbers objects
	When settings for Main Company (commission trade)
	When Create catalog RetailCustomers objects (check POS)
	When Create POS cash account objects
	When Create information register CurrencyRates records (multicurrency revaluation)
	* Workstation
		When Create catalog Workstations objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	
	* Load documents
	When Create document BankPayment objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.BankPayment.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.BankPayment.FindByNumber(812).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.BankPayment.FindByNumber(813).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document BankReceipt objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.BankReceipt.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.BankReceipt.FindByNumber(812).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.BankReceipt.FindByNumber(813).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.BankReceipt.FindByNumber(814).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document CashReceipt, CashPayment and objects EmployeeCashAdvance (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.CashReceipt.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.CashPayment.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.EmployeeCashAdvance.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document MoneyTransfer objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.MoneyTransfer.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document OpeningEntry objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.OpeningEntry.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.OpeningEntry.FindByNumber(812).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document PurchaseInvoice objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document SalesInvoice objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(812).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document CustomersAdvancesClosing and VendorsAdvancesClosing objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.CustomersAdvancesClosing.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.VendorsAdvancesClosing.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I close all client application windows


Scenario: _0978002 check preparation
	When check preparation

Scenario: _0978003 check foreign currency revaluation
	And I close all client application windows
	* Create first document foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I click "Create" button
		And I input "01.02.2023 23:59:59" text in the field named "Date"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "(Expense) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I click Select button of "(Expense) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$Number1$$" variable
		And I save the value of "Number" field as "$$Number1$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And "List" table contains lines
			| 'Number'         |
			| '$$Number1$$'    |
		And I close all client application windows
	* Create second document foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I click "Create" button
		And I input "02.02.2023 23:59:59" text in the field named "Date"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "(Expense) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I click Select button of "(Expense) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$Number2$$" variable
		And I save the value of "Number" field as "$$Number2$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And "List" table contains lines
			| 'Number'         |
			| '$$Number2$$'    |
		And I close all client application windows
	* Create third document foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I click "Create" button
		And I input "08.02.2023 23:59:59" text in the field named "Date"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "(Expense) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I click Select button of "(Expense) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$Number3$$" variable
		And I save the value of "Number" field as "$$Number3$$"
		And I delete "$$ForeignCurrencyRevaluation3$$" variable
		And I save the window as "$$ForeignCurrencyRevaluation3$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And "List" table contains lines
			| 'Number'         |
			| '$$Number3$$'    |
		And I close all client application windows
					
Scenario: _0978006 check ForeignCurrencyRevaluation by the Register  "R5015 Other partners transactions"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R5015 Other partners transactions" 
		And I click "Registrations report info" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'               | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                | ''                | ''                     | ''      | ''       | ''                     |
			| 'Register  "R5015 Other partners transactions"' | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                | ''                | ''                     | ''      | ''       | ''                     |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'      | 'Partner'         | 'Agreement'            | 'Basis' | 'Amount' | 'Deferred calculation' |
			| ''                                              | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Other partner 1' | 'Other partner 1' | 'Other partner 1, USD' | ''      | '-1,39'  | 'No'                   |
			| ''                                              | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Other partner 2' | 'Other partner 2' | 'Other partner 2, USD' | ''      | '-2,78'  | 'No'                   |
	And I close all client application windows

Scenario: _0978007 check ForeignCurrencyRevaluation by the Register  "R1020 Advances to vendors"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report info" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'       | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                | ''        | ''      | ''                                 | ''        | ''       | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"' | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                | ''        | ''      | ''                                 | ''        | ''       | ''                     | ''                         |
			| ''                                      | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'      | 'Partner' | 'Order' | 'Agreement'                        | 'Project' | 'Amount' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                      | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Kalipso' | 'Kalipso' | ''      | 'Basic Partner terms, TRY'         | ''        | '1,95'   | 'No'                   | ''                         |
			| ''                                      | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Kalipso' | 'Kalipso' | ''      | 'Basic Partner terms, without VAT' | ''        | '3,89'   | 'No'                   | ''                         |	
	And I close all client application windows

Scenario: _0978008 check ForeignCurrencyRevaluation by the Register  "R2020 Advances from customer"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report info" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'          | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                          | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"' | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                          | ''        | ''       | ''                     | ''                           |
			| ''                                         | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'                 | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                         | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Ferron, USD'               | ''        | '8,25'   | 'No'                   | ''                           |
			| ''                                         | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Kalipso'   | 'Kalipso'   | ''      | 'Personal Partner terms, $' | ''        | '9,55'   | 'No'                   | ''                           |
			| ''                                         | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Big foot'          | 'Big foot'  | ''      | 'Basic Partner terms, $'    | ''        | '7,64'   | 'No'                   | ''                           |
			| ''                                         | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Big foot'          | 'Big foot'  | ''      | 'Basic Partner terms, TRY'  | ''        | '0,39'   | 'No'                   | ''                           |	
	And I close all client application windows

Scenario: _0978009 check ForeignCurrencyRevaluation by the Register  "R2021 Customer transactions"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report info" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'         | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''                          | ''                                            | ''      | ''        | ''       | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"' | ''                    | ''           | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''                          | ''                                            | ''      | ''        | ''       | ''                     | ''                           |
			| ''                                        | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Agreement'                 | 'Basis'                                       | 'Order' | 'Project' | 'Amount' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                        | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | 'Ferron, USD'               | 'Sales invoice 812 dated 02.02.2023 12:00:00' | ''      | ''        | '1,91'   | 'No'                   | ''                           |
			| ''                                        | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Kalipso'   | 'Kalipso'   | 'Personal Partner terms, $' | 'Sales invoice 811 dated 01.02.2023 12:00:00' | ''      | ''        | '38,2'   | 'No'                   | ''                           |	
	And I close all client application windows

Scenario: _0978010 check ForeignCurrencyRevaluation by the Register  "R3010 Cash on hand"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report info" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$' | ''                    | ''           | ''             | ''       | ''                  | ''         | ''                     | ''                             | ''          | ''                     |
			| 'Register  "R3010 Cash on hand"'  | ''                    | ''           | ''             | ''       | ''                  | ''         | ''                     | ''                             | ''          | ''                     |
			| ''                                | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Account'           | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Amount'    | 'Deferred calculation' |
			| ''                                | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Cash desk №1'      | 'USD'      | 'TRY'                  | 'Reporting currency'           | '0,24'      | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Cash desk №1'      | 'USD'      | 'EUR'                  | 'Reporting currency'           | '104'       | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Cash desk №2'      | 'USD'      | 'EUR'                  | 'Reporting currency'           | '10,5'      | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Cash desk №3'      | 'TRY'      | 'USD'                  | 'Local currency'               | '1,91'      | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Bank account, TRY' | 'USD'      | 'TRY'                  | 'Reporting currency'           | '-5,84'     | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Bank account, USD' | 'TRY'      | 'USD'                  | 'Local currency'               | '19,11'     | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Bank account, EUR' | 'TRY'      | 'EUR'                  | 'Local currency'               | '-6 119,97' | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Bank account, EUR' | 'USD'      | 'EUR'                  | 'Reporting currency'           | '223,5'     | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Expense'    | 'Main Company' | ''       | 'Cash desk №1'      | 'TRY'      | 'EUR'                  | 'Local currency'               | '-9,9'      | 'No'                   |
			| ''                                | '08.02.2023 23:59:59' | 'Expense'    | 'Main Company' | ''       | 'Cash desk №2'      | 'TRY'      | 'EUR'                  | 'Local currency'               | '5,13'      | 'No'                   |	
	And I close all client application windows

Scenario: _0978011 check ForeignCurrencyRevaluation by the Register  "R3027 Employee cash advance"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R3027 Employee cash advance" 
		And I click "Registrations report info" button
		And I select "R3027 Employee cash advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'         | ''                    | ''           | ''             | ''       | ''         | ''                     | ''              | ''                             | ''       | ''                     |
			| 'Register  "R3027 Employee cash advance"' | ''                    | ''           | ''             | ''       | ''         | ''                     | ''              | ''                             | ''       | ''                     |
			| ''                                        | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Currency' | 'Transaction currency' | 'Partner'       | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                        | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'USD'      | 'EUR'                  | 'David Romanov' | 'Reporting currency'           | '2,5'    | 'No'                   |
			| ''                                        | '08.02.2023 23:59:59' | 'Expense'    | 'Main Company' | ''       | 'TRY'      | 'EUR'                  | 'David Romanov' | 'Local currency'               | '4,95'   | 'No'                   |
	And I close all client application windows

Scenario: _09780114 check ForeignCurrencyRevaluation by the Register  "R5021 Revenues"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$' | ''                    | ''             | ''       | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''          | ''                  |
			| 'Register  "R5021 Revenues"'      | ''                    | ''             | ''       | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''          | ''                  |
			| ''                                | 'Period'              | 'Company'      | 'Branch' | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount'    | 'Amount with taxes' |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '-6 119,97' | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '-2,78'     | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '-1,39'     | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '1,91'      | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '1,91'      | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '4,95'      | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '19,11'     | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '38,2'      | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '-5,84'     | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '0,24'      | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '1,95'      | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '2,5'       | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '3,89'      | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '10,5'      | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '104'       | ''                  |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '223,5'     | ''                  |
	And I close all client application windows

Scenario: _09780111 check ForeignCurrencyRevaluation by the Register  "R5022 Expenses"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$' | ''                    | ''             | ''       | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'      | ''                    | ''             | ''       | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                | 'Period'              | 'Company'      | 'Branch' | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '-9,9'   | ''                  | ''            | ''                          |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '5,13'   | ''                  | ''            | ''                          |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '6,79'   | ''                  | ''            | ''                          |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '7,64'   | ''                  | ''            | ''                          |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '8,25'   | ''                  | ''            | ''                          |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '9,55'   | ''                  | ''            | ''                          |
			| ''                                | '08.02.2023 23:59:59' | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '0,39'   | ''                  | ''            | ''                          |
	And I close all client application windows

Scenario: _09780112 check ForeignCurrencyRevaluation by the Register  "R5020 Partners balance"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report info" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'    | ''                    | ''           | ''             | ''       | ''                | ''                  | ''                                 | ''                                            | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"' | ''                    | ''           | ''             | ''       | ''                | ''                  | ''                                 | ''                                            | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                   | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Partner'         | 'Legal name'        | 'Agreement'                        | 'Document'                                    | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Ferron BP'       | 'Company Ferron BP' | 'Vendor Ferron, USD'               | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | '-6,79'  | ''                     | ''                 | '-6,79'              | ''               | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Ferron BP'       | 'Company Ferron BP' | 'Ferron, USD'                      | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | '-8,25'  | ''                     | '-8,25'            | ''                   | ''               | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Ferron BP'       | 'Company Ferron BP' | 'Ferron, USD'                      | 'Sales invoice 812 dated 02.02.2023 12:00:00' | 'TRY'      | 'Local currency'               | 'USD'                  | '1,91'   | '1,91'                 | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Kalipso'         | 'Company Kalipso'   | 'Basic Partner terms, TRY'         | ''                                            | 'USD'      | 'Reporting currency'           | 'TRY'                  | '1,95'   | ''                     | ''                 | ''                   | '1,95'           | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Kalipso'         | 'Company Kalipso'   | 'Basic Partner terms, without VAT' | ''                                            | 'USD'      | 'Reporting currency'           | 'TRY'                  | '3,89'   | ''                     | ''                 | ''                   | '3,89'           | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Kalipso'         | 'Company Kalipso'   | 'Personal Partner terms, $'        | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | '-9,55'  | ''                     | '-9,55'            | ''                   | ''               | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Kalipso'         | 'Company Kalipso'   | 'Personal Partner terms, $'        | 'Sales invoice 811 dated 01.02.2023 12:00:00' | 'TRY'      | 'Local currency'               | 'USD'                  | '38,2'   | '38,2'                 | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Big foot'        | 'Big foot'          | 'Basic Partner terms, TRY'         | ''                                            | 'USD'      | 'Reporting currency'           | 'TRY'                  | '-0,39'  | ''                     | '-0,39'            | ''                   | ''               | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Big foot'        | 'Big foot'          | 'Basic Partner terms, $'           | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | '-7,64'  | ''                     | '-7,64'            | ''                   | ''               | ''                  | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Other partner 1' | 'Other partner 1'   | 'Other partner 1, USD'             | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | '-1,39'  | ''                     | ''                 | ''                   | ''               | '-1,39'             | ''                 |
			| ''                                   | '08.02.2023 23:59:59' | 'Receipt'    | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2'   | 'Other partner 2, USD'             | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | '-2,78'  | ''                     | ''                 | ''                   | ''               | '-2,78'             | ''                 |
	And I close all client application windows
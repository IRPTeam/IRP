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
	When Create document BankReceipt objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.BankReceipt.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.BankReceipt.FindByNumber(812).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.BankReceipt.FindByNumber(813).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.BankReceipt.FindByNumber(814).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document CashReceipt objects (multicurrency revaluation)
	And I execute 1C:Enterprise script at server
		| "Documents.CashReceipt.FindByNumber(811).GetObject().Write(DocumentWriteMode.Posting);"   |
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
		And I click "Registrations report" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'                 | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| 'Register  "R5015 Other partners transactions"'   | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | ''                        |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                  | ''                  | 'Attributes'              |
			| ''                                                | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'           | 'Agreement'         | 'Basis'             | 'Deferred calculation'    |
			| ''                                                | 'Receipt'       | '08.02.2023 23:59:59'   | '-2,78'       | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'USD'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
			| ''                                                | 'Receipt'       | '08.02.2023 23:59:59'   | '-2,78'       | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | 'USD'                    | 'Other partner 2'   | 'Other partner 2'   | 'Other partner 2'   | ''                  | 'No'                      |
			| ''                                                | 'Receipt'       | '08.02.2023 23:59:59'   | '-1,39'       | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'USD'                    | 'Other partner 1'   | 'Other partner 1'   | 'Other partner 1'   | ''                  | 'No'                      |
			| ''                                                | 'Receipt'       | '08.02.2023 23:59:59'   | '-1,39'       | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | 'USD'                    | 'Other partner 1'   | 'Other partner 1'   | 'Other partner 1'   |  ''                 | 'No'                      |
	And I close all client application windows

Scenario: _0978007 check ForeignCurrencyRevaluation by the Register  "R1020 Advances to vendors"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'       | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''           | ''        | ''      | ''                        | ''        | ''                     | ''                         |
			| 'Document registrations records'        | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''           | ''        | ''      | ''                        | ''        | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"' | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''           | ''        | ''      | ''                        | ''        | ''                     | ''                         |
			| ''                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''                             | ''         | ''                     | ''           | ''        | ''      | ''                        | ''        | 'Attributes'           | ''                         |
			| ''                                      | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name' | 'Partner' | 'Order' | 'Agreement'               | 'Project' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                      | 'Receipt'     | '08.02.2023 23:59:59' | '1,91'      | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'DFC'        | 'DFC'     | ''      | 'Partner term vendor DFC' | ''        | 'No'                   | ''                         |
			| ''                                      | 'Receipt'     | '08.02.2023 23:59:59' | '1,91'      | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'USD'                  | 'DFC'        | 'DFC'     | ''      | 'Partner term vendor DFC' | ''        | 'No'                   | ''                         |
			| ''                                      | 'Receipt'     | '08.02.2023 23:59:59' | '5 750,07'  | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'EUR'                  | 'DFC'        | 'DFC'     | ''      | 'Partner term vendor DFC' | ''        | 'No'                   | ''                         |
			| ''                                      | 'Expense'     | '08.02.2023 23:59:59' | '55,56'     | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'EUR'                  | 'DFC'        | 'DFC'     | ''      | 'Partner term vendor DFC' | ''        | 'No'                   | ''                         |	
	And I close all client application windows

Scenario: _0978008 check ForeignCurrencyRevaluation by the Register  "R2020 Advances from customer"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'          | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''                     | ''                           |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"' | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | ''                     | ''                           |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''                         | ''        | 'Attributes'           | ''                           |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement'                | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                         | 'Receipt'     | '08.02.2023 23:59:59' | '1,74'      | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Lomaniti'  | 'Lomaniti'  | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '08.02.2023 23:59:59' | '1,74'      | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'USD'                  | 'Company Lomaniti'  | 'Lomaniti'  | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '08.02.2023 23:59:59' | '3,82'      | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Big foot'          | 'Big foot'  | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '08.02.2023 23:59:59' | '7,64'      | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Big foot'          | 'Big foot'  | ''      | 'Basic Partner terms, $'   | ''        | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '08.02.2023 23:59:59' | '9,55'      | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Kalipso'   | 'Kalipso'   | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '08.02.2023 23:59:59' | '9,55'      | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'USD'                  | 'Company Kalipso'   | 'Kalipso'   | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '08.02.2023 23:59:59' | '12,52'     | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
			| ''                                         | 'Receipt'     | '08.02.2023 23:59:59' | '12,52'     | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'USD'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | 'Basic Partner terms, TRY' | ''        | 'No'                   | ''                           |
	And I close all client application windows

Scenario: _0978009 check ForeignCurrencyRevaluation by the Register  "R2021 Customer transactions"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'           | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''          | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'            | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''          | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'   | ''              | ''                      | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''          | ''                           | ''                                              | ''        | ''        | ''                       | ''                              |
			| ''                                          | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                  | ''          | ''                           | ''                                              | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                          | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'   | 'Agreement'                  | 'Basis'                                         | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                          | 'Receipt'       | '08.02.2023 23:59:59'   | '38,2'        | 'Main Company'   | ''         | 'Local currency'                 | 'TRY'        | 'USD'                    | 'Company Kalipso'   | 'Kalipso'   | 'Basic Partner terms, TRY'   | 'Sales invoice 811 dated 01.02.2023 12:00:00'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                          | 'Receipt'       | '08.02.2023 23:59:59'   | '38,2'        | 'Main Company'   | ''         | 'TRY'                            | 'TRY'        | 'USD'                    | 'Company Kalipso'   | 'Kalipso'   | 'Basic Partner terms, TRY'   | 'Sales invoice 811 dated 01.02.2023 12:00:00'   | ''        | ''        | 'No'                     | ''                              |
	And I close all client application windows

Scenario: _0978010 check ForeignCurrencyRevaluation by the Register  "R3010 Cash on hand"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'   | ''              | ''                      | ''            | ''               | ''         | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'    | ''              | ''                      | ''            | ''               | ''         | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'    | ''              | ''                      | ''            | ''               | ''         | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                  | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                  | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                  | 'Receipt'       | '08.02.2023 23:59:59'   | '-4 791,73'   | 'Main Company'   | ''         | 'Bank account, EUR'   | 'USD'        | 'EUR'                    | 'Reporting currency'             | 'No'                      |
			| ''                                  | 'Receipt'       | '08.02.2023 23:59:59'   | '1,91'        | 'Main Company'   | ''         | 'Cash desk №3'        | 'TRY'        | 'USD'                    | 'Local currency'                 | 'No'                      |
			| ''                                  | 'Receipt'       | '08.02.2023 23:59:59'   | '2,29'        | 'Main Company'   | ''         | 'Cash desk №1'        | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                  | 'Receipt'       | '08.02.2023 23:59:59'   | '26,07'       | 'Main Company'   | ''         | 'Bank account, USD'   | 'TRY'        | 'USD'                    | 'Local currency'                 | 'No'                      |
			| ''                                  | 'Receipt'       | '08.02.2023 23:59:59'   | '2 875,04'    | 'Main Company'   | ''         | 'Cash desk №2'        | 'USD'        | 'EUR'                    | 'Reporting currency'             | 'No'                      |
			| ''                                  | 'Expense'       | '08.02.2023 23:59:59'   | '-35,53'      | 'Main Company'   | ''         | 'Bank account, EUR'   | 'TRY'        | 'EUR'                    | 'Local currency'                 | 'No'                      |
			| ''                                  | 'Expense'       | '08.02.2023 23:59:59'   | '17,01'       | 'Main Company'   | ''         | 'Cash desk №2'        | 'TRY'        | 'EUR'                    | 'Local currency'                 | 'No'                      |
			| ''                                  | 'Expense'       | '08.02.2023 23:59:59'   | '71,26'       | 'Main Company'   | ''         | 'Cash desk №1'        | 'USD'        | 'EUR'                    | 'Reporting currency'             | 'No'                      |
	And I close all client application windows

Scenario: _0978011 check ForeignCurrencyRevaluation by the Register  "R3027 Employee cash advance"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R3027 Employee cash advance" 
		And I click "Registrations report" button
		And I select "R3027 Employee cash advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'           | ''              | ''                      | ''            | ''               | ''         | ''           | ''                       | ''                | ''                               | ''                        |
			| 'Document registrations records'            | ''              | ''                      | ''            | ''               | ''         | ''           | ''                       | ''                | ''                               | ''                        |
			| 'Register  "R3027 Employee cash advance"'   | ''              | ''                      | ''            | ''               | ''         | ''           | ''                       | ''                | ''                               | ''                        |
			| ''                                          | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''           | ''                       | ''                | ''                               | 'Attributes'              |
			| ''                                          | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Currency'   | 'Transaction currency'   | 'Partner'         | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                          | 'Expense'       | '08.02.2023 23:59:59'   | '-71,26'      | 'Main Company'   | ''         | 'USD'        | 'EUR'                    | 'David Romanov'   | 'Reporting currency'             | 'No'                      |
	And I close all client application windows

Scenario: _09780114 check ForeignCurrencyRevaluation by the Register  "R5021 Revenues"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'   | ''                      | ''            | ''                    | ''               | ''         | ''                     | ''               | ''           | ''           | ''                      | ''                                | ''                      |
			| 'Document registrations records'    | ''                      | ''            | ''                    | ''               | ''         | ''                     | ''               | ''           | ''           | ''                      | ''                                | ''                      |
			| 'Register  "R5021 Revenues"'        | ''                      | ''            | ''                    | ''               | ''         | ''                     | ''               | ''           | ''           | ''                      | ''                                | ''                      |
			| ''                                  | 'Period'                | 'Resources'   | ''                    | 'Dimensions'     | ''         | ''                     | ''               | ''           | ''           | ''                      | ''                                | ''                      |
			| ''                                  | ''                      | 'Amount'      | 'Amount with taxes'   | 'Company'        | 'Branch'   | 'Profit loss center'   | 'Revenue type'   | 'Item key'   | 'Currency'   | 'Additional analytic'   | 'Multi currency movement type'    | 'Project'               |
			| ''                                  | '08.02.2023 23:59:59'   | '-4 791,73'   | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'USD'        | ''                      | 'Reporting currency'              | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '-2,78'       | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'TRY'        | ''                      | 'Local currency'                  | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '-1,39'       | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'TRY'        | ''                      | 'Local currency'                  | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '1,91'        | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'TRY'        | ''                      | 'Local currency'                  | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '1,91'        | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'TRY'        | ''                      | 'Local currency'                  | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '2,29'        | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'USD'        | ''                      | 'Reporting currency'              | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '26,07'       | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'TRY'        | ''                      | 'Local currency'                  | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '38,2'        | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'TRY'        | ''                      | 'Local currency'                  | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '2 875,04'    | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'USD'        | ''                      | 'Reporting currency'              | ''                      |
			| ''                                  | '08.02.2023 23:59:59'   | '5 750,07'    | ''                    | 'Main Company'   | ''         | 'Front office'         | 'Revenue'        | ''           | 'USD'        | ''                      | 'Reporting currency'              | ''                      |
	And I close all client application windows

Scenario: _09780111 check ForeignCurrencyRevaluation by the Register  "R5022 Expenses"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$' | ''                    | ''          | ''                  | ''            | ''             | ''       | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''                    | ''                          |
			| 'Document registrations records'  | ''                    | ''          | ''                  | ''            | ''             | ''       | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''                    | ''                          |
			| 'Register  "R5022 Expenses"'      | ''                    | ''          | ''                  | ''            | ''             | ''       | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''                    | ''                          |
			| ''                                | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''       | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''                    | 'Attributes'                |
			| ''                                | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch' | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project'             | 'Calculation movement cost' |
			| ''                                | '08.02.2023 23:59:59' | '-71,26'    | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '-35,53'    | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '1,74'      | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '3,82'      | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '7,64'      | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '9,55'      | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '12,52'     | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '17,01'     | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '55,56'     | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                    | ''                          |
			| ''                                | '08.02.2023 23:59:59' | '71,26'     | ''                  | ''            | 'Main Company' | ''       | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''                    | ''                          |		
	And I close all client application windows

Scenario: _09780112 check ForeignCurrencyRevaluation by the Register  "R5020 Partners balance"
		And  I close all client application windows
	* Select ForeignCurrencyRevaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I go to line in "List" table
			| 'Number'         |
			| '$$Number3$$'    |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$ForeignCurrencyRevaluation3$$'    | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''       | ''                | ''                  | ''                         | ''                                            | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'     | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''       | ''                | ''                  | ''                         | ''                                            | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''       | ''                | ''                  | ''                         | ''                                            | ''         | ''                             | ''                     | ''                 |
			| ''                                   | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'   | ''       | ''                | ''                  | ''                         | ''                                            | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                   | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'      | 'Branch' | 'Partner'         | 'Legal name'        | 'Agreement'                | 'Document'                                    | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-12,52'    | ''                     | '-12,52'           | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Ferron BP'       | 'Company Ferron BP' | 'Basic Partner terms, TRY' | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-12,52'    | ''                     | '-12,52'           | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Ferron BP'       | 'Company Ferron BP' | 'Basic Partner terms, TRY' | ''                                            | 'TRY'      | 'TRY'                          | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-9,55'     | ''                     | '-9,55'            | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Kalipso'         | 'Company Kalipso'   | 'Basic Partner terms, TRY' | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-9,55'     | ''                     | '-9,55'            | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Kalipso'         | 'Company Kalipso'   | 'Basic Partner terms, TRY' | ''                                            | 'TRY'      | 'TRY'                          | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-7,64'     | ''                     | '-7,64'            | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Big foot'        | 'Big foot'          | 'Basic Partner terms, $'   | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-3,82'     | ''                     | '-3,82'            | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Big foot'        | 'Big foot'          | 'Basic Partner terms, TRY' | ''                                            | 'USD'      | 'Reporting currency'           | 'TRY'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-2,78'     | ''                     | ''                 | ''                   | ''               | '-2,78'             | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2'   | 'Other partner 2'          | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-2,78'     | ''                     | ''                 | ''                   | ''               | '-2,78'             | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2'   | 'Other partner 2'          | ''                                            | 'TRY'      | 'TRY'                          | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-1,74'     | ''                     | '-1,74'            | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Lomaniti'        | 'Company Lomaniti'  | 'Basic Partner terms, TRY' | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-1,74'     | ''                     | '-1,74'            | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Lomaniti'        | 'Company Lomaniti'  | 'Basic Partner terms, TRY' | ''                                            | 'TRY'      | 'TRY'                          | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-1,39'     | ''                     | ''                 | ''                   | ''               | '-1,39'             | 'Main Company' | ''       | 'Other partner 1' | 'Other partner 1'   | 'Other partner 1'          | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '-1,39'     | ''                     | ''                 | ''                   | ''               | '-1,39'             | 'Main Company' | ''       | 'Other partner 1' | 'Other partner 1'   | 'Other partner 1'          | ''                                            | 'TRY'      | 'TRY'                          | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '1,91'      | ''                     | ''                 | ''                   | '1,91'           | ''                  | 'Main Company' | ''       | 'DFC'             | 'DFC'               | 'Partner term vendor DFC'  | ''                                            | 'TRY'      | 'Local currency'               | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '1,91'      | ''                     | ''                 | ''                   | '1,91'           | ''                  | 'Main Company' | ''       | 'DFC'             | 'DFC'               | 'Partner term vendor DFC'  | ''                                            | 'TRY'      | 'TRY'                          | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '38,2'      | '38,2'                 | ''                 | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Kalipso'         | 'Company Kalipso'   | 'Basic Partner terms, TRY' | 'Sales invoice 811 dated 01.02.2023 12:00:00' | 'TRY'      | 'Local currency'               | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '38,2'      | '38,2'                 | ''                 | ''                   | ''               | ''                  | 'Main Company' | ''       | 'Kalipso'         | 'Company Kalipso'   | 'Basic Partner terms, TRY' | 'Sales invoice 811 dated 01.02.2023 12:00:00' | 'TRY'      | 'TRY'                          | 'USD'                  | ''                 |
			| ''                                   | 'Receipt'     | '08.02.2023 23:59:59' | '5 750,07'  | ''                     | ''                 | ''                   | '5 750,07'       | ''                  | 'Main Company' | ''       | 'DFC'             | 'DFC'               | 'Partner term vendor DFC'  | ''                                            | 'USD'      | 'Reporting currency'           | 'EUR'                  | ''                 |
			| ''                                   | 'Expense'     | '08.02.2023 23:59:59' | '55,56'     | ''                     | ''                 | ''                   | '55,56'          | ''                  | 'Main Company' | ''       | 'DFC'             | 'DFC'               | 'Partner term vendor DFC'  | ''                                            | 'TRY'      | 'Local currency'               | 'EUR'                  | ''                 |
	And I close all client application windows
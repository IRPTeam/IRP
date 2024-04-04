#language: en
@tree
@Positive
@Movements2
@MovementsIncomingPaymentOrder


Feature: check Incoming payment order movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _045100 preparation (Incoming payment order)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Countries objects
		When Create catalog PartnersBankAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		When Create document SalesOrder objects (with aging, prepaid)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(112).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesOrder objects (with aging, post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(113).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoice objects (with aging, prepaid)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(112).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesInvoice objects (with aging, Post-shipment credit)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(113).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document IncomingPaymentOrder objects (Cash planning)
		And I execute 1C:Enterprise script at server
			| "Documents.IncomingPaymentOrder.FindByNumber(113).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _0451001 check preparation
	When check preparation	


Scenario: _045102 check Incoming payment order movements by the Register "R2022 Customers payment planning" (lines with basis)
	* Select Incoming payment order
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '113'       |
	* Check movements by the Register  "R2022 Customers payment planning" 
		And I click "Registrations report info" button
		And I select "R2022 Customers payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Incoming payment order 113 dated 01.06.2021 10:53:53' | ''                    | ''           | ''             | ''        | ''                                            | ''                | ''        | ''                                 | ''       |
			| 'Register  "R2022 Customers payment planning"'         | ''                    | ''           | ''             | ''        | ''                                            | ''                | ''        | ''                                 | ''       |
			| ''                                                     | 'Period'              | 'RecordType' | 'Company'      | 'Branch'  | 'Basis'                                       | 'Legal name'      | 'Partner' | 'Agreement'                        | 'Amount' |
			| ''                                                     | '01.06.2021 10:53:53' | 'Expense'    | 'Main Company' | 'Shop 01' | 'Sales invoice 113 dated 01.06.2021 10:37:58' | 'Company Kalipso' | 'Kalipso' | 'Basic Partner terms, without VAT' | '400'    |
			| ''                                                     | '01.06.2021 10:53:53' | 'Expense'    | 'Main Company' | 'Shop 01' | 'Sales order 112 dated 30.05.2021 12:24:18'   | 'Company Kalipso' | 'Kalipso' | 'Basic Partner terms, without VAT' | '200'    |	
	And I close all client application windows

Scenario: _045103 check Incoming payment order movements by the Register "R3035 Cash planning"
	* Select Incoming payment order
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '113'       |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Incoming payment order 113 dated 01.06.2021 10:53:53' | ''                    | ''          | ''             | ''        | ''                  | ''                                                     | ''         | ''                    | ''         | ''                 | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'                       | ''                    | ''          | ''             | ''        | ''                  | ''                                                     | ''         | ''                    | ''         | ''                 | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'                      | ''                    | ''          | ''             | ''        | ''                  | ''                                                     | ''         | ''                    | ''         | ''                 | ''                             | ''                        | ''                | ''                     |
			| ''                                                     | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                  | ''                                                     | ''         | ''                    | ''         | ''                 | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                                     | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'           | 'Basis document'                                       | 'Currency' | 'Cash flow direction' | 'Partner'  | 'Legal name'       | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                                     | '01.06.2021 10:53:53' | '34,24'     | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'USD'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '01.06.2021 10:53:53' | '68,48'     | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'USD'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '01.06.2021 10:53:53' | '85,6'      | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'USD'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '01.06.2021 10:53:53' | '200'       | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '01.06.2021 10:53:53' | '200'       | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '01.06.2021 10:53:53' | '400'       | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '01.06.2021 10:53:53' | '400'       | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Kalipso'  | 'Company Kalipso'  | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '01.06.2021 10:53:53' | '500'       | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                                     | '01.06.2021 10:53:53' | '500'       | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming payment order 113 dated 01.06.2021 10:53:53' | 'TRY'      | 'Incoming'            | 'Lomaniti' | 'Company Lomaniti' | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
	And I close all client application windows



Scenario: _045112 Incoming payment order clear posting/mark for deletion
	And I close all client application windows
	* Select Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '113'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Incoming payment order 113 dated 01.06.2021 10:53:53'    |
			| 'Document registrations records'                          |
		And I close current window
	* Post Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '113'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '113'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Incoming payment order 113 dated 01.06.2021 10:53:53'    |
			| 'Document registrations records'                          |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '113'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'    |
		And I close all client application windows		

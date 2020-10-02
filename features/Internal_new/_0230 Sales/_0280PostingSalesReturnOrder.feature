#language: en
@tree
@Positive
@Sales

Feature: create document Sales return order

As a sales manager
I want to create a Sales return order document
To track a product that needs to be returned from customer


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _023000 preparation (Sales return order)
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
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
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create SalesOrder023001
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023001$$" |
			When create SalesOrder023001
	* Check or create SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023005$$" |
			When create SalesOrder023005
	* Check or create SalesInvoice024001 based on SalesOrder023001
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024001$$" |
			When create SalesInvoice024001
	* Check or create SalesInvoice024008 based on SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024008$$" |
			When create SalesInvoice024008

Scenario: _028001 create document Sales return order, store use Goods receipt, based on Sales invoice + check status
	When create SalesReturnOrder028001
	* Check for no movements in the registers
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Order'                      | 'Item key' |
			| '1,000'    | '$$SalesReturnOrder028001$$' | 'Store 02' | '$$SalesReturnOrder028001$$' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key' |
			| '-1,000'   | '$$SalesReturnOrder028001$$' | '$$SalesInvoice024008$$' | 'L/Green'  |
		And I close all client application windows
	* And I set Wait status
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesReturnOrder028001$$'      |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Wait" exact value from "Status" drop-down list
		And I click "Post" button
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                 | 'Status'   |
			| '$$SalesReturnOrder028001$$' | 'Wait'     |
			| '$$SalesReturnOrder028001$$' | 'Approved' |
		And I close current window
		And I click "Post and close" button


Scenario: _028002 check  Sales  return order movements the OrderBalance register (store use Goods receipt, based on Sales invoice)  (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'              | 'Item key' |
		| '1,000'    | '$$SalesReturnOrder028001$$' | 'Store 02' | '$$SalesReturnOrder028001$$' | 'L/Green'  |

Scenario: _028003 check  Sales  return order movements the SalesTurnovers register (store use Goods receipt, based on Sales invoice)  (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | '$$SalesReturnOrder028001$$' | '$$SalesInvoice024008$$' | 'L/Green'  |


Scenario: _028004 create document Sales return order, store doesn't use Goods receipt, based on Sales invoice
	When create SalesReturnOrder028004
	* Check for no movements in the registers
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'              | 'Item key' |
			| '1,000'    | '$$SalesReturnOrder028001$$' | 'Store 02' | '$$SalesReturnOrder028001$$' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key' |
			| '-1,000'   | '$$SalesReturnOrder028001$$' | '$$SalesInvoice024008$$' | 'L/Green'  |
		And I close all client application windows
	* And I set Approved status
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesReturnOrder028001$$'      |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                 | 'Status'   |
			| '$$SalesReturnOrder028001$$' | 'Wait'     |
			| '$$SalesReturnOrder028001$$' | 'Approved' |
		And I close current window
		And I click "Post and close" button



Scenario: _028005 check Sales return order movements the OrderBalance register (store doesn't use Goods receipt, based on Sales invoice)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                   | 'Store'    | 'Order'                      | 'Item key'  |
		| '2,000'    | '$$SalesReturnOrder028004$$' | 'Store 01' | '$$SalesReturnOrder028004$$' | 'L/Green'   |
		| '4,000'    | '$$SalesReturnOrder028004$$' | 'Store 01' | '$$SalesReturnOrder028004$$' | '36/Yellow' |

Scenario: _028006 check Sales return order movements the SalesTurnovers register (store doesn't use Goods receipt, based on Sales invoice) (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                   | 'Sales invoice'          | 'Item key'  |
		| '-2,000'   | '$$SalesReturnOrder028004$$' | '$$SalesInvoice024001$$' | 'L/Green'   |
		| '-4,000'   | '$$SalesReturnOrder028004$$' | '$$SalesInvoice024001$$' | '36/Yellow' |



Scenario: _028012 check totals in the document Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Select Sales return
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
		And I select current line in "List" table
	* Check totals in the document Sales return order
		Then the form attribute named "ItemListTotalNetAmount" became equal to "466,10"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "83,90"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "550,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"



Scenario: _028013 check the output of the document movement report for Sales Return Order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesReturnOrder028001$$'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                             | ''                  | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | '$$SalesReturnOrder028001$$' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                             | ''                  | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesReturnOrder028001$$'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                             | ''                  | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | '$$SalesReturnOrder028001$$' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                             | ''                  | ''                     |
	And I close all client application windows


Scenario: _02801301 clear movements Sales Return Order and check that there is no movements on the registers 
	* Open list form Sales Return Order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Check the report generation
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Sales turnovers"'    |
			| 'Register  "Order balance"'      |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesReturnOrder028001$$'          | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''                      | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                             | ''                  | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount'         | 'Company'      | 'Sales invoice'    | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-550'      | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                               | '*'           | '-1'        | '-94,18'    | ''           | ''                      | 'Main Company' | '$$SalesInvoice024008$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                      | ''             | ''                 | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'     | 'Row key'          | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		| ''                               | 'Receipt'     | '*'         | '1'         | 'Store 02'   | '$$SalesReturnOrder028001$$' | 'L/Green'      | '*'                | ''         | ''         | ''        | ''                             | ''                  | ''                     |
		And I close all client application windows


Scenario: _300510 check connection to SalesReturnOrder report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberSalesReturnOrder028001$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
#language: en
@tree
@Positive
@Sales

Feature: create document Sales return

As a procurement manager
I want to create a Sales return document
To track a product that returned from customer

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028500 preparation (create document Sales return)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
	* Check or create SalesReturnOrder028001
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesReturnOrder028001$$" |
			When create SalesReturnOrder028001
	* Check or create SalesReturnOrder028004
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesReturnOrder028004$$" |
			When create SalesReturnOrder028004
	* Check or create SalesInvoice024016
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024016$$" |
			When create SalesInvoice024016 (Shipment confirmation does not used)

Scenario: _028501 create document Sales return, store use Goods receipt, without Sales return order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'                       | 'Partner' |
		| '$$NumberSalesInvoice024016$$' | 'Kalipso' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 02'  |
	And I select current line in "List" table
	And I click "OK" button
	And I move to "Item list" tab
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "1,000" text in "Q" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I move to "Item list" tab
	And "ItemList" table contains lines
	| 'Item'     | 'Item key'  | 'Store'    |
	| 'Dress'    |  'L/Green'  | 'Store 02' |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturn028501$$" variable
	And I delete "$$SalesReturn028501$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturn028501$$"
	And I save the window as "$$SalesReturn028501$$"
	And I click the button named "FormPostAndClose"
	And I close current window




Scenario: _028508 create document Sales return, store does not use Goods receipt, without Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'                       | 'Partner'   |
		| '$$NumberSalesInvoice024008$$' | 'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click "OK" button
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'     |
		| 'Trousers' |
	And I delete a line in "ItemList" table
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "1,000" text in "Q" field of "ItemList" table
	And I input "466,10" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturn028508$$" variable
	And I delete "$$SalesReturn028508$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturn028508$$"
	And I save the window as "$$SalesReturn028508$$"
	And I click the button named "FormPostAndClose"
	And I close current window




Scenario: _028515 create document Sales return, store use Goods receipt, based on Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028001$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I input "466,10" text in "Price" field of "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturn028515$$" variable
	And I delete "$$SalesReturn028515$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturn028515$$"
	And I save the window as "$$SalesReturn028515$$"
	And I click the button named "FormPostAndClose"
	And I close current window


Scenario: _028522 create document Sales return, store does not use Goods receipt, based on Sales return order
	
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturnOrder028004$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturn028522$$" variable
	And I delete "$$SalesReturn028522$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturn028522$$"
	And I save the window as "$$SalesReturn028522$$"
	And I click the button named "FormPostAndClose"
	And I close current window






Scenario: _028534 check totals in the document Sales return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Select Sales Return
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesReturn028501$$'     |
		And I select current line in "List" table
	* Check totals in the document Sales return
		Then the form attribute named "ItemListTotalNetAmount" became equal to "466,10"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "83,90"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "550,00"



Scenario: _300511 check connection to SalesReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberSalesReturn028508$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session
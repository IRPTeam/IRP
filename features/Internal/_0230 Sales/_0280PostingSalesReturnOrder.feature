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


Scenario: _028000 preparation (Sales return order)
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
	* Tax settings
		When filling in Tax settings for company
	When Create document SalesOrder and SalesInvoice objects (creation based on, SI >SO)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);" |
	

Scenario: _028001 create document Sales return order based on SI (button Create)
	* Create Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
				| 'Number'                       | 'Partner'   |
				| '32' | 'Ferron BP' |
		And I select current line in "List" table
		And I click the button named "FormDocumentSalesReturnOrderGenerateSalesReturnOrder"
		* Check the details
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
			Then the form attribute named "Description" became equal to "Click to enter description"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Store" became equal to "Store 02"
		And I select "Approved" exact value from "Status" drop-down list
	* Check items tab
		And "ItemList" table became equal
			| 'Business unit'           | '#' | 'Item'    | 'Dont calculate row' | 'Q'      | 'Unit'           | 'Tax amount' | 'Price'    | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Sales invoice'                              | 'Expense type' | 'Item key' | 'Cancel' | 'Cancel reason' |
			| 'Distribution department' | '1' | 'Dress'   | 'No'                 | '1,000'  | 'pcs'            | '75,36'      | '520,00'   | '18%' | '26,00'         | '418,64'     | '494,00'       | ''                    | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | ''             | 'XS/Blue'  | 'No'     | ''              |
			| 'Distribution department' | '2' | 'Shirt'   | 'No'                 | '12,000' | 'pcs'            | '640,68'     | '350,00'   | '18%' | ''              | '3 559,32'   | '4 200,00'     | ''                    | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | ''             | '36/Red'   | 'No'     | ''              |
			| 'Distribution department' | '3' | 'Boots'   | 'No'                 | '2,000'  | 'Boots (12 pcs)' | '2 434,58'   | '8 400,00' | '18%' | '840,00'        | '13 525,42'  | '15 960,00'    | ''                    | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | ''             | '37/18SD'  | 'No'     | ''              |
			| 'Front office'            | '4' | 'Service' | 'No'                 | '1,000'  | 'pcs'            | '14,49'      | '100,00'   | '18%' | '5,00'          | '80,51'      | '95,00'        | ''                    | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | ''             | 'Interner' | 'No'     | ''              |
			| ''                        | '5' | 'Shirt'   | 'No'                 | '2,000'  | 'pcs'            | '106,78'     | '350,00'   | '18%' | ''              | '593,22'     | '700,00'       | ''                    | 'Store 02' | 'Sales invoice 32 dated 04.03.2021 16:32:23' | ''             | '38/Black' | 'No'     | ''              |
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Manager" became equal to "Region 1"
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "871,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "18 177,11"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "3 271,89"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "21 449"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "21 449,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I click the button named "FormPost"
		And I delete "$$SalesReturnOrder028001$$" variable
		And I delete "$$NumberSalesReturnOrder028001$$" variable
		And I save the window as "$$SalesReturnOrder028001$$"
		And I save the value of "Number" field as "$$NumberSalesReturnOrder028001$$"
		And I click the button named "FormPostAndClose"
	* Check for no movements in the registers
		Given I open hyperlink "e1cib/list/AccumulationRegister.R2012B_SalesOrdersInvoiceClosing"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Order'                      | 'Item key' |
			| '2,000'    | '$$SalesReturnOrder028001$$' | '$$SalesReturnOrder028001$$' | '38/Black'  |
		And I close current window
	* And I set Wait status
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesReturnOrder028001$$'      |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And Delay 2
		And I select "Wait" exact value from "Status" drop-down list
		And Delay 2
		And I click the button named "FormPost"
		* Check for no movements in the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.R2012B_SalesOrdersInvoiceClosing"
			And "List" table does not contain lines
				| 'Quantity' | 'Recorder'                   | 'Order'                      | 'Item key' |
				| '2,000'    | '$$SalesReturnOrder028001$$' | '$$SalesReturnOrder028001$$' | '38/Black'  |
			And I close current window
		And Delay 2
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                 | 'Status'   |
			| '$$SalesReturnOrder028001$$' | 'Wait'     |
			| '$$SalesReturnOrder028001$$' | 'Approved' |
		And I close current window
		And I click the button named "FormPostAndClose"





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
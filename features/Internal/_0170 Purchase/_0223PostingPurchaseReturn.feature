#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase return

As a procurement manager
I want to create a Purchase return document
To track a product that returned to the vendor

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _022300 preparation
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
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
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
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017001$$" |
			When create PurchaseOrder017001
	* Check or create PurchaseOrder017003
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017003$$" |
			When create PurchaseOrder017003
	* Check or create PurchaseInvoice018001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018001$$" |
			When create PurchaseInvoice018001 based on PurchaseOrder017001
	* Check or create PurchaseInvoice018006
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018006$$" |
			When create PurchaseInvoice018006 based on PurchaseOrder017003
	* Check or create PurchaseReturnOrder022001
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseReturnOrder022001$$" |
			When create PurchaseReturnOrder022001 based on PurchaseInvoice018006 (PurchaseOrder017003)
	* Check or create PurchaseReturnOrder022006
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseReturnOrder022006$$" |
			When create PurchaseReturnOrder022006 based on PurchaseInvoice018001 (PurchaseOrder017001)
	







Scenario: _022305 create document Purchase return without Purchase return order
	When create PurchaseReturn022314
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022314$$'      |
	And I select current line in "List" table
	And "ItemList" table contains lines
		| 'Purchase return order' | 'Item'  | 'Item key' | 'Purchase invoice'          | 'Unit' | 'Q'       |
		| ''                      | 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'pcs'  | '500,000' |
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "10,000" text in "Q" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPostAndClose"





Scenario: _022310 create Purchase return based on Purchase return order
	* Save Purchase return order Row id
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberPurchaseReturnOrder022006$$' | 
		And I select current line in "List" table
		And I click "Show row key" button	
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseReturnOrder022310$$" variable
		And I save the current field value as "$$Rov1PurchaseReturnOrder022310$$"
		And I close all client application windows
	* Add items from basis documents
		* Open form for create Purchase return
			Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
			And I click the button named "FormCreate"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Ferron BP' | 
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Company Ferron BP' | 
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Vendor Ferron, TRY' | 
			And I select current line in "List" table
		* Select items from basis documents
			And I click the button named "AddBasisDocuments"
			And "BasisesTree" table contains lines
				| 'Row presentation'              | 'Use'                           | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
				| '$$PurchaseReturnOrder022006$$' | '$$PurchaseReturnOrder022006$$' | ''         | ''     | ''       | ''         |
				| 'Trousers, 36/Yellow'           | 'No'                            | '3,000'    | 'pcs'  | '250,00' | 'TRY'      |
			Then the number of "BasisesTree" table lines is "равно" "2"
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
				| '3,000'    | 'Trousers, 36/Yellow'   | 'pcs'  | 'No'  |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And I click "Show row key" button
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1PurchaseReturn22310$$" variable	
			And I save the current field value as "$$Rov1PurchaseReturn22310$$"			
		* Check Item tab and RowID tab
			And "ItemList" table contains lines
				| 'Store'    | 'Purchase invoice'          | '#' | 'Quantity in base unit' | 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Purchase return order'         |
				| 'Store 01' | '$$PurchaseInvoice018001$$' | '1' | '3,000'                 | 'Trousers' | '36/Yellow' | '3,000' | 'pcs'  | '$$PurchaseReturnOrder022006$$' |
			And "RowIDInfo" table contains lines
				| '#' | 'Key'                         | 'Basis'                         | 'Row ID'                            | 'Next step' | 'Q'     | 'Basis key'                         | 'Current step' | 'Row ref'                           |
				| '1' | '$$Rov1PurchaseReturn22310$$' | '$$PurchaseReturnOrder022006$$' | '$$Rov1PurchaseReturnOrder022310$$' | ''          | '3,000' | '$$Rov1PurchaseReturnOrder022310$$' | 'PR'           | '$$Rov1PurchaseReturnOrder022310$$' |
			* Set checkbox Use SC and check RowID tab
				And I move to "Item list" tab
				And I activate "Use shipment confirmation" field in "ItemList" table
				And I set "Use shipment confirmation" checkbox in "ItemList" table
				And I finish line editing in "ItemList" table
				And I click "Save" button
				And "RowIDInfo" table contains lines
					| '#' | 'Key'                         | 'Basis'                         | 'Row ID'                            | 'Next step' | 'Q'     | 'Basis key'                         | 'Current step' | 'Row ref'                           |
					| '1' | '$$Rov1PurchaseReturn22310$$' | '$$PurchaseReturnOrder022006$$' | '$$Rov1PurchaseReturnOrder022310$$' | 'SC'        | '3,000' | '$$Rov1PurchaseReturnOrder022310$$' | 'PR'           | '$$Rov1PurchaseReturnOrder022310$$' |
		And I close all client application windows
	* Create Purchase return based on Purchase return order(Create button)
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseReturnOrder022006$$' |
		And I click the button named "FormDocumentPurchaseReturnGenerate"
		And I click "Ok" button	
		And Delay 1
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		* Change quantity
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table			
		And I click "Show row key" button	
		And "ItemList" table contains lines
			| 'Store'    | 'Purchase invoice'          | '#' | 'Quantity in base unit' | 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Purchase return order'         |
			| 'Store 01' | '$$PurchaseInvoice018001$$' | '1' | '2,000'                 | 'Trousers' | '36/Yellow' | '2,000' | 'pcs'  | '$$PurchaseReturnOrder022006$$' |
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseReturn22310$$" variable
		And I save the current field value as "$$Rov1PurchaseReturn22310$$"	
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                         | 'Basis'                         | 'Row ID'                            | 'Next step' | 'Q'     | 'Basis key'                         | 'Current step' | 'Row ref'                           |
			| '1' | '$$Rov1PurchaseReturn22310$$' | '$$PurchaseReturnOrder022006$$' | '$$Rov1PurchaseReturnOrder022310$$' | ''          | '2,000' | '$$Rov1PurchaseReturnOrder022310$$' | 'PR'           | '$$Rov1PurchaseReturnOrder022310$$' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseReturn22310$$" variable
		And I delete "$$PurchaseReturn22310$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturn22310$$"
		And I save the window as "$$PurchaseReturn22310$$"
		And I click the button named "FormPostAndClose"


Scenario: _022335 check totals in the document Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Select Purchase Return
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022301$$'     |
		And I select current line in "List" table
	* Check totals in the document Purchase return
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "12,20"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "67,80"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "80,00"



Scenario: _300509 check connection to PurchaseReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberPurchaseReturn022301$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows


Scenario: _999999 close TestClient session
	And I close TestClient session

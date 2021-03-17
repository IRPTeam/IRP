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
	



Scenario: _022301 create document Purchase return, store use Shipment confirmation, based on Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022001$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGeneratePurchaseReturn"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
	* Check the addition of the store to the tabular part
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'  | 'Item key' | 'Purchase invoice'    | 'Store'    | 'Unit' | 'Q'     |
		| 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'Store 02' | 'pcs' | '2,000' |
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturn022301$$" variable
	And I delete "$$PurchaseReturn022301$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturn022301$$"
	And I save the window as "$$PurchaseReturn022301$$"
	And I click the button named "FormPostAndClose"






Scenario: _022309 create document Purchase retur, store use Shipment confirmation, based on Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022006$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGeneratePurchaseReturn"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturn022309$$" variable
	And I delete "$$PurchaseReturn022309$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturn022309$$"
	And I save the window as "$$PurchaseReturn022309$$"
	And I close current window


Scenario: _022314 create document Purchase return, store use Shipment confirmation, without Purchase return order
	When create PurchaseReturn022314
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022314$$'      |
	And I select current line in "List" table
	* Check that the amount from the receipt minus the previous returns is pulled into the return
		And "ItemList" table contains lines
			| 'Purchase return order' | 'Item'  | 'Item key' | 'Purchase invoice'          | 'Unit' | 'Q'       |
			| ''                      | 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'pcs'  | '498,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"


Scenario: _022322 create document Purchase return, store does not use Shipment confirmation, without Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGeneratePurchaseReturn"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key' | 'Q'|
		| 'Trousers' | '36/Yellow'| '8,000'|
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And Delay 2
	And I input "7,000" text in "Q" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'  | 'Item key' | 'Unit' |
		| 'Dress' | 'S/Yellow'  | 'pcs'  |
	And I delete a line in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'  |
		| 'Boots' |
	And I delete a line in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key' | 'Q'|
		| 'Trousers' | '36/Yellow'| '2,000'|
	And I delete a line in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturn022322$$" variable
	And I delete "$$PurchaseReturn022322$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturn022322$$"
	And I save the window as "$$PurchaseReturn022322$$"
	And I click the button named "FormPostAndClose"
	// 4
	And I close current window


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

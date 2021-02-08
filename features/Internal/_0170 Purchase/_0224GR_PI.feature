#language: en
@tree
@Positive
@Purchase

Feature: create document GR - PI



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _022400 preparation (GR-PI)
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
	
	

Scenario: _022401 create GR and PI
	* Create GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click "Create" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I select "Purchase" exact value from "Transaction type" drop-down list
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt022401$$" variable
		And I delete "$$PurchaseInvoice022401$$" variable
		And I delete "$$DateGoodsReceipt022401$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt022401$$"
		And I save the value of "Date" field as "$$DateGoodsReceipt022401$$"
		And I save the window as "$$GoodsReceipt022401$$"
	* Create PI based on GR
		And I click "Purchase invoice" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Dont calculate row' | 'Unit' | 'Q'      |
			| 'Dress'    | 'XS/Blue'   | 'No'                 | 'pcs'  | '10,000' |
			| 'Trousers' | '38/Yellow' | 'No'                 | 'pcs'  | '20,000' |
		* Filling in store, partner term and change quantity
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'        |
				| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
			And I activate "Price" field in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate field named "ItemListQuantity" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0224011$$" variable
			And I delete "$$PurchaseInvoice0224011$$" variable
			And I delete "$$DatePurchaseInvoice0224011$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0224011$$"
			And I save the value of "Date" field as "$$DatePurchaseInvoice0224011$$"
			And I save the window as "$$PurchaseInvoice0224011$$"
	* Create one more PI
		And I activate "$$GoodsReceipt022401$$" window
		And I click "Purchase invoice" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Dont calculate row' | 'Unit' | 'Q'      |
			| 'Dress'    | 'XS/Blue'   | 'No'                 | 'pcs'  | '5,000' |
		* Filling in store, partner term and change quantity
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'        |
				| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Save PI number
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice0224012$$" variable
			And I delete "$$PurchaseInvoice0224012$$" variable
			And I delete "$$DatePurchaseInvoice0224012$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice0224012$$"
			And I save the value of "Date" field as "$$DatePurchaseInvoice0224012$$"
			And I save the window as "$$PurchaseInvoice0224012$$"
		And I close all client application windows
		
Scenario: _022402 check GR postings (register R1031)
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt022401$$'  |
	And I click "Registrations report" button
	And in "ResultTable" spreadsheet document I move to "R1C1" cell
	And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt022401$$'              | ''            | ''                           | ''          | ''             | ''                      | ''          |
		| 'Document registrations records'      | ''            | ''                           | ''          | ''             | ''                      | ''          |
		| 'Register  "R1031 Receipt invoicing"' | ''            | ''                           | ''          | ''             | ''                      | ''          |
		| ''                                    | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions'   | ''                      | ''          |
		| ''                                    | ''            | ''                           | 'Quantity'  | 'Company'      | 'Basis'                 | 'Item key'  |
		| ''                                    | 'Receipt'     | '$$DateGoodsReceipt022401$$' | '10'        | 'Main Company' | '$$GoodsReceipt022401$$' | 'XS/Blue'   |
		| ''                                    | 'Receipt'     | '$$DateGoodsReceipt022401$$' | '20'        | 'Main Company' | '$$GoodsReceipt022401$$' | '38/Yellow' |
	And I select "R4010 Actual stocks" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt022401$$'           | ''            | ''                           | ''          | ''           | ''          |
		| 'Document registrations records'  | ''            | ''                           | ''          | ''           | ''          |
		| 'Register  "R4010 Actual stocks"' | ''            | ''                           | ''          | ''           | ''          |
		| ''                                | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions' | ''          |
		| ''                                | ''            | ''                           | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                                | 'Receipt'     | '$$DateGoodsReceipt022401$$' | '10'        | 'Store 02'   | 'XS/Blue'   |
		| ''                                | 'Receipt'     | '$$DateGoodsReceipt022401$$' | '20'        | 'Store 02'   | '38/Yellow' |
	And I select "R4011 Free stocks" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt022401$$'          | ''            | ''                           | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''                           | ''          | ''           | ''          |
		| 'Register  "R4011 Free stocks"'  | ''            | ''                           | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''                           | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '$$DateGoodsReceipt022401$$' | '10'        | 'Store 02'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '$$DateGoodsReceipt022401$$' | '20'        | 'Store 02'   | '38/Yellow' |
	And I select "Stock reservation" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt022401$$'          | ''            | ''                           | ''          | ''           | ''          |
		| 'Document registrations records' | ''            | ''                           | ''          | ''           | ''          |
		| 'Register  "Stock reservation"'  | ''            | ''                           | ''          | ''           | ''          |
		| ''                               | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions' | ''          |
		| ''                               | ''            | ''                           | 'Quantity'  | 'Store'      | 'Item key'  |
		| ''                               | 'Receipt'     | '$$DateGoodsReceipt022401$$' | '10'        | 'Store 02'   | 'XS/Blue'   |
		| ''                               | 'Receipt'     | '$$DateGoodsReceipt022401$$' | '20'        | 'Store 02'   | '38/Yellow' |
	And I close all client application windows
	
	
		



Scenario: _022403 check PI postings		
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice0224011$$'  |
	And I click "Registrations report" button
	And in "ResultTable" spreadsheet document I move to "R1C1" cell
	And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice0224011$$'          | ''            | ''                               | ''          | ''             | ''                      | ''          |
		| 'Document registrations records'      | ''            | ''                               | ''          | ''             | ''                      | ''          |
		| 'Register  "R1031 Receipt invoicing"' | ''            | ''                               | ''          | ''             | ''                      | ''          |
		| ''                                    | 'Record type' | 'Period'                         | 'Resources' | 'Dimensions'   | ''                      | ''          |
		| ''                                    | ''            | ''                               | 'Quantity'  | 'Company'      | 'Basis'                 | 'Item key'  |
		| ''                                    | 'Expense'     | '$$DatePurchaseInvoice0224011$$' | '5'         | 'Main Company' | '$$GoodsReceipt022401$$' | 'XS/Blue'   |
		| ''                                    | 'Expense'     | '$$DatePurchaseInvoice0224011$$' | '20'        | 'Main Company' | '$$GoodsReceipt022401$$' | '38/Yellow' |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice0224012$$'  |
	And I click "Registrations report" button
	And in "ResultTable" spreadsheet document I move to "R1C1" cell
	And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice0224012$$'          | ''            | ''                               | ''          | ''             | ''                      | ''         |
		| 'Document registrations records'      | ''            | ''                               | ''          | ''             | ''                      | ''         |
		| 'Register  "R1031 Receipt invoicing"' | ''            | ''                               | ''          | ''             | ''                      | ''         |
		| ''                                    | 'Record type' | 'Period'                         | 'Resources' | 'Dimensions'   | ''                      | ''         |
		| ''                                    | ''            | ''                               | 'Quantity'  | 'Company'      | 'Basis'                 | 'Item key' |
		| ''                                    | 'Expense'     | '$$DatePurchaseInvoice0224012$$' | '5'         | 'Main Company' | '$$GoodsReceipt022401$$' | 'XS/Blue'  |
	And I select "R4011 Free stocks" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document does not contain values
		| 'Register  "R4011 Free stocks" '|
	And I select "R4010 Actual stocks" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document does not contain values
		| 'Register  "R4010 Actual stocks"'           |
	And I select "Stock reservation" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document does not contain values
		| 'Register  "Stock reservation"'             |
	And I close all client application windows
	
	




		
				


		
				



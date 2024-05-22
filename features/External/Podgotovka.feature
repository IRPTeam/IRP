#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: create discount Message Dialog Box 2 (Message 3)
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click the button named "FormCreate"
	And I click Select button of "Special offer type" field
	And I click the button named "FormCreate"
	And I click Select button of "Plugins" field
	And I go to line in "List" table
			| 'Description'               |
			| 'ExternalSpecialMessage'    |
	And I select current line in "List" table
	And I click Open button of the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And I click "Set settings" button
	And I select "DialogBox" exact value from "Message type" drop-down list
	And I input "Message 3" text in "Message Description_en" field
	And I input "Message 3" text in "Message Description_tr" field
	And I click "Save settings" button
	And I click "Save and close" button
	And I wait "DialogBox2 (Special offer types) *" window closing in 20 seconds
	And I click the button named "FormChoose"
	And I input "8" text in "Priority" field
	And I input "01.01.2019  0:00:00" text in "Period" field
	And I select "Sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	And I click Open button of the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_tr"
	And I click "Ok" button
	And in the table "Rules" I click the button named "RulesAdd"
	And I click choice button of "Rule" attribute in "Rules" table
	And I go to line in "List" table
			| 'Description'                                    |
			| 'Discount on Basic Partner terms without Vat'    |
	And I select current line in "List" table
	And I finish line editing in "Rules" table
	And I click "Save and close" button
	And Delay 2
	And I go to line in "List" table
			| 'Description'               |
			| 'Discount 2 without Vat'    |
	And I go to line in "List" table
			| 'Description'    |
			| 'DialogBox2'     |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'    |
			| 'Sum'            |
	And I click the button named "FormChoose"

Scenario: transfer the discount Discount 1 without Vat from Sum to Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat'   |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I expand a line in "List" table
		| 'Launch'  | 'Manually'  | 'Priority'  | 'Special offer type'   |
		| 'No'      | 'No'        | '1'         | 'Special Offers'       |
	And I go to line in "List" table
		| 'Launch'  | 'Manually'  | 'Priority'  | 'Special offer type'   |
		| 'No'      | 'No'        | '3'         | 'Maximum'              |
	And I click the button named "FormChoose"



Scenario: changing the auto apply of Discount 1 without Vat
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'               |
			| 'Discount 1 without Vat'    |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: create an order for MIO Basic Partner terms, without VAT (High shoes and Boots)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'MIO'            |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'High shoes'     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'    |
			| '39/19SD'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'    |
			| '39/18SD'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "4,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"



Scenario: transfer the Discount 1 without Vat discount from Maximum to Minimum.
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat'   |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And in the table "List" I click the button named "ListContextMenuLevelDown"
	And Delay 2
	And I click "List" button
	And I go to line in "List" table
		| 'Description'   |
		| 'Min'           |
	And I click the button named "FormChoose"







Scenario: filling in Tax settings for company
	Given I open hyperlink "e1cib/list/Catalog.Companies"
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company'   |
	And I select current line in "List" table
	And I move to "Tax types" tab
	And I go to line in "CompanyTaxes" table
		| 'Period'      | 'Use'  | 'Tax'  | 'Priority'   |
		| '01.01.2020'  | 'Yes'  | 'VAT'  | '5'          |
	And I select current line in "CompanyTaxes" table
	And I click Open button of "Tax" field
	Then "VAT (Tax type)" window is opened
	And I click "Settings" button
	And I click "Ok" button
	And I click "Save and close" button
	And I close all client application windows

Scenario: check load data form in the document
	* Open load date form	
		And in the table "ItemList" I click "Load data from table" button
		Then "Load data from table (form)" window is opened
		And I set checkbox "Show image"
	* Add barcodes
		And in "Template" spreadsheet document I move to "R3C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283705"
		And in "Template" spreadsheet document I move to "R4C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "67789997777801"
		And in "Template" spreadsheet document I move to "R4C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2"
		And I click "Next" button
	* Check
		// Given in "Result" Spreadsheet document and "LoadDataWithPicture" template contain the same pictures
		Given "Result" spreadsheet document is equal to "LoadDataWithPicture" by template
	* Add barcode with serial lot number
		And I click "Back" button
		And Delay 5
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "23455677788976667"
		And Delay 5
		And in "Template" spreadsheet document I move to "R5C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "23455677788976667"
	* Add wrong barcode
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "234500000"
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "234500000"
		And Delay 5
	* Add the same barcode
		And in "Template" spreadsheet document I move to "R7C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283705"
		And in "Template" spreadsheet document I move to "R7C2" cell
		And in "Template" spreadsheet document I input text "5"
	* Check
		And I click "Next" button
		Then "Template" spreadsheet document is equal
			| 'Barcode'             | 'Quantity'    |
			| 'Barcode'             | 'Quantity'    |
			| '2202283705'          | ''            |
			| '67789997777801'      | '2'           |
			| '23455677788976667'   | ''            |
			| '234500000'           | ''            |
			| '2202283705'          | '5'           |
		Then the form attribute named "LoadType" became equal to "Barcode"
		Then "Result" spreadsheet document is equal by template
			| 'Key'   | 'Image'                                      | 'ItemType'                                      | 'Item'                 | 'ItemKey'     | 'SerialLotNumber'           | 'Unit'         | 'hasSpecification'   | 'UseSerialLotNumber'      | 'Quantity'   | 'Barcode'              |
			| 'Key'   | ''                                           | 'Item types'                                    | 'Items'                | 'Item keys'   | 'Item serial/lot numbers'   | 'Item units'   | 'Item types'         | 'Use serial lot number'   | 'Quantity'   | 'Barcode'              |
			| '1'     | 'f82457a7c91f5d12beec5826930cb235blue.jpg'   | 'Clothes'                                       | 'Dress'                | 'XS/Blue'     | ''                          | 'pcs'          | '*'                  | '*'                       | '1,000'      | '2202283705'           |
			| '2'     | ''                                           | 'With serial lot numbers (use stock control)'   | 'Product 1 with SLN'   | 'ODS'         | ''                          | 'pcs'          | '*'                  | '*'                       | '2,000'      | '67789997777801'       |
			| '3'     | ''                                           | 'With serial lot numbers (use stock control)'   | 'Product 1 with SLN'   | 'PZU'         | '8908899877'                | 'pcs'          | '*'                  | '*'                       | '1,000'      | '23455677788976667'    |
			| '4'     | ''                                           | ''                                              | ''                     | ''            | ''                          | ''             | '*'                  | '*'                       | '1,000'      | '234500000'            |
			| '5'     | 'f82457a7c91f5d12beec5826930cb235blue.jpg'   | 'Clothes'                                       | 'Dress'                | 'XS/Blue'     | ''                          | 'pcs'          | '*'                  | '*'                       | '5,000'      | '2202283705'           |
		And "ErrorList" table became equal
			| 'Row'   | 'Column'   | 'Error text'      |
			| '4'     | '6'        | '[Not filled]'    |
			| '6'     | '4'        | '[Not filled]'    |
			| '6'     | '5'        | '[Not filled]'    |
	* Fix barcode and check loading
		And I click "Back" button
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283713"
		And Delay 5
		And in "Template" spreadsheet document I move to "R6C1" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "2202283713"
		And in "Template" spreadsheet document I move to "R6C2" cell
		And in "Template" spreadsheet document I double-click the current cell
		And in "Template" spreadsheet document I input text "3"
		And I click "Next" button
		And I click "Next" button



Scenario: add Plugin for tax calculation
		* Opening a form to add Plugin sessing
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		* Addition of Plugin sessing for calculating Tax types for Turkey (VAT)
			And I click the button named "FormCreate"
			And I select external file "$Path$/DataProcessor/TaxCalculateVAT_TR.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "TaxCalculateVAT_TR" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "TaxCalculateVAT_TR" text in the field named "Description_en"
			And I input "TaxCalculateVAT_TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And I wait "Plugins (create)" window closing in 10 seconds
		* Check added processing
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "TaxCalculateVAT_TR"
			Given I open hyperlink "e1cib/list/Catalog.Taxes"		
			And I go to line in "List" table
				| 'Description'     |
				| 'VAT'             |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'            |
				| 'TaxCalculateVAT_TR'     |
			And I select current line in "List" table
			And I click "Save and close" button
		And I close all client application windows


Scenario: add Plugin for print label
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		And I click the button named "FormCreate"
		And I select external file "$Path$/DataProcessor/PromotionalAndOldPricesPrintLabel.epf"
		And I click the button named "FormAddExtDataProc"
		And I input "" text in "Path to plugin for test" field
		And I input "PrintLabel" text in "Name" field
		And I click Open button of the field named "Description_en"
		And I input "PrintLabel" text in the field named "Description_en"
		And I input "PrintLabel" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I wait "Plugins (create)" window closing in 10 seconds
		Then I check for the "ExternalDataProc" catalog element with the "Description_en" "PrintLabel"

Scenario: create PurchaseOrder017001
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Status filling
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description           |
			| Vendor Ferron, TRY    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
				| Description     |
				| Dress           |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'M/White'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
				| Description     |
				| Dress           |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'    |
			| 'L/Green'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Unit'    |
			| '1'   | 'Dress'   | 'M/White'    | 'pcs'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100" text in "Quantity" field of "ItemList" table
		And I input "200" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Unit'    |
			| '2'   | 'Dress'   | 'L/Green'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200" text in "Quantity" field of "ItemList" table
		And I input "210" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'       | 'Item key'    | 'Unit'    |
			| '3'   | 'Trousers'   | '36/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "300" text in "Quantity" field of "ItemList" table
		And I input "250" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'    | 'Quantity'   | 'Item key'   | 'Store'      | 'Unit'    |
			| 'Dress'   | '100,000'    | 'M/White'    | 'Store 01'   | 'pcs'     |
		And I input end of the current month date in "Delivery date" field
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder017001$$" variable
		And I delete "$$PurchaseOrder017001$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder017001$$"
		And I save the window as "$$PurchaseOrder017001$$"
		And I click the button named "FormPostAndClose"

Scenario: create PurchaseOrder017003
		* Opening a form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in the details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description     |
			| Main Company    |
			And I select current line in "List" table
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor information
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description            |
				| Vendor Ferron, USD     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '1'    | 'Dress'    | 'L/Green'     | 'pcs'      |
			And I select current line in "ItemList" table
			And I input "500,000" text in "Quantity" field of "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Post document
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder017003$$" variable
			And I delete "$$PurchaseOrder017003$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder017003$$"
			And I save the window as "$$PurchaseOrder017003$$"
			And I click the button named "FormPostAndClose"

Scenario: create PurchaseInvoice018001 based on PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder017001$$'    |
		And I select current line in "List" table
		* Check filling of elements upon entry based on
			And I click the button named "FormDocumentPurchaseInvoiceGenerate"
			And I click "Ok" button
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
			Then the form attribute named "Store" became equal to "Store 01"
			Then the form attribute named "Company" became equal to "Main Company"
		* Check filling items table
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'       | 'Purchase order'            | 'Item key'    | 'Unit'   | 'Quantity'    |
			| 'Dress'      | '$$PurchaseOrder017001$$'   | 'M/White'     | 'pcs'    | '100,000'     |
			| 'Dress'      | '$$PurchaseOrder017001$$'   | 'L/Green'     | 'pcs'    | '200,000'     |
			| 'Trousers'   | '$$PurchaseOrder017001$$'   | '36/Yellow'   | 'pcs'    | '300,000'     |
		* Check filling prices
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'Item key'    | 'Quantity'   | 'Price type'                | 'Store'       |
			| '200,00'   | 'Dress'      | 'M/White'     | '100,000'    | 'en description is empty'   | 'Store 01'    |
			| '210,00'   | 'Dress'      | 'L/Green'     | '200,000'    | 'en description is empty'   | 'Store 01'    |
			| '250,00'   | 'Trousers'   | '36/Yellow'   | '300,000'    | 'en description is empty'   | 'Store 01'    |
		* Check addition of the store in tabular part
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Store'      | 'Unit'   | 'Quantity'    |
			| 'Dress'   | 'M/White'    | 'Store 01'   | 'pcs'    | '100,000'     |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice018001$$" variable
		And I delete "$$PurchaseInvoice018001$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018001$$"
		And I save the window as "$$PurchaseInvoice018001$$"
		And I click the button named "FormPostAndClose"

Scenario: create PurchaseInvoice018006 based on PurchaseOrder017003
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder017003$$'    |
		And I select current line in "List" table
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		* Check filling of elements upon entry based on
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
			Then the form attribute named "Store" became equal to "Store 02"
		* Check filling items table
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'    | 'Purchase order'            | 'Item key'   | 'Unit'   | 'Quantity'    |
			| 'Dress'   | '$$PurchaseOrder017003$$'   | 'L/Green'    | 'pcs'    | '500,000'     |
		* Filling prices
			And "ItemList" table contains lines
			| 'Price'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Price type'                | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'    |
			| '40,00'   | 'Dress'   | 'L/Green'    | '500,000'    | 'en description is empty'   | 'pcs'    | '3 050,85'     | '16 949,15'    | '20 000,00'       |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice018006$$" variable
		And I delete "$$PurchaseInvoice018006$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018006$$"
		And I save the window as "$$PurchaseInvoice018006$$"
		And I click the button named "FormPostAndClose"



Scenario: create PurchaseReturnOrder022001 based on PurchaseInvoice018006 (PurchaseOrder017003)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'                            |
		| '$$NumberPurchaseInvoice018006$$'   |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnOrderGenerate"
	And I click "Ok" button
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I activate "Quantity" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "2,000" text in "Quantity" field of "ItemList" table
	And I input "40,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	* Check the addition of the store to the tabular partner
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Purchase invoice'           | 'Store'     | 'Unit'  | 'Quantity'   |
		| 'Dress'  | 'L/Green'   | '$$PurchaseInvoice018006$$'  | 'Store 02'  | 'pcs'   | '2,000'      |
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturnOrder022001$$" variable
	And I delete "$$PurchaseReturnOrder022001$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022001$$"
	And I save the window as "$$PurchaseReturnOrder022001$$"
	And I click the button named "FormPostAndClose"
	
Scenario: create PurchaseReturnOrder022006 based on PurchaseInvoice018001
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'                            |
		| '$$NumberPurchaseInvoice018001$$'   |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnOrderGenerate"
	And I click "Ok" button
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'      | 'Item key'   | 'Unit'   |
		| 'Trousers'  | '36/Yellow'  | 'pcs'    |
	And I select current line in "ItemList" table
	And Delay 2
	And I input "3,000" text in "Quantity" field of "ItemList" table
	And Delay 2
	And I finish line editing in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'   | 'Item key'  | 'Unit'   |
		| 'Dress'  | 'L/Green'   | 'pcs'    |
	And Delay 2
	And I delete a line in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'   | 'Item key'  | 'Unit'   |
		| 'Dress'  | 'M/White'   | 'pcs'    |
	And I delete a line in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturnOrder022006$$" variable
	And I delete "$$PurchaseReturnOrder022006$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022006$$"
	And I save the window as "$$PurchaseReturnOrder022006$$"
	And I click the button named "FormPostAndClose"
	And I close current window



Scenario: create InventoryTransferOrder020001
	* Opening a form to create Inventory transfer order
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I click the button named "FormCreate"
		* Filling in Store sender and Store receiver
			And I click Select button of "Store sender" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I click Select button of "Store receiver" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
			And I select "Approved" exact value from "Status" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
		* Filling in items table
			And I move to "Item list" tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'M/White'      |
			And I select current line in "List" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I click the button named "FormChoose"
			And I move to the next attribute
			And I input "50,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'S/Yellow'     |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I click the button named "FormChoose"
			And I move to the next attribute
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberInventoryTransferOrder020001$$" variable
		And I delete "$$InventoryTransferOrder020001$$" variable
		And I save the value of "Number" field as "$$NumberInventoryTransferOrder020001$$"
		And I save the window as "$$InventoryTransferOrder020001$$"
		And I click the button named "FormPostAndClose"

Scenario: create InventoryTransferOrder020004
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'L/Green'     |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransferOrder020004$$" variable
	And I delete "$$InventoryTransferOrder020004$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransferOrder020004$$"
	And I save the window as "$$InventoryTransferOrder020004$$"
	And I click the button named "FormPostAndClose"

Scenario: create InventoryTransferOrder020007
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'L/Green'     |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "17,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransferOrder020007$$" variable
	And I delete "$$InventoryTransferOrder020007$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransferOrder020007$$"
	And I save the window as "$$InventoryTransferOrder020007$$"
	And I click the button named "FormPostAndClose"

Scenario: create InventoryTransferOrder020010
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 04'       |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Trousers       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'     |
			| '36/Yellow'    |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransferOrder020010$$" variable
	And I delete "$$InventoryTransferOrder020010$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransferOrder020010$$"
	And I save the window as "$$InventoryTransferOrder020010$$"
	And I click the button named "FormPostAndClose"

Scenario: create SalesOrder023001
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	Then "Partner terms" window is opened
	And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
	And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'L/Green'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate "Profit loss center" field in "ItemList" table
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Revenue type" field in "ItemList" table
		And I click choice button of "Revenue type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I input "123" text in "Detail" field of "ItemList" table
		And I click choice button of "Sales person" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Anna Petrova'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Trousers       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "4,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I activate "Profit loss center" field in "ItemList" table
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Revenue type" field in "ItemList" table
		And I click choice button of "Revenue type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I click choice button of "Sales person" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Alexander Orlov'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Check store filling in the tabular section
		And "ItemList" table contains lines
		| 'Item'   | 'Price'   | 'Item key'  | 'Store'      |
		| 'Dress'  | '550,00'  | 'L/Green'   | 'Store 01'   |
	* Check default sales order status
		And I move to "Other" tab
		Then the form attribute named "Status" became equal to "Approved"
	* Filling Delivery date
		And I input current date in the field named "DeliveryDate"
	And I click the button named "FormPost"
	And I delete "$$SalesOrder023001$$" variable
	And I delete "$$NumberSalesOrder023001$$" variable
	And I save the window as "$$SalesOrder023001$$"
	And I save the value of "Number" field as "$$NumberSalesOrder023001$$"
	And I close current window
	And I display "$$SalesOrder023001$$" variable value



Scenario: create SalesOrder023005
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'                          |
				| 'Basic Partner terms, without VAT'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
		And I select current line in "List" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key'   |
		| 'L/Green'    |
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "10,000" text in "Quantity" field of "ItemList" table
	And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	And I activate "Profit loss center" field in "ItemList" table
	And I click choice button of "Profit loss center" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'               |
		| 'Distribution department'   |
	And I select current line in "List" table
	And I activate "Revenue type" field in "ItemList" table
	And I click choice button of "Revenue type" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Revenue'       |
	And I select current line in "List" table
	And I input "123" text in "Detail" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| Description   |
		| Trousers      |
	And I select current line in "List" table
	And I move to the next attribute
	And I click choice button of "Item key" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "14,000" text in "Quantity" field of "ItemList" table
	And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	And I activate "Profit loss center" field in "ItemList" table
	And I click choice button of "Profit loss center" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'               |
		| 'Distribution department'   |
	And I select current line in "List" table
	And I activate "Revenue type" field in "ItemList" table
	And I click choice button of "Revenue type" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Revenue'       |
	And I select current line in "List" table
	And I input "123" text in "Detail" field of "ItemList" table
	And I finish line editing in "ItemList" table
	* Check default sales order status
		And I move to "Other" tab
		Then the form attribute named "Status" became equal to "Approved"
	And I input end of the current month date in "Delivery date" field
	And I click the button named "FormPost"
	And I delete "$$SalesOrder023005$$" variable
	And I delete "$$NumberSalesOrder023005$$" variable
	And I save the window as "$$SalesOrder023005$$"
	And I save the value of "Number" field as "$$NumberSalesOrder023005$$"
	And I close current window
	And I display "$$SalesOrder023005$$" variable value

Scenario: create SalesInvoice024001
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| Number                       |
		| $$NumberSalesOrder023001$$   |
	And I click the button named "FormDocumentSalesInvoiceGenerate"	
	And I click "Ok" button
	* Check that information is filled in when creating based on
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
	* Check adding Store
		And I move to "Item list" tab
		And "ItemList" table contains lines
			| 'Item'       | Price   | 'Item key'    | 'Store'      | 'Sales order'            | 'Unit'   | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Net amount'   | 'Total amount'    |
			| 'Dress'      | '*'     | 'L/Green'     | 'Store 01'   | '$$SalesOrder023001$$'   | 'pcs'    | '5,000'      | '*'               | '*'            | '*'            | '*'               |
			| 'Trousers'   | '*'     | '36/Yellow'   | 'Store 01'   | '$$SalesOrder023001$$'   | 'pcs'    | '4,000'      | '*'               | '*'            | '*'            | '*'               |
	* Check prices and type of prices
		And "ItemList" table contains lines
		| 'Price'   | 'Item'      | 'Item key'   | 'Quantity'  | 'Price type'          |
		| '550,00'  | 'Dress'     | 'L/Green'    | '5,000'     | 'Basic Price Types'   |
		| '400,00'  | 'Trousers'  | '36/Yellow'  | '4,000'     | 'Basic Price Types'   |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesInvoice024001$$" variable
	And I delete "$$SalesInvoice024001$$" variable
	And I save the value of "Number" field as "$$NumberSalesInvoice024001$$"
	And I save the window as "$$SalesInvoice024001$$"
	And I click the button named "FormPostAndClose"
	And I close current window

Scenario: create SalesInvoice024008
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number'                      | 'Partner'     |
		| '$$NumberSalesOrder023005$$'  | 'Ferron BP'   |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesInvoiceGenerate"
	And I click "Ok" button
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check filling prices and type of prices
		And "ItemList" table contains lines
		| 'Price'   | 'Item'      | 'Item key'   | 'Price type'               | 'Quantity'   |
		| '466,10'  | 'Dress'     | 'L/Green'    | 'Basic Price without VAT'  | '10,000'     |
		| '338,98'  | 'Trousers'  | '36/Yellow'  | 'Basic Price without VAT'  | '14,000'     |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesInvoice024008$$" variable
	And I delete "$$SalesInvoice024008$$" variable
	And I save the value of "Number" field as "$$NumberSalesInvoice024008$$"
	And I save the window as "$$SalesInvoice024008$$"
	And I click the button named "FormPostAndClose"
	And I close current window


Scenario: create SalesReturnOrder028004
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                         | 'Partner'      |
			| '$$NumberSalesInvoice024001$$'   | 'Ferron BP'    |
		And I select current line in "List" table
		And I click the button named "FormDocumentSalesReturnOrderGenerate"
		And I click "Ok" button
		* Check the details
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
			Then the form attribute named "Description" became equal to "Click to enter description"
			Then the form attribute named "Company" became equal to "Main Company"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'L/Green'     |
		And I select current line in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I input "550,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| Item       | Item key     |
			| Trousers   | 36/Yellow    |
		And I select current line in "ItemList" table
		And I input "400,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturnOrder028004$$" variable
		And I delete "$$SalesReturnOrder028004$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturnOrder028004$$"
		And I save the window as "$$SalesReturnOrder028004$$"
		And I click the button named "FormPostAndClose"
		And I close current window

	
Scenario: create SalesReturnOrder028001
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'                        | 'Partner'     |
		| '$$NumberSalesInvoice024008$$'  | 'Ferron BP'   |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnOrderGenerate"
	And I click "Ok" button
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
	And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'       |
		| 'Trousers'   |
	And I delete a line in "ItemList" table
	And I activate "Quantity" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "1,000" text in "Quantity" field of "ItemList" table
	And I input "466,10" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Store'      |
		| 'Dress'  | 'L/Green'   | 'Store 02'   |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturnOrder028001$$" variable
	And I delete "$$SalesReturnOrder028001$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturnOrder028001$$"
	And I save the window as "$$SalesReturnOrder028001$$"
	And I click the button named "FormPostAndClose"
	And I close all client application windows


Scenario: create SalesInvoice024025
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Change store to Store 02
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'L/Green'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I set "Use shipment confirmation" checkbox in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberSalesInvoice024025$$" variable
	And I delete "$$SalesInvoice024025$$" variable
	And I save the value of "Number" field as "$$NumberSalesInvoice024025$$"
	And I save the window as "$$SalesInvoice024025$$"
	And I click the button named "FormPostAndClose"

Scenario: create PurchaseReturn022314
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number'                            |
		| '$$NumberPurchaseInvoice018006$$'   |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGenerate"
	And I click "Ok" button
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturn022314$$" variable
	And I delete "$$PurchaseReturn022314$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturn022314$$"
	And I save the window as "$$PurchaseReturn022314$$"
	And I click the button named "FormPostAndClose"
	


Scenario: create InventoryTransfer021030
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	And I click Select button of "Store sender" field
	And I go to line in "List" table
		| Description   |
		| Store 02      |
	And I select current line in "List" table
	And I click Select button of "Store receiver" field
	And I go to line in "List" table
		| Description   |
		| Store 03      |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company'   |
	And I select current line in "List" table
	And I move to "Items" tab
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Dress'         |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key'   |
		| 'L/Green'    |
	And I select current line in "List" table
	And I activate "Unit" field in "ItemList" table
	And I click choice button of "Unit" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "3,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransfer021030$$" variable
	And I delete "$$InventoryTransfer021030$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransfer021030$$"
	And I save the window as "$$InventoryTransfer021030$$"
	And I click the button named "FormPostAndClose"

Scenario: Create document PriceList objects (works)

	And I check or create document "PriceList" objects:
		| 'Ref'                                                                 | 'DeletionMark'  | 'Number'  | 'Date'                 | 'Posted'  | 'ItemType'  | 'PriceListType'                     | 'PriceType'                                                           | 'Author'                                                         | 'Branch'  | 'Description'   |
		| 'e1cib/data/Document.PriceList?ref=b785989306affb7a11ed3da49fd4558c'  | 'False'         | 21        | '25.09.2022 17:18:39'  | 'False'   | ''          | 'Enum.PriceListTypes.PriceByItems'  | 'e1cib/data/Catalog.PriceTypes?ref=aa78120ed92fbced11eaf114c59eeffe'  | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0'  | ''        | ''              |
		| 'e1cib/data/Document.PriceList?ref=b785989306affb7a11ed3da49fd4558d'  | 'False'         | 22        | '25.09.2022 17:19:14'  | 'False'   | ''          | 'Enum.PriceListTypes.PriceByItems'  | 'e1cib/data/Catalog.PriceTypes?ref=aa78120ed92fbced11eaf114c59ef002'  | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0'  | ''        | ''              |

	And I refill object tabular section "ItemList":
		| 'Ref'                                                                 | 'Item'                                                           | 'Price'  | 'InputUnit'                                                      | 'InputPrice'  | 'Unit'                                                            |
		| 'e1cib/data/Document.PriceList?ref=b785989306affb7a11ed3da49fd4558c'  | 'e1cib/data/Catalog.Items?ref=b785989306affb7a11ed39a5560fdf6e'  | 100      | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |               | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'   |
		| 'e1cib/data/Document.PriceList?ref=b785989306affb7a11ed3da49fd4558c'  | 'e1cib/data/Catalog.Items?ref=b785989306affb7a11ed39a5560fdf71'  | 110      | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |               | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'   |
		| 'e1cib/data/Document.PriceList?ref=b785989306affb7a11ed3da49fd4558c'  | 'e1cib/data/Catalog.Items?ref=b785989306affb7a11ed39af48f5fa03'  | 120      | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |               | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'   |
		| 'e1cib/data/Document.PriceList?ref=b785989306affb7a11ed3da49fd4558d'  | 'e1cib/data/Catalog.Items?ref=b785989306affb7a11ed39a5560fdf6e'  | 70       | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |               | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'   |
		| 'e1cib/data/Document.PriceList?ref=b785989306affb7a11ed3da49fd4558d'  | 'e1cib/data/Catalog.Items?ref=b785989306affb7a11ed39a5560fdf71'  | 80       | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |               | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'   |
		| 'e1cib/data/Document.PriceList?ref=b785989306affb7a11ed3da49fd4558d'  | 'e1cib/data/Catalog.Items?ref=b785989306affb7a11ed39af48f5fa03'  | 90       | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |               | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'   |



Scenario: create SalesInvoice024016 (Shipment confirmation does not used)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer information
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Kalipso'         |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
			And I select current line in "List" table
		* Select store 
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I input end of the current month date in "Delivery date" field
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice024016$$" variable
		And I delete "$$SalesInvoice024016$$" variable
		And I delete "$$DateSalesInvoice024016$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice024016$$"
		And I save the window as "$$SalesInvoice024016$$"
		And I save the value of the field named "Date" as "$$DateSalesInvoice024016$$"
		And I click the button named "FormPostAndClose"

Scenario: create SalesReturn30001
	* Open form  Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		* Filling in item and item key
			And I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn30001$$" variable
		And I delete "$$SalesReturn30001$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn30001$$"
		And I save the window as "$$SalesReturn30001$$"
		And I click the button named "FormPostAndClose"


Scenario: create PurchaseReturn300301
	* Open form  Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		* Filling in item and item key
			And I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'        | 'Item key'      |
				| 'Trousers'    | '38/Yellow'     |
			And I select current line in "List" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseReturn300301$$" variable
		And I delete "$$PurchaseReturn300301$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturn300301$$"
		And I save the window as "$$PurchaseReturn300301$$"
		And I click the button named "FormPostAndClose"


Scenario: set True value to the constant
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I click "Check all" button
		And I go to line in "FunctionalOptions" table
			| 'Option'                       | 'Use'    |
			| 'Use lock data modification'   | 'Yes'    |
		And I activate "Use" field in "FunctionalOptions" table
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'                          | 'Use'    |
			| 'Use consolidated retail sales'   | 'Yes'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'                                 | 'Use'    |
			| 'Use job queue for external functions'   | 'Yes'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'               | 'Use'    |
			| 'Use all functional'   | 'Yes'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'           | 'Use'    |
			| 'Use accounting'   | 'Yes'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'                   | 'Use'    |
			| 'Use commission trading'   | 'Yes'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'       | 'Use'    |
			| 'Use salary'   | 'Yes'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		// And I go to line in "FunctionalOptions" table
		// 	| 'Option'                                | 'Use' |
		// 	| 'Use additional table control document' | 'Yes' |
		// And I remove "Use" checkbox in "FunctionalOptions" table
		// And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'                                | 'Use' |
			| 'Use additional table control document' | 'Yes' |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'          | 'Use' |
			| 'Use simple mode' | 'Yes' |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'           | 'Use' |
			| 'Use fixed assets' | 'Yes' |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'            | 'Use' |
			| 'Use object access' | 'Yes' |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window
	* Disable LinkedRowsIntegrity
		And I execute 1C:Enterprise script at server
			| "Constants.DisableLinkedRowsIntegrity.Set(True);"     |

		
		
Scenario: set True value to the constant Use salary
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'        |
			| 'Use salary'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window	

Scenario: set True value to the constant Use fixed assets
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'        |
			| 'Use fixed assets'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window	

Scenario: set True value to the constant Use additional table control document
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'        |
			| 'Use additional table control document'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window		
				

Scenario: set True value to the constant Use consolidated retail sales
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'                           |
			| 'Use consolidated retail sales'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window

Scenario: set True value to the constant Use commission trading
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'                    |
			| 'Use commission trading'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window

Scenario: set True value to the constant Use object access
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'                    |
			| 'Use object access'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window

Scenario: set True value to the constant Use retail orders
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'               |
			| 'Use retail orders'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window


Scenario: set False value to the constant Use retail orders
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'               |
			| 'Use retail orders'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window

Scenario: set False value to the constant Use commission trading
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'                    |
			| 'Use commission trading'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window
		
Scenario: set True value to the constant Use accounting
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'            |
			| 'Use accounting'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window				

Scenario: set True value to the constant Use job queue for external functions
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'                                  |
			| 'Use job queue for external functions'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window	

Scenario: set True value to the constant Use lock data modification
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		Then "Functional option settings" window is opened
		And I go to line in "FunctionalOptions" table
			| 'Option'                        |
			| 'Use lock data modification'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window	

Scenario: set False value to the constant DisableLinkedRowsIntegrity
		And I execute 1C:Enterprise script at server
				| "Constants.DisableLinkedRowsIntegrity.Set(False);"     |

Scenario: set True value to the constant SaasMode
		And I execute 1C:Enterprise script at server
				| "Constants.SaasMode.Set(True);"     |

Scenario: set True value to the constant UseSimpleMode
		And I execute 1C:Enterprise script at server
				| "Constants.UseSimpleMode.Set(True);"     |


Scenario: add VAExtension
	Given I open hyperlink "e1cib/list/Catalog.Extensions"
	And I click the button named "FormCreate"
	And I select external file "C:/ForAgent/VAExtension.cfe"
	And I click "Add file" button
	And Delay 2
	And I input "VAExtension" text in "Description" field
	And I click the button named "FormWriteAndClose"
	And I close TestClient session
	And I install the "VAExtension" extension
	Given I open new TestClient session or connect the existing one

Scenario: create Workstation
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		If "List" table does not contain lines Then
			| 'Description'       |
			| 'Workstation 01'    |
			And I click the button named "FormCreate"
			And I input "Workstation 01" text in "Description" field
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Cash desk №2'    |
			And I select current line in "List" table
			And I click "Set current" button
			And I click "Save and close" button
			And I close TestClient session
			Given I open new TestClient session or connect the existing one


Scenario: auto filling Configuration metadata catalog
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I click "Refill metadata" button
		And Delay 20
		And I click "List" button
		And "List" table contains lines
		| 'Description'                      |
		| 'Additional attribute sets'        |
		| 'Additional attribute values'      |
		| 'Addresses hierarchy'              |
		| 'Bank payment'                     |
		| 'Bank receipt'                     |
		| 'Bank terms'                       |
		| 'Bundling'                         |
		| 'Business units'                   |
		| 'Cash expense'                     |
		| 'Cash payment'                     |
		| 'Cash receipt'                     |
		| 'Cash revenue'                     |
		| 'Cash statement'                   |
		| 'Cash statement statuses'          |
		| 'Cash transfer order'              |
		| 'Cash/Bank accounts'               |
		| 'Catalogs'                         |
		| 'Companies'                        |
		| 'Configuration metadata'           |
		| 'Contact info sets'                |
		| 'Countries'                        |
		| 'Credit note'                      |
		| 'Currencies'                       |
		| 'Data areas'                       |
		| 'Data base status'                 |
		| 'Data mapping items'               |
		| 'Data processors'                  |
		| 'Debit note'                       |
		| 'Documents'                        |
		| 'Equipment drivers'                |
		| 'Expense and revenue types'        |
		| 'Extensions'                       |
		| 'File storage volumes'             |
		| 'File storages info'               |
		| 'Files'                            |
		| 'Goods receipt'                    |
		| 'Hardware'                         |
		| 'Incoming payment order'           |
		| 'Integration settings'             |
		| 'Internal supply request'          |
		| 'Inventory transfer'               |
		| 'Inventory transfer order'         |
		| 'Item keys'                        |
		| 'Item segments'                    |
		| 'Item serial/lot numbers'          |
		| 'Item types'                       |
		| 'Item units'                       |
		| 'Items'                            |
		| 'Labeling'                         |
		| 'Lock data modification reasons'   |
		| 'Multi currency movement sets'     |
		| 'Objects statuses'                 |
		| 'Opening entry'                    |
		| 'Outgoing payment order'           |
		| 'Partner segments'                 |
		| 'Partner terms'                    |
		| 'Partners'                         |
		| 'Payment terminals'                |
		| 'Payment terms'                    |
		| 'Payment types'                    |
		| 'Physical count by location'       |
		| 'Physical inventory'               |
		| 'Plugins'                          |
		| 'Price keys'                       |
		| 'Price list'                       |
		| 'Price types'                      |
		| 'Print templates'                  |
		| 'Purchase invoice'                 |
		| 'Purchase order'                   |
		| 'Purchase return'                  |
		| 'Purchase return order'            |
		| 'Reconciliation statement'         |
		| 'Report options'                   |
		| 'Reports'                          |
		| 'Retail customers'                 |
		| 'Retail return receipt'            |
		| 'Retail sales receipt'             |
		| 'Sales invoice'                    |
		| 'Sales order'                      |
		| 'Sales return'                     |
		| 'Sales return order'               |
		| 'Shipment confirmation'            |
		| 'Special offer rules'              |
		| 'Special offer types'              |
		| 'Special offers'                   |
		| 'Specifications'                   |
		| 'Stock adjustment as surplus'      |
		| 'Stock adjustment as write-off'    |
		| 'Stores'                           |
		| 'Tax additional analytics'         |
		| 'Tax rates'                        |
		| 'Tax types'                        |
		| 'UI groups'                        |
		| 'Unbundling'                       |
		| 'Units of measurement'             |
		| 'User access groups'               |
		| 'User access profiles'             |
		| 'User groups'                      |
		| 'Users'                            |
		| 'Workstations'                     |

	And I close all client application windows

Scenario: create payment terminal
		Given I open hyperlink "e1cib/list/Catalog.PaymentTerminals"
		And I click the button named "FormCreate"
		And I input "Payment terminal 01" text in the field named "Description_en"
		And I click "Save and close" button

Scenario: create PaymentTypes
		Given I open hyperlink "e1cib/list/Catalog.PaymentTypes"
		And I click the button named "FormCreate"
		And I input "Cash" text in the field named "Description_en"
		And I select "Cash" exact value from "Type" drop-down list
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Card 01" text in the field named "Description_en"
		And I select "Card" exact value from "Type" drop-down list
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Card 02" text in the field named "Description_en"
		And I select "Card" exact value from "Type" drop-down list
		And I click "Save and close" button

Scenario: create Bank terms
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I click the button named "FormCreate"
		And I input "Bank term 01" text in "ENG" field
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Transit Main'    |
		And I select current line in "List" table
		And I activate "Percent" field in "PaymentTypes" table
		And I input "1,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And in the table "PaymentTypes" I click the button named "PaymentTypesAdd"
		And I click choice button of "Payment type" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 02'        |
		And I select current line in "List" table
		And I activate "Account" field in "PaymentTypes" table
		And I click choice button of "Account" attribute in "PaymentTypes" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Transit Second'    |
		And I select current line in "List" table
		And I activate "Percent" field in "PaymentTypes" table
		And I input "2,00" text in "Percent" field of "PaymentTypes" table
		And I finish line editing in "PaymentTypes" table
		And I click "Save" button
		And In this window I click command interface button "Branch bank terms"
		And I click the button named "FormCreate"
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Shop 01'        |
		And I select current line in "List" table
		And I click Select button of "Bank term" field
		Then "Bank terms" window is opened
		And I select current line in "List" table
		And I click "Save and close" button		
	


Scenario: add Plugin for document discount
		* Opening a form to add Plugin sessing
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		* Addition of Plugin sessing for calculating Tax types for Turkey (VAT)
			And I click the button named "FormCreate"
			And I select external file "$Path$/DataProcessor/DocumentDiscount.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "DocumentDiscount" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "DocumentDiscount" text in the field named "Description_en"
			And I input "DocumentDiscount_TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And I wait "Plugins (create)" window closing in 10 seconds
		* Check added processing
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "DocumentDiscount"
			Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"		
			And I go to line in "List" table
				| 'Description'          |
				| 'DocumentDiscount'     |
			And I select current line in "List" table
			And I click Open button of "Special offer type" field
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description'          |
				| 'DocumentDiscount'     |
			And I select current line in "List" table
			And I click "Save and close" button
		And I close all client application windows

Scenario: check preparation
	* Check preparation
		Try
			And the previous scenario executed successfully
		Except
			Then I stop the execution of scripts for this feature


Scenario: create Document discount2
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click the button named "FormCreate"
	And I input "Document discount 2" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Document discount 2 TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I select "Purchases and sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	And I click Select button of "Special offer type" field
	And I click the button named "FormCreate"
	And I input "Document discount 2" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Document discount 2 TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click Select button of "Plugins" field
	Then "Plugins" window is opened
	And I go to line in "List" table
		| Description                 |
		| ExternalSpecialOfferRules   |
	And I go to line in "List" table
		| Description        |
		| DocumentDiscount   |
	And I select current line in "List" table
	And I click "Save and close" button
	And I wait "Special offer type (create) *" window closing in 20 seconds
	Then "Special offer types" window is opened
	And I click the button named "FormChoose"
	And I input "12" text in "Priority" field
	And I input current date in "Period" field
	And I change checkbox "Manually"
	And I change checkbox "Manual input value"
	And I set checkbox "Launch"
	And I click "Save and close" button
	And I wait "Special offer (create) *" window closing in 20 seconds

Scenario: settings for Main Company (commission trade)
	* Main Company
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'       |
			| 'TRY'        | 'Local currency'    |
		And I select current line in "List" table
		And I move to "Comission trading" tab
		And I click Select button of "Trade agent store" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Trade agent store'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'             |
			| 'Main Company partner'    |
		And I select current line in "List" table
		And I click "Save and close" button


Scenario: settings for Company (commission trade)
	* Main Company
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'       |
			| 'TRY'        | 'Local currency'    |
		And I select current line in "List" table
		And I move to "Comission trading" tab
		And I click Select button of "Trade agent store" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Trade agent store'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'             |
			| 'Main Company partner'    |
		And I select current line in "List" table
		And I click "Save and close" button
	* Second Company
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf128cde918b4"
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'               |
			| 'Second Company partner'    |
		And I select current line in "List" table
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'       |
			| 'TRY'        | 'Local currency'    |
		And I select current line in "List" table
		And I move to "Comission trading" tab
		And I click Select button of "Trade agent store" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Trade agent store'    |
		And I select current line in "List" table
		And I move to "Currencies" tab
		And in the table "Currencies" I click the button named "CurrenciesAdd"
		And I click choice button of "Movement type" attribute in "Currencies" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Local currency'    |
		And I select current line in "List" table
		And I move to "Tax types" tab
		And I finish line editing in "Currencies" table
		If number of "CompanyTaxes" table lines is "равно" "0" Then
			And in the table "CompanyTaxes" I click the button named "CompanyTaxesAdd"
			And I activate "Tax" field in "CompanyTaxes" table
			And I click choice button of "Tax" attribute in "CompanyTaxes" table
			And I activate field named "Description" in "List" table
			And I select current line in "List" table
			And I activate "Period" field in "CompanyTaxes" table
			And I input "01.01.2022" text in "Period" field of "CompanyTaxes" table
			And I finish line editing in "CompanyTaxes" table
			And I click "Save and close" button
		And I close all client application windows
		
		

Scenario: set False value to the constant Use source of origin	
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I go to line in "FunctionalOptions" table
			| 'Option'               |
			| 'Use source of origin'    |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window
	
Scenario: set True value to the constant Use source of origin	
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I go to line in "FunctionalOptions" table
			| 'Option'               |
			| 'Use source of origin'    |
		And I set "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close current window


Scenario: check filter by transaction type in CR/BR 
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Main Company'     |
		And I select current line in "List" table
		And I select "Payment from customer" exact value from the drop-down list named "TransactionType"		
	* Check filter for partner term (transaction type)
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "ndb" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner' | 'Payer'       | 'Partner term'     |
			| 'NDB'     | 'Company NDB' | 'Partner term NDB' |
		And I select current line in "PaymentList" table
		And I click choice button of the attribute named "PaymentListAgreement" in "PaymentList" table
		And I remove checkbox named "FilterCompanyUse"
		And "List" table became equal
			| 'Description'                 | 'Type'     |
			| 'Partner term NDB'            | 'Customer' |
			| 'Partner term Second Company' | 'Customer' |
		And I close current window
	* Select transaction type Return from vendor
		And I finish line editing in "PaymentList" table
		And I select "Return from vendor" exact value from the drop-down list named "TransactionType"
		And I click the button named "Button0"
		And "PaymentList" table became equal
			| 'Partner' | 'Payer'       | 'Partner term'            |
			| 'NDB'     | 'Company NDB' | 'Partner term vendor NDB' |
	* Add second line and check partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "ndb" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner' | 'Payer'       | 'Partner term'            |
			| 'NDB'     | 'Company NDB' | 'Partner term vendor NDB' |
			| 'NDB'     | 'Company NDB' | 'Partner term vendor NDB' |
	* Select transaction type Other partner
		And I select "Other partner" exact value from the drop-down list named "TransactionType"
		And I click the button named "Button0"
		And "PaymentList" table became equal
			| 'Partner' | 'Payer'       | 'Partner term' |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "ndb" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner' | 'Payer'       | 'Partner term' |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |

Scenario: check filter by transaction type in CP/BP 
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Main Company'     |
		And I select current line in "List" table
		And I select "Payment to the vendor" exact value from the drop-down list named "TransactionType"		
	* Check filter for partner term (transaction type)
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "ndb" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner' | 'Payee'       | 'Partner term'            |
			| 'NDB'     | 'Company NDB' | 'Partner term vendor NDB' |
		And I select current line in "PaymentList" table
		And I click choice button of the attribute named "PaymentListAgreement" in "PaymentList" table
		And I remove checkbox named "FilterCompanyUse"
		And "List" table became equal
			| 'Description'                        | 'Type'   |
			| 'Partner term Second Company Vendor' | 'Vendor' |
			| 'Partner term vendor NDB'            | 'Vendor' |
		And I close current window
	* Select transaction type Return to customer
		And I finish line editing in "PaymentList" table
		And I select "Return to customer" exact value from the drop-down list named "TransactionType"
		And I click the button named "Button0"
		And "PaymentList" table became equal
			| 'Partner' | 'Payee'       | 'Partner term'     |
			| 'NDB'     | 'Company NDB' | 'Partner term NDB' |
	* Add second line and check partner term
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "ndb" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner' | 'Payee'       | 'Partner term'     |
			| 'NDB'     | 'Company NDB' | 'Partner term NDB' |
			| 'NDB'     | 'Company NDB' | 'Partner term NDB' |
	* Select transaction type Other partner
		And I select "Other partner" exact value from the drop-down list named "TransactionType"
		And I click the button named "Button0"
		And "PaymentList" table became equal
			| 'Partner' | 'Payee'       | 'Partner term' |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "ndb" by string from the drop-down list named "PaymentListPartner" in "PaymentList" table
		And "PaymentList" table became equal
			| 'Partner' | 'Payee'       | 'Partner term' |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
			| 'NDB'     | 'Company NDB' | 'NDB, Other'   |
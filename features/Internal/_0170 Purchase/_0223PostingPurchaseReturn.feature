#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase return

As a procurement manager
I want to create a Purchase return document
To track a product that returned to the vendor

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _022300 preparation
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
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number"                            |
				| "$$NumberPurchaseOrder017001$$"     |
			When create PurchaseOrder017001
	* Check or create PurchaseOrder017003
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number"                            |
				| "$$NumberPurchaseOrder017003$$"     |
			When create PurchaseOrder017003
	* Create PurchaseInvoice018001
			When create PurchaseInvoice018001 based on PurchaseOrder017001
	* Check or create PurchaseInvoice018006
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number"                              |
				| "$$NumberPurchaseInvoice018006$$"     |
			When create PurchaseInvoice018006 based on PurchaseOrder017003
	* Check or create PurchaseReturnOrder022001
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		If "List" table does not contain lines Then
				| "Number"                                  |
				| "$$NumberPurchaseReturnOrder022001$$"     |
			When create PurchaseReturnOrder022001 based on PurchaseInvoice018006 (PurchaseOrder017003)
		And I close all client application windows
	* Check or create PurchaseReturnOrder022006
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		If "List" table does not contain lines Then
				| "Number"                                  |
				| "$$NumberPurchaseReturnOrder022006$$"     |
			When create PurchaseReturnOrder022006 based on PurchaseInvoice018001

Scenario: _0223001 check preparation
	When check preparation

Scenario: _022301 create Purchase return without bases document
	* Opening a form to create Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
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
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Store'      | 'Unit'    |
			| 'Dress'      | '100,000'    | 'M/White'     | 'Store 01'   | 'pcs'     |
			| 'Dress'      | '200,000'    | 'L/Green'     | 'Store 01'   | 'pcs'     |
			| 'Trousers'   | '300,000'    | '36/Yellow'   | 'Store 01'   | 'pcs'     |
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseReturn022301$$" variable
		And I delete "$$PurchaseReturn022301$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturn022301$$"
		And I save the window as "$$PurchaseReturn022301$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberPurchaseReturn022301$$'    |
		And I close all client application windows

Scenario: _022303 check filling in Row Id info table in the PR
	* Select PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'                            |
			| '$$NumberPurchaseReturn022301$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseReturn022301$$" variable
		And I save the current field value as "$$Rov1PurchaseReturn022301$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2PurchaseReturn022301$$" variable
		And I save the current field value as "$$Rov2PurchaseReturn022301$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov3PurchaseReturn022301$$" variable
		And I save the current field value as "$$Rov3PurchaseReturn022301$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                            | 'Basis'   | 'Row ID'                         | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                         |
			| '$$Rov1PurchaseReturn022301$$'   | ''        | '$$Rov1PurchaseReturn022301$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturn022301$$'    |
			| '$$Rov2PurchaseReturn022301$$'   | ''        | '$$Rov2PurchaseReturn022301$$'   | ''            | '200,000'    | ''            | ''               | '$$Rov2PurchaseReturn022301$$'    |
			| '$$Rov3PurchaseReturn022301$$'   | ''        | '$$Rov3PurchaseReturn022301$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturn022301$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '2'   | 'Dress'   | 'L/Green'    | '200,000'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "208,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'    |
			| '4'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov4PurchaseReturn022301$$" variable
		And I save the current field value as "$$Rov4PurchaseReturn022301$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                            | 'Basis'   | 'Row ID'                         | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                         |
			| '$$Rov1PurchaseReturn022301$$'   | ''        | '$$Rov1PurchaseReturn022301$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturn022301$$'    |
			| '$$Rov2PurchaseReturn022301$$'   | ''        | '$$Rov2PurchaseReturn022301$$'   | ''            | '200,000'    | ''            | ''               | '$$Rov2PurchaseReturn022301$$'    |
			| '$$Rov3PurchaseReturn022301$$'   | ''        | '$$Rov3PurchaseReturn022301$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturn022301$$'    |
			| '$$Rov4PurchaseReturn022301$$'   | ''        | '$$Rov4PurchaseReturn022301$$'   | ''            | '208,000'    | ''            | ''               | '$$Rov4PurchaseReturn022301$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And "RowIDInfo" table does not contain lines
			| 'Key'                            | 'Basis'   | 'Row ID'                         | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                         |
			| '$$Rov2PurchaseReturn022301$$'   | ''        | '$$Rov2PurchaseReturn022301$$'   | ''            | '208,000'    | ''            | ''               | '$$Rov2PurchaseReturn022301$$'    |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '4'   | 'Dress'   | 'L/Green'    | '208,000'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                            | 'Basis'   | 'Row ID'                         | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                         |
			| '$$Rov1PurchaseReturn022301$$'   | ''        | '$$Rov1PurchaseReturn022301$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturn022301$$'    |
			| '$$Rov2PurchaseReturn022301$$'   | ''        | '$$Rov2PurchaseReturn022301$$'   | ''            | '200,000'    | ''            | ''               | '$$Rov2PurchaseReturn022301$$'    |
			| '$$Rov3PurchaseReturn022301$$'   | ''        | '$$Rov3PurchaseReturn022301$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturn022301$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '2'   | 'Dress'   | 'L/Green'    | '200,000'     |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                            | 'Basis'   | 'Row ID'                         | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                         |
			| '$$Rov1PurchaseReturn022301$$'   | ''        | '$$Rov1PurchaseReturn022301$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturn022301$$'    |
			| '$$Rov2PurchaseReturn022301$$'   | ''        | '$$Rov2PurchaseReturn022301$$'   | ''            | '7,000'      | ''            | ''               | '$$Rov2PurchaseReturn022301$$'    |
			| '$$Rov3PurchaseReturn022301$$'   | ''        | '$$Rov3PurchaseReturn022301$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturn022301$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '2'   | 'Dress'   | 'L/Green'    | '7,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
		
	
Scenario: _022304 copy PR and check filling in Row Id info table
	* Copy PO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number'                            |
			| '$$NumberPurchaseReturn022301$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Profit loss center'   | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Use shipment confirmation'   | 'Additional analytic'   | 'Store'      | 'Expense type'   | 'Return reason'   | 'Net amount'   | 'Purchase invoice'   | 'Purchase return order'    |
			| '1'   | ''                     | 'Dress'      | 'M/White'     | 'No'                   | ''                     | '100,000'    | 'pcs'    | '3 050,85'     | '200,00'   | '18%'   | ''                | '20 000,00'      | 'No'                          | ''                      | 'Store 01'   | ''               | ''                | '16 949,15'    | ''                   | ''                         |
			| '2'   | ''                     | 'Dress'      | 'L/Green'     | 'No'                   | ''                     | '200,000'    | 'pcs'    | '6 406,78'     | '210,00'   | '18%'   | ''                | '42 000,00'      | 'No'                          | ''                      | 'Store 01'   | ''               | ''                | '35 593,22'    | ''                   | ''                         |
			| '3'   | ''                     | 'Trousers'   | '36/Yellow'   | 'No'                   | ''                     | '300,000'    | 'pcs'    | '11 440,68'    | '250,00'   | '18%'   | ''                | '75 000,00'      | 'No'                          | ''                      | 'Store 01'   | ''               | ''                | '63 559,32'    | ''                   | ''                         |
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'       |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200' | '23 454,40'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '137 000'      |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '137 000'      |
		And I close current window		
		Then the form attribute named "Branch" became equal to ""
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post PR and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                            | 'Basis'   | 'Row ID'                         | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                         |
			| '$$Rov1PurchaseReturn022301$$'   | ''        | '$$Rov1PurchaseReturn022301$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturn022301$$'    |
			| '$$Rov2PurchaseReturn022301$$'   | ''        | '$$Rov2PurchaseReturn022301$$'   | ''            | '200,000'    | ''            | ''               | '$$Rov2PurchaseReturn022301$$'    |
			| '$$Rov3PurchaseReturn022301$$'   | ''        | '$$Rov3PurchaseReturn022301$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturn022301$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows





Scenario: _022305 create document Purchase return without Purchase return order
	When create PurchaseReturn022314
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number'                           |
		| '$$NumberPurchaseReturn022314$$'   |
	And I select current line in "List" table
	And "ItemList" table contains lines
		| 'Purchase return order'  | 'Item'   | 'Item key'  | 'Purchase invoice'           | 'Unit'  | 'Quantity'   |
		| ''                       | 'Dress'  | 'L/Green'   | '$$PurchaseInvoice018006$$'  | 'pcs'   | '498,000'    |
	And I activate "Quantity" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "10,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And "List" table contains lines
			| 'Number'                            |
			| '$$NumberPurchaseReturn022314$$'    |
		And I close all client application windows





Scenario: _022310 create Purchase return based on Purchase return order
	And I close all client application windows
	* Save Purchase return order Row id
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'                                 |
			| '$$NumberPurchaseReturnOrder022006$$'    |
		And I select current line in "List" table
		And I click "Show row key" button	
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
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
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'            |
				| 'Vendor Ferron, TRY'     |
			And I select current line in "List" table
		* Select items from basis documents
			And I click the button named "AddBasisDocuments"
			And "BasisesTree" table contains lines
				| 'Row presentation'                 | 'Use'    | 'Quantity'    | 'Unit'    | 'Price'     | 'Currency'     |
				| '$$PurchaseReturnOrder022006$$'    | 'No'     | ''            | ''        | ''          | ''             |
				| 'Trousers (36/Yellow)'             | 'No'     | '3,000'       | 'pcs'     | '250,00'    | 'TRY'          |
			And I go to line in "BasisesTree" table
				| 'Quantity'    | 'Row presentation'        | 'Unit'    | 'Use'     |
				| '3,000'       | 'Trousers (36/Yellow)'    | 'pcs'     | 'No'      |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And I click "Show row key" button
			And in the table "ItemList" I click "Edit quantity in base unit" button
			And I go to line in "ItemList" table
				| '#'     |
				| '1'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1PurchaseReturn22310$$" variable	
			And I save the current field value as "$$Rov1PurchaseReturn22310$$"			
		* Check Item tab and RowID tab
			And "ItemList" table contains lines
				| 'Store'       | 'Purchase invoice'             | '#'    | 'Stock quantity'    | 'Item'        | 'Item key'     | 'Quantity'    | 'Unit'    | 'Purchase return order'             |
				| 'Store 01'    | '$$PurchaseInvoice018001$$'    | '1'    | '3,000'             | 'Trousers'    | '36/Yellow'    | '3,000'       | 'pcs'     | '$$PurchaseReturnOrder022006$$'     |
			And "RowIDInfo" table contains lines
				| '#'    | 'Key'                            | 'Basis'                            | 'Row ID'    | 'Next step'    | 'Quantity'    | 'Basis key'                            | 'Current step'    | 'Row ref'     |
				| '1'    | '$$Rov1PurchaseReturn22310$$'    | '$$PurchaseReturnOrder022006$$'    | '*'         | ''             | '3,000'       | '$$Rov1PurchaseReturnOrder022310$$'    | 'PR'              | '*'           |
			* Set checkbox Use SC and check RowID tab
				And I move to "Item list" tab
				And I activate "Use shipment confirmation" field in "ItemList" table
				And I set "Use shipment confirmation" checkbox in "ItemList" table
				And I finish line editing in "ItemList" table
				And I click "Post" button
				And "RowIDInfo" table contains lines
					| '#'     | 'Key'                             | 'Basis'                             | 'Row ID'     | 'Next step'     | 'Quantity'     | 'Basis key'                             | 'Current step'     | 'Row ref'      |
					| '1'     | '$$Rov1PurchaseReturn22310$$'     | '$$PurchaseReturnOrder022006$$'     | '*'          | 'SC'            | '3,000'        | '$$Rov1PurchaseReturnOrder022310$$'     | 'PR'               | '*'            |
				And I click the button named "FormUndoPosting"	
		And I close all client application windows
	* Create Purchase return based on Purchase return order(Create button)
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'                                 |
			| '$$NumberPurchaseReturnOrder022006$$'    |
		And I click the button named "FormDocumentPurchaseReturnGenerate"
		And I click "Ok" button	
		And Delay 1
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		* Change quantity
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table			
		And I click "Show row key" button	
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Store'      | 'Purchase invoice'            | '#'   | 'Stock quantity'   | 'Item'       | 'Item key'    | 'Quantity'   | 'Unit'   | 'Purchase return order'            |
			| 'Store 01'   | '$$PurchaseInvoice018001$$'   | '1'   | '2,000'            | 'Trousers'   | '36/Yellow'   | '2,000'      | 'pcs'    | '$$PurchaseReturnOrder022006$$'    |
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseReturn22310$$" variable
		And I save the current field value as "$$Rov1PurchaseReturn22310$$"	
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                           | 'Basis'                           | 'Row ID'   | 'Next step'   | 'Quantity'   | 'Basis key'                           | 'Current step'   | 'Row ref'    |
			| '1'   | '$$Rov1PurchaseReturn22310$$'   | '$$PurchaseReturnOrder022006$$'   | '*'        | ''            | '2,000'      | '$$Rov1PurchaseReturnOrder022310$$'   | 'PR'             | '*'          |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseReturn22310$$" variable
		And I delete "$$PurchaseReturn22310$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturn22310$$"
		And I save the window as "$$PurchaseReturn22310$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And "List" table contains lines
			| 'Number'                           |
			| '$$NumberPurchaseReturn22310$$'    |
		And I close all client application windows


Scenario: _022335 check totals in the document Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Select Purchase Return
		And I go to line in "List" table
		| 'Number'                           |
		| '$$NumberPurchaseReturn022301$$'   |
		And I select current line in "List" table
	* Check totals in the document Purchase return
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"



Scenario: _300509 check connection to PurchaseReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Form report Related documents
		And I go to line in "List" table
		| 'Number'                           |
		| '$$NumberPurchaseReturn022301$$'   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows


Scenario: _300512 check Use GR filling from store when create PR based on PI
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice018006$$'    |
		And I select current line in "List" table
	* Create PR and check Use SC filling
		And I click "Purchase return" button
		And I click "Ok" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Use shipment confirmation'    |
			| 'Dress'   | 'L/Green'    | 'Yes'                          |
		And I close all client application windows
		
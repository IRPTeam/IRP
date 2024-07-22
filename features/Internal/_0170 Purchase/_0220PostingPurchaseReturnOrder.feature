#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase return order

As a procurement manager
I want to create a Purchase return order document
To track a product that needs to be returned to the vendor

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _022000 preparation
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
		If "List" table does not contain lines Then
				| "Number"                            |
				| "$$NumberPurchaseOrder017003$$"     |
			When create PurchaseOrder017003
	* Check or create PurchaseInvoice018001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number"                              |
				| "$$NumberPurchaseInvoice018001$$"     |
			When create PurchaseInvoice018001 based on PurchaseOrder017001
	* Check or create PurchaseInvoice018006
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number"                              |
				| "$$NumberPurchaseInvoice018006$$"     |
			When create PurchaseInvoice018006 based on PurchaseOrder017003
		
Scenario: _0220001 check preparation
	When check preparation	
	


Scenario: _022001 create document Purchase return order, store use Shipment confirmation based on Purchase invoice + check status
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
		Then the form attribute named "Store" became equal to "Store 02"
		And I select "Approved" exact value from "Status" drop-down list
	And I select "Wait" exact value from "Status" drop-down list
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
	And I close current window
	And I close current window
	* Check for no movements in the registers
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1001T_Purchases"
		And "List" table does not contain lines
			| 'Quantity'   | 'Recorder'                        | 'Line number'   | 'Invoice'                     | 'Item key'    |
			| '2,000'      | '$$PurchaseReturnOrder022001$$'   | '1'             | '$$PurchaseInvoice018006$$'   | 'L/Green'     |
		And I close current window
	* Set Approved status
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'                                 |
			| '$$NumberPurchaseReturnOrder022001$$'    |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                          | 'Status'      |
			| '$$PurchaseReturnOrder022001$$'   | 'Wait'        |
			| '$$PurchaseReturnOrder022001$$'   | 'Approved'    |
		And I close current window
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And "List" table contains lines
			| 'Number'                                 |
			| '$$NumberPurchaseReturnOrder022001$$'    |
		And I close all client application windows



Scenario: _022009 create Purchase return order without bases document
	* Opening a form to create Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
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
			| 'M/White'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
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
		And I delete "$$NumberPurchaseReturnOrder022009$$" variable
		And I delete "$$PurchaseReturnOrder022009$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022009$$"
		And I save the window as "$$PurchaseReturnOrder022009$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And "List" table contains lines
			| 'Number'                                 |
			| '$$NumberPurchaseReturnOrder022009$$'    |
		And I close all client application windows

Scenario: _022010 check filling in Row Id info table in the PRO
	* Select PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'                                 |
			| '$$NumberPurchaseReturnOrder022009$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1PurchaseReturnOrder022009$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2PurchaseReturnOrder022009$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3PurchaseReturnOrder022009$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                                 | 'Basis'   | 'Row ID'                              | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                              |
			| '$$Rov1PurchaseReturnOrder022009$$'   | ''        | '$$Rov1PurchaseReturnOrder022009$$'   | 'PR'          | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturnOrder022009$$'    |
			| '$$Rov2PurchaseReturnOrder022009$$'   | ''        | '$$Rov2PurchaseReturnOrder022009$$'   | 'PR'          | '200,000'    | ''            | ''               | '$$Rov2PurchaseReturnOrder022009$$'    |
			| '$$Rov3PurchaseReturnOrder022009$$'   | ''        | '$$Rov3PurchaseReturnOrder022009$$'   | 'PR'          | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturnOrder022009$$'    |
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
		And I save the current field value as "$$Rov4PurchaseReturnOrder022009$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                                 | 'Basis'   | 'Row ID'                              | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                              |
			| '$$Rov1PurchaseReturnOrder022009$$'   | ''        | '$$Rov1PurchaseReturnOrder022009$$'   | 'PR'          | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturnOrder022009$$'    |
			| '$$Rov2PurchaseReturnOrder022009$$'   | ''        | '$$Rov2PurchaseReturnOrder022009$$'   | 'PR'          | '200,000'    | ''            | ''               | '$$Rov2PurchaseReturnOrder022009$$'    |
			| '$$Rov3PurchaseReturnOrder022009$$'   | ''        | '$$Rov3PurchaseReturnOrder022009$$'   | 'PR'          | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturnOrder022009$$'    |
			| '$$Rov4PurchaseReturnOrder022009$$'   | ''        | '$$Rov4PurchaseReturnOrder022009$$'   | 'PR'          | '208,000'    | ''            | ''               | '$$Rov4PurchaseReturnOrder022009$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And "RowIDInfo" table does not contain lines
			| 'Key'                                 | 'Basis'   | 'Row ID'                              | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                              |
			| '$$Rov2PurchaseReturnOrder022009$$'   | ''        | '$$Rov2PurchaseReturnOrder022009$$'   | ''            | '208,000'    | ''            | ''               | '$$Rov2PurchaseReturnOrder022009$$'    |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '4'   | 'Dress'   | 'L/Green'    | '208,000'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                                 | 'Basis'   | 'Row ID'                              | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                              |
			| '$$Rov1PurchaseReturnOrder022009$$'   | ''        | '$$Rov1PurchaseReturnOrder022009$$'   | 'PR'          | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturnOrder022009$$'    |
			| '$$Rov2PurchaseReturnOrder022009$$'   | ''        | '$$Rov2PurchaseReturnOrder022009$$'   | 'PR'          | '200,000'    | ''            | ''               | '$$Rov2PurchaseReturnOrder022009$$'    |
			| '$$Rov3PurchaseReturnOrder022009$$'   | ''        | '$$Rov3PurchaseReturnOrder022009$$'   | 'PR'          | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturnOrder022009$$'    |
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
			| 'Key'                                 | 'Basis'   | 'Row ID'                              | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                              |
			| '$$Rov1PurchaseReturnOrder022009$$'   | ''        | '$$Rov1PurchaseReturnOrder022009$$'   | 'PR'          | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturnOrder022009$$'    |
			| '$$Rov2PurchaseReturnOrder022009$$'   | ''        | '$$Rov2PurchaseReturnOrder022009$$'   | 'PR'          | '7,000'      | ''            | ''               | '$$Rov2PurchaseReturnOrder022009$$'    |
			| '$$Rov3PurchaseReturnOrder022009$$'   | ''        | '$$Rov3PurchaseReturnOrder022009$$'   | 'PR'          | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturnOrder022009$$'    |
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
		
	
Scenario: _022011 copy PRO and check filling in Row Id info table
	* Copy PRO
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number'                                 |
			| '$$NumberPurchaseReturnOrder022009$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Profit loss center'   | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Expense type'   | 'Net amount'   | 'Purchase invoice'    |
			| '1'   | ''                     | 'Dress'      | 'M/White'     | 'No'                   | '100,000'    | 'pcs'    | '3 050,85'     | '200,00'   | '18%'   | ''                | '20 000,00'      | ''                      | 'Store 01'   | ''               | '16 949,15'    | ''                    |
			| '2'   | ''                     | 'Dress'      | 'L/Green'     | 'No'                   | '200,000'    | 'pcs'    | '6 406,78'     | '210,00'   | '18%'   | ''                | '42 000,00'      | ''                      | 'Store 01'   | ''               | '35 593,22'    | ''                    |
			| '3'   | ''                     | 'Trousers'   | '36/Yellow'   | 'No'                   | '300,000'    | 'pcs'    | '11 440,68'    | '250,00'   | '18%'   | ''                | '75 000,00'      | ''                      | 'Store 01'   | ''               | '63 559,32'    | ''                    |
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'       |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200' | '23 454,40'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '137 000'      |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '137 000'      |
		And I close current window		
		Then the form attribute named "Branch" became equal to ""
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post PRO and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                                 | 'Basis'   | 'Row ID'                              | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                              |
			| '$$Rov1PurchaseReturnOrder022009$$'   | ''        | '$$Rov1PurchaseReturnOrder022009$$'   | 'PR'          | '100,000'    | ''            | ''               | '$$Rov1PurchaseReturnOrder022009$$'    |
			| '$$Rov2PurchaseReturnOrder022009$$'   | ''        | '$$Rov2PurchaseReturnOrder022009$$'   | 'PR'          | '200,000'    | ''            | ''               | '$$Rov2PurchaseReturnOrder022009$$'    |
			| '$$Rov3PurchaseReturnOrder022009$$'   | ''        | '$$Rov3PurchaseReturnOrder022009$$'   | 'PR'          | '300,000'    | ''            | ''               | '$$Rov3PurchaseReturnOrder022009$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows



Scenario: _022015 create PRO using form link/unlink
	* Open PRO form
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table	
	* Select items from basis documents
		And I click the button named "AddBasisDocuments"		
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '100,00'   | '5,000'      | 'Dress (S/Yellow)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'      | 'Quantity'   | 'Row presentation'   | 'Unit'             | 'Use'    |
			| 'TRY'        | '2 400,00'   | '5,000'      | 'Boots (36/18SD)'    | 'Boots (12 pcs)'   | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
		| '#'  | 'Basis'                      | 'Next step'  | 'Quantity'  | 'Current step'   |
		| '1'  | '$$PurchaseInvoice018001$$'  | ''           | '5,000'     | 'PRO&PR'         |
		| '2'  | '$$PurchaseInvoice018001$$'  | ''           | '60,000'    | 'PRO&PR'         |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Unlink line
		And I click the button named "LinkUnlinkBasisDocuments"
		Then "Link / unlink document row" window is opened
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'              |
			| '2'   | '5,000'      | 'Boots (36/18SD)'    | 'Store 02'   | 'Boots (12 pcs)'    |
		And I set checkbox "Linked documents"
		And I click "Unlink" button
		And I click "Ok" button
		And I click "Post" button	
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                       | 'Next step'   | 'Quantity'   | 'Current step'    |
			| '1'   | '$$PurchaseInvoice018001$$'   | 'PR'          | '5,000'      | 'PRO&PR'          |
			| '2'   | ''                            | 'PR'          | '60,000'     | ''                |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Purchase invoice'             |
			| 'Boots'   | '36/18SD'    | ''                             |
			| 'Dress'   | 'S/Yellow'   | '$$PurchaseInvoice018001$$'    |
	* Link line
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'              |
			| '2'   | '5,000'      | 'Boots (36/18SD)'    | 'Store 02'   | 'Boots (12 pcs)'    |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'      | 'Quantity'   | 'Row presentation'   | 'Unit'              |
			| 'TRY'        | '2 400,00'   | '5,000'      | 'Boots (36/18SD)'    | 'Boots (12 pcs)'    |
		And I click "Link" button
		And I click "Ok" button
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                       | 'Next step'   | 'Quantity'   | 'Current step'    |
			| '1'   | '$$PurchaseInvoice018001$$'   | ''            | '5,000'      | 'PRO&PR'          |
			| '2'   | '$$PurchaseInvoice018001$$'   | ''            | '60,000'     | 'PRO&PR'          |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Purchase invoice'             |
			| 'Boots'   | '36/18SD'    | '$$PurchaseInvoice018001$$'    |
			| 'Dress'   | 'S/Yellow'   | '$$PurchaseInvoice018001$$'    |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Boots'   | '36/18SD'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'      | 'Quantity'   | 'Row presentation'   | 'Unit'             | 'Use'    |
			| 'TRY'        | '2 400,00'   | '5,000'      | 'Boots (36/18SD)'    | 'Boots (12 pcs)'   | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Purchase invoice'             |
			| 'Boots'   | '36/18SD'    | '$$PurchaseInvoice018001$$'    |
			| 'Dress'   | 'S/Yellow'   | '$$PurchaseInvoice018001$$'    |
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Store'       |
			| 'Dress'   | 'S/Yellow'   | '5,000'      | 'Store 02'    |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I select current line in "List" table
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                       | 'Next step'   | 'Quantity'   | 'Current step'    |
			| '1'   | '$$PurchaseInvoice018001$$'   | 'PR'          | '40,000'     | 'PRO&PR'          |
			| '2'   | '$$PurchaseInvoice018001$$'   | 'PR'          | '60,000'     | 'PRO&PR'          |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I click the button named "FormUndoPosting"	
		And I close all client application windows

Scenario: _022016 check totals in the document Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Select PurchaseReturnOrder
		And I go to line in "List" table
		| 'Number'                                |
		| '$$NumberPurchaseReturnOrder022009$$'   |
		And I select current line in "List" table
	* Check totals in the document Purchase return order
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"




Scenario: _300508 check connection to PurchaseReturnOrder report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number                                |
		| $$NumberPurchaseReturnOrder022001$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows



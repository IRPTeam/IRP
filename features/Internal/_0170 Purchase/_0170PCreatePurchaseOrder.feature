#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase order

As a procurement manager
I want to create a Purchase order document
For tracking an item that has been ordered from a vendor

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _017000 preparation
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
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create information register Taxes records (VAT)


Scenario: _0170001 check preparation
	When check preparation	

Scenario: _017001 create document Purchase order
	When create PurchaseOrder017001

Scenario: _017002 check filling in Row Id info table in the PO
	* Select PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder017001$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1PurchaseOrder017001$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2PurchaseOrder017001$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3PurchaseOrder017001$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                           | 'Basis'   | 'Row ID'                        | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                        |
			| '$$Rov1PurchaseOrder017001$$'   | ''        | '$$Rov1PurchaseOrder017001$$'   | 'PI&GR'       | '100,000'    | ''            | ''               | '$$Rov1PurchaseOrder017001$$'    |
			| '$$Rov2PurchaseOrder017001$$'   | ''        | '$$Rov2PurchaseOrder017001$$'   | 'PI&GR'       | '200,000'    | ''            | ''               | '$$Rov2PurchaseOrder017001$$'    |
			| '$$Rov3PurchaseOrder017001$$'   | ''        | '$$Rov3PurchaseOrder017001$$'   | 'PI&GR'       | '300,000'    | ''            | ''               | '$$Rov3PurchaseOrder017001$$'    |
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
		And I save the current field value as "$$Rov4PurchaseOrder017001$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                           | 'Basis'   | 'Row ID'                        | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                        |
			| '$$Rov1PurchaseOrder017001$$'   | ''        | '$$Rov1PurchaseOrder017001$$'   | 'PI&GR'       | '100,000'    | ''            | ''               | '$$Rov1PurchaseOrder017001$$'    |
			| '$$Rov2PurchaseOrder017001$$'   | ''        | '$$Rov2PurchaseOrder017001$$'   | 'PI&GR'       | '200,000'    | ''            | ''               | '$$Rov2PurchaseOrder017001$$'    |
			| '$$Rov3PurchaseOrder017001$$'   | ''        | '$$Rov3PurchaseOrder017001$$'   | 'PI&GR'       | '300,000'    | ''            | ''               | '$$Rov3PurchaseOrder017001$$'    |
			| '$$Rov4PurchaseOrder017001$$'   | ''        | '$$Rov4PurchaseOrder017001$$'   | 'PI&GR'       | '208,000'    | ''            | ''               | '$$Rov4PurchaseOrder017001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And "RowIDInfo" table does not contain lines
			| 'Key'                           | 'Basis'   | 'Row ID'                        | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                        |
			| '$$Rov2PurchaseOrder017001$$'   | ''        | '$$Rov2PurchaseOrder017001$$'   | 'PI&GR'       | '208,000'    | ''            | ''               | '$$Rov2PurchaseOrder017001$$'    |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '4'   | 'Dress'   | 'L/Green'    | '208,000'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                           | 'Basis'   | 'Row ID'                        | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                        |
			| '$$Rov1PurchaseOrder017001$$'   | ''        | '$$Rov1PurchaseOrder017001$$'   | 'PI&GR'       | '100,000'    | ''            | ''               | '$$Rov1PurchaseOrder017001$$'    |
			| '$$Rov2PurchaseOrder017001$$'   | ''        | '$$Rov2PurchaseOrder017001$$'   | 'PI&GR'       | '200,000'    | ''            | ''               | '$$Rov2PurchaseOrder017001$$'    |
			| '$$Rov3PurchaseOrder017001$$'   | ''        | '$$Rov3PurchaseOrder017001$$'   | 'PI&GR'       | '300,000'    | ''            | ''               | '$$Rov3PurchaseOrder017001$$'    |
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
			| 'Key'                           | 'Basis'   | 'Row ID'                        | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                        |
			| '$$Rov1PurchaseOrder017001$$'   | ''        | '$$Rov1PurchaseOrder017001$$'   | 'PI&GR'       | '100,000'    | ''            | ''               | '$$Rov1PurchaseOrder017001$$'    |
			| '$$Rov2PurchaseOrder017001$$'   | ''        | '$$Rov2PurchaseOrder017001$$'   | 'PI&GR'       | '7,000'      | ''            | ''               | '$$Rov2PurchaseOrder017001$$'    |
			| '$$Rov3PurchaseOrder017001$$'   | ''        | '$$Rov3PurchaseOrder017001$$'   | 'PI&GR'       | '300,000'    | ''            | ''               | '$$Rov3PurchaseOrder017001$$'    |
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
		
	
Scenario: _017003 copy PO and check filling in Row Id info table
	* Copy PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder017001$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
		Then "Update item list info" window is opened
		And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button	
	* Check copy info
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Comment" became equal to "Click to enter comment"
		Then the form attribute named "Status" became equal to "Approved"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Profit loss center'   | 'Price type'                | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Tax amount'   | 'Quantity'   | 'Unit'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Internal supply request'   | 'Store'      | 'Expense type'   | 'Detail'   | 'Sales order'   | 'Cancel'   | 'Purchase basis'   | 'Cancel reason'    |
			| '1'   | ''                     | 'en description is empty'   | 'Dress'      | 'M/White'     | 'No'                   | '3 050,85'     | '100,000'    | 'pcs'    | '200,00'   | '18%'   | ''                | '16 949,15'    | '20 000,00'      | ''                          | 'Store 01'   | ''               | ''         | ''              | 'No'       | ''                 | ''                 |
			| '2'   | ''                     | 'en description is empty'   | 'Dress'      | 'L/Green'     | 'No'                   | '6 406,78'     | '200,000'    | 'pcs'    | '210,00'   | '18%'   | ''                | '35 593,22'    | '42 000,00'      | ''                          | 'Store 01'   | ''               | ''         | ''              | 'No'       | ''                 | ''                 |
			| '3'   | ''                     | 'en description is empty'   | 'Trousers'   | '36/Yellow'   | 'No'                   | '11 440,68'    | '300,000'    | 'pcs'    | '250,00'   | '18%'   | ''                | '63 559,32'    | '75 000,00'      | ''                          | 'Store 01'   | ''               | ''         | ''              | 'No'       | ''                 | ''                 |
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
		Then the form attribute named "UseItemsReceiptScheduling" became equal to "No"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Post PO and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                           | 'Basis'   | 'Row ID'                        | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                        |
			| '$$Rov1PurchaseOrder017001$$'   | ''        | '$$Rov1PurchaseOrder017001$$'   | 'PI&GR'       | '100,000'    | ''            | ''               | '$$Rov1PurchaseOrder017001$$'    |
			| '$$Rov2PurchaseOrder017001$$'   | ''        | '$$Rov2PurchaseOrder017001$$'   | 'PI&GR'       | '200,000'    | ''            | ''               | '$$Rov2PurchaseOrder017001$$'    |
			| '$$Rov3PurchaseOrder017001$$'   | ''        | '$$Rov3PurchaseOrder017001$$'   | 'PI&GR'       | '300,000'    | ''            | ''               | '$$Rov3PurchaseOrder017001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows


Scenario: _017005 check movements by status and status history of a Purchase Order document
	And I close all client application windows
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Company" field
		And I go to line in "List" table
		| Description    |
		| Main Company   |
		And I select current line in "List" table
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
		Then "Stores" window is opened
		And I select current line in "List" table
	* Check the default status "Wait"
		Then the form attribute named "Status" became equal to "Wait"
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
		And I go to line in "List" table
			| 'Item key'    |
			| 'L/Green'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
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
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Unit'    |
			| '2'   | 'Dress'   | 'L/Green'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I input "210,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'       | 'Item key'    | 'Unit'    |
			| '3'   | 'Trousers'   | '36/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "30,000" text in "Quantity" field of "ItemList" table
		And I input "210,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder017005$$" variable
		And I delete "$$PurchaseOrder017005$$" variable
		And I delete "$$DatePurchaseOrderWait017005$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder017005$$"
		And I save the window as "$$PurchaseOrder017005$$"
		And I save "{Left(CurrentDate(), 16)}" in "$$DatePurchaseOrderWait017005$$" variable
		And I close current window
	* Check the absence of movements Purchase Order N101 by register PurchaseOrders
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
		And "List" table does not contain lines
			| 'Recorder'                  | 'Order'                      |
			| '$$PurchaseOrder017005$$'   | '$$PurchaseOrder017005$$'    |
		And I close all client application windows
	* Setting the status by Purchase Order №101 'Approved'
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder017005$$'    |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		And I click the hyperlink named "DecorationStatusHistory"
		And "List" table contains lines
			| 'Object'                    | 'Status'     | 'Period'                              |
			| '$$PurchaseOrder017005$$'   | 'Wait'       | '$$DatePurchaseOrderWait017005$$*'    |
			| '$$PurchaseOrder017005$$'   | 'Approved'   | '*'                                   |
		And "List" table does not contain lines
			| 'Object'                    | 'Status'     | 'Period'                              |
			| '$$PurchaseOrder017005$$'   | 'Approved'   | '$$DatePurchaseOrderWait017005$$*'    |
		And I close current window
		And I click the button named "FormPostAndClose"
		And I close current window
	* Check document movements after the status is set to Approved
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
		And "List" table contains lines
			| 'Recorder'                  | 'Order'                      |
			| '$$PurchaseOrder017005$$'   | '$$PurchaseOrder017005$$'    |
		And I close current window
	* Check for cancelled movements when the Approved status is changed to Wait
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder017005$$'    |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Wait" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		And I click the hyperlink named "DecorationStatusHistory"
		And "List" table contains lines
			| 'Object'                    | 'Status'      |
			| '$$PurchaseOrder017005$$'   | 'Wait'        |
			| '$$PurchaseOrder017005$$'   | 'Approved'    |
			| '$$PurchaseOrder017005$$'   | 'Wait'        |
		And I close current window
		And I click the button named "FormPostAndClose"
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
		And "List" table does not contain lines
			| 'Recorder'                  | 'Order'                      |
			| '$$PurchaseOrder017005$$'   | '$$PurchaseOrder017005$$'    |
		And I close current window

Scenario: _017006 create Purchase order based on Internal supply request
	* Add items from basis documents
		* Open form for create PO
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'            |
				| 'Vendor Ferron, TRY'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Select items from basis documents
			And I click the button named "AddBasisDocuments"
			And I go to line in "BasisesTree" table
				| 'Quantity'    | 'Row presentation'    | 'Unit'    | 'Use'     |
				| '50,000'      | 'Dress (XS/Blue)'     | 'pcs'     | 'No'      |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I go to line in "BasisesTree" table
				| 'Quantity'    | 'Row presentation'    | 'Unit'    | 'Use'     |
				| '10,000'      | 'Dress (S/Yellow)'    | 'pcs'     | 'No'      |
			And I change "Use" checkbox in "BasisesTree" table
			And I click "Ok" button
			And I click "Show row key" button
			And I click "Post" button							
		* Check Item tab and RowID tab
			And in the table "ItemList" I click "Edit quantity in base unit" button
			And "ItemList" table contains lines
				| 'Store'       | 'Internal supply request'                                  | 'Stock quantity'    | 'Profit loss center'    | 'Price type'           | 'Item'     | 'Item key'    | 'Dont calculate row'    | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Price'    | 'VAT'    | 'Offers amount'    | 'Net amount'    | 'Total amount'    | 'Expense type'    | 'Detail'    | 'Sales order'    | 'Cancel'    | 'Purchase basis'    | 'Delivery date'    | 'Cancel reason'     |
				| 'Store 02'    | 'Internal supply request 117 dated 12.02.2021 14:39:38'    | '10,000'            | ''                      | 'Vendor price, TRY'    | 'Dress'    | 'S/Yellow'    | 'No'                    | '10,000'      | 'pcs'     | ''              | ''         | '18%'    | ''                 | ''              | ''                | ''                | ''          | ''               | 'No'        | ''                  | ''                 | ''                  |
				| 'Store 02'    | 'Internal supply request 117 dated 12.02.2021 14:39:38'    | '50,000'            | ''                      | 'Vendor price, TRY'    | 'Dress'    | 'XS/Blue'     | 'No'                    | '50,000'      | 'pcs'     | ''              | ''         | '18%'    | ''                 | ''              | ''                | ''                | ''          | ''               | 'No'        | ''                  | ''                 | ''                  |
			And "RowIDInfo" table contains lines
				| 'Basis'                                                    | 'Next step'    | 'Quantity'    | 'Current step'     |
				| 'Internal supply request 117 dated 12.02.2021 14:39:38'    | 'PI&GR'        | '10,000'      | 'ITO&PO&PI'        |
				| 'Internal supply request 117 dated 12.02.2021 14:39:38'    | 'PI&GR'        | '50,000'      | 'ITO&PO&PI'        |
			Then the number of "RowIDInfo" table lines is "равно" "2"		
		And I close all client application windows
	* Create PO based on ISR (Create button)
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1InternalSupplyRequestr017006$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2InternalSupplyRequestr017006$$"
		And I click the button named "FormDocumentPurchaseOrderGenerate"
		And I click "Ok" button	
		And Delay 1
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And I click "Show row key" button	
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Store'      | 'Internal supply request'                                 | 'Stock quantity'   | 'Profit loss center'   | 'Price type'   | 'Item'    | 'Item key'   | 'Dont calculate row'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'   | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Expense type'   | 'Detail'   | 'Sales order'   | 'Cancel'   | 'Purchase basis'   | 'Delivery date'   | 'Cancel reason'    |
			| 'Store 02'   | 'Internal supply request 117 dated 12.02.2021 14:39:38'   | '10,000'           | ''                     | ''             | 'Dress'   | 'S/Yellow'   | 'No'                   | '10,000'     | 'pcs'    | ''             | ''        | '18%'   | ''                | ''             | ''               | ''               | ''         | ''              | 'No'       | ''                 | ''                | ''                 |
			| 'Store 02'   | 'Internal supply request 117 dated 12.02.2021 14:39:38'   | '50,000'           | ''                     | ''             | 'Dress'   | 'XS/Blue'    | 'No'                   | '50,000'     | 'pcs'    | ''             | ''        | '18%'   | ''                | ''             | ''               | ''               | ''         | ''              | 'No'       | ''                 | ''                | ''                 |
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseOrder017006$$" variable
		And I save the current field value as "$$Rov1PurchaseOrder017006$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2PurchaseOrder017006$$" variable
		And I save the current field value as "$$Rov2PurchaseOrder017006$$"
		And I click "Save" button	
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                         | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Quantity' | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseOrder017006$$' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '$$Rov1InternalSupplyRequestr017006$$' | ''          | '10,000'   | '$$Rov1InternalSupplyRequestr017006$$' | 'ITO&PO&PI'    | '$$Rov1InternalSupplyRequestr017006$$' |
			| '2' | '$$Rov2PurchaseOrder017006$$' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '$$Rov2InternalSupplyRequestr017006$$' | ''          | '50,000'   | '$$Rov2InternalSupplyRequestr017006$$' | 'ITO&PO&PI'    | '$$Rov2InternalSupplyRequestr017006$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		* Filling in the main details of the document
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'            |
				| 'Vendor Ferron, TRY'     |
			And I select current line in "List" table
			And I click "OK" button					
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                         | 'Basis'                                                 | 'Row ID'                               | 'Next step' | 'Quantity' | 'Basis key'                            | 'Current step' | 'Row ref'                              |
			| '1' | '$$Rov1PurchaseOrder017006$$' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '$$Rov1InternalSupplyRequestr017006$$' | 'PI&GR'     | '10,000'   | '$$Rov1InternalSupplyRequestr017006$$' | 'ITO&PO&PI'    | '$$Rov1InternalSupplyRequestr017006$$' |
			| '2' | '$$Rov2PurchaseOrder017006$$' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '$$Rov2InternalSupplyRequestr017006$$' | 'PI&GR'     | '50,000'   | '$$Rov2InternalSupplyRequestr017006$$' | 'ITO&PO&PI'    | '$$Rov2InternalSupplyRequestr017006$$' |
		And I delete "$$NumberPurchaseOrder017006$$" variable
		And I delete "$$PurchaseOrder017006$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder017006$$"
		And I save the window as "$$PurchaseOrder017006$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And "List" table contains lines
			| 'Number'                           |
			| '$$NumberPurchaseOrder017006$$'    |
		And I close all client application windows
		


Scenario: _017011 check totals in the document Purchase Order
	* Opening a list of documents Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	* Selecting PurchaseOrder
		And I go to line in "List" table
		| 'Number'                          |
		| '$$NumberPurchaseOrder017001$$'   |
		And I select current line in "List" table
	* Check totals in the document
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"

	


// Scenario: _017003 check the form Pick up items in the document Purchase order
// 	* Opening a form to create Purchase Order
// 		And I close all client application windows
// 		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
// 		And I click the button named "FormCreate"
// 	* Filling in vendor information
// 		And I click Select button of "Partner" field
// 		And I go to line in "List" table
// 			| Description |
// 			| Ferron BP   |
// 		And I select current line in "List" table
// 		And I click Select button of "Legal name" field
// 		And I activate "Description" field in "List" table
// 		And I go to line in "List" table
// 			| Description       |
// 			| Company Ferron BP |
// 		And I select current line in "List" table
// 		And I click Select button of "Partner term" field
// 		And I go to line in "List" table
// 			| Description        |
// 			| Vendor Ferron, TRY |
// 		And I select current line in "List" table
// 		And I click Select button of "Store" field
// 		Then "Stores" window is opened
// 		And I select current line in "List" table
// 	* Check the form Pick up items
// 		When check the product selection form with price information in Purchase order
// 		And I close all client application windows
	

Scenario: _017101 check input item key by line in the Purchase order
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
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
	* Check input item key line by line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I select "S/Yellow" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Quantity" field in "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| Item   | Item key   |
		| Dress  | S/Yellow   |
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button


Scenario: _017102 check for the creation of the missing item key from the Purchase order document
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
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
	* Creating an item key when filling out the tabular part
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I select from "Size" drop-down list by "XL" string
		And I select from "Color" drop-down list by "red" string
		And I click "Create new" button
		And I click "Save and close" button
		And Delay 2
		And I input "" text in "Size" field
		And I input "" text in "Color" field
		And "List" table became equal
		| Item key   | Item    |
		| S/Yellow   | Dress   |
		| XS/Blue    | Dress   |
		| M/White    | Dress   |
		| L/Green    | Dress   |
		| XL/Green   | Dress   |
		| Dress/A-8  | Dress   |
		| XXL/Red    | Dress   |
		| M/Brown    | Dress   |
		| XL/Red     | Dress   |
		And I close current window
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button


Scenario: _017105 filter when selecting item key in the purchase order document
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
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
	* Filter check on item key when filling out the commodity part
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And Delay 2
		And I select from "Size" drop-down list by "l" string
		And "List" table became equal
		| Item key    |
		| L/Green     |
		| Dress/A-8   |
		And I input "" text in "Size" field
		And I select from "Color" drop-down list by "gr" string
		And "List" table became equal
		| Item key    |
		| L/Green     |
		| XL/Green    |
		| Dress/A-8   |
		And I close current window
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button



Scenario: _019901 check changes in movements on a Purchase Order document when quantity changes
		And I close all client application windows
		When create a Purchase Order document
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder019901$$" variable
		And I delete "$$PurchaseOrder019901$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder019901$$"
		And I save the window as "$$PurchaseOrder019901$$"
	* Check registry entries 
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
		And "List" table contains lines
			| 'Quantity'   | 'Recorder'                  | 'Order'                     | 'Item key'     |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | 'S/Yellow'     |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | 'XS/Blue'      |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | 'M/White'      |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | 'XL/Green'     |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '36/Yellow'    |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '38/Yellow'    |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '36/Red'       |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '38/Black'     |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '36/18SD'      |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '37/18SD'      |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '38/18SD'      |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '39/18SD'      |
		And I close all client application windows
	* Changing the quantity by Item Dress 'S/Yellow' by 250 pcs
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And Delay 2
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder019901$$'    |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | 'S/Yellow'   | '200,000'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "250,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
		And "List" table contains lines
			| 'Quantity'   | 'Recorder'                  | 'Order'                     | 'Item key'    |
			| '250,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | 'S/Yellow'    |
		And "List" table does not contain lines
			| 'Quantity'   | 'Recorder'                  | 'Order'                     | 'Item key'    |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | 'S/Yellow'    |
		
		
				
Scenario: _019902 delete line in Purchase order and chek movements changes
	* Delete last line in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And Delay 2
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder019901$$'    |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to the last line in "ItemList" table
		And I delete current line in "ItemList" table
		And I click the button named "FormPostAndClose"
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
		And "List" table does not contain lines
			| 'Quantity'   | 'Recorder'                  | 'Order'                     | 'Item key'    |
			| '200,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '39/18SD'     |
	
Scenario: _019903 add line in Purchase order and chek movements changes
	* Add line in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder019901$$'    |
		And Delay 2
		And I select current line in "List" table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '39/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '39/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "100,000" text in "Quantity" field of "ItemList" table
		And I input "195,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'High shoes'     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '39/19SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'   | 'Unit'    |
			| 'High shoes'   | '39/19SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "50,000" text in "Quantity" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
	* Check registry entries 
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
		And Delay 2
		And "List" table contains lines
			| 'Quantity'   | 'Recorder'                  | 'Order'                     | 'Item key'    |
			| '100,000'    | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '39/18SD'     |
			| '50,000'     | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '39/19SD'     |
	
Scenario: _019904 add package in Purchase order and chek movements (conversion to storage unit)
	* Add package in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                           |
			| '$$NumberPurchaseOrder019901$$'    |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to the last line in "ItemList" table
		And I delete current line in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'High shoes'     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '39/19SD'     |
		And I select current line in "List" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'High shoes box (8 pcs)'    |
		And I select current line in "List" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'         | 'Item key'   | 'Unit'                      |
			| 'High shoes'   | '39/19SD'    | 'High shoes box (8 pcs)'    |
		And I select current line in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
	* Check registry entries R1010T_PurchaseOrders
	# Packages are converted into pcs.
		Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
		And "List" table contains lines
			| 'Quantity'   | 'Recorder'                  | 'Order'                     | 'Item key'    |
			| '80,000'     | '$$PurchaseOrder019901$$'   | '$$PurchaseOrder019901$$'   | '39/19SD'     |
	



Scenario: _300502 check connection to Purchase order report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number                          |
		| $$NumberPurchaseOrder017001$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows

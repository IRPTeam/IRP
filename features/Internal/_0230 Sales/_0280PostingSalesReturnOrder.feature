#language: en
@tree
@Positive
@Sales

Feature: create document Sales return order

As a sales manager
I want to create a Sales return order document
To track a product that needs to be returned from customer

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _028000 preparation (Sales return order)
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
		When Create catalog Countries objects
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
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
	When Create Document discount (for row)
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create document SalesOrder and SalesInvoice objects (creation based on, SI >SO)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document SalesInvoice objects (linked)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);"   |

Scenario: _0280001 check preparation
	When check preparation


Scenario: _028001 create document Sales return order based on SI (button Create)
	* Create Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
				| 'Number'    | 'Partner'       |
				| '32'        | 'Ferron BP'     |
		And I select current line in "List" table
		And I click the button named "FormDocumentSalesReturnOrderGenerate"
		And I click "Ok" button		
		* Check the details
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
			Then the form attribute named "Comment" became equal to "Click to enter description"
			Then the form attribute named "Company" became equal to "Main Company"
			Then the form attribute named "Store" became equal to "Store 02"
		And I select "Approved" exact value from "Status" drop-down list
	* Check items tab
		And "ItemList" table became equal
			| 'Profit loss center'        | '#'   | 'Item'      | 'Dont calculate row'   | 'Quantity'   | 'Unit'             | 'Tax amount'   | 'Price'      | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Sales invoice'                                | 'Revenue type'   | 'Item key'   | 'Cancel'   | 'Cancel reason'   | 'Sales person'       |
			| 'Distribution department'   | '1'   | 'Dress'     | 'No'                   | '1,000'      | 'pcs'              | '75,36'        | '520,00'     | '18%'   | '26,00'           | '418,64'       | '494,00'         | ''                      | 'Store 02'   | 'Sales invoice 32 dated 04.03.2021 16:32:23'   | 'Revenue'        | 'XS/Blue'    | 'No'       | ''                | 'Alexander Orlov'    |
			| 'Distribution department'   | '2'   | 'Shirt'     | 'No'                   | '12,000'     | 'pcs'              | '640,68'       | '350,00'     | '18%'   | ''                | '3 559,32'     | '4 200,00'       | ''                      | 'Store 02'   | 'Sales invoice 32 dated 04.03.2021 16:32:23'   | 'Revenue'        | '36/Red'     | 'No'       | ''                | 'Alexander Orlov'    |
			| 'Distribution department'   | '3'   | 'Boots'     | 'No'                   | '2,000'      | 'Boots (12 pcs)'   | '2 434,58'     | '8 400,00'   | '18%'   | '840,00'          | '13 525,42'    | '15 960,00'      | ''                      | 'Store 02'   | 'Sales invoice 32 dated 04.03.2021 16:32:23'   | 'Revenue'        | '37/18SD'    | 'No'       | ''                | 'Alexander Orlov'    |
			| 'Front office'              | '4'   | 'Service'   | 'No'                   | '1,000'      | 'pcs'              | '14,49'        | '100,00'     | '18%'   | '5,00'            | '80,51'        | '95,00'          | ''                      | ''           | 'Sales invoice 32 dated 04.03.2021 16:32:23'   | 'Revenue'        | 'Internet'   | 'No'       | ''                | ''                   |
			| ''                          | '5'   | 'Shirt'     | 'No'                   | '2,000'      | 'pcs'              | '106,78'       | '350,00'     | '18%'   | ''                | '593,22'       | '700,00'         | ''                      | 'Store 02'   | 'Sales invoice 32 dated 04.03.2021 16:32:23'   | ''               | '38/Black'   | 'No'       | ''                | 'Anna Petrova'       |
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "871,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "18 177,11"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "3 271,89"
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
			| 'Quantity'   | 'Recorder'                     | 'Order'                        | 'Item key'    |
			| '2,000'      | '$$SalesReturnOrder028001$$'   | '$$SalesReturnOrder028001$$'   | '38/Black'    |
		And I close current window
	* And I set Wait status
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberSalesReturnOrder028001$$'    |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And Delay 2
		And I select "Wait" exact value from "Status" drop-down list
		And Delay 2
		And I click the button named "FormPost"
		* Check for no movements in the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.R2012B_SalesOrdersInvoiceClosing"
			And "List" table does not contain lines
				| 'Quantity'    | 'Recorder'                      | 'Order'                         | 'Item key'     |
				| '2,000'       | '$$SalesReturnOrder028001$$'    | '$$SalesReturnOrder028001$$'    | '38/Black'     |
			And I close current window
		And Delay 2
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                       | 'Status'      |
			| '$$SalesReturnOrder028001$$'   | 'Wait'        |
			| '$$SalesReturnOrder028001$$'   | 'Approved'    |
		And I close current window
		And I click the button named "FormPostAndClose"


Scenario: _028009 create Sales return order without bases document
	* Opening a form to create Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
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
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
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
		And I click choice button of "Sales person" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Alexander Orlov'    |
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
		And I delete "$$NumberSalesReturnOrder028009$$" variable
		And I delete "$$SalesReturnOrder028009$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturnOrder028009$$"
		And I save the window as "$$SalesReturnOrder028009$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And "List" table contains lines
			| 'Number'                              |
			| '$$NumberSalesReturnOrder028009$$'    |
		And I close all client application windows
		

Scenario: _028010 check filling in Row Id info table in the SRO
	* Select SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberSalesReturnOrder028009$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1SalesReturnOrder028009$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2SalesReturnOrder028009$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3SalesReturnOrder028009$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                              | 'Basis'   | 'Row ID'                           | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                           |
			| '$$Rov1SalesReturnOrder028009$$'   | ''        | '$$Rov1SalesReturnOrder028009$$'   | 'SR'          | '100,000'    | ''            | ''               | '$$Rov1SalesReturnOrder028009$$'    |
			| '$$Rov2SalesReturnOrder028009$$'   | ''        | '$$Rov2SalesReturnOrder028009$$'   | 'SR'          | '200,000'    | ''            | ''               | '$$Rov2SalesReturnOrder028009$$'    |
			| '$$Rov3SalesReturnOrder028009$$'   | ''        | '$$Rov3SalesReturnOrder028009$$'   | 'SR'          | '300,000'    | ''            | ''               | '$$Rov3SalesReturnOrder028009$$'    |
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
		And I save the current field value as "$$Rov4SalesReturnOrder028009$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                              | 'Basis'   | 'Row ID'                           | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                           |
			| '$$Rov1SalesReturnOrder028009$$'   | ''        | '$$Rov1SalesReturnOrder028009$$'   | 'SR'          | '100,000'    | ''            | ''               | '$$Rov1SalesReturnOrder028009$$'    |
			| '$$Rov2SalesReturnOrder028009$$'   | ''        | '$$Rov2SalesReturnOrder028009$$'   | 'SR'          | '200,000'    | ''            | ''               | '$$Rov2SalesReturnOrder028009$$'    |
			| '$$Rov3SalesReturnOrder028009$$'   | ''        | '$$Rov3SalesReturnOrder028009$$'   | 'SR'          | '300,000'    | ''            | ''               | '$$Rov3SalesReturnOrder028009$$'    |
			| '$$Rov4SalesReturnOrder028009$$'   | ''        | '$$Rov4SalesReturnOrder028009$$'   | 'SR'          | '208,000'    | ''            | ''               | '$$Rov4SalesReturnOrder028009$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And "RowIDInfo" table does not contain lines
			| 'Key'                              | 'Basis'   | 'Row ID'                           | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                           |
			| '$$Rov2SalesReturnOrder028009$$'   | ''        | '$$Rov2SalesReturnOrder028009$$'   | ''            | '208,000'    | ''            | ''               | '$$Rov2SalesReturnOrder028009$$'    |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '4'   | 'Dress'   | 'L/Green'    | '208,000'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                              | 'Basis'   | 'Row ID'                           | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                           |
			| '$$Rov1SalesReturnOrder028009$$'   | ''        | '$$Rov1SalesReturnOrder028009$$'   | 'SR'          | '100,000'    | ''            | ''               | '$$Rov1SalesReturnOrder028009$$'    |
			| '$$Rov2SalesReturnOrder028009$$'   | ''        | '$$Rov2SalesReturnOrder028009$$'   | 'SR'          | '200,000'    | ''            | ''               | '$$Rov2SalesReturnOrder028009$$'    |
			| '$$Rov3SalesReturnOrder028009$$'   | ''        | '$$Rov3SalesReturnOrder028009$$'   | 'SR'          | '300,000'    | ''            | ''               | '$$Rov3SalesReturnOrder028009$$'    |
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
			| 'Key'                              | 'Basis'   | 'Row ID'                           | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                           |
			| '$$Rov1SalesReturnOrder028009$$'   | ''        | '$$Rov1SalesReturnOrder028009$$'   | 'SR'          | '100,000'    | ''            | ''               | '$$Rov1SalesReturnOrder028009$$'    |
			| '$$Rov2SalesReturnOrder028009$$'   | ''        | '$$Rov2SalesReturnOrder028009$$'   | 'SR'          | '7,000'      | ''            | ''               | '$$Rov2SalesReturnOrder028009$$'    |
			| '$$Rov3SalesReturnOrder028009$$'   | ''        | '$$Rov3SalesReturnOrder028009$$'   | 'SR'          | '300,000'    | ''            | ''               | '$$Rov3SalesReturnOrder028009$$'    |
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
		
	
Scenario: _028011 copy SRO and check filling in Row Id info table
	* Copy SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberSalesReturnOrder028009$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table became equal
			| '#'   | 'Profit loss center'   | 'Item'       | 'Item key'    | 'Dont calculate row'   | 'Quantity'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Revenue type'   | 'Net amount'    |
			| '1'   | ''                     | 'Dress'      | 'M/White'     | 'No'                   | '100,000'    | 'pcs'    | '3 050,85'     | '200,00'   | '18%'   | ''                | '20 000,00'      | ''                      | 'Store 01'   | ''               | '16 949,15'     |
			| '2'   | ''                     | 'Dress'      | 'L/Green'     | 'No'                   | '200,000'    | 'pcs'    | '6 406,78'     | '210,00'   | '18%'   | ''                | '42 000,00'      | ''                      | 'Store 01'   | ''               | '35 593,22'     |
			| '3'   | ''                     | 'Trousers'   | '36/Yellow'   | 'No'                   | '300,000'    | 'pcs'    | '11 440,68'    | '250,00'   | '18%'   | ''                | '75 000,00'      | ''                      | 'Store 01'   | ''               | '63 559,32'     |
		And in the table "ItemList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'       |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '23 454,40'    |
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
	* Post SRO and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                              | 'Basis'   | 'Row ID'                           | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                           |
			| '$$Rov1SalesReturnOrder028009$$'   | ''        | '$$Rov1SalesReturnOrder028009$$'   | 'SR'          | '100,000'    | ''            | ''               | '$$Rov1SalesReturnOrder028009$$'    |
			| '$$Rov2SalesReturnOrder028009$$'   | ''        | '$$Rov2SalesReturnOrder028009$$'   | 'SR'          | '200,000'    | ''            | ''               | '$$Rov2SalesReturnOrder028009$$'    |
			| '$$Rov3SalesReturnOrder028009$$'   | ''        | '$$Rov3SalesReturnOrder028009$$'   | 'SR'          | '300,000'    | ''            | ''               | '$$Rov3SalesReturnOrder028009$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows




Scenario: _028012 check totals in the document Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Select Sales return
		And I go to line in "List" table
		| 'Number'                             |
		| '$$NumberSalesReturnOrder028001$$'   |
		And I select current line in "List" table
	* Check totals in the document Sales return order
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "871,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "18 177,11"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "3 271,89"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "21 449,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"



Scenario: _028013 create SRO using form link/unlink
	* Open SRO form
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Crystal'        |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Adel'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table	
	* Select items from basis documents
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '350,00'   | '2,000'      | 'Shirt (38/Black)'   | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '4,000'      | 'Dress (M/White)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '700,00'   | '1,000'      | 'Boots (37/18SD)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Show row key" button
	* Check RowIDInfo
		And "RowIDInfo" table contains lines
		| '#'  | 'Basis'                                        | 'Next step'  | 'Quantity'  | 'Current step'   |
		| '1'  | 'Sales invoice 101 dated 05.03.2021 12:56:38'  | ''           | '2,000'     | 'SRO&SR'         |
		| '2'  | 'Sales invoice 102 dated 05.03.2021 12:57:59'  | ''           | '1,000'     | 'SRO&SR'         |
		| '3'  | 'Sales invoice 101 dated 05.03.2021 12:56:38'  | ''           | '4,000'     | 'SRO&SR'         |
		Then the number of "RowIDInfo" table lines is "равно" "3"
	* Unlink line
		And I click the button named "LinkUnlinkBasisDocuments"
		Then "Link / unlink document row" window is opened
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'    |
			| '1'   | '2,000'      | 'Shirt (38/Black)'   | 'Store 01'   | 'pcs'     |
		And I set checkbox "Linked documents"		
		And I go to line in "ResultsTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'    |
			| 'TRY'        | '350,00'   | '2,000'      | 'Shirt (38/Black)'   | 'pcs'     |
		And I click "Unlink" button
		And I click "Ok" button
		And I click "Save" button	
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                                         | 'Next step' | 'Quantity'   | 'Current step'    |
			| '1'   | 'Sales invoice 102 dated 05.03.2021 12:57:59'   | ''          | '1,000'      | 'SRO&SR'          |
			| '2'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | ''          | '4,000'      | 'SRO&SR'          |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Sales invoice'                                  |
			| 'Shirt'   | '38/Black'   | ''                                               |
			| 'Dress'   | 'M/White'    | 'Sales invoice 101 dated 05.03.2021 12:56:38'    |
			| 'Boots'   | '37/18SD'    | 'Sales invoice 102 dated 05.03.2021 12:57:59'    |
	* Link line
		And I click the button named "LinkUnlinkBasisDocuments"
		And I go to line in "ItemListRows" table
			| '#'   | 'Quantity'   | 'Row presentation'   | 'Store'      | 'Unit'    |
			| '1'   | '2,000'      | 'Shirt (38/Black)'   | 'Store 01'   | 'pcs'     |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'    |
			| 'TRY'        | '350,00'   | '2,000'      | 'Shirt (38/Black)'   | 'pcs'     |
		And I click "Link" button
		And I click "Ok" button
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                                         | 'Next step'     | 'Quantity'   | 'Current step'    |
			| '1'   | 'Sales invoice 102 dated 05.03.2021 12:57:59'   | 'SR'            | '1,000'      | 'SRO&SR'          |
			| '2'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'SR'            | '2,000'      | 'SRO&SR'          |
			| '3'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'SR'            | '4,000'      | 'SRO&SR'          |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Sales invoice'                                  |
			| 'Shirt'   | '38/Black'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'    |
			| 'Dress'   | 'M/White'    | 'Sales invoice 101 dated 05.03.2021 12:56:38'    |
			| 'Boots'   | '37/18SD'    | 'Sales invoice 102 dated 05.03.2021 12:57:59'    |
	* Delete string, add it again, change unit
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click the button named "AddBasisDocuments"
		And I go to line in "BasisesTree" table
			| 'Currency'   | 'Price'    | 'Quantity'   | 'Row presentation'   | 'Unit'   | 'Use'    |
			| 'TRY'        | '520,00'   | '4,000'      | 'Dress (M/White)'    | 'pcs'    | 'No'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Sales invoice'                                  |
			| 'Shirt'   | '38/Black'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'    |
			| 'Dress'   | 'M/White'    | 'Sales invoice 101 dated 05.03.2021 12:56:38'    |
			| 'Boots'   | '37/18SD'    | 'Sales invoice 102 dated 05.03.2021 12:57:59'    |
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Store'       |
			| 'Dress'   | 'M/White'    | '4,000'      | 'Store 01'    |
		And I activate "Unit" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I select current line in "List" table
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| '#'   | 'Basis'                                         | 'Next step'     | 'Quantity'   | 'Current step'    |
			| '1'   | 'Sales invoice 102 dated 05.03.2021 12:57:59'   | 'SR'            | '1,000'      | 'SRO&SR'          |
			| '2'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'SR'            | '2,000'      | 'SRO&SR'          |
			| '3'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'SR'            | '32,000'     | 'SRO&SR'          |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I click the button named "FormUndoPosting"	
		And I close all client application windows


Scenario: _300510 check connection to SalesReturnOrder report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number                             |
		| $$NumberSalesReturnOrder028001$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows

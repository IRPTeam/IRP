#language: en
@tree
@Positive
@Sales

Feature: create document Sales return

As a procurement manager
I want to create a Sales return document
To track a product that returned from customer

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028500 preparation (create document Sales return)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog Partners objects
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
		When Create catalog ExpenseAndRevenueTypes objects 
		When Create information register CurrencyRates records
		When Create catalog Companies objects (own Second company)
		When Create information register Taxes records (VAT)
		When Create catalog BusinessUnits objects
	* Add plugin for discount
		When Create Document discount (for row)
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
		When Create document SalesInvoice objects (linked)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesOrder and SalesInvoice objects (creation based on, SI >SO)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesReturnOrder objects (creation based on)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturnOrder.FindByNumber(32).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document SalesReturnOrder objects (creation based on, without SI)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturnOrder.FindByNumber(105).GetObject().Write(DocumentWriteMode.Write);"    |
			| "Documents.SalesReturnOrder.FindByNumber(105).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturnOrder.FindByNumber(106).GetObject().Write(DocumentWriteMode.Write);"    |
			| "Documents.SalesReturnOrder.FindByNumber(106).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturnOrder.FindByNumber(107).GetObject().Write(DocumentWriteMode.Write);"    |
			| "Documents.SalesReturnOrder.FindByNumber(107).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _0285001 check preparation
	When check preparation


Scenario: _028501 create document Sales return based on SI (without SRO)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'  | 'Partner'   |
		| '101'     | 'Crystal'   |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerate"
	And I click "Ok" button
	* Check the details
		Then the form attribute named "Partner" became equal to "Crystal"
		Then the form attribute named "LegalName" became equal to "Company Adel"
		Then the form attribute named "Comment" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Store" became equal to "Store 01"
		// Then the form attribute named "Branch" became equal to "Distribution department"
	* Check items tab
		And "ItemList" table contains lines
		| '#'  | 'Item'   | 'Item key'  | 'Dont calculate row'  | 'Serial lot numbers'  | 'Quantity'  | 'Unit'            | 'Tax amount'  | 'Price'     | 'VAT'  | 'Offers amount'  | 'Net amount'  | 'Use goods receipt'  | 'Total amount'  | 'Additional analytic'  | 'Store'     | 'Sales return order'  | 'Sales invoice'                                | 'Revenue type'  | 'Sales person'      |
		| '1'  | 'Shirt'  | '38/Black'  | 'No'                  | ''                    | '2,000'     | 'pcs'             | '106,78'      | '350,00'    | '18%'  | ''               | '593,22'      | 'No'                 | '700,00'        | ''                     | 'Store 01'  | ''                    | 'Sales invoice 101 dated 05.03.2021 12:56:38'  | 'Revenue'       | 'Alexander Orlov'   |
		| '2'  | 'Boots'  | '36/18SD'   | 'No'                  | ''                    | '2,000'     | 'Boots (12 pcs)'  | '2 562,71'    | '8 400,00'  | '18%'  | ''               | '14 237,29'   | 'No'                 | '16 800,00'     | ''                     | 'Store 01'  | ''                    | 'Sales invoice 101 dated 05.03.2021 12:56:38'  | 'Revenue'       | 'Alexander Orlov'   |
		| '3'  | 'Boots'  | '37/18SD'   | 'No'                  | ''                    | '2,000'     | 'pcs'             | '213,56'      | '700,00'    | '18%'  | ''               | '1 186,44'    | 'No'                 | '1 400,00'      | ''                     | 'Store 01'  | ''                    | 'Sales invoice 101 dated 05.03.2021 12:56:38'  | 'Revenue'       | ''                  |
		| '4'  | 'Dress'  | 'M/White'   | 'No'                  | ''                    | '4,000'     | 'pcs'             | '317,29'      | '520,00'    | '18%'  | ''               | '1 762,71'    | 'No'                 | '2 080,00'      | ''                     | 'Store 01'  | ''                    | 'Sales invoice 101 dated 05.03.2021 12:56:38'  | 'Revenue'       | ''                  |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturn028501$$" variable
	And I delete "$$SalesReturn028501$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturn028501$$"
	And I save the window as "$$SalesReturn028501$$"
	And I click the button named "FormPostAndClose"
	And I close current window
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                         |
			| '$$NumberSalesReturn028501$$'    |
		And I close all client application windows



Scenario: _028502 check filling in Row Id info table in the SR (SI-SR)
		And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberSalesReturn028501$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1SalesReturn028501$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2SalesReturn028501$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3SalesReturn028501$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '4'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov4SalesReturn028501$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| '#'   | 'Key'                         | 'Basis'                                         | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '72d99733-14eb-4cc2-b463-1782405cd408'   | ''            | '2,000'      | '72d99733-14eb-4cc2-b463-1782405cd408'   | 'SRO&SR'         | '72d99733-14eb-4cc2-b463-1782405cd408'    |
			| '2'   | '$$Rov2SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | ''            | '24,000'     | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | 'SRO&SR'         | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'    |
			| '3'   | '$$Rov3SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | ''            | '2,000'      | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | 'SRO&SR'         | 'c6605104-b141-4358-ab1d-9355d75d21c6'    |
			| '4'   | '$$Rov4SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | ''            | '4,000'      | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | 'SRO&SR'         | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Shirt'   | '38/Black'   | '2,000'       |
		And in the table "ItemList" I click "Copy" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'    |
			| '5'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov5SalesReturn028501$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table became equal
			| '#'   | 'Key'                         | 'Basis'                                         | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '72d99733-14eb-4cc2-b463-1782405cd408'   | ''            | '2,000'      | '72d99733-14eb-4cc2-b463-1782405cd408'   | 'SRO&SR'         | '72d99733-14eb-4cc2-b463-1782405cd408'    |
			| '2'   | '$$Rov2SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | ''            | '24,000'     | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | 'SRO&SR'         | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'    |
			| '3'   | '$$Rov3SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | ''            | '2,000'      | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | 'SRO&SR'         | 'c6605104-b141-4358-ab1d-9355d75d21c6'    |
			| '4'   | '$$Rov4SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | ''            | '4,000'      | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | 'SRO&SR'         | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'    |
			| '5'   | '$$Rov5SalesReturn028501$$'   | ''                                              | '$$Rov5SalesReturn028501$$'              | ''            | '8,000'      | '                                    '   | ''               | '$$Rov5SalesReturn028501$$'               |
		Then the number of "RowIDInfo" table lines is "равно" "5"
		And "RowIDInfo" table does not contain lines
			| 'Key'                         | 'Quantity'    |
			| '$$Rov1SalesReturn028501$$'   | '8,000'       |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '5'   | 'Shirt'   | '38/Black'   | '8,000'       |
		And in the table "ItemList" I click "Delete" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| '#'   | 'Key'                         | 'Basis'                                         | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '72d99733-14eb-4cc2-b463-1782405cd408'   | ''            | '2,000'      | '72d99733-14eb-4cc2-b463-1782405cd408'   | 'SRO&SR'         | '72d99733-14eb-4cc2-b463-1782405cd408'    |
			| '2'   | '$$Rov2SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | ''            | '24,000'     | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | 'SRO&SR'         | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'    |
			| '3'   | '$$Rov3SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | ''            | '2,000'      | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | 'SRO&SR'         | 'c6605104-b141-4358-ab1d-9355d75d21c6'    |
			| '4'   | '$$Rov4SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | ''            | '4,000'      | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | 'SRO&SR'         | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Shirt'   | '38/Black'   | '2,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                         | 'Basis'                                         | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '72d99733-14eb-4cc2-b463-1782405cd408'   | ''            | '7,000'      | '72d99733-14eb-4cc2-b463-1782405cd408'   | 'SRO&SR'         | '72d99733-14eb-4cc2-b463-1782405cd408'    |
			| '2'   | '$$Rov2SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | ''            | '24,000'     | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | 'SRO&SR'         | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'    |
			| '3'   | '$$Rov3SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | ''            | '2,000'      | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | 'SRO&SR'         | 'c6605104-b141-4358-ab1d-9355d75d21c6'    |
			| '4'   | '$$Rov4SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | ''            | '4,000'      | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | 'SRO&SR'         | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Shirt'   | '38/Black'   | '7,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change checkbox Use Goods receipt and check RowIDInfo
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'              |
			| 'Boots'   | '36/18SD'    | '2,000'      | 'Boots (12 pcs)'    |
		And I set "Use Goods receipt" checkbox in "ItemList" table
		And I move to the tab named "GroupRowIDInfo"
		And I click "Post" button
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                         | 'Basis'                                         | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '72d99733-14eb-4cc2-b463-1782405cd408'   | ''            | '2,000'      | '72d99733-14eb-4cc2-b463-1782405cd408'   | 'SRO&SR'         | '72d99733-14eb-4cc2-b463-1782405cd408'    |
			| '2'   | '$$Rov2SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | 'GR'          | '24,000'     | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'   | 'SRO&SR'         | '60f79f2b-f0c4-42d9-8175-bc4b346e419d'    |
			| '3'   | '$$Rov3SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | ''            | '2,000'      | 'c6605104-b141-4358-ab1d-9355d75d21c6'   | 'SRO&SR'         | 'c6605104-b141-4358-ab1d-9355d75d21c6'    |
			| '4'   | '$$Rov4SalesReturn028501$$'   | 'Sales invoice 101 dated 05.03.2021 12:56:38'   | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | ''            | '4,000'      | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'   | 'SRO&SR'         | '9ea0981e-11cc-4dd3-a57c-a226b4a7e405'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"	
		And I click the button named "FormPostAndClose"


Scenario: _028503 create SR based on SI (different company, branch, store)
		And I close all client application windows
	* Open a form to create Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Filling in vendor information
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
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'    |
			| 'Shop 01'        |
		And I select current line in "List" table
	* Select items
		And I move to "Item list" tab
		And in the table "ItemList" I click "Add basis documents" button
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And "BasisesTree" table became equal
			| 'Row presentation'                            | 'Use' | 'Company'      | 'Branch'                  | 'Quantity' | 'Unit' | 'Price'  | 'Currency' |
			| 'Sales invoice 102 dated 05.03.2021 12:57:59' | 'No'  | 'Main Company' | 'Distribution department' | ''         | ''     | ''       | ''         |
			| 'Boots (37/18SD)'                             | 'No'  | 'Main Company' | 'Distribution department' | '1,000'    | 'pcs'  | '700,00' | 'TRY'      |
			| 'Dress (M/White)'                             | 'No'  | 'Main Company' | 'Distribution department' | '2,000'    | 'pcs'  | '520,00' | 'TRY'      |
		And I go to line in "BasisesTree" table
			| 'Row presentation'    |
			| 'Dress (M/White)'     |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
	* Check
		And "ItemList" table became equal
			| '#'   | 'Item'    | 'Profit loss center'        | 'Item key'   | 'Unit'   | 'Serial lot numbers'   | 'Dont calculate row'   | 'Quantity'   | 'Sales invoice'                                 | 'Price'    | 'Use goods receipt'   | 'Total amount'   | 'Additional analytic'   | 'Store'      | 'Sales return order'   | 'Return reason'   | 'Revenue type'   | 'Offers amount'   | 'Landed cost'   | 'Sales person'    |
			| '1'   | 'Dress'   | 'Distribution department'   | 'M/White'    | 'pcs'    | ''                     | 'No'                   | '2,000'      | 'Sales invoice 102 dated 05.03.2021 12:57:59'   | '520,00'   | 'No'                  | '1 040,00'       | ''                      | 'Store 01'   | ''                     | ''                | 'Revenue'        | ''                | ''              | ''                |
	* Show row key
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'   | 'Basis'                                         | 'Row ID'   | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'    |
			| '1'   | '*'     | 'Sales invoice 102 dated 05.03.2021 12:57:59'   | '*'        | ''            | '2,000'      | '*'           | 'SRO&SR'         | '*'          |
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn028503$$" variable
		And I delete "$$SalesReturn028503$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn028503$$"
		And I save the window as "$$SalesReturn028503$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                         |
			| '$$NumberSalesReturn028503$$'    |
		And I close all client application windows	
			


Scenario: _028509 create Sales return without bases document
	* Opening a form to create Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
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
		And I input "100" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Unit'    |
			| '2'   | 'Dress'   | 'L/Green'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200" text in "Quantity" field of "ItemList" table
		And I input "210" text in "Price" field of "ItemList" table
		And I input "100" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'   | 'Item'       | 'Item key'    | 'Unit'    |
			| '3'   | 'Trousers'   | '36/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "300" text in "Quantity" field of "ItemList" table
		And I input "250" text in "Price" field of "ItemList" table
		And I input "100" text in "Landed cost" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'       | 'Quantity'   | 'Item key'    | 'Store'      | 'Unit'    |
			| 'Dress'      | '100,000'    | 'M/White'     | 'Store 01'   | 'pcs'     |
			| 'Dress'      | '200,000'    | 'L/Green'     | 'Store 01'   | 'pcs'     |
			| 'Trousers'   | '300,000'    | '36/Yellow'   | 'Store 01'   | 'pcs'     |
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn028509$$" variable
		And I delete "$$SalesReturn028509$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn028509$$"
		And I save the window as "$$SalesReturn028509$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                         |
			| '$$NumberSalesReturn028509$$'    |
		And I close all client application windows

Scenario: _028510 check filling in Row Id info table in the SR
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberSalesReturn028509$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1SalesReturn028509$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2SalesReturn028509$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3SalesReturn028509$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                         | 'Basis'   | 'Row ID'                      | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                      |
			| '$$Rov1SalesReturn028509$$'   | ''        | '$$Rov1SalesReturn028509$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1SalesReturn028509$$'    |
			| '$$Rov2SalesReturn028509$$'   | ''        | '$$Rov2SalesReturn028509$$'   | ''            | '200,000'    | ''            | ''               | '$$Rov2SalesReturn028509$$'    |
			| '$$Rov3SalesReturn028509$$'   | ''        | '$$Rov3SalesReturn028509$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3SalesReturn028509$$'    |
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
		And I save the current field value as "$$Rov4SalesReturn028509$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                         | 'Basis'   | 'Row ID'                      | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                      |
			| '$$Rov1SalesReturn028509$$'   | ''        | '$$Rov1SalesReturn028509$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1SalesReturn028509$$'    |
			| '$$Rov2SalesReturn028509$$'   | ''        | '$$Rov2SalesReturn028509$$'   | ''            | '200,000'    | ''            | ''               | '$$Rov2SalesReturn028509$$'    |
			| '$$Rov3SalesReturn028509$$'   | ''        | '$$Rov3SalesReturn028509$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3SalesReturn028509$$'    |
			| '$$Rov4SalesReturn028509$$'   | ''        | '$$Rov4SalesReturn028509$$'   | ''            | '208,000'    | ''            | ''               | '$$Rov4SalesReturn028509$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "4"
		And "RowIDInfo" table does not contain lines
			| 'Key'                         | 'Basis'   | 'Row ID'                      | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                      |
			| '$$Rov2SalesReturn028509$$'   | ''        | '$$Rov2SalesReturn028509$$'   | ''            | '208,000'    | ''            | ''               | '$$Rov2SalesReturn028509$$'    |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '4'   | 'Dress'   | 'L/Green'    | '208,000'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                         | 'Basis'   | 'Row ID'                      | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                      |
			| '$$Rov1SalesReturn028509$$'   | ''        | '$$Rov1SalesReturn028509$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1SalesReturn028509$$'    |
			| '$$Rov2SalesReturn028509$$'   | ''        | '$$Rov2SalesReturn028509$$'   | ''            | '200,000'    | ''            | ''               | '$$Rov2SalesReturn028509$$'    |
			| '$$Rov3SalesReturn028509$$'   | ''        | '$$Rov3SalesReturn028509$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3SalesReturn028509$$'    |
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
			| 'Key'                         | 'Basis'   | 'Row ID'                      | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                      |
			| '$$Rov1SalesReturn028509$$'   | ''        | '$$Rov1SalesReturn028509$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1SalesReturn028509$$'    |
			| '$$Rov2SalesReturn028509$$'   | ''        | '$$Rov2SalesReturn028509$$'   | ''            | '7,000'      | ''            | ''               | '$$Rov2SalesReturn028509$$'    |
			| '$$Rov3SalesReturn028509$$'   | ''        | '$$Rov3SalesReturn028509$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3SalesReturn028509$$'    |
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
		
	
Scenario: _028511 copy SR and check filling in Row Id info table
	* Copy SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberSalesReturn028509$$'    |
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
	* Post SR and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                         | 'Basis'   | 'Row ID'                      | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                      |
			| '$$Rov1SalesReturn028509$$'   | ''        | '$$Rov1SalesReturn028509$$'   | ''            | '100,000'    | ''            | ''               | '$$Rov1SalesReturn028509$$'    |
			| '$$Rov2SalesReturn028509$$'   | ''        | '$$Rov2SalesReturn028509$$'   | ''            | '200,000'    | ''            | ''               | '$$Rov2SalesReturn028509$$'    |
			| '$$Rov3SalesReturn028509$$'   | ''        | '$$Rov3SalesReturn028509$$'   | ''            | '300,000'    | ''            | ''               | '$$Rov3SalesReturn028509$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And I close all client application windows

Scenario: _028515 create document Sales return based on SRO 
	* Save Sales return order Row id
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '105'       |
		And I select current line in "List" table
		And I click "Show row key" button	
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesReturnOrder028515$$" variable
		And I save the current field value as "$$Rov1SalesReturnOrder028515$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2SalesReturnOrder028515$$" variable
		And I save the current field value as "$$Rov2SalesReturnOrder028515$$"
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '106'       |
		And I select current line in "List" table
		And I click "Show row key" button	
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov3SalesReturnOrder028515$$" variable
		And I save the current field value as "$$Rov3SalesReturnOrder028515$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov4SalesReturnOrder028515$$" variable
		And I save the current field value as "$$Rov4SalesReturnOrder028515$$"
		And I close all client application windows
	* Add items from basis documents
		* Open form for create Sales return
			Given I open hyperlink "e1cib/list/Document.SalesReturn"
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
				| 'Kalipso'         |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'         |
				| 'Company Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I move to "Other" tab
			And I click Choice button of the field named "Branch"
			And I go to line in "List" table
				| 'Description'                 |
				| 'Distribution department'     |
			And I select current line in "List" table	
		* Select items from basis documents
			And I click the button named "AddBasisDocuments"
			And "BasisesTree" table contains lines
				| 'Row presentation'                                    | 'Use'    | 'Quantity'    | 'Unit'              | 'Price'       | 'Currency'     |
				| 'Sales return order 105 dated 25.03.2021 12:09:40'    | 'No'     | ''            | ''                  | ''            | ''             |
				| 'Dress (XS/Blue)'                                     | 'No'     | '1,000'       | 'pcs'               | '520,00'      | 'TRY'          |
				| 'Boots (37/18SD)'                                     | 'No'     | '3,000'       | 'Boots (12 pcs)'    | '8 400,00'    | 'TRY'          |
				| 'Sales return order 106 dated 25.03.2021 12:10:03'    | 'No'     | ''            | ''                  | ''            | ''             |
				| 'Dress (XS/Blue)'                                     | 'No'     | '12,000'      | 'pcs'               | '520,00'      | 'TRY'          |
				| 'Boots (37/18SD)'                                     | 'No'     | '11,000'      | 'Boots (12 pcs)'    | '8 400,00'    | 'TRY'          |
			// Then the number of "BasisesTree" table lines is "равно" "6"
			And I go to line in "BasisesTree" table
				| 'Quantity'    | 'Row presentation'    | 'Unit'    | 'Use'     |
				| '12,000'      | 'Dress (XS/Blue)'     | 'pcs'     | 'No'      |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I go to line in "BasisesTree" table
				| 'Quantity'    | 'Row presentation'    | 'Unit'    | 'Use'     |
				| '1,000'       | 'Dress (XS/Blue)'     | 'pcs'     | 'No'      |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And I click "Show row key" button
			And in the table "ItemList" I click "Edit quantity in base unit" button
			And I go to line in "ItemList" table
				| '#'     |
				| '1'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1SalesReturn028515$$" variable	
			And I save the current field value as "$$Rov1SalesReturn028515$$"	
			And I go to line in "ItemList" table
				| '#'     |
				| '2'     |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov2SalesReturn028515$$" variable	
			And I save the current field value as "$$Rov2SalesReturn028515$$"			
		* Check Item tab and RowID tab
			And "ItemList" table contains lines
				| 'Key'                          | 'Store'       | 'Additional analytic'    | 'Stock quantity'    | '#'    | 'Item'     | 'Item key'    | 'Dont calculate row'    | 'Serial lot numbers'    | 'Quantity'    | 'Unit'    | 'Tax amount'    | 'Price'     | 'VAT'    | 'Offers amount'    | 'Net amount'    | 'Use goods receipt'    | 'Total amount'    | 'Sales return order'                                  | 'Sales invoice'    | 'Revenue type'     |
				| '$$Rov1SalesReturn028515$$'    | 'Store 02'    | ''                       | '1,000'             | '1'    | 'Dress'    | 'XS/Blue'     | 'No'                    | ''                      | '1,000'       | 'pcs'     | '79,32'         | '520,00'    | '18%'    | ''                 | '440,68'        | 'No'                   | '520,00'          | 'Sales return order 105 dated 25.03.2021 12:09:40'    | ''                 | 'Expense'          |
				| '$$Rov2SalesReturn028515$$'    | 'Store 02'    | ''                       | '12,000'            | '2'    | 'Dress'    | 'XS/Blue'     | 'No'                    | ''                      | '12,000'      | 'pcs'     | '951,86'        | '520,00'    | '18%'    | ''                 | '5 288,14'      | 'No'                   | '6 240,00'        | 'Sales return order 106 dated 25.03.2021 12:10:03'    | ''                 | ''                 |
			And "RowIDInfo" table contains lines
				| '#'    | 'Key'                          | 'Basis'                                               | 'Row ID'                            | 'Next step'    | 'Quantity'    | 'Basis key'                         | 'Current step'    | 'Row ref'                            |
				| '1'    | '$$Rov1SalesReturn028515$$'    | 'Sales return order 105 dated 25.03.2021 12:09:40'    | '$$Rov1SalesReturnOrder028515$$'    | ''             | '1,000'       | '$$Rov1SalesReturnOrder028515$$'    | 'SR'              | '$$Rov1SalesReturnOrder028515$$'     |
				| '2'    | '$$Rov2SalesReturn028515$$'    | 'Sales return order 106 dated 25.03.2021 12:10:03'    | '$$Rov3SalesReturnOrder028515$$'    | ''             | '12,000'      | '$$Rov3SalesReturnOrder028515$$'    | 'SR'              | '$$Rov3SalesReturnOrder028515$$'     |
			Then the number of "RowIDInfo" table lines is "равно" "2"
			* Set checkbox Use GR and check RowID tab
				And I move to "Item list" tab
				And I go to line in "ItemList" table
					| '#'      |
					| '1'      |
				And I activate "Use goods receipt" field in "ItemList" table
				And I set "Use goods receipt" checkbox in "ItemList" table
				And I finish line editing in "ItemList" table
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Quantity' |
					| 'Dress' | 'XS/Blue'  | '1,000'    |
				And I activate "Landed cost" field in "ItemList" table
				And I select current line in "ItemList" table
				And I input "2,00" text in "Landed cost" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Quantity' |
					| 'Dress' | 'XS/Blue'  | '12,000'   |
				And I select current line in "ItemList" table
				And I input "2,00" text in "Landed cost" field of "ItemList" table
				And I finish line editing in "ItemList" table				
				And I click "Post" button
				And "RowIDInfo" table contains lines
					| '#'     | 'Key'                           | 'Basis'                                                | 'Row ID'                             | 'Next step'     | 'Quantity'     | 'Basis key'                          | 'Current step'     | 'Row ref'                             |
					| '1'     | '$$Rov1SalesReturn028515$$'     | 'Sales return order 105 dated 25.03.2021 12:09:40'     | '$$Rov1SalesReturnOrder028515$$'     | 'GR'            | '1,000'        | '$$Rov1SalesReturnOrder028515$$'     | 'SR'               | '$$Rov1SalesReturnOrder028515$$'      |
					| '2'     | '$$Rov2SalesReturn028515$$'     | 'Sales return order 106 dated 25.03.2021 12:10:03'     | '$$Rov3SalesReturnOrder028515$$'     | ''              | '12,000'       | '$$Rov3SalesReturnOrder028515$$'     | 'SR'               | '$$Rov3SalesReturnOrder028515$$'      |
				Then the number of "RowIDInfo" table lines is "равно" "2"
				And I click the button named "FormUndoPosting"	
		And I close all client application windows
	* Create Sales return based on Sales return order(Create button)
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '105'       |
		And I click the button named "FormDocumentSalesReturnGenerate"
		And I click "Ok" button	
		And Delay 1
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"		
		And I click "Show row key" button	
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Store'      | 'Additional analytic'   | 'Stock quantity'   | '#'   | 'Item'    | 'Item key'   | 'Dont calculate row'   | 'Serial lot numbers'   | 'Quantity'   | 'Unit'             | 'Tax amount'   | 'Price'      | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Use goods receipt'   | 'Total amount'   | 'Sales return order'                                 | 'Sales invoice'   | 'Revenue type'    |
			| 'Store 02'   | ''                      | '1,000'            | '1'   | 'Dress'   | 'XS/Blue'    | 'No'                   | ''                     | '1,000'      | 'pcs'              | '79,32'        | '520,00'     | '18%'   | ''                | '440,68'       | 'No'                  | '520,00'         | 'Sales return order 105 dated 25.03.2021 12:09:40'   | ''                | 'Expense'         |
			| 'Store 02'   | ''                      | '36,000'           | '2'   | 'Boots'   | '37/18SD'    | 'No'                   | ''                     | '3,000'      | 'Boots (12 pcs)'   | '3 844,07'     | '8 400,00'   | '18%'   | ''                | '21 355,93'    | 'No'                  | '25 200,00'      | 'Sales return order 105 dated 25.03.2021 12:09:40'   | ''                | 'Expense'         |
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesReturn028515$$" variable
		And I save the current field value as "$$Rov1SalesReturn028515$$"
		And I input "100" text in "Landed cost" field of "ItemList" table	
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2SalesReturn028515$$" variable
		And I save the current field value as "$$Rov2SalesReturn028515$$"
		And I input "100" text in "Landed cost" field of "ItemList" table	
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                         | 'Basis'                                              | 'Row ID'                           | 'Next step'   | 'Quantity'   | 'Basis key'                        | 'Current step'   | 'Row ref'                           |
			| '1'   | '$$Rov1SalesReturn028515$$'   | 'Sales return order 105 dated 25.03.2021 12:09:40'   | '$$Rov1SalesReturnOrder028515$$'   | ''            | '1,000'      | '$$Rov1SalesReturnOrder028515$$'   | 'SR'             | '$$Rov1SalesReturnOrder028515$$'    |
			| '2'   | '$$Rov2SalesReturn028515$$'   | 'Sales return order 105 dated 25.03.2021 12:09:40'   | '$$Rov2SalesReturnOrder028515$$'   | ''            | '36,000'     | '$$Rov2SalesReturnOrder028515$$'   | 'SR'             | '$$Rov2SalesReturnOrder028515$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"

		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn028515$$" variable
		And I delete "$$SalesReturn028515$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn028515$$"
		And I save the window as "$$SalesReturn028515$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And "List" table contains lines
			| 'Number'                         |
			| '$$NumberSalesReturn028515$$'    |
		And I close all client application windows







Scenario: _028534 check totals in the document Sales return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Select Sales Return
		And I go to line in "List" table
		| 'Number'                        |
		| '$$NumberSalesReturn028509$$'   |
		And I select current line in "List" table
	* Check totals in the document Sales return
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"



Scenario: _300511 check connection to SalesReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Form report Related documents
		And I go to line in "List" table
		| 'Number'                        |
		| '$$NumberSalesReturn028509$$'   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows

Scenario: _300512 check Use GR filling from store when create SR based on SI
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '103'       |
		And I select current line in "List" table
	* Create SR and check Use GR filling
		And I click "Sales return" button
		And I click "Ok" button
		And "ItemList" table became equal
			| 'Item'    | 'Item key'   | 'Use goods receipt'    |
			| 'Dress'   | 'M/White'    | 'Yes'                  |
			| 'Boots'   | '36/18SD'    | 'Yes'                  |
			| 'Boots'   | '37/18SD'    | 'Yes'                  |
			| 'Dress'   | 'S/Yellow'   | 'Yes'                  |
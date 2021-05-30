#language: en
@tree
@Positive
@Sales

Functionality: Goods receipt - Sales return

Scenario: _028400 preparation (GR-SR)
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
		When Create catalog Partners objects (Kalipso)
		When Create catalog BusinessUnits objects
	* Tax settings
		When filling in Tax settings for company
	When Create document SalesInvoice objects
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document GoodsReceipt objects (check movements, transaction type - return from customers)
	When Create document GoodsReceipt objects (creation based on, without PO and PI)
	And I execute 1C:Enterprise script at server
		| "Documents.GoodsReceipt.FindByNumber(125).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.GoodsReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"  |

Scenario: _028401 create GR with transaction type return from customer and create Sales return
	* Open form Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
		And I select "Return from customer" exact value from "Transaction type" drop-down list
	* Filling in main info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'|
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Filling in items info
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
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table		
		And I click "Post" button
		And I delete "$$GoodsReceipt028401$$" variable
		And I delete "$$NumberGoodsReceipt028401$$" variable
		And I delete "$$DateGoodsReceipt028401$$" variable
		And I save the window as "$$GoodsReceipt028401$$"
		And I save the value of "Number" field as "$$NumberGoodsReceipt028401$$"
		And I save the value of the field named "Date" as  "$$DateGoodsReceipt028401$$"
	* Check RowID tab
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1GoodsReceipt028401$$" variable
		And I save the current field value as "$$Rov1GoodsReceipt028401$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2GoodsReceipt028401$$" variable
		And I save the current field value as "$$Rov2GoodsReceipt028401$$"
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                        | 'Basis' | 'Row ID'                     | 'Next step' | 'Q'     | 'Basis key' | 'Current step' | 'Row ref'                    |
			| '1' | '$$Rov1GoodsReceipt028401$$' | ''      | '$$Rov1GoodsReceipt028401$$' | 'SR'        | '1,000' | ''          | ''             | '$$Rov1GoodsReceipt028401$$' |
			| '2' | '$$Rov2GoodsReceipt028401$$' | ''      | '$$Rov2GoodsReceipt028401$$' | 'SR'        | '1,000' | ''          | ''             | '$$Rov2GoodsReceipt028401$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I close current window
	* Create SR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'             |
			| '$$NumberGoodsReceipt028401$$' |
		And I click the button named "FormDocumentSalesReturnGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Ok" button	
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Q'     | 'Unit' |
			| 'Trousers' | '38/Yellow' | '2,000' | 'pcs'  |
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                      |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		* Select SI
			And I select current line in "ItemList" table
			And I click choice button of "Sales invoice" attribute in "ItemList" table
			And I go to line in "" table
				| ''              |
				| 'Sales invoice' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Amount' | 'Company'      | 'Currency' | 'Date'                | 'Legal name'      | 'Partner' |
				| '800,00' | 'Main Company' | 'TRY'      | '07.10.2020 01:19:02' | 'Company Kalipso' | 'Kalipso' |
			And I select current line in "List" table			
		And I click "Post" button
		* Check Row ID tab
			And I click "Show row key" button
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1SalesReturn028401$$" variable
			And I save the current field value as "$$Rov1SalesReturn028401$$"
			And "RowIDInfo" table contains lines
				| '#' | 'Key'                       | 'Basis'                  | 'Row ID'                     | 'Next step' | 'Q'     | 'Basis key'                  | 'Current step' | 'Row ref'                    |
				| '1' | '$$Rov1SalesReturn028401$$' | '$$GoodsReceipt028401$$' | '$$Rov1GoodsReceipt028401$$' | ''          | '1,000' | '$$Rov1GoodsReceipt028401$$' | 'SR'           | '$$Rov1GoodsReceipt028401$$' |
				| '2' | '$$Rov1SalesReturn028401$$' | '$$GoodsReceipt028401$$' | '$$Rov2GoodsReceipt028401$$' | ''          | '1,000' | '$$Rov2GoodsReceipt028401$$' | 'SR'           | '$$Rov2GoodsReceipt028401$$' |
			Then the number of "RowIDInfo" table lines is "равно" "2"
		And I delete "$$SalesReturn028401$$" variable
		And I delete "$$NumberSalesReturn028401$$" variable
		And I delete "$$DateSalesReturn028401$$" variable
		And I save the window as "$$SalesReturn028401$$"
		And I save the value of "Number" field as "$$NumberSalesReturn028401$$"
		And I save the value of the field named "Date" as  "$$DateSalesReturn028401$$"
		And I close current window
		

Scenario: _028402 check link/unlink when add items to Sales return from GR
	* Save GR Row key 
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '125'|
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1GoodsReceipt28402$$" variable
		And I save the current field value as "$$Rov1GoodsReceipt28402$$"
		And I close all client application windows
	* Open form Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Filling in main info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'|
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, without VAT'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table	
	* Add items
		And I click the button named "AddBasisDocuments"
		And "BasisesTree" table does not contain lines
			| 'Row presentation'                           | 'Use'                                        |
			| 'Goods receipt 12 dated 02.03.2021 12:16:02' | 'Goods receipt 12 dated 02.03.2021 12:16:02' |
		And "BasisesTree" table contains lines
			| 'Row presentation'                            | 'Use'                                         |
			| 'Goods receipt 125 dated 12.03.2021 08:56:32' | 'Goods receipt 125 dated 12.03.2021 08:56:32' |
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| '2,000'    | 'Dress, XS/Blue'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Save" button		
		And I click "Show row key" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Unit' | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'pcs'  | 'Store 02' |
		Then the number of "ItemList" table lines is "равно" "1"
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1SalesReturn28402$$" variable
		And I save the current field value as "$$Rov1SalesReturn28402$$"
		And "GoodsReceiptsTree" table contains lines
			| 'Key'                      | 'Basis key'                 | 'Item'  | 'Item key' | 'Goods receipt'                               | 'Invoice' | 'GR'    | 'Q'     |
			| '$$Rov1SalesReturn28402$$' | ''                          | 'Dress' | 'XS/Blue'  | ''                                            | '2,000'   | '2,000' | '2,000' |
			| '$$Rov1SalesReturn28402$$' | '$$Rov1GoodsReceipt28402$$' | ''      | ''         | 'Goods receipt 125 dated 12.03.2021 08:56:32' | ''        | '2,000' | '2,000' |
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                      | 'Basis'                                       | 'Row ID'                    | 'Next step' | 'Q'     | 'Basis key'                 | 'Current step' | 'Row ref'                   |
			| '1' | '$$Rov1SalesReturn28402$$' | 'Goods receipt 125 dated 12.03.2021 08:56:32' | '$$Rov1GoodsReceipt28402$$' | ''          | '2,000' | '$$Rov1GoodsReceipt28402$$' | 'SR'           | '$$Rov1GoodsReceipt28402$$' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
	* Unlink line and check RowId tab
		And I click the button named "LinkUnlinkBasisDocuments"
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                            |
			| 'Goods receipt 125 dated 12.03.2021 08:56:32' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ResultsTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' |
			| '2,000'    | 'Dress, XS/Blue'   | 'pcs'  |
		And I click "Unlink" button
		And I click "Ok" button
		Then the number of "GoodsReceiptsTree" table lines is "равно" "0"
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                      | 'Basis' | 'Row ID'                   | 'Next step' | 'Q'     | 'Basis key' | 'Current step' | 'Row ref'                  |
			| '1' | '$$Rov1SalesReturn28402$$' | ''      | '$$Rov1SalesReturn28402$$' | 'GR'        | '2,000' | ''          | ''             | '$$Rov1SalesReturn28402$$' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
	* Link line and check RowId tab
		And I click the button named "LinkUnlinkBasisDocuments"
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' |
			| '2,000'    | 'Dress, XS/Blue'   | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And "GoodsReceiptsTree" table contains lines
			| 'Key'                      | 'Basis key'                 | 'Item'  | 'Item key' | 'Goods receipt'                               | 'Invoice' | 'GR'    | 'Q'     |
			| '$$Rov1SalesReturn28402$$' | ''                          | 'Dress' | 'XS/Blue'  | ''                                            | '2,000'   | '2,000' | '2,000' |
			| '$$Rov1SalesReturn28402$$' | '$$Rov1GoodsReceipt28402$$' | ''      | ''         | 'Goods receipt 125 dated 12.03.2021 08:56:32' | ''        | '2,000' | '2,000' |
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                      | 'Basis'                                       | 'Row ID'                    | 'Next step' | 'Q'     | 'Basis key'                 | 'Current step' | 'Row ref'                   |
			| '1' | '$$Rov1SalesReturn28402$$' | 'Goods receipt 125 dated 12.03.2021 08:56:32' | '$$Rov1GoodsReceipt28402$$' | ''          | '2,000' | '$$Rov1GoodsReceipt28402$$' | 'SR'           | '$$Rov1GoodsReceipt28402$$' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I close all client application windows
		
				

	
		
				

		
				
	
				

	



	
		
	
		
					
				
		
				


	



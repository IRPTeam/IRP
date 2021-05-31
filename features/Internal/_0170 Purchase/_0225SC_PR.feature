#language: en
@tree
@Positive
@Purchase

Functionality: Shipment confirmation - Purchase return



Scenario: _022500 preparation (SC-PR)
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
		When Create document PurchaseInvoice objects
		When Create catalog PriceTypes objects
		When Create document ShipmentConfirmation objects (check movements, SC-PR)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(233).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document ShipmentConfirmation objects (creation based on, without SO and SI)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(17).GetObject().Write(DocumentWriteMode.Posting);" |



Scenario: _022501 create SC with transaction type return to vendor and create Purchase return
	* Open form SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I select "Return to vendor" exact value from "Transaction type" drop-down list
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
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Filling in items info
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'L/Green' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table	
		And I click "Post" button
		And I delete "$$ShipmentConfirmation022501$$" variable
		And I delete "$$NumberShipmentConfirmation022501$$" variable
		And I delete "$$DateShipmentConfirmation022501$$" variable
		And I save the window as "$$ShipmentConfirmation022501$$"
		And I save the value of "Number" field as "$$NumberShipmentConfirmation022501$$"
		And I save the value of the field named "Date" as  "$$DateShipmentConfirmation022501$$"
	* Check RowID tab
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1ShipmentConfirmation022501$$" variable
		And I save the current field value as "$$Rov1ShipmentConfirmation022501$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2ShipmentConfirmation022501$$" variable
		And I save the current field value as "$$Rov2ShipmentConfirmation022501$$"
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                                | 'Basis' | 'Row ID'                             | 'Next step' | 'Q'     | 'Basis key' | 'Current step' | 'Row ref'                            |
			| '1' | '$$Rov1ShipmentConfirmation022501$$' | ''      | '$$Rov1ShipmentConfirmation022501$$' | 'PR'        | '5,000' | ''          | ''             | '$$Rov1ShipmentConfirmation022501$$' |
			| '2' | '$$Rov2ShipmentConfirmation022501$$' | ''      | '$$Rov2ShipmentConfirmation022501$$' | 'PR'        | '5,000' | ''          | ''             | '$$Rov2ShipmentConfirmation022501$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I close current window
	* Create PR
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberShipmentConfirmation022501$$'    |
		And I click the button named "FormDocumentPurchaseReturnGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "BasisesTree" table
		And I click "Ok" button	
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Q'     | 'Unit' |
			| 'Trousers' | '36/Yellow' | '5,000' | 'pcs'  |
			| 'Dress'    | 'L/Green'   | '5,000' | 'pcs'  |
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                      |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		* Select PI
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'     | 'Store'    | 'Unit' |
				| 'Dress' | 'L/Green'  | '5,000' | 'Store 02' | 'pcs'  |
			And I click choice button of "Purchase invoice" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Company'      | 'Currency' | 'Date'                | 'Legal name'      | 'Partner' |
				| 'Main Company' | 'TRY'      | '07.09.2020 17:53:38' | 'Company Ferron BP' | 'Ferron BP' |
			And I select current line in "List" table	
		* Check Row ID tab
			And I click "Show row key" button
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov1PurchaseReturn022501$$" variable
			And I save the current field value as "$$Rov1PurchaseReturn022501$$"
			And I go to line in "ItemList" table
				| '#' |
				| '2' |
			And I activate "Key" field in "ItemList" table
			And I delete "$$Rov2PurchaseReturn022501$$" variable
			And I save the current field value as "$$Rov2PurchaseReturn022501$$"
			And "RowIDInfo" table contains lines
				| '#' | 'Key'                          | 'Basis'                          | 'Row ID'                             | 'Next step' | 'Q'     | 'Basis key'                          | 'Current step' | 'Row ref'                            |
				| '1' | '$$Rov1PurchaseReturn022501$$' | '$$ShipmentConfirmation022501$$' | '$$Rov1ShipmentConfirmation022501$$' | ''          | '5,000' | '$$Rov1ShipmentConfirmation022501$$' | 'PR'           | '$$Rov1ShipmentConfirmation022501$$' |
				| '2' | '$$Rov2PurchaseReturn022501$$' | '$$ShipmentConfirmation022501$$' | '$$Rov2ShipmentConfirmation022501$$' | ''          | '5,000' | '$$Rov2ShipmentConfirmation022501$$' | 'PR'           | '$$Rov2ShipmentConfirmation022501$$' |
			Then the number of "RowIDInfo" table lines is "равно" "2"		
		And I click "Post" button
		And I delete "$$PurchaseReturn022501$$" variable
		And I delete "$$NumberPurchaseReturn022501$$" variable
		And I delete "$$DatePurchaseReturn022501$$" variable
		And I save the window as "$$PurchaseReturn022501$$"
		And I save the value of "Number" field as "$$NumberPurchaseReturn022501$$"
		And I save the value of the field named "Date" as  "$$DatePurchaseReturn022501$$"
		And I close current window


Scenario: _022502 check link/unlink when add items to Purchase return from SC
	* Save SC Row key 
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '233'|
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1ShipmentConfirmation022502$$" variable
		And I save the current field value as "$$Rov1ShipmentConfirmation022502$$"
		And I close all client application windows
	* Open form Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
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
			| 'Vendor Ferron, TRY'     |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table	
	* Add items
		And I click the button named "AddBasisDocuments"
		And "BasisesTree" table does not contain lines
			| 'Row presentation'                                   | 'Use'                                                 |
			| 'Shipment confirmation 17 dated 25.02.2021 16:28:54' | 'Shipment confirmation 17 dated 25.02.2021 16:28:54' |
		And "BasisesTree" table contains lines
			| 'Row presentation'                                   | 'Use'                                                |
			| 'Shipment confirmation 233 dated 14.03.2021 19:22:5' | 'Shipment confirmation 233 dated 14.03.2021 19:22:5' |
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
			| '4,000'    | 'Dress, S/Yellow'   | 'pcs'  | 'No'  |
		And I change "Use" checkbox in "BasisesTree" table
		And I finish line editing in "BasisesTree" table
		And I click "Ok" button
		And I click "Save" button		
		And I click "Show row key" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Unit' | 'Store'    |
			| 'Dress' | 'S/Yellow'  | '4,000' | 'pcs'  | 'Store 02' |
		Then the number of "ItemList" table lines is "равно" "1"
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1PurchaseReturn28402$$" variable
		And I save the current field value as "$$Rov1PurchaseReturn28402$$"
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                         | 'Basis'                                              | 'Row ID'                             | 'Next step' | 'Q'     | 'Basis key'                          | 'Current step' | 'Row ref'                            |
			| '1' | '$$Rov1PurchaseReturn28402$$' | 'Shipment confirmation 233 dated 14.03.2021 19:22:58' | '$$Rov1ShipmentConfirmation022502$$' | ''          | '4,000' | '$$Rov1ShipmentConfirmation022502$$' | 'PR'           | '$$Rov1ShipmentConfirmation022502$$' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And "ShipmentConfirmationsTree" table contains lines
			| 'Key'                         | 'Basis key'                          | 'Item'  | 'Item key' | 'Shipment confirmation'                              | 'Invoice' | 'SC'    | 'Q'     |
			| '$$Rov1PurchaseReturn28402$$' | ''                                   | 'Dress' | 'S/Yellow' | ''                                                   | '4,000'   | '4,000' | '4,000' |
			| '$$Rov1PurchaseReturn28402$$' | '$$Rov1ShipmentConfirmation022502$$' | ''      | ''         | 'Shipment confirmation 233 dated 14.03.2021 19:22:58' | ''        | '4,000' | '4,000' |
		Then the number of "ShipmentConfirmationsTree" table lines is "равно" "2"
	* Unlink line and check RowId tab
		And I click the button named "LinkUnlinkBasisDocuments"
		And I expand a line in "ResultsTree" table
			| 'Row presentation'                            |
			| 'Shipment confirmation 233 dated 14.03.2021 19:22:5' |
		And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
		And I go to line in "ResultsTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' |
			| '4,000'    | 'Dress, S/Yellow'   | 'pcs'  |
		And I click "Unlink" button
		And I click "Ok" button
		Then the number of "ShipmentConfirmationsTree" table lines is "равно" "0"
		And I click "Save" button
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                         | 'Basis' | 'Row ID'                      | 'Next step' | 'Q'     | 'Basis key' | 'Current step' | 'Row ref'                     |
			| '1' | '$$Rov1PurchaseReturn28402$$' | ''      | '$$Rov1PurchaseReturn28402$$' | 'SC'        | '4,000' | ''          | ''             | '$$Rov1PurchaseReturn28402$$' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
	* Link line and check RowId tab
		And I click the button named "LinkUnlinkBasisDocuments"
		Then "Link / unlink document row" window is opened
		And I go to line in "BasisesTree" table
			| 'Quantity' | 'Row presentation' | 'Unit' |
			| '4,000'    | 'Dress, S/Yellow'  | 'pcs'  |
		And I click "Link" button
		And I click "Ok" button
		And "ShipmentConfirmationsTree" table contains lines
			| 'Key'                         | 'Basis key'                          | 'Item'  | 'Item key' | 'Shipment confirmation'                              | 'Invoice' | 'SC'    | 'Q'     |
			| '$$Rov1PurchaseReturn28402$$' | ''                                   | 'Dress' | 'S/Yellow' | ''                                                   | '4,000'   | '4,000' | '4,000' |
			| '$$Rov1PurchaseReturn28402$$' | '$$Rov1ShipmentConfirmation022502$$' | ''      | ''         | 'Shipment confirmation 233 dated 14.03.2021 19:22:58' | ''        | '4,000' | '4,000' |
		And "RowIDInfo" table contains lines
			| '#' | 'Key'                         | 'Basis'                                              | 'Row ID'                             | 'Next step' | 'Q'     | 'Basis key'                          | 'Current step' | 'Row ref'                            |
			| '1' | '$$Rov1PurchaseReturn28402$$' | 'Shipment confirmation 233 dated 14.03.2021 19:22:58' | '$$Rov1ShipmentConfirmation022502$$' | ''          | '4,000' | '$$Rov1ShipmentConfirmation022502$$' | 'PR'           | '$$Rov1ShipmentConfirmation022502$$' |
		Then the number of "RowIDInfo" table lines is "равно" "1"
		And I close all client application windows
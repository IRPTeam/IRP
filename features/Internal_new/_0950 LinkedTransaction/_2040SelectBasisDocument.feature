#language: en
@tree
@Positive
@LinkedTransaction

Feature: buttons for selecting base documents



Background:
	Given I launch TestClient opening script or connect the existing one
	

Scenario: _2040001 preparation 
	* Constants
		When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
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
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Add sales tax
		When Create catalog Taxes objects (Sales tax)
		When Create information register TaxSettings (Sales tax)
		When Create information register Taxes records (Sales tax)
		When add sales tax settings 
	* Creation of a Sales order on Crystal, Basic Partner terms, TRY, Sales invoice before Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I click "List" button			
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme
			And I move to "Other" tab
			And I remove checkbox "Shipment confirmations before sales invoice"
			// And I input "8 007" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 000" text in "Number" field
			And I click "Post" button
			And I save the window as "$$SalesOrder20400011$$"
			And I save the value of "Number" field as "$$NumberSalesOrder20400011$$"
			And I click "Post and close" button
	* * Creation of a Sales order on Crystal, Basic Partner terms, TRY, Shipment confirmation before Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "8,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme and document number
			And I move to "Other" tab
			And I set checkbox "Shipment confirmations before sales invoice"
			// And I input "9 001" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 001" text in "Number" field
			And I click "Post" button
			And I save the window as "$$SalesOrder20400012$$"
			And I save the value of "Number" field as "$$NumberSalesOrder20400012$$"
			And I click "Post and close" button
	* Creation of a Sales order on Crystal, Basic Partner terms, TRY, Sales invoice before Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "4,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme and document number
			And I move to "Other" tab
			And I remove checkbox "Shipment confirmations before sales invoice"
			// And I input "9 002" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 002" text in "Number" field
			And I click "Post" button
			And I save the window as "$$SalesOrder20400013$$"
			And I save the value of "Number" field as "$$NumberSalesOrder20400013$$"
			And I click "Post and close" button
	* Creation of a Sales order on Crystal, Basic Partner terms, without VAT, TRY, Sales invoice before Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "8,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme
			And I move to "Other" tab
			And I remove checkbox "Shipment confirmations before sales invoice"
			// And I input "9 004" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 004" text in "Number" field
			And I click "Post" button
			And I save the window as "$$SalesOrder20400014$$"
			And I save the value of "Number" field as "$$NumberSalesOrder20400014$$"
			And I click "Post and close" button
		* Creation of a Sales order on Crystal, Basic Partner terms, without VAT, TRY, Shipment confirmation before Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "8,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme and document number
			And I move to "Other" tab
			And I remove checkbox "Shipment confirmations before sales invoice"
			// And I input "9 005" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			And I click "Post" button
			And I save the window as "$$SalesOrder20400015$$"
			And I save the value of "Number" field as "$$NumberSalesOrder20400015$$"
			And I click "Post and close" button
	* Create Shipment confirmation on Crystal without Sales order
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I select "Sales" exact value from "Transaction type" drop-down list
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		// And I input "5 607" text in "Number" field
		// Then "1C:Enterprise" window is opened
		// And I click "Yes" button
		// And I input "8 999" text in "Number" field
		And I click "Post" button
		And I save the window as "$$ShipmentConfirmation0400016$$"
		And I save the value of "Number" field as "$$NumberShipmentConfirmation20400016$$"
		And I click "Post and close" button
		And I close all client application windows
	* Create one more Shipment confirmation on Crystal without Sales order
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I select "Sales" exact value from "Transaction type" drop-down list
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		// And I input "5 607" text in "Number" field
		// Then "1C:Enterprise" window is opened
		// And I click "Yes" button
		// And I input "9 000" text in "Number" field
		And I click "Post" button
		And I save the window as "$$ShipmentConfirmation0400017$$"
		And I save the value of "Number" field as "$$NumberShipmentConfirmation20400017$$"
		And I click "Post and close" button
		And I close all client application windows
	* Create Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		Then "Sales orders" window is opened
		And I go to line in "List" table
			| 'Number'                       | 'Partner' |
			| '$$NumberSalesOrder20400012$$' | 'Crystal' |
		And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
		And I move to "Other" tab
		And I click "Post" button
		And I save the window as "$$ShipmentConfirmation20400018$$"
		And I save the value of "Number" field as "$$NumberShipmentConfirmation20400018$$"
		And I click "Post and close" button
		And I close all client application windows
	* Creating Purchase order to Crystal by agreement Vendor, TRY, Goods receipt before Purchase invoice №9000
		* Open form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in status
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Crystal   |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor, TRY |
			And I select current line in "List" table
		// * Change document number to №9000
			And I move to "Other" tab
			And I remove checkbox "Goods receipt before purchase invoice"
			// And I input "9 000" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 000" text in "Number" field
		* Filling in item tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "250" text in "Price" field of "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "12,000" text in "Q" field of "ItemList" table
			And I input "210" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Post document
			And I click "Post" button
			And I save the window as "$$PurchaseOrder20400019$$"
			And I save the value of "Number" field as "$$NumberPurchaseOrder20400019$$"
			And I click "Post and close" button
	* Create Purchase order to Crystal, Vendor, TRY, Goods receipt before Purchase invoice № 9001
		* Open form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in status
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Crystal   |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor, TRY |
			And I select current line in "List" table
		* Filling in item tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "8,000" text in "Q" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "12,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme and document number
			And I move to "Other" tab
			And I set checkbox "Goods receipt before purchase invoice"
			// And I input "9 001" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 001" text in "Number" field
			And I click "Post" button
			And I save the window as "$$PurchaseOrder204000110$$"
			And I save the value of "Number" field as "$$NumberPurchaseOrder204000110$$"
			And I click "Post and close" button
	* Create Purchase order to Crystal, Vendor, USD, Goods receipt before Purchase invoice № 9003
		* Open form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in status
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Crystal   |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor, USD |
			And I select current line in "List" table
		* Filling in item tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I input "990" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme and document number
			And I move to "Other" tab
			// And I input "9 003" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 003" text in "Number" field
			And I click "Post" button
			And I save the window as "$$PurchaseOrder204000111$$"
			And I save the value of "Number" field as "$$NumberPurchaseOrder204000111$$"
			And I click "Post and close" button
	* Create Purchase order to Crystal, Vendor, TRY, Purchase invoice before Goods receipt № 9004
		* Open form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in status
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Crystal   |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor, TRY |
			And I select current line in "List" table
		* Filling in item tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I input "990" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Change document number
			And I move to "Other" tab
			And I remove checkbox "Goods receipt before purchase invoice"
			// And I input "9 004" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 004" text in "Number" field
			And I click "Post" button
			And I save the window as "$$PurchaseOrder204000112$$"
			And I save the value of "Number" field as "$$NumberPurchaseOrder204000112$$"
			And I click "Post and close" button
	* Create Purchase order to Astar, partner term Vendor, TRY, Purchase invoice before Goods receipt № 9005
		* Open form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in status
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Astar   |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor, TRY |
			And I select current line in "List" table
		* Filling in item tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I input "990" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Change document number
			And I move to "Other" tab
			And I remove checkbox "Goods receipt before purchase invoice"
			// And I input "9 005" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 005" text in "Number" field
			And I click "Post" button
			And I save the window as "$$PurchaseOrder204000113$$"
			And I save the value of "Number" field as "$$NumberPurchaseOrder204000113$$"
			And I click "Post and close" button
	* Create Purchase order to Astar partner term Vendor, TRY, Purchase invoice before Goods receipt, one Store use Goods receipt the other does not № 9002
		* Open form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in status
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Astar   |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor, TRY |
			And I select current line in "List" table
		* Filling in item tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "3,000" text in "Q" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '36/18SD'  |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Boots (12 pcs)' |
			And I select current line in "List" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I input "990" text in "Price" field of "ItemList" table
			And I click choice button of "Store" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'    |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I click choice button of "Store" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'    |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Change document number
			And I move to "Other" tab
			And I remove checkbox "Goods receipt before purchase invoice"
			// And I input "9 002" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 002" text in "Number" field
			And I click "Post" button
			And I save the window as "$$PurchaseOrder204000114$$"
			And I save the value of "Number" field as "$$NumberPurchaseOrder204000114$$"
			And I click "Post and close" button
	* Create Purchase order to Astar partner term Vendor, TRY, Goods receipt before Purchase invoice, one Store use Goods receipt the other does not № 9002
		* Open form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in status
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Astar   |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor, TRY |
			And I select current line in "List" table
		* Filling in item tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I input "8,000" text in "Q" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/Yellow'  |
			And I select current line in "List" table
			And I input "12,000" text in "Q" field of "ItemList" table
			And I input "300" text in "Price" field of "ItemList" table
			And I click choice button of "Store" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'    |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Specify shipping scheme and document number
			And I move to "Other" tab
			And I set checkbox "Goods receipt before purchase invoice"
			// And I input "9 006" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "9 006" text in "Number" field
			And I click "Post" button
			And I save the window as "$$PurchaseOrder204000115$$"
			And I save the value of "Number" field as "$$NumberPurchaseOrder204000115$$"
			And I click "Post and close" button




Scenario: _2040002 Sales order selection button in the Sales invoice document
# works to select Sales order when Sales invoice before Shipment confirmation. Selection by agreement, partner, legal name, company. Displays uncovered documents
	* Open a creation form SI 
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
	* Select Sales order
		And in the table "ItemList" I click "Select sales orders" button
		And "DocumentsTree" table contains lines
		| 'Sales order'                                 | 'Use' |
		| '$$SalesOrder20400011$$'                          | 'No'  |
		| 'Shirt, 38/Black, pcs, 2,000'                 | 'No'  |
		| 'Boots, 36/18SD, Boots (12 pcs), 1,000'       | 'No'  |
		| 'Boots, 37/18SD, pcs, 1,000'                  | 'No'  |
		| '$$SalesOrder20400013$$'                          | 'No'  |
		| 'Dress, M/White, pcs, 4,000'                  | 'No'  |
		| 'Boots, 36/18SD, Boots (12 pcs), 1,000'       | 'No'  |
		| 'Boots, 37/18SD, pcs, 1,000'                  | 'No'  |
		And I click the button named "FormSelectAll"
		And I click "Ok" button
		And "ItemList" table contains lines
		| 'Item'  | 'Item key' | 'Q'     | 'Price type'        | 'Unit'           | 'Store'    | 'Sales order'        |
		| 'Shirt' | '38/Black' | '2,000' | 'Basic Price Types' | 'pcs'            | 'Store 02' | '$$SalesOrder20400011$$' |
		| 'Boots' | '36/18SD'  | '1,000' | 'Basic Price Types' | 'Boots (12 pcs)' | 'Store 02' | '$$SalesOrder20400011$$' |
		| 'Boots' | '37/18SD'  | '1,000' | 'Basic Price Types' | 'pcs'            | 'Store 02' | '$$SalesOrder20400011$$' |
		| 'Dress' | 'M/White'  | '4,000' | 'Basic Price Types' | 'pcs'            | 'Store 02' | '$$SalesOrder20400013$$' |
		| 'Boots' | '36/18SD'  | '1,000' | 'Basic Price Types' | 'Boots (12 pcs)' | 'Store 02' | '$$SalesOrder20400013$$' |
		Then the number of "ItemList" table lines is "меньше или равно" 6
	* Check that the quantity already added by rows is not available to select products from Sales order
		And I go to the last line in "ItemList" table
		# | 'Item'  | 'Item key' | 'Sales order'        |
		# | 'Boots' | '37/18SD'  | '$$SalesOrder20400013$$' |
		And I delete a line in "ItemList" table
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key' | 'Q'     |
		| 'Dress' | 'M/White'  | '4,000' |
		And I select current line in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Select sales orders" button
		And "DocumentsTree" table contains lines
		| 'Sales order'                | 'Use' |
		| '$$SalesOrder20400013$$'         | 'No'  |
		| 'Dress, M/White, pcs, 2,000' | 'No'  |
		| 'Boots, 37/18SD, pcs, 1,000' | 'No'  |
		And I click "Cancel" button
	// * Change the document number
	// 	And I move to "Other" tab
	// 	And I input "0" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "9 000" text in "Number" field
		And I click "Post" button
		And I save the window as "$$SalesInvoice20400022$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice20400022$$"
		And I click "Post and close" button
	* Create one more Sales invoice for the remainder
		* Open a creation form SI 
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
		* Select Sales order
			And in the table "ItemList" I click "Select sales orders" button
			And "DocumentsTree" table contains lines
			| 'Sales order'                | 'Use' |
			| '$$SalesOrder20400013$$'         | 'No'  |
			| 'Dress, M/White, pcs, 2,000' | 'No'  |
			| 'Boots, 37/18SD, pcs, 1,000' | 'No'  |
			And I click the button named "FormSelectAll"
			And I click "Ok" button
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "9 002" text in "Number" field
			And I click "Post" button
			And I save the window as "$$SalesInvoice2040002$$"
			And I save the value of "Number" field as "$$NumberSalesInvoice2040002$$"
			And I click "Post and close" button
	* Create Sales invoice by partner term Basic Partner terms, without VAT
		* Open a creation form SI 
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
		* Select Sales order
			And in the table "ItemList" I click "Select sales orders" button
			And "DocumentsTree" table contains lines
			| 'Sales order'                           | 'Use' |
			| '$$SalesOrder20400014$$'                    | 'No'  |
			| 'Dress, M/White, pcs, 8,000'            | 'No'  |
			| 'Boots, 36/18SD, Boots (12 pcs), 1,000' | 'No'  |
			| 'Boots, 37/18SD, pcs, 1,000'            | 'No'  |
			| '$$SalesOrder20400015$$'                    | 'No'  |
			| 'Dress, S/Yellow, pcs, 8,000'           | 'No'  |
			| 'Boots, 36/18SD, Boots (12 pcs), 1,000' | 'No'  |
			| 'Boots, 37/18SD, pcs, 1,000'            | 'No'  |
			And I click the button named "FormSelectAll"
			And I click "Ok" button
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "9 003" text in "Number" field
			And I click "Post" button
			And I save the window as "$$SalesInvoice20400021$$"
			And I save the value of "Number" field as "$$NumberSalesInvoice20400021$$"
			And I click "Post and close" button


Scenario: _2040003 selection button Shipment confirmation in Sales invoice document
# works to select Shipment confirmation when Shipment confirmation before Sales invoice. Selection by partner, legal name, company. Displays uncovered documents
	* Open a creation form SI 
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
	* Check Shippment confirmation by partner terms
		And in the table "ItemList" I click "Select shipment confirmations" button
		And I click the button named "FormSelectAll"
		And "ShipmentConfirmationsTree" table contains lines
			| 'Order'                           | 'Use'                          |
			| ''                                | ''                             |
			| '$$ShipmentConfirmation0400016$$' | 'Yes'                          |
			| 'Shirt, 38/Black, pcs, 10,000'    | 'Shirt, 38/Black, pcs, 10,000' |
			| '$$ShipmentConfirmation0400017$$' | 'Yes'                          |
			| 'Dress, M/White, pcs, 10,000'     | 'Dress, M/White, pcs, 10,000'  |
		And I click "Ok" button
		Then the number of "ItemList" table lines is "меньше или равно" 2
		* Change of agreement and check of selection
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           | 'Kind'    |
				| 'Basic Partner terms, TRY' | 'Regular' |
			And I select current line in "List" table
			And I change checkbox "Do you want to update filled stores on Store 01?"
			And I change checkbox "Do you want to update filled price types on Basic Price Types?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
		And in the table "ItemList" I click "Select shipment confirmations" button
		And "ShipmentConfirmationsTree" table contains lines
		| 'Order'                            | 'Use'                         |
		| '$$SalesOrder20400012$$'           | '$$SalesOrder20400012$$'      |
		| '$$ShipmentConfirmation20400018$$' | 'No'                          |
		| 'Dress, S/Yellow, pcs, 8,000'      | 'Dress, S/Yellow, pcs, 8,000' |
		| 'Boots, 36/18SD, pcs, 12,000'      | 'Boots, 36/18SD, pcs, 12,000' |
		| 'Boots, 37/18SD, pcs, 1,000'       | 'Boots, 37/18SD, pcs, 1,000'  |
		And I click "Ok" button
		Then the number of "ItemList" table lines is "меньше или равно" 5
		And I close all client application windows


Scenario: _2040004 selection of base documents in line in the Shipment confirmation
	* Open a creation form SC
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Filling the document header
		And I select "Sales" exact value from "Transaction type" drop-down list
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Store 02' |
		And I select current line in "List" table
	* Filling in item tab
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Shipment basis" field in "ItemList" table
		And I select current line in "ItemList" table
		When I Check the steps for Exception
		|'And I click choice button of "Shipment basis" attribute in "ItemList" table'|
		Then "Select Receipt basises" window is opened
		And "DocumentsTree" table contains lines
			| 'Currency'                             |
			| '$$SalesInvoice20400021$$'                 |
			| 'Dress, M/White, pcs, 8,000, Store 02' |
			| '$$SalesInvoice20400022$$*'                 |
			| 'Dress, M/White, pcs, 2,000, Store 02' |
			| '$$SalesInvoice2040002$$'                 |
			| 'Dress, M/White, pcs, 2,000, Store 02' |
		And I go to the last line in "DocumentsTree" table
		And I select current line in "DocumentsTree" table
		And I finish line editing in "ItemList" table
	* Check for product selections when adding a line
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'S/Yellow'  |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Shipment basis" field in "ItemList" table
		And I select current line in "ItemList" table
		When I Check the steps for Exception
		|'And I click choice button of "Shipment basis" attribute in "ItemList" table'|
		And "DocumentsTree" table contains lines
			| 'Currency'                              |
			| '$$SalesInvoice20400021$$'                  |
			| 'Dress, S/Yellow, pcs, 8,000, Store 02' |
		And "DocumentsTree" table does not contain lines
			| 'Currency'                              |
			| '$$SalesInvoice2040002$$'                  |
			| 'Dress, M/White, pcs, 2,000, Store 02' |
		And I go to the last line in "DocumentsTree" table
		And I select current line in "DocumentsTree" table
		And I finish line editing in "ItemList" table
	And I close all client application windows




Scenario: _2040005 purchase order selection button in Purchase invoice document
# works to select Purchase order when Purchase invoice before Goods receipt. Selection by agreement, partner, legal name, company. Displays uncovered documents
	* Open a creation form PI 
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor, TRY' |
		And I select current line in "List" table
	* Select Purchase order
		And I click "Select purchase orders" button
		And "DocumentsTree" table contains lines
		| 'Purchase order'                        |
		| '$$PurchaseOrder20400019$$'                 |
		| 'Dress, M/White, pcs, 10,000'           |
		| 'Trousers, 36/Yellow, pcs, 12,000'      |
		| '$$PurchaseOrder204000112$$'                 |
		| 'Dress, M/White, pcs, 3,000'            |
		| 'Trousers, 36/Yellow, pcs, 10,000'      |
		| 'Trousers, 36/Yellow, pcs, 5,000'       |
		| 'Boots, 36/18SD, Boots (12 pcs), 5,000' |
		And I click the button named "FormSelectAll"
		And I click "Ok" button
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Q'      | 'Unit'           |
		| 'Dress'    | 'M/White'   | '10,000' | 'pcs'            |
		| 'Trousers' | '36/Yellow' | '12,000' | 'pcs'            |
		| 'Dress'    | 'M/White'   | '3,000'  | 'pcs'            |
		| 'Trousers' | '36/Yellow' | '10,000' | 'pcs'            |
		| 'Trousers' | '36/Yellow' | '5,000'  | 'pcs'            |
		| 'Boots'    | '36/18SD'   | '5,000'  | 'Boots (12 pcs)' |
		Then the number of "ItemList" table lines is "меньше или равно" 6
	* Check that the quantity already added by rows is not available for selecting products from Purchase order
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key' | 'Q'        |
		| 'Dress' | 'M/White'  | '3,000' |
		And I delete a line in "ItemList" table
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key' | 'Q'     |
		| 'Boots' | '36/18SD'  | '5,000' |
		And I select current line in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Select purchase orders" button
		And "DocumentsTree" table contains lines
		| 'Purchase order'                        |
		| '$$PurchaseOrder204000112$$'                 |
		| 'Dress, M/White, pcs, 3,000'            |
		| 'Boots, 36/18SD, Boots (12 pcs), 3,000' |
		And I click "Cancel" button
	// * Change the document number
	// 	And I move to "Other" tab
	// 	And I input "0" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "9 000" text in "Number" field
		And I click "Post" button
		And I save the window as "$$PurchaseInvoice2040005$$"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice2040005$$"
		And I click "Post and close" button
	* Create one more Purchase invoice for the remainder
		* Open a creation form SI 
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Vendor, TRY' |
			And I select current line in "List" table
		* Select Purchase order
			And I click "Select purchase orders" button
			And "DocumentsTree" table contains lines
			| 'Purchase order'                        |
			| '$$PurchaseOrder204000112$$'            |
			| 'Dress, M/White, pcs, 3,000'            |
			| 'Boots, 36/18SD, Boots (12 pcs), 3,000' |
			And I click the button named "FormSelectAll"
			And I click "Ok" button
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "9 001" text in "Number" field
			And I click "Post" button
			And I save the window as "$$PurchaseInvoice20400051$$"
			And I save the value of "Number" field as "$$NumberPurchaseInvoice20400051$$"
			And I click "Post and close" button
	* Create Purchase invoice to Astar by partner term 'Vendor, TRY'
		* Open a creation form PI 
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
		* Filling the document header
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Astar'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Vendor, TRY' |
			And I select current line in "List" table
		* Select Purchase order
			And I click "Select purchase orders" button
			And "DocumentsTree" table contains lines
			| 'Purchase order'                        |
			| '$$PurchaseOrder204000114$$'                 |
			| 'Trousers, 36/Yellow, pcs, 10,000'      |
			| 'Boots, 36/18SD, Boots (12 pcs), 5,000' |
			| 'Dress, M/White, pcs, 3,000'            |
			| 'Trousers, 36/Yellow, pcs, 5,000'       |
			| '$$PurchaseOrder204000113$$'                 |
			| 'Dress, M/White, pcs, 3,000'            |
			| 'Trousers, 36/Yellow, pcs, 5,000'       |
			| 'Trousers, 36/Yellow, pcs, 10,000'      |
			| 'Boots, 36/18SD, Boots (12 pcs), 5,000' |
			And I click the button named "FormSelectAll"
			And I click "Ok" button
			Then the number of "ItemList" table lines is "меньше или равно" 8
			And I go to the last line in "ItemList" table
			And I delete a line in "ItemList" table
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "9 003" text in "Number" field
			And I click "Post" button
			And I save the window as "$$PurchaseInvoice20400052$$"
			And I save the value of "Number" field as "$$NumberPurchaseInvoice20400052$$"
			And I click "Post and close" button

Scenario: _2040006 button for filling items from the base documents in Goods receipt
	# No verification by partner term. A currency check is triggered when posted. There is no check at the store.
	* Open a creation form GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Filling the document header
		And I select "Purchase" exact value from "Transaction type" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main company'     |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'     |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Company Adel' |
		And I select current line in "List" table
	* Check button Fill 'From basises'
		And I click "From basises" button
		And "DocumentsTree" table contains lines
		| 'Currency'                                         |
		| 'TRY'                                              |
		| '$$PurchaseInvoice2040005$$'                          |
		| 'Dress, M/White, pcs, 10,000, Store 02'            |
		| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
		| 'Trousers, 36/Yellow, pcs, 10,000, Store 02'       |
		| 'Trousers, 36/Yellow, pcs, 12,000, Store 02'       |
		| 'Boots, 36/18SD, Boots (12 pcs), 24,000, Store 02' |
		| '$$PurchaseInvoice20400051$$'                          |
		| 'Dress, M/White, pcs, 3,000, Store 02'             |
		| 'Boots, 36/18SD, Boots (12 pcs), 36,000, Store 02' |
		| '$$PurchaseOrder204000110$$'                            |
		| 'Dress, M/White, pcs, 8,000, Store 02'             |
		| 'Trousers, 36/Yellow, pcs, 12,000, Store 02'       |
		| 'USD'                                              |
		| '$$PurchaseOrder204000111$$'                            |
		| 'Dress, M/White, pcs, 3,000, Store 02'             |
		| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
		| 'Boots, 36/18SD, Boots (12 pcs), 60,000, Store 02' |
		And I click the button named "FormSelectAll"
		And I click "Ok" button
		Then the number of "ItemList" table lines is "меньше или равно" 11
	// * Change the document number
	// 	And I move to "Other" tab
	// 	And I input "0" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "9 000" text in "Number" field
	* Check the display of an error that GR documents with different currencies are selected in GR
		And I click "Post" button
		And I save the window as "$$GoodsReceipt2040006$$"
		And I save the value of "Number" field as "$$NumberGoodsReceipt2040006$$"
		Then I wait that in user messages the "Currencies in the base documents must match." substring will appear in 30 seconds
	* Post with the same currency
		And I move to "Items" tab
		And I go to line in "ItemList" table
			| 'Currency' | 'Item'  | 'Item key' | 'Quantity' | 'Store'    | 'Unit' |
			| 'USD'      | 'Dress' | 'M/White'  | '3,000'    | 'Store 02' | 'pcs'  |
		And I delete a line in "ItemList" table
		And I go to line in "ItemList" table
			| 'Currency' | 'Item'     | 'Item key'  | 'Quantity' | 'Store'    | 'Unit' |
			| 'USD'      | 'Trousers' | '36/Yellow' | '5,000'    | 'Store 02' | 'pcs'  |
		And I delete a line in "ItemList" table
		And I go to line in "ItemList" table
			| 'Currency' | 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
			| 'USD'      | 'Boots' | '36/18SD'  | '60,000'   | 'Store 02' |
		And I delete a line in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Check that the quantity already added by lines is not available for the choice of goods from the bases documents
		And I go to line in "ItemList" table
		| 'Item'     | 'Item key' | 'Quantity'        |
		| 'Trousers' | '36/Yellow'  | '10,000' |
		And I delete a line in "ItemList" table
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key' | 'Quantity'     |
		| 'Boots' | '36/18SD'  | '60,000' |
		And I select current line in "ItemList" table
		And I input "24,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "From basises" button
		And "DocumentsTree" table contains lines
		| 'Currency'                                         | 'Use' |
		| 'TRY'                                              | 'No'  |
		| '$$PurchaseInvoice2040005$$'                          | 'No'  |
		| 'Trousers, 36/Yellow, pcs, 10,000, Store 02'       | 'No'  |
		| 'Boots, 36/18SD, Boots (12 pcs), 22,000, Store 02' | 'No'  |
		| '$$PurchaseInvoice20400051$$'                          | 'No'  |
		| 'Boots, 36/18SD, Boots (12 pcs), 36,000, Store 02' | 'No'  |
		Then the number of "DocumentsTree" table lines is "меньше или равно" 11
		And I click "Cancel" button
		And I click "Post and close" button
	* Create one more Goods receipt for the remainder
		* Open a creation form GR
			Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
			And I click the button named "FormCreate"
		* Filling the document header
			And I select "Purchase" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'MAin company'     |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Crystal'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Adel' |
			And I select current line in "List" table
		* Select basis documents
			And I click "From basises" button
			And "DocumentsTree" table contains lines
			| 'Currency'                                         |
			| 'TRY'                                              |
			| '$$PurchaseInvoice2040005$$'                          |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
			| 'Boots, 36/18SD, Boots (12 pcs), 24,000, Store 02' |
			| 'USD'                                              |
			| '$$PurchaseOrder204000111$$'                            |
			| 'Dress, M/White, pcs, 3,000, Store 02'             |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'        |
			| 'Boots, 36/18SD, Boots (12 pcs), 60,000, Store 02' |
			And I click the button named "FormSelectAll"
			And I click "Ok" button
		* Delete lines in dollars
			And I move to "Items" tab
			And I go to line in "ItemList" table
				| 'Currency' | 'Item'  | 'Item key' | 'Quantity' | 'Store'    | 'Unit' |
				| 'USD'      | 'Dress' | 'M/White'  | '3,000'    | 'Store 02' | 'pcs'  |
			And I delete a line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Currency' | 'Item'     | 'Item key'  | 'Quantity' | 'Store'    | 'Unit' |
				| 'USD'      | 'Trousers' | '36/Yellow' | '5,000'    | 'Store 02' | 'pcs'  |
			And I delete a line in "ItemList" table
			And I go to line in "ItemList" table
				| 'Currency' | 'Item'  | 'Item key' | 'Quantity' | 'Store'    |
				| 'USD'      | 'Boots' | '36/18SD'  | '60,000'   | 'Store 02' |
			And I delete a line in "ItemList" table
		# temporarily
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Quantity' |
				| 'Boots' | '36/18SD'  | '24,000'   |
			And I click choice button of the attribute named "ItemListUnit" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'pcs'         |
			And I select current line in "List" table
		# temporarily
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "9 001" text in "Number" field
			And I click "Post" button
			And I save the window as "$$GoodsReceipt20400061$$"
			And I save the value of "Number" field as "$$NumberGoodsReceipt20400061$$"
			And I click "Post and close" button
	
Scenario: _2040007 button for filling in base documents in Goods receipt
	* Open a creation form GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt20400061$$'     |
		And I select current line in "List" table
	* Cleaning of base documents
		And I go to the first line in "ItemList" table
		And I click Clear button of "Receipt basis" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to the next line in "ItemList" table
		And I click Clear button of "Receipt basis" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Fill in the base documents using the Fill receipt basises button
		And I click "Fill receipt basises" button
	* Filling check
		And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Store'    | 'Unit' | 'Receipt basis'           |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'Store 02' | 'pcs'  | '$$PurchaseOrder204000111$$'   |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'Store 02' | 'pcs'  | '$$PurchaseInvoice2040005$$' |
			| 'Boots'    | '24,000'   | '36/18SD'   | 'Store 02' | 'pcs'  | '$$PurchaseOrder204000111$$'   |
	* Filling line by line
		And I go to the first line in "ItemList" table
		And I click Clear button of "Receipt basis" attribute in "ItemList" table
		And I click choice button of "Receipt basis" attribute in "ItemList" table
		And "DocumentsTree" table contains lines
			| 'Currency'                                    |
			| 'USD'                                         |
			| '$$PurchaseOrder204000111$$'                       |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'   |
			| 'TRY'                                         |
			| '$$PurchaseInvoice2040005$$'                     |
			| 'Trousers, 36/Yellow, pcs, 5,000, Store 02'   |
		And I go to the last line in "DocumentsTree" table
		And I move one line up in "DocumentsTree" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Currency' | 'Item key'  | 'Store'    | 'Unit' | 'Receipt basis'           |
			| 'Trousers' | '5,000'    | 'TRY'      | '36/Yellow' | 'Store 02' | 'pcs'  | '$$PurchaseInvoice2040005$$' |
			| 'Trousers' | '5,000'    | 'TRY'      | '36/Yellow' | 'Store 02' | 'pcs'  | '$$PurchaseInvoice2040005$$' |
			| 'Boots'    | '24,000'   | 'USD'      | '36/18SD'   | 'Store 02' | 'pcs'  | '$$PurchaseOrder204000111$$' |
		And I close all client application windows




Scenario: _2040008 button to fill in items from Goods receipt in Purchase invoice
	* Open a creation form PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Crystal'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor, TRY' |
		And I select current line in "List" table
	* Check the button for filling items from Goods receipt
		And I click "Select goods receipt" button
		And "GoodsReceiptTree" table contains lines
		| 'Order'                            |
		| '$$PurchaseOrder204000110$$'            |
		| '$$GoodsReceipt2040006$$'             |
		| 'Dress, M/White, pcs, 8,000'       |
		| 'Trousers, 36/Yellow, pcs, 12,000' |
		Then the number of "GoodsReceiptTree" table lines is "меньше или равно" 4
		And I click the button named "FormSelectAll"
		And I click "Ok" button
		And I close all client application windows

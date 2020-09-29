#language: en
@tree
@Positive
@Group15
Feature: sales Shipment confirmation - Sales invoice

As a sales manager
I want to create a Shipment confirmation -  Sales invoice
For shipment of items to the customer before the invoice (no price)

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _290000 preparation (Shipment confirmation - Sales invoice)
	* Constants
		When set True value to the constant
	* Load info
		When Create catalog Companies objects (second company Ferron BP)
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
		When Create catalog Partners objects (Ferron BP)
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

Scenario: _0290001 create Shipment confirmation document for the shipment of items to the customer without an order and an invoice

	* Create SC for Nicoletta from store Store 02 (Main company)
		* Open form Shipment confirmation
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I click the button named "FormCreate"
			And I select "Sales" exact value from "Transaction type" drop-down list
		* Filling in Partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main company'   |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
		* Add items
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "4,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
			And I activate "Item" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "8,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
				| 'Dress' | 'XS/Blue'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
				| 'Dress' | 'M/White'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "4,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "2 013" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "5 600" text in "Number" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberShipmentConfirmation0290001$$"
			And I save the window as "$$ShipmentConfirmation0290001$$"
			And I click "Post and close" button
	* Create SC for Nicoletta from Store 03 (Main company)
		* Open Shipment confirmation
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I click the button named "FormCreate"
			And I select "Sales" exact value from "Transaction type" drop-down list
		* Create Partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main company'   |
			And I select current line in "List" table
		* Add items
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "4,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
			And I activate "Item" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "8,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "5 601" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "5 601" text in "Number" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberShipmentConfirmation02900011$$"
			And I save the window as "$$ShipmentConfirmation02900011$$"
			And I click "Post and close" button
	* Create SC for Ferron BP from Store 03 (Company Ferron BP, Main company)
		* OPen Shipment confirmation
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I click the button named "FormCreate"
			And I select "Sales" exact value from "Transaction type" drop-down list
		* Filling in Partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Ferron BP' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main company'   |
			And I select current line in "List" table
		* Add items
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "12,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
			And I activate "Item" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
			And I activate "Item" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "4,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "5 602" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "5 602" text in "Number" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberShipmentConfirmation02900012$$"
			And I save the window as "$$ShipmentConfirmation02900012$$"
			And I click "Post and close" button
	* Create SC for Ferron BP from Store 03 for Second Company Ferron BP (Main company) 
		* Open Shipment confirmation
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I click the button named "FormCreate"
			And I select "Sales" exact value from "Transaction type" drop-down list
		* Filling in Partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'              |
				| 'Second Company Ferron BP' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main company'   |
			And I select current line in "List" table
		* Add items
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "18,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Change the document number
			// And I move to "Other" tab
			// And I input "5 603" text in "Number" field
			// Then "1C:Enterprise" window is opened
			// And I click "Yes" button
			// And I input "5 603" text in "Number" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberShipmentConfirmation02900013$$"
			And I save the window as "$$ShipmentConfirmation02900013$$"
			And I click "Post and close" button
	* Create SC for Ferron BP from Store 03 for Company Ferron BP (Second company)
		* Open Shipment confirmation
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I click the button named "FormCreate"
			And I select "Sales" exact value from "Transaction type" drop-down list
		* Filling in Partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Ferron BP' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'    |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
		* Add items
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "12,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
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
			And I activate "Item" field in "List" table
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		// * Change the document number
		// 	And I move to "Other" tab
		// 	And I input "5 604" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "5 604" text in "Number" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberShipmentConfirmation02900014$$"
			And I save the window as "$$ShipmentConfirmation02900014$$"
			And I click "Post and close" button
	* Create Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And "List" table contains lines
		| 'Number'                                 | 'Company'        |
		| '$$NumberShipmentConfirmation0290001$$'  | 'Main Company'   |
		| '$$NumberShipmentConfirmation02900011$$' | 'Main Company'   |
		| '$$NumberShipmentConfirmation02900012$$' | 'Main Company'   |
		| '$$NumberShipmentConfirmation02900013$$' | 'Main Company'   |
		| '$$NumberShipmentConfirmation02900014$$' | 'Second Company' |

Scenario: _0290002 create Sales invoice based on Shipment confirmation
	# based on several Shipment confirmation creates multiple Sales invoice
	* Open Shipment confirmation list
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Select SC for creating SI 
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberShipmentConfirmation0290001$$'  |
		And I move one line down in "List" table and select line
		And I move one line down in "List" table and select line
		And I move one line down in "List" table and select line
		And I move one line down in "List" table and select line
	* Create SI based on SC
		And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
		* Create first SI
			And I save number of "ItemList" table lines as "M"
			If the field named "Company" is equal to "Second Company" Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Company Ferron BP"
				Then the form attribute named "Store" became equal to "Store 03"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
				* Filling in an Partner term
					And I click Select button of "Partner term" field
					And I go to line in "List" table
						| 'Description'                   |
						| 'Basic Partner terms, without VAT' |
					And I select current line in "List" table
					And I change checkbox "Do you want to update filled stores on Store 02?"
					And I click "OK" button
				* Check tabular part
					And "ItemList" table contains lines
					| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Price type'              | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Shipment confirmation'        |
					| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000'  | 'Basic Price without VAT' | 'pcs'  | '112,71'     | '593,22'     | '705,93'       | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
					| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '12,000' | 'Basic Price without VAT' | 'pcs'  | '772,88'     | '4 067,76'   | '4 840,64'     | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
				And I move to "Other" tab
				And I input "5 604" text in "Number" field
				And I click "Yes" button
				And I input "5 604" text in "Number" field
			If the field named "LegalName" is equal to "Second Company Ferron BP" Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Second Company Ferron BP"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
				| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
				| 'Trousers' | '38/Yellow' | '18,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900013$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, without VAT' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 02?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 600" text in "Number" field
				And I click "Yes" button
				And I input "5 600" text in "Number" field
			If the field named "LegalName" is equal to "Company Nicoletta" Then
				Then the form attribute named "Partner" became equal to "Nicoletta"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Dress'    | 'M/White'   | '4,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Dress'    | 'XS/Blue'   | '2,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900011$$' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900011$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Posting by Standard Partner term Customer' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 01?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 603" text in "Number" field
				And I click "Yes" button
				And I input "5 603" text in "Number" field
			If "M" variable is equal to 3 Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Company Ferron BP"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900012$$' |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900012$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, without VAT' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 02?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 602" text in "Number" field
				And I click "Yes" button
				And I input "5 602" text in "Number" field
			And I click "Post and close" button
		* Create second SI
			And I save number of "ItemList" table lines as "M"
			If the field named "Company" is equal to "Second Company" Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Company Ferron BP"
				Then the form attribute named "Store" became equal to "Store 03"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
				* Filling in an Partner term
					And I click Select button of "Partner term" field
					And I go to line in "List" table
						| 'Description'                   |
						| 'Basic Partner terms, without VAT' |
					And I select current line in "List" table
					And I change checkbox "Do you want to update filled stores on Store 02?"
					And I click "OK" button
				* Check tabular part
					And "ItemList" table contains lines
					| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Price type'              | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Shipment confirmation'        |
					| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000'  | 'Basic Price without VAT' | 'pcs'  | '112,71'     | '593,22'     | '705,93'       | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
					| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '12,000' | 'Basic Price without VAT' | 'pcs'  | '772,88'     | '4 067,76'   | '4 840,64'     | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
				And I move to "Other" tab
				And I input "5 604" text in "Number" field
				And I click "Yes" button
				And I input "5 604" text in "Number" field
			If the field named "LegalName" is equal to "Second Company Ferron BP" Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Second Company Ferron BP"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
				| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
				| 'Trousers' | '38/Yellow' | '18,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900013$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, without VAT' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 02?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 600" text in "Number" field
				And I click "Yes" button
				And I input "5 600" text in "Number" field
			If the field named "LegalName" is equal to "Company Nicoletta" Then
				Then the form attribute named "Partner" became equal to "Nicoletta"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Dress'    | 'M/White'   | '4,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Dress'    | 'XS/Blue'   | '2,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900011$$' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900011$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Posting by Standard Partner term Customer' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 01?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 603" text in "Number" field
				And I click "Yes" button
				And I input "5 603" text in "Number" field
			If "M" variable is equal to 3 Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Company Ferron BP"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900012$$' |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900012$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, without VAT' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 02?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 602" text in "Number" field
				And I click "Yes" button
				And I input "5 602" text in "Number" field
			And I click "Post and close" button
		* Create third SI
			And I save number of "ItemList" table lines as "M"
			If the field named "Company" is equal to "Second Company" Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Company Ferron BP"
				Then the form attribute named "Store" became equal to "Store 03"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
				* Filling in an Partner term
					And I click Select button of "Partner term" field
					And I go to line in "List" table
						| 'Description'                   |
						| 'Basic Partner terms, without VAT' |
					And I select current line in "List" table
					And I change checkbox "Do you want to update filled stores on Store 02?"
					And I click "OK" button
				* Check tabular part
					And "ItemList" table contains lines
					| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Price type'              | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Shipment confirmation'        |
					| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000'  | 'Basic Price without VAT' | 'pcs'  | '112,71'     | '593,22'     | '705,93'       | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
					| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '12,000' | 'Basic Price without VAT' | 'pcs'  | '772,88'     | '4 067,76'   | '4 840,64'     | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
				And I move to "Other" tab
				And I input "5 604" text in "Number" field
				And I click "Yes" button
				And I input "5 604" text in "Number" field
			If the field named "LegalName" is equal to "Second Company Ferron BP" Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Second Company Ferron BP"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
				| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
				| 'Trousers' | '38/Yellow' | '18,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900013$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, without VAT' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 02?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 600" text in "Number" field
				And I click "Yes" button
				And I input "5 600" text in "Number" field
			If the field named "LegalName" is equal to "Company Nicoletta" Then
				Then the form attribute named "Partner" became equal to "Nicoletta"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Dress'    | 'M/White'   | '4,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Dress'    | 'XS/Blue'   | '2,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900011$$' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900011$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Posting by Standard Partner term Customer' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 01?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 603" text in "Number" field
				And I click "Yes" button
				And I input "5 603" text in "Number" field
			If "M" variable is equal to 3 Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Company Ferron BP"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900012$$' |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900012$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, without VAT' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 02?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 602" text in "Number" field
				And I click "Yes" button
				And I input "5 602" text in "Number" field
			And I click "Post and close" button
		* Create fourth SI
			And I save number of "ItemList" table lines as "M"
			If the field named "Company" is equal to "Second Company" Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Company Ferron BP"
				Then the form attribute named "Store" became equal to "Store 03"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
				* Filling in an Partner term
					And I click Select button of "Partner term" field
					And I go to line in "List" table
						| 'Description'                   |
						| 'Basic Partner terms, without VAT' |
					And I select current line in "List" table
					And I change checkbox "Do you want to update filled stores on Store 02?"
					And I click "OK" button
				* Check tabular part
					And "ItemList" table contains lines
					| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Price type'              | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    | 'Shipment confirmation'        |
					| '296,61' | 'Shirt'    | '18%' | '38/Black'  | '2,000'  | 'Basic Price without VAT' | 'pcs'  | '112,71'     | '593,22'     | '705,93'       | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
					| '338,98' | 'Trousers' | '18%' | '38/Yellow' | '12,000' | 'Basic Price without VAT' | 'pcs'  | '772,88'     | '4 067,76'   | '4 840,64'     | 'Store 03' | '$$ShipmentConfirmation02900014$$' |
				And I move to "Other" tab
				And I input "5 604" text in "Number" field
				And I click "Yes" button
				And I input "5 604" text in "Number" field
			If the field named "LegalName" is equal to "Second Company Ferron BP" Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Second Company Ferron BP"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
				| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
				| 'Trousers' | '38/Yellow' | '18,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900013$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, without VAT' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 02?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 600" text in "Number" field
				And I click "Yes" button
				And I input "5 600" text in "Number" field
			If the field named "LegalName" is equal to "Company Nicoletta" Then
				Then the form attribute named "Partner" became equal to "Nicoletta"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Dress'    | 'M/White'   | '4,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Dress'    | 'XS/Blue'   | '2,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 02' | '$$ShipmentConfirmation0290001$$' |
					| 'Trousers' | '38/Yellow' | '4,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900011$$' |
					| 'Shirt'    | '38/Black'  | '8,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900011$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Posting by Standard Partner term Customer' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 01?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 603" text in "Number" field
				And I click "Yes" button
				And I input "5 603" text in "Number" field
			If "M" variable is equal to 3 Then
				Then the form attribute named "Partner" became equal to "Ferron BP"
				Then the form attribute named "LegalName" became equal to "Company Ferron BP"
				Then the form attribute named "Company" became equal to "Main Company"
				And "ItemList" table contains lines
					| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Shipment confirmation'        |
					| 'Trousers' | '38/Yellow' | '12,000' | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900012$$' |
					| 'Shirt'    | '38/Black'  | '2,000'  | 'pcs'  | 'Store 03' | '$$ShipmentConfirmation02900012$$' |
				And I click Select button of "Partner term" field
				And I go to line in "List" table
					| 'Description'                   |
					| 'Basic Partner terms, without VAT' |
				And I select current line in "List" table
				And I change checkbox "Do you want to update filled stores on Store 02?"
				And I click "OK" button
				And I move to "Other" tab
				And I input "5 602" text in "Number" field
				And I click "Yes" button
				And I input "5 602" text in "Number" field
			And I click "Post and close" button

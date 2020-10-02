#language: en
@tree
@Positive
@DocumentVerification

Feature: test filling-in SO - SI




Background:
	Given I launch TestClient opening script or connect the existing one



	
Scenario: _29700101 preparation (test filling-in SO - SI)
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
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
	* Create SO
		When create a test SO for VerificationPosting
	// * Change number SO to 2970
		// And I move to "Other" tab
		// And I input "2970" text in "Number" field
		// Then "1C:Enterprise" window is opened
		// And I click "Yes" button
		// And I input "2970" text in "Number" field
		And I save the value of "Number" field as "$$NumberSalesOrder29700101$$"
		And I save the window as "$$SalesOrder29700101$$"
		And I close all client application windows
		

Scenario: _29700102 test filling-in SO - SI - SC by quantity
	* Select SO 2970
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                       | 'Partner' |
			| '$$NumberSalesOrder29700101$$' | 'Foxred'  |
		And I select current line in "List" table
	* Create SI based on SO
		And I click "Sales invoice" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'      | 'Unit' | 'Store'    | 'Sales order'            |
			| 'Dress' | 'L/Green'  | '20,000' | 'pcs'  | 'Store 02' | '$$SalesOrder29700101$$' |
			| 'Dress' | 'M/White'  | '8,000'  | 'pcs'  | 'Store 02' | '$$SalesOrder29700101$$' |
		* Check the prohibition of holding SI for an amount greater than specified in the order
			* Change in the second row to 12
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				And I select current line in "ItemList" table
				And I input "12,000" text in "Q" field of "ItemList" table
				And I finish line editing in "ItemList" table
			* Check for a ban
				And I click "Post" button
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Then I wait that in user messages the "Line No. [1] [Dress M/White] Ordered remaining: 8 pcs. Required: 12 pcs. Lacking: 4 pcs." substring will appear in 20 seconds
			* Change in quantity to original value
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				And I select current line in "ItemList" table
				And I input "8,000" text in "Q" field of "ItemList" table
				And I finish line editing in "ItemList" table
		* Check the prohibition of holding SI for an amount greater than specified in the order (copy line)	
			* Copy second kine
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'     |
				| 'Dress' | 'M/White'  | '8,000' |
				And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
			* Check for a ban
				And I click "Post" button
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Then I wait that in user messages the "Line No. [1,3] [Dress M/White] Ordered remaining: 8 pcs. Required: 16 pcs. Lacking: 8 pcs." substring will appear in 20 seconds
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Q'     |
					| 'Dress' | 'M/White'  | '8,000' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		* Add an over-order line to the SI and checking post
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
		* Create SI for closing quantity on order
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
				And I click "Post" button
			// * Change the SO number to 2970
				// And I move to "Other" tab
				// And I input "2970" text in "Number" field
				// Then "1C:Enterprise" window is opened
				// And I click "Yes" button
				// And I input "2970" text in "Number" field
				And I save the value of "Number" field as "$$NumberSalesInvoice29700102$$"
				And I save the window as "$$SalesInvoice29700102$$"
				And I click "Post and close" button
				And I close all client application windows
	

Scenario: _29700103 test filling-in SO - SI - SC by quantity (second part)
	* Check the SO unpost when SI is created
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number' | 'Partner' |
		| '$$NumberSalesOrder29700101$$'  | 'Foxred'  |
		And I select current line in "List" table
		And I click "Clear posting" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Dress M/White] Invoiced remaining: 8 pcs. Required: 0 pcs. Lacking: 8 pcs." substring will appear in 20 seconds
		Then I wait that in user messages the "Line No. [2] [Dress L/Green] Invoiced remaining: 20 pcs. Required: 0 pcs. Lacking: 20 pcs." substring will appear in 20 seconds
	* Check for changes in the quantity in SO when SI is created (SI is more than in SO)
		* Change the number in the second line to 19
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '20,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "19,000" text in "Q" field of "ItemList" table
		* Check for a ban
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress L/Green] Invoiced remaining: 20 pcs. Required: 19 pcs. Lacking: 1 pcs." substring will appear in 20 seconds
	* Check for changes in the quantity in SO when SI is created (SI is less than in SO)
		* Change the number in the second line to 21
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '19,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "21,000" text in "Q" field of "ItemList" table
			And I click "Post" button
	* Check post SO with deleted a string when SI is created (SI has this string)
		* Remove the second line
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '21,000' |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		* Check for a ban 
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [] [Dress L/Green] Invoiced remaining: 20 pcs. Required: 0 pcs. Lacking: 20 pcs." substring will appear in 20 seconds
	* Check the addition in SO of a string that has been deleted and that is in the Sales invoice carried out 
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Create one more SI
		* Add line in SO
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
		* Create SI on the added line
			And I click "Sales invoice" button
			# temporarily
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '20,000' |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			# temporarily
			And "ItemList" table contains lines
			| 'Item'     | 'Item key'   |
			| 'Trousers' | '38/Yellow'  |
			And I click "Post" button
			Then user message window does not contain messages
	* Check for a ban SI if you add a line to it (by copying) from an order for which SI has already been created (order by line is specified)
		And I activate "Item key" field in "ItemList" table
		And in the table "ItemList" I click "Copy" button
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key'  |
			| '2' | 'Trousers' | '38/Yellow' |
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [Dress L/Green] Ordered remaining: 0 pcs. Required: 20 pcs. Lacking: 20 pcs." substring will appear in 20 seconds
	* Check post SI if a line is not added to it by order
		And I go to line in "ItemList" table
		| '#' | 'Item'  | 'Item key' |
		| '2' | 'Dress' | 'L/Green'  |
		And in the table "ItemList" I click "Delete" button
		And in the table "ItemList" I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click "Post" button
		Then user message window does not contain messages
		And I close all client application windows
	* Create Shipment confirmation by more than the quantity specified on the invoice
		* Select created SI (2970)
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
			| 'Number' | 'Partner' |
			| '$$NumberSalesInvoice29700102$$'  | 'Foxred'  |
		* Create SC
			And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
			And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Shipment basis'       |
			| 'Dress' | '8,000'    | 'M/White'  | 'pcs'  | 'Store 02' | '$$SalesInvoice29700102$$' |
			| 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | 'Store 02' | '$$SalesInvoice29700102$$' |
		// * Change of document number
		// 	And I move to "Other" tab
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "2 970" text in "Number" field
			And I click "Post" button
			And I save the value of "Number" field as "$$NumberShipmentConfirmation29700103$$"
			And I save the window as "$$ShipmentConfirmation29700103$$"
		* Change the quantity by more than SI
			And I move to "Items" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "22,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Invoiced remaining: 20 pcs. Required: 22 pcs. Lacking: 2 pcs." string by template
		* Change the quantity by less than specified in SI and post
			And I move to "Items" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "19,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
		* Add line which isn't in SI and try to post
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Boots' | 'Boots/S-8' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
		* Copy the string that is in the order and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			And I click the button named "ItemListContextMenuCopy"
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Invoiced remaining: 20 pcs. Required: 38 pcs. Lacking: 18 pcs." string by template
		* Clearing the basis document from the copied line and try to post
			And I go to the last line in "ItemList" table
			And I select current line in "ItemList" table
			And I click Clear button of "Shipment basis" attribute in "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
		* Deleting a string that has SI and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And I click "Post" button
			Then user message window does not contain messages
		* Create one more SC for the rest of SI
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number' | 'Partner' |
				| '$$NumberSalesInvoice29700102$$'  | 'Foxred'  |
			And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
			And "ItemList" table contains lines
				| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Shipment basis'       |
				| 'Dress' | '8,000'    | 'M/White'  | 'pcs'  | 'Store 02' | '$$SalesInvoice29700102$$' |
				| 'Dress' | '1,000'    | 'L/Green'  | 'pcs'  | 'Store 02' | '$$SalesInvoice29700102$$' |
			And I click "Post" button
			Then user message window does not contain messages
		* Change by more than the SI balance (already created by SC) and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "ItemList" table
			And I input "9,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress M/White] Invoiced remaining: 8 pcs. Required: 9 pcs. Lacking: 1 pcs." string by template
		* Change by less than the SI balance (already created by SC) and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Quantity' |
				| 'Dress' | 'M/White'  | '9,000'    |
			And I select current line in "ItemList" table
			And I input "7,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
			Then user message window does not contain messages
			And I close all client application windows
		* Check that the SI cannot be unpost when SC is created
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number' | 'Partner' |
				| '$$NumberSalesInvoice29700102$$'  | 'Foxred'  |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Shipped remaining: 20 pcs. Required: 0 pcs. Lacking: 20 pcs." string by template
			And I close all client application windows




Scenario: _29700104 test filling-in SO - SI - SC in different units
	* Create SO
		When create a test SO for VerificationPosting by package
	// * Change the document number to 2971
	// 	And I move to "Other" tab
	// 	And I input "2971" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "2971" text in "Number" field
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberSalesOrder29700104$$"
		And I save the window as "$$SalesOrder29700104$$"
		And I close all client application windows
	* Create SI
		* Select SO 2970
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number' | 'Partner' |
				| '$$NumberSalesOrder29700104$$'  | 'Foxred'  |
			And I select current line in "List" table
		* Create SI based on SO
			And I click "Sales invoice" button
			And "ItemList" table contains lines
			| 'Item'  | 'Item key'  | 'Q'      | 'Unit'           |
			| 'Dress' | 'M/White'   | '15,000' | 'pcs'            |
			| 'Boots' | 'Boots/S-8' | '50,000' | 'pcs'            |
			| 'Boots' | 'Boots/S-8' | '2,000'  | 'Boots (12 pcs)' |
			And I click "Post" button
	* Change in SI quantity between packages and pieces and check for post
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Q'      | 'Unit' |
		| 'Boots' | 'Boots/S-8' | '50,000' | 'pcs'  |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "38,000" text in "Q" field of "ItemList" table
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Q'     | 'Unit'           |
		| 'Boots' | 'Boots/S-8' | '2,000' | 'Boots (12 pcs)' |
		And I select current line in "ItemList" table
		And I input "3,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Change in SI quantity by shoes upside down in pieces and try to post
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Q'      | 'Unit' |
		| 'Boots' | 'Boots/S-8' | '38,000' | 'pcs'  |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "51,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2,3] [Boots Boots/S-8] Ordered remaining: 74 pcs. Required: 87 pcs. Lacking: 13 pcs." substring will appear in 20 seconds
	* Change the SI quantity of shoes to a lesser side in packages and try to post
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '3,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Change in SI quantity by shoes upside down in packs and try to post
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '1,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "4,000" text in "Q" field of "ItemList" table
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '51,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "46,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2,3] [Boots Boots/S-8] Ordered remaining: 74 pcs. Required: 94 pcs. Lacking: 20 pcs." substring will appear in 20 seconds
	* Change in SI shoe quantity by which in SO
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '4,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Q'      |
		| 'Boots' | 'Boots/S-8' | '46,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "50,000" text in "Q" field of "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Creating SC for the quantity that in SI and checking post
		And I click "Shipment confirmation" button
		And I click "Post" button
		Then user message window does not contain messages
	* Change the quantity within SI and check post
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Quantity' |
		| 'Boots' | 'Boots/S-8' | '24,000'   |
		And I select current line in "ItemList" table
		And I input "22,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key'  | 'Quantity' | 'Unit' |
			| 'Boots' | 'Boots/S-8' | '50,000'   | 'pcs'  |
		And I select current line in "ItemList" table
		And I input "52,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Specification of packages and post
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Quantity' |
		| 'Boots' | 'Boots/S-8' | '22,000'   |
		And I select current line in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots (12 pcs)' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key'  | 'Quantity' | 'Unit' |
			| 'Boots' | 'Boots/S-8' | '52,000'   | 'pcs'  |
		And I select current line in "ItemList" table
		And I input "50,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		Then user message window does not contain messages
	* Specify more packages than in SI and check post
		And I go to line in "ItemList" table
		| 'Item'  | 'Item key'  | 'Quantity' |
		| 'Boots' | 'Boots/S-8' | '2,000'   |
		And I select current line in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I click "Post" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "*[Boots Boots/S-8] Invoiced remaining: 74 pcs. Required: 86 pcs. Lacking: 12 pcs." string by template
		And I close all client application windows








		






		


	









			

















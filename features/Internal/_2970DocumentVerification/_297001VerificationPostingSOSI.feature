#language: en
@tree
@Positive
@DocumentVerification

Feature: test filling-in SO - SI




Background:
	Given I launch TestClient opening script or connect the existing one




	
Scenario: _29700101 preparation (test filling-in SO - SI)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
			And I delete "$$SalesOrder29700101$$" variable
			And I delete "$$NumberSalesOrder29700101$$" variable
			When create a test SO for VerificationPosting
			And I save the value of "Number" field as "$$NumberSalesOrder29700101$$"
			And I save the window as "$$SalesOrder29700101$$"
			And I delete "$$SalesOrder29700102$$" variable
			And I delete "$$NumberSalesOrder29700102$$" variable
			When create a test SO for VerificationPosting
			And I move to "Other" tab
			And I set checkbox "Shipment confirmations before sales invoice"
			And I click the button named "FormPost"			
			And I save the value of "Number" field as "$$NumberSalesOrder29700102$$"
			And I save the window as "$$SalesOrder29700102$$"
			And I click the button named "FormPostAndClose"
		And I close all client application windows
		And I create user settings for check registers balance
		When Create information register UserSettings records (check registers balance)
		When create the first test PO for a test on the creation mechanism based on	
		And I delete "$$NumberPurchaseOrder29700101$$" variable
		And I delete "$$PurchaseOrder29700101$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder29700101$$"
		And I save the window as "$$PurchaseOrder29700101$$"
		And I click the button named "FormPostAndClose"
		When create the first test PO for a test on the creation mechanism based on	
		And I move to "Other" tab
		And I set checkbox "Goods receipt before purchase invoice"
		And I click the button named "FormPost"	
		And I delete "$$NumberPurchaseOrder29700102$$" variable
		And I delete "$$PurchaseOrder29700102$$" variable		
		And I save the value of "Number" field as "$$NumberPurchaseOrder29700102$$"
		And I save the window as "$$PurchaseOrder29700102$$"
		And I click the button named "FormPostAndClose"
	* Check user settings
		Given I open hyperlink "e1cib/list/InformationRegister.UserSettings"
		If "List" table contains lines Then
				| "Attribute name" |
				| "EditIfSalesInvoiceExists" |
			And I go to line in "List" table
				| 'Attribute name'           |
				| 'EditIfSalesInvoiceExists' |
			And in the table "List" I click the button named "ListContextMenuDelete"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		If "List" table contains lines Then
				| "Attribute name" |
				| "EditIfPurchaseInvoiceExists" |
			And I go to line in "List" table
				| 'Attribute name'           |
				| 'EditIfPurchaseInvoiceExists' |
			And in the table "List" I click the button named "ListContextMenuDelete"
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
		
					
		



Scenario: _29700102 test filling-in SO - SI - SC by quantity
	And I delete "$$SalesInvoice29700102$$" variable
	And I delete "$$NumberSalesInvoice29700102$$" variable
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
				And I click the button named "FormPost"
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Then I wait that in user messages the "Line No. [1] [Dress M/White] Ordering remaining: 8 . Required: 12 . Lacking: 4 ." substring will appear in 20 seconds
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
				And I click the button named "FormPost"
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Then I wait that in user messages the "Line No. [3] [Dress M/White] Ordering remaining: 0 . Required: 8 . Lacking: 8 ." substring will appear in 20 seconds
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
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create SI for closing quantity on order
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
				And I click the button named "FormPost"
				And I save the value of "Number" field as "$$NumberSalesInvoice29700102$$"
				And I save the window as "$$SalesInvoice29700102$$"
				And I click the button named "FormPostAndClose"
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
		Then I wait that in user messages the "Line No. [1] [Dress M/White] Ordering remaining: 8 . Required: 0 . Lacking: 8 ." substring will appear in 20 seconds
		Then I wait that in user messages the "Line No. [2] [Dress L/Green] Ordering remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 20 seconds
	* Check for changes in the quantity in SO when SI is created (SI is more than in SO)
		* Change the number in the second line to 19
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '20,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "19,000" text in "Q" field of "ItemList" table
		* Check for a ban
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress L/Green] Ordering remaining: 20 . Required: 19 . Lacking: 1 ." substring will appear in 20 seconds
	* Check for changes in the quantity in SO when SI is created (SI is less than in SO)
		* Change the number in the second line to 21
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '19,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "21,000" text in "Q" field of "ItemList" table
			And I click the button named "FormPost"
		And I input "20,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
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
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create SI on the added line
			And I click "Sales invoice" button
			And "ItemList" table contains lines
			| 'Item'     | 'Item key'   |
			| 'Trousers' | '38/Yellow'  |
			And I click the button named "FormPost"
			Then user message window does not contain messages
	* Check for a ban SI if you add a line to it (by copying) from an order for which SI has already been created (order by line is specified)
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I activate "Item key" field in "ItemList" table
		And I click the button named "ItemListContextMenuCopy"
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
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
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "* [Dress L/Green] Ordering remaining: 0 . Required: 20 . Lacking: 20 ." string by template
	* Check post SI if a line is not added to it by order
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
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
		And I click the button named "FormPost"
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
			And I click the button named "FormPost"
			And I delete "$$ShipmentConfirmation29700103$$" variable
			And I delete "$$NumberShipmentConfirmation29700103$$" variable
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
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Line No. [2] [Dress L/Green] Shipping remaining: 20 . Required: 22 . Lacking: 2 ." string by template
		* Change the quantity by less than specified in SI and post
			And I move to "Items" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "19,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
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
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Copy the string that is in the order clearing the basis document from the copied line and try to post and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			And I click the button named "ItemListContextMenuCopy"
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Shipping remaining: 0 . Required: 19 . Lacking: 19 ." string by template
			And I go to the last line in "ItemList" table
			And I select current line in "ItemList" table
			And I click Clear button of "Shipment basis" attribute in "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Deleting a string that has SI and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And I click the button named "FormPost"
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
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Change by more than the SI balance (already created by SC) and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "ItemList" table
			And I input "9,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress M/White] Shipping remaining: 8 . Required: 9 . Lacking: 1 ." string by template
		* Change by less than the SI balance (already created by SC) and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Quantity' |
				| 'Dress' | 'M/White'  | '9,000'    |
			And I select current line in "ItemList" table
			And I input "7,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
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
			Given Recent TestClient message contains "* [Dress L/Green] Shipping remaining: 20 . Required: 0 . Lacking: 20 ." string by template
			And I close all client application windows




Scenario: _29700104 test filling-in SO - SI in different units (ban)
		And I delete "$$SalesOrder29700104$$" variable
		And I delete "$$NumberSalesOrder29700104$$" variable
	* Create SO
		When create a test SO for VerificationPosting by package
		And I click the button named "FormPost"
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
			And I click the button named "FormPost"
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
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "* [Boots Boots/S-8] Ordering remaining: 24 . Required: 36 . Lacking: 12 ." string by template
		And I close all client application windows



Scenario: _29700110 test filling-in SO - SС - SI by quantity
	And I close all client application windows
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'                       | 'Partner' |
			| '$$NumberSalesOrder29700102$$' | 'Foxred'  |
		And I select current line in "List" table
	* Create SI based on SO
		And I click "Shipment confirmation" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Quantity' | 'Unit' | 'Store'    | 'Shipment basis'         |
			| 'Dress' | 'L/Green'  | '20,000'   | 'pcs'  | 'Store 02' | '$$SalesOrder29700102$$' |
			| 'Dress' | 'M/White'  | '8,000'    | 'pcs'  | 'Store 02' | '$$SalesOrder29700102$$' |
		* Check the prohibition of holding SI for an amount greater than specified in the order
			* Change in the second row to 12
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				And I select current line in "ItemList" table
				And I input "12,000" text in "Quantity" field of "ItemList" table
				And I finish line editing in "ItemList" table
			* Check for a ban
				And I click the button named "FormPost"
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Then I wait that in user messages the "Line No. [1] [Dress M/White] Shipping remaining: 8 . Required: 12 . Lacking: 4 ." substring will appear in 20 seconds
			* Change in quantity to original value
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				And I select current line in "ItemList" table
				And I input "8,000" text in "Quantity" field of "ItemList" table
				And I finish line editing in "ItemList" table
		* Check the prohibition of holding SC for an amount greater than specified in the order (copy line)	
			* Copy second kine
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Quantity'     |
				| 'Dress' | 'M/White'  | '8,000' |
				And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
			* Check for a ban
				And I click the button named "FormPost"
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Then I wait that in user messages the "Line No. [3] [Dress M/White] Shipping remaining: 0 . Required: 8 . Lacking: 8 ." substring will appear in 20 seconds
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Quantity'     |
					| 'Dress' | 'M/White'  | '8,000' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		* Add an over-order line to the SC and checking post
			And I click the button named "Add"
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
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create SC for closing quantity on order
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
				And I click the button named "FormPost"
				And I delete "$$ShipmentConfirmation29700104$$" variable
				And I delete "$$NumberShipmentConfirmation29700104$$" variable
				And I save the value of "Number" field as "$$NumberShipmentConfirmation29700104$$"
				And I save the window as "$$ShipmentConfirmation29700104$$"
				And I click the button named "FormPostAndClose"
				And I close all client application windows
	

Scenario: _29700111 test filling-in SO - SC - SI by quantity (second part)
	* Check the SO unpost when SC is created
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number' | 'Partner' |
		| '$$NumberSalesOrder29700102$$'  | 'Foxred'  |
		And I select current line in "List" table
		And I click "Clear posting" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Dress M/White] Shipping remaining: 8 . Required: 0 . Lacking: 8 ." substring will appear in 20 seconds
		Then I wait that in user messages the "Line No. [2] [Dress L/Green] Shipping remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 20 seconds
	* Check for changes in the quantity in SO when SC is created (SC is more than in SO)
		* Change the number in the second line to 19
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '20,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "19,000" text in "Q" field of "ItemList" table
		* Check for a ban
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress L/Green] Shipping remaining: 20 . Required: 19 . Lacking: 1 ." substring will appear in 20 seconds
	* Check for changes in the quantity in SO when SC is created (SC is less than in SO)
		* Change the number in the second line to 21
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '19,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "21,000" text in "Q" field of "ItemList" table
			And I click the button named "FormPost"
		And I activate "Q" field in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Create one more SC
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
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create SC on the added line
			And I click "Shipment confirmation" button
			And "ItemList" table contains lines
			| 'Item'     | 'Item key'   |
			| 'Trousers' | '38/Yellow'  |
			And I click the button named "FormPost"
			Then user message window does not contain messages
	* Check for a ban SC if you add a line to it (by copying) from an order for which SI has already been created (order by line is specified)
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I activate "Item" field in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"		
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
		And I activate "Quantity" field in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [2] [Dress L/Green] Shipping remaining: 0 . Required: 20 . Lacking: 20 ." substring will appear in 20 seconds
	* Check post SC if a line is not added to it by order
		And I go to line in "ItemList" table
		| '#' | 'Item'  | 'Item key' |
		| '2' | 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click "Add" button
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
		And I input "1" text in "Quantity" field of "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows
	* Create Sales invoice by more than the quantity specified on the SC
		* Select created SC
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I go to line in "List" table
			| 'Number' | 'Partner' |
			| '$$NumberShipmentConfirmation29700104$$'  | 'Foxred'  |
		* Create SI
			And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
			And "ItemList" table contains lines
			| 'Item'  | 'Q'      | 'Item key' | 'Unit' | 'Store'    | 'Sales order'            |
			| 'Dress' | '8,000'  | 'M/White'  | 'pcs'  | 'Store 02' | '$$SalesOrder29700102$$' |
			| 'Dress' | '20,000' | 'L/Green'  | 'pcs'  | 'Store 02' | '$$SalesOrder29700102$$' |
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice29700104$$" variable
			And I delete "$$SalesInvoice29700104$$" variable	
			And I save the value of "Number" field as "$$NumberSalesInvoice29700104$$"
			And I save the window as "$$SalesInvoice29700104$$"
		* Change the quantity by more than SC
			And I move to "Item list" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "22,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Given Recent TestClient message contains "*22 greater than 20" string by template
		* Change the quantity by less than specified in SI and post
			And I move to "Item list" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "19,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Add line which isn't in SC and try to post
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
			And I activate "Q" field in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Copy the string that is in the order and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			And I click the button named "ItemListContextMenuCopy"
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "Line No. [4] [Dress L/Green] Ordering remaining: 0 . Required: 19 . Lacking: 19 ." string by template
			And I go to the last line in "ItemList" table
			And I select current line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		* Deleting a string that has SC and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create one more SI for the rest of SO
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number' | 'Partner' |
				| '$$NumberSalesOrder29700102$$'  | 'Foxred'  |
			And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
			And I click the button named "FormSelectAll"
			And I click "Ok" button		
			And "ItemList" table contains lines
				| 'Item'  | 'Q' | 'Item key' | 'Unit' | 'Store'    | 'Sales order'       |
				| 'Dress' | '8,000'    | 'M/White'  | 'pcs'  | 'Store 02' | '$$SalesOrder29700102$$' |
				| 'Dress' | '1,000'    | 'L/Green'  | 'pcs'  | 'Store 02' | '$$SalesOrder29700102$$' |
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Change by more than the SI balance (already created by SC) and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "ItemList" table
			And I input "9,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Given Recent TestClient message contains "* 9 greater than 8" string by template
		* Change by less than the SI balance (already created by SC) and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q' |
				| 'Dress' | 'M/White'  | '9,000'    |
			And I select current line in "ItemList" table
			And I input "7,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
			And I close all client application windows
		* Check forbid changes of SC when SI were already created
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberShipmentConfirmation29700104$$'  |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedLabel"
			If "TransactionType" attribute is not editable Then
			If "Store" attribute is not editable Then
			And I close all client application windows
		* Check that the SC cannot be unpost when SI is created
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I go to line in "List" table
				| 'Number' | 'Partner' |
				| '$$NumberShipmentConfirmation29700104$$'  | 'Foxred'  |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Shipping order remaining: 20 . Required: 0 . Lacking: 20 ." string by template
			And I close all client application windows



Scenario: _29700120 test filling-in PO - PI - GR by quantity
	And I delete "$$PurchaseInvoice29700102$$" variable
	And I delete "$$NumberPurchaseInvoice29700102$$" variable
	* Select PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                       |
			| '$$NumberPurchaseOrder29700101$$' |
		And I select current line in "List" table
	* Create PI based on PO
		And I click "Purchase invoice" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Q'      | 'Unit' | 'Store'    | 'Purchase order'            |
			| 'Dress'    | 'L/Green'   | '20,000' | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700101$$' |
			| 'Dress'    | 'M/White'   | '20,000' | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700101$$' |
			| 'Trousers' | '36/Yellow' | '30,000' | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700101$$' |
		* Check the prohibition of holding PI for an amount greater than specified in the order
			* Change in the second row to 12
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				And I select current line in "ItemList" table
				And I input "22,000" text in "Q" field of "ItemList" table
				And I finish line editing in "ItemList" table
			* Check for a ban
				And I click the button named "FormPost"
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Then I wait that in user messages the "Line No. [1] [Dress M/White] Ordering remaining: 20 . Required: 22 . Lacking: 2 ." substring will appear in 20 seconds
			* Change in quantity to original value
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				And I select current line in "ItemList" table
				And I input "20,000" text in "Q" field of "ItemList" table
				And I finish line editing in "ItemList" table
		* Check the prohibition of holding PI for an amount greater than specified in the order (copy line)	
			* Copy second line
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q'     |
				| 'Dress' | 'M/White'  | '20,000' |
				And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
			* Check for a ban
				And I click the button named "FormPost"
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Then I wait that in user messages the "Line No. [4] [Dress M/White] Ordering remaining: 0 . Required: 20 . Lacking: 20 ." substring will appear in 20 seconds
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Q'     |
					| 'Dress' | 'M/White'  | '20,000' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		* Add an over-order line to the PI and checking post
			And I click the button named "Add"
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
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create PI for closing quantity on order
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
				And I click the button named "FormPost"
				And I save the value of "Number" field as "$$NumberPurchaseInvoice29700102$$"
				And I save the window as "$$PurchaseInvoice29700102$$"
				And I click the button named "FormPostAndClose"
				And I close all client application windows
	

Scenario: _29700121 test filling-in PO - PI - GR by quantity (second part)
	* Check the PO unpost when PI is created
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseOrder29700101$$'  |
		And I select current line in "List" table
		And I click "Clear posting" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Dress M/White] Ordering remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 20 seconds
		Then I wait that in user messages the "Line No. [2] [Dress L/Green] Ordering remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 20 seconds
	* Check for changes in the quantity in PO when PI is created (PI is more than in PO)
		* Change the number in the first line to 19
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '20,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "19,000" text in "Q" field of "ItemList" table
		* Check for a ban
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress L/Green] Ordering remaining: 20 . Required: 19 . Lacking: 1 ." substring will appear in 20 seconds
	* Check for changes in the quantity in PO when PI is created (PI is less than in PO)
		* Change the number in the first line to 21
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '19,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "21,000" text in "Q" field of "ItemList" table
			And I click the button named "FormPost"
		And I input "20,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Create one more PI
		* Add line in PO
			And I click the button named "Add"
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
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create PI on the added line
			And I click "Purchase invoice" button
			And "ItemList" table contains lines
			| 'Item'     | 'Item key'   |
			| 'Trousers' | '38/Yellow'  |
			And I click the button named "FormPost"
			Then user message window does not contain messages
	* Check PI post if you add a line to it (by copying) from an order for which PI has already been created (order by line is specified)
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I activate "Item key" field in "ItemList" table
		And I click the button named "ItemListContextMenuCopy"
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
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
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "* [Dress L/Green] Ordering remaining: 0 . Required: 20 . Lacking: 20 ." string by template
	* Check post PI if a line is not added to it by order
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click "Add" button
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
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows
	* Create GR by more than the quantity specified on the invoice
		* Select created PI
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice29700102$$'  |
		* Create GR
			And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
			And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Store'    | 'Receipt basis'       |
			| 'Dress' | '20,000'    | 'M/White'  | 'pcs'  | 'Store 02' | '$$PurchaseInvoice29700102$$' |
			| 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | 'Store 02' | '$$PurchaseInvoice29700102$$' |
			And I click the button named "FormPost"
			And I delete "$$GoodsReceipt29700103$$" variable
			And I delete "$$NumberGoodsReceipt29700103$$" variable
			And I save the value of "Number" field as "$$NumberGoodsReceipt29700103$$"
			And I save the window as "$$GoodsReceipt29700103$$"
		* Change the quantity by more than PI
			And I move to "Items" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "22,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Receipt remaining: 20 . Required: 22 . Lacking: 2 ." string by template
		* Change the quantity by less than specified in PI and post
			And I move to "Items" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "19,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Add line which isn't in PI and try to post
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
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Boots Boots/S-8] Receipt remaining: 0 . Required: 2 . Lacking: 2 ." string by template
		* Copy the string that is in the order clearing the basis document from the copied line and try to post and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			And I click the button named "ItemListContextMenuCopy"
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Receipt remaining: 0 . Required: 19 . Lacking: 19 ." string by template
			And I go to the last line in "ItemList" table
			And I select current line in "ItemList" table
			And I click Clear button of "Receipt basis" attribute in "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Receipt remaining: 0 . Required: 19 . Lacking: 19 ." string by template
		* Deleting a string that has PI and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Boots' | 'Boots/S-8'  |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create one more GR for the rest of PI
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice29700102$$'  |
			And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
			And "ItemList" table contains lines
				| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Receipt basis'               |
				| 'Dress'    | '20,000'   | 'M/White'   | 'pcs'  | 'Store 02' | '$$PurchaseInvoice29700102$$' |
				| 'Dress'    | '1,000'    | 'L/Green'   | 'pcs'  | 'Store 02' | '$$PurchaseInvoice29700102$$' |
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Change by more than the PI balance (already created by GR) and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "9,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Dress L/Green] Receipt remaining: 1 . Required: 9 . Lacking: 8 ." string by template
		* Change by less than the PI balance (already created by GR) and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Quantity' |
				| 'Dress' | 'L/Green'  | '9,000'    |
			And I select current line in "ItemList" table
			And I input "0,500" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
			And I close all client application windows
		* Check that the PI cannot be unpost when GR is created
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberPurchaseInvoice29700102$$'  |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Trousers 36/Yellow] Receipt remaining: 30 . Required: 0 . Lacking: 30 ." string by template
			And I close all client application windows




Scenario: _29700123 test filling-in PO - GR - PI by quantity
	And I close all client application windows
	And I delete "$$GoodsReceipt29700102$$" variable
	And I delete "$$NumberGoodsReceipt29700102$$" variable
	* Select PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                       |
			| '$$NumberPurchaseOrder29700102$$' |
		And I select current line in "List" table
	* Create GR based on PO
		And I click "Goods receipt" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Quantity'      | 'Unit' | 'Store'    | 'Receipt basis'            |
			| 'Dress'    | 'L/Green'   | '20,000' | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700102$$' |
			| 'Dress'    | 'M/White'   | '20,000' | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700102$$' |
			| 'Trousers' | '36/Yellow' | '30,000' | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700102$$' |
		* Check quantity in GR (greater than specified in the order)
			* Change in the second row to 22
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				And I select current line in "ItemList" table
				And I input "22,000" text in "Quantity" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I click the button named "FormPost"
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Given Recent TestClient message contains "* [Dress M/White] Receipt remaining: 20 . Required: 22 . Lacking: 2 ." string by template
			* Change in quantity to original value
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
				And I select current line in "ItemList" table
				And I input "20,000" text in "Quantity" field of "ItemList" table
				And I finish line editing in "ItemList" table
		* Check GR post when quantity greater than specified in the order (copy line)	
			* Copy second line
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Quantity'     |
				| 'Dress' | 'M/White'  | '20,000' |
				And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
				And I click the button named "FormPost"
				Then "1C:Enterprise" window is opened
				And I click "OK" button
				Given Recent TestClient message contains "* [Dress M/White] Receipt remaining: 0 . Required: 20 . Lacking: 20 ." string by template
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Quantity'     |
					| 'Dress' | 'M/White'  | '20,000' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		* Add an over-order line to the GR and checking post
			And I click "Add" button			
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
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Post GR for closing quantity on order
			* Delete added line
				And I go to line in "ItemList" table
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				And I activate field named "ItemListItemKey" in "ItemList" table
				And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
				And I click the button named "FormPost"
				And I save the value of "Number" field as "$$NumberGoodsReceipt29700102$$"
				And I save the window as "$$GoodsReceipt29700102$$"
				And I click the button named "FormPostAndClose"
				And I close all client application windows
	

Scenario: _29700123 test filling-in PO - GR - PI by quantity (second part)
	* Check the PO unpost when GR is created
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseOrder29700102$$'  |
		And I select current line in "List" table
		And I click "Clear posting" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Line No. [1] [Dress M/White] Receipt remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 20 seconds
		Then I wait that in user messages the "Line No. [2] [Dress L/Green] Receipt remaining: 20 . Required: 0 . Lacking: 20 ." substring will appear in 20 seconds
	* Check for changes in the quantity in PO when GR is created (GR is more than in PO)
		* Change the number in the first line to 19
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '20,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "19,000" text in "Q" field of "ItemList" table
		* Check for a ban
			And I click the button named "FormPost"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Then I wait that in user messages the "Line No. [2] [Dress L/Green] Receipt remaining: 20 . Required: 19 . Lacking: 1 ." substring will appear in 20 seconds
	* Check for changes in the quantity in PO when GR is created (GR is less than in PO)
		* Change the number in the first line to 21
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Dress' | 'L/Green'  | '19,000' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "21,000" text in "Q" field of "ItemList" table
			And I click the button named "FormPost"
		And I input "20,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Create one more GR
		* Add line in PO
			And I click the button named "Add"
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
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create PI on the added line
			And I click "Goods receipt" button
			And "ItemList" table contains lines
			| 'Item'     | 'Item key'   |
			| 'Trousers' | '38/Yellow'  |
			And I click the button named "FormPost"
			Then user message window does not contain messages
	* Check GR post if you add a line to it (by copying) from an order for which PI has already been created (order by line is specified)
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I activate "Item key" field in "ItemList" table
		And I click the button named "ItemListContextMenuCopy"
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
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
		And I activate "Quantity" field in "ItemList" table
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "* [Dress L/Green] Receipt remaining: 0 . Required: 20 . Lacking: 20 ." string by template
	* Check post GR if a line is not added to it by order
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click "Add" button
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
		And I click the button named "FormPost"
		Then user message window does not contain messages
		And I close all client application windows
	* Create PI by more than the quantity specified on the invoice
		* Select created GR
			Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
			And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt29700102$$'  |
		* Create GR
			And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
			And "ItemList" table contains lines
			| 'Item'  | 'Q'      | 'Item key' | 'Unit' | 'Store'    | 'Purchase order'            |
			| 'Dress' | '20,000' | 'M/White'  | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700102$$' |
			| 'Dress' | '20,000' | 'L/Green'  | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700102$$' |
			And I click the button named "FormPost"
			And I delete "$$PurchaseInvoice29700103$$" variable
			And I delete "$$NumberPurchaseInvoice29700103$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice29700103$$"
			And I save the window as "$$PurchaseInvoice2970010329700103$$"
		* Change the quantity by more than GR
			And I move to "Item list" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "22,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Given Recent TestClient message contains "*22 greater than 20" string by template
		* Change the quantity by less than specified in PI and post
			And I move to "Item list" tab
			And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
			And I select current line in "ItemList" table
			And I input "19,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Deleting a string that has PI and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Create one more PI for the rest of GR
			Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
			And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt29700102$$'  |
			And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
			And "ItemList" table contains lines
				| 'Item'  | 'Q' | 'Item key' | 'Unit' | 'Store'    | 'Purchase order'            |
				| 'Dress' | '1,000'    | 'L/Green'  | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700102$$' |
				| 'Dress' | '20,000'   | 'M/White'  | 'pcs'  | 'Store 02' | '$$PurchaseOrder29700102$$' |
			And I click the button named "FormPost"
			Then user message window does not contain messages
		* Change by more than the GR balance  and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "ItemList" table
			And I input "21,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Given Recent TestClient message contains "* 21 greater than 20" string by template
		* Change by less than the GR balance  and try to post
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' | 'Q' |
				| 'Dress' | 'M/White'  | '21,000'    |
			And I select current line in "ItemList" table
			And I input "9" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			Then user message window does not contain messages
			And I close all client application windows
		* Check forbid changes of GR when PI were already created
			Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberGoodsReceipt29700102$$'  |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedLabel"
			If "TransactionType" attribute is not editable Then
			If "Store" attribute is not editable Then
			And I close all client application windows
		* Check that the GR cannot be unpost when PI is created
			Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberGoodsReceipt29700102$$'  |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			Given Recent TestClient message contains "* [Trousers 36/Yellow] Receipt order remaining: 30 . Required: 0 . Lacking: 30 ." string by template
			And I close all client application windows

Scenario: _29700140 check custom user setting Edit GR if PI exists
	When Create information register UserSettings records (edit GR and SC)
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt29700102$$'  |
	And in the table "List" I click the button named "ListContextMenuPost"	
	And I select current line in "List" table
	And I click "Add" button
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
	And I activate "Item key" field in "List" table
	And I select current line in "List" table
	And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Dress'    | 'M/White'   |
	And I close all client application windows

Scenario: _29700141 check custom user setting Edit SC if SI exists
	When Create information register UserSettings records (edit GR and SC)
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberShipmentConfirmation29700104$$'  |
	And in the table "List" I click the button named "ListContextMenuPost"	
	And I select current line in "List" table
	And I click "Add" button
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
	And I activate "Item key" field in "List" table
	And I select current line in "List" table
	And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Dress'    | 'M/White'   |
	And I close all client application windows
		
	

			
Scenario: _999999 close TestClient session
	And I close TestClient session

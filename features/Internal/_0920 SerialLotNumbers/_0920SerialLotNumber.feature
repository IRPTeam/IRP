#language: en
@tree
@Positive
@SerialLotNumber

Feature: check that the item marked for deletion is not displayed


As a developer
I want to hide the items marked for deletion from the product selection form.
So the user can't select it in the sales and purchase documents


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _092000 preparation (SerialLotNumbers)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog PaymentTypes objects
		When Create catalog BusinessUnits objects
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
		When update ItemKeys
		When Create document PurchaseInvoice objects (for stock remaining control)
		When Create catalog SerialLotNumbers objects
		When Create catalog ExpenseAndRevenueTypes objects
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
		When Create document PurchaseInvoice objects (use serial lot number)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(29).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document SalesInvoice objects (use serial lot number)	
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1029).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document GoodsReceipt objects (use serial lot number)	
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1029).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document ShipmentConfirmation objects (use serial lot number)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1029).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document InventoryTransfer objects (use serial lot number)
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(1029).GetObject().Write(DocumentWriteMode.Posting);" |


Scenario: _092001 checkbox Use serial lot number in the Item type
	When checkbox Use serial lot number in the Item type Clothes
	* Check saving
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to ""
		Then the form attribute named "UseSerialLotNumber" became equal to "Yes"
	And I close all client application windows
	
Scenario: _092002 check serial lot number in the Retail sales receipt
	* Preparation
		And I delete '$$RetailSalesReceipt092002$$' variable
		And I delete '$$NumberRetailSalesReceipt092002$$' variable
	* Create Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail customer' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Retail customer' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Retail partner term' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'Store 01'    | 'Store 01'  |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Filling in payment tab
		And I move to "Payments" tab
		And in the table "Payments" I click "Add" button
		And I click choice button of "Account" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
		And I activate "Amount" field in "Payments" table
		And I input "1 050,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table
	* Post Retail sales receipt and check movements in the register Retail sales
		And I click the button named "FormPost"
		And I delete "$$RetailSalesReceipt092002$$" variable
		And I delete "$$NumberRetailSalesReceipt092002$$" variable
		And I save the window as "$$RetailSalesReceipt092002$$"
		And I save the value of the field named "Number" as "$$NumberRetailSalesReceipt092002$$"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines
		| '$$RetailSalesReceipt092002$$'   | ''       | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''                             | ''                             | ''          | ''                  | ''        |
		| 'Document registrations records' | ''       | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''                             | ''                             | ''          | ''                  | ''        |
		| 'Register  "R2050 Retail sales"' | ''       | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''                             | ''                             | ''          | ''                  | ''        |
		| ''                               | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''        | ''         | ''                             | ''                             | ''          | ''                  | ''        |
		| ''                               | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Store'    | 'Sales person'                 | 'Retail sales receipt'         | 'Item key'  | 'Serial lot number' | 'Row key' |
		| ''                               | '*'      | '1'         | '400'    | '338,98'     | ''              | 'Main Company' | '*'       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '*'       |
		| ''                               | '*'      | '1'         | '650'    | '550,85'     | ''              | 'Main Company' | '*'       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '*'       |
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$RetailSalesReceipt092002$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I input "3,000" text in "Q" field of "ItemList" table
		* Filling in payment tab
			And I move to "Payments" tab
			And I select current line in "Payments" table
			And I input "1 050,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			* Create serial lot number for item
				And I click the button named "FormCreate"
				And I input "99098809009998" text in "Serial number" field
				And I click "Save and close" button
			And I go to line in "List" table
				| 'Owner'     | 'Serial number'  |
				| '38/Yellow' | '99098809009998' |
			And I activate "Serial number" field in "List" table
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3,000'    | '99098809009998'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		* Filling in payment tab
			And I move to "Payments" tab
			And I select current line in "Payments" table
			And I input "1 850,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
	* Post Retail sales receipt and check movements in the register Retail sales
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines
			| '$$RetailSalesReceipt092002$$'   | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| 'Document registrations records' | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| 'Register  "R2050 Retail sales"' | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| ''                               | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| ''                               | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch' | 'Store'    | 'Sales person'                 | 'Retail sales receipt'         | 'Item key'  | 'Serial lot number' | 'Row key' |
			| ''                               | '*'      | '1'         | '400'    | '338,98'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '*'       |
			| ''                               | '*'      | '1'         | '650'    | '550,85'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '*'       |
			| ''                               | '*'      | '2'         | '800'    | '677,97'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '*'       |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$RetailSalesReceipt092002$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that does not use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Filling in payments tab
		And I move to "Payments" tab
		And I select current line in "Payments" table
		And I input "2 550,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change item that does not use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
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
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	And I go to line in "List" table
			| 'Number'     |
			| '$$NumberRetailSalesReceipt092002$$' |
	And I click "Registrations report" button
	And I select "R2050 Retail sales" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| '$$RetailSalesReceipt092002$$'   | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
		| 'Document registrations records' | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
		| 'Register  "R2050 Retail sales"' | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
		| ''                               | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
		| ''                               | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch' | 'Store'    | 'Sales person'                 | 'Retail sales receipt'         | 'Item key'  | 'Serial lot number' | 'Row key' |
		| ''                               | '*'      | '1'         | '400'    | '338,98'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '*'       |
		| ''                               | '*'      | '1'         | '650'    | '550,85'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '*'       |
		| ''                               | '*'      | '1'         | '700'    | '593,22'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '*'       |
		| ''                               | '*'      | '2'         | '800'    | '677,97'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '*'       |
	And I close all client application windows
	

		
	
	
Scenario: _092003 check serial lot number in the Retail return receipt
	* Preparation
		And I delete '$$RetailReturnReceipt092003$$' variable
		And I delete '$$NumberRetailReturnReceipt092003$$' variable
	* Create Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			|'Number'|
			|'$$NumberRetailSalesReceipt092002$$'|
		And I click the button named "FormDocumentRetailReturnReceiptGenarate"
		And I click "Ok" button	
	* Check filling in serial lot number
		And "ItemList" table contains lines
			| 'Serial lot numbers'             | 'Price'  | 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Retail sales receipt'         |
			| '99098809009999; 99098809009998' | '400,00' | 'Trousers' | '38/Yellow' | '3,000' | 'pcs'  | '$$RetailSalesReceipt092002$$' |
			| ''                               | '650,00' | 'Boots'    | '38/18SD'   | '1,000' | 'pcs'  | '$$RetailSalesReceipt092002$$' |
			| ''                               | '700,00' | 'Boots'    | '37/18SD'   | '1,000' | 'pcs'  | '$$RetailSalesReceipt092002$$' |
		And "SerialLotNumbersTree" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Serial lot number' | 'Item key quantity' |
			| 'Trousers' | '3,000'    | '38/Yellow' | ''                  | '3,000'             |
			| ''         | '1,000'    | ''          | '99098809009999'    | ''                  |
			| ''         | '2,000'    | ''          | '99098809009998'    | ''                  |
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
		# And I move to "Other" tab
		# And I click Select button of "Branch" field
		# And I go to line in "List" table
		# 	| 'Description' |
		# 	| 'Shop 01'     |
		# And I select current line in "List" table	
	* Post Retail return receipt and check movements in the register Retail sales
		And I click the button named "FormPost"
		And I delete "$$RetailReturnReceipt092003$$" variable
		And I save the window as "$$RetailReturnReceipt092003$$"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$RetailReturnReceipt092003$$'  | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| 'Document registrations records' | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| 'Register  "R2050 Retail sales"' | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| ''                               | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| ''                               | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch' | 'Store'    | 'Sales person'                 | 'Retail sales receipt'         | 'Item key'  | 'Serial lot number' | 'Row key' |
			| ''                               | '*'      | '-2'        | '-800'   | '-677,97'    | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '*'       |
			| ''                               | '*'      | '-1'        | '-400'   | '-338,98'    | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '*'       |
			| ''                               | '*'      | '-1'        | '650'    | '550,85'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '*'       |
			| ''                               | '*'      | '-1'        | '700'    | '593,22'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '*'       |
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$RetailReturnReceipt092003$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '3,000' |
		And I input "1,000" text in "Q" field of "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [1] does not match the quantity [3] by serial/lot numbers" substring will appear in "30" seconds
		* Delete 1 serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '1,000'    | '99098809009999'    |
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersContextMenuDelete"
			And I click "Ok" button
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [1] does not match the quantity [2] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '2,000'    | '99098809009998'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
			And I move to "Payments" tab
			And I activate "Amount" field in "Payments" table
			And I select current line in "Payments" table
			And I input "1 750,00" text in "Amount" field of "Payments" table
			And I finish line editing in "Payments" table
			And I move to "Item list" tab			
	* Post Retail return receipt and check movements in the register Retail sales
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$RetailReturnReceipt092003$$'  | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| 'Document registrations records' | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| 'Register  "R2050 Retail sales"' | ''       | ''          | ''       | ''           | ''              | ''             | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| ''                               | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''       | ''         | ''                             | ''                             | ''          | ''                  | ''        |
			| ''                               | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch' | 'Store'    | 'Sales person'                 | 'Retail sales receipt'         | 'Item key'  | 'Serial lot number' | 'Row key' |
			| ''                               | '*'      | '-1'        | '-400'   | '-338,98'    | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '*'       |
			| ''                               | '*'      | '-1'        | '650'    | '550,85'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '*'       |
			| ''                               | '*'      | '-1'        | '700'    | '593,22'     | ''              | 'Main Company' | ''       | 'Store 01' | ''                             | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '*'       |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$RetailReturnReceipt092003$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that does not use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I move to "Payments" tab
		And I activate "Amount" field in "Payments" table
		And I select current line in "Payments" table
		And I input "2 450,00" text in "Amount" field of "Payments" table
		And I finish line editing in "Payments" table
		And I move to "Item list" tab
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change item that does not use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
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
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	And I close all client application windows


	
Scenario: _092004 check serial lot number in the Sales invoice
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Kalipso' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Kalipso' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' | 'Reference' |
			| 'Store 01'    | 'Store 01'  |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009910" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009910' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Retail sales receipt and check movements in the register R4014 Serial lot numbers
		And I click the button named "FormPost"
		And I delete "$$SalesInvoice092004$$" variable
		And I delete "$$NumberSalesInvoice092004$$" variable
		And I save the window as "$$SalesInvoice092004$$"
		And I save the value of the field named "Number" as "$$NumberSalesInvoice092004$$"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice092004$$'               | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Expense'     | '*'      | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009910'    |
		And I close current window
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$SalesInvoice092004$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I input "3,000" text in "Q" field of "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			* Create serial lot number for item
				And I click the button named "FormCreate"
				And I input "99098809009911" text in "Serial number" field
				And I click "Save and close" button
			And I go to line in "List" table
				| 'Owner'     | 'Serial number'  |
				| '38/Yellow' | '99098809009911' |
			And I activate "Serial number" field in "List" table
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And the editing text of form attribute named "ItemQuantity" became equal to "3,000"
			And the editing text of form attribute named "SelectedCount" became equal to "4,000"
			And I click "Ok" button
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3,000'    | '99098809009911'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And the editing text of form attribute named "ItemQuantity" became equal to "3,000"
			And the editing text of form attribute named "SelectedCount" became equal to "3,000"
			And I click "Ok" button
	* Post Sales invoice and check movements in the register Sales turnovers
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice092004$$'               | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Expense'     | '*'      | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009910'    |
			| ''                                     | 'Expense'     | '*'      | '2'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009911'    |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$SalesInvoice092004$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that does not use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change item that does not use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
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
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Copy line with serial lot number (serial lot number not copied)
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     | 'Serial lot numbers'             |
			| 'Trousers' | '38/Yellow' | '3,000' | '99098809009910; 99098809009911' |
		And I activate "Item key" field in "ItemList" table
		And in the table "ItemList" I click "Copy" button
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Serial lot numbers'             | 'Q'     |
		| 'Trousers' | '38/Yellow' | '99098809009910; 99098809009911' | '3,000' |
		| 'Boots'    | '38/18SD'   | ''                               | '1,000' |
		| 'Dress'    | 'M/White'   | ''                               | '1,000' |
		| 'Trousers' | '38/Yellow' | ''                               | '3,000' |	
	And I close all client application windows

Scenario: _092005 check serial lot number in the Sales return
	* Create Sales return
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			|'Number'|
			|'$$NumberSalesInvoice092004$$'|
		And I click the button named "FormDocumentSalesReturnGenerate"
		And I click "OK" button
	* Check filling in serial lot number
		And "ItemList" table contains lines
			| 'Serial lot numbers'             | 'Price'  | 'Item'     | 'Item key'  | 'Q'     | 'Unit' | 'Sales invoice'          |
			| '99098809009910; 99098809009911' | '400,00' | 'Trousers' | '38/Yellow' | '3,000' | 'pcs'  | '$$SalesInvoice092004$$' |
			| ''                               | '650,00' | 'Boots'    | '38/18SD'   | '1,000' | 'pcs'  | '$$SalesInvoice092004$$' |
			| ''                               | '700,00' | 'Boots'    | '37/18SD'   | '1,000' | 'pcs'  | '$$SalesInvoice092004$$' |
		And "SerialLotNumbersTree" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Serial lot number' | 'Item key quantity' |
			| 'Trousers' | '3,000'    | '38/Yellow' | ''                  | '3,000'             |
			| ''         | '1,000'    | ''          | '99098809009910'    | ''                  |
			| ''         | '2,000'    | ''          | '99098809009911'    | ''                  |
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Retail return receipt and check movements in the register R4014 Serial lot numbers
		And I click the button named "FormPost"
		And I delete "$$SalesReturn092005$$" variable
		And I save the window as "$$SalesReturn092005$$"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesReturn092005$$'                | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '*'      | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009910'    |
			| ''                                     | 'Receipt'     | '*'      | '2'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009911'    |
		And I close current window
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$SalesReturn092005$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '3,000' |
		And I input "1,000" text in "Q" field of "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [1] does not match the quantity [3] by serial/lot numbers" substring will appear in "30" seconds
		* Delete 1 serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '1,000'    | '99098809009910'    |
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersContextMenuDelete"
			And I click "Ok" button
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [1] does not match the quantity [2] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '2,000'    | '99098809009911'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Sales return and check movements in the register R4014 Serial lot numbers
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesReturn092005$$'                | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''       | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''       | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '*'      | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009911'    |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$SalesReturn092005$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that does not use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change item that does not use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
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
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	And I close all client application windows

Scenario: _092006 check serial lot number in the PurchaseInvoice
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "400,00" text in "Price" field of "ItemList" table	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "700,00" text in "Price" field of "ItemList" table		
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Purchase invoice and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$PurchaseInvoice092006$$" variable
		And I delete "$$NumberPurchaseInvoice092006$$" variable
		And I delete "$$DatePurchaseInvoice092006$$" variable
		And I save the window as "$$PurchaseInvoice092006$$"
		And I save the value of the field named "Number" as "$$NumberPurchaseInvoice092006$$"
		And I save the value of the field named "Date" as "$$DatePurchaseInvoice092006$$"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseInvoice092006$$'            | ''            | ''                              | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                              | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                              | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                              | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '$$DatePurchaseInvoice092006$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
		And I close all client application windows
		
	
	
	
Scenario: _0920061 check serial lot number controls in the PurchaseInvoice
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "400,00" text in "Price" field of "ItemList" table	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "700,00" text in "Price" field of "ItemList" table		
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Post Purchase invoice and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$PurchaseInvoice0920061$$" variable
		And I delete "$$NumberPurchaseInvoice0920061$$" variable
		And I delete "$$DatePurchaseInvoice0920061$$" variable
		And I save the window as "$$PurchaseInvoice0920061$$"
		And I save the value of the field named "Number" as "$$NumberPurchaseInvoice0920061$$"
		And I save the value of the field named "Date" as "$$DatePurchaseInvoice0920061$$"
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$PurchaseInvoice0920061$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I input "3,000" text in "Q" field of "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			* Create serial lot number for item
				And I click the button named "FormCreate"
				And I input "99098809009908" text in "Serial number" field
				And I click "Save and close" button
			And I go to line in "List" table
				| 'Owner'     | 'Serial number'  |
				| '38/Yellow' | '99098809009908' |
			And I activate "Serial number" field in "List" table
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3,000'    | '99098809009908'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Purchase invoice and check movements in the register R4014 Serial lot numbers
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseInvoice0920061$$'           | ''            | ''                               | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                               | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                               | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                         | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                               | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '$$DatePurchaseInvoice0920061$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
			| ''                                     | 'Receipt'     | '$$DatePurchaseInvoice0920061$$' | '2'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009908'    |
		And I close current window
	* Check the message to the user when the serial number was not filled in
		And I activate "$$PurchaseInvoice0920061$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that does not use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change item that does not use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
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
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	And I close all client application windows


Scenario: _092007 check serial lot number in the PurchaseReturn
	* Create Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "400,00" text in "Price" field of "ItemList" table	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "700,00" text in "Price" field of "ItemList" table		
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Purchase return and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$PurchaseReturn092007$$" variable
		And I delete "$$NumberPurchaseReturn092007$$" variable
		And I delete "$$DatePurchaseReturn092007$$" variable
		And I save the window as "$$PurchaseReturn092007$$"
		And I save the value of the field named "Number" as "$$NumberPurchaseReturn092007$$"
		And I save the value of the field named "Date" as "$$DatePurchaseReturn092007$$"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseReturn092007$$'             | ''            | ''                             | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                             | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                             | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                       | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                             | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Expense'     | '$$DatePurchaseReturn092007$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
		And I close all client application windows
		

	
Scenario: _0920071 check serial lot number controls in the PurchaseReturn	
	* Create Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "400,00" text in "Price" field of "ItemList" table	
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "700,00" text in "Price" field of "ItemList" table		
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Purchase return and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$PurchaseReturn0920071$$" variable
		And I delete "$$NumberPurchaseReturn0920071$$" variable
		And I delete "$$DatePurchaseReturn0920071$$" variable
		And I save the window as "$$PurchaseReturn0920071$$"
		And I save the value of the field named "Number" as "$$NumberPurchaseReturn0920071$$"
		And I save the value of the field named "Date" as "$$DatePurchaseReturn0920071$$"
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$PurchaseReturn0920071$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Q'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I input "3,000" text in "Q" field of "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			* Create serial lot number for item
				And I click the button named "FormCreate"
				And I input "99098809009008" text in "Serial number" field
				And I click "Save and close" button
			And I go to line in "List" table
				| 'Owner'     | 'Serial number'  |
				| '38/Yellow' | '99098809009008' |
			And I activate "Serial number" field in "List" table
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3,000'    | '99098809009008'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Purchase return and check movements in the register R4014 Serial lot numbers
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseReturn0920071$$'            | ''            | ''                              | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                              | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                              | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                        | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                              | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Expense'     | '$$DatePurchaseReturn0920071$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
			| ''                                     | 'Expense'     | '$$DatePurchaseReturn0920071$$' | '2'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009008'    |
		And I close current window
	* Check the message to the user when the serial number was not filled in
		And I activate "$$PurchaseReturn0920071$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that does not use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change item that does not use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
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
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	And I close all client application windows

Scenario: _0920072 check filling in serial lot number in the PurchaseReturn	from Purchase invoice
	* Create Purchase return based on Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'     |
			| '29' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormDocumentPurchaseReturnGenerate"
		And I click "OK" button
	* Check filling in serial lot number from Purchase invoice
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Purchase invoice'                              | 'Purchase return order' | 'Total amount' | 'Store'    |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '400,00' | '18%' | ''              | '1 016,95'   | 'Purchase invoice 29 dated 25.01.2021 12:37:04' | ''                      | '1 200,00'     | 'Store 01' |
		And I click the button named "FormPost"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Q'     | 'Unit' | 'Dont calculate row' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Purchase invoice'                              | 'Purchase return order' | 'Total amount' | 'Store'    |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000' | 'pcs'  | 'No'                 | '183,05'     | '400,00' | '18%' | ''              | '1 016,95'   | 'Purchase invoice 29 dated 25.01.2021 12:37:04' | ''                      | '1 200,00'     | 'Store 01' |
		And I close all client application windows
		
					


Scenario: _092008 check serial lot number in the Opening entry
	* Create Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of the attribute named "InventoryItem" in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "InventoryItemKey" in "Inventory" table
		And I click choice button of the attribute named "InventoryItemKey" in "Inventory" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "1,000" text in "Quantity" field of "Inventory" table	
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' | 
			| 'Store 01'    |
		And I select current line in "List" table	
		And I click choice button of "Item serial/lot number" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Owner'   | 'Serial number' |
			| '38/Yellow' | '99098809009999'            |
		And I select current line in "List" table
		And I finish line editing in "Inventory" table	
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of the attribute named "InventoryItem" in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "InventoryItemKey" in "Inventory" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
		And I input "1,000" text in "Quantity" field of "Inventory" table
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' | 
			| 'Store 01'    |
		And I select current line in "List" table		
		And I finish line editing in "Inventory" table
	* Post Opening entry and check movements
		And I click the button named "FormPost"
		And I delete "$$OpeningEntry092008$$" variable
		And I delete "$$NumberOpeningEntry092008$$" variable
		And I delete "$$DateOpeningEntry092008$$" variable
		And I save the window as "$$OpeningEntry092008$$"
		And I save the value of the field named "Number" as "$$NumberOpeningEntry092008$$"
		And I save the value of the field named "Date" as "$$DateOpeningEntry092008$$"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$OpeningEntry092008$$'               | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                           | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '$$DateOpeningEntry092008$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
		And I close current window
	* Clear post Opening entry and check movements
		And I activate "$$OpeningEntry092008$$" window			
		And I click "Clear posting" button
		And I click "Registrations report" button		
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4014 Serial lot numbers"'    |
		And I close current window
	* Change quantity, post document and check movements
		And I activate "$$OpeningEntry092008$$" window
		And I go to line in "Inventory" table
			| 'Item'     | 'Item key'  | 'Item serial/lot number' | 'Quantity' |
			| 'Trousers' | '38/Yellow' | '99098809009999'                     | '1,000'    |
		And I select current line in "Inventory" table
		And I input "5,000" text in "Quantity" field of "Inventory" table
		And I finish line editing in "Inventory" table
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$OpeningEntry092008$$'               | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                           | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '$$DateOpeningEntry092008$$' | '5'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
		And I close current window
	* Add one more string with the same item and different Serial lot number
		And I activate "$$OpeningEntry092008$$" window
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I click choice button of the attribute named "InventoryItem" in "Inventory" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "InventoryItemKey" in "Inventory" table
		And I click choice button of the attribute named "InventoryItemKey" in "Inventory" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "8,000" text in "Quantity" field of "Inventory" table	
		And I click choice button of "Store" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Description' | 
			| 'Store 01'    |
		And I select current line in "List" table	
		And I click choice button of "Item serial/lot number" attribute in "Inventory" table
		And I go to line in "List" table
			| 'Owner'   | 'Serial number' |
			| '38/Yellow' | '99098809009910'            |
		And I select current line in "List" table
		And I finish line editing in "Inventory" table	
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I click "Generate report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$OpeningEntry092008$$'               | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                           | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                     | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                           | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '$$DateOpeningEntry092008$$' | '5'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
			| ''                                     | 'Receipt'     | '$$DateOpeningEntry092008$$' | '8'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009910'    |
		And I close all client application windows


Scenario: _092009 check serial lot number in the Stock adjustment as surplus
	* Create stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
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
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListRevenueType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Revenue' |
		And I select current line in "List" table
		And I input "1,00" text in "Quantity" field of "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "2,00" text in "Quantity" field of "ItemList" table	
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListRevenueType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Revenue' |
		And I select current line in "List" table	
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Boots'    | '38/18SD' | '2,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Stock adjustment as surplus and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$StockAdjustmentAsSurplus092009$$" variable
		And I delete "$$NumberStockAdjustmentAsSurplus092009$$" variable
		And I delete "$$DateStockAdjustmentAsSurplus092009$$" variable
		And I save the window as "$$StockAdjustmentAsSurplus092009$$"
		And I save the value of the field named "Number" as "$$NumberStockAdjustmentAsSurplus092009$$"
		And I save the value of the field named "Date" as "$$DateStockAdjustmentAsSurplus092009$$"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$StockAdjustmentAsSurplus092009$$'   | ''            | ''                                       | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                                       | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                                       | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                                 | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                                       | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '$$DateStockAdjustmentAsSurplus092009$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
		And I close all client application windows
		

	
Scenario: _0920091 check serial lot number controls in the Stock adjustment as surplus	
	* Create stock adjustment as surplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
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
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListRevenueType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Revenue' |
		And I select current line in "List" table
		And I input "1,00" text in "Quantity" field of "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "2,00" text in "Quantity" field of "ItemList" table	
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListRevenueType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Revenue' |
		And I select current line in "List" table	
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Post Stock adjustment as surplus and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$StockAdjustmentAsSurplus0920091$$" variable
		And I delete "$$NumberStockAdjustmentAsSurplus0920091$$" variable
		And I delete "$$DateStockAdjustmentAsSurplus0920091$$" variable
		And I save the window as "$$StockAdjustmentAsSurplus0920091$$"
		And I save the value of the field named "Number" as "$$NumberStockAdjustmentAsSurplus0920091$$"
		And I save the value of the field named "Date" as "$$DateStockAdjustmentAsSurplus0920091$$"
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$StockAdjustmentAsSurplus0920091$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I go to line in "List" table
				| 'Owner'     | 'Serial number'  |
				| '38/Yellow' | '99098809009008' |
			And I activate "Serial number" field in "List" table
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3,000'    | '99098809009008'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post Stock adjustment as surplus and check movements in the register R4014 Serial lot numbers
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$StockAdjustmentAsSurplus0920091$$'  | ''            | ''                                        | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                                        | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                                        | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                                  | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                                        | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '$$DateStockAdjustmentAsSurplus0920091$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
			| ''                                     | 'Receipt'     | '$$DateStockAdjustmentAsSurplus0920091$$' | '2'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009008'    |
		And I close current window
	* Check the message to the user when the serial number was not filled in
		And I activate "$$StockAdjustmentAsSurplus0920091$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListRevenueType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Revenue' |
		And I select current line in "List" table	
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that does not use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change item that does not use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
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
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	And I close all client application windows		



Scenario: _092010 check serial lot number in the Stock adjustment as write off
	* Create stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
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
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListExpenseType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Expense' |
		And I select current line in "List" table
		And I input "1,00" text in "Quantity" field of "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "2,00" text in "Quantity" field of "ItemList" table	
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListExpenseType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Expense' |
		And I select current line in "List" table	
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Boots'    | '38/18SD' | '2,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Stock adjustment as surplus and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$StockAdjustmentAsWriteOff092010$$" variable
		And I delete "$$NumberStockAdjustmentAsWriteOff092010$$" variable
		And I delete "$$DateStockAdjustmentAsWriteOff092010$$" variable
		And I save the window as "$$StockAdjustmentAsWriteOff092010$$"
		And I save the value of the field named "Number" as "$$NumberStockAdjustmentAsWriteOff092010$$"
		And I save the value of the field named "Date" as "$$DateStockAdjustmentAsWriteOff092010$$"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$StockAdjustmentAsWriteOff092010$$'  | ''            | ''                                        | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                                        | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                                        | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                                  | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                                        | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Expense'     | '$$DateStockAdjustmentAsWriteOff092010$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
		And I close all client application windows
		

	
Scenario: _09200101 check serial lot number controls in the Stock adjustment as write off	
	* Create stock adjustment as write off
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
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
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListExpenseType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Expense' |
		And I select current line in "List" table
		And I input "1,00" text in "Quantity" field of "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "2,00" text in "Quantity" field of "ItemList" table	
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListExpenseType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Expense' |
		And I select current line in "List" table	
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Post Stock adjustment as write off and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$StockAdjustmentAsWriteOff09200101$$" variable
		And I delete "$$NumberStockAdjustmentAsWriteOff09200101$$" variable
		And I delete "$$DateStockAdjustmentAsWriteOff09200101$$" variable
		And I save the window as "$$StockAdjustmentAsWriteOff09200101$$"
		And I save the value of the field named "Number" as "$$NumberStockAdjustmentAsWriteOff09200101$$"
		And I save the value of the field named "Date" as "$$DateStockAdjustmentAsWriteOff09200101$$"
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$StockAdjustmentAsWriteOff09200101$$" window
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [1] by serial/lot numbers" substring will appear in "30" seconds
		* Add one more serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And I go to line in "List" table
				| 'Owner'     | 'Serial number'  |
				| '38/Yellow' | '99098809009008' |
			And I activate "Serial number" field in "List" table
			And I click the button named "FormChoose"
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I input "3,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
		And I click the button named "FormPost"
		Then I wait that in user messages the "Quantity [3] does not match the quantity [4] by serial/lot numbers" substring will appear in "30" seconds
		* Change serial/lot numbers quantity to 3
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
			And I go to line in "SerialLotNumbers" table
				| 'Quantity' | 'Serial lot number' |
				| '3,000'    | '99098809009008'    |
			And I activate "Quantity" field in "SerialLotNumbers" table
			And I select current line in "SerialLotNumbers" table
			And I input "2,000" text in "Quantity" field of "SerialLotNumbers" table
			And I finish line editing in "SerialLotNumbers" table
			And I click "Ok" button
	* Post stock adjustment as write off and check movements in the register R4014 Serial lot numbers
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$StockAdjustmentAsWriteOff09200101$$' | ''            | ''                                          | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'        | ''            | ''                                          | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"'  | ''            | ''                                          | ''          | ''             | ''       | ''          | ''                  |
			| ''                                      | 'Record type' | 'Period'                                    | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                      | ''            | ''                                          | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                      | 'Expense'     | '$$DateStockAdjustmentAsWriteOff09200101$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009999'    |
			| ''                                      | 'Expense'     | '$$DateStockAdjustmentAsWriteOff09200101$$' | '2'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009008'    |
		And I close current window
	* Check the message to the user when the serial number was not filled in
		And I activate "$$StockAdjustmentAsWriteOff09200101$$" window
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "List" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListExpenseType" in "ItemList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Expense' |
		And I select current line in "List" table	
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	* Change item that uses serial lot number to item that does not use serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then user message window does not contain messages
	* Change item that does not use serial lot number to item that uses serial lot number and check user message
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I activate "Item" field in "ItemList" table
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
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Item serial/lot numbers] is empty." substring will appear in "30" seconds
	And I close all client application windows	

Scenario: _092011 check serial lot number in the Item stock adjustment
	* Create Item stock adjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
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
		And I input "1,00" text in "Quantity" field of "ItemList" table
		And I activate "Serial lot number (surplus)" field in "ItemList" table
		And I click choice button of "Serial lot number (surplus)" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Owner'   | 'Serial number' |
			| '38/Yellow' | '99098809009910'             |
		And I select current line in "List" table
		And I click choice button of "Item key (write off)" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		And I select current line in "List" table
		And I activate "Serial lot number (write off)" field in "ItemList" table
		And I click choice button of "Serial lot number (write off)" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Owner'   | 'Serial number' |
			| '38/Yellow' | '99098809009999'            |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"	
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item key (surplus)" attribute in "ItemList" table		
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table	
		And I input "2,00" text in "Quantity" field of "ItemList" table	
		And I click choice button of "Item key (write off)" attribute in "ItemList" table		
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '36/18SD'  |
		And I select current line in "List" table
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key (surplus)' | 'Quantity' |
			| 'Boots' | '38/18SD'            | '2,000'    |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        	|"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|
	* Post Stock adjustment as surplus and check movements in the register Register  "R4014 Serial lot numbers"
		And I click the button named "FormPost"
		And I delete "$$ItemStockAdjustment092011$$" variable
		And I delete "$$NumberItemStockAdjustment092011$$" variable
		And I delete "$$DateItemStockAdjustment092011$$" variable
		And I save the window as "$$ItemStockAdjustment092011$$"
		And I save the value of the field named "Number" as "$$NumberItemStockAdjustment092011$$"
		And I save the value of the field named "Date" as "$$DateItemStockAdjustment092011$$"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$ItemStockAdjustment092011$$'        | ''            | ''                                  | ''          | ''             | ''       | ''          | ''                  |
			| 'Document registrations records'       | ''            | ''                                  | ''          | ''             | ''       | ''          | ''                  |
			| 'Register  "R4014 Serial lot numbers"' | ''            | ''                                  | ''          | ''             | ''       | ''          | ''                  |
			| ''                                     | 'Record type' | 'Period'                            | 'Resources' | 'Dimensions'   | ''       | ''          | ''                  |
			| ''                                     | ''            | ''                                  | 'Quantity'  | 'Company'      | 'Branch' | 'Item key'  | 'Serial lot number' |
			| ''                                     | 'Receipt'     | '$$DateItemStockAdjustment092011$$' | '1'         | 'Main Company' | '*'      | '38/Yellow' | '99098809009910'    |
			| ''                                     | 'Expense'     | '$$DateItemStockAdjustment092011$$' | '1'         | 'Main Company' | '*'      | '36/Yellow' | '99098809009999'    |
		And I close all client application windows
		
Scenario: _092015 check serial lot number in the Shipment confirmation
		And I close all client application windows
	* Create Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'    |
		And I select current line in "List" table
		And I select "Sales" exact value from "Transaction type" drop-down list		
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Ferron BP' |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table		
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|

Scenario: _092016 check serial lot number in the Goods receipt
		And I close all client application windows
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I select "Purchase" exact value from "Transaction type" drop-down list		
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Company Ferron BP' |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table		
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|

Scenario: _092007 check serial lot number in the Inventory transfer
		And I close all client application windows
	* Create Inventory transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
		And I select current line in "List" table
	* Add items (first item with serial lot number, second - without serial lot number)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '38/18SD'  |
		And I select current line in "List" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table		
	* Filling in serial lot number in the first string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Trousers' | '38/Yellow' | '1,000' |
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		* Create serial lot number for item
			And I click the button named "FormCreate"
			And I input "99098809009999" text in "Serial number" field
			And I click "Save and close" button
		And I go to line in "List" table
			| 'Owner'     | 'Serial number'  |
			| '38/Yellow' | '99098809009999' |
		And I activate "Serial number" field in "List" table
		And I click the button named "FormChoose"
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
	* Check that the field Serial lot number is inactive in the second string
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity'     |
			| 'Boots'    | '38/18SD' | '1,000' |
		And I select current line in "ItemList" table
		When I Check the steps for Exception
        |"And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table"|

Scenario: _092020 check choice form Serial Lot number
		And I close all client application windows
	* Create Serial lot number
		Given I open hyperlink "e1cib/list/Catalog.SerialLotNumbers"
		* For item key (Dree M/Brown)
			And I click the button named "FormCreate"
			And I input "099995" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item key' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item key (Dree M/White)
			And I click the button named "FormCreate"
			And I input "89999" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item key' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item (Dress)
			And I click the button named "FormCreate"
			And I input "05" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Dress' |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item (Boots)
			And I click the button named "FormCreate"
			And I input "06" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Boots' |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item type (Clothes)
			And I click the button named "FormCreate"
			And I input "07" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item type' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Clothes' |
			And I select current line in "List" table
			And I click "Save and close" button
		* For item type (Shoes)
			And I click the button named "FormCreate"
			And I input "08" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item type' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Shoes' |
			And I select current line in "List" table
			And I click "Save and close" button
		* Without owner
			And I click the button named "FormCreate"
			And I input "10" text in "Serial number" field
			And I click "Save and close" button
		* Inactive
			And I click the button named "FormCreate"
			And I input "11" text in "Serial number" field
			And I click Select button of "Owner" field
			And I go to line in "" table
				| ''         |
				| 'Item type' |
			And I select current line in "" table
			And I go to line in "List" table
				| 'Description'  |
				| 'Clothes' |
			And I select current line in "List" table
			And I set checkbox "Inactive"
			And I click "Save and close" button
	* Check box Use serial lot number for shoes
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'     |
		And I select current line in "List" table
		And I set checkbox "Use serial lot number"
		And I click "Save and close" button	
	* Сheck choice form
		* Create Sales invoice
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
		* Add items (first item with serial lot number, second - without serial lot number)
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '38/18SD'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/Brown'  |
			And I select current line in "List" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'L/Green'  |
			And I select current line in "List" table
		* Сheck choice form Serial lot number
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  | 'Q'     |
				| 'Trousers' | '38/Yellow' | '1,000' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '05'             | 'Dress'     |
			| '8999'           | 'M/White'   |
			| '8999'           | 'M/Brown'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '07'             | 'Clothes'   |
			| '10'             | ''          |
			And I close current window
			And I close "Select serial lot numbers *" window
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'|
				| 'Boots'    | '38/18SD' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '8999'           | 'M/White'   |
			| '8999'           | 'M/Brown'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			And I close "Item serial/lot numbers" window
			And I close "Select serial lot numbers *" window
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'|
				| 'Dress'    | 'M/White' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '8999'           | 'M/Brown'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '89999'          | 'M/White'   |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			And I close "Item serial/lot numbers" window
			And I close "Select serial lot numbers *" window
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'|
				| 'Dress'    | 'M/Brown' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '89999'          | 'M/White'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '099995'         | 'M/Brown'   |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '10'             | ''          |
			And I close "Item serial/lot numbers" window
			And I close "Select serial lot numbers *" window
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'|
				| 'Dress'    | 'L/Green' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListSerialLotNumbersPresentation" in "ItemList" table	
			And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
			And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
			And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '11'             | 'Clothes'   |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '89999'          | 'M/White'   |
			| '099995'         | 'M/Brown'   |
			And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '10'             | ''          |
			And I close "Item serial/lot numbers" window
			And I close "Select serial lot numbers *" window
		And I close all client application windows


Scenario: _092025 check Serial lot number tab in the Item/item key
	* Select Item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'     |
		And I select current line in "List" table
	* Check Serial lot number tab
		And In this window I click command interface button "Serial lot numbers"
		And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '11'             | 'Clothes'   |
		And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '89999'          | 'M/White'   |
			| '99098809009910' | '38/Yellow' |
	* Select item key without own Serial lot number
		And In this window I click command interface button "Item keys"
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And In this window I click command interface button "Serial lot numbers"
		And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '11'             | 'Clothes'   |
		And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '89999'          | 'M/White'   |
			| '99098809009910' | '38/Yellow' |
		And I close current window
	* Select item key with own Serial lot number
		And In this window I click command interface button "Item keys"
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And In this window I click command interface button "Serial lot numbers"
		And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '07'             | 'Clothes'   |
			| '05'             | 'Dress'     |
			| '11'             | 'Clothes'   |
			| '89999'		   | 'M/White'   |
		And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '99098809009910' | '38/Yellow' |
		And I close all client application windows
		
Scenario: _092030 check Serial lot number tab in the Item type
	And I close all client application windows
	* Select Item type with own Serial lot number
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
	* Check Serial lot number tab 
		And In this window I click command interface button "Serial lot numbers"
		And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
			| '07'             | 'Clothes'   |
			| '11'             | 'Clothes'   |
		And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '89999'          | 'M/White'   |
			| '99098809009910' | '38/Yellow' |
			| '05'             | 'Dress'     |
	And I close all client application windows 
	* Select Item type without own Serial lot number
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Bags'     |
		And I select current line in "List" table
	* Check Serial lot number tab 
		And In this window I click command interface button "Serial lot numbers"
		And "List" table contains lines
			| 'Serial number'  | 'Owner'     |
			| '10'             | ''          |
		And "List" table does not contain lines
			| 'Serial number'  | 'Owner'     |
			| '08'             | 'Shoes'     |
			| '06'             | 'Boots'     |
			| '89999'          | 'M/White'   |
			| '99098809009910' | '38/Yellow' |
			| '05'             | 'Dress'     |
			| '07'             | 'Clothes'   |
			| '11'             | 'Clothes'   |
	And I close all client application windows
	
		
Scenario: _092035 product scanning with and without serial lot number
	* Create barcodes with serial lot number
		Given I open hyperlink "e1cib/list/InformationRegister.Barcodes"
		If "List" table does not contain lines Then
				| 'Barcode'       | 'Item key' | 'Item serial/lot number' | 'Unit' |
				| '590876909358'  | 'M/White'  | '89999'                  | 'pcs'  |
				| '590876909359'  | '38/Yellow'| '99098809009910'         | 'pcs'  |
			And I click the button named "FormCreate"
			And I click Select button of "Item key" field
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'  |
			And I select current line in "List" table
			And I input "590876909358" text in "Barcode" field
			And I input "590876909358" text in "Presentation" field
			And I click Select button of "Item serial/lot number" field
			And I go to line in "List" table
				| 'Owner'   | 'Serial number' |
				| 'M/White' | '89999'         |
			And I select current line in "List" table
			And I click "Save and close" button
			And I click the button named "FormCreate"
			And I click Select button of "Item key" field
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Trousers' | '38/Yellow'  |
			And I select current line in "List" table
			And I input "590876909359" text in "Barcode" field
			And I input "590876909359" text in "Presentation" field
			And I click Select button of "Item serial/lot number" field
			And I go to line in "List" table
				| 'Owner'   | 'Serial number' |
				| '38/Yellow' | '99098809009910'         |
			And I select current line in "List" table
			And I click "Save and close" button
			And I close current window
	* Check product scanning with serial lot number
		And In the command interface I select "Retail" "Point of sale"
		And I click "Search by barcode (F7)" button
		And I input "590876909358" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Serial number' | 'Quantity' |
			| 'Dress' | 'M/White'  | '89999'         | '1,000'    |
		And "SerialLotNumbersTree" table became equal
			| 'Item'  | 'Item key' | 'Serial lot number' | 'Quantity' | 'Item key quantity' |
			| 'Dress' | 'M/White'  | ''                  | '1,000'    | '1,000'             |
			| ''      | ''         | '89999'             | '1,000'    | ''                  |
		And I click "Search by barcode (F7)" button
		And I input "590876909358" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Serial number' | 'Quantity' |
			| 'Dress' | 'M/White'  | '89999; 89999'  | '2,000'    |
		And "SerialLotNumbersTree" table became equal
			| 'Item'  | 'Item key' | 'Serial lot number' | 'Quantity' | 'Item key quantity' |
			| 'Dress' | 'M/White'  | ''                  | '2,000'    | '2,000'             |
			| ''      | ''         | '89999'             | '1,000'    | ''                  |		
			| ''      | ''         | '89999'             | '1,000'    | ''                  |	
	* Check product scanning without own serial lot number
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in "InputFld" field
		And I click "OK" button
		Then "Select serial lot numbers" window is opened
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I click choice button of "Serial lot number" attribute in "SerialLotNumbers" table
		And I activate "Owner" field in "List" table
		And I activate "Serial number" field in "List" table
		And I go to line in "List" table
				| 'Serial number' |
				| '10'         |
		And I select current line in "List" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Serial number' | 'Quantity' |
			| 'Dress' | 'M/White'  | '89999; 89999'  | '2,000'    |
			| 'Dress' | 'XS/Blue'  | '10'            | '1,000'    |
		And "SerialLotNumbersTree" table became equal
			| 'Item'  | 'Item key' | 'Serial lot number' | 'Quantity' | 'Item key quantity' |
			| 'Dress' | 'M/White'  | ''                  | '2,000'    | '2,000'             |
			| ''      | ''         | '89999'             | '1,000'    | ''                  |
			| ''      | ''         | '89999'             | '1,000'    | ''                  |
			| 'Dress' | 'XS/Blue'  | ''                  | '1,000'    | '1,000'             |
			| ''      | ''         | '10'                | '1,000'    | ''                  |
	* Check product scanning without own serial lot number (input  serial lot number by string)
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		Then "Select serial lot numbers" window is opened
		And in the table "SerialLotNumbers" I click the button named "SerialLotNumbersAdd"
		And I select "10" from "Serial lot number" drop-down list by string in "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I activate "Quantity" field in "SerialLotNumbers" table
		And I select current line in "SerialLotNumbers" table
		And I input "1,000" text in "Quantity" field of "SerialLotNumbers" table
		And I finish line editing in "SerialLotNumbers" table
		And I click "Ok" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Serial number' | 'Quantity' |
			| 'Dress' | 'M/White'  | '89999; 89999'  | '2,000'    |
			| 'Dress' | 'XS/Blue'  | '10'            | '1,000'    |
			| 'Dress' | 'L/Green'  | '10'            | '1,000'    |	
	* Check message if user scan new serial lot number
		And I click "Search by barcode (F7)" button
		And I input "2202283739" text in "InputFld" field
		And I click "OK" button
		Then "Select serial lot numbers" window is opened
		And I click "Search by barcode (F7)" button
		And I input "5908769093878" text in "InputFld" field
		And I click "OK" button
		Then the form attribute named "SerialLotNumberStatus" became equal to "Serial lot 5908769093878 was not found. Create new?"
		And I close all client application windows
		
		
				
Scenario: _092045 product scanning with serial lot number in the document without serial column
	* Open Sales order
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click "SearchByBarcode" button
	* Product scanning with serial lot number
		Then "Enter a barcode" window is opened
		And I input "590876909359" text in "InputFld" field
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I close all client application windows
		
Scenario: _092050 check filling in serial lot number in the GR from Purchase invoice
	* Create GR based on Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'     |
			| '29' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "OK" button
	* Check filling in serial lot number from Purchase invoice
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Purchase invoice'                              | 'Store'    |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000'    | 'pcs'  | 'Purchase invoice 29 dated 25.01.2021 12:37:04' | 'Store 01' |
		And I click the button named "FormPost"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Purchase invoice'                              | 'Store'    |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000'    | 'pcs'  | 'Purchase invoice 29 dated 25.01.2021 12:37:04' | 'Store 01' |
		And I close all client application windows	


Scenario: _092051 check filling in serial lot number in the SC from Sales invoice
	* Create SC based on Sales invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'     |
			| '1 029' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "OK" button
	* Check filling in serial lot number from Sales invoice
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Sales invoice'                                 | 'Store'    |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000'    | 'pcs'  | 'Sales invoice 1 029 dated 16.02.2022 13:02:27' | 'Store 01' |
		And I click the button named "FormPost"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Sales invoice'                                 | 'Store'    |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000'    | 'pcs'  | 'Sales invoice 1 029 dated 16.02.2022 13:02:27' | 'Store 01' |
		And I close all client application windows

Scenario: _092052 check filling in serial lot number in the SI from SC
	* Create SI based on SC
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'     |
			| '1 029' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "OK" button
	* Check filling in serial lot number from SC
		And "ItemList" table became equal
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Q'     | 'Unit' | 'Store'    | 'Use shipment confirmation' |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000' | 'pcs'  | 'Store 01' | 'Yes'                       |		
		And I click the button named "FormPost"
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Q'     | 'Unit' | 'Store'    | 'Use shipment confirmation' |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000' | 'pcs'  | 'Store 01' | 'Yes'                       |
		And I close all client application windows

Scenario: _092053 check filling in serial lot number in the PI from GR
	* Create PI based on GR
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'     |
			| '1 029' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "OK" button
	* Check filling in serial lot number from GR
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Q'     | 'Unit' | 'Store'    | 'Use goods receipt' |
			| 'Trousers' | '38/Yellow' | '0512; 0514'         | '3,000' | 'pcs'  | 'Store 01' | 'Yes'               |
		And I close all client application windows

Scenario: _092054 check filling in serial lot number in the SC from IT
	* Create SC based on IT
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'     |
			| '1 029' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "OK" button
	* Check filling in serial lot number from IT
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Store'    |
			| 'Trousers' | '36/Yellow' | '0512; 0514'         | '3,000'    | 'pcs'  | 'Store 02' |
		And I close all client application windows	

Scenario: _092055 check filling in serial lot number in the GR from IT
	* Create GR based on IT
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I go to line in "List" table
			| 'Number'     |
			| '1 029' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "OK" button
	* Check filling in serial lot number from IT
		And "ItemList" table contains lines
			| 'Item'     | 'Item key'  | 'Serial lot numbers' | 'Quantity' | 'Unit' | 'Store'    |
			| 'Trousers' | '36/Yellow' | '0512; 0514'         | '3,000'    | 'pcs'  | 'Store 03' |
		And I close all client application windows


Scenario: _092090 uncheck checkbox Use serial lot number in the Item type
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Check box Use serial lot number
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I remove checkbox "Use serial lot number"
		And I click "Save and close" button	
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'     |
		And I select current line in "List" table
		And I remove checkbox "Use serial lot number"
		And I click "Save and close" button	
	* Check saving
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to ""
		Then the form attribute named "UseSerialLotNumber" became equal to "No"
		And I close current window
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'     |
		And I select current line in "List" table
		Then the form attribute named "Parent" became equal to ""
		Then the form attribute named "UseSerialLotNumber" became equal to "No"
	And I close all client application windows




		







	
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

Scenario: _092001 checkbox Use serial lot number in the Item type
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Check box Use serial lot number
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I set checkbox "Use serial lot number"
		And I click "Save and close" button	
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
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click the button named "FormPost"
		And I delete "$$RetailSalesReceipt092002$$" variable
		And I delete "$$NumberRetailSalesReceipt092002$$" variable
		And I save the window as "$$RetailSalesReceipt092002$$"
		And I save the value of the field named "Number" as "$$NumberRetailSalesReceipt092002$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                     | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                                    | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '68,48'  |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '111,28' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
	* Сhange the quantity and check that the quantity of the serial lot numbers matches the quantity in the document
		And I activate "$$RetailSalesReceipt092002$$" window
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
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click the button named "FormPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                     | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                                    | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '68,48'  |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '111,28' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009999'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2,000'    | '800,00' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2,000'    | '800,00' |
			| 'USD'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2,000'    | '136,96' |
			| 'TRY'      | '$$RetailSalesReceipt092002$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$'                     | '38/Yellow' | '99098809009998'    | '2,000'    | '800,00' |
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
		And in the table "Payments" I click the button named "PaymentsAdd"
		And I click choice button of "Payment type" attribute in "Payments" table
		And I go to line in "List" table
			| 'Description' |
			| 'Cash'        |
		And I select current line in "List" table
		And I activate field named "PaymentsAmount" in "Payments" table
		And I input "2 550,00" text in the field named "PaymentsAmount" of "Payments" table
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
	And I select "Retail sales" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| '$$RetailSalesReceipt092002$$'   | ''            | ''       | ''          | ''       | ''           | ''              | ''             | ''              | ''         | ''                             | ''          | ''                  | ''        |
		| 'Document registrations records' | ''            | ''       | ''          | ''       | ''           | ''              | ''             | ''              | ''         | ''                             | ''          | ''                  | ''        |
		| 'Register  "Retail sales"'       | ''            | ''       | ''          | ''       | ''           | ''              | ''             | ''              | ''         | ''                             | ''          | ''                  | ''        |
		| ''                               | 'Record type' | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''              | ''         | ''                             | ''          | ''                  | ''        |
		| ''                               | ''            | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Business unit' | 'Store'    | 'Retail sales receipt'         | 'Item key'  | 'Serial lot number' | 'Row key' |
		| ''                               | 'Receipt'     | '*'      | '1'         | '400'    | '338,98'     | ''              | 'Main Company' | ''              | 'Store 01' | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '*'       |
		| ''                               | 'Receipt'     | '*'      | '1'         | '650'    | '550,85'     | ''              | 'Main Company' | ''              | 'Store 01' | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '*'       |
		| ''                               | 'Receipt'     | '*'      | '1'         | '700'    | '593,22'     | ''              | 'Main Company' | ''              | 'Store 01' | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '*'       |
		| ''                               | 'Receipt'     | '*'      | '2'         | '800'    | '677,97'     | ''              | 'Main Company' | ''              | 'Store 01' | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '*'       |
	And I select "Sales turnovers" exact value from "Register" drop-down list
	And I click "Generate report" button
	And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Sales turnovers"'    | ''            | ''          | ''          | ''           | ''              | ''              | ''                             | ''              | ''          | ''                             | ''                             | ''                  | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | ''              | 'Dimensions'    | ''                             | ''              | ''          | ''                             | ''                             | ''                  | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount' | 'Company'       | 'Sales invoice'                | 'Currency'      | 'Item key'  | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
		| ''                               | '*'           | '1'         | '68,48'     | '58,03'      | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'USD'           | '38/Yellow' | '*'                            | 'Reporting currency'           | '99098809009999'    | 'No'                   |
		| ''                               | '*'           | '1'         | '111,28'    | '94,31'      | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'USD'           | '38/18SD'   | '*'                            | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                               | '*'           | '1'         | '119,84'    | '101,56'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'USD'           | '37/18SD'   | '*'                            | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                               | '*'           | '1'         | '400'       | '338,98'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/Yellow' | '*'                            | 'Local currency'               | '99098809009999'    | 'No'                   |
		| ''                               | '*'           | '1'         | '400'       | '338,98'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/Yellow' | '*'                            | 'TRY'                          | '99098809009999'    | 'No'                   |
		| ''                               | '*'           | '1'         | '400'       | '338,98'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/Yellow' | '*'                            | 'en description is empty'      | '99098809009999'    | 'No'                   |
		| ''                               | '*'           | '1'         | '650'       | '550,85'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/18SD'   | '*'                            | 'Local currency'               | ''                  | 'No'                   |
		| ''                               | '*'           | '1'         | '650'       | '550,85'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/18SD'   | '*'                            | 'TRY'                          | ''                  | 'No'                   |
		| ''                               | '*'           | '1'         | '650'       | '550,85'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/18SD'   | '*'                            | 'en description is empty'      | ''                  | 'No'                   |
		| ''                               | '*'           | '1'         | '700'       | '593,22'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '37/18SD'   | '*'                            | 'Local currency'               | ''                  | 'No'                   |
		| ''                               | '*'           | '1'         | '700'       | '593,22'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '37/18SD'   | '*'                            | 'TRY'                          | ''                  | 'No'                   |
		| ''                               | '*'           | '1'         | '700'       | '593,22'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '37/18SD'   | '*'                            | 'en description is empty'      | ''                  | 'No'                   |
		| ''                               | '*'           | '2'         | '136,96'    | '116,07'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'USD'           | '38/Yellow' | '*'                            | 'Reporting currency'           | '99098809009998'    | 'No'                   |
		| ''                               | '*'           | '2'         | '800'       | '677,97'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/Yellow' | '*'                            | 'Local currency'               | '99098809009998'    | 'No'                   |
		| ''                               | '*'           | '2'         | '800'       | '677,97'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/Yellow' | '*'                            | 'TRY'                          | '99098809009998'    | 'No'                   |
		| ''                               | '*'           | '2'         | '800'       | '677,97'     | ''              | 'Main Company'  | '$$RetailSalesReceipt092002$$' | 'TRY'           | '38/Yellow' | '*'                            | 'en description is empty'      | '99098809009998'    | 'No'                   |

		
	
	
Scenario: _092003 check serial lot number in the Retail return receipt
	* Preparation
		And I delete '$$RetailReturnReceipt092003$$' variable
		And I delete '$$NumberRetailReturnReceipt092003$$' variable
	* Create Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			|'Number'|
			|'$$NumberRetailSalesReceipt092002$$'|
		And I click the button named "FormDocumentRetailReturnReceiptGenerateSalesReturn"
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
		And I move to "Other" tab
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shop 01'     |
		And I select current line in "List" table	
	* Post Retail return receipt and check movements in the register Sales turnovers
		And I click the button named "FormPost"
		And I delete "$$RetailReturnReceipt092003$$" variable
		And I save the window as "$$RetailReturnReceipt092003$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'                      | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                | 'Item key'  | 'Serial lot number' | 'Quantity'  | 'Amount' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '-1,000'    | '-400,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '-1,000'    | '-400,00' |
			| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '-1,000'    | '-68,48'  |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'    | '-650,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'    | '-650,00' |
			| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'    | '-111,28' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009999'    | '-1,000'    | '-400,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'    | '-650,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-2,000'    | '-800,00' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-2,000'    | '-800,00' |
			| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-2,000'    | '-136,96' |
			| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-2,000'    | '-800,00' |
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
	* Post Retail return receipt and check movements in the register Sales turnovers
		And I click the button named "FormPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                      | 'Company'      | 'Multi currency movement type' | 'Sales invoice'                | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount'  |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-1,000'   | '-400,00' |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-1,000'   | '-400,00' |
		| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-1,000'   | '-68,48'  |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
		| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'   | '-111,28' |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'TRY'                          | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Local currency'               | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' |
		| 'USD'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'Reporting currency'           | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '-1,000'   | '-119,84' |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/Yellow' | '99098809009998'    | '-1,000'   | '-400,00' |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
		| 'TRY'      | '$$RetailReturnReceipt092003$$' | 'Main Company' | 'en description is empty'      | '$$RetailSalesReceipt092002$$' | '37/18SD'   | ''                  | '-1,000'   | '-700,00' |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$RetailReturnReceipt092003$$" window
		And I click the button named "Add"
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
	* Post Retail sales receipt and check movements in the register Sales turnovers
		And I click the button named "FormPost"
		And I delete "$$SalesInvoice092004$$" variable
		And I delete "$$NumberSalesInvoice092004$$" variable
		And I save the window as "$$SalesInvoice092004$$"
		And I save the value of the field named "Number" as "$$NumberSalesInvoice092004$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'               | 'Company'      | 'Multi currency movement type' | 'Sales invoice'          | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '68,48'  |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '111,28' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
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
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'               | 'Company'      | 'Multi currency movement type' | 'Sales invoice'          | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '68,48'  |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '111,28' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '1,000'    | '400,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '1,000'    | '650,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '2,000'    | '800,00' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '2,000'    | '800,00' |
			| 'USD'      | '$$SalesInvoice092004$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '2,000'    | '136,96' |
			| 'TRY'      | '$$SalesInvoice092004$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '2,000'    | '800,00' |
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
		And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
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
	* Post Retail return receipt and check movements in the register Sales turnovers
		And I click the button named "FormPost"
		And I delete "$$SalesReturn092005$$" variable
		And I save the window as "$$SalesReturn092005$$"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Currency' | 'Recorder'              | 'Company'      | 'Multi currency movement type' | 'Sales invoice'          | 'Item key'  | 'Serial lot number' | 'Quantity' | 'Amount'  |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '-1,000'   | '-400,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '-1,000'   | '-400,00' |
			| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '-1,000'   | '-68,48'  |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
			| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-111,28' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009910'    | '-1,000'   | '-400,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   | '-650,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-2,000'   | '-800,00' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-2,000'   | '-800,00' |
			| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-2,000'   | '-136,96' |
			| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-2,000'   | '-800,00' |
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
	* Post Sales return and check movements in the register Sales turnovers
		And I click the button named "FormPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And Delay 3
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Company'      | 'Multi currency movement type' | 'Sales invoice'          | 'Item key'  | 'Serial lot number' | 'Quantity' |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-1,000'   |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-1,000'   |
		| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-1,000'   |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   |
		| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'TRY'                          | '$$SalesInvoice092004$$' | '37/18SD'   | ''                  | '-1,000'   |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'Local currency'               | '$$SalesInvoice092004$$' | '37/18SD'   | ''                  | '-1,000'   |
		| 'USD'      | '$$SalesReturn092005$$' | 'Main Company' | 'Reporting currency'           | '$$SalesInvoice092004$$' | '37/18SD'   | ''                  | '-1,000'   |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/Yellow' | '99098809009911'    | '-1,000'   |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '38/18SD'   | ''                  | '-1,000'   |
		| 'TRY'      | '$$SalesReturn092005$$' | 'Main Company' | 'en description is empty'      | '$$SalesInvoice092004$$' | '37/18SD'   | ''                  | '-1,000'   |
	* Check the message to the user when the serial number was not filled in
		And I activate "$$SalesReturn092005$$" window
		And I click the button named "Add"
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


Scenario: _092009 check choice form Serial Lot number
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


Scenario: _092011 check Serial lot number tab in the Item/item key
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
		
Scenario: _092012 check Serial lot number tab in the Item type
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
	
		
Scenario: _092015 product scanning with and without serial lot number
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
		
		
				
Scenario: _092025 product scanning with serial lot number in the document without serial column
	* Open Sales order
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




		







	
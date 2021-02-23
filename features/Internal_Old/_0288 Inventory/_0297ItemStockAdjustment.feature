#language: en
@tree
@Positive

@Inventory

Feature: Item Stock adjustment

Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _0297000 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When update ItemKeys

Scenario: _0297001 create Item stock adjustment
	Given I open hyperlink 'e1cib/list/Document.ItemStockAdjustment'
	And I click the button named "FormCreate"
	* Filling in Company and Store
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Add items
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key (surplus)" field in "ItemList" table
		And I click choice button of "Item key (surplus)" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Item key (write off)" field in "ItemList" table
		And I click choice button of "Item key (write off)" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'box Dress (8 pcs)' |
		And I select current line in "List" table		
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key (surplus)" field in "ItemList" table
		And I click choice button of "Item key (surplus)" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key' |
			| 'Trousers' |'36/Yellow' |
		And I select current line in "List" table
		And I activate "Item key (write off)" field in "ItemList" table
		And I click choice button of "Item key (write off)" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key' |
			| 'Trousers' | '38/Yellow'  |
		And I activate field named "ItemKey" in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "3,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post
		And I click the button named "FormPost"
		And I delete "$$ItemStockAdjustment0297001$$" variable
		And I delete "$$NumberItemStockAdjustment0297001$$" variable
		And I delete "$$DateItemStockAdjustment0297001$$" variable
		And I save the window as "$$ItemStockAdjustment0297001$$"
		And I save the value of "Number" field as "$$NumberItemStockAdjustment0297001$$"
		And I save the value of "Date" field as "$$DateItemStockAdjustment0297001$$"
		And I close current window

Scenario: _0297002 check Item stock adjustment movements in the register R4010 Actual stocks
	* Select document
		Given I open hyperlink 'e1cib/list/Document.ItemStockAdjustment'
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberItemStockAdjustment0297001$$' |
		And I click "Registrations report" button
	* Check movements
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$ItemStockAdjustment0297001$$'  | ''            | ''                                   | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'  | ''            | ''                                   | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"' | ''            | ''                                   | ''          | ''           | ''         | ''                  |
			| ''                                | 'Record type' | 'Period'                             | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                | ''            | ''                                   | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                | 'Receipt'     | '$$DateItemStockAdjustment0297001$$' | '16'        | 'Store 02'   | 'XS/Blue'  | ''                  |
			| ''                                | 'Expense'     | '$$DateItemStockAdjustment0297001$$' | '16'        | 'Store 02'   | 'M/White'  | ''                  |
			| ''                                | 'Receipt'     | '$$DateItemStockAdjustment0297001$$' | '3'         | 'Store 02'   | '36/Yellow'| ''                  |
			| ''                                | 'Expense'     | '$$DateItemStockAdjustment0297001$$' | '3'         | 'Store 02'   | '38/Yellow'| ''                  |
		And I close all client application windows
		
Scenario: _0297003 check Item stock adjustment movements in the register R4050 Stock inventory
	* Select document
		Given I open hyperlink 'e1cib/list/Document.ItemStockAdjustment'
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberItemStockAdjustment0297001$$' |
		And I click "Registrations report" button
	* Check movements
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$ItemStockAdjustment0297001$$'    | ''            | ''                                   | ''          | ''             | ''         | ''          |
			| 'Document registrations records'    | ''            | ''                                   | ''          | ''             | ''         | ''          |
			| 'Register  "R4050 Stock inventory"' | ''            | ''                                   | ''          | ''             | ''         | ''          |
			| ''                                  | 'Record type' | 'Period'                             | 'Resources' | 'Dimensions'   | ''         | ''          |
			| ''                                  | ''            | ''                                   | 'Quantity'  | 'Company'      | 'Store'    | 'Item key'  |
			| ''                                  | 'Receipt'     | '$$DateItemStockAdjustment0297001$$' | '16'        | 'Main Company' | 'Store 02' | 'XS/Blue'   |
			| ''                                  | 'Receipt'     | '$$DateItemStockAdjustment0297001$$' | '3'         | 'Main Company' | 'Store 02' | '36/Yellow' |
			| ''                                  | 'Expense'     | '$$DateItemStockAdjustment0297001$$' | '16'        | 'Main Company' | 'Store 02' | 'M/White'   |
			| ''                                  | 'Expense'     | '$$DateItemStockAdjustment0297001$$' | '3'         | 'Main Company' | 'Store 02' | '38/Yellow' |
		And I close all client application windows

	
Scenario: _0297004 check Item stock adjustment movements in the register R4011 Free stocks
	* Select document
		Given I open hyperlink 'e1cib/list/Document.ItemStockAdjustment'
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberItemStockAdjustment0297001$$' |
		And I click "Registrations report" button
	* Check movements
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$ItemStockAdjustment0297001$$' | ''            | ''                                   | ''          | ''           | ''          | ''                  |
			| 'Document registrations records' | ''            | ''                                   | ''          | ''           | ''          | ''                  |
			| 'Register  "R4011 Free stocks"'  | ''            | ''                                   | ''          | ''           | ''          | ''                  |
			| ''                               | 'Record type' | 'Period'                             | 'Resources' | 'Dimensions' | ''          | ''                  |
			| ''                               | ''            | ''                                   | 'Quantity'  | 'Store'      | 'Item key'  | 'Serial lot number' |
			| ''                               | 'Receipt'     | '$$DateItemStockAdjustment0297001$$' | '16'        | 'Store 02'   | 'XS/Blue'   | ''                  |
			| ''                               | 'Receipt'     | '$$DateItemStockAdjustment0297001$$' | '3'         | 'Store 02'   | '36/Yellow' | ''                  |
			| ''                               | 'Expense'     | '$$DateItemStockAdjustment0297001$$' | '16'        | 'Store 02'   | 'M/White'   | ''                  |
			| ''                               | 'Expense'     | '$$DateItemStockAdjustment0297001$$' | '3'         | 'Store 02'   | '38/Yellow' | ''                  |
		And I close all client application windows
				
Scenario: _0297005 check Item stock adjustment movements in the register R4052 Stock adjustment (Surplus)
	* Select document
		Given I open hyperlink 'e1cib/list/Document.ItemStockAdjustment'
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberItemStockAdjustment0297001$$' |
		And I click "Registrations report" button
	* Check movements
		And I select "R4052 Stock adjustment (Surplus)" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$ItemStockAdjustment0297001$$'               | ''                                   | ''          | ''           | ''      | ''          |
			| 'Document registrations records'               | ''                                   | ''          | ''           | ''      | ''          |
			| 'Register  "R4052 Stock adjustment (Surplus)"' | ''                                   | ''          | ''           | ''      | ''          |
			| ''                                             | 'Period'                             | 'Resources' | 'Dimensions' | ''      | ''          |
			| ''                                             | ''                                   | 'Quantity'  | 'Store'      | 'Basis' | 'Item key'  |
			| ''                                             | '$$DateItemStockAdjustment0297001$$' | '16'        | 'Store 02'   | ''      | 'M/White'   |
			| ''                                             | '$$DateItemStockAdjustment0297001$$' | '3'         | 'Store 02'   | ''      | '38/Yellow' |
		And I close all client application windows

Scenario: _0297006 check Item stock adjustment movements in the register R4051 Stock adjustment (Write off)
	* Select document
		Given I open hyperlink 'e1cib/list/Document.ItemStockAdjustment'
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberItemStockAdjustment0297001$$' |
		And I click "Registrations report" button
	* Check movements
		And I select "R4051 Stock adjustment (Write off)" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$ItemStockAdjustment0297001$$'                 | ''                                   | ''          | ''           | ''      | ''          |
			| 'Document registrations records'                 | ''                                   | ''          | ''           | ''      | ''          |
			| 'Register  "R4051 Stock adjustment (Write off)"' | ''                                   | ''          | ''           | ''      | ''          |
			| ''                                               | 'Period'                             | 'Resources' | 'Dimensions' | ''      | ''          |
			| ''                                               | ''                                   | 'Quantity'  | 'Store'      | 'Basis' | 'Item key'  |
			| ''                                               | '$$DateItemStockAdjustment0297001$$' | '16'        | 'Store 02'   | ''      | 'XS/Blue'   |
			| ''                                               | '$$DateItemStockAdjustment0297001$$' | '3'         | 'Store 02'   | ''      | '36/Yellow' |
		And I close all client application windows
		

				
		
			

	
		


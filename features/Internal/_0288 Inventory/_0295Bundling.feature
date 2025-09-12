#language: en
@tree
@Positive
@Inventory

Feature: Bundling

As a sales manager
I want to create Bundle
For joint sale of products


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _029500 preparation (Bundling)
	When set True value to the constant
	* Load info
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Stores objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
	
Scenario: _0295001 check preparation
	When check preparation

Scenario: _029501 create Bundling (Store does not use Shipment confirmation and Goods receipt)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
	And I select current line in "List" table
	And I click Select button of "Item bundle" field
	And I go to line in "List" table
		| 'Description'     |
		| 'Scarf + Dress'   |
	And I select current line in "List" table
	And I click Choice button of the field named "Unit"
	And I select current line in "List" table
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description'   |
		| 'Store 01'      |
	And I select current line in "List" table
	And I input "10,000" text in the field named "Quantity"
	And I move to "Item list" tab
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Dress'         |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item'   | 'Item key'   |
		| 'Dress'  | 'XS/Blue'    |
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "1,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Scarf'         |
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "1,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberBundling0029501$$" variable
	And I delete "$$Bundling0029501$$" variable
	And I save the value of "Number" field as "$$NumberBundling0029501$$"
	And I save the window as "$$Bundling0029501$$"
	And I click the button named "FormPostAndClose"
	And Delay 5

Scenario: _029502 check the automatic creation of the Bundle specification
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Specifications"
	And I go to line in "List" table
		| 'Description'  | 'Type'     |
		| 'Dress+Scarf'  | 'Bundle'   |
	And I select current line in "List" table
	Then the form attribute named "Type" became equal to "Bundle"
	Then the form attribute named "ItemBundle" became equal to "Scarf + Dress"
	And "FormTable*" table contains lines
		| 'Size'  | 'Color'  | 'Quantity'   |
		| 'XS'    | 'Blue'   | '1,000'      |
	And I close current window



Scenario: _029507 create Bundling ( Store use Shipment confirmation and Goods receipt)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
	And I select current line in "List" table
	And I click Select button of "Item bundle" field
	And I go to line in "List" table
		| 'Description'     |
		| 'Scarf + Dress'   |
	And I select current line in "List" table
	And I click Choice button of the field named "Unit"
	And I select current line in "List" table
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description'   |
		| 'Store 02'      |
	And I select current line in "List" table
	And I input "7,000" text in the field named "Quantity"
	And I move to "Item list" tab
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Dress'         |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item'   | 'Item key'   |
		| 'Dress'  | 'XS/Blue'    |
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "2,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Trousers'      |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key'    |
		| '36/Yellow'   |
	And I select current line in "List" table
	And I activate field named "ItemListQuantity" in "ItemList" table
	And I input "2,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberBundling0029507$$" variable
	And I delete "$$Bundling0029507$$" variable
	And I save the value of "Number" field as "$$NumberBundling0029507$$"
	And I save the window as "$$Bundling0029507$$"
	And I click the button named "FormPostAndClose"
	And Delay 5

Scenario: _029508 check the automatic creation of an additional specification for the created Bundle
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Specifications"
	And I go to the last line in "List" table
	And I go to line in "List" table
		| 'Description'     | 'Type'     |
		| 'Dress+Trousers'  | 'Bundle'   |
	And I select current line in "List" table
	Then the form attribute named "Description_en" became equal to "Dress+Trousers"
	Then the form attribute named "Type" became equal to "Bundle"
	Then the form attribute named "ItemBundle" became equal to "Bound Dress+Trousers"
	And "FormTable*" table contains lines
		| 'Size'  | 'Color'  | 'Quantity'   |
		| 'XS'    | 'Blue'   | '2*'         |
	And I close all client application windows






Scenario: _029515 check automatic creation of ItemKey by bundles
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And I go to line in "List" table
		| 'Description'    | 'Item type'   |
		| 'Scarf + Dress'  | 'Clothes'     |
	And I select current line in "List" table
	And In this window I click command interface button "Item keys"
	And "List" table contains lines
		| Item key                       |
		| Scarf + Dress/Dress+Scarf      |
		| Scarf + Dress/Dress+Trousers   |
	And I close all client application windows


Scenario: _029516 checking duplicate specifications when creating the same bundle
	* Create Bundle
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Scarf + Dress'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Scarf'          |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
		And Delay 5
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And "List" table contains lines
			| 'Description'      | 'Type'     |
			| 'A-8'              | 'Set'      |
			| 'S-8'              | 'Set'      |
			| 'Dress+Shirt'      | 'Bundle'   |
			| 'Dress+Trousers'   | 'Bundle'   |
			| 'Trousers'         | 'Set'      |
			| 'Dress'            | 'Set'      |
			| 'Test'             | 'Bundle'   |
			| 'Chewing gum'      | 'Set'      |
			| 'Dress+Scarf'      | 'Bundle'   |
			| 'Dress+Trousers'   | 'Bundle'   |
		Then the number of "List" table lines is "меньше или равно" 10


Scenario: _029518 creating a bundle of 2 different properties + one repeating of the same item + 1 other item
	* Create bundle
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Scarf + Dress'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description    |
			| pcs            |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | XS/Blue     |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | XS/Blue     |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | L/Green     |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Scarf          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item    | Item key    |
			| Scarf   | XS/Red      |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBundling0029518$$" variable
		And I delete "$$Bundling0029518$$" variable
		And I save the value of "Number" field as "$$NumberBundling0029518$$"
		And I save the window as "$$Bundling0029518$$"
		And I click the button named "FormPostAndClose"
		And Delay 10
	* Check creation of an Item key on a bundle by Dress + Scarf
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description     | Item type    |
			| Scarf + Dress   | Clothes      |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And "List" table contains lines
			| 'Item key'                     |
			| 'Scarf + Dress/Dress+Scarf'    |
			| 'Scarf + Dress/Dress+Scarf'    |
		And I close all client application windows
	* Check an auto-generated specification on Bundle
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I go to line in "List" table
			| 'Code'   | 'Description'   | 'Type'      |
			| '11'     | 'Dress+Scarf'   | 'Bundle'    |
		And I select current line in "List" table
		Then the form attribute named "Description_en" became equal to "Dress+Scarf"
		Then the form attribute named "Type" became equal to "Bundle"
		And "FormTable*" table contains lines
			| 'Size'   | 'Color'   | 'Quantity'    |
			| 'XS'     | 'Blue'    | '2,000'       |
			| 'XS'     | 'Blue'    | '2,000'       |
			| 'L'      | 'Green'   | '2,000'       |
		And I close all client application windows
	
		

Scenario: _029519 create Bundling (Store use Goods receipt, does not use Shipment confirmation)
	* Opening form for creating Bundle
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'               |
			| 'Skittles + Chewing gum'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 07'       |
		And I select current line in "List" table
	* Filling in items table
		And I input "7,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Skittles'       |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Chewing gum'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'      |
			| 'Mint/Mango'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document and check movements
		And I click the button named "FormPost"
		And I delete "$$NumberBundling0029519$$" variable
		And I delete "$$Bundling0029519$$" variable
		And I save the value of "Number" field as "$$NumberBundling0029519$$"
		And I save the window as "$$Bundling0029519$$"
		And I click the button named "FormPost"
		And Delay 5
		And I click "Registrations report" button
		And I select "Bundles content" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$Bundling0029519$$'             | ''        | ''           | ''                                             | ''            | ''  | ''  | ''   |
		| 'Document registrations records'  | ''        | ''           | ''                                             | ''            | ''  | ''  | ''   |
		| 'Register  "Bundles content"'     | ''        | ''           | ''                                             | ''            | ''  | ''  | ''   |
		| ''                                | 'Period'  | 'Resources'  | 'Dimensions'                                   | ''            | ''  | ''  | ''   |
		| ''                                | ''        | 'Quantity'   | 'Item key bundle'                              | 'Item key'    | ''  | ''  | ''   |
		| ''                                | '*'       | '2'          | 'Skittles + Chewing gum/Skittles+Chewing gum'  | 'Mint/Mango'  | ''  | ''  | ''   |
		| ''                                | '*'       | '2'          | 'Skittles + Chewing gum/Skittles+Chewing gum'  | 'Fruit'       | ''  | ''  | ''   |
		And I close all client application windows

Scenario: _029520 create Bundling (Store use Shipment confirmation, does not use Goods receipt)
	* Opening form for creating Bundle
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'               |
			| 'Skittles + Chewing gum'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 08'       |
		And I select current line in "List" table
	* Filling in items table
		And I input "7,000" text in the field named "Quantity"
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Skittles'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'    |
			| 'Skittles'   | 'Fruit'       |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Chewing gum'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'      |
			| 'Mint/Mango'    |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document and check movements
		And I click the button named "FormPost"
		And I delete "$$NumberBundling0029520$$" variable
		And I delete "$$Bundling0029520$$" variable
		And I save the value of "Number" field as "$$NumberBundling0029520$$"
		And I save the window as "$$Bundling0029520$$"
		And I click the button named "FormPost"
		And Delay 5
		And I click "Registrations report" button
		And I select "Bundles content" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$Bundling0029520$$'              | ''         | ''            | ''                                              | ''             | ''   | ''   | ''    |
			| 'Document registrations records'   | ''         | ''            | ''                                              | ''             | ''   | ''   | ''    |
			| 'Register  "Bundles content"'      | ''         | ''            | ''                                              | ''             | ''   | ''   | ''    |
			| ''                                 | 'Period'   | 'Resources'   | 'Dimensions'                                    | ''             | ''   | ''   | ''    |
			| ''                                 | ''         | 'Quantity'    | 'Item key bundle'                               | 'Item key'     | ''   | ''   | ''    |
			| ''                                 | '*'        | '2'           | 'Skittles + Chewing gum/Skittles+Chewing gum'   | 'Mint/Mango'   | ''   | ''   | ''    |
			| ''                                 | '*'        | '2'           | 'Skittles + Chewing gum/Skittles+Chewing gum'   | 'Fruit'        | ''   | ''   | ''    |
	
		And I close all client application windows




Scenario: _029521 check the output of the document movement report for Bundling
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number'                      |
		| '$$NumberBundling0029501$$'   |
		And I click the button named "FormReportD0009_DocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And I select "Bundles content" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$Bundling0029501$$'             | ''        | ''           | ''                           | ''          | ''   |
		| 'Document registrations records'  | ''        | ''           | ''                           | ''          | ''   |
		| 'Register  "Bundles content"'     | ''        | ''           | ''                           | ''          | ''   |
		| ''                                | 'Period'  | 'Resources'  | 'Dimensions'                 | ''          | ''   |
		| ''                                | ''        | 'Quantity'   | 'Item key bundle'            | 'Item key'  | ''   |
		| ''                                | '*'       | '1'          | 'Scarf + Dress/Dress+Scarf'  | 'XS/Blue'   | ''   |
		| ''                                | '*'       | '1'          | 'Scarf + Dress/Dress+Scarf'  | 'XS/Red'    | ''   |

	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number'                      |
		| '$$NumberBundling0029501$$'   |
		And I select current line in "List" table
		And I click the button named "FormReportD0009_DocumentRegistrationsReportRegistrationsReport"
		And I select "Bundles content" exact value from "Register" drop-down list
		And I click "Generate report" button			
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$Bundling0029501$$'             | ''        | ''           | ''                           | ''          | ''   |
		| 'Document registrations records'  | ''        | ''           | ''                           | ''          | ''   |
		| 'Register  "Bundles content"'     | ''        | ''           | ''                           | ''          | ''   |
		| ''                                | 'Period'  | 'Resources'  | 'Dimensions'                 | ''          | ''   |
		| ''                                | ''        | 'Quantity'   | 'Item key bundle'            | 'Item key'  | ''   |
		| ''                                | '*'       | '1'          | 'Scarf + Dress/Dress+Scarf'  | 'XS/Blue'   | ''   |
		| ''                                | '*'       | '1'          | 'Scarf + Dress/Dress+Scarf'  | 'XS/Red'    | ''   |

	And I close all client application windows


Scenario: _02951901 clear movements Bundling and check that there is no movements on the registers 
	* Open list form Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
	* Check the report generation
		And I go to line in "List" table
			| 'Number'                       |
			| '$$NumberBundling0029501$$'    |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportD0009_DocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Bundles content"'      |
			| 'Register  "Stock reservation"'    |
			| 'Register  "Stock balance"'        |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I go to line in "List" table
			| 'Number'                       |
			| '$$NumberBundling0029501$$'    |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportD0009_DocumentRegistrationsReportRegistrationsReport"
		And I select "Bundles content" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$Bundling0029501$$'             | ''        | ''           | ''                           | ''          | ''   |
		| 'Document registrations records'  | ''        | ''           | ''                           | ''          | ''   |
		| 'Register  "Bundles content"'     | ''        | ''           | ''                           | ''          | ''   |
		| ''                                | 'Period'  | 'Resources'  | 'Dimensions'                 | ''          | ''   |
		| ''                                | ''        | 'Quantity'   | 'Item key bundle'            | 'Item key'  | ''   |
		| ''                                | '*'       | '1'          | 'Scarf + Dress/Dress+Scarf'  | 'XS/Blue'   | ''   |
		| ''                                | '*'       | '1'          | 'Scarf + Dress/Dress+Scarf'  | 'XS/Red'    | ''   |
		
		And I close all client application windows


Scenario: _300519 check connection to Bundling report "Related documents"
	Given I open hyperlink "e1cib/list/Document.Bundling"
	* Form report Related documents
		And I go to line in "List" table
		| Number                      |
		| $$NumberBundling0029501$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows

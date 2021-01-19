#language: en
@tree
@Positive
@Forms

Feature: label processing



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _0202200 preparation (label processing)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog PriceTypes objects
		When Create information register PricesByItemKeys records
		When Create information register Barcodes records
		When update ItemKeys
		* Add external data processors for print layout creation
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			And I click the button named "FormCreate"
			And I select external file "#workingDir#/DataProcessor/PromotionalAndOldPricesPrintLabel.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "PrintLabel" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "PrintLabel" text in the field named "Description_en"
			And I input "PrintLabel" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And I wait "Plugins (create)" window closing in 10 seconds
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "PrintLabel"



Scenario: _0202201 print layout creation
	* Opening the constructor
		Given I open hyperlink "e1cib/list/Catalog.PrintTemplates"
	* Create Label 1
		And I click the button named "FormCreate"
		And I click "Get default" button
		And I input "Label 1" text in the field named "Description_en"
		And I input "2" text in "Labels in row" field
		And I input "4" text in "Labels in column" field
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Barcode picture'  |
		And I select current line in "OrderOrderAvailableFields" table
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Barcode'          |
		And I select current line in "OrderOrderAvailableFields" table
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Item key'         |
		And in "TemplateSpreadsheet" spreadsheet document I move to "R4C1" cell
		And I select current line in "OrderOrderAvailableFields" table
		And in "TemplateSpreadsheet" spreadsheet document I move to "R7C2" cell
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Item picture'     |
		And I select current line in "OrderOrderAvailableFields" table
		And in "TemplateSpreadsheet" spreadsheet document I move to "R7C1" cell
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Price'            |
		And I select current line in "OrderOrderAvailableFields" table
		And I click "Save and close" button
	* Create Label 2
		And I click the button named "FormCreate"
		And I click "Get default" button
		And I input "Label 2" text in the field named "Description_en"
		And I input "2" text in "Labels in row" field
		And I input "4" text in "Labels in column" field
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Barcode picture'  |
		And I select current line in "OrderOrderAvailableFields" table
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Barcode'          |
		And I select current line in "OrderOrderAvailableFields" table
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Item key'         |
		And in "TemplateSpreadsheet" spreadsheet document I move to "R4C1" cell
		And I select current line in "OrderOrderAvailableFields" table
		And in "TemplateSpreadsheet" spreadsheet document I move to "R7C2" cell
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Item picture'     |
		And I select current line in "OrderOrderAvailableFields" table
		And I click "Save and close" button



Scenario: _0202202 adding items to label printing processing
	* Open the processing form
		Given I open hyperlink "e1cib/app/DataProcessor.PrintLabels"
	* Add items and selecting labels by lines
		And I select "Auto" exact value from the drop-down list named "BarcodeType"
		And I click Choice button of the field named "PriceType"
		And I go to line in "List" table
			| 'Description'       |
			| 'Basic Price Types' |
		And I select current line in "List" table
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
			| 'Dress' | 'S/Yellow' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Template" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Template" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Label 1'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Template" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Template" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Label 2'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     | 'Template' |
		| 'Dress'    | 'Label 1'  |
		| 'Trousers' | 'Label 2'  |
	* Reselect the label for all lines in the processing header
		And I select "Label 1" exact value from "Label template" drop-down list
		And "ItemList" table contains lines
		| 'Item'     | 'Template' |
		| 'Dress'    | 'Label 1'  |
		| 'Trousers' | 'Label 1'  |
	* Print line selection
		And I go to line in "ItemList" table
			| 'Barcode'    | 'Barcode type' | 'Item'  | 'Item key' | 'Price'  | 'Price type'        | 'Print' | 'Quantity' | 'Template' | 'Unit' |
			| '2202283713' | 'Auto'         | 'Dress' | 'S/Yellow' | '550,00' | 'Basic Price Types' | 'No'    | '2'        | 'Label 1'  | 'pcs'  |
		And I activate "Item key" field in "ItemList" table
		And in the table "ItemList" I click "Check print for selected rows" button
		And "ItemList" table contains lines
			| 'Print' | 'Price type'        | 'Item'     | 'Quantity' | 'Price'  | 'Item key'  | 'Unit' | 'Barcode'    | 'Barcode type' | 'Template' |
			| 'Yes'   | 'Basic Price Types' | 'Dress'    | '2'        | '550,00' | 'S/Yellow'  | 'pcs'  | '2202283713' | 'Auto'         | 'Label 1'  |
		And in the table "ItemList" I click "Uncheck print for selected rows" button
		And "ItemList" table contains lines
			| 'Print' | 'Price type'        | 'Item'     | 'Quantity' | 'Price'  | 'Item key'  | 'Unit' | 'Barcode'    | 'Barcode type' | 'Template' |
			| 'No'   | 'Basic Price Types' | 'Dress'    | '2'        |  '550,00' | 'S/Yellow'  | 'pcs'  | '2202283713' | 'Auto'         | 'Label 1'  |
		And in the table "ItemList" I click "Check print for selected rows" button
	* Print output check
		And I click "Print" button
		Then "" spreadsheet document is equal
			| ''           | '' | '' | '' | '' | '' | '2202283713' |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| '36/Yellow'  | '' | '' | '' | '' | '' | 'S/Yellow'   |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| '400'        | '' | '' | '' | '' | '' | '550'        |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| '2202283713' | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| 'S/Yellow'   | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| ''           | '' | '' | '' | '' | '' | ''           |
			| '550'        | '' | '' | '' | '' | '' | ''           |
		And I close all client application windows
		
Scenario: _0202203 print layout creation with using external data processors
	* Opening the constructor
		Given I open hyperlink "e1cib/list/Catalog.PrintTemplates"
	* Create Label 3
		And I click the button named "FormCreate"
		And I click "Get default" button
		And I input "Label 3" text in the field named "Description_en"
		And I input "2" text in "Labels in row" field
		And I input "4" text in "Labels in column" field
	* Filling in Plugins
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description' |
			| 'PrintLabel'  |
		And I select current line in "List" table
	* Select fields for label
		And in "TemplateSpreadsheet" spreadsheet document I move to "R1C1" cell
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Item'             |
		And I select current line in "OrderOrderAvailableFields" table
		And in "TemplateSpreadsheet" spreadsheet document I move to "R3C1" cell
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Old price'        |
		And I select current line in "OrderOrderAvailableFields" table
		And in "TemplateSpreadsheet" spreadsheet document I move to "R5C1" cell
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields' |
			| 'Price'            |
		And I select current line in "OrderOrderAvailableFields" table
		And in "TemplateSpreadsheet" spreadsheet document I move to "R7C1" cell
		And I go to line in "OrderOrderAvailableFields" table
			| 'Available fields'  |
			| 'Promotional price' |
		And I select current line in "OrderOrderAvailableFields" table
		And I click "Save and close" button
	* Check 
		Given I open hyperlink "e1cib/app/DataProcessor.PrintLabels"
		And I select "Auto" exact value from the drop-down list named "BarcodeType"
		And I click Choice button of the field named "PriceType"
		And I go to line in "List" table
			| 'Description'       |
			| 'Basic Price Types' |
		And I select current line in "List" table
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
			| 'Dress' | 'S/Yellow' |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Template" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Template" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Label 3'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		Then "Print labels" window is opened
		And I activate field named "ItemListPrint" in "ItemList" table
		And I change checkbox named "ItemListPrint" in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Print" button
		Then "" spreadsheet document is equal
		| 'Dress'          |
		| ''               |
		| ''               |
		| ''               |
		| '550'            |
		| ''               |
		| 'Цiна: 550 грн.' |
	And I close all client application windows
	

		
				
		
				



Scenario: _999999 close TestClient session
	And I close TestClient session
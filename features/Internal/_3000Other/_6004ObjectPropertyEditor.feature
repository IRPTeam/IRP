#language: en
@tree
@Positive
@Other


Feature: object property editor

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"
Tag = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag"), "#Tag#")}"
webPort = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort"), "#webPort#")}"
Publication = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Publication")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Publication"), "#Publication#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _604700 preparation (Object property editor)
	When set True value to the constant
	And I set "True" value to the constant "UseJobQueueForExternalFunctions"
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
		When Create catalog AddAttributeAndPropertySets objects for ITO and item
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create catalog IntegrationSettings objects (db connection)
		When Create information register CurrencyRates records
		When Create information register Barcodes records
		When update ItemKeys
		When Create catalog ExternalFunctions objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
	When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
	When Create document InventoryTransferOrder objects (check movements)
	When Create document InternalSupplyRequest objects (check movements)
	* Add test extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description" |
				| "AdditionalFunctionality" |
			When add Additional Functionality extension
	And I close all client application windows


Scenario: _604702 check filling additional attribute and filters in the ObjectPropertyEditor (catalog)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"
	* Select catalog items
		And I select "(Catalog) Item" exact value from "Object type" drop-down list
	* Check filling additional attribute
		And I click the button named "Refresh"
		And "PropertiesTable" table contains lines
			| 'Marked' | 'Is modified' | 'Object'                 | 'Brand' | 'Producer' | 'Article' | 'Country of consignment' |
			| 'No'     | 'No'          | 'Dress'                  | 'Rose'  | 'UNIQ'     | ''        | 'Poland'                 |
			| 'No'     | 'No'          | 'Scarf + Dress'          | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Skittles + Chewing gum' | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Trousers'               | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Shirt'                  | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Boots'                  | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'High shoes'             | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Box'                    | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Bound Dress+Shirt'      | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Bound Dress+Trousers'   | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Service'                | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Router'                 | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Bag'                    | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Scarf'                  | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Chewing gum'            | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Skittles'               | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Socks'                  | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Jacket J22001'          | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Fee'                    | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Candy Fruit'            | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'Stockings'              | ''      | ''         | ''        | ''                       |
	* Add filter
		And I click Select button of "Filter" field
		And I expand current line in "FilterAvailableFields" table
		And I go to line in "FilterAvailableFields" table
			| 'Available fields' |
			| 'Item type'        |
		And I select current line in "FilterAvailableFields" table
		And I click choice button of the attribute named "DataRightValue" in "Data" table
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I finish line editing in "Data" table
		And I click the button named "OK"
		And I click the button named "Refresh"
	* Check filter
		And "PropertiesTable" table does not contain lines
			| 'Marked' | 'Is modified' | 'Object'     | 'Brand' | 'Producer' | 'Article' | 'Country of consignment' |
			| 'No'     | 'No'          | 'Boots'      | ''      | ''         | ''        | ''                       |
			| 'No'     | 'No'          | 'High shoes' | ''      | ''         | ''        | ''                       |
	* Select fields
		And I click "Fields" button
		And I go to line in "FieldsTable" table
			| 'Field name' | 'Is visible' | 'Type'                       |
			| 'Article'    | 'Yes'        | 'Additional attribute value' |
		And I remove "Is visible" checkbox in "FieldsTable" table
		And I finish line editing in "FieldsTable" table
		And in the table "FieldsTable" I click "Apply setting" button
		And I click the button named "Refresh"
	

Scenario: _604703 check filling additional attribute and filters in the ObjectPropertyEditor (document)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"
	* Select catalog items
		And I select "(Document) Inventory transfer order" exact value from "Object type" drop-down list
	* Check filling additional attribute
		And I click the button named "Refresh"
		And "PropertiesTable" table became equal
			| 'Marked' | 'Is modified' | 'Object'                                                 | 'Brand' | 'Producer' |
			| 'No'     | 'No'          | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'  | ''      | ''         |
			| 'No'     | 'No'          | 'Inventory transfer order 201 dated 28.02.2021 20:17:48' | ''      | ''         |
			| 'No'     | 'No'          | 'Inventory transfer order 202 dated 01.03.2021 10:04:57' | ''      | ''         |
	* Add filter
		And I click Select button of "Filter" field
		And I expand current line in "FilterAvailableFields" table
		And I go to line in "FilterAvailableFields" table
			| 'Available fields' |
			| 'Number'           |
		And I select current line in "FilterAvailableFields" table
		And I select "Greater than" exact value from "Comparison type" drop-down list in "Data" table
		And I input "200" text in the field named "DataRightValue" of "Data" table
		And I finish line editing in "Data" table
		And I click the button named "OK"
		And I click the button named "Refresh"
		And "PropertiesTable" table became equal
			| 'Marked' | 'Is modified' | 'Object'                                                 | 'Brand' | 'Producer' |
			| 'No'     | 'No'          | 'Inventory transfer order 201 dated 28.02.2021 20:17:48' | ''      | ''         |
			| 'No'     | 'No'          | 'Inventory transfer order 202 dated 01.03.2021 10:04:57' | ''      | ''         |
		And I close all client application windows


				
Scenario: _604706 edit selected elements (ObjectPropertyEditor)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"			
	* Select catalog items
		And I select "(Catalog) Item" exact value from "Object type" drop-down list
		And I click the button named "Refresh"	
	* Edit selected elements
		And I go to line in "PropertiesTable" table
			| 'Object'   |
			| 'Trousers' |
		And I activate "Marked" field in "PropertiesTable" table
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I go to line in "PropertiesTable" table
			| 'Object' |
			| 'Shirt'  |
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I activate "Brand" field in "PropertiesTable" table
		Then "Object property editor" window is opened
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuSetValueForMarkedRows"
		And I go to line in "List" table
			| 'Additional attribute' | 'Additional attribute values' |
			| 'Brand'                | 'Montel'                      |
		And I select current line in "List" table
		And "PropertiesTable" table contains lines
			| 'Marked' | 'Is modified' | 'Object'                 | 'Brand'  |
			| 'Yes'    | 'Yes'         | 'Trousers'               | 'Montel' |
			| 'Yes'    | 'Yes'         | 'Shirt'                  | 'Montel' |
		And I activate "Marked" field in "PropertiesTable" table
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I activate "Producer" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuSetValueForMarkedRows"
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Additional attribute' | 'Additional attribute values' |
			| 'Producer'             | 'PZU'                         |
		And I click the button named "FormChoose"
		And I activate "Brand" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuSetValueForMarkedRows"
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Additional attribute' | 'Additional attribute values' |
			| 'Brand'                | 'Rose'                        |
		And I click the button named "FormChoose"
	* Copy attribute
		And I activate "Producer" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuSetValueToEmptyCells"
		And I go to line in "List" table
			| 'Additional attribute values' |
			| 'ODS'                         |
		And I click the button named "FormChoose"
		And "PropertiesTable" table became equal
			| 'Marked' | 'Is modified' | 'Object'                 | 'Brand' | 'Producer' | 'Article' | 'Country of consignment' |
			| 'Yes'    | 'Yes'         | 'Dress'                  | 'Rose'  | 'PZU'      | ''        | 'Poland'                 |
			| 'No'     | 'Yes'         | 'Scarf + Dress'          | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Skittles + Chewing gum' | ''      | 'ODS'      | ''        | ''                       |
			| 'Yes'    | 'Yes'         | 'Trousers'               | 'Rose'  | 'PZU'      | ''        | ''                       |
			| 'Yes'    | 'Yes'         | 'Shirt'                  | 'Rose'  | 'PZU'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Boots'                  | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'High shoes'             | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Box'                    | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Bound Dress+Shirt'      | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Bound Dress+Trousers'   | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Service'                | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Router'                 | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Bag'                    | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Scarf'                  | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Chewing gum'            | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Skittles'               | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Socks'                  | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Jacket J22001'          | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Fee'                    | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Candy Fruit'            | ''      | 'ODS'      | ''        | ''                       |
			| 'No'     | 'Yes'         | 'Stockings'              | ''      | 'ODS'      | ''        | ''                       |
		And I click the button named "Save"
		And I go to line in "PropertiesTable" table
			| 'Object' |
			| 'Shirt'  |
		And I activate "Object" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table
		Then "Producer" form attribute became equal to "PZU"
		Then "Brand" form attribute became equal to "Rose"
		And I close current window
		And I go to line in "PropertiesTable" table
			| 'Object' |
			| 'Bag'  |
		And I activate "Object" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table	
		Then "Producer" form attribute became equal to "ODS"
		Then "Brand" form attribute became equal to ""	
		And I close current window
		And I go to line in "PropertiesTable" table
			| 'Object' |
			| 'Dress'  |
		And I activate "Object" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table	
		Then "Producer" form attribute became equal to "PZU"
		Then "Brand" form attribute became equal to "Rose"	
		And I close all client application windows
		
				
		
Scenario: _604710 delete value from element (ObjectPropertyEditor)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"			
	* Select catalog items
		And I select "(Catalog) Item" exact value from "Object type" drop-down list
		And I click the button named "Refresh"
	* Delete value from element
		And I activate "Brand" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table
		And I input "" text in "Brand" field of "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I click the button named "Save"
		And I activate "Object" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table
		Then "Brand" form attribute became equal to ""	
		Then "Producer" form attribute became equal to "PZU"
	And I close all client application windows
	
Scenario: _604714 copy value to marked row (ObjectPropertyEditor)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"			
	* Select catalog items
		And I select "(Catalog) Item" exact value from "Object type" drop-down list
		And I click the button named "Refresh"
	* Select row
		And I go to line in "PropertiesTable" table
			| 'Marked' | 'Object' | 'Producer' |
			| 'No'     | 'Box'    | 'ODS'      |
		And I activate "Marked" field in "PropertiesTable" table
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I go to line in "PropertiesTable" table
			| 'Object' | 'Producer' |
			| 'Bag'    | 'ODS'      |
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I go to line in "PropertiesTable" table
			| 'Brand' | 'Object' | 'Producer' |
			| 'Rose'  | 'Shirt'  | 'PZU'      |
		And I activate "Brand" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuCopyThisRowValueToMarkedRows"
		And I click "Set values" button
		And I click the button named "Save"
		And "PropertiesTable" table contains lines
			| 'Brand' | 'Object' | 'Producer' |
			| 'Rose'  | 'Bag'    | 'PZU'      |
			| 'Rose'  | 'Box'    | 'PZU'      |
		And I close all client application windows
		

				

		
				
				
				
				
				
				

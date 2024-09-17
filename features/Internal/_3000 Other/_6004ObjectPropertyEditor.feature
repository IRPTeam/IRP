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
		When Create catalog BusinessUnits objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Partners objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertySets objects for ITO and item
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog PartnersBankAccounts objects
		When Create catalog CancelReturnReasons objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create catalog ExternalFunctions objects
		When Create information register Taxes records (VAT)
	When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
	When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
	When Create document InventoryTransferOrder objects (check movements)
	When Create document InternalSupplyRequest objects (check movements)
	* PO posting
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Properties settings for items
		And properties settings for items
	And I close all client application windows


Scenario: _604702 check filling additional attribute and filters in the ObjectPropertyEditor (catalog)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"
	* Select catalog items
		And I select "(Catalog) Item" exact value from "Object type" drop-down list
		And I select "Additional attributes" exact value from "Table" drop-down list		
	* Check filling additional attribute
		And I click the button named "Refresh"
		And "PropertiesTable" table contains lines
			| 'Marked'   | 'Is modified'   | 'Object'                   | 'Brand'   | 'Producer'   | 'Article'   | 'Country of consignment'    |
			| 'No'       | 'No'            | 'Dress'                    | 'Rose'    | 'UNIQ'       | ''          | 'Poland'                    |
			| 'No'       | 'No'            | 'Scarf + Dress'            | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Skittles + Chewing gum'   | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Trousers'                 | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Shirt'                    | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Boots'                    | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'High shoes'               | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Box'                      | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Bound Dress+Shirt'        | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Bound Dress+Trousers'     | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Service'                  | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Router'                   | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Bag'                      | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Scarf'                    | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Chewing gum'              | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Skittles'                 | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Socks'                    | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Jacket J22001'            | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'Fee'                      | ''        | ''           | ''          | ''                          |
	* Add filter
		And I click Select button of "Filter" field
		And I expand current line in "FilterAvailableFields" table
		And I expand a line in "FilterAvailableFields" table
			| 'Available fields' |
			| 'Ref'              |		
		And I go to line in "FilterAvailableFields" table
			| 'Available fields'    |
			| 'Item type'           |
		And I select current line in "FilterAvailableFields" table
		And I click choice button of the attribute named "DataRightValue" in "Data" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Clothes'        |
		And I select current line in "List" table
		And I finish line editing in "Data" table
		And I click the button named "OK"
		And I click the button named "Refresh"
	* Check filter
		And "PropertiesTable" table does not contain lines
			| 'Marked'   | 'Is modified'   | 'Object'       | 'Brand'   | 'Producer'   | 'Article'   | 'Country of consignment'    |
			| 'No'       | 'No'            | 'Boots'        | ''        | ''           | ''          | ''                          |
			| 'No'       | 'No'            | 'High shoes'   | ''        | ''           | ''          | ''                          |
	* Select fields
		And I click "Settings" button
		And I go to line in "FieldsTable" table
			| 'Field name'   | 'Is visible'   | 'Type'                          |
			| 'Article'      | 'Yes'          | 'Additional attribute value'    |
		And I remove "Is visible" checkbox in "FieldsTable" table
		And I finish line editing in "FieldsTable" table
		And I click "Apply setting" button
		And I click the button named "Refresh"
	

Scenario: _604703 check filling additional attribute and filters in the ObjectPropertyEditor (document)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"
	* Select catalog items
		And I select "(Document) Inventory transfer order" exact value from "Object type" drop-down list
	* Check filling additional attribute
		And I select "Additional attributes" exact value from "Table" drop-down list
		And I click the button named "Refresh"
		And "PropertiesTable" table became equal
			| 'Marked'   | 'Is modified'   | 'Object'                                                   | 'Brand'   | 'Producer'    |
			| 'No'       | 'No'            | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    | ''        | ''            |
			| 'No'       | 'No'            | 'Inventory transfer order 201 dated 28.02.2021 20:17:48'   | ''        | ''            |
			| 'No'       | 'No'            | 'Inventory transfer order 202 dated 01.03.2021 10:04:57'   | ''        | ''            |
	* Add filter
		And I click Select button of "Filter" field
		And I expand a line in "FilterAvailableFields" table
			| 'Available fields' |
			| 'Ref'              |	
		And I expand current line in "FilterAvailableFields" table
		And I go to line in "FilterAvailableFields" table
			| 'Available fields'    |
			| 'Number'              |
		And I select current line in "FilterAvailableFields" table
		And I select "Greater than" exact value from "Comparison type" drop-down list in "Data" table
		And I input "200" text in the field named "DataRightValue" of "Data" table
		And I finish line editing in "Data" table
		And I click the button named "OK"
		And I click the button named "Refresh"
		And "PropertiesTable" table became equal
			| 'Marked'   | 'Is modified'   | 'Object'                                                   | 'Brand'   | 'Producer'    |
			| 'No'       | 'No'            | 'Inventory transfer order 201 dated 28.02.2021 20:17:48'   | ''        | ''            |
			| 'No'       | 'No'            | 'Inventory transfer order 202 dated 01.03.2021 10:04:57'   | ''        | ''            |
		And I close all client application windows


				
Scenario: _604706 edit selected elements (ObjectPropertyEditor)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"			
	* Select catalog items
		And I select "(Catalog) Item" exact value from "Object type" drop-down list
		And I select "Additional attributes" exact value from "Table" drop-down list
		And I click the button named "Refresh"	
	* Edit selected elements
		And I go to line in "PropertiesTable" table
			| 'Object'      |
			| 'Trousers'    |
		And I activate "Marked" field in "PropertiesTable" table
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I go to line in "PropertiesTable" table
			| 'Object'    |
			| 'Shirt'     |
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I activate "Brand" field in "PropertiesTable" table
		Then "Object property editor" window is opened
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuSetValueForMarkedRows"
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Brand'                  | 'Montel'         |
		And I select current line in "List" table
		And "PropertiesTable" table contains lines
			| 'Marked'   | 'Is modified'   | 'Object'     | 'Brand'     |
			| 'Yes'      | 'Yes'           | 'Trousers'   | 'Montel'    |
			| 'Yes'      | 'Yes'           | 'Shirt'      | 'Montel'    |
		And I activate "Marked" field in "PropertiesTable" table
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I activate "Producer" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuSetValueForMarkedRows"
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Producer'               | 'PZU'            |
		And I click the button named "FormChoose"
		And I activate "Brand" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuSetValueForMarkedRows"
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Additional attribute'   |  'Description'    |
			| 'Brand'                  | 'Rose'            |
		And I click the button named "FormChoose"
	* Copy attribute
		And I activate "Producer" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuSetValueToEmptyCells"
		And I go to line in "List" table
			| 'Description'    |
			| 'ODS'            |
		And I click the button named "FormChoose"
		And "PropertiesTable" table contains lines
			| 'Marked'   | 'Is modified'   | 'Object'                   | 'Brand'   | 'Producer'   | 'Article'   | 'Country of consignment'    |
			| 'Yes'      | 'Yes'           | 'Dress'                    | 'Rose'    | 'PZU'        | ''          | 'Poland'                    |
			| 'No'       | 'Yes'           | 'Scarf + Dress'            | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Skittles + Chewing gum'   | ''        | 'ODS'        | ''          | ''                          |
			| 'Yes'      | 'Yes'           | 'Trousers'                 | 'Rose'    | 'PZU'        | ''          | ''                          |
			| 'Yes'      | 'Yes'           | 'Shirt'                    | 'Rose'    | 'PZU'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Boots'                    | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'High shoes'               | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Box'                      | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Bound Dress+Shirt'        | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Bound Dress+Trousers'     | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Service'                  | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Router'                   | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Bag'                      | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Scarf'                    | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Chewing gum'              | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Skittles'                 | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Socks'                    | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Jacket J22001'            | ''        | 'ODS'        | ''          | ''                          |
			| 'No'       | 'Yes'           | 'Fee'                      | ''        | 'ODS'        | ''          | ''                          |
		And I click the button named "Save"
		And I go to line in "PropertiesTable" table
			| 'Object'    |
			| 'Shirt'     |
		And I activate "Object" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table
		Then "Producer" form attribute became equal to "PZU"
		Then "Brand" form attribute became equal to "Rose"
		And I close current window
		And I go to line in "PropertiesTable" table
			| 'Object'    |
			| 'Bag'       |
		And I activate "Object" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table	
		Then "Producer" form attribute became equal to "ODS"
		Then "Brand" form attribute became equal to ""	
		And I close current window
		And I go to line in "PropertiesTable" table
			| 'Object'    |
			| 'Dress'     |
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
		And I select "Additional attributes" exact value from "Table" drop-down list
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
		And I select "Additional attributes" exact value from "Table" drop-down list
		And I click the button named "Refresh"
	* Select row
		And I go to line in "PropertiesTable" table
			| 'Marked'   | 'Object'   | 'Producer'    |
			| 'No'       | 'Box'      | 'ODS'         |
		And I activate "Marked" field in "PropertiesTable" table
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I go to line in "PropertiesTable" table
			| 'Object'   | 'Producer'    |
			| 'Bag'      | 'ODS'         |
		And I set "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I go to line in "PropertiesTable" table
			| 'Brand'   | 'Object'   | 'Producer'    |
			| 'Rose'    | 'Shirt'    | 'PZU'         |
		And I activate "Brand" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuCopyThisRowValueToMarkedRows"
		And I click "Set values" button
		And I click the button named "Save"
		And "PropertiesTable" table contains lines
			| 'Brand'   | 'Object'   | 'Producer'    |
			| 'Rose'    | 'Bag'      | 'PZU'         |
			| 'Rose'    | 'Box'      | 'PZU'         |
		And I close all client application windows
		

Scenario: _604717 change main attributes (ObjectPropertyEditor)				
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"			
	* Select catalog items
		And I select "(Catalog) Item" exact value from "Object type" drop-down list
		And I select "Main attributes" exact value from "Table" drop-down list
		And I click the button named "Refresh"
	* Change unit and Vendor
		And I go to line in "PropertiesTable" table
			| 'Is modified' | 'Item ID' | 'Item type' | 'Marked' | 'Object' | 'Unit' |
			| 'No'          | 'D18001'  | 'Bags'      | 'No'     | 'Bag'    | 'pcs'  |
		And I activate "Unit" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table
		And I click choice button of "Unit" attribute in "PropertiesTable" table
		And I go to line in "List" table
			| 'Code'   | 'Description'   |
			| '4'      | 'box (8 pcs)'   |
		And I select current line in "List" table
		And I finish line editing in "PropertiesTable" table
		And I go to line in "PropertiesTable" table
			| 'Is modified'   | 'Item ID'   | 'Item type'   | 'Marked'   | 'Object'   | 'Unit'    |
			| 'No'            | '10003'     | 'Clothes'     | 'No'       | 'Shirt'    | 'pcs'     |
		And I activate "Vendor" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table
		And I click choice button of "Vendor" attribute in "PropertiesTable" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I finish line editing in "PropertiesTable" table
		And I click the button named "Save"
	* Check
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		Then the form attribute named "Vendor" became equal to "Kalipso"
		And I close current window
		And I go to line in "List" table
			| 'Description'|
			| 'Bag'        |
		And I select current line in "List" table	
		Then the form attribute named "Unit" became equal to "box (8 pcs)"
	And I close all client application windows
						
				

Scenario: _604718 change agreement in the PO (ObjectPropertyEditor), Update related fields			
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"			
	* Select document
		And I select "(Document) Purchase order" exact value from "Object type" drop-down list
		And I select "Main attributes" exact value from "Table" drop-down list
		And I click the button named "Refresh"
		And I click the button named "Settings"
		And I change the radio button named "WritingMode" value to "Update related fields"
		And I change checkbox "Show service tables"
		And I change checkbox "Show service attributes"
		And I click "Apply setting" button
		And I click the button named "Refresh"
	* Change partner and check change legal name
		And I go to line in "PropertiesTable" table
			| 'Company'      | 'Currency' | 'Is modified' | 'Legal name'        | 'Marked' | 'Object'                                       | 'Partner'   | 'Partner term'       | 'Price includes tax' | 'Status'   | 'Use items receipt scheduling' |
			| 'Main Company' | 'TRY'      | 'No'          | 'Company Ferron BP' | 'No'     | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Yes'                | 'Approved' | 'Yes'                          |
		And I activate "Partner" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table
		And I click choice button of "Partner" attribute in "PropertiesTable" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Veritas'        |
		And I select current line in "List" table
		And I finish line editing in "PropertiesTable" table
		And I click the button named "Save"
		And "PropertiesTable" table contains lines
			| 'Marked' | 'Is modified' | 'Currency' | 'Object'                                       | 'Partner term'                               | 'Legal name'        | 'Partner bank account'          | 'Company'      | 'Partner'   | 'Price includes tax' | 'Status'   | 'Use items receipt scheduling' |
			| 'No'     | 'No'          | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Posting by Standard Partner term (Veritas)' | 'Company Veritas '  | 'Partner bank account (Ferron)' | 'Main Company' | 'Veritas'   | 'Yes'                | 'Approved' | 'Yes'                          |
			| 'No'     | 'No'          | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'Vendor Ferron, TRY'                         | 'Company Ferron BP' | 'Partner bank account (Ferron)' | 'Main Company' | 'Ferron BP' | 'Yes'                | 'Approved' | 'No'                           |
	* Change quantity
		And I select "* Item list" exact value from "Table" drop-down list
		And I click the button named "Refresh"
		And I activate "Quantity" field in "PropertiesTable" table
		And I select current line in "PropertiesTable" table
		And I go to line in "PropertiesTable" table
			| '#'   | 'Cancel'   | 'Delivery date'   | 'Dont calculate row'   | 'Is modified'   | 'Is service'   | 'Item'    | 'Item key'   | 'Key'                                    | 'Marked'   | 'Net amount'   | 'Object'                                         | 'Price'   | 'Price type'                | 'Quantity'   | 'Stock quantity'   | 'Store'      | 'Tax amount'   | 'Total amount'   | 'Unit'    |
			| '1'   | 'No'       | '12.02.2021'      | 'No'                   | 'No'            | 'No'           | 'Dress'   | 'S/Yellow'   | 'baf60337-67a7-4627-8518-6881217d1593'   | 'No'       | '847,46'       | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '100'     | 'en description is empty'   | '10'         | '10'               | 'Store 02'   | '152,54'       | '1 000'          | 'pcs'     |
		And I input "2" text in "Quantity" field of "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I click the button named "Save"
		And "PropertiesTable" table contains lines
			| 'Marked'   | 'Detail'   | 'Sales order'   | 'Is modified'   | 'Item'       | 'Object'                                         | 'Price type'                | '#'   | 'Stock quantity'   | 'Store'      | 'Key'                                    | 'Internal supply request'   | 'Price'   | 'Total amount'   | 'Net amount'   | 'Offers amount'   | 'Quantity'   | 'Expense type'   | 'Unit'   | 'Tax amount'   | 'Dont calculate row'   | 'Item key'    | 'Profit loss center'   | 'Partner item'   | 'Cancel'   | 'Delivery date'   | 'Purchase basis'   | 'Is service'    |
			| 'No'       | ''         | ''              | 'No'            | 'Dress'      | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Vendor price, TRY'         | '1'   | '10'               | 'Store 02'   | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | ''                          | ''        | ''               | ''             | ''                | '10'         | ''               | 'pcs'    | ''             | 'No'                   | 'S/Yellow'    | 'Front office'         | ''               | 'No'       | '12.02.2021'      | ''                 | 'No'            |
			| 'No'       | ''         | ''              | 'No'            | 'Service'    | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Vendor price, TRY'         | '2'   | '2'                | ''           | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | ''                          | ''        | ''               | ''             | ''                | '2'          | ''               | 'pcs'    | ''             | 'No'                   | 'Internet'    | 'Front office'         | ''               | 'No'       | '12.02.2021'      | ''                 | 'Yes'           |
			| 'No'       | ''         | ''              | 'No'            | 'Boots'      | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Vendor price, TRY'         | '3'   | '8'                | 'Store 02'   | '62d24ced-315a-473c-b47a-5bc9c4a824e0'   | ''                          | ''        | ''               | ''             | ''                | '8'          | ''               | 'pcs'    | ''             | 'No'                   | '36/18SD'     | 'Front office'         | ''               | 'Yes'      | '12.02.2021'      | ''                 | 'No'            |
			| 'No'       | ''         | ''              | 'No'            | 'Trousers'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Vendor price, TRY'         | '4'   | '5'                | 'Store 02'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | ''                          | ''        | ''               | ''             | ''                | '5'          | ''               | 'pcs'    | ''             | 'No'                   | '36/Yellow'   | 'Front office'         | ''               | 'No'       | '12.02.2021'      | ''                 | 'No'            |
			| 'No'       | ''         | ''              | 'No'            | 'Dress'      | 'Purchase order 116 dated 12.02.2021 12:44:59'   | 'en description is empty'   | '1'   | '2'                | 'Store 02'   | 'baf60337-67a7-4627-8518-6881217d1593'   | ''                          | '100'     | '200'            | '169,49'       | ''                | '2'          | ''               | 'pcs'    | '30,51'        | 'No'                   | 'S/Yellow'    | 'Front office'         | ''               | 'No'       | '12.02.2021'      | ''                 | 'No'            |
			| 'No'       | ''         | ''              | 'No'            | 'Service'    | 'Purchase order 116 dated 12.02.2021 12:44:59'   | 'en description is empty'   | '2'   | '2'                | 'Store 02'   | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | ''                          | '150'     | '300'            | '254,24'       | ''                | '2'          | ''               | 'pcs'    | '45,76'        | 'No'                   | 'Internet'    | 'Front office'         | ''               | 'No'       | '12.02.2021'      | ''                 | 'Yes'           |
			| 'No'       | ''         | ''              | 'No'            | 'Boots'      | 'Purchase order 116 dated 12.02.2021 12:44:59'   | 'en description is empty'   | '3'   | '8'                | 'Store 02'   | '7b9432c6-b2fa-4763-b4ae-8cfaecd6fc7c'   | ''                          | '120'     | '960'            | '813,56'       | ''                | '8'          | ''               | 'pcs'    | '146,44'       | 'No'                   | '36/18SD'     | 'Front office'         | ''               | 'Yes'      | '12.02.2021'      | ''                 | 'No'            |
			| 'No'       | ''         | ''              | 'No'            | 'Trousers'   | 'Purchase order 116 dated 12.02.2021 12:44:59'   | 'en description is empty'   | '4'   | '5'                | 'Store 02'   | '2f854b37-44db-469e-a5cb-6478adca5001'   | ''                          | '200'     | '1 000'          | '847,46'       | ''                | '5'          | ''               | 'pcs'    | '152,54'       | 'No'                   | '36/Yellow'   | 'Front office'         | ''               | 'No'       | '12.02.2021'      | ''                 | 'No'            |
	* Check
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Veritas"
		Then the form attribute named "LegalName" became equal to "Company Veritas "
		Then the form attribute named "Agreement" became equal to "Posting by Standard Partner term (Veritas)"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '116'       |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Cancel'   | 'Item key'   | 'Profit loss center'   | 'Price type'                | 'Item'    | 'Quantity'   | 'Dont calculate row'   | 'Unit'   | 'Tax amount'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Expense type'   | 'Detail'   | 'Sales order'   | 'Purchase basis'   | 'Delivery date'    |
			| 'No'       | 'S/Yellow'   | 'Front office'         | 'en description is empty'   | 'Dress'   | '2,000'      | 'No'                   | 'pcs'    | '30,51'        | '100,00'   | '18%'   | ''                | '169,49'       | '200,00'         | 'Store 02'   | ''               | ''         | ''              | ''                 | '12.02.2021'       |
		And I close all client application windows
		

Scenario: _604719 change Row ID info and partner (ObjectPropertyEditor), forced writing
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
	And Delay 15
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"			
	* Select document
		And I select "(Document) Purchase order" exact value from "Object type" drop-down list
		And I select "Main attributes" exact value from "Table" drop-down list
		And I click the button named "Refresh"
		And I click the button named "Settings"
		And I change the radio button named "WritingMode" value to "Forced writing (dangerous)"	
		And I change checkbox "Show service tables"
		And I change checkbox "Show service attributes"
		And I click "Apply setting" button
		And I click the button named "Refresh"
	* Change partner
		And I go to line in "PropertiesTable" table
			| 'Object'                                          |
			| 'Purchase order 116 dated 12.02.2021 12:44:59'    |
		And I activate "Partner" field in "PropertiesTable" table
		And I click choice button of "Partner" attribute in "PropertiesTable" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Veritas'        |
		And I select current line in "List" table
		And I finish line editing in "PropertiesTable" table
		And I click the button named "Save"
		And Delay 15
		And "PropertiesTable" table contains lines
			| 'Marked' | 'Is modified' | 'Currency' | 'Object'                                       | 'Partner term'                               | 'Legal name'        | 'Partner bank account'          | 'Company'      | 'Partner' | 'Price includes tax' | 'Status'   | 'Use items receipt scheduling' |
			| 'No'     | 'No'          | 'TRY'      | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Posting by Standard Partner term (Veritas)' | 'Company Veritas '  | 'Partner bank account (Ferron)' | 'Main Company' | 'Veritas' | 'Yes'                | 'Approved' | 'Yes'                          |
			| 'No'     | 'No'          | 'TRY'      | 'Purchase order 116 dated 12.02.2021 12:44:59' | 'Vendor Ferron, TRY'                         | 'Company Ferron BP' | 'Partner bank account (Ferron)' | 'Main Company' | 'Veritas' | 'Yes'                | 'Approved' | 'No'                           |
	* Change Row ID tab
		And I select "* Row IDInfo" exact value from "Table" drop-down list
		And I click the button named "Refresh"
		And I go to line in "PropertiesTable" table
			| '#'   | 'Is modified'   | 'Key'                                    | 'Marked'   | 'Next step'   | 'Object'                                         | 'Quantity'   | 'Row ID'                                 | 'Row ref'                                 |
			| '1'   | 'No'            | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'No'       | 'PI&GR'       | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '10'         | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'    |
		And I select current line in "PropertiesTable" table
		And I click choice button of "Next step" attribute in "PropertiesTable" table
		And I go to line in "List" table
			| 'Description'    |
			| 'GR'             |
		And I select current line in "List" table
		And I finish line editing in "PropertiesTable" table
		And Delay 10
		And I click the button named "Save"
		And Delay 10
		If "PropertiesTable" table does not contain lines Then
			| 'Marked'   | 'Is modified'   | 'Object'                                         | '#'   | 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Current step'   | 'Row ref'                                | 'Basis key'                               |
			| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '1'   | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | ''        | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'GR'          | '10'         | ''               | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '2'   | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | ''        | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | 'PI'          | '2'          | ''               | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '3'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | ''        | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | 'PI&GR'       | '5'          | ''               | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '1'   | 'baf60337-67a7-4627-8518-6881217d1593'   | ''        | 'baf60337-67a7-4627-8518-6881217d1593'   | 'PI&GR'       | '2'          | ''               | 'baf60337-67a7-4627-8518-6881217d1593'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '2'   | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | ''        | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | 'PI'          | '2'          | ''               | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '3'   | '2f854b37-44db-469e-a5cb-6478adca5001'   | ''        | '2f854b37-44db-469e-a5cb-6478adca5001'   | 'PI&GR'       | '5'          | ''               | '2f854b37-44db-469e-a5cb-6478adca5001'   | '                                    '    |
			And I go to line in "PropertiesTable" table
				| '#'   | 'Is modified'   | 'Key'                                    | 'Marked'   | 'Next step'   | 'Object'                                         | 'Quantity'   | 'Row ID'                                 | 'Row ref'                                 |
				| '1'   | 'No'            | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'No'       | 'PI&GR'       | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '10'         | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'    |
			And I select current line in "PropertiesTable" table
			And I click choice button of "Next step" attribute in "PropertiesTable" table
			And I go to line in "List" table
				| 'Description'    |
				| 'GR'             |
			And I select current line in "List" table
			And I finish line editing in "PropertiesTable" table
			And Delay 10
			And I click the button named "Save"
			And Delay 10
			And "PropertiesTable" table contains lines
				| 'Marked'   | 'Is modified'   | 'Object'                                         | '#'   | 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Current step'   | 'Row ref'                                | 'Basis key'                               |
				| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '1'   | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | ''        | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'GR'          | '10'         | ''               | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | '                                    '    |
				| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '2'   | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | ''        | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | 'PI'          | '2'          | ''               | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | '                                    '    |
				| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '3'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | ''        | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | 'PI&GR'       | '5'          | ''               | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | '                                    '    |
				| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '1'   | 'baf60337-67a7-4627-8518-6881217d1593'   | ''        | 'baf60337-67a7-4627-8518-6881217d1593'   | 'PI&GR'       | '2'          | ''               | 'baf60337-67a7-4627-8518-6881217d1593'   | '                                    '    |
				| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '2'   | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | ''        | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | 'PI'          | '2'          | ''               | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | '                                    '    |
				| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '3'   | '2f854b37-44db-469e-a5cb-6478adca5001'   | ''        | '2f854b37-44db-469e-a5cb-6478adca5001'   | 'PI&GR'       | '5'          | ''               | '2f854b37-44db-469e-a5cb-6478adca5001'   | '                                    '    |
		And I click the button named "Refresh"
		And "PropertiesTable" table contains lines
			| 'Marked'   | 'Is modified'   | 'Object'                                         | '#'   | 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Current step'   | 'Row ref'                                | 'Basis key'                               |
			| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '1'   | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | ''        | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'GR'          | '10'         | ''               | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '2'   | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | ''        | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | 'PI'          | '2'          | ''               | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '3'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | ''        | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | 'PI&GR'       | '5'          | ''               | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '1'   | 'baf60337-67a7-4627-8518-6881217d1593'   | ''        | 'baf60337-67a7-4627-8518-6881217d1593'   | 'PI&GR'       | '2'          | ''               | 'baf60337-67a7-4627-8518-6881217d1593'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '2'   | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | ''        | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | 'PI'          | '2'          | ''               | '59a126c2-0ca4-4dad-b39b-606e75973f8e'   | '                                    '    |
			| 'No'       | 'No'            | 'Purchase order 116 dated 12.02.2021 12:44:59'   | '3'   | '2f854b37-44db-469e-a5cb-6478adca5001'   | ''        | '2f854b37-44db-469e-a5cb-6478adca5001'   | 'PI&GR'       | '5'          | ''               | '2f854b37-44db-469e-a5cb-6478adca5001'   | '                                    '    |
		And I close all client application windows
		
				
Scenario: _604720 execute code (ObjectPropertyEditor)
	And I close all client application windows
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"	
	* Select object
		And I select "(Document) Inventory transfer order" exact value from "Object type" drop-down list
		And I select "Main attributes" exact value from "Table" drop-down list
		And I click the button named "Refresh"
	* Check execute code
		Then "Object property editor" window is opened
		And I go to line in "PropertiesTable" table
			| 'Object'                                                   |
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    |
		And I change "Marked" checkbox in "PropertiesTable" table
		And I finish line editing in "PropertiesTable" table
		And I activate "Company" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click the button named "PropertiesTableContextMenuRunACodeForMarkedRows"		
		Then "Run code form" window is opened
		And I click "Run code" button
		Then there are lines in TestClient message log
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    |
		And I close all client application windows
				
				

Scenario: _604722 change properties (ObjectPropertyEditor)	
		And I close all client application windows			
	* Open Object property editor
		Given I open hyperlink "e1cib/app/DataProcessor.ObjectPropertyEditor"			
	* Select document
		And I select "(Catalog) Item" exact value from "Object type" drop-down list
		And I select "Add properties" exact value from "Table" drop-down list
		And I click the button named "Refresh"
		Then "Object property editor" window is opened
		And I go to line in "PropertiesTable" table
			| 'Object' |
			| 'Boots'  |
		And I activate "Test" field in "PropertiesTable" table
		And in the table "PropertiesTable" I click "Edit" button
		And I click choice button of "Test" attribute in "PropertiesTable" table
		And I activate "Additional attribute" field in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'Test 1'      |
		And I click "Select" button
		And I finish line editing in "PropertiesTable" table
		And I click the button named "Save"
	* Check
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f6"
		And I click "Add properties" button
		And "Properties" table contains lines
			| 'Property' | 'Value'  |
			| 'Test'     | 'Test 1' |
	And I close all client application windows
	
		
		
				
						
				
		
				
				
				

				
					
						
				


				


		
				
				
				
				
				
				

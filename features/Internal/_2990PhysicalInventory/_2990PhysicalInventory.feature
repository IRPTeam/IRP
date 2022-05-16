#language: en
@tree
@Positive
@PhysicalInventory

Feature: product inventory

As a developer
I'd like to add functionality to write off shortages and recover surplus goods.
To work with the products


Background:
	Given I launch TestClient opening script or connect the existing one




	
Scenario: _2990000 preparation (product inventory)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Items objects (serial lot numbers)
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
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When update ItemKeys
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
		When Create document PurchaseInvoice objects (serial lot numbers)
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(161).GetObject().Write(DocumentWriteMode.Posting);" |
	* Add balances for created store (Opening entry)
		* Open document form opening entry
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			And I click the button named "FormCreate"
		* Filling in company info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the tabular part Inventory
			And I move to "Inventory" tab
			And in the table "Inventory" I click the button named "InventoryAdd"
			And I click choice button of "Item" attribute in "Inventory" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "Inventory" table
			And I go to line in "List" table
				| Item  | Item key |
				| Dress | XS/Blue  |
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "Inventory" table
			And I go to line in "List" table
				| Description |
				| Store 05    |
			And I select current line in "List" table
			And I activate "Quantity" field in "Inventory" table
			And I input "200,000" text in "Quantity" field of "Inventory" table
			And I finish line editing in "Inventory" table
			And in the table "Inventory" I click the button named "InventoryAdd"
			And I click choice button of "Item" attribute in "Inventory" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'       |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "Inventory" table
			And I go to line in "List" table
				| Item  | Item key |
				| Dress | S/Yellow |
			And I select current line in "List" table
			And I activate "Store" field in "Inventory" table
			And I click choice button of "Store" attribute in "Inventory" table
			And I go to line in "List" table
				| Description |
				| Store 05    |
			And I select current line in "List" table
			And I activate "Quantity" field in "Inventory" table
			And I input "120,000" text in "Quantity" field of "Inventory" table
			And I finish line editing in "Inventory" table
			And I click the button named "FormPost"
			And I delete "$$NumberOpeningEntry2990000$$" variable
			And I delete "$$OpeningEntry2990000$$" variable
			And I save the value of "Number" field as "$$NumberOpeningEntry2990000$$"
			And I save the window as "$$OpeningEntry2990000$$"
			And I click the button named "FormPostAndClose"


Scenario: _2990001 filling in the status guide for PhysicalInventory and PhysicalCountByLocation
	* Open a creation form Object Statuses
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Assigning a name to a predefined element of PhysicalInventory
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data name |
			| PhysicalInventory         |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Physical inventory" text in the field named "Description_en"
		And I input "Physical inventory TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Add status "Draft"
		And I go to line in "List" table
		| 'Description'              |
		| 'Physical inventory' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Draft" text in the field named "Description_en"
		And I input "Draft TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
	* Assigning a name to a predefined element of PhysicalCountByLocation
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data name |
			| PhysicalCountByLocation         |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Physical count by location" text in the field named "Description_en"
		And I input "Physical count by location TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Add status "Draft"
		And I go to line in "List" table
		| 'Description'              |
		| 'Physical count by location' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Draft" text in the field named "Description_en"
		And I input "Draft TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2


Scenario: _2990002 create Stock adjustment as surplus
	* Open document form
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'      |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'      |
		And I select current line in "List" table
	* Filling in the tabular part
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Distribution department'  |
		And I select current line in "List" table
		And I click choice button of "Revenue type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Check filling in tabular part
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'      | 'Unit' | 'Revenue type' | 'Basis document' |
			| 'Dress' | '8,000'    | 'M/White'  | 'Distribution department' | 'pcs'  | 'Delivery'     | ''               |
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberStockAdjustmentAsSurplus2990002$$" variable
		And I delete "$$StockAdjustmentAsSurplus2990002$$" variable
		And I save the value of "Number" field as "$$NumberStockAdjustmentAsSurplus2990002$$"
		And I close all client application windows
	* Re-select store and company (store does not use Shipment confirmation and Goods receipt)
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01' |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I close all client application windows

Scenario: _2990003 create Stock adjustment as write off
	* Open document form
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'      |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'      |
		And I select current line in "List" table
	* Filling in the tabular part
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Distribution department'  |
		And I select current line in "List" table
		And I click choice button of "Expense type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Check filling in tabular part
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'           | 'Unit' | 'Expense type' | 'Basis document' |
			| 'Dress' | '8,000'    | 'M/White'  | 'Distribution department' | 'pcs'  | 'Delivery'     | ''               |
	* Post document
		And I click the button named "FormPost"
		And I delete "$$NumberStockAdjustmentAsWriteOff2990003$$" variable
		And I delete "$$StockAdjustmentAsWriteOff2990003$$" variable
		And I save the value of "Number" field as "$$NumberStockAdjustmentAsWriteOff2990003$$"
		And I close all client application windows
	* Re-select store and company (store does not use Shipment confirmation and Goods receipt)
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01' |
		And I select current line in "List" table
		And I click the button named "FormPost"
		Then the form attribute named "Company" became equal to "Second Company"
		Then the form attribute named "Store" became equal to "Store 01"	
		And I close all client application windows

Scenario: _2990004 create Physical inventory and check Row Id info tab
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I select "Done" exact value from "Status" drop-down list
	* Check filling in document with stock balances
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click "Fill expected count" button		
		And Delay 2
		Then the number of "ItemList" table lines is "меньше или равно" 2
		And "ItemList" table contains lines
			| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' |
			| 'Dress' | '-120,000'   | 'S/Yellow' | '120,000'    | 'pcs'  |
			| 'Dress' | '-200,000'   | 'XS/Blue'  | '200,000'    | 'pcs'  |
		And I click "Fill expected count" button
		And Delay 2
		Then the number of "ItemList" table lines is "меньше или равно" 2
		And "ItemList" table contains lines
			| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' |
			| 'Dress' | '-120,000'   | 'S/Yellow' | '120,000'    | 'pcs'  |
			| 'Dress' | '-200,000'   | 'XS/Blue'  | '200,000'    | 'pcs'  |
	* Filling in Phys. count
		And I go to line in "ItemList" table
			| 'Difference' | 'Exp. count' | 'Item'  | 'Item key' | 'Unit' |
			| '-200,000'   | '200,000'    | 'Dress' | 'XS/Blue'  | 'pcs'  |
		And I select current line in "ItemList" table
		And I input "198,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Difference' | 'Exp. count' | 'Item'  | 'Item key' | 'Unit' |
			| '-120,000'   | '120,000'    | 'Dress' | 'S/Yellow' | 'pcs'  |
		And I select current line in "ItemList" table
		And I input "125,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		* Try to add Service
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I activate "Item" field in "ItemList" table
			And I click choice button of "Item" attribute in "ItemList" table
			And "List" table does not contain lines
				| 'Description' |
				| 'Service' |
			And I close "Items" window			
			And I finish line editing in "ItemList" table
			And I delete a line in "ItemList" table	
			When in opened panel I select "Physical inventory (create) *"
			Then "Physical inventory (create) *" window is opened
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "89908" text in the field named "InputFld"
			And I click the button named "OK"
			And "ItemList" table became equal
				| '#' | 'Exp. count' | 'Item'  | 'Item key' | 'Unit' | 'Difference' | 'Phys. count' | 'Manual fixed count' | 'Description' |
				| '1' | '120,000'    | 'Dress' | 'S/Yellow' | 'pcs'  | '5,000'      | '125,000'     | ''                   | ''            |
				| '2' | '200,000'    | 'Dress' | 'XS/Blue'  | 'pcs'  | '-2,000'     | '198,000'     | ''                   | ''            |					
	* Posting the document Physical inventory
		And I click the button named "FormPost"
		And I delete "$$NumberPhysicalInventory2990004$$" variable
		And I delete "$$PhysicalInventory2990004$$" variable
		And I save the value of "Number" field as "$$NumberPhysicalInventory2990004$$"
		And I save the window as "$$PhysicalInventory2990004$$"
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1PhysicalInventory2990004$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2PhysicalInventory2990004$$"
	* Check row id info tab
		And I move to "Row ID Info" tab
		And "RowIDInfo" table became equal
			| '#' | 'Key'                              | 'Basis' | 'Row ID'                           | 'Next step'                     | 'Quantity'     | 'Basis key'                            | 'Current step' | 'Row ref'                          |
			| '1' | '$$Rov1PhysicalInventory2990004$$' | ''      | '$$Rov1PhysicalInventory2990004$$' | 'Stock adjustment as surplus'   | '5,000' | '                                    ' | ''             | '$$Rov1PhysicalInventory2990004$$' |
			| '2' | '$$Rov2PhysicalInventory2990004$$' | ''      | '$$Rov2PhysicalInventory2990004$$' | 'Stock adjustment as write off' | '2,000' | '                                    ' | ''             | '$$Rov2PhysicalInventory2990004$$' |
		And I close all client application windows
	

Scenario: _2990006 create Stock adjustment as surplus based on Physical inventory (link/unlink)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
	* Create a document StockAdjustmentAsSurplus and check filling in
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 05' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Logistics department' |
		And I select current line in "List" table	
	* Filling ItemList tab and check link/unlink line
		* Add item from Physical inventory
			And in the table "ItemList" I click "Add basis documents" button
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
				| '5,000'    | 'Dress (S/Yellow)'  | 'pcs'  | 'No'  |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center' | 'Unit' | 'Revenue type' | 'Basis document'               |
				| 'Dress' | '5,000'    | 'S/Yellow' | ''                   | 'pcs'  | ''             | '$$PhysicalInventory2990004$$' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
			And I go to line in "List" table
				| 'Description'          |
				| 'Logistics department' |
			And I select current line in "List" table
			And I activate "Revenue type" field in "ItemList" table
			And I click choice button of "Revenue type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Revenue'     |
			And I select current line in "List" table	
			And I click the button named "FormPost"
			And I delete "$$NumberStockAdjustmentAsSurplus2990006$$" variable
			And I delete "$$StockAdjustmentAsSurplus2990006$$" variable
			And I save the window as "$$StockAdjustmentAsSurplus2990006$$"
			And I save the value of "Number" field as "$$NumberStockAdjustmentAsSurplus2990006$$"
		* Check Row ID info tab
			And I click "Show row key" button
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I save the current field value as "$$Rov1StockAdjustmentAsSurplus2990006$$"
			And I move to "Row ID Info" tab
			And "RowIDInfo" table became equal
				| '#' | 'Key'                                     | 'Basis'                        | 'Row ID'                           | 'Next step' | 'Quantity'     | 'Basis key'                        | 'Current step'                | 'Row ref'                          |
				| '1' | '$$Rov1StockAdjustmentAsSurplus2990006$$' | '$$PhysicalInventory2990004$$' | '$$Rov1PhysicalInventory2990004$$' | ''          | '5,000' | '$$Rov1PhysicalInventory2990004$$' | 'Stock adjustment as surplus' | '$$Rov1PhysicalInventory2990004$$' |
			Then the number of "RowIDInfo" table lines is "равно" "1"
		* Unlink line and check Row ID info tab
			And in the table "ItemList" I click "Link unlink basis documents" button			
			And I set checkbox "Linked documents"		
			And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
			And I go to line in "ResultsTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' |
				| '5,000'    | 'Dress (S/Yellow)'  | 'pcs'  |
			And I click "Unlink" button
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'   | 'Unit' | 'Revenue type' | 'Basis document' |
				| 'Dress' | '5,000'    | 'S/Yellow' | 'Logistics department' | 'pcs'  | 'Revenue'      | ''               |
			And I click the button named "FormPost"
			And "RowIDInfo" table became equal
				| '#' | 'Key'                                     | 'Basis' | 'Row ID'                                  | 'Next step' | 'Quantity'     | 'Basis key'                            | 'Current step' | 'Row ref'                                 |
				| '1' | '$$Rov1StockAdjustmentAsSurplus2990006$$' | ''      | '$$Rov1StockAdjustmentAsSurplus2990006$$' | ''          | '5,000' | '                                    ' | ''             | '$$Rov1StockAdjustmentAsSurplus2990006$$' |
			Then the number of "RowIDInfo" table lines is "равно" "1"
		* Link line and check Row ID info tab
			And I move to "Items" tab
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' |
				| '5,000'    | 'Dress (S/Yellow)' | 'pcs'  |
			And I click "Link" button
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'   | 'Unit' | 'Revenue type' | 'Basis document'               |
				| 'Dress' | '5,000'    | 'S/Yellow' | 'Logistics department' | 'pcs'  | 'Revenue'      | '$$PhysicalInventory2990004$$' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
			And I go to line in "List" table
				| 'Description'          |
				| 'Logistics department' |
			And I select current line in "List" table
			And I activate "Revenue type" field in "ItemList" table
			And I click choice button of "Revenue type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Revenue'     |
			And I select current line in "List" table
			And "RowIDInfo" table became equal
				| '#' | 'Key'                                     | 'Basis'                        | 'Row ID'                           | 'Next step' | 'Quantity'     | 'Basis key'                        | 'Current step'                | 'Row ref'                          |
				| '1' | '$$Rov1StockAdjustmentAsSurplus2990006$$' | '$$PhysicalInventory2990004$$' | '$$Rov1PhysicalInventory2990004$$' | ''          | '5,000' | '$$Rov1PhysicalInventory2990004$$' | 'Stock adjustment as surplus' | '$$Rov1PhysicalInventory2990004$$' |
			Then the number of "RowIDInfo" table lines is "равно" "1"
		And I close all client application windows
	
	

Scenario: _2990007 create Stock adjustment as write off based on Physical inventory
	* Open document form
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
	* Create a document StockAdjustmentAsSurplus and check filling in
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Store 05' |
		And I select current line in "List" table
	* Filling ItemList tab and check link/unlink line
		* Add item from Physical inventory
			And in the table "ItemList" I click "Add basis documents" button
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' | 'Use' |
				| '2,000'    | 'Dress (XS/Blue)'  | 'pcs'  | 'No'  |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center' | 'Unit' | 'Expense type' | 'Basis document'               |
				| 'Dress' | '2,000'    | 'XS/Blue'  | ''                   | 'pcs'  | ''             | '$$PhysicalInventory2990004$$' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
			And I go to line in "List" table
				| 'Description'          |
				| 'Logistics department' |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Expense'     |
			And I select current line in "List" table	
			And I click the button named "FormPost"
			And I delete "$$NumberStockAdjustmentAsWriteOff2990007$$" variable
			And I delete "$$StockAdjustmentAsWriteOff2990007$$" variable
			And I save the window as "$$StockAdjustmentAsWriteOff2990007$$"
			And I save the value of "Number" field as "$$NumberStockAdjustmentAsWriteOff2990007$$"
		* Check Row ID info tab
			And I click "Show row key" button
			And I go to line in "ItemList" table
				| '#' |
				| '1' |
			And I activate "Key" field in "ItemList" table
			And I save the current field value as "$$Rov1StockAdjustmentAsWriteOff2990007$$"
			And I move to "Row ID Info" tab
			And "RowIDInfo" table became equal
				| '#' | 'Key'                                      | 'Basis'                        | 'Row ID'                           | 'Next step' | 'Quantity'     | 'Basis key'                        | 'Current step'                | 'Row ref'                          |
				| '1' | '$$Rov1StockAdjustmentAsWriteOff2990007$$' | '$$PhysicalInventory2990004$$' | '$$Rov2PhysicalInventory2990004$$' | ''          | '2,000' | '$$Rov2PhysicalInventory2990004$$' | 'Stock adjustment as write off' | '$$Rov2PhysicalInventory2990004$$' |
			Then the number of "RowIDInfo" table lines is "равно" "1"
		* Unlink line and check Row ID info tab
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I activate field named "ItemListRowsRowPresentation" in "ItemListRows" table
			And I set checkbox "Linked documents"	
			And I go to line in "ResultsTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' |
				| '2,000'    | 'Dress (XS/Blue)'  | 'pcs'  |
			And I click "Unlink" button
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'   | 'Unit' | 'Expense type' | 'Basis document' |
				| 'Dress' | '2,000'    | 'XS/Blue'  | 'Logistics department' | 'pcs'  | 'Expense'      | ''               |
			And I click the button named "FormPost"
			And "RowIDInfo" table became equal
				| '#' | 'Key'                                      | 'Basis' | 'Row ID'                                   | 'Next step' | 'Quantity'     | 'Basis key'                            | 'Current step' | 'Row ref'                                  |
				| '1' | '$$Rov1StockAdjustmentAsWriteOff2990007$$' | ''      | '$$Rov1StockAdjustmentAsWriteOff2990007$$' | ''          | '2,000' | '                                    ' | ''             | '$$Rov1StockAdjustmentAsWriteOff2990007$$' |
			Then the number of "RowIDInfo" table lines is "равно" "1"
		* Link line and check Row ID info tab
			And I move to "Items" tab
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' |
				| '2,000'    | 'Dress (XS/Blue)'  | 'pcs'  |
			And I click "Link" button
			And I click "Ok" button
			And "ItemList" table contains lines
				| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'   | 'Unit' | 'Expense type' | 'Basis document'               |
				| 'Dress' | '2,000'    | 'XS/Blue'  | 'Logistics department' | 'pcs'  | 'Expense'      | '$$PhysicalInventory2990004$$' |
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListProfitLossCenter" in "ItemList" table
			And I go to line in "List" table
				| 'Description'          |
				| 'Logistics department' |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Expense'     |
			And I select current line in "List" table
			And "RowIDInfo" table became equal
				| '#' | 'Key'                                      | 'Basis'                        | 'Row ID'                           | 'Next step' | 'Quantity'     | 'Basis key'                        | 'Current step'                | 'Row ref'                          |
				| '1' | '$$Rov1StockAdjustmentAsWriteOff2990007$$' | '$$PhysicalInventory2990004$$' | '$$Rov2PhysicalInventory2990004$$' | ''          | '2,000' | '$$Rov2PhysicalInventory2990004$$' | 'Stock adjustment as write off' | '$$Rov2PhysicalInventory2990004$$' |
			Then the number of "RowIDInfo" table lines is "равно" "1"
		And I close all client application windows


Scenario: _2990013 check the question of saving Physical inventory before creating Physical count by location
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Filling out a document with stock balances
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click "Fill expected count" button
	* Check message output
		And I click "Physical count by location" button
		Then the form attribute named "Message" became equal to
		|'To run the "Physical count by location" command, you must save your work. Click OK to save and continue, or click Cancel to return.'|
	And I close all client application windows


Scenario: _2990015 create Physical inventory with Physical count by location (with serial lot numbers)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I move to "Rules" tab
		And I set checkbox "Use serial lot"
		And I activate "Exp. count" field in "ItemList" table	
	* Filling out a document with stock balances
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 07'    |
		And I select current line in "List" table
		And I click "Fill expected count" button
	* Check filling
		And "ItemList" table became equal
			| '#' | 'Exp. count' | 'Item'               | 'Item key' | 'Serial lot number' | 'Unit' | 'Difference' | 'Phys. count' | 'Manual fixed count' | 'Description' |
			| '1' | '500,000'    | 'Dress'              | 'XS/Blue'  | ''                  | 'pcs'  | '-500,000'   | ''            | ''                   | ''            |
			| '2' | '150,000'    | 'Boots'              | '37/18SD'  | ''                  | 'pcs'  | '-150,000'   | ''            | ''                   | ''            |
			| '3' | '20,000'     | 'High shoes'         | '37/19SD'  | ''                  | 'pcs'  | '-20,000'    | ''            | ''                   | ''            |
			| '4' | '120,000'    | 'Product 1 with SLN' | 'PZU'      | '8908899877'        | 'pcs'  | '-120,000'   | ''            | ''                   | ''            |
	* Create Physical count by location
		And I click "Post" button
		And I delete "$$NumberPhysicalInventory3$$" variable
		And I delete "$$PhysicalInventory3$$" variable
		And I save the window as "$$PhysicalInventory3$$"
		And I save the value of "Number" field as "$$NumberPhysicalInventory3$$"
		And I move to "Physical count by location" tab
		And I click "Physical count by location" button
		Then "How many documents to create?" window is opened
		And I input "3" text in the field named "InputFld"
		And I click the button named "OK"
		* Check
			And "PhysicalCountByLocationList" table contains lines
				| 'Reference'         | 'Status'   | 'Count rows' | 'Phys. count' |
				| 'Location count 1*' | 'Prepared' | ''           | ''            |
				| 'Location count 2*' | 'Prepared' | ''           | ''            |
				| 'Location count 3*' | 'Prepared' | ''           | ''            |
			Then the number of "PhysicalCountByLocationList" table lines is "равно" 3
	* Filling second Physical count by location
		And I go to the last line in "PhysicalCountByLocationList" table	
		And I select current line in "PhysicalCountByLocationList" table
		* Scan item without serial lot number
			And in the table "ItemList" I click the button named "SearchByBarcode"
			Then "Enter a barcode" window is opened
			And I input "2202283705" text in the field named "InputFld"
			And I click the button named "OK"
			And I activate "Phys. count" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "53,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Scan item with serial lot number (with barcode)
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "23455677788976667" text in the field named "InputFld"
			And I click the button named "OK"
			And I input "5,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Scan item without serial lot number (need to select serial lot number)
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "67789997777899" text in the field named "InputFld"
			And I click the button named "OK"
			And I activate "Serial lot number" field in "ItemList" table
			And I click choice button of "Serial lot number" attribute in "ItemList" table
			And I activate field named "Owner" in "List" table
			And I click "Create" button
			And I input "677899" text in "Serial number" field
			And I click "Save and close" button
			And I wait "Item serial/lot number (create) *" window closing in 20 seconds
			Then "Item serial/lot numbers" window is opened
			And I go to line in "List" table
				| 'Owner' | 'Serial number' |
				| 'ODS'   | '677899'        |
			And I select current line in "List" table
			And I activate "Phys. count" field in "ItemList" table
			And I input "4,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add item from Pickup form
			And in the table "ItemList" I click "Pickup" button
			And I go to line in "ItemList" table
				| 'Title' |
				| 'Dress' |
			And I select current line in "ItemList" table
			And I move to the next attribute
			And I go to line in "ItemKeyList" table
				| 'Title'    |
				| 'S/Yellow' |
			And I select current line in "ItemKeyList" table
			And I click "Transfer to document" button
			And I activate "Phys. count" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "110,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add item input by string
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' | 'Reference' |
				| 'Dress'       | 'Dress'     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'XS/Blue'  |
			And I select current line in "List" table
			And I activate "Phys. count" field in "ItemList" table
			And I input "50,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I move to the next attribute
			// And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			// And I select "Done" exact value from the drop-down list named "Status"
			And I click "Save and close" button
	* Check update Physical count by location tab in the Physical inventory
		And "PhysicalCountByLocationList" table contains lines
			| 'Reference'         | 'Status'   | 'Count rows' | 'Phys. count' |
			| 'Location count 1*' | 'Prepared' | ''           | ''            |
			| 'Location count 2*' | 'Prepared' | ''           | ''            |
			| 'Location count 3*' | 'Prepared' | '5'          | '222,000'     |
		Then the number of "PhysicalCountByLocationList" table lines is "равно" 3
		And I close all client application windows

Scenario: _2990016 filling Physical count by location (mobile form)
	And I close all client application windows
	And In the command interface I select "Mobile" "Mobile invent"
	* Select Location count 
		And I click Select button of "DocumentRef" field
		And I go to the first line in "List" table
		And I select current line in "List" table
		Given Recent TestClient message contains "Current location #* was linked to you. Other users will not be able to scan it." string by template
	* Scan item without serial lot number
		And I click "SearchByBarcode" button
		And I input "4820024700016" text in "InputFld" field
		And I click "OK" button
	* Scan item with serial lot number and change quantity
		And I click "SearchByBarcode" button
		And I input "23455677788976667" text in "InputFld" field
		And I click "OK" button
		And I go to line in "ItemList" table
			| 'Item'               | 'Item key' | 'Phys. count' | 'Serial lot number' |
			| 'Product 1 with SLN' | 'PZU'      | '1,000'       | '8908899877'        |
		And I activate "Phys. count" field in "ItemList" table
		And I select current line in "ItemList" table
		Then "Row form" window is opened
		And I input "2,000" text in the field named "Quantity"
		And I click the button named "OK"
	* Scan service
		And I click "SearchByBarcode" button
		And I input "89908" text in "InputFld" field
		And I click "OK" button
	* Check item tab
		And "ItemList" table became equal
			| 'Item'               | 'Item key' | 'Serial lot number' | 'Phys. count' |
			| 'Boots'              | '36/18SD'  | ''                  | '1,000'       |
			| 'Product 1 with SLN' | 'PZU'      | '8908899877'        | '2,000'       |
		Then the number of "ItemList" table lines is "равно" 2
		
		
				
		
		
				


		
		
				

			
						
			
						
			
						

		
				
		
				
			
			
						
		
				
		
		
				



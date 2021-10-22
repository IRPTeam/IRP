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
			And I activate "Store" field in "Inventory" table
			And I click choice button of "Store" attribute in "Inventory" table
			And I go to line in "List" table
				| Description |
				| Store 06    |
			And I select current line in "List" table
			And I finish line editing in "Inventory" table
			And I activate "Quantity" field in "Inventory" table
			And I select current line in "Inventory" table
			And I input "400,000" text in "Quantity" field of "Inventory" table
			And I finish line editing in "Inventory" table
			And in the table "Inventory" I click the button named "InventoryAdd"
			And I click choice button of "Item" attribute in "Inventory" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'       |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "Inventory" table
			And I go to line in "List" table
				| Item  | Item key |
				| Trousers | 36/Yellow  |
			And I select current line in "List" table
			And I activate "Store" field in "Inventory" table
			And I click choice button of "Store" attribute in "Inventory" table
			And I go to line in "List" table
				| Description |
				| Store 06    |
			And I select current line in "List" table
			And I finish line editing in "Inventory" table
			And I activate "Quantity" field in "Inventory" table
			And I select current line in "Inventory" table
			And I input "400,000" text in "Quantity" field of "Inventory" table
			And I finish line editing in "Inventory" table
			And I click the button named "FormPost"
			And I delete "$$NumberOpeningEntry2990000$$" variable
			And I delete "$$OpeningEntry2990000$$" variable
			And I save the value of "Number" field as "$$NumberOpeningEntry2990000$$"
			And I save the window as "$$OpeningEntry2990000$$"
			And I click the button named "FormPostAndClose"


Scenario: _2990001 filling in the status guide for PhysicalInventory and PhysicalCountByLocation
	* Open a creation form Object Statuses
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
		| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'           | 'Unit' | 'Revenue type' | 'Basis document' |
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
		And I set checkbox "Use responsible person by row"
		And I select "Done" exact value from "Status" drop-down list
	* Check filling in document with stock balances
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click "Fill exp. count" button
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
			| '#' | 'Key'                              | 'Basis' | 'Row ID'                           | 'Next step'                     | 'Q'     | 'Basis key' | 'Current step' | 'Row ref'                          |
			| '1' | '$$Rov1PhysicalInventory2990004$$' | ''      | '$$Rov1PhysicalInventory2990004$$' | 'Stock adjustment as surplus'   | '5,000' | ''          | ''             | '$$Rov1PhysicalInventory2990004$$' |
			| '2' | '$$Rov2PhysicalInventory2990004$$' | ''      | '$$Rov2PhysicalInventory2990004$$' | 'Stock adjustment as write off' | '2,000' | ''          | ''             | '$$Rov2PhysicalInventory2990004$$' |	
		And I close all client application windows
	


Scenario: _2990005 create Physical inventory (store does not use GR and SC)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I set checkbox "Use responsible person by row"
		And I select "Done" exact value from "Status" drop-down list
	* Check filling in document with stock balances
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 06'    |
		And I select current line in "List" table
		And I click "Fill exp. count" button
		And Delay 2
		Then the number of "ItemList" table lines is "меньше или равно" 2
		And "ItemList" table contains lines
		| 'Item'     | 'Difference' | 'Item key'   | 'Exp. count' | 'Unit' |
		| 'Dress'    | '-400,000'   | 'XS/Blue'    | '400,000'    | 'pcs'  |
		| 'Trousers' | '-400,000'   | '36/Yellow'  | '400,000'    | 'pcs'  |
	* Filling in Phys. count
		And I go to line in "ItemList" table
			| 'Difference' | 'Exp. count' | 'Item'  | 'Item key' | 'Unit' |
			| '-400,000'   | '400,000'    | 'Dress' | 'XS/Blue'  | 'pcs'  |
		And I select current line in "ItemList" table
		And I input "398,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Difference' | 'Exp. count' | 'Item'     | 'Item key'  | 'Unit' |
			| '-400,000'   | '400,000'    | 'Trousers' | '36/Yellow' | 'pcs'  |
		And I select current line in "ItemList" table
		And I input "405,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Posting the document Physical inventory
		And I click the button named "FormPost"
		And I delete "$$NumberPhysicalInventory2990005$$" variable
		And I delete "$$PhysicalInventory2990005$$" variable
		And I save the value of "Number" field as "$$NumberPhysicalInventory2990005$$"
		And I save the window as "$$PhysicalInventory2990005$$"
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
				| 'Dress' | '5,000'    | 'S/Yellow' | ''              | 'pcs'  | ''             | '$$PhysicalInventory2990004$$' |
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
				| '#' | 'Key'                                     | 'Basis'                        | 'Row ID'                           | 'Next step' | 'Q'     | 'Basis key'                        | 'Current step'                | 'Row ref'                          |
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
				| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'        | 'Unit' | 'Revenue type' | 'Basis document' |
				| 'Dress' | '5,000'    | 'S/Yellow' | 'Logistics department' | 'pcs'  | 'Revenue'      | ''               |
			And I click the button named "FormPost"
			And "RowIDInfo" table became equal
				| '#' | 'Key'                                     | 'Basis' | 'Row ID'                                  | 'Next step' | 'Q'     | 'Basis key' | 'Current step' | 'Row ref'                                 |
				| '1' | '$$Rov1StockAdjustmentAsSurplus2990006$$' | ''      | '$$Rov1StockAdjustmentAsSurplus2990006$$' | ''          | '5,000' | ''          | ''             | '$$Rov1StockAdjustmentAsSurplus2990006$$' |
			Then the number of "RowIDInfo" table lines is "равно" "1"
		* Link line and check Row ID info tab
			And I move to "Items" tab
			And in the table "ItemList" I click "Link unlink basis documents" button
			And I go to line in "BasisesTree" table
				| 'Quantity' | 'Row presentation' | 'Unit' |
				| '5,000'    | 'Dress (S/Yellow)'  | 'pcs'  |
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
				| '#' | 'Key'                                     | 'Basis'                        | 'Row ID'                           | 'Next step' | 'Q'     | 'Basis key'                        | 'Current step'                | 'Row ref'                          |
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
				| 'Dress' | '2,000'    | 'XS/Blue'  | ''              | 'pcs'  | ''             | '$$PhysicalInventory2990004$$' |
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
				| '#' | 'Key'                                      | 'Basis'                        | 'Row ID'                           | 'Next step' | 'Q'     | 'Basis key'                        | 'Current step'                | 'Row ref'                          |
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
				| 'Item'  | 'Quantity' | 'Item key'       | 'Profit loss center'        | 'Unit' | 'Expense type' | 'Basis document' |
				| 'Dress' | '2,000'    | 'XS/Blue'        | 'Logistics department' | 'pcs'  | 'Expense'      | ''               |
			And I click the button named "FormPost"
			And "RowIDInfo" table became equal
				| '#' | 'Key'                                      | 'Basis' | 'Row ID'                                   | 'Next step' | 'Q'     | 'Basis key' | 'Current step' | 'Row ref'                                  |
				| '1' | '$$Rov1StockAdjustmentAsWriteOff2990007$$' | ''      | '$$Rov1StockAdjustmentAsWriteOff2990007$$' | ''          | '2,000' | ''          | ''             | '$$Rov1StockAdjustmentAsWriteOff2990007$$' |
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
				| '#' | 'Key'                                      | 'Basis'                        | 'Row ID'                           | 'Next step' | 'Q'     | 'Basis key'                        | 'Current step'                | 'Row ref'                          |
				| '1' | '$$Rov1StockAdjustmentAsWriteOff2990007$$' | '$$PhysicalInventory2990004$$' | '$$Rov2PhysicalInventory2990004$$' | ''          | '2,000' | '$$Rov2PhysicalInventory2990004$$' | 'Stock adjustment as write off' | '$$Rov2PhysicalInventory2990004$$' |
			Then the number of "RowIDInfo" table lines is "равно" "1"
		And I close all client application windows

Scenario: _2990008 create Stock adjustment as surplus and Stock adjustment as write off based on Physical inventory on a partial quantity
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPhysicalInventory2990005$$'    |
	* Create a document StockAdjustmentAsWriteOff on a partial quantity
		And I click the button named "FormDocumentStockAdjustmentAsWriteOffGenerate"
		And I click "Ok" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Logistics department' |
		And I select current line in "List" table
		And I click choice button of "Expense type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Change quantity and post of a document
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
	* Create a document StockAdjustmentAsWriteOff for the remaining quantity and check filling in
		And I click the button named "FormDocumentStockAdjustmentAsWriteOffGenerate"
		And I click "Ok" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Logistics department' |
		And I select current line in "List" table
		And I click choice button of "Expense type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'  | 'Quantity' | 'Item key' | 'Profit loss center'        | 'Unit' | 'Expense type' | 'Basis document'        |
			| 'Dress' | '1,000'    | 'XS/Blue'  | 'Logistics department' | 'pcs'  | 'Delivery'     | '$$PhysicalInventory2990005$$' |
		Then the number of "ItemList" table lines is "меньше или равно" 1
		And I click the button named "FormPostAndClose"
	* Create a document StockAdjustmentAsSurplus on a partial quantity
		And I click the button named "FormDocumentStockAdjustmentAsSurplusGenerate"
		And I click "Ok" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Logistics department' |
		And I select current line in "List" table
		And I click choice button of "Revenue type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Change quantity and post of a document
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
	* Create a document StockAdjustmentAsSurplus for the remaining quantity and check filling in
		And I click the button named "FormDocumentStockAdjustmentAsSurplusGenerate"
		And I click "Ok" button
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Profit loss center" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Logistics department' |
		And I select current line in "List" table
		And I click choice button of "Revenue type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'   | 'Profit loss center'        | 'Unit' | 'Revenue type' | 'Basis document'        |
			| 'Trousers' | '4,000'    | '36/Yellow'  | 'Logistics department' | 'pcs'  | 'Delivery'     | '$$PhysicalInventory2990005$$' |
		Then the number of "ItemList" table lines is "меньше или равно" 1
		And I click the button named "FormPostAndClose"

Scenario: _2990009 check for updates Update Exp Count
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I set checkbox "Use responsible person by row"
	* Check filling in document with stock balances
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 06'    |
		And I select current line in "List" table
		And I click "Fill exp. count" button
		And Delay 2
		Then the number of "ItemList" table lines is "меньше или равно" 2
		And "ItemList" table contains lines
			| 'Item'     | 'Difference' | 'Item key'  | 'Exp. count' | 'Unit' |
			| 'Dress'    | '-398,000'   | 'XS/Blue'   | '398,000'    | 'pcs'  |
			| 'Trousers' | '-405,000'   | '36/Yellow' | '405,000'    | 'pcs'  |
	* Delete second line
		And I go to line in "ItemList" table
			| 'Difference' | 'Exp. count' | 'Item'     | 'Item key'  | 'Unit' |
			| '-405,000'   | '405,000'    | 'Trousers' | '36/Yellow' | 'pcs'  |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		Then the number of "ItemList" table lines is "меньше или равно" 1
	* Add one more line without stock remains
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Boots' | '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate "Phys. count" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check update
		And I click "Update exp. count" button
		Then the number of "ItemList" table lines is "меньше или равно" 3
		And "ItemList" table contains lines
			| 'Phys. count' | 'Item'     | 'Difference' | 'Item key'  | 'Exp. count' | 'Unit' |
			| ''            | 'Trousers' | '-405,000'   | '36/Yellow' | '405,000'    | 'pcs'  |
			| ''            | 'Dress'    | '-398,000'   | 'XS/Blue'   | '398,000'    | 'pcs'  |
			| '2,000'       | 'Boots'    | '2,000'      | '37/18SD'   | ''           | 'pcs'  |
	And I close all client application windows

Scenario: _2990010 create Physical inventory and Physical count by location with distribution to responsible employees
	And I execute 1C:Enterprise script at server
		| "Documents.StockAdjustmentAsWriteOff.FindByNumber($$NumberStockAdjustmentAsWriteOff2990007$$).GetObject().Write(DocumentWriteMode.UndoPosting);" |
		| "Documents.StockAdjustmentAsSurplus.FindByNumber($$NumberStockAdjustmentAsSurplus2990006$$).GetObject().Write(DocumentWriteMode.UndoPosting);" |
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
		And I set checkbox "Use responsible person by row"
	* Filling out a document with stock balances
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click "Fill exp. count" button
		And Delay 2
		Then the number of "ItemList" table lines is "меньше или равно" 2
	* Distribution of items for recalculation into two employees
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'XS/Blue'  | 'pcs'  |
		And I click "Set responsible person" button
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Unit' |
			| 'Dress'    | 'S/Yellow'  | 'pcs'  |
		And I click "Set responsible person" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Anna Petrova' |
		And I select current line in "List" table
		And I save "Format((EndOfDay(CurrentDate()) + 500), \"DF=dd.MM.yyyy\")" in "$$$$DateCurrentDay$$$$" variable
		And I input "$$$$DateCurrentDay$$$$" text in "Date" field
		And I click the button named "FormPost"
		And I delete "$$NumberPhysicalInventory2990010$$" variable
		And I delete "$$PhysicalInventory2990010$$" variable
		And I save the value of "Number" field as "$$NumberPhysicalInventory2990010$$"
		And I save the window as "$$PhysicalInventory2990010$$"
	* Create Physical count by location
		And I click "Physical count by location" button
	* Check the display of which recalculations the string has got into
		And "ItemList" table contains lines
			| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Physical count'    |
			| 'Dress' | '-125,000'   | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date:*'      |
			| 'Dress' | '-198,000'   | 'XS/Blue'  | '198,000'    | 'pcs'  | 'Arina Brown'        | '#2 date:*'      |
	* Check filling in recalculation data in tabular part
		And I move to "Physical count by location" tab
		And "PhysicalCountByLocationList" table contains lines
			| 'Responsible person' | 'Status'   |
			| 'Arina Brown'        | 'Prepared' |
			| 'Anna Petrova'       | 'Prepared' |
	* Posting of surplus items retroactively
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
				| 'Store 05'      |
			And I select current line in "List" table
		* Filling in the tabular part
			* Add first string
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
			* Add second string
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
					| 'XS/Blue'|
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
			* Add third string
				And I click "Add" button
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Shirt'  |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item key' |
					| '36/Red'|
				And I select current line in "List" table
				And I input "7,000" text in "Quantity" field of "ItemList" table
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
			* Add fourth string
				And I click "Add" button
				And I click choice button of "Item" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Boots'  |
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item key' |
					| '36/18SD'|
				And I select current line in "List" table
				And I input "4,000" text in "Quantity" field of "ItemList" table
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
			* Change date and post
				And I input begin of the current month date in "Date" field
				And I click the button named "FormPostAndClose"
	* Post Shipment confirmation retroactively
		* Open Shipment confirmation
			Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
			And I click the button named "FormCreate"
			And I select "Sales" exact value from "Transaction type" drop-down list
		* Filling in Partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 05'    |
			And I select current line in "List" table
		* Filling in Company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main Company'   |
			And I select current line in "List" table
		* Add items
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Dress'    | 'XS/Blue'   |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "4,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Change date and post
			And I move to "Other" tab
			And I input begin of the current month date in "Date" field
			And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Updating the quantity in the inventory document with Physical count by location created
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPhysicalInventory2990010$$'      |
		And I select current line in "List" table
		And I click "Update exp. count" button
		And "ItemList" table contains lines
			| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Physical count' |
			| 'Dress' | '-8,000'     | 'M/White'  | '8,000'      | 'pcs'  | ''                   | ''               |
			| 'Shirt' | '-7,000'     | '36/Red'   | '7,000'      | 'pcs'  | ''                   | ''               |
			| 'Boots' | '-4,000'     | '36/18SD'  | '4,000'      | 'pcs'  | ''                   | ''               |
			| 'Dress' | '-125,000'   | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date*'       |
			| 'Dress' | '-202,000'   | 'XS/Blue'  | '202,000'    | 'pcs'  | 'Arina Brown'        | '#2 date*'       |
		* Check for line locks on which a Physical count by location has already been created
			* Inability to delete a line
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
				And I activate "Item key" field in "ItemList" table
				And I delete a line in "ItemList" table
				And "ItemList" table contains lines
				| 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Physical count' |
				| 'Dress' | '-125,000'   | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date*'       |
			* Inability to change quantity in line
				And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'S/Yellow' |
				When I Check the steps for Exception
				|'And I input "2,000" text in "Phys. count" field of "ItemList" table'|
		* Check the availability of added line
			* Change quantity
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Unit' |
					| 'Dress' | 'M/White'   | 'pcs'  |
				And I select current line in "ItemList" table
				And I input "7,000" text in "Phys. count" field of "ItemList" table
				And I finish line editing in "ItemList" table
			* Delete a line
				And I go to line in "ItemList" table
					| 'Item'  | 'Item key' | 'Unit' |
					| 'Shirt' | '36/Red'   | 'pcs'  |
				And I delete a line in "ItemList" table
				And "ItemList" table does not contain lines
					| 'Item'  | 'Item key' | 'Unit' |
					| 'Shirt' | '36/Red'   | 'pcs'  |
		* Update quantity and create new Physical count by location
			And I click "Update exp. count" button
			And I go to line in "ItemList" table
				| 'Exp. count' | 'Item'  | 'Item key' | 'Unit' |
				| '4,000'      | 'Boots' | '36/18SD'  | 'pcs'  |
			And I input "0,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  | 'Item key' |
				| 'Dress' | 'M/White'   |
			And I input "0,000" text in "Phys. count" field of "ItemList" table
			And I finish line editing in "ItemList" table
			Then I select all lines of "ItemList" table
			And I click "Set responsible person" button
			And I go to line in "List" table
				| 'Description'  |
				| 'Anna Petrova' |
			And I select current line in "List" table
			And I click the button named "FormPost"
			And I click "Physical count by location" button
		* Create new Physical count by location
			And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Physical count' |
			| 'Dress' | 'M/White'  | '8,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
			| 'Shirt' | '36/Red'   | '7,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
			| 'Boots' | '36/18SD'  | '4,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
			| 'Dress' | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date:*'      |
			| 'Dress' | 'XS/Blue'  | '202,000'    | 'pcs'  | 'Arina Brown'        | '#2 date:*'      |
		* Check for impossibility to change the status to the one that makes movements with open Physical count by location
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Done" exact value from "Status" drop-down list
			And I click the button named "FormPost"
			Then I wait that in user messages the 'There are "Physical count by location" documents that are not closed.' substring will appear in 30 seconds
		* Change the status to "In processing" and post the document
			And I select "In processing" exact value from "Status" drop-down list
			And I click the button named "FormPostAndClose"

# Scenario: _2990011 refilling Physical inventory based on Physical count by location list
# 	And I close all client application windows
# 	* Open Physical count by location list
# 		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
# 	* Filling in Phys. count  in the first Physical count by location and select status that make movements
# 		And I go to line in "List" table
# 			| 'Number' | 'Status'   | 'Store'    |
# 			| '1'      | 'Prepared' | 'Store 05' |
# 		And I select current line in "List" table
# 		And I activate "Phys. count" field in "ItemList" table
# 		And I input "124,000" text in "Phys. count" field of "ItemList" table
# 		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
# 		And I select "Done" exact value from "Status" drop-down list
# 		And I click "Save and close" button
# 		And Delay 2
# 	* Filling in Phys. count  in the second Physical count by location and select status that does not make movements
# 		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
# 		And I go to line in "List" table
# 			| 'Number' | 'Status'   | 'Store'    |
# 			| '2'      | 'Prepared' | 'Store 05' |
# 		And I select current line in "List" table
# 		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
# 		And I activate "Phys. count" field in "ItemList" table
# 		And I select current line in "ItemList" table
# 		And I input "197,000" text in "Phys. count" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I select "In processing" exact value from "Status" drop-down list
# 		And I click "Save and close" button
# 		And Delay 2
# 	* Filling in Phys. count  in the third Physical count by location and select status that make movements
# 		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
# 		And I go to line in "List" table
# 			| 'Number' | 'Status'   | 'Store'    |
# 			| '3'      | 'Prepared' | 'Store 05' |
# 		And I select current line in "List" table
# 		And I go to line in "ItemList" table
# 			| 'Item'  | 'Item key' | 'Unit' |
# 			| 'Dress' | 'M/White'  | 'pcs'  |
# 		And I activate "Phys. count" field in "ItemList" table
# 		And I input "10,000" text in "Phys. count" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I go to line in "ItemList" table
# 			| 'Item'  | 'Item key' | 'Unit' |
# 			| 'Shirt' | '36/Red'   | 'pcs'  |
# 		And I select current line in "ItemList" table
# 		And I input "7,000" text in "Phys. count" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I go to line in "ItemList" table
# 			| 'Item'  | 'Item key' | 'Unit' |
# 			| 'Boots' | '36/18SD'  | 'pcs'  |
# 		And I select current line in "ItemList" table
# 		And I input "4,000" text in "Phys. count" field of "ItemList" table
# 		And I finish line editing in "ItemList" table
# 		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
# 		And I select "Done" exact value from "Status" drop-down list
# 		And I click "Save and close" button
# 		And Delay 2
# 		And I close all client application windows
# 	* Filling in Physical inventory with the results of the first and third Physical count by location
# 		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
# 		And I go to line in "List" table
# 			| 'Number' |
# 			| '$$NumberPhysicalInventory2990010$$'      |
# 		And I select current line in "List" table
# 		And I click "Update phys. count" button
# 		And "ItemList" table contains lines
# 		| 'Phys. count' | 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Physical count' |
# 		| '10,000'      | 'Dress' | '2,000'      | 'M/White'  | '8,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
# 		| '7,000'       | 'Shirt' | ''           | '36/Red'   | '7,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
# 		| '4,000'       | 'Boots' | ''           | '36/18SD'  | '4,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
# 		| '124,000'     | 'Dress' | '-1,000'     | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date*'       |
# 		| ''            | 'Dress' | '-206,000'   | 'XS/Blue'  | '206,000'    | 'pcs'  | 'Arina Brown'        | '#2 date*'       |
# 		And I click "Save" button
# 	* Check that you cannot close the inventory without closed Physical count by location
# 		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
# 		And I select "Done" exact value from "Status" drop-down list
# 		And I click the button named "FormPost"
# 		Then I wait that in user messages the 'There are "Physical count by location" documents that are not closed.' substring will appear in 30 seconds
# 	* Check that Physical count by location are not created and their statuses do not change
# 		And I select "In processing" exact value from "Status" drop-down list
# 		And I click "Physical count by location" button
# 		And I move to "Physical count by location" tab
# 		And "PhysicalCountByLocationList" table contains lines
# 		| 'Reference'                     | 'Status'        |
# 		| 'Location count 1*' | 'Done'          |
# 		| 'Location count 2*' | 'In processing' |
# 		| 'Location count 3*' | 'Done'          |
# 		And I close all client application windows
# 	* Closing the second Physical count by location and refilling Physical inventory
# 		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
# 		And I go to line in "List" table
# 			| 'Number' |
# 			| '2'      |
# 		And I select current line in "List" table
# 		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
# 		And I select "Done" exact value from "Status" drop-down list
# 		And I click "Save and close" button
# 		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
# 		And I go to line in "List" table
# 			| 'Number' |
# 			| '$$NumberPhysicalInventory2990010$$'      |
# 		And I select current line in "List" table
# 		And I click "Update phys. count" button
# 		And "ItemList" table contains lines
# 		| 'Phys. count' | 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Physical count' |
# 		| '10,000'      | 'Dress' | '2,000'      | 'M/White'  | '8,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
# 		| '7,000'       | 'Shirt' | ''           | '36/Red'   | '7,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
# 		| '4,000'       | 'Boots' | ''           | '36/18SD'  | '4,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
# 		| '124,000'     | 'Dress' | '-1,000'     | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date:*'      |
# 		| '197,000'     | 'Dress' | '-9,000'     | 'XS/Blue'  | '206,000'    | 'pcs'  | 'Arina Brown'        | '#2 date:*'      |
# 		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
# 		And I select "Done" exact value from "Status" drop-down list
# 		And I click the button named "FormPost"
# 	* Check movements Physical inventory
# 		And I click "Registrations report" button
# 		And I select "Stock adjustment as surplus" exact value from "Register" drop-down list
# 		And I click "Generate report" button
# 		And "ResultTable" spreadsheet document contains lines:
# 		| '$$PhysicalInventory2990010$$'            | ''            | ''       | ''          | ''           | ''                             | ''         |
# 		| 'Document registrations records'          | ''            | ''       | ''          | ''           | ''                             | ''         |
# 		| 'Register  "Stock adjustment as surplus"' | ''            | ''       | ''          | ''           | ''                             | ''         |
# 		| ''                                        | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                             | ''         |
# 		| ''                                        | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'               | 'Item key' |
# 		| ''                                        | 'Receipt'     | '*'      | '2'         | 'Store 05'   | '$$PhysicalInventory2990010$$' | 'M/White'  |
# 		And I select "Stock reservation" exact value from "Register" drop-down list
# 		And I click "Generate report" button
# 		And "ResultTable" spreadsheet document contains lines:
# 		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''         | '' |
# 		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' |
# 		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' |
# 		| ''                              | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'M/White'  | '' |
# 		| ''                              | 'Expense'     | '*'      | '1'         | 'Store 05'   | 'S/Yellow' | '' |
# 		| ''                              | 'Expense'     | '*'      | '9'         | 'Store 05'   | 'XS/Blue'  | '' |
# 		And I select "Stock adjustment as write-off" exact value from "Register" drop-down list
# 		And I click "Generate report" button
# 		And "ResultTable" spreadsheet document contains lines:
# 		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                             | ''         |
# 		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                             | ''         |
# 		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'               | 'Item key' |
# 		| ''                                          | 'Receipt'     | '*'      | '1'         | 'Store 05'   | '$$PhysicalInventory2990010$$' | 'S/Yellow' |
# 		| ''                                          | 'Receipt'     | '*'      | '9'         | 'Store 05'   | '$$PhysicalInventory2990010$$' | 'XS/Blue'  |
# 		And I select "Stock balance" exact value from "Register" drop-down list
# 		And I click "Generate report" button
# 		And "ResultTable" spreadsheet document contains lines:
# 		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                             | ''         |
# 		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                             | ''         |
# 		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'                     | ''         |
# 		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'M/White'                      | ''         |
# 		| ''                                          | 'Expense'     | '*'      | '1'         | 'Store 05'   | 'S/Yellow'                     | ''         |
# 		| ''                                          | 'Expense'     | '*'      | '9'         | 'Store 05'   | 'XS/Blue'                      | ''         |
# 		And I close all client application windows

# Scenario: _2990012 check the opening of the status history in Physical inventory and Physical count by location
# 	And I close all client application windows
# 	* Check the opening of the status history in Physical inventory
# 		* Open test document
# 			Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
# 			And I go to line in "List" table
# 				| 'Number' |
# 				| '$$NumberPhysicalInventory2990010$$'      |
# 			And I select current line in "List" table
# 		* Open and check status history
# 			And I move to "Other" tab
# 			And I click "History" hyperlink
# 			And "List" table contains lines
# 			| 'Period' | 'Object'                | 'Status'        |
# 			| '*'      | '$$PhysicalInventory2990010$$' | 'Prepared'      |
# 			| '*'      | '$$PhysicalInventory2990010$$' | 'In processing' |
# 			| '*'      | '$$PhysicalInventory2990010$$' | 'Done'          |
# 			And I close all client application windows
# 	* Check the opening of the status history in Physical inventory
# 		* Open document
# 			Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
# 			And I go to line in "List" table
# 				| 'Number'  |
# 				| '3'       |
# 			And I select current line in "List" table
# 		* Open and check status history
# 			And I move to "Other" tab
# 			And I click "History" hyperlink
# 			And "List" table contains lines
# 			| 'Period' | 'Object'            | 'Status'        |
# 			| '*'      | 'Location count 3*' | 'Prepared'      |
# 			| '*'      | 'Location count 3*' | 'Done'          |
# 			And I close all client application windows
	
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
		And I set checkbox "Use responsible person by row"
		And I click "Fill exp. count" button
	* Check message output
		And I click "Physical count by location" button
		Then the form attribute named "Message" became equal to
		|'To run the "Physical count by location" command, you must save your work. Click OK to save and continue, or click Cancel to return.'|
	And I close all client application windows




Scenario: _999999 close TestClient session
	And I close TestClient session



#language: en
@tree
@Positive


Feature: product inventory

As a developer
I'd like to add functionality to write off shortages and recover surplus goods.
To work with the products


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario:_2990000 preparation
	* Create store that use Shipment confirmation and Goods receipt - Store 05
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Store 05" text in the field named "Description_en"
		And I input "Store 05 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseGoodsReceipt"
		And I set checkbox named "UseShipmentConfirmation"
		Then the form attribute named "Transit" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create store that use Shipment confirmation and Goods receipt - Store 06
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Store 06" text in the field named "Description_en"
		And I input "Store 06 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I remove checkbox named "UseGoodsReceipt"
		And I remove checkbox named "UseShipmentConfirmation"
		Then the form attribute named "Transit" became equal to "No"
		And I click the button named "FormWriteAndClose"
		And Delay 5
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
		* Change the document number
			And I move to "Other" tab
			And I input "8" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "8" text in "Number" field
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
			And I click "Post and close" button


Scenario: _2990001 filling in the status guide for PhysicalInventory and PhysicalCountByLocation
	* Open a creation form Object Statuses
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Assigning a name to a predefined element of PhysicalInventory
		And I expand a line in "List" table
			| 'Description'     |
			| 'Objects status history' |
		And I go to line in "List" table
			| Predefined data item name |
			| PhysicalInventory         |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Physical inventory" text in "ENG" field
		And I input "Physical inventory TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Add status "Prepared"
		And I go to line in "List" table
		| 'Description'              |
		| 'Physical inventory' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Prepared" text in "ENG" field
		And I input "Prepared TR" text in "TR" field
		And I click "Ok" button
		And I set checkbox "Set by default"
		And I click "Save and close" button
		And Delay 2
	* Add status "In processing"
		And I go to line in "List" table
		| 'Description'              |
		| 'Physical inventory' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "In processing" text in "ENG" field
		And I input "In processing TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
	* Add status "Done"
		And I go to line in "List" table
		| 'Description'              |
		| 'Physical inventory' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Done" text in "ENG" field
		And I input "Done TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
	* Assigning a name to a predefined element of PhysicalCountByLocation
		And I expand a line in "List" table
			| 'Description'     |
			| 'Objects status history' |
		And I go to line in "List" table
			| Predefined data item name |
			| PhysicalCountByLocation         |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Physical count by location" text in "ENG" field
		And I input "Physical count by location TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Add status "Prepared"
		And I go to line in "List" table
		| 'Description'              |
		| 'Physical count by location' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Prepared" text in "ENG" field
		And I input "Prepared TR" text in "TR" field
		And I click "Ok" button
		And I set checkbox "Set by default"
		And I click "Save and close" button
		And Delay 2
	* Add status "In processing"
		And I go to line in "List" table
		| 'Description'              |
		| 'Physical count by location' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "In processing" text in "ENG" field
		And I input "In processing TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
	* Add status "Done"
		And I go to line in "List" table
		| 'Description'              |
		| 'Physical count by location' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Done" text in "ENG" field
		And I input "Done TR" text in "TR" field
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
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click choice button of "Business unit" attribute in "ItemList" table
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
		| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'           | 'Unit' | 'Revenue type' | 'Basis document' |
		| 'Dress' | '8,000'    | 'M/White'  | 'Distribution department' | 'pcs'  | 'Delivery'     | ''               |
	* Change the document number
		And I move to "Other" tab
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
	* Post document
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as surplus 1*' | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records' | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'  | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'     | 'Company'                 | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'            | 'Main Company'            | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'     | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'            | 'Store 02'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Revenues turnovers"' | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''             | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                               | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                               | '*'           | ''          | 'Main Company' | 'Distribution department' | 'Delivery'     | 'M/White'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                               | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock balance"'      | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'     | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'            | 'Store 02'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		And I close all client application windows
	* Check movements after re-select store and company (store does not use Shipment confirmation and Goods receipt)
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
		And I click "Post" button
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as surplus 1*' | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records' | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'  | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'       | 'Company'                 | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'              | 'Second Company'          | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'       | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'              | 'Store 01'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Revenues turnovers"' | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Period'      | 'Resources' | 'Dimensions'     | ''                        | ''             | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                               | ''            | 'Amount'    | 'Company'        | 'Business unit'           | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                               | '*'           | ''          | 'Second Company' | 'Distribution department' | 'Delivery'     | 'M/White'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                               | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock balance"'      | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | ''            | ''          | 'Quantity'       | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                               | 'Receipt'     | '*'         | '8'              | 'Store 01'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
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
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "8,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click choice button of "Business unit" attribute in "ItemList" table
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
		| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'           | 'Unit' | 'Expense type' | 'Basis document' |
		| 'Dress' | '8,000'    | 'M/White'  | 'Distribution department' | 'pcs'  | 'Delivery'     | ''               |
	* Change the document number
		And I move to "Other" tab
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
	* Post document
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as write-off 1*' | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'   | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'    | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'     | 'Company'                 | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'            | 'Main Company'            | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Expenses turnovers"'   | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Period'      | 'Resources' | 'Dimensions'   | ''                        | ''             | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                 | ''            | 'Amount'    | 'Company'      | 'Business unit'           | 'Expense type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                 | '*'           | ''          | 'Main Company' | 'Distribution department' | 'Delivery'     | 'M/White'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                                 | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock reservation"'    | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'     | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'            | 'Store 02'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock balance"'        | ''            | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'     | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'            | 'Store 02'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		And I close all client application windows
	* Check movements after re-select store and company (store does not use Shipment confirmation and Goods receipt)
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
		And I click "Post" button
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as write-off 1*' | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'   | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'    | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'       | 'Company'                 | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'              | 'Second Company'          | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Expenses turnovers"'   | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Period'      | 'Resources' | 'Dimensions'     | ''                        | ''             | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                 | ''            | 'Amount'    | 'Company'        | 'Business unit'           | 'Expense type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                 | '*'           | ''          | 'Second Company' | 'Distribution department' | 'Delivery'     | 'M/White'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                                 | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock reservation"'    | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'       | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'              | 'Store 01'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock balance"'        | ''            | ''          | ''               | ''                        | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Record type' | 'Period'    | 'Resources'      | 'Dimensions'              | ''             | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | ''            | ''          | 'Quantity'       | 'Store'                   | 'Item key'     | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                 | 'Expense'     | '*'         | '8'              | 'Store 01'                | 'M/White'      | ''         | ''         | ''                    | ''                       | ''                     |
		And I close all client application windows

Scenario: _2990004 create Physical inventory (store use GR and SC)
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
	* Change the document number
		And I move to "Other" tab
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
	* Posting the document Physical inventory
		And I click "Post" button
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Physical inventory 1*'                     | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Document registrations records'            | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as surplus"'   | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'Physical inventory 1*' | 'S/Yellow' |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock reservation"'             | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 05'   | 'XS/Blue'               | ''         |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'Physical inventory 1*' | 'XS/Blue'  |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 05'   | 'XS/Blue'               | ''         |
		And I close all client application windows
	* Clear movements Physical Inventory and check movements
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'  |
			| '1'       |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Physical inventory 1*' |
		| 'Document registrations records'                |
		And I close all client application windows
	* Re-post Physical Inventory and check movements
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'  |
			| '1'       |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Physical inventory 1*'                     | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Document registrations records'            | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as surplus"'   | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'Physical inventory 1*' | 'S/Yellow' |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock reservation"'             | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 05'   | 'XS/Blue'               | ''         |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'Physical inventory 1*' | 'XS/Blue'  |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 05'   | 'XS/Blue'               | ''         |
		And I close all client application windows


Scenario: _2990004 create Physical inventory (store doesn't use GR and SC)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
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
	* Change the document number
		And I move to "Other" tab
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	* Posting the document Physical inventory
		And I click "Post" button
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Physical inventory 2*'                     | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Document registrations records'            | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Register  "Stock adjustment as surplus"'   | ''            | ''       | ''          | ''           | ''                      | ''          |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key'  |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 06'   | 'Physical inventory 2*' | '36/Yellow' |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Register  "Stock reservation"'             | ''            | ''       | ''          | ''           | ''                      | ''          |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''          |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 06'   | '36/Yellow'             | ''          |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 06'   | 'XS/Blue'               | ''          |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                      | ''          |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key'  |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 06'   | 'Physical inventory 2*' | 'XS/Blue'   |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''          |
		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                      | ''          |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''          |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 06'   | '36/Yellow'             | ''          |
		| ''                                          | 'Expense'     | '*'      | '2'         | 'Store 06'   | 'XS/Blue'               | ''          |
		And I close all client application windows

Scenario: _2990005 create Stock adjustment as surplus based on Physical inventory
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '1'    |
	* Create a document StockAdjustmentAsSurplus and check filling in
		And I click the button named "FormDocumentStockAdjustmentAsSurplusGenerateStockAdjustmentAsSurplus"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Business unit" attribute in "ItemList" table
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
	* Check filling in
		And "ItemList" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'        | 'Unit' | 'Revenue type' | 'Basis document'        |
		| 'Dress' | '5,000'    | 'S/Yellow' | 'Logistics department' | 'pcs'  | 'Delivery'     | 'Physical inventory 1*' |
		Then the number of "ItemList" table lines is "меньше или равно" 1
	* Change the document number
		And I move to "Other" tab
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "Stock adjustment as surplus (create) *" window is opened
		And I input "2" text in "Number" field
	* Posting the document and check movements
		And I click "Post" button
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as surplus 2*'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock adjustment as surplus"' | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | 'Quantity'     | 'Store'                | 'Basis document'        | 'Item key' | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Expense'     | '*'         | '5'            | 'Store 05'             | 'Physical inventory 1*' | 'S/Yellow' | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'           | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | 'Quantity'     | 'Company'              | 'Item key'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Receipt'     | '*'         | '5'            | 'Main Company'         | 'S/Yellow'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Revenues turnovers"'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Period'      | 'Resources' | 'Dimensions'   | ''                     | ''                      | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                        | ''            | 'Amount'    | 'Company'      | 'Business unit'        | 'Revenue type'          | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                        | '*'           | ''          | 'Main Company' | 'Logistics department' | 'Delivery'              | 'S/Yellow' | ''         | ''                    | ''                       | 'No'                   |
		And I close all client application windows
	* Clear movements Stock adjustment as surplus and check movements
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '2'       |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as surplus 2*'          |
		| 'Document registrations records'                |
		And I close all client application windows
	* Re-post Physical Inventory and check movements
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I go to line in "List" table
			| 'Number'  |
			| '2'       |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as surplus 2*'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock adjustment as surplus"' | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | 'Quantity'     | 'Store'                | 'Basis document'        | 'Item key' | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Expense'     | '*'         | '5'            | 'Store 05'             | 'Physical inventory 1*' | 'S/Yellow' | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'           | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | 'Quantity'     | 'Company'              | 'Item key'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Receipt'     | '*'         | '5'            | 'Main Company'         | 'S/Yellow'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Revenues turnovers"'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                        | 'Period'      | 'Resources' | 'Dimensions'   | ''                     | ''                      | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                        | ''            | 'Amount'    | 'Company'      | 'Business unit'        | 'Revenue type'          | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                        | '*'           | ''          | 'Main Company' | 'Logistics department' | 'Delivery'              | 'S/Yellow' | ''         | ''                    | ''                       | 'No'                   |
		And I close all client application windows
	

Scenario: _2990007 create Stock adjustment as write off based on Physical inventory
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '1'    |
	* Create a document StockAdjustmentAsWriteOff and check filling in
		And I click the button named "FormDocumentStockAdjustmentAsWriteOffGenerateStockAdjustmentAsWriteOff"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Business unit" attribute in "ItemList" table
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
	* Check filling in
		And "ItemList" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'        | 'Unit' | 'Expense type' | 'Basis document'        |
		| 'Dress' | '2,000'    | 'XS/Blue'  | 'Logistics department' | 'pcs'  | 'Delivery'     | 'Physical inventory 1*' |
		Then the number of "ItemList" table lines is "меньше или равно" 1
	* Change the document number
		And I move to "Other" tab
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	* Posting the document and check movements
		And I click "Post" button
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as write-off 2*'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'            | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'             | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | 'Quantity'     | 'Company'              | 'Item key'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Expense'     | '*'         | '2'            | 'Main Company'         | 'XS/Blue'               | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Expenses turnovers"'            | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Period'      | 'Resources' | 'Dimensions'   | ''                     | ''                      | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                          | ''            | 'Amount'    | 'Company'      | 'Business unit'        | 'Expense type'          | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                          | '*'           | ''          | 'Main Company' | 'Logistics department' | 'Delivery'              | 'XS/Blue'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                                          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | 'Quantity'     | 'Store'                | 'Basis document'        | 'Item key' | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Expense'     | '*'         | '2'            | 'Store 05'             | 'Physical inventory 1*' | 'XS/Blue'  | ''         | ''                    | ''                       | ''                     |
		And I close all client application windows
	* Clear movements Stock adjustment as write-off and check movements
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'  |
			| '2'       |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as write-off 2*'          |
		| 'Document registrations records'                |
		And I close all client application windows
	* Re-post Physical Inventory and check movements
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I go to line in "List" table
			| 'Number'  |
			| '2'       |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Stock adjustment as write-off 2*'          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Document registrations records'            | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Inventory balance"'             | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | 'Quantity'     | 'Company'              | 'Item key'              | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Expense'     | '*'         | '2'            | 'Main Company'         | 'XS/Blue'               | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Expenses turnovers"'            | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Period'      | 'Resources' | 'Dimensions'   | ''                     | ''                      | ''         | ''         | ''                    | ''                       | 'Attributes'           |
		| ''                                          | ''            | 'Amount'    | 'Company'      | 'Business unit'        | 'Expense type'          | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                          | '*'           | ''          | 'Main Company' | 'Logistics department' | 'Delivery'              | 'XS/Blue'  | ''         | ''                    | ''                       | 'No'                   |
		| ''                                          | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''          | ''             | ''                     | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Record type' | 'Period'    | 'Resources'    | 'Dimensions'           | ''                      | ''         | ''         | ''                    | ''                       | ''                     |
		| ''                                          | ''            | ''          | 'Quantity'     | 'Store'                | 'Basis document'        | 'Item key' | ''         | ''                    | ''                       | ''                     |
		| ''                                          | 'Expense'     | '*'         | '2'            | 'Store 05'             | 'Physical inventory 1*' | 'XS/Blue'  | ''         | ''                    | ''                       | ''                     |
		And I close all client application windows

Scenario: _2990008 create Stock adjustment as surplus and Stock adjustment as write off based on Physical inventory on a partial quantity
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '2'    |
	* Create a document StockAdjustmentAsWriteOff on a partial quantity
		And I click the button named "FormDocumentStockAdjustmentAsWriteOffGenerateStockAdjustmentAsWriteOff"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Business unit" attribute in "ItemList" table
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
		And I click "Post and close" button
	* Create a document StockAdjustmentAsWriteOff for the remaining quantity and check filling in
		And I click the button named "FormDocumentStockAdjustmentAsWriteOffGenerateStockAdjustmentAsWriteOff"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Business unit" attribute in "ItemList" table
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
			| 'Item'  | 'Quantity' | 'Item key' | 'Business unit'        | 'Unit' | 'Expense type' | 'Basis document'        |
			| 'Dress' | '1,000'    | 'XS/Blue'  | 'Logistics department' | 'pcs'  | 'Delivery'     | 'Physical inventory 2*' |
		Then the number of "ItemList" table lines is "меньше или равно" 1
		And I click "Post and close" button
	* Create a document StockAdjustmentAsSurplus on a partial quantity
		And I click the button named "FormDocumentStockAdjustmentAsSurplusGenerateStockAdjustmentAsSurplus"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Business unit" attribute in "ItemList" table
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
		And I click "Post and close" button
	* Create a document StockAdjustmentAsSurplus for the remaining quantity and check filling in
		And I click the button named "FormDocumentStockAdjustmentAsSurplusGenerateStockAdjustmentAsSurplus"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click choice button of "Business unit" attribute in "ItemList" table
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
			| 'Item'     | 'Quantity' | 'Item key'   | 'Business unit'        | 'Unit' | 'Revenue type' | 'Basis document'        |
			| 'Trousers' | '4,000'    | '36/Yellow'  | 'Logistics department' | 'pcs'  | 'Delivery'     | 'Physical inventory 2*' |
		Then the number of "ItemList" table lines is "меньше или равно" 1
		And I click "Post and close" button

Scenario: _2990009 check for updates Update Exp Count
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
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
		And I click the button named "Add"
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
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
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
		And I click "Post" button
	* Create Physical count by locatio
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
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item key' |
					| 'M/White'  |
				And I select current line in "List" table
				And I input "8,000" text in "Quantity" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I click choice button of "Business unit" attribute in "ItemList" table
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
				And I select current line in "List" table
				And I activate "Item key" field in "ItemList" table
				And I click choice button of "Item key" attribute in "ItemList" table
				And I go to line in "List" table
					| 'Item key' |
					| 'XS/Blue'|
				And I select current line in "List" table
				And I input "8,000" text in "Quantity" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I click choice button of "Business unit" attribute in "ItemList" table
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
				And I click choice button of "Business unit" attribute in "ItemList" table
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
				And I click choice button of "Business unit" attribute in "ItemList" table
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
				And I click "Post and close" button
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
		* Add items
			And I click the button named "Add"
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
			And I click "Post and close" button
		And I close all client application windows
	* Updating the quantity in the inventory document with Physical count by location created
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
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
			And I click "Post" button
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
			And I click "Post" button
			Then I wait that in user messages the "Not yet all Physical count by location is closed" substring will appear in 30 seconds
		* Change the status to "In processing" and post the document
			And I select "In processing" exact value from "Status" drop-down list
			And I click "Post and close" button

Scenario: _2990011 re-filling Physical inventory based on Physical count by location list
	* Open Physical count by location list
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
	* Filling in Phys. count  in the first Physical count by location and select status that make movements
		And I go to line in "List" table
			| 'Number' | 'Status'   | 'Store'    |
			| '1'      | 'Prepared' | 'Store 05' |
		And I select current line in "List" table
		And I activate "Phys. count" field in "ItemList" table
		And I input "124,000" text in "Phys. count" field of "ItemList" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Done" exact value from "Status" drop-down list
		And I click "Save and close" button
		And Delay 2
	* Filling in Phys. count  in the second Physical count by location and select status that does not make movements
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I go to line in "List" table
			| 'Number' | 'Status'   | 'Store'    |
			| '2'      | 'Prepared' | 'Store 05' |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I activate "Phys. count" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "197,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I select "In processing" exact value from "Status" drop-down list
		And I click "Save and close" button
		And Delay 2
	* Filling in Phys. count  in the third Physical count by location and select status that make movements
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I go to line in "List" table
			| 'Number' | 'Status'   | 'Store'    |
			| '3'      | 'Prepared' | 'Store 05' |
		And I select current line in "List" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'M/White'  | 'pcs'  |
		And I activate "Phys. count" field in "ItemList" table
		And I input "10,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Shirt' | '36/Red'   | 'pcs'  |
		And I select current line in "ItemList" table
		And I input "7,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '36/18SD'  | 'pcs'  |
		And I select current line in "ItemList" table
		And I input "4,000" text in "Phys. count" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Done" exact value from "Status" drop-down list
		And I click "Save and close" button
		And Delay 2
		And I close all client application windows
	* Filling in Physical inventory with the results of the first and third Physical count by location
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And I select current line in "List" table
		And I click "Update phys. count" button
		And "ItemList" table contains lines
		| 'Phys. count' | 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Physical count' |
		| '10,000'      | 'Dress' | '2,000'      | 'M/White'  | '8,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
		| '7,000'       | 'Shirt' | ''           | '36/Red'   | '7,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
		| '4,000'       | 'Boots' | ''           | '36/18SD'  | '4,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date*'       |
		| '124,000'     | 'Dress' | '-1,000'     | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date*'       |
		| ''            | 'Dress' | '-202,000'   | 'XS/Blue'  | '202,000'    | 'pcs'  | 'Arina Brown'        | '#2 date*'       |
		And I click "Save" button
	* Check that you cannot close the inventory without closed Physical count by location
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Done" exact value from "Status" drop-down list
		And I click "Post" button
		Then I wait that in user messages the "Not yet all Physical count by location is closed" substring will appear in 30 seconds
	* Check that Physical count by location are not created and their statuses do not change
		And I select "In processing" exact value from "Status" drop-down list
		And I click "Physical count by location" button
		And I move to "Physical count by location" tab
		And "PhysicalCountByLocationList" table contains lines
		| 'Reference'                     | 'Status'        |
		| 'Physical count by location 1*' | 'Done'          |
		| 'Physical count by location 2*' | 'In processing' |
		| 'Physical count by location 3*' | 'Done'          |
		And I close all client application windows
	* Closing the second Physical count by location and refilling Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Done" exact value from "Status" drop-down list
		And I click "Save and close" button
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And I select current line in "List" table
		And I click "Update phys. count" button
		And "ItemList" table contains lines
		| 'Phys. count' | 'Item'  | 'Difference' | 'Item key' | 'Exp. count' | 'Unit' | 'Responsible person' | 'Physical count' |
		| '10,000'      | 'Dress' | '2,000'      | 'M/White'  | '8,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
		| '7,000'       | 'Shirt' | ''           | '36/Red'   | '7,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
		| '4,000'       | 'Boots' | ''           | '36/18SD'  | '4,000'      | 'pcs'  | 'Anna Petrova'       | '#3 date:*'      |
		| '124,000'     | 'Dress' | '-1,000'     | 'S/Yellow' | '125,000'    | 'pcs'  | 'Anna Petrova'       | '#1 date:*'      |
		| '197,000'     | 'Dress' | '-5,000'     | 'XS/Blue'  | '202,000'    | 'pcs'  | 'Arina Brown'        | '#2 date:*'      |
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Done" exact value from "Status" drop-down list
		And I click "Post" button
	* Check movements Physical inventory
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Physical inventory 3*'                     | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Document registrations records'            | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as surplus"'   | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'Physical inventory 3*' | 'M/White'  |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock reservation"'             | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'M/White'               | ''         |
		| ''                                          | 'Expense'     | '*'      | '1'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '5'         | 'Store 05'   | 'XS/Blue'               | ''         |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock adjustment as write-off"' | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Basis document'        | 'Item key' |
		| ''                                          | 'Receipt'     | '*'      | '1'         | 'Store 05'   | 'Physical inventory 3*' | 'S/Yellow' |
		| ''                                          | 'Receipt'     | '*'      | '5'         | 'Store 05'   | 'Physical inventory 3*' | 'XS/Blue'  |
		| ''                                          | ''            | ''       | ''          | ''           | ''                      | ''         |
		| 'Register  "Stock balance"'                 | ''            | ''       | ''          | ''           | ''                      | ''         |
		| ''                                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''         |
		| ''                                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'              | ''         |
		| ''                                          | 'Receipt'     | '*'      | '2'         | 'Store 05'   | 'M/White'               | ''         |
		| ''                                          | 'Expense'     | '*'      | '1'         | 'Store 05'   | 'S/Yellow'              | ''         |
		| ''                                          | 'Expense'     | '*'      | '5'         | 'Store 05'   | 'XS/Blue'               | ''         |
		And I close all client application windows

Scenario: _2990012 check the opening of the status history in Physical inventory and Physical count by location
	* Check the opening of the status history in Physical inventory
		* Open test document
			Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
			And I go to line in "List" table
				| 'Number'  |
				| '3'       |
			And I select current line in "List" table
		* Open and check status history
			And I move to "Other" tab
			And I click "History" hyperlink
			And "List" table contains lines
			| 'Period' | 'Object'                | 'Status'        |
			| '*'      | 'Physical inventory 3*' | 'Prepared'      |
			| '*'      | 'Physical inventory 3*' | 'In processing' |
			| '*'      | 'Physical inventory 3*' | 'Done'          |
			And I close all client application windows
	* Check the opening of the status history in Physical inventory
		* Open document
			Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
			And I go to line in "List" table
				| 'Number'  |
				| '3'       |
			And I select current line in "List" table
		* Open and check status history
			And I move to "Other" tab
			And I click "History" hyperlink
			And "List" table contains lines
			| 'Period' | 'Object'                        | 'Status'        |
			| '*'      | 'Physical count by location 3*' | 'Prepared'      |
			| '*'      | 'Physical count by location 3*' | 'Done'          |
			And I close all client application windows
	
Scenario: _2990013 check the question of saving Physical inventory before creating Physical count by location
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Filling out a document with stock balances
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click "Fill exp. count" button
	* Check message output
		And I click "Physical count by location" button
		Then the form attribute named "Message" became equal to
		|'To run the "Physical count by location" command, you must save your work. Click OK to save and continue, or click Cancel to return.'|
	And I close all client application windows








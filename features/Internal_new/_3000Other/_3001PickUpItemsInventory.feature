#language: en
@tree
@Positive
@Group18

Feature: check form of selection of item in store documents



Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _3001001 check the form of selection of items in the document StockAdjustmentAsWriteOff
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
			| 'Store 05'      |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	And I close all client application windows


Scenario: _3001002 check the form of selection of items in the document StockAdjustmentAsSurplus
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
	* Check the form of selection items
		When check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	And I close all client application windows

Scenario: 3001003 check the form of selection of items in the document PhysicalInventory
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'      |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in PhysicalInventory
	And I close all client application windows

Scenario: 3001004 check the form of selection of items in the document PhysicalCountByLocation
	* Open document form
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
	* Filling the document header
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'      |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in PhysicalInventory
	And I close all client application windows



Scenario: 3001005 check the form Pick Up items Inventory Transfer Order
	* Open form to create Inventory Transfer Order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling the document header Inventory Transfer Order
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 06'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in InventoryTransferOrder/InventoryTransfer
	And I close all client application windows


Scenario: 3001006 check the form Pick Up items Inventory Transfer
	* Open form to create Inventory Transfer Order
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Filling the document header Inventory Transfer
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 06'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in InventoryTransferOrder/InventoryTransfer
	And I close all client application windows

Scenario: 3001007 check the form Pick Up items Internal supply request
	* Open form to create Internal supply request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
	* Filling the document header Internal supply request
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 05'    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Check the form of selection items
		When check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	And I close all client application windows

#language: en
@tree
@Positive
@Catalogs

Feature: filling in Object statuses catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one



Scenario: _005039 filling in the status catalog for Inventory transfer order
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element InventoryTransferOrder
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data item name |
			| InventoryTransferOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Inventory transfer order" text in the field named "Description_en"
		And I input "Inventory transfer order TR" text in the field named "Description_tr"
		And I input "Заказ на перемещение товаров" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Inventory transfer order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I input "На согласовании" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Inventory transfer order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	

Scenario: _005040 filling in the status catalog for Outgoing Payment Order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element OutgoingPaymentOrder
			And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data item name |
			| OutgoingPaymentOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Outgoing payment order" text in the field named "Description_en"
		And I input "Outgoing payment order TR" text in the field named "Description_tr"
		And I input "Заявка на расходование денежных средств" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Outgoing payment order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Outgoing payment order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button

Scenario: _005041 filling in the status catalog for Purchase return order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  PurchaseReturnOrder
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data item name |
			| PurchaseReturnOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Purchase return order" text in the field named "Description_en"
		And I input "Purchase return order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button


Scenario: _005042 filling in the status catalog for Purchase order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element PurchaseOrder
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data item name |
			| PurchaseOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Purchase order" text in the field named "Description_en"
		And I input "Purchase order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Purchase order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button

Scenario: _005043 filling in the status catalog for Sales return order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  SalesReturnOrder
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data item name |
			| SalesReturnOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Sales return order" text in the field named "Description_en"
		And I input "Sales return order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales return order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button

Scenario: _005044 filling in the status catalog for Sales order
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
	* Filling the name for the predefined element  SalesOrder
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
		And I go to line in "List" table
			| Predefined data item name |
			| SalesOrder                |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Sales order" text in the field named "Description_en"
		And I input "Sales order TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Wait"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales order' |
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Wait" text in the field named "Description_en"
		And I input "Wait TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	* Adding status "Approved"
		And I go to line in "List" table
		| 'Description'              |
		| 'Sales order' |
		And I click the button named "FormCreate"
		And I set checkbox "Posting"
		And I set checkbox "Set by default"
		And I click Open button of the field named "Description_en"
		And I input "Approved" text in the field named "Description_en"
		And I input "Approved TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
	And I close all client application windows

Scenario: _005045 check for clearing the UniqueID field when copying the status
	* Opening a form for creating Objects status historyes
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I go to line in "List" table
			| 'Code'    |
			| 'Objects statuses'|
		And I expand current line in "List" table
	* Copy status
		And I expand a line in "List" table
			| 'Description' | 'Predefined data item name' |
			| 'Sales order' | 'SalesOrder'                |
		And I go to line in "List" table
			| 'Description' |
			| 'Wait'        |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check UniqueID field deleting
		Then the form attribute named "UniqueID" became equal to ""
		Then the form attribute named "Description_en" became equal to "Wait"
	And I close all client application windows
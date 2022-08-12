#language: en
@tree
@Positive
@SettingsCatalogs

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
			| Predefined data name |
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
			| Predefined data name |
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
			| Predefined data name |
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
			| Predefined data name |
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
			| Predefined data name |
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
			| Predefined data name |
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
			| 'Description' | 'Predefined data name' |
			| 'Sales order' | 'SalesOrder'                |
		And I go to line in "List" table
			| 'Description' |
			| 'Wait'        |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check UniqueID field deleting
		Then the form attribute named "UniqueID" became equal to ""
		Then the form attribute named "Description_en" became equal to "Wait"
	And I close all client application windows


Scenario: _005046 create statuses for Cheque bond
	* Opening of the catalog Objects status historyes and renaming of predefined elements for Cheque bond
		Given I open hyperlink "e1cib/list/Catalog.ObjectStatuses"
		And I expand current line in "List" table
		And I expand a line in "List" table
			| 'Predefined data name' |
			| 'ChequeBondTransaction'     |
		And I go to line in "List" table
			| 'Predefined data name' |
			| 'ChequeBondIncoming'     |
		And I activate "Predefined data name" field in "List" table
		And in the table "List" I click the button named "ListContextMenuChange"
		And I input "ChequeBondIncoming" text in the field named "Description_en"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Predefined data name' |
			| 'ChequeBondOutgoing'     |
		And I activate "Predefined data name" field in "List" table
		And in the table "List" I click the button named "ListContextMenuChange"
		And I input "ChequeBondOutgoing" text in the field named "Description_en"
		And I click "Save and close" button
	* Create statuses for Cheque bond incoming
		* Create status Taken from partner
			And I go to line in "List" table
			| 'Description'        |
			| 'ChequeBondIncoming' |
			And I click the button named "FormCreate"
			And I input "01. TakenFromPartner" text in the field named "Description_en"
			And I set checkbox "Set by default"
			And I move to the tab named "GroupPosting"
			And I change "Cheque bond balance" radio button value to "Posting"
			And I change "Customer transactions" radio button value to "Posting"
			And I change "Cash planning" radio button value to "Posting"
			And I click "Save and close" button
		* Create status Payment received
			And I go to line in "List" table
			| 'Description'        |
			| 'ChequeBondIncoming' |
			And I click the button named "FormCreate"
			And I input "03. PaymentReceived" text in the field named "Description_en"
			And I move to the tab named "GroupPosting"
			And I click "Save and close" button
		* Create status Protested
			And I go to line in "List" table
			| 'Description'        |
			| 'ChequeBondIncoming' |
			And I click the button named "FormCreate"
			And I input "04. Protested" text in the field named "Description_en"
			And I move to the tab named "GroupPosting"
			And I change "Cheque bond balance" radio button value to "Reversal"
			And I change "Customer transactions" radio button value to "Reversal"
			And I change "Cash planning" radio button value to "Correction"
			And I click "Save and close" button
		* Create status Give to bank as assurance
			And I go to line in "List" table
			| 'Description'        |
			| 'ChequeBondIncoming' |
			And I click the button named "FormCreate"
			And I input "02. GiveToBankAsAssurance" text in the field named "Description_en"
			And I click "Save and close" button
	* Create statuses for Cheque bond outgoing
		* Create status Given to partner
			And I go to line in "List" table
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			And I click the button named "FormCreate"
			And I input "01. GivenToPartner" text in the field named "Description_en"
			And I set checkbox "Set by default"
			And I move to the tab named "GroupPosting"
			And I change "Cheque bond balance" radio button value to "Posting"
			And I change "Cash planning" radio button value to "Posting"
			And I click "Save and close" button
		* Create status Payed
			And I go to line in "List" table
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			And I click the button named "FormCreate"
			And I input "02. Payed" text in the field named "Description_en"
			And I move to the tab named "GroupPosting"
			And I change "Vendor transactions" radio button value to "Posting"
			And I click "Save and close" button
		* Create status Protested
			And I go to line in "List" table
				| 'Description'        |
				| 'ChequeBondOutgoing' |
			And I click the button named "FormCreate"
			And I input "03. Protested" text in the field named "Description_en"
			And I move to the tab named "GroupPosting"
			And I change "Cheque bond balance" radio button value to "Reversal"
			And I change "Customer transactions" radio button value to "Reversal"
			And I change "Cash planning" radio button value to "Reversal"
			And I click "Save and close" button
	* Setting the order of statuses for incoming cheques
		And I go to line in "List" table
			| 'Description'          |
			| '01. TakenFromPartner' |
		And I select current line in "List" table
		And in the table "NextPossibleStatuses" I click the button named "NextPossibleStatusesAdd"
		And Delay 2
		And I go to line in "List" table
			| 'Description'               |
			| '02. GiveToBankAsAssurance' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And in the table "NextPossibleStatuses" I click the button named "NextPossibleStatusesAdd"
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And in the table "NextPossibleStatuses" I click the button named "NextPossibleStatusesAdd"
		And I go to line in "List" table
			| 'Description'   |
			| '04. Protested' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And I click "Save and close" button
		And I wait "01. TakenFromPartner (Order status) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Description'               |
			| '02. GiveToBankAsAssurance' |
		And I select current line in "List" table
		And in the table "NextPossibleStatuses" I click "Add" button
		And I go to line in "List" table
			| 'Description'         |
			| '03. PaymentReceived' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And in the table "NextPossibleStatuses" I click "Add" button
		And I go to line in "List" table
			| 'Description'   |
			| '04. Protested' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And I click "Save and close" button
	* Setting the order of statuses for outgoing cheques
		And I go to line in "List" table
			| 'Description'          |
			| '01. GivenToPartner' |
		And I select current line in "List" table
		And in the table "NextPossibleStatuses" I click the button named "NextPossibleStatusesAdd"
		And Delay 2
		And I go to line in "List" table
			| 'Description'               |
			| '02. Payed' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And in the table "NextPossibleStatuses" I click "Add" button
		And I go to line in "List" table
			| 'Description'   |
			| '03. Protested' |
		And I select current line in "List" table
		And I finish line editing in "NextPossibleStatuses" table
		And I click "Save and close" button
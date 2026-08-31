#language: en
@tree
@Positive
@FunctionalOptions

Feature: general FO


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _900100 preparation (general FO)
	When set True value to the constant

Scenario: _900105 check FO use store
	And I close all client application windows
	* Switch-off FO Use store
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I remove checkbox "Use stores"
		And I remove checkbox "Use shipment confirmation and goods receipts"
		And I click "Save" button
		And I close "Functional option settings" window
	* Check
		* Subsystem Inventory
			When I Check the steps for Exception
				| 'And In the command interface I select "Inventory" "Stores"'     |			
		* Attribute isAdditionalİtemCost in PI
			And in functions panel I select "Items"		
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click "Create" button	
			And in the table "ItemList" I click "Add" button
			And I activate "Item" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Service 1" from "Item" drop-down list by string in "ItemList" table
			And I finish line editing in "ItemList" table
			When I Check the steps for Exception
				| 'And I activate "Other period expense type" field in "ItemList" table'     |
			And I close all client application windows
	
								
Scenario: _900106 check FO use shipment confirmation and goods receipts
	And I close all client application windows
	* Shipment statuses in PI/SI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		When I Check the steps for Exception
			| 'And I activate "Status" field in "List" table'     |		
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		When I Check the steps for Exception
			| 'And I activate "Status" field in "List" table'     |	


// Scenario: _900107 check FO use serial lot number
// 	And I close all client application windows
// 	* Switch-off FO Use store
// 		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
// 		And I go to line in "FunctionalOptions" table
// 			| 'Option'                 |
// 			| 'Use serial lot numbers' |
// 		And I remove "Use" checkbox in "FunctionalOptions" table
// 		And I click "Save" button
// 		And I close "Functional option settings" window	
// 	* Check
// 		* DataProcessor.CreateSerialLotNumbers
// 			When I Check the steps for Exception
// 				| 'And In the command interface I select "Master data" "Create serial lot numbers"'     |
			
			
						
Scenario: _900107 check FO use cheque bonds
	And I close all client application windows
	* Switch-off FO use cheque bonds
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I remove checkbox "  -  Use cheque bonds"	
		And I click "Save" button
		And I close "Functional option settings" window	
	* Check
		* Document Cheque bond transaction
			When I Check the steps for Exception
				| 'And In the command interface I select "Treasure" "Cheque bond transaction"'     |
		* Transaction type BP/BR
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I click "Create" button	
			When I Check the steps for Exception
				| 'And I select "Payment by cheque" exact value from "Transaction type" drop-down list'     |
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			And I click "Create" button	
			When I Check the steps for Exception
				| 'And I select "Receipt by cheque" exact value from "Transaction type" drop-down list'     |
	And I close all client application windows	
			
						
Scenario: _900108 check FO use item key
	And I close all client application windows
	* Switch-off FO use item key
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I remove checkbox "Use item key"
		And I click "Save" button
		And I close "Functional option settings" window	
	* Check
		* MasterData
			When I Check the steps for Exception
				| 'And In the command interface I select "MasterData" "Item key"'     |
	And I close all client application windows


Scenario: _900109 check FO use Legal Name (check in SI,PI)
	And I close all client application windows
	* Switch-off FO use Legal Name
		Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"
		And I remove checkbox "Use legal name"
		And I click "Save" button
		And I close "Functional option settings" window	
	* Check
		* MasterData
			When I Check the steps for Exception
				| 'And In the command interface I select "MasterData" "Legal name"'     |
		* Check in SI 
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I click the button named "FormCreate"
			And I click Choice button of the field named "Partner"
			And I go to line in "List" table
				| 'Description' |
				| 'Customer 1'  |
			And I click the button named "FormChoose"
			Then the field named "DecorationGroupTitleCollapsedLabel" value does not contain "Legal name" text
		* Check in PI 
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
			And I click Choice button of the field named "Partner"
			And I go to line in "List" table
				| 'Description' |
				| 'Vendor and customer' |
			And I click the button named "FormChoose"
			Then the field named "DecorationGroupTitleCollapsedLabel" value does not contain "Legal name" text
	And I close all client application windows						
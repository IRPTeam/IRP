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
		And I go to line in "FunctionalOptions" table
			| 'Option'     |
			| 'Use stores' |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I go to line in "FunctionalOptions" table
			| 'Option'                                       |
			| 'Use shipment confirmation and goods receipts' |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I finish line editing in "FunctionalOptions" table
		And I click "Save" button
		And I close "Functional option settings" window
	* Check
		* Subsystem Inventory
			When I Check the steps for Exception
				| 'When in sections panel I select "Inventory"'     |
		* Attribute isAdditionalİtemCost in PI
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click "Create" button	
			And in the table "ItemList" I click "Add" button
			And I activate "Item" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Service 1" from "Item" drop-down list by string in "ItemList" table
			And I finish line editing in "ItemList" table
			When I Check the steps for Exception
				| 'And I activate "Is additional item cost" field in "ItemList" table'     |
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
		And I go to line in "FunctionalOptions" table
			| 'Option'           |
			| 'Use cheque bonds' |
		And I remove "Use" checkbox in "FunctionalOptions" table
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
		And I go to line in "FunctionalOptions" table
			| 'Option'       |
			| 'Use item key' |
		And I remove "Use" checkbox in "FunctionalOptions" table
		And I click "Save" button
		And I close "Functional option settings" window	
	* Check
		* MasterData
			When I Check the steps for Exception
				| 'And In the command interface I select "MasterData" "Item key"'     |
	And I close all client application windows
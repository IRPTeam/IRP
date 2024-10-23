#language: en
@tree
@Positive
@FunctionalOptions

Feature: transaction types


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _900100 preparation (transaction types)
	When set True value to the constant
	When set True value to the constant Use retail orders

Scenario: _900102 check transaction types in the SO and SI (FO Use retail orders)
	And I close all client application windows
	* SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"	
		And I click "Create" button
		And I click Select button of "Transaction type" field
		And drop-down list named "TransactionType" is equal to:
			| Sales           |
			| Retail sales    |
		And I close all client application windows
	*SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click Select button of "Transaction type" field'    |
		And I close all client application windows
		
Scenario: _900103 check transaction types in the SO and SI (FO Use retail orders and Use commission trading)
	When set True value to the constant Use commission trading
	And I close all client application windows
	* SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"	
		And I click "Create" button
		And I click Select button of "Transaction type" field
		And drop-down list named "TransactionType" is equal to:
			| Sales                      |
			| Shipment to trade agent    |
			| Retail sales               |
		And I close all client application windows
	*SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		And I click "Create" button
		And I click Select button of "Transaction type" field
		And drop-down list named "TransactionType" is equal to:
			| Sales                         |
			| Shipment to trade agent       |
			| Retail sales                  |
			| Currency revaluation customer |
			| Currency revaluation vendor   |
		And I close all client application windows

Scenario: _900104 check transaction types in the SO and SI (FO Use commission trading)
	When set False value to the constant Use retail orders
	When set True value to the constant Use commission trading
	And I close all client application windows
	* SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"	
		And I click "Create" button
		And I click Select button of "Transaction type" field
		And drop-down list named "TransactionType" is equal to:
			| Sales                      |
			| Shipment to trade agent    |
		And I close all client application windows
	*SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		And I click "Create" button
		And I click Select button of "Transaction type" field
		And drop-down list named "TransactionType" is equal to:
			| Sales                         |
			| Shipment to trade agent       |
			| Currency revaluation customer |
			| Currency revaluation vendor   |
		And I close all client application windows

Scenario: _900105 check transaction types in the SO and SI (without FO Use commission trading and Use retail orders)
	When set False value to the constant Use retail orders
	When set False value to the constant Use commission trading
	And I close all client application windows
	* SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"	
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click Select button of "Transaction type" field'    |
		And I close all client application windows
	*SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
		And I click "Create" button
		When I Check the steps for Exception
			| 'And I click Select button of "Transaction type" field'    |
		And I close all client application windows




Scenario: _900199 check use source of origin
	And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"		
		And I click "Create" button
		And in the table "ItemList" I click "Add" button
		And I activate "Source of origins" field in "ItemList" table
	* Remove FO Use source of origin		
		When set False value to the constant Use source of origin	
	* Check
		When in opened panel I select "Sales invoice (create)*"
		When I Check the steps for Exception
			| 'And I activate "Source of origins" field in "ItemList" table'    |
	When set True value to the constant Use source of origin	
	And I close all client application windows
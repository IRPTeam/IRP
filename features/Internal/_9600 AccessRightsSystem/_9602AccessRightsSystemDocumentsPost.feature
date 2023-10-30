#language: en
@tree
@Positive
@AccessRightsSystem

Feature: access rights system accumulation and information registers


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: 960001 preparation (access rights system registers)
	And I connect "Этот клиент" TestClient using "CI" login and "CI" password
	When set True value to the constant
	When set True value to the constant Use commission trading
	When set True value to the constant Use accounting
	When set True value to the constant Use consolidated retail sales
	When set True value to the constant Use object access
	When set True value to the constant Use salary
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog Users and AccessProfiles objects (LimitedAccess)
	Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
	And I go to line in "List" table
		| 'Description'          |
		| 'Unit access group'    |
	And I select current line in "List" table	
	If "Profiles" table does not contain lines Then
		| 'Profile'      |
		| 'Unit profile' |
		And in the table "Profiles" I click "Add" button
		And I click choice button of "Profile" attribute in "Profiles" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Unit profile'    |
		And I select current line in "List" table
		And I move to "Users" tab
		And I finish line editing in "Profiles" table
		And in the table "Users" I click the button named "UsersAdd"
		And I click choice button of "User" attribute in "Users" table
		And I go to line in "List" table
			| 'Description'   |
			| 'LimitedAccess' |
		And I select current line in "List" table
		And I finish line editing in "Users" table
	* Check ObjectAccess table
		When filling Access key in the AccessGroups
	And I click "Save and close" button
	And I connect "TestAdmin" TestClient using "LimitedAccess" login and "" password
	When import data for access rights
	And I close all client application windows

Scenario: 963002 try post SO (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '81'     | '26.10.2023 17:19:50' |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales order * dated * *" window closing in "5" seconds
		
Scenario: 963003 try post SI (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '73'     |'26.10.2023 17:20:16'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales invoice * dated * *" window closing in "5" seconds	
	
Scenario: 963004 try post SC (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '73'     |'26.10.2023 17:20:46'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Shipment confirmation * dated * *" window closing in "5" seconds			

Scenario: 963005 try post PlannedReceiptReservation (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
	And I go to line in "List" table
		| 'Number'  | 'Date'                |
		| '217'     |'26.10.2023 17:21:29'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Planned receipt reservation * dated * *" window closing in "5" seconds	

Scenario: 963006 try post SalesReturnOrder (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '73'     |'26.10.2023 17:21:56'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales return order * dated * *" window closing in "5" seconds	

Scenario: 963007 try post SalesReturn(LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '73'     |'26.10.2023 17:22:43'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales return * dated * *" window closing in "5" seconds	

Scenario: 963008 try post PriceList (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PriceList"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '11'     |'26.10.2023 17:14:53'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Price list * dated * *" window closing in "5" seconds

Scenario: 963009 try post WorkOrder (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.WorkOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '10'     |'26.10.2023 17:25:31'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Work order * dated * *" window closing in "5" seconds

Scenario: 963010 try post WorkSheet (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.WorkSheet"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '10'     |'26.10.2023 17:26:08'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Work sheet * dated * *" window closing in "5" seconds

Scenario: 963011 try post SalesReportFromTradeAgent (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '10'     |'26.10.2023 17:26:52'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales report from trade agent * dated * *" window closing in "5" seconds

Scenario: 963012 try post SalesReportToConsignor (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	And I go to line in "List" table
		| 'Number' | 'Date'                |
		| '10'     |'26.10.2023 17:27:31'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales report to consignor * dated * *" window closing in "5" seconds

Scenario: 963013 try post SalesReportToConsignor (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '26.10.2023 17:27:31'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales report to consignor * dated * *" window closing in "5" seconds

Scenario: 963014 try post SalesReportToConsignor (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '26.10.2023 17:27:31'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales report to consignor * dated * *" window closing in "5" seconds


Scenario: 963015 try post PurchaseOrder (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '26.10.2023 17:11:07'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Purchase order * dated * *" window closing in "5" seconds

Scenario: 963017 try post PurchaseInvoice (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '26.10.2023 17:11:46'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Purchase invoice * dated * *" window closing in "5" seconds

Scenario: 963018 try post GoodsReceipt (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '26.10.2023 17:13:07'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Goods receipt * dated * *" window closing in "5" seconds

Scenario: 963018 try post PurchaseReturnOrder (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '26.10.2023 17:13:40'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Purchase return order * dated * *" window closing in "5" seconds

Scenario: 963018 try post PurchaseReturn (LimitedAccess)	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '26.10.2023 17:14:09'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Purchase return * dated * *" window closing in "5" seconds

Scenario: 963019 try post InternalSupplyRequest (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '26.10.2023 17:15:29'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Internal supply request * dated * *" window closing in "5" seconds

Scenario: 963020 try post Labeling (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Labeling"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '4'      | '26.10.2023 17:15:49'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Labeling * dated * *" window closing in "5" seconds
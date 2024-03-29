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
	When set True value to the constant Use fixed assets
	* Add VA extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description"     |
				| "VAExtension"     |
			When add VAExtension
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
	And I close "TestAdmin" TestClient
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

Scenario: 963021 try post Cash statement (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashStatement"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '28'      | '30.10.2023 16:40:34'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash statement * dated * *" window closing in "5" seconds

Scenario: 963022 try post RetailGoodsReceipt (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '73'      | '30.10.2023 16:41:52'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Retail goods receipt * dated * *" window closing in "5" seconds

Scenario: 963023 try post RetailShipmentConfirmation (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '73'      | '30.10.2023 16:42:31'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Retail shipment confirmation * dated * *" window closing in "5" seconds

Scenario: 963024 try post RetailSalesReceipt (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '73'      | '30.10.2023 16:43:38'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Retail sales receipt * dated * *" window closing in "5" seconds

Scenario: 963025 try post RetailReturnReceipt (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '73'      | '30.10.2023 16:47:40'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Retail return receipt * dated * *" window closing in "5" seconds

Scenario: 963026 try post ConsolidatedRetailSales (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ConsolidatedRetailSales"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '28'      | '30.10.2023 16:47:25'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Consolidated retail sales * dated * *" window closing in "5" seconds

Scenario: 963027 try post AdditionalCostAllocation (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '73'      | '31.10.2023 09:50:59'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Additional cost allocation * dated * *" window closing in "5" seconds

Scenario: 963028 try post AdditionalRevenueAllocation (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.AdditionalRevenueAllocation"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '73'      | '31.10.2023 09:51:45'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Additional revenue allocation * dated * *" window closing in "5" seconds

Scenario: 963029 try post Bundling (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '28'      | '31.10.2023 09:52:46'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Bundling * dated * *" window closing in "5" seconds

Scenario: 963030 try post CalculationMovementCosts (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '4'       | '31.10.2023 09:50:35'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Calculation movement costs * dated * *" window closing in "5" seconds

Scenario: 963031 try post InventoryTransfer (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '244'     | '31.10.2023 09:36:46'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Inventory transfer * dated * *" window closing in "5" seconds

Scenario: 963032 try post InventoryTransferOrder (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '82'     | '31.10.2023 09:37:17'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Inventory transfer order * dated * *" window closing in "5" seconds

Scenario: 963033 try post ItemStockAdjustment (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 09:35:50'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Item stock adjustment * dated * *" window closing in "5" seconds

Scenario: 963034 try post PhysicalCountByLocation (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 09:47:30'  |
	And I select current line in "List" table
	And I click "Save and close" button
	Then user message window does not contain messages
	Then I wait "Physical count by location * dated * *" window closing in "5" seconds

Scenario: 963035 try post PhysicalInventory (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 09:43:14'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Physical inventory * dated * *" window closing in "5" seconds

Scenario: 963036 try post StockAdjustmentAsSurplus (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 09:49:18'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Stock adjustment as surplus * dated * *" window closing in "5" seconds

Scenario: 963037 try post StockAdjustmentAsWriteOff (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 09:50:02'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Stock adjustment as write off * dated * *" window closing in "5" seconds

Scenario: 963038 try post Unbundling (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 09:53:14'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Unbundling * dated * *" window closing in "5" seconds

Scenario: 963039 try post Unbundling (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 09:53:14'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Unbundling * dated * *" window closing in "5" seconds

Scenario: 963040 try post BankPayment (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '82'     | '31.10.2023 11:45:20'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Bank payment * dated * *" window closing in "5" seconds

Scenario: 963040 try post BankReceipt (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '82'     | '31.10.2023 11:46:28'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Bank receipt * dated * *" window closing in "5" seconds

Scenario: 963041 try post CashExpense (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashExpense"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '82'     | '31.10.2023 11:48:21'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash expense * dated * *" window closing in "5" seconds

Scenario: 963042 try post CashPayment (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 11:46:55'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash payment * dated * *" window closing in "5" seconds

Scenario: 963043 try post CashReceipt (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 11:47:16'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash receipt * dated * *" window closing in "5" seconds

Scenario: 963044 try post CashRevenue (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashRevenue"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 11:48:49'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash revenue * dated * *" window closing in "5" seconds

Scenario: 963045 try post CashTransferOrder (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '244'     | '31.10.2023 11:54:02'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash transfer order * dated * *" window closing in "5" seconds

Scenario: 963046 try post CreditNote (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CreditNote"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:50:10'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Credit note * dated * *" window closing in "5" seconds

Scenario: 963047 try post CustomersAdvancesClosing (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:50:26'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Customers advances closing * dated * *" window closing in "5" seconds

Scenario: 963048 try post DebitNote (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.DebitNote"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:49:37'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Debit note * dated * *" window closing in "5" seconds

Scenario: 963049 try post EmployeeCashAdvance (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:51:24'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Employee cash advance * dated * *" window closing in "5" seconds

Scenario: 963050 try post ForeignCurrencyRevaluation (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
	And I go to line in "List" table
		| 'Number'| 'Date'                 |
		| '4'     | '31.10.2023 11:51:47'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Foreign currency revaluation * dated * *" window closing in "5" seconds

Scenario: 963051 try post IncomingPaymentOrder (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:54:57'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Incoming payment order * dated * *" window closing in "5" seconds

Scenario: 963052 try post MoneyTransfer (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '244'    | '31.10.2023 11:54:30'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Money transfer * dated * *" window closing in "5" seconds

Scenario: 963053 try post OutgoingPaymentOrder (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 11:55:21'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Outgoing payment order * dated * *" window closing in "5" seconds

Scenario: 963054 try post ReconciliationStatement (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:47:36'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Reconciliation statement * dated * *" window closing in "5" seconds

Scenario: 963055 try post VendorsAdvancesClosing (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:50:47'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Vendors advances closing * dated * *" window closing in "5" seconds

Scenario: 963056 try post Payroll (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Payroll"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 17:01:18'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Payroll * dated * *" window closing in "5" seconds

Scenario: 963057 try post TimeSheet (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.TimeSheet"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 17:02:09'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Time sheet * dated * *" window closing in "5" seconds

Scenario: 963058 try post ProductionPlanning (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '02.11.2023 12:01:51'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Production planning * dated * *" window closing in "5" seconds

Scenario: 963059 try post Production (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Production"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '02.11.2023 12:02:30'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Production * dated * *" window closing in "5" seconds

Scenario: 963060 try post ProductionPlanningCorrection (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '02.11.2023 12:03:16'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Production planning correction * dated * *" window closing in "5" seconds

Scenario: 963061 try post ProductionPlanningClosing (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ProductionPlanningClosing"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '02.11.2023 12:03:24'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Production planning closing * dated * *" window closing in "5" seconds

Scenario: 963062 try post SalesOrderClosing (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '01.11.2023 13:35:53'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Sales order closing * dated * *" window closing in "5" seconds

Scenario: 963063 try post PurchaseOrderClosing (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '01.11.2023 13:36:20'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Purchase order closing * dated * *" window closing in "5" seconds

Scenario: 963064 try post CommissioningOfFixedAsset (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '01.11.2023 13:15:18'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Commissioning of fixed asset * dated * *" window closing in "5" seconds

Scenario: 963065 try post DecommissioningOfFixedAsset (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.DecommissioningOfFixedAsset"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '01.11.2023 13:15:51'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Decommissioning of fixed asset * dated * *" window closing in "5" seconds

Scenario: 963066 try post DepreciationCalculation (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '01.11.2023 13:16:01'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Depreciation calculation * dated * *" window closing in "5" seconds

Scenario: 963067 try post ModernizationOfFixedAsset (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ModernizationOfFixedAsset"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '73'     | '01.11.2023 13:35:12'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Modernization of fixed asset * dated * *" window closing in "5" seconds

Scenario: 963068 try post ChequeBondTransaction (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '01.11.2023 13:54:15'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cheque bond transaction * dated * *" window closing in "5" seconds
	

Scenario: 964003 deletion mark AdditionalCostAllocation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.AdditionalCostAllocation.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.AdditionalCostAllocation.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.AdditionalCostAllocation.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.AdditionalCostAllocation.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964004 deletion mark AdditionalRevenueAllocation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.AdditionalRevenueAllocation.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.AdditionalRevenueAllocation.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.AdditionalRevenueAllocation.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.AdditionalRevenueAllocation.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964005 deletion mark BankPayment (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.BankPayment.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.BankPayment.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.BankPayment.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.BankPayment.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964006 deletion mark BankReceipt (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.BankReceipt.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.BankReceipt.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.BankReceipt.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.BankReceipt.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964007 deletion mark BatchReallocateIncoming (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.BatchReallocateIncoming.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.BatchReallocateIncoming.FindByNumber(10).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.BatchReallocateIncoming.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.BatchReallocateIncoming.FindByNumber(10).DeletionMark=True}" is true

Scenario: 964008 deletion mark BatchReallocateOutgoing (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.BatchReallocateOutgoing.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.BatchReallocateOutgoing.FindByNumber(10).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.BatchReallocateOutgoing.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.BatchReallocateOutgoing.FindByNumber(10).DeletionMark=True}" is true

Scenario: 964009 deletion mark Bundling (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Bundling.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Bundling.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.Bundling.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.Bundling.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964010 deletion mark CalculationMovementCosts (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CalculationMovementCosts.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CalculationMovementCosts.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CalculationMovementCosts.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CalculationMovementCosts.FindByNumber(2).DeletionMark=True}" is true

Scenario: 964011 deletion mark CashExpense (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashExpense.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashExpense.FindByNumber(41).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CashExpense.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CashExpense.FindByNumber(41).DeletionMark=True}" is true

Scenario: 964012 deletion mark CashPayment (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashPayment.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashPayment.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CashPayment.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CashPayment.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964013 deletion mark CashReceipt (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashReceipt.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashReceipt.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CashReceipt.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CashReceipt.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964014 deletion mark CashRevenue (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashRevenue.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashRevenue.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CashRevenue.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CashRevenue.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964015 deletion mark CashStatement (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashStatement.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashStatement.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CashStatement.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CashStatement.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964016 deletion mark CashTransferOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashTransferOrder.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CashTransferOrder.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CashTransferOrder.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CashTransferOrder.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964017 deletion mark ChequeBondTransaction (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ChequeBondTransaction.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ChequeBondTransaction.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ChequeBondTransaction.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ChequeBondTransaction.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964018 deletion mark ChequeBondTransactionItem (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ChequeBondTransactionItem.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ChequeBondTransactionItem.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ChequeBondTransactionItem.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ChequeBondTransactionItem.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964019 deletion mark ConsolidatedRetailSales (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ConsolidatedRetailSales.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ConsolidatedRetailSales.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ConsolidatedRetailSales.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ConsolidatedRetailSales.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964020 deletion mark CreditNote (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CreditNote.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CreditNote.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CreditNote.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CreditNote.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964021 deletion mark CustomersAdvancesClosing (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CustomersAdvancesClosing.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CustomersAdvancesClosing.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CustomersAdvancesClosing.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CustomersAdvancesClosing.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964022 deletion mark DebitNote (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.DebitNote.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.DebitNote.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.DebitNote.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.DebitNote.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964023 deletion mark EmployeeCashAdvance (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.EmployeeCashAdvance.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.EmployeeCashAdvance.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.EmployeeCashAdvance.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.EmployeeCashAdvance.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964024 deletion mark ForeignCurrencyRevaluation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ForeignCurrencyRevaluation.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ForeignCurrencyRevaluation.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ForeignCurrencyRevaluation.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ForeignCurrencyRevaluation.FindByNumber(2).DeletionMark=True}" is true

Scenario: 964025 deletion mark GoodsReceipt (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.GoodsReceipt.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.GoodsReceipt.FindByNumber(11).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.GoodsReceipt.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.GoodsReceipt.FindByNumber(11).DeletionMark=True}" is true

Scenario: 964026 deletion mark IncomingPaymentOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.IncomingPaymentOrder.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.IncomingPaymentOrder.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.IncomingPaymentOrder.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.IncomingPaymentOrder.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964027 deletion mark InternalSupplyRequest (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.InternalSupplyRequest.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.InternalSupplyRequest.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.InternalSupplyRequest.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.InternalSupplyRequest.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964028 deletion mark InventoryTransfer (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.InventoryTransfer.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.InventoryTransfer.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.InventoryTransfer.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.InventoryTransfer.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964029 deletion mark InventoryTransferOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.InventoryTransferOrder.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.InventoryTransferOrder.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.InventoryTransferOrder.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.InventoryTransferOrder.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964030 deletion mark ItemStockAdjustment (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ItemStockAdjustment.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ItemStockAdjustment.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ItemStockAdjustment.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ItemStockAdjustment.FindByNumber(5).DeletionMark=True}" is true


Scenario: 964032 deletion mark Labeling (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Labeling.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Labeling.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.Labeling.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.Labeling.FindByNumber(2).DeletionMark=True}" is true

Scenario: 964033 deletion mark ManualRegisterEntry (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ManualRegisterEntry.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ManualRegisterEntry.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ManualRegisterEntry.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ManualRegisterEntry.FindByNumber(2).DeletionMark=True}" is true

Scenario: 964034 deletion mark MoneyTransfer (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.MoneyTransfer.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.MoneyTransfer.FindByNumber(14).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.MoneyTransfer.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.MoneyTransfer.FindByNumber(14).DeletionMark=True}" is true

Scenario: 964035 deletion mark OpeningEntry (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.OpeningEntry.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.OpeningEntry.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.OpeningEntry.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.OpeningEntry.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964036 deletion mark OutgoingPaymentOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.OutgoingPaymentOrder.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.OutgoingPaymentOrder.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.OutgoingPaymentOrder.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.OutgoingPaymentOrder.FindByNumber(5).DeletionMark=True}" is true


Scenario: 964037 deletion mark Payroll (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Payroll.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Payroll.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.Payroll.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.Payroll.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964038 deletion mark PhysicalCountByLocation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PhysicalCountByLocation.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PhysicalCountByLocation.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PhysicalCountByLocation.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PhysicalCountByLocation.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964039 deletion mark PhysicalInventory (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PhysicalInventory.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PhysicalInventory.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PhysicalInventory.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PhysicalInventory.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964040 deletion mark PlannedReceiptReservation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PlannedReceiptReservation.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PlannedReceiptReservation.FindByNumber(118).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PlannedReceiptReservation.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PlannedReceiptReservation.FindByNumber(118).DeletionMark=True}" is true

Scenario: 964041 deletion mark PriceList (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PriceList.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PriceList.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PriceList.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PriceList.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964042 deletion mark Production (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Production.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Production.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.Production.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.Production.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964043 deletion mark ProductionCostsAllocation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ProductionCostsAllocation.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ProductionCostsAllocation.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ProductionCostsAllocation.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ProductionCostsAllocation.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964044 deletion mark ProductionPlanning (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ProductionPlanning.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ProductionPlanning.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ProductionPlanning.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ProductionPlanning.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964045 deletion mark ProductionPlanningClosing (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ProductionPlanningClosing.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ProductionPlanningClosing.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ProductionPlanningClosing.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ProductionPlanningClosing.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964046 deletion mark ProductionPlanningCorrection (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ProductionPlanningCorrection.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ProductionPlanningCorrection.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ProductionPlanningCorrection.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ProductionPlanningCorrection.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964047 deletion mark PurchaseInvoice (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseInvoice.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseInvoice.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PurchaseInvoice.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PurchaseInvoice.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964048 deletion mark PurchaseOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseOrder.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseOrder.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PurchaseOrder.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PurchaseOrder.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964049 deletion mark PurchaseOrderClosing (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseOrderClosing.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseOrderClosing.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PurchaseOrderClosing.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PurchaseOrderClosing.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964050 deletion mark PurchaseReturn (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseReturn.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseReturn.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PurchaseReturn.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PurchaseReturn.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964051 deletion mark PurchaseReturnOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseReturnOrder.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.PurchaseReturnOrder.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.PurchaseReturnOrder.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.PurchaseReturnOrder.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964052 deletion mark ReconciliationStatement (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ReconciliationStatement.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ReconciliationStatement.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ReconciliationStatement.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ReconciliationStatement.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964053 deletion mark RetailGoodsReceipt (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.RetailGoodsReceipt.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.RetailGoodsReceipt.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.RetailGoodsReceipt.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.RetailGoodsReceipt.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964054 deletion mark RetailReturnReceipt (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.RetailReturnReceipt.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.RetailReturnReceipt.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.RetailReturnReceipt.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.RetailReturnReceipt.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964055 deletion mark RetailSalesReceipt (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.RetailSalesReceipt.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.RetailSalesReceipt.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.RetailSalesReceipt.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.RetailSalesReceipt.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964056 deletion mark RetailShipmentConfirmation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.RetailShipmentConfirmation.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.RetailShipmentConfirmation.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.RetailShipmentConfirmation.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.RetailShipmentConfirmation.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964057 deletion mark SalesInvoice (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesInvoice.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesInvoice.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.SalesInvoice.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.SalesInvoice.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964058 deletion mark SalesOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesOrder.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesOrder.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.SalesOrder.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.SalesOrder.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964059 deletion mark SalesOrderClosing (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesOrderClosing.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesOrderClosing.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.SalesOrderClosing.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.SalesOrderClosing.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964060 deletion mark SalesReportFromTradeAgent (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesReportFromTradeAgent.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesReportFromTradeAgent.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.SalesReportFromTradeAgent.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.SalesReportFromTradeAgent.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964061 deletion mark SalesReportToConsignor (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesReportToConsignor.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesReportToConsignor.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.SalesReportToConsignor.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.SalesReportToConsignor.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964062 deletion mark SalesReturn (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesReturn.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesReturn.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.SalesReturn.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.SalesReturn.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964063 deletion mark SalesReturnOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesReturnOrder.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.SalesReturnOrder.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.SalesReturnOrder.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.SalesReturnOrder.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964064 deletion mark ShipmentConfirmation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ShipmentConfirmation.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ShipmentConfirmation.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ShipmentConfirmation.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ShipmentConfirmation.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964065 deletion mark StockAdjustmentAsSurplus (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.StockAdjustmentAsSurplus.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.StockAdjustmentAsSurplus.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.StockAdjustmentAsSurplus.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.StockAdjustmentAsSurplus.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964066 deletion mark StockAdjustmentAsWriteOff (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.StockAdjustmentAsWriteOff.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.StockAdjustmentAsWriteOff.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.StockAdjustmentAsWriteOff.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.StockAdjustmentAsWriteOff.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964067 deletion mark TimeSheet (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.TimeSheet.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.TimeSheet.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.TimeSheet.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.TimeSheet.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964068 deletion mark Unbundling (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Unbundling.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.Unbundling.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.Unbundling.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.Unbundling.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964069 deletion mark VendorsAdvancesClosing (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.VendorsAdvancesClosing.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.VendorsAdvancesClosing.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.VendorsAdvancesClosing.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.VendorsAdvancesClosing.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964070 deletion mark WorkOrder (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.WorkOrder.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.WorkOrder.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.WorkOrder.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.WorkOrder.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964071 deletion mark WorkOrderClosing (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.WorkOrderClosing.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.WorkOrderClosing.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.WorkOrderClosing.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.WorkOrderClosing.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964072 deletion mark WorkSheet (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.WorkSheet.FindByNumber(1).GetObject();"  |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.WorkSheet.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.WorkSheet.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.WorkSheet.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964073 deletion mark CommissioningOfFixedAsset (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CommissioningOfFixedAsset.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.CommissioningOfFixedAsset.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.CommissioningOfFixedAsset.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.CommissioningOfFixedAsset.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964074 deletion mark DecommissioningOfFixedAsset (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.DecommissioningOfFixedAsset.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.DecommissioningOfFixedAsset.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.DecommissioningOfFixedAsset.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.DecommissioningOfFixedAsset.FindByNumber(26).DeletionMark=True}" is true

Scenario: 964075 deletion mark DepreciationCalculation (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.DepreciationCalculation.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.DepreciationCalculation.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.DepreciationCalculation.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.DepreciationCalculation.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964076 deletion mark FixedAssetTransfer (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.FixedAssetTransfer.FindByNumber(1).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.FixedAssetTransfer.FindByNumber(5).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.FixedAssetTransfer.FindByNumber(1).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.FixedAssetTransfer.FindByNumber(5).DeletionMark=True}" is true

Scenario: 964077 deletion mark ModernizationOfFixedAsset (LimitedAccess)
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ModernizationOfFixedAsset.FindByNumber(2).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And I execute the built-in language code at server (Extension)
		| "Try"                                                     |
		| "Doc = Documents.ModernizationOfFixedAsset.FindByNumber(26).GetObject();" |
		| "Doc.DeletionMark = False;"                               |
		| "Doc.Write();"                                            |
		| "Except"                                                  |
		| "EndTry"                                                  |
	And 1C:Enterprise language expression "{!Documents.ModernizationOfFixedAsset.FindByNumber(2).DeletionMark=False}" is true
	And 1C:Enterprise language expression "{!Documents.ModernizationOfFixedAsset.FindByNumber(26).DeletionMark=True}" is true

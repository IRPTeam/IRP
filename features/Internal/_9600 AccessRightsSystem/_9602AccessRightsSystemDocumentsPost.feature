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

Scenario: 963041 try post CashPayment (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 11:46:55'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash payment * dated * *" window closing in "5" seconds

Scenario: 963041 try post CashReceipt (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 11:47:16'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash receipt * dated * *" window closing in "5" seconds

Scenario: 963041 try post CashRevenue (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashRevenue"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 11:48:49'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash revenue * dated * *" window closing in "5" seconds

Scenario: 963041 try post CashTransferOrder (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I go to line in "List" table
		| 'Number'  | 'Date'                 |
		| '244'     | '31.10.2023 11:54:02'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Cash transfer order * dated * *" window closing in "5" seconds

Scenario: 963041 try post CreditNote (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CreditNote"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:50:10'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Credit note * dated * *" window closing in "5" seconds

Scenario: 963041 try post CustomersAdvancesClosing (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CustomersAdvancesClosing"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:50:26'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Customers advances closing * dated * *" window closing in "5" seconds

Scenario: 963041 try post DebitNote (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.DebitNote"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:49:37'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Debit note * dated * *" window closing in "5" seconds

Scenario: 963041 try post EmployeeCashAdvance (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:51:24'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Employee cash advance * dated * *" window closing in "5" seconds

Scenario: 963041 try post ForeignCurrencyRevaluation (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
	And I go to line in "List" table
		| 'Number'| 'Date'                 |
		| '4'     | '31.10.2023 11:51:47'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Foreign currency revaluation * dated * *" window closing in "5" seconds

Scenario: 963041 try post IncomingPaymentOrder (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:54:57'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Incoming payment order * dated * *" window closing in "5" seconds

Scenario: 963041 try post MoneyTransfer (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '244'    | '31.10.2023 11:54:30'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Money transfer * dated * *" window closing in "5" seconds

Scenario: 963041 try post OutgoingPaymentOrder (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '28'     | '31.10.2023 11:55:21'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Outgoing payment order * dated * *" window closing in "5" seconds

Scenario: 963041 try post ReconciliationStatement (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:47:36'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Reconciliation statement * dated * *" window closing in "5" seconds

Scenario: 963041 try post VendorsAdvancesClosing (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.VendorsAdvancesClosing"
	And I go to line in "List" table
		| 'Number' | 'Date'                 |
		| '10'     | '31.10.2023 11:50:47'  |
	And I select current line in "List" table
	And I click "Post and close" button
	Then user message window does not contain messages
	Then I wait "Vendors advances closing * dated * *" window closing in "5" seconds
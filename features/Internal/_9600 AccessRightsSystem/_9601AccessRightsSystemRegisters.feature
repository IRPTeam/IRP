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
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog Users and AccessProfiles objects (LimitedAccess)
	When Create catalog AccessGroups objects (LimitedAccessRegisters)
	* Create registers for tests
		Given I open hyperlink "e1cib/app/DataProcessor.Unit_RunTest"
		And I go to line in "TestList" table
			| 'Test'                                                 |
			| 'Unit_AccessSubsystem.GenerateAccumulationRegisters()' |
		And in the table "TestList" I click "Run test" button
		And Delay 60
		And I go to line in "TestList" table
			| 'Test'                                                |
			| 'Unit_AccessSubsystem.GenerateInformationRegisters()' |
		And in the table "TestList" I click "Run test" button
		And Delay 60
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
* Add new users in the Unit profile profile
	Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
	And I go to line in "List" table
		| 'Description'          |
		| 'Unit access group'    |
	And I select current line in "List" table
	And I move to "Users" tab
	And I finish line editing in "Profiles" table
	And in the table "Users" I click the button named "UsersAdd"
	And I click choice button of "User" attribute in "Users" table
	And I go to line in "List" table
		| 'Description'   |
		| 'LimitedAccessRegisters' |
	And I select current line in "List" table
	And I finish line editing in "Users" table
	And in the table "Users" I click the button named "UsersAdd"
	And I click choice button of "User" attribute in "Users" table
	And I go to line in "List" table
		| 'Description'   |
		| 'LARegAccessDeny' |
	And I select current line in "List" table
	And I finish line editing in "Users" table
	And I click "Save and close" button
* Save user access group
	Given I open hyperlink "e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb0635de1ba68"
	And I click "Save and close" button
	Given I open hyperlink "e1cib/data/Catalog.AccessGroups?ref=b7b4b80c227e00a211eeb070971c2f4d"
	And I click "Save and close" button
	// * Check ObjectAccess register
	// 	Given I open hyperlink "e1cib/list/InformationRegister.T9101A_ObjectAccessRegisters"
	// 	And "List" table contains "ObjectAccessRegister" template lines by template
	// * Check catalog Object access keys
	// 	Given I open hyperlink "e1cib/list/Catalog.ObjectAccessKeys"
	// 	And "List" table is equal to "ObjectAccessKeys" by template
	// * Check catalog Object access keys
	// 	Given I open hyperlink "e1cib/list/InformationRegister.T9100A_ObjectAccessMap"
	// 	And "List" table is equal to "ObjectAccessMap" by template
	And I close all client application windows

Scenario: 961003 check CashInTransit creation (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.CashInTransit"
	Then the number of "List" table lines is "равно" "27"	

Scenario: 961004 check R1001 Purchases register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1001T_Purchases"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961005 check R1002 Purchase returns register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1002T_PurchaseReturns"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961006 check R1005T_PurchaseSpecialOffers register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1005T_PurchaseSpecialOffers"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961007 check R1010T_PurchaseOrders register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961008 check R1011B_PurchaseOrdersReceipt register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1011B_PurchaseOrdersReceipt"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961009 check R1012B_PurchaseOrdersInvoiceClosing register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1012B_PurchaseOrdersInvoiceClosing"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961010 check R1014T_CanceledPurchaseOrders register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1014T_CanceledPurchaseOrders"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961011 check R1020B_AdvancesToVendors register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961012 check R1021B_VendorsTransactions register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961013 check R1022B_VendorsPaymentPlanning register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1022B_VendorsPaymentPlanning"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961014 check R1031B_ReceiptInvoicing register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1031B_ReceiptInvoicing"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961015 check R1040B_TaxesOutgoing register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1040B_TaxesOutgoing"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961016 check R2001T_Sales register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2001T_Sales"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961017 check R2002T_SalesReturns register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2002T_SalesReturns"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961018 check R2005T_SalesSpecialOffers register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2005T_SalesSpecialOffers"
	Then the number of "List" table lines is "равно" "9"

// Scenario: 961019 check R2006T_Certificates register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.R2006T_Certificates"
// 	Then the number of "List" table lines is "равно" "9"

Scenario: 961020 check R2010T_SalesOrders register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2010T_SalesOrders"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961021 check R2011B_SalesOrdersShipment register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2011B_SalesOrdersShipment"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961022 check R2012B_SalesOrdersInvoiceClosing register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2012B_SalesOrdersInvoiceClosing"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961023 check R2013T_SalesOrdersProcurement register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2013T_SalesOrdersProcurement"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961024 check R2014T_CanceledSalesOrders register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2014T_CanceledSalesOrders"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961025 check R2020B_AdvancesFromCustomers register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961026 check R2021B_CustomersTransactions register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961027 check R2022B_CustomersPaymentPlanning register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2022B_CustomersPaymentPlanning"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961028 check R2023B_AdvancesFromRetailCustomers register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2023B_AdvancesFromRetailCustomers"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961029 check R2031B_ShipmentInvoicing register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2031B_ShipmentInvoicing"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961030 check R2040B_TaxesIncoming register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2040B_TaxesIncoming"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961031 check R2050T_RetailSales register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2050T_RetailSales"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961032 check R3010B_CashOnHand register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3010B_CashOnHand"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961033 check R3011T_CashFlow register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3011T_CashFlow"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961034 check R3015B_CashAdvance register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3015B_CashAdvance"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961035 check R3016B_ChequeAndBonds register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3016B_ChequeAndBonds"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961036 check R3021B_CashInTransitIncoming register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3021B_CashInTransitIncoming"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961037 check R3022B_CashInTransitOutgoing register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3022B_CashInTransitOutgoing"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961038 check R3024B_SalesOrdersToBePaid register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3024B_SalesOrdersToBePaid"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961039 check R3025B_PurchaseOrdersToBePaid register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3025B_PurchaseOrdersToBePaid"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961040 check R3026B_SalesOrdersCustomerAdvance register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3026B_SalesOrdersCustomerAdvance"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961041 check R3027B_EmployeeCashAdvancee register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3027B_EmployeeCashAdvance"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961042 check R3035T_CashPlanning register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961043 check R3050T_PosCashBalances register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3050T_PosCashBalances"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961044 check R4010B_ActualStocks register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4010B_ActualStocks"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961045 check R4011B_FreeStocks register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4011B_FreeStocks"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961046 check R4012B_StockReservation register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4012B_StockReservation"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961047 check R4014B_SerialLotNumber register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4014B_SerialLotNumber"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961048 check R4015T_InternalSupplyRequests register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4015T_InternalSupplyRequests"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961049 check R4016B_InternalSupplyRequestOrdering register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4016B_InternalSupplyRequestOrdering"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961050 check R4017B_InternalSupplyRequestProcurement register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4017B_InternalSupplyRequestProcurement"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961051 check R4020T_StockTransferOrders register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4020T_StockTransferOrders"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961052 check R4021B_StockTransferOrdersReceipt register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4021B_StockTransferOrdersReceipt"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961053 check R4022B_StockTransferOrdersShipment register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4022B_StockTransferOrdersShipment"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961054 check R4031B_GoodsInTransitIncoming register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4031B_GoodsInTransitIncoming"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961055 check R4032B_GoodsInTransitOutgoing register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4032B_GoodsInTransitOutgoing"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961056 check R4033B_GoodsReceiptSchedule register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4033B_GoodsReceiptSchedule"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961057 check R4034B_GoodsShipmentSchedule register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4034B_GoodsShipmentSchedule"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961058 check R4035B_IncomingStocks register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4035B_IncomingStocks"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961059 check R4036B_IncomingStocksRequested register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4036B_IncomingStocksRequested"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961060 check R4037B_PlannedReceiptReservationRequests register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4037B_PlannedReceiptReservationRequests"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961061 check R4050B_StockInventory register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4050B_StockInventory"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961062 check R4051T_StockAdjustmentAsWriteOff register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4051T_StockAdjustmentAsWriteOff"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961063 check R4052T_StockAdjustmentAsSurplus register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4052T_StockAdjustmentAsSurplus"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961064 check R5010B_ReconciliationStatement register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5010B_ReconciliationStatement"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961065 check R5011B_CustomersAging register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5011B_CustomersAging"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961066 check R5012B_VendorsAging register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5012B_VendorsAging"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961067 check R5015B_OtherPartnersTransactions register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5015B_OtherPartnersTransactions"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961068 check R5021T_Revenues register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5021T_Revenues"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961069 check R5022T_Expenses register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5022T_Expenses"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961070 check R5041B_TaxesPayable register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5041B_TaxesPayable"
	Then the number of "List" table lines is "равно" "9"

// Scenario: 961071 check R6010B_BatchWiseBalance register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.R6010B_BatchWiseBalance"
// 	Then the number of "List" table lines is "равно" "9"

Scenario: 961072 check R6020B_BatchBalance register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6020B_BatchBalance"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961073 check R6030T_BatchShortageOutgoing register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6030T_BatchShortageOutgoing"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961074 check R6040T_BatchShortageIncoming register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6040T_BatchShortageIncoming"
	Then the number of "List" table lines is "равно" "3"

// Scenario: 961075 check R6050T_SalesBatches register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.R6050T_SalesBatches"
// 	Then the number of "List" table lines is "равно" "9"

Scenario: 961076 check R6060T_CostOfGoodsSold register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6060T_CostOfGoodsSold"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961077 check R6070T_OtherPeriodsExpenses register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6070T_OtherPeriodsExpenses"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961078 check R6080T_OtherPeriodsRevenues register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6080T_OtherPeriodsRevenues"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961079 check R7010T_DetailingSupplies register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7010T_DetailingSupplies"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961080 check R7020T_MaterialPlanning register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7020T_MaterialPlanning"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961081 check R7030T_ProductionPlanning register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7030T_ProductionPlanning"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961082 check R7040T_ManualMaterialsCorretionInProduction register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7040T_ManualMaterialsCorretionInProduction"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961083 check R7050T_ProductionDurations register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7050T_ProductionDurations"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961084 check R8014T_ConsignorSales register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R8014T_ConsignorSales"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961085 check R8015T_ConsignorPrices register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R8015T_ConsignorPrices"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961086 check R9010B_SourceOfOriginStock register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9010B_SourceOfOriginStock"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961087 check R9510B_SalaryPayment register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9510B_SalaryPayment"
	Then the number of "List" table lines is "равно" "9"

// Scenario: 961088 check T1040T_AccountingAmounts register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.T1040T_AccountingAmounts"
// 	Then the number of "List" table lines is "равно" "9"

// Scenario: 961089 check T1050T_AccountingQuantities register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.T1050T_AccountingQuantities"
// 	Then the number of "List" table lines is "равно" "9"

// Scenario: 961090 check TM1010B_RowIDMovements register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1010B_RowIDMovements"
// 	Then the number of "List" table lines is "равно" "9"

// Scenario: 961091 check TM1010T_RowIDMovements register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1010T_RowIDMovements"
// 	Then the number of "List" table lines is "равно" "9"

// Scenario: 961092 check TM1020B_AdvancesKey register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1020B_AdvancesKey"
// 	Then the number of "List" table lines is "равно" "9"

// Scenario: 961093 check TM1030B_TransactionsKey register access (admin)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1030B_TransactionsKey"
// 	Then the number of "List" table lines is "равно" "9"

Scenario: 961094 check R8510B_BookValueOfFixedAsset register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R8510B_BookValueOfFixedAsset"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961095 check R8515T_CostOfFixedAsset register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R8515T_CostOfFixedAsset"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961096 check BranchBankTerms register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.BranchBankTerms"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961099 check CompanyLedgerTypes register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.CompanyLedgerTypes"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961102 check ExpenseRevenueTypeSettings register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.ExpenseRevenueTypeSettings"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961104 check S1001L_VendorsPricesByItemKey register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.S1001L_VendorsPricesByItemKey"
	Then the number of "List" table lines is "равно" "3"


Scenario: 961106 check PricesByItemKeys register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.PricesByItemKeys"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961107 check PricesByItems register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.PricesByItems"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961108 check PricesByProperties register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.PricesByProperties"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961109 check RemainingItemsInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.RemainingItemsInfo"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961110 check RetailWorkers register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.RetailWorkers"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961111 check T2010S_OffsetOfAdvances register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2010S_OffsetOfAdvances"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961112 check T2013S_OffsetOfAging register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2013S_OffsetOfAging"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961113 check T2014S_AdvancesInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2014S_AdvancesInfo"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961114 check T2015S_TransactionsInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2015S_TransactionsInfo"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961115 check T2016S_VendorsAdvancesRelevance register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2016S_VendorsAdvancesRelevance"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961116 check T2017S_CustomersAdvancesRelevance register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2017S_CustomersAdvancesRelevance"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961116 check T6010S_BatchesInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6010S_BatchesInfo"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961117 check T6020S_BatchKeysInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6020S_BatchKeysInfo"
	Then the number of "List" table lines is "равно" "27"

Scenario: 961118 check T6030S_BatchRelevance register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6030S_BatchRelevance"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961119 check T6040S_BundleAmountValues register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6040S_BundleAmountValues"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961120 check T6050S_ManualBundleAmountValues register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6050S_ManualBundleAmountValues"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961121 check T6060S_BatchCostAllocationInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6060S_BatchCostAllocationInfo"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961122 check T6070S_BatchRevenueAllocationInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6070S_BatchRevenueAllocationInfo"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961124 check T6090S_CompositeBatchesAmountValues register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6090S_CompositeBatchesAmountValues"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961125 check T6095S_WriteOffBatchesInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6095S_WriteOffBatchesInfo"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961126 check T7010S_BillOfMaterials register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T7010S_BillOfMaterials"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961127 check T7051S_ProductionDurationDetails register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T7051S_ProductionDurationDetails"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961128 check T9010S_AccountsItemKey register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9010S_AccountsItemKey"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961129 check T9011S_AccountsCashAccount register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9011S_AccountsCashAccount"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961130 check T9012S_AccountsPartner register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9012S_AccountsPartner"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961131 check T9013S_AccountsTax register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9013S_AccountsTax"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961132 check T9014S_AccountsExpenseRevenue register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9014S_AccountsExpenseRevenue"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961133 check T9520S_TimeSheetInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9520S_TimeSheetInfo"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961134 check Taxes register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.Taxes"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961135 check TaxSettings register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.TaxSettings"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961136 check T8510S_FixedAssetsInfo register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T8510S_FixedAssetsInfo"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961137 check T8515S_FixedAssetsLocation register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T8515S_FixedAssetsLocation"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961138 check R9555T_PaidSickLeaves register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9555T_PaidSickLeaves"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961139 check R9545T_PaidVacations register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9545T_PaidVacations"
	Then the number of "List" table lines is "равно" "3"

Scenario: 961141 check R9560T_AdditionalAccrual register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9560T_AdditionalAccrual"
	Then the number of "List" table lines is "равно" "9"

Scenario: 961142 check R9570T_AdditionalDeduction register access (admin)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9570T_AdditionalDeduction"
	Then the number of "List" table lines is "равно" "9"

Scenario: 962003 check CashInTransit creation (LimitedAccess)
	And I close all client application windows
	And I connect "TestAdmin" TestClient using "LimitedAccess" login and "" password
	Given I open hyperlink "e1cib/list/AccumulationRegister.CashInTransit"
	Then the number of "List" table lines is "равно" "16"	

Scenario: 962004 check R1001 Purchases register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1001T_Purchases"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962005 check R1002 Purchase returns register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1002T_PurchaseReturns"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962006 check R1005T_PurchaseSpecialOffers register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1005T_PurchaseSpecialOffers"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962007 check R1010T_PurchaseOrders register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1010T_PurchaseOrders"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962008 check R1011B_PurchaseOrdersReceipt register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1011B_PurchaseOrdersReceipt"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962009 check R1012B_PurchaseOrdersInvoiceClosing register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1012B_PurchaseOrdersInvoiceClosing"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962010 check R1014T_CanceledPurchaseOrders register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1014T_CanceledPurchaseOrders"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962011 check R1020B_AdvancesToVendors register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1020B_AdvancesToVendors"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962012 check R1021B_VendorsTransactions register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1021B_VendorsTransactions"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962013 check R1022B_VendorsPaymentPlanning register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1022B_VendorsPaymentPlanning"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962014 check R1031B_ReceiptInvoicing register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1031B_ReceiptInvoicing"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962015 check R1040B_TaxesOutgoing register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R1040B_TaxesOutgoing"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962016 check R2001T_Sales register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2001T_Sales"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962017 check R2002T_SalesReturns register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2002T_SalesReturns"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962018 check R2005T_SalesSpecialOffers register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2005T_SalesSpecialOffers"
	Then the number of "List" table lines is "равно" "4"

// Scenario: 962019 check R2006T_Certificates register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.R2006T_Certificates"
// 	Then the number of "List" table lines is "равно" "4"

Scenario: 962020 check R2010T_SalesOrders register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2010T_SalesOrders"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962021 check R2011B_SalesOrdersShipment register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2011B_SalesOrdersShipment"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962022 check R2012B_SalesOrdersInvoiceClosing register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2012B_SalesOrdersInvoiceClosing"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962023 check R2013T_SalesOrdersProcurement register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2013T_SalesOrdersProcurement"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962024 check R2014T_CanceledSalesOrders register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2014T_CanceledSalesOrders"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962025 check R2020B_AdvancesFromCustomers register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2020B_AdvancesFromCustomers"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962026 check R2021B_CustomersTransactions register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2021B_CustomersTransactions"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962027 check R2022B_CustomersPaymentPlanning register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2022B_CustomersPaymentPlanning"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962028 check R2023B_AdvancesFromRetailCustomers register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2023B_AdvancesFromRetailCustomers"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962029 check R2031B_ShipmentInvoicing register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2031B_ShipmentInvoicing"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962030 check R2040B_TaxesIncoming register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2040B_TaxesIncoming"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962031 check R2050T_RetailSales register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2050T_RetailSales"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962032 check R3010B_CashOnHand register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3010B_CashOnHand"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962033 check R3011T_CashFlow register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3011T_CashFlow"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962034 check R3015B_CashAdvance register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3015B_CashAdvance"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962035 check R3016B_ChequeAndBonds register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3016B_ChequeAndBonds"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962036 check R3021B_CashInTransitIncoming register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3021B_CashInTransitIncoming"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962037 check R3022B_CashInTransitOutgoing register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3022B_CashInTransitOutgoing"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962038 check R3024B_SalesOrdersToBePaid register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3024B_SalesOrdersToBePaid"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962039 check R3025B_PurchaseOrdersToBePaid register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3025B_PurchaseOrdersToBePaid"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962040 check R3026B_SalesOrdersCustomerAdvance register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3026B_SalesOrdersCustomerAdvance"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962041 check R3027B_EmployeeCashAdvancee register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3027B_EmployeeCashAdvance"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962042 check R3035T_CashPlanning register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962043 check R3050T_PosCashBalances register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3050T_PosCashBalances"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962044 check R4010B_ActualStocks register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4010B_ActualStocks"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962045 check R4011B_FreeStocks register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4011B_FreeStocks"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962046 check R4012B_StockReservation register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4012B_StockReservation"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962047 check R4014B_SerialLotNumber register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4014B_SerialLotNumber"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962048 check R4015T_InternalSupplyRequests register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4015T_InternalSupplyRequests"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962049 check R4016B_InternalSupplyRequestOrdering register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4016B_InternalSupplyRequestOrdering"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962050 check R4017B_InternalSupplyRequestProcurement register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4017B_InternalSupplyRequestProcurement"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962051 check R4020T_StockTransferOrders register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4020T_StockTransferOrders"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962052 check R4021B_StockTransferOrdersReceipt register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4021B_StockTransferOrdersReceipt"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962053 check R4022B_StockTransferOrdersShipment register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4022B_StockTransferOrdersShipment"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962054 check R4031B_GoodsInTransitIncoming register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4031B_GoodsInTransitIncoming"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962055 check R4032B_GoodsInTransitOutgoing register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4032B_GoodsInTransitOutgoing"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962056 check R4033B_GoodsReceiptSchedule register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4033B_GoodsReceiptSchedule"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962057 check R4034B_GoodsShipmentSchedule register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4034B_GoodsShipmentSchedule"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962058 check R4035B_IncomingStocks register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4035B_IncomingStocks"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962059 check R4036B_IncomingStocksRequested register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4036B_IncomingStocksRequested"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962060 check R4037B_PlannedReceiptReservationRequests register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4037B_PlannedReceiptReservationRequests"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962061 check R4050B_StockInventory register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4050B_StockInventory"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962062 check R4051T_StockAdjustmentAsWriteOff register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4051T_StockAdjustmentAsWriteOff"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962063 check R4052T_StockAdjustmentAsSurplus register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R4052T_StockAdjustmentAsSurplus"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962064 check R5010B_ReconciliationStatement register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5010B_ReconciliationStatement"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962065 check R5011B_CustomersAging register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5011B_CustomersAging"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962066 check R5012B_VendorsAging register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5012B_VendorsAging"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962067 check R5015B_OtherPartnersTransactions register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5015B_OtherPartnersTransactions"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962068 check R5021T_Revenues register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5021T_Revenues"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962069 check R5022T_Expenses register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5022T_Expenses"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962070 check R5041B_TaxesPayable register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R5041B_TaxesPayable"
	Then the number of "List" table lines is "равно" "4"

// Scenario: 962071 check R6010B_BatchWiseBalance register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.R6010B_BatchWiseBalance"
// 	Then the number of "List" table lines is "равно" "4"

Scenario: 962072 check R6020B_BatchBalance register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6020B_BatchBalance"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962073 check R6030T_BatchShortageOutgoing register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6030T_BatchShortageOutgoing"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962074 check R6040T_BatchShortageIncoming register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6040T_BatchShortageIncoming"
	Then the number of "List" table lines is "равно" "2"

// Scenario: 962075 check R6050T_SalesBatches register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.R6050T_SalesBatches"
// 	Then the number of "List" table lines is "равно" "4"

Scenario: 962076 check R6060T_CostOfGoodsSold register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6060T_CostOfGoodsSold"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962077 check R6070T_OtherPeriodsExpenses register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6070T_OtherPeriodsExpenses"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962078 check R6080T_OtherPeriodsRevenues register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R6080T_OtherPeriodsRevenues"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962079 check R7010T_DetailingSupplies register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7010T_DetailingSupplies"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962080 check R7020T_MaterialPlanning register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7020T_MaterialPlanning"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962081 check R7030T_ProductionPlanning register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7030T_ProductionPlanning"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962082 check R7040T_ManualMaterialsCorretionInProduction register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7040T_ManualMaterialsCorretionInProduction"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962083 check R7050T_ProductionDurations register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R7050T_ProductionDurations"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962084 check R8014T_ConsignorSales register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R8014T_ConsignorSales"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962085 check R8015T_ConsignorPrices register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R8015T_ConsignorPrices"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962086 check R9010B_SourceOfOriginStock register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9010B_SourceOfOriginStock"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962087 check R9510B_SalaryPayment register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9510B_SalaryPayment"
	Then the number of "List" table lines is "равно" "4"

// Scenario: 962088 check T1040T_AccountingAmounts register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.T1040T_AccountingAmounts"
// 	Then the number of "List" table lines is "равно" "4"

// Scenario: 962089 check T1050T_AccountingQuantities register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.T1050T_AccountingQuantities"
// 	Then the number of "List" table lines is "равно" "4"

// Scenario: 962090 check TM1010B_RowIDMovements register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1010B_RowIDMovements"
// 	Then the number of "List" table lines is "равно" "4"

// Scenario: 962091 check TM1010T_RowIDMovements register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1010T_RowIDMovements"
// 	Then the number of "List" table lines is "равно" "4"

// Scenario: 962092 check TM1020B_AdvancesKey register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1020B_AdvancesKey"
// 	Then the number of "List" table lines is "равно" "4"

// Scenario: 962093 check TM1030B_TransactionsKey register access (LimitedAccess)
// 	And I close all client application windows
// 	Given I open hyperlink "e1cib/list/AccumulationRegister.TM1030B_TransactionsKey"
// 	Then the number of "List" table lines is "равно" "4"

Scenario: 962094 check R8510B_BookValueOfFixedAsset register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R8510B_BookValueOfFixedAsset"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962095 check R8515T_CostOfFixedAsset register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R8515T_CostOfFixedAsset"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962096 check BranchBankTerms register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.BranchBankTerms"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962099 check CompanyLedgerTypes register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.CompanyLedgerTypes"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962102 check ExpenseRevenueTypeSettings register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.ExpenseRevenueTypeSettings"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962104 check S1001L_VendorsPricesByItemKey register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.S1001L_VendorsPricesByItemKey"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962106 check PricesByItemKeys register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.PricesByItemKeys"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962107 check PricesByItems register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.PricesByItems"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962108 check PricesByProperties register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.PricesByProperties"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962109 check RemainingItemsInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.RemainingItemsInfo"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962110 check RetailWorkers register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.RetailWorkers"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962111 check T2010S_OffsetOfAdvances register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2010S_OffsetOfAdvances"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962112 check T2013S_OffsetOfAging register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2013S_OffsetOfAging"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962113 check T2014S_AdvancesInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2014S_AdvancesInfo"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962114 check T2015S_TransactionsInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2015S_TransactionsInfo"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962115 check T2016S_VendorsAdvancesRelevance register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2016S_VendorsAdvancesRelevance"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962116 check T2017S_CustomersAdvancesRelevance register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T2017S_CustomersAdvancesRelevance"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962116 check T6010S_BatchesInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6010S_BatchesInfo"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962117 check T6020S_BatchKeysInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6020S_BatchKeysInfo"
	Then the number of "List" table lines is "равно" "8"

Scenario: 962118 check T6030S_BatchRelevance register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6030S_BatchRelevance"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962119 check T6040S_BundleAmountValues register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6040S_BundleAmountValues"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962120 check T6050S_ManualBundleAmountValues register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6050S_ManualBundleAmountValues"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962121 check T6060S_BatchCostAllocationInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6060S_BatchCostAllocationInfo"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962122 check T6070S_BatchRevenueAllocationInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6070S_BatchRevenueAllocationInfo"
	Then the number of "List" table lines is "равно" "4"


Scenario: 962124 check T6090S_CompositeBatchesAmountValues register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6090S_CompositeBatchesAmountValues"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962125 check T6095S_WriteOffBatchesInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T6095S_WriteOffBatchesInfo"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962126 check T7010S_BillOfMaterials register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T7010S_BillOfMaterials"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962127 check T7051S_ProductionDurationDetails register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T7051S_ProductionDurationDetails"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962128 check T9010S_AccountsItemKey register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9010S_AccountsItemKey"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962129 check T9011S_AccountsCashAccount register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9011S_AccountsCashAccount"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962130 check T9012S_AccountsPartner register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9012S_AccountsPartner"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962131 check T9013S_AccountsTax register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9013S_AccountsTax"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962132 check T9014S_AccountsExpenseRevenue register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9014S_AccountsExpenseRevenue"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962133 check T9520S_TimeSheetInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T9520S_TimeSheetInfo"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962134 check Taxes register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.Taxes"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962135 check TaxSettings register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.TaxSettings"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962136 check T8510S_FixedAssetsInfo register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T8510S_FixedAssetsInfo"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962137 check T8515S_FixedAssetsLocation register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.T8515S_FixedAssetsLocation"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962138 check R9555T_PaidSickLeaves register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9555T_PaidSickLeaves"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962139 check R9545T_PaidVacations register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9545T_PaidVacations"
	Then the number of "List" table lines is "равно" "2"

Scenario: 962141 check R9560T_AdditionalAccrual register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9560T_AdditionalAccrual"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962142 check R9570T_AdditionalDeduction register access (LimitedAccess)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R9570T_AdditionalDeduction"
	Then the number of "List" table lines is "равно" "4"

Scenario: 962180 LimitedAccessRegisters - AccumulationRegisters R2001T Sales, Do not control Company and Store
	And I close all client application windows
	And I connect "TestAdmin2" TestClient using "LimitedAccessRegisters" login and "" password
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2001T_Sales"
	And "List" table contains lines
		| 'Company'                       | 'Branch'                       |
		| 'Company Read and Write Access' | 'Branch Read and Write Access' |
		| 'Company Only read access'      | 'Branch Read and Write Access' |
		| 'Company Read and Write Access' | 'Branch Only read access'      |
		| 'Company Only read access'      | 'Branch Only read access'      |
		| 'Company Read and Write Access' | 'Branch access deny'           |
		| 'Company Only read access'      | 'Branch access deny'           |
		| 'Company access deny'           | 'Branch access deny'           |
	Then the number of "List" table lines is "равно" "7"
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And "List" table does not contain lines
		| 'Description'                                                                                                                                                         |
		| 'Document.SalesInvoice Branch: Branch Read and Write Access;Company: Company access deny;Store: Store access deny'                                                    |
		| 'Document.SalesInvoice Branch: Branch Read and Write Access;Company: Company access deny;Store: Store Only read access&Store access deny'                             |
		| 'Document.SalesInvoice Branch: Branch Read and Write Access;Company: Company access deny;Store: Store Read and Write Access&Store access deny'                        |
		| 'Document.SalesInvoice Branch: Branch Read and Write Access;Company: Company access deny;Store: Store Read and Write Access&Store Only read access&Store access deny' |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Read and Write Access'                                               |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Only read access'                                                    |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store access deny'                                                         |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Only read access&Store access deny'                                  |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Read and Write Access&Store access deny'                             |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Read and Write Access&Store Only read access&Store access deny'      |
		| 'Document.SalesInvoice Branch: Branch access deny;Company: Company access deny;Store: Store access deny'                                                              |
		| 'Document.SalesInvoice Branch: Branch access deny;Company: Company access deny;Store: Store Only read access&Store access deny'                                       |
		| 'Document.SalesInvoice Branch: Branch access deny;Company: Company access deny;Store: Store Read and Write Access&Store access deny'                                  |
		| 'Document.SalesInvoice Branch: Branch access deny;Company: Company access deny;Store: Store Read and Write Access&Store Only read access&Store access deny'           |
	And I close "TestAdmin" TestClient

Scenario: 962181 LimitedAccessRegisters - AccumulationRegisters R2001T Sales, Company and Branch access deny
	And I close all client application windows
	And I connect "TestAdmin1" TestClient using "LARegAccessDeny" login and "" password
	Given I open hyperlink "e1cib/list/AccumulationRegister.R2001T_Sales"
	Then "List" table contains lines
		| 'Company'                       | 'Branch'                       |
		| 'Company Read and Write Access' | 'Branch Read and Write Access' |
		| 'Company Only read access'      | 'Branch Read and Write Access' |
		| 'Company Read and Write Access' | 'Branch Only read access'      |
		| 'Company Only read access'      | 'Branch Only read access'      |
		| 'Company access deny'           | 'Branch access deny'           |
	Then the number of "List" table lines is "равно" "5"
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And "List" table does not contain lines
		| 'Description'                                                                                                                                                         |
		| 'Document.SalesInvoice Branch: Branch Read and Write Access;Company: Company access deny;Store: Store access deny'                                                    |
		| 'Document.SalesInvoice Branch: Branch Read and Write Access;Company: Company access deny;Store: Store Only read access&Store access deny'                             |
		| 'Document.SalesInvoice Branch: Branch Read and Write Access;Company: Company access deny;Store: Store Read and Write Access&Store access deny'                        |
		| 'Document.SalesInvoice Branch: Branch Read and Write Access;Company: Company access deny;Store: Store Read and Write Access&Store Only read access&Store access deny' |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Read and Write Access'                                               |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Only read access'                                                    |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store access deny'                                                         |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Only read access&Store access deny'                                  |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Read and Write Access&Store access deny'                             |
		| 'Document.SalesInvoice Branch: Branch Only read access;Company: Company access deny;Store: Store Read and Write Access&Store Only read access&Store access deny'      |
		| 'Document.SalesInvoice Branch: Branch access deny;Company: Company access deny;Store: Store access deny'                                                              |
		| 'Document.SalesInvoice Branch: Branch access deny;Company: Company access deny;Store: Store Only read access&Store access deny'                                       |
		| 'Document.SalesInvoice Branch: Branch access deny;Company: Company access deny;Store: Store Read and Write Access&Store access deny'                                  |
		| 'Document.SalesInvoice Branch: Branch access deny;Company: Company access deny;Store: Store Read and Write Access&Store Only read access&Store access deny'           |
	And I close "TestAdmin1" TestClient

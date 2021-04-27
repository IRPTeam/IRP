#language: en
@tree
@Positive
@Test
@BasicFormsCheck

Feature: basic check registers, reports, constants
As an QA
I want to check opening registers, reports and data processor forms

Background:
	Given I launch TestClient opening script or connect the existing one
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"
	And I set "True" value to the constant "NotFirstStart"


Scenario: Open information register form "AddProperties" 

	Given I open "AddProperties" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  AddProperties" exception
	And I close current window



	
Scenario: Open information register form "AttachedFiles" 

	Given I open "AttachedFiles" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  AttachedFiles" exception
	And I close current window



	
Scenario: Open information register form "Barcodes" 

	Given I open "Barcodes" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  Barcodes" exception
	And I close current window



	
Scenario: Open information register form "BundleContents" 

	Given I open "BundleContents" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  BundleContents" exception
	And I close current window



	
Scenario: Open information register form "ChequeBondStatuses" 

	Given I open "ChequeBondStatuses" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ChequeBondStatuses" exception
	And I close current window


	
Scenario: Open information register form "CurrencyRates" 

	Given I open "CurrencyRates" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  CurrencyRates" exception
	And I close current window


	
Scenario: Open information register form "ExternalCommands" 

	Given I open "ExternalCommands" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ExternalCommands" exception
	And I close current window

	
Scenario: Open information register form "IDInfo" 

	Given I open "IDInfo" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  IDInfo" exception
	And I close current window

	
Scenario: Open information register form "IntegrationInfo" 

	Given I open "IntegrationInfo" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  IntegrationInfo" exception
	And I close current window

	
Scenario: Open information register form "ItemSegments" 

	Given I open "ItemSegments" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ItemSegments" exception
	And I close current window


	
Scenario: Open information register form "ObjectStatuses" 

	Given I open "ObjectStatuses" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ObjectStatuses" exception
	And I close current window


	
Scenario: Open information register form "PartnerSegments" 

	Given I open "PartnerSegments" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  PartnerSegments" exception
	And I close current window


	
Scenario: Open information register form "PricesByItemKeys" 

	Given I open "PricesByItemKeys" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  PricesByItemKeys" exception
	And I close current window


	
Scenario: Open information register form "PricesByItems" 

	Given I open "PricesByItems" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  PricesByItems" exception
	And I close current window

	
Scenario: Open information register form "PricesByProperties" 

	Given I open "PricesByProperties" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  PricesByProperties" exception
	And I close current window

	
Scenario: Open information register form "RemainingItemsInfo" 

	Given I open "RemainingItemsInfo" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  RemainingItemsInfo" exception
	And I close current window


	
Scenario: Open information register form "SavedItems" 

	Given I open "SavedItems" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  SavedItems" exception
	And I close current window


	
Scenario: Open information register form "Taxes" 

	Given I open "Taxes" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  Taxes" exception
	And I close current window


	
Scenario: Open information register form "TaxSettings" 

	Given I open "TaxSettings" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  TaxSettings" exception
	And I close current window 

	
Scenario: Open information register form "UserSettings" 

	Given I open "UserSettings" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form  UserSettings" exception
	And I close current window

	
Scenario: Open information register form "SharedReportOptions" 

	Given I open "SharedReportOptions" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form  SharedReportOptions" exception
	And I close current window


	
Scenario: Open information register form "BusinessUnitBankTerms" 

	Given I open "BusinessUnitBankTerms" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  BusinessUnitBankTerms" exception
	And I close current window




	
Scenario: Open list form "AccountsStatement" 

	Given I open "AccountsStatement" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form AccountsStatement" exception
	And I close current window

Scenario: Open object form "AccountsStatement"

	Given I open "AccountsStatement" accumulation register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form AccountsStatement" exception
	And I close current window

	
Scenario: Open list form "AdvanceFromCustomers" 

	Given I open "AdvanceFromCustomers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form AdvanceFromCustomers" exception
	And I close current window

Scenario: Open object form "AdvanceFromCustomers"

	Given I open "AdvanceFromCustomers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form AdvanceFromCustomers" exception
	And I close current window

	
Scenario: Open list form "AdvanceToSuppliers" 

	Given I open "AdvanceToSuppliers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form AdvanceToSuppliers" exception
	And I close current window

Scenario: Open object form "AdvanceToSuppliers"

	Given I open "AdvanceToSuppliers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form AdvanceToSuppliers" exception
	And I close current window

	


	
Scenario: Open list form "CashInTransit" 

	Given I open "CashInTransit" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form CashInTransit" exception
	And I close current window

Scenario: Open object form "CashInTransit"

	Given I open "CashInTransit" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form CashInTransit" exception
	And I close current window

	
Scenario: Open list form "ChequeBondBalance" 

	Given I open "ChequeBondBalance" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form ChequeBondBalance" exception
	And I close current window

Scenario: Open object form "ChequeBondBalance"

	Given I open "ChequeBondBalance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form ChequeBondBalance" exception
	And I close current window

	
Scenario: Open list form "ExpensesTurnovers" 

	Given I open "ExpensesTurnovers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form ExpensesTurnovers" exception
	And I close current window

Scenario: Open object form "ExpensesTurnovers"

	Given I open "ExpensesTurnovers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form ExpensesTurnovers" exception
	And I close current window

	

	
Scenario: Open list form "GoodsReceiptSchedule" 

	Given I open "GoodsReceiptSchedule" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form GoodsReceiptSchedule" exception
	And I close current window

Scenario: Open object form "GoodsReceiptSchedule"

	Given I open "GoodsReceiptSchedule" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form GoodsReceiptSchedule" exception
	And I close current window

	
	

	
Scenario: Open list form "OrderProcurement" 

	Given I open "OrderProcurement" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form OrderProcurement" exception
	And I close current window

Scenario: Open object form "OrderProcurement"

	Given I open "OrderProcurement" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form OrderProcurement" exception
	And I close current window

	
	
Scenario: Open list form "PartnerApTransactions" 

	Given I open "PartnerApTransactions" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form PartnerApTransactions" exception
	And I close current window

Scenario: Open object form "PartnerApTransactions"

	Given I open "PartnerApTransactions" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form PartnerApTransactions" exception
	And I close current window

	
Scenario: Open list form "PartnerArTransactions" 

	Given I open "PartnerArTransactions" accumulation register list form
	If the warning is displayed then
		Then I raise "Failed to open information register form PartnerArTransactions" exception
	And I close current window

Scenario: Open object form "PartnerArTransactions"

	Given I open "PartnerArTransactions" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form PartnerArTransactions" exception
	And I close current window

	
Scenario: Open list form "PlaningCashTransactions" 

	Given I open "PlaningCashTransactions" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form PlaningCashTransactions" exception
	And I close current window

Scenario: Open object form "PlaningCashTransactions"

	Given I open "PlaningCashTransactions" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form PlaningCashTransactions" exception
	And I close current window

	
Scenario: Open list form "PurchaseReturnTurnovers" 

	Given I open "PurchaseReturnTurnovers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form PurchaseReturnTurnovers" exception
	And I close current window

Scenario: Open object form "PurchaseReturnTurnovers"

	Given I open "PurchaseReturnTurnovers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form PurchaseReturnTurnovers" exception
	And I close current window

	


	
Scenario: Open list form "ReceiptOrders" 

	Given I open "ReceiptOrders" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form ReceiptOrders" exception
	And I close current window

Scenario: Open object form "ReceiptOrders"

	Given I open "ReceiptOrders" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form ReceiptOrders" exception
	And I close current window

	


	
Scenario: Open list form "RevenuesTurnovers" 

	Given I open "RevenuesTurnovers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form RevenuesTurnovers" exception
	And I close current window

Scenario: Open object form "RevenuesTurnovers"

	Given I open "RevenuesTurnovers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form RevenuesTurnovers" exception
	And I close current window

	


	
Scenario: Open list form "SalesReturnTurnovers" 

	Given I open "SalesReturnTurnovers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form SalesReturnTurnovers" exception
	And I close current window

Scenario: Open object form "SalesReturnTurnovers"

	Given I open "SalesReturnTurnovers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form SalesReturnTurnovers" exception
	And I close current window

	
Scenario: Open list form "SalesTurnovers" 

	Given I open "SalesTurnovers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form SalesTurnovers" exception
	And I close current window

Scenario: Open object form "SalesTurnovers"

	Given I open "SalesTurnovers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form SalesTurnovers" exception
	And I close current window

	
Scenario: Open list form "ShipmentConfirmationSchedule" 

	Given I open "ShipmentConfirmationSchedule" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form ShipmentConfirmationSchedule" exception
	And I close current window

Scenario: Open object form "ShipmentConfirmationSchedule"

	Given I open "ShipmentConfirmationSchedule" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form ShipmentConfirmationSchedule" exception
	And I close current window

	
Scenario: Open list form "ShipmentOrders" 

	Given I open "ShipmentOrders" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form ShipmentOrders" exception
	And I close current window

Scenario: Open object form "ShipmentOrders"

	Given I open "ShipmentOrders" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form ShipmentOrders" exception
	And I close current window

	


	




	
Scenario: Open list form "TaxesTurnovers" 

	Given I open "TaxesTurnovers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form TaxesTurnovers" exception
	And I close current window

Scenario: Open object form "TaxesTurnovers"

	Given I open "TaxesTurnovers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form TaxesTurnovers" exception
	And I close current window

	



Scenario: Open object form "PriceInfo"

	Given I open "PriceInfo" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form PriceInfo" exception
	And I close current window


Scenario: Open object form "PrintLabels"

	Given I open "PrintLabels" data processor default form
	If the warning is displayed then
		Then I raise "Failed to open data processor form PrintLabels" exception
	And I close current window







Scenario: Open object form "PointOfSale"

	Given I open "PointOfSale" data processor default form 
	If the warning is displayed then
		Then I raise "Failed to open data processor form PointOfSale" exception
	And I close current window

Scenario: Open object form "DataHistory"

	Given I open "DataHistory" data processor default form 
	If the warning is displayed then
		Then I raise "Failed to open data processor form Data history" exception
	And "MetadataTree" table became equal
		| 'Use' | 'Name'                        |
		| 'No'  | 'Catalogs'                    |
		| 'No'  | 'ChartsOfCharacteristicTypes' |
		| 'No'  | 'Constants'                   |
		| 'No'  | 'Documents'                   |
		| 'No'  | 'ExchangePlans'               |
		| 'No'  | 'InformationRegisters'        |
	And I close current window


Scenario: Open object form "Mobile invent"

	Given I open "MobileInvent" data processor default form 
	If the warning is displayed then
		Then I raise "Failed to open data processor form MobileInvent" exception
	And I close current window

Scenario: Open information register form "BarcodeScanInfoCheck" 

	Given I open "BarcodeScanInfoCheck" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form  BarcodeScanInfoCheck" exception
	And I close current window

Scenario: Open information register form "BarcodeScanInfoCheck" 

	Given I open "BarcodeScanInfoCheck" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form  BarcodeScanInfoCheck" exception
	And I close current window

Scenario: Open information register form "DataMappingTable" 

	Given I open "DataMappingTable" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form  DataMappingTable" exception
	And I close current window

Scenario: Open object form "Procurement"

	Given I open "Procurement" data processor default form
	If the warning is displayed then
		Then I raise "Failed to open data processor form Procurement" exception
	And I close current window

Scenario: Open object form "R1001 Purchases"

	Given I open "R1001T_Purchases" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1001T_Purchases" exception
	And I close current window



Scenario: Open object form "R1002T_PurchaseReturns"

	Given I open "R1001T_Purchases" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1002T_PurchaseReturns" exception
	And I close current window



Scenario: Open object form "R1005T_PurchaseSpecialOffers"

	Given I open "R1005T_PurchaseSpecialOffers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1005T_PurchaseSpecialOffers" exception
	And I close current window

Scenario: Open object form "R1010T_PurchaseOrders"

	Given I open "R1010T_PurchaseOrders" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1010T_PurchaseOrders" exception
	And I close current window


Scenario: Open object form "R1011B_PurchaseOrdersReceipt"

	Given I open "R1011B_PurchaseOrdersReceipt" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1011B_PurchaseOrdersReceipt" exception
	And I close current window

Scenario: Open object form "R1012B_PurchaseOrdersInvoiceClosing"

	Given I open "R1012B_PurchaseOrdersInvoiceClosing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1012B_PurchaseOrdersInvoiceClosing" exception
	And I close current window

Scenario: Open object form "R1014T_CanceledPurchaseOrders"

	Given I open "R1014T_CanceledPurchaseOrders" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1014T_CanceledPurchaseOrders" exception
	And I close current window

Scenario: Open object form "R1020B_AdvancesToVendors"

	Given I open "R1020B_AdvancesToVendors" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1020B_AdvancesToVendors" exception
	And I close current window
	

Scenario: Open object form "R1021B_VendorsTransactions"

	Given I open "R1021B_VendorsTransactions" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1021B_VendorsTransactions" exception
	And I close current window

Scenario: Open object form "R1031B_ReceiptInvoicing"

	Given I open "R1031B_ReceiptInvoicing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1031B_ReceiptInvoicing" exception
	And I close current window
	

Scenario: Open object form "R1040B_TaxesOutgoing"

	Given I open "R1040B_TaxesOutgoing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1040B_TaxesOutgoing" exception
	And I close current window

Scenario: Open object form "R2001T_Sales"

	Given I open "R2001T_Sales" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2001T_Sales" exception
	And I close current window

Scenario: Open object form "R2002T_SalesReturns"

	Given I open "R2002T_SalesReturns" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2002T_SalesReturns" exception
	And I close current window

Scenario: Open object form "R2005T_SalesSpecialOffers"

	Given I open "R2005T_SalesSpecialOffers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2005T_SalesSpecialOffers" exception
	And I close current window



Scenario: Open object form "R2010T_SalesOrders"

	Given I open "R2010T_SalesOrders" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2010T_SalesOrders" exception
	And I close current window

Scenario: Open object form "R2011B_SalesOrdersShipment"

	Given I open "R2011B_SalesOrdersShipment" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2011B_SalesOrdersShipment" exception
	And I close current window


Scenario: Open object form "R2012B_SalesOrdersInvoiceClosing"

	Given I open "R2012B_SalesOrdersInvoiceClosing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2012B_SalesOrdersInvoiceClosing" exception
	And I close current window


Scenario: Open object form "R2013T_SalesOrdersProcurement"

	Given I open "R2013T_SalesOrdersProcurement" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2013T_SalesOrdersProcurement" exception
	And I close current window

Scenario: Open object form "R2014T_CanceledSalesOrders"

	Given I open "R2014T_CanceledSalesOrders" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2014T_CanceledSalesOrders" exception
	And I close current window

Scenario: Open object form "R2020B_AdvancesFromCustomers"

	Given I open "R2020B_AdvancesFromCustomers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2020B_AdvancesFromCustomers" exception
	And I close current window


Scenario: Open object form "R2021B_CustomersTransactions"

	Given I open "R2021B_CustomersTransactions" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2021B_CustomersTransactions" exception
	And I close current window

Scenario: Open object form "R2031B_ShipmentInvoicing"

	Given I open "R2031B_ShipmentInvoicing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2031B_ShipmentInvoicing" exception
	And I close current window


Scenario: Open object form "R2040B_TaxesIncoming"

	Given I open "R2040B_TaxesIncoming" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2040B_TaxesIncoming" exception
	And I close current window

Scenario: Open object form "R3010B_CashOnHand"

	Given I open "R3010B_CashOnHand" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3010B_CashOnHand" exception
	And I close current window


Scenario: Open object form "R3011T_CashMovements"

	Given I open "R3011T_CashMovements" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3011T_CashMovements" exception
	And I close current window

Scenario: Open object form "R3015B_CashAdvance"

	Given I open "R3015B_CashAdvance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3015B_CashAdvance" exception
	And I close current window

Scenario: Open object form "R3016B_ChequeAndBonds"

	Given I open "R3016B_ChequeAndBonds" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3016B_ChequeAndBonds" exception
	And I close current window

Scenario: Open object form "R3021B_CashInTransitIncoming"

	Given I open "R3021B_CashInTransitIncoming" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3021B_CashInTransitIncoming" exception
	And I close current window

Scenario: Open object form "R3022B_CashInTransitOutgoing"

	Given I open "R3022B_CashInTransitOutgoing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3022B_CashInTransitOutgoing" exception
	And I close current window

Scenario: Open object form "R3033B_CashPlanningIncoming"

	Given I open "R3033B_CashPlanningIncoming" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3033B_CashPlanningIncoming" exception
	And I close current window

Scenario: Open object form "R3034B_CashPlanningOutgoing"

	Given I open "R3034B_CashPlanningOutgoing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3034B_CashPlanningOutgoing" exception
	And I close current window

Scenario: Open object form "R4010B_ActualStocks"

	Given I open "R4010B_ActualStocks" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4010B_ActualStocks" exception
	And I close current window

Scenario: Open object form "R4011B_FreeStocks"

	Given I open "R4011B_FreeStocks" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4011B_FreeStocks" exception
	And I close current window

Scenario: Open object form "R4012B_StockReservation"

	Given I open "R4012B_StockReservation" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4012B_StockReservation" exception
	And I close current window

Scenario: Open object form "R4013B_StockReservationPlanning"

	Given I open "R4013B_StockReservationPlanning" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4013B_StockReservationPlanning" exception
	And I close current window

Scenario: Open object form "R4015T_InternalSupplyRequests"

	Given I open "R4015T_InternalSupplyRequests" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4015T_InternalSupplyRequests" exception
	And I close current window

Scenario: Open object form "R4016B_InternalSupplyRequestOrdering"

	Given I open "R4016B_InternalSupplyRequestOrdering" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4016B_InternalSupplyRequestOrdering" exception
	And I close current window

Scenario: Open object form "R4017B_InternalSupplyRequestProcurement"

	Given I open "R4017B_InternalSupplyRequestProcurement" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4017B_InternalSupplyRequestProcurement" exception
	And I close current window

Scenario: Open object form "R4020T_StockTransferOrders"

	Given I open "R4020T_StockTransferOrders" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4020T_StockTransferOrders" exception
	And I close current window

Scenario: Open object form "R4021B_StockTransferOrdersReceipt"

	Given I open "R4021B_StockTransferOrdersReceipt" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4021B_StockTransferOrdersReceipt" exception
	And I close current window

Scenario: Open object form "R4022B_StockTransferOrdersShipment"

	Given I open "R4022B_StockTransferOrdersShipment" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4022B_StockTransferOrdersShipment" exception
	And I close current window

Scenario: Open object form "R4031B_GoodsInTransitIncoming"

	Given I open "R4031B_GoodsInTransitIncoming" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4031B_GoodsInTransitIncoming" exception
	And I close current window

Scenario: Open object form "R4032B_GoodsInTransitOutgoing"

	Given I open "R4032B_GoodsInTransitOutgoing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4032B_GoodsInTransitOutgoing" exception
	And I close current window

Scenario: Open object form "R4033B_GoodsReceiptSchedule"

	Given I open "R4033B_GoodsReceiptSchedule" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4033B_GoodsReceiptSchedule" exception
	And I close current window

Scenario: Open object form "R4034B_GoodsShipmentSchedule"

	Given I open "R4034B_GoodsShipmentSchedule" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4034B_GoodsShipmentSchedule" exception
	And I close current window

Scenario: Open object form "R4035B_IncommingStocks"

	Given I open "R4035B_IncomingStocks" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4035B_IncommingStocks" exception
	And I close current window

Scenario: Open object form "R4036B_IncommingStocksRequested"

	Given I open "R4036B_IncomingStocksRequested" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4036B_IncommingStocksRequested" exception
	And I close current window

Scenario: Open object form "R4050B_StockInventory"

	Given I open "R4050B_StockInventory" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4050B_StockInventory" exception
	And I close current window

Scenario: Open object form "R4051T_StockAdjustmentAsWriteOff"

	Given I open "R4051T_StockAdjustmentAsWriteOff" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4051T_StockAdjustmentAsWriteOff" exception
	And I close current window

Scenario: Open object form "R4052T_StockAdjustmentAsSurplus"

	Given I open "R4052T_StockAdjustmentAsSurplus" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R4052T_StockAdjustmentAsSurplus" exception
	And I close current window

Scenario: Open object form "R5010B_ReconciliationStatement"

	Given I open "R5010B_ReconciliationStatement" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R5010B_ReconciliationStatement" exception
	And I close current window

Scenario: Open object form "R5011B_PartnersAging"

	Given I open "R5011B_PartnersAging" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R5011B_PartnersAging" exception
	And I close current window

Scenario: Open object form "R5021T_Revenues"

	Given I open "R5021T_Revenues" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R5021T_Revenues" exception
	And I close current window

Scenario: Open object form "R5022T_Expenses"

	Given I open "R5022T_Expenses" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R5022T_Expenses" exception
	And I close current window

Scenario: Open object form "R5041B_TaxesPayable"

	Given I open "R5041B_TaxesPayable" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R5041B_TaxesPayable" exception
	And I close current window

Scenario: Open object form "Analise document movements"

	Given I open "AnaliseDocumentMovements" data processor default form 
	If the warning is displayed then
		Then I raise "Failed to open data processor form PointOfSale" exception
	And in the table "Info" I click "Fill movements" button
	Then system warning window does not appear
	And "Info" table contains lines
		| 'Document'    | 'Register'                       | 
		| 'BankPayment' | 'R1021B_VendorsTransactions'     | 
		| 'BankPayment' | 'R5010B_ReconciliationStatement' | 
		| 'BankPayment' | 'R1020B_AdvancesToVendors'       | 
	And I close all client application windows

Scenario: Open object form "All registers movement"

	Given I open "AllRegistersMovement" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form AllRegistersMovemen" exception
	And I click "Run report" button		
	Then system warning window does not appear
	And I close all client application windows
	

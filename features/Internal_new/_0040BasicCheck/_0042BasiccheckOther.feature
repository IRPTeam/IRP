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
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
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



Scenario: Open list form "AccountBalance" 

	Given I open "AccountBalance" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form AccountBalance" exception
	And I close current window

Scenario: Open object form "AccountBalance"

	Given I open "AccountBalance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form AccountBalance" exception
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

	
Scenario: Open list form "CashAdvance" 

	Given I open "CashAdvance" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form CashAdvance" exception
	And I close current window

Scenario: Open object form "CashAdvance"

	Given I open "CashAdvance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form CashAdvance" exception
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

	
Scenario: Open list form "GoodsInTransitIncoming" 

	Given I open "GoodsInTransitIncoming" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form GoodsInTransitIncoming" exception
	And I close current window

Scenario: Open object form "GoodsInTransitIncoming"

	Given I open "GoodsInTransitIncoming" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form GoodsInTransitIncoming" exception
	And I close current window

	
Scenario: Open list form "GoodsInTransitOutgoing" 

	Given I open "GoodsInTransitOutgoing" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form GoodsInTransitOutgoing" exception
	And I close current window

Scenario: Open object form "GoodsInTransitOutgoing"

	Given I open "GoodsInTransitOutgoing" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form GoodsInTransitOutgoing" exception
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

	
Scenario: Open list form "InventoryBalance" 

	Given I open "InventoryBalance" accumulation register list form
	If the warning is displayed then
		Then I raise "Failed to open information register form InventoryBalance" exception
	And I close current window

Scenario: Open object form "InventoryBalance"

	Given I open "InventoryBalance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form InventoryBalance" exception
	And I close current window

	
Scenario: Open list form "ItemsInStores" 

	Given I open "ItemsInStores" accumulation register list form 
	If the warning is displayed then 
		Then I raise "Failed to open information register form ItemsInStores" exception
	And I close current window

Scenario: Open object form "ItemsInStores"

	Given I open "ItemsInStores" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form ItemsInStores" exception
	And I close current window

	
Scenario: Open list form "OrderBalance" 

	Given I open "OrderBalance" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form OrderBalance" exception
	And I close current window

Scenario: Open object form "OrderBalance"

	Given I open "OrderBalance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form OrderBalance" exception
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

	
Scenario: Open list form "OrderReservation" 

	Given I open "OrderReservation" accumulation register list form
	If the warning is displayed then
		Then I raise "Failed to open information register form OrderReservation" exception
	And I close current window

Scenario: Open object form "OrderReservation"

	Given I open "OrderReservation" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form OrderReservation" exception
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

	
Scenario: Open list form "PurchaseTurnovers" 

	Given I open "PurchaseTurnovers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form PurchaseTurnovers" exception
	And I close current window

Scenario: Open object form "PurchaseTurnovers"

	Given I open "PurchaseTurnovers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form PurchaseTurnovers" exception
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

	
Scenario: Open list form "ReconciliationStatement" 

	Given I open "ReconciliationStatement" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form ReconciliationStatement" exception
	And I close current window

Scenario: Open object form "ReconciliationStatement"

	Given I open "ReconciliationStatement" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form ReconciliationStatement" exception
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

	
Scenario: Open list form "SalesOrderTurnovers" 

	Given I open "SalesOrderTurnovers" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form SalesOrderTurnovers" exception
	And I close current window

Scenario: Open object form "SalesOrderTurnovers"

	Given I open "SalesOrderTurnovers" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form SalesOrderTurnovers" exception
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

	
Scenario: Open list form "StockAdjustmentAsSurplus" 

	Given I open "StockAdjustmentAsSurplus" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form StockAdjustmentAsSurplus" exception
	And I close current window

Scenario: Open object form "StockAdjustmentAsSurplus"

	Given I open "StockAdjustmentAsSurplus" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form StockAdjustmentAsSurplus" exception
	And I close current window

	
Scenario: Open list form "StockAdjustmentAsWriteOff" 

	Given I open "StockAdjustmentAsWriteOff" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form StockAdjustmentAsWriteOff" exception
	And I close current window

Scenario: Open object form "StockAdjustmentAsWriteOff"

	Given I open "StockAdjustmentAsWriteOff" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form StockAdjustmentAsWriteOff" exception
	And I close current window

	
Scenario: Open list form "StockBalance" 

	Given I open "StockBalance" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form StockBalance" exception
	And I close current window

Scenario: Open object form "StockBalance"

	Given I open "StockBalance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form StockBalance" exception
	And I close current window

	
Scenario: Open list form "StockReservation" 

	Given I open "StockReservation" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form StockReservation" exception
	And I close current window

Scenario: Open object form "StockReservation"

	Given I open "StockReservation" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form StockReservation" exception
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

	
Scenario: Open list form "TransferOrderBalance" 

	Given I open "TransferOrderBalance" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form TransferOrderBalance" exception
	And I close current window

Scenario: Open object form "TransferOrderBalance"

	Given I open "TransferOrderBalance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form TransferOrderBalance" exception
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


Scenario: Open object form "QuantityCompare"

	Given I open "QuantityCompare" data processor default form 
	If the warning is displayed then
		Then I raise "Failed to open data processor form QuantityCompare" exception
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

Scenario: Open object form "Desktop"

	Given I open "Desktop" data processor default form 
	If the warning is displayed then
		Then I raise "Failed to open data processor form Desktop" exception
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
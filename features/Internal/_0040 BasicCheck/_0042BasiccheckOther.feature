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
	
	

Scenario: preparation
	When set True value to the constant
	When set True value to the constant Use accounting
	When Create catalog AccessGroups and AccessProfiles objects (Full access + Accounting reports)
	Given I open hyperlink "e1cib/data/Catalog.AccessGroups?ref=b7c3b7b1d5c014d211ef53224a7fb945"
	And I move to "Users" tab
	And in the table "Users" I click the button named "UsersAdd"
	And I select "ci" from "User" drop-down list by string in "Users" table
	And I finish line editing in "Users" table	
	And I click "Save and close" button
	And I close TestClient session
	And I open new TestClient session or connect the existing one
	* Add VA extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description"     |
				| "VAExtension"     |
			When add VAExtension

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

Scenario: Open information register form "T2010S_OffsetOfAdvances" 

	Given I open "T2010S_OffsetOfAdvances" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form T2010S_OffsetOfAdvances" exception
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


	
Scenario: Open information register form "BranchBankTerms" 

	Given I open "BranchBankTerms" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  BranchBankTerms" exception
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



	


	

	
	

	
Scenario: Open list form "R3035T_CashPlanning" 

	Given I open "R3035T_CashPlanning" accumulation register list form 
	If the warning is displayed then
		Then I raise "Failed to open information register form R3035T_CashPlanning" exception
	And I close current window

Scenario: Open object form "R3035T_CashPlanning"

	Given I open "R3035T_CashPlanning" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3035T_CashPlanning" exception
	And I close current window


Scenario: Open object form "D0011_PriceInfo"

	Given I open "D0011_PriceInfo" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form D0011_PriceInfo" exception
	And I close current window


Scenario: Open object form "PrintLabels"

	Given I open "PrintLabels" data processor default form
	If the warning is displayed then
		Then I raise "Failed to open data processor form PrintLabels" exception
	And I close current window

Scenario: Open object form "A0013_AccountAnalysis"

	Given I open "A0013_AccountAnalysis" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form A0013_AccountAnalysis" exception
	And I close current window

Scenario: Open object form "A0012_AccountCard"

	Given I open "A0012_AccountCard" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form A0012_AccountCard" exception
	And I close current window

Scenario: Open object form "A0010_TrialBalance"

	Given I open "A0010_TrialBalance" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form A0010_TrialBalance" exception
	And I close current window

Scenario: Open object form "A0011_TrialBalanceByAccount"

	Given I open "A0011_TrialBalanceByAccount" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form A0011_TrialBalanceByAccount" exception
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
		| 'Use'  | 'Name'                          |
		| 'No'   | 'Catalogs'                      |
		| 'No'   | 'ChartsOfAccounts'              |
		| 'No'   | 'ChartsOfCharacteristicTypes'   |
		| 'No'   | 'Constants'                     |
		| 'No'   | 'Documents'                     |
		| 'No'   | 'ExchangePlans'                 |
		| 'No'   | 'InformationRegisters'          |
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


Scenario: Open object form "R3011T_CashFlow"

	Given I open "R3011T_CashFlow" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3011T_CashFlow" exception
	And I close current window

Scenario: Open object form "R3015B_CashAdvance"

	Given I open "R3015B_CashAdvance" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R3015B_CashAdvance" exception
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

Scenario: Open object form "R5011B_CustomersAging"

	Given I open "R5011B_CustomersAging" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R5011B_CustomersAging" exception
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

Scenario: Open object form "R1022B_VendorsPaymentPlanning"

	Given I open "R1022B_VendorsPaymentPlanning" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R1022B_VendorsPaymentPlanning" exception
	And I close current window

Scenario: Open object form "R2022B_CustomersPaymentPlanning"

	Given I open "R2022B_CustomersPaymentPlanning" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form R2022B_CustomersPaymentPlanning" exception
	And I close current window

Scenario: Open object form "T9500S_AccrualAndDeductionValues"

	Given I open "T9500S_AccrualAndDeductionValues" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form T9500S_AccrualAndDeductionValues" exception
	And I close current window

Scenario: Open object form "T9510S_Staffing"

	Given I open "T9510S_Staffing" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form T9510S_Staffing" exception
	And I close current window

Scenario: Open object form "T9530S_WorkDays"

	Given I open "T9530S_WorkDays" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form T9530S_WorkDays" exception
	And I close current window

Scenario: Open object form "Analise document movements"

	Given I open "AnaliseDocumentMovements" data processor default form 
	If the warning is displayed then
		Then I raise "Failed to open data processor form PointOfSale" exception
	And in the table "Info" I click "Fill movements" button
	Then system warning window does not appear
	And "Info" table contains lines
		| 'Document'     | 'Register'                         |
		| 'BankPayment'  | 'R1021B_VendorsTransactions'       |
		| 'BankPayment'  | 'R5010B_ReconciliationStatement'   |
		| 'BankPayment'  | 'R1020B_AdvancesToVendors'         |
	And I close all client application windows

Scenario: Open object form "D0009_DocumentRegistrationsReport"

	Given I open "D0009_DocumentRegistrationsReport" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form D0009_DocumentRegistrationsReport" exception
	And I click "Generate report" button		
	Then system warning window does not appear
	And I close all client application windows
	
Scenario: Open choise form "CustomUserSettings"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("ChartOfCharacteristicTypes.CustomUserSettings.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open ChartsOfCharacteristicTypes choise form CustomUserSettings" exception
	And I close current window

Scenario: Open object form "T1040 Accounting amounts"

	Given I open "T1040T_AccountingAmounts" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open accounting register form T1040 Accounting amounts" exception
	And I close current window


Scenario: Open object form "T1050 Accounting quantities"

	Given I open "T1050T_AccountingQuantities" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open accounting register form T1050 Accounting quantities" exception
	And I close current window
	

Scenario: Open information register form "ChequeBondStatuses" 

	Given I open "ChequeBondStatuses" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ChequeBondStatuses" exception
	And I close current window


Scenario: Open object form "R7010_DetailingSupplies"

	Given I open "R7010_DetailingSupplies" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form R7010_DetailingSupplies" exception
	And I close current window

Scenario: Open object form "R7030_ProductionPlanning"

	Given I open "R7030_ProductionPlanning" report default form
	If the warning is displayed then
		Then I raise "Failed to open report form R7030_ProductionPlanning" exception
	And I close current window

Scenario: Open object form "ProductionWorkspace"

	Given I open "ProductionWorkspace" data processor default form
	If the warning is displayed then
		Then I raise "Failed to open ext data proc form ProductionWorkspace" exception
	And I close current window

Scenario: Open list form "R7010T_DetailingSupplies" 

	Given I open "R7010T_DetailingSupplies" accumulation register list form
	If the warning is displayed then
		Then I raise "Failed to open register form R7010T_DetailingSupplies" exception
	And I close current window

Scenario: Open object form "R7010T_DetailingSupplies"

	Given I open "R7010T_DetailingSupplies" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open register form R7010T_DetailingSupplies" exception
	And I close current window

Scenario: Open list form "R7040T_ManualMaterialsCorretionInProduction" 

	Given I open "R7040T_ManualMaterialsCorretionInProduction" accumulation register list form
	If the warning is displayed then
		Then I raise "Failed to open register form R7040T_ManualMaterialsCorretionInProduction" exception
	And I close current window

Scenario: Open object form "R7040T_ManualMaterialsCorretionInProduction"

	Given I open "R7040T_ManualMaterialsCorretionInProduction" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open register form R7040T_ManualMaterialsCorretionInProduction" exception
	And I close current window

	Scenario: Open list form "R7020T_MaterialPlanning" 

	Given I open "R7020T_MaterialPlanning" accumulation register list form
	If the warning is displayed then
		Then I raise "Failed to open register form R7020T_MaterialPlanning" exception
	And I close current window

Scenario: Open object form "R7020T_MaterialPlanning"

	Given I open "R7020T_MaterialPlanning" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open register form R7020T_MaterialPlanning" exception
	And I close current window

Scenario: Open list form "R7030T_ProductionPlanning" 

	Given I open "R7030T_ProductionPlanning" accumulation register list form
	If the warning is displayed then
		Then I raise "Failed to open register form R7030T_ProductionPlanning" exception
	And I close current window

Scenario: Open object form "R7030T_ProductionPlanning"

	Given I open "R7030T_ProductionPlanning" accumulation register default form
	If the warning is displayed then
		Then I raise "Failed to open register form R7030T_ProductionPlanning" exception
	And I close current window

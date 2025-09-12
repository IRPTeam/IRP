
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Documents - ListForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening the List form Documents "Additional accrual" (AdditionalAccrual)

	Given I open "AdditionalAccrual" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents AdditionalAccrual" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents AdditionalAccrual" exception
	And I close current window

Scenario: Opening the List form Documents "Additional cost allocation" (AdditionalCostAllocation)

	Given I open "AdditionalCostAllocation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents AdditionalCostAllocation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents AdditionalCostAllocation" exception
	And I close current window

Scenario: Opening the List form Documents "Additional deduction" (AdditionalDeduction)

	Given I open "AdditionalDeduction" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents AdditionalDeduction" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents AdditionalDeduction" exception
	And I close current window

Scenario: Opening the List form Documents "Additional revenue allocation" (AdditionalRevenueAllocation)

	Given I open "AdditionalRevenueAllocation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents AdditionalRevenueAllocation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents AdditionalRevenueAllocation" exception
	And I close current window

Scenario: Opening the List form Documents "Bank payment" (BankPayment)

	Given I open "BankPayment" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents BankPayment" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents BankPayment" exception
	And I close current window

Scenario: Opening the List form Documents "Bank receipt" (BankReceipt)

	Given I open "BankReceipt" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents BankReceipt" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents BankReceipt" exception
	And I close current window

Scenario: Opening the List form Documents "Batch reallocate incoming" (BatchReallocateIncoming)

	Given I open "BatchReallocateIncoming" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents BatchReallocateIncoming" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents BatchReallocateIncoming" exception
	And I close current window

Scenario: Opening the List form Documents "Batch reallocate outgoing" (BatchReallocateOutgoing)

	Given I open "BatchReallocateOutgoing" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents BatchReallocateOutgoing" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents BatchReallocateOutgoing" exception
	And I close current window

Scenario: Opening the List form Documents "Bundling" (Bundling)

	Given I open "Bundling" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents Bundling" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents Bundling" exception
	And I close current window

Scenario: Opening the List form Documents "Calculation deserved vacations" (CalculationDeservedVacations)

	Given I open "CalculationDeservedVacations" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CalculationDeservedVacations" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CalculationDeservedVacations" exception
	And I close current window

Scenario: Opening the List form Documents "Calculation movement costs" (CalculationMovementCosts)

	Given I open "CalculationMovementCosts" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CalculationMovementCosts" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CalculationMovementCosts" exception
	And I close current window

Scenario: Opening the List form Documents "Cash expense" (CashExpense)

	Given I open "CashExpense" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CashExpense" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CashExpense" exception
	And I close current window

Scenario: Opening the List form Documents "Cash payment" (CashPayment)

	Given I open "CashPayment" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CashPayment" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CashPayment" exception
	And I close current window

Scenario: Opening the List form Documents "Cash receipt" (CashReceipt)

	Given I open "CashReceipt" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CashReceipt" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CashReceipt" exception
	And I close current window

Scenario: Opening the List form Documents "Cash revenue" (CashRevenue)

	Given I open "CashRevenue" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CashRevenue" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CashRevenue" exception
	And I close current window

Scenario: Opening the List form Documents "Cash statement" (CashStatement)

	Given I open "CashStatement" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CashStatement" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CashStatement" exception
	And I close current window

Scenario: Opening the List form Documents "Cash transfer order" (CashTransferOrder)

	Given I open "CashTransferOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CashTransferOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CashTransferOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Cheque bond transaction" (ChequeBondTransaction)

	Given I open "ChequeBondTransaction" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ChequeBondTransaction" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ChequeBondTransaction" exception
	And I close current window

Scenario: Opening the List form Documents "Cheque bond transaction item" (ChequeBondTransactionItem)

	Given I open "ChequeBondTransactionItem" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ChequeBondTransactionItem" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ChequeBondTransactionItem" exception
	And I close current window

Scenario: Opening the List form Documents "Commissioning of fixed asset" (CommissioningOfFixedAsset)

	Given I open "CommissioningOfFixedAsset" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CommissioningOfFixedAsset" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CommissioningOfFixedAsset" exception
	And I close current window

Scenario: Opening the List form Documents "Consolidated retail sales" (ConsolidatedRetailSales)

	Given I open "ConsolidatedRetailSales" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ConsolidatedRetailSales" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ConsolidatedRetailSales" exception
	And I close current window

Scenario: Opening the List form Documents "Credit note" (CreditNote)

	Given I open "CreditNote" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CreditNote" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CreditNote" exception
	And I close current window

Scenario: Opening the List form Documents "Customers advances closing" (CustomersAdvancesClosing)

	Given I open "CustomersAdvancesClosing" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents CustomersAdvancesClosing" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents CustomersAdvancesClosing" exception
	And I close current window

Scenario: Opening the List form Documents "Debit note" (DebitNote)

	Given I open "DebitNote" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents DebitNote" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents DebitNote" exception
	And I close current window

Scenario: Opening the List form Documents "Decommissioning of fixed asset" (DecommissioningOfFixedAsset)

	Given I open "DecommissioningOfFixedAsset" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents DecommissioningOfFixedAsset" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents DecommissioningOfFixedAsset" exception
	And I close current window

Scenario: Opening the List form Documents "Depreciation calculation" (DepreciationCalculation)

	Given I open "DepreciationCalculation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents DepreciationCalculation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents DepreciationCalculation" exception
	And I close current window

Scenario: Opening the List form Documents "Employee cash advance" (EmployeeCashAdvance)

	Given I open "EmployeeCashAdvance" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents EmployeeCashAdvance" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents EmployeeCashAdvance" exception
	And I close current window

Scenario: Opening the List form Documents "Employee firing" (EmployeeFiring)

	Given I open "EmployeeFiring" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents EmployeeFiring" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents EmployeeFiring" exception
	And I close current window

Scenario: Opening the List form Documents "Employee hiring" (EmployeeHiring)

	Given I open "EmployeeHiring" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents EmployeeHiring" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents EmployeeHiring" exception
	And I close current window

Scenario: Opening the List form Documents "Employee sick leave" (EmployeeSickLeave)

	Given I open "EmployeeSickLeave" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents EmployeeSickLeave" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents EmployeeSickLeave" exception
	And I close current window

Scenario: Opening the List form Documents "Employee transfer" (EmployeeTransfer)

	Given I open "EmployeeTransfer" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents EmployeeTransfer" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents EmployeeTransfer" exception
	And I close current window

Scenario: Opening the List form Documents "Employee vacation" (EmployeeVacation)

	Given I open "EmployeeVacation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents EmployeeVacation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents EmployeeVacation" exception
	And I close current window

Scenario: Opening the List form Documents "Fixed asset transfer" (FixedAssetTransfer)

	Given I open "FixedAssetTransfer" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents FixedAssetTransfer" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents FixedAssetTransfer" exception
	And I close current window

Scenario: Opening the List form Documents "Foreign currency revaluation" (ForeignCurrencyRevaluation)

	Given I open "ForeignCurrencyRevaluation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ForeignCurrencyRevaluation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ForeignCurrencyRevaluation" exception
	And I close current window

Scenario: Opening the List form Documents "Goods receipt" (GoodsReceipt)

	Given I open "GoodsReceipt" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents GoodsReceipt" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents GoodsReceipt" exception
	And I close current window

Scenario: Opening the List form Documents "Incoming payment order" (IncomingPaymentOrder)

	Given I open "IncomingPaymentOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents IncomingPaymentOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents IncomingPaymentOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Internal supply request" (InternalSupplyRequest)

	Given I open "InternalSupplyRequest" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents InternalSupplyRequest" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents InternalSupplyRequest" exception
	And I close current window

Scenario: Opening the List form Documents "Inventory transfer" (InventoryTransfer)

	Given I open "InventoryTransfer" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents InventoryTransfer" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents InventoryTransfer" exception
	And I close current window

Scenario: Opening the List form Documents "Inventory transfer order" (InventoryTransferOrder)

	Given I open "InventoryTransferOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents InventoryTransferOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents InventoryTransferOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Item stock adjustment" (ItemStockAdjustment)

	Given I open "ItemStockAdjustment" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ItemStockAdjustment" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ItemStockAdjustment" exception
	And I close current window

Scenario: Opening the List form Documents "Journal entry" (JournalEntry)

	Given I open "JournalEntry" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents JournalEntry" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents JournalEntry" exception
	And I close current window

Scenario: Opening the List form Documents "Labeling" (Labeling)

	Given I open "Labeling" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents Labeling" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents Labeling" exception
	And I close current window

Scenario: Opening the List form Documents "Manual register entry" (ManualRegisterEntry)

	Given I open "ManualRegisterEntry" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ManualRegisterEntry" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ManualRegisterEntry" exception
	And I close current window

Scenario: Opening the List form Documents "Modernization of fixed asset" (ModernizationOfFixedAsset)

	Given I open "ModernizationOfFixedAsset" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ModernizationOfFixedAsset" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ModernizationOfFixedAsset" exception
	And I close current window

Scenario: Opening the List form Documents "Money transfer" (MoneyTransfer)

	Given I open "MoneyTransfer" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents MoneyTransfer" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents MoneyTransfer" exception
	And I close current window

Scenario: Opening the List form Documents "Opening entry" (OpeningEntry)

	Given I open "OpeningEntry" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents OpeningEntry" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents OpeningEntry" exception
	And I close current window

Scenario: Opening the List form Documents "Outgoing payment order" (OutgoingPaymentOrder)

	Given I open "OutgoingPaymentOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents OutgoingPaymentOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents OutgoingPaymentOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Payroll" (Payroll)

	Given I open "Payroll" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents Payroll" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents Payroll" exception
	And I close current window

Scenario: Opening the List form Documents "Physical count by location" (PhysicalCountByLocation)

	Given I open "PhysicalCountByLocation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PhysicalCountByLocation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PhysicalCountByLocation" exception
	And I close current window

Scenario: Opening the List form Documents "Physical inventory" (PhysicalInventory)

	Given I open "PhysicalInventory" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PhysicalInventory" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PhysicalInventory" exception
	And I close current window

Scenario: Opening the List form Documents "Planned receipt reservation" (PlannedReceiptReservation)

	Given I open "PlannedReceiptReservation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PlannedReceiptReservation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PlannedReceiptReservation" exception
	And I close current window

Scenario: Opening the List form Documents "Price list" (PriceList)

	Given I open "PriceList" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PriceList" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PriceList" exception
	And I close current window

Scenario: Opening the List form Documents "Production" (Production)

	Given I open "Production" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents Production" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents Production" exception
	And I close current window

Scenario: Opening the List form Documents "Production costs allocation" (ProductionCostsAllocation)

	Given I open "ProductionCostsAllocation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ProductionCostsAllocation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ProductionCostsAllocation" exception
	And I close current window

Scenario: Opening the List form Documents "Production planning" (ProductionPlanning)

	Given I open "ProductionPlanning" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ProductionPlanning" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ProductionPlanning" exception
	And I close current window

Scenario: Opening the List form Documents "Production planning closing" (ProductionPlanningClosing)

	Given I open "ProductionPlanningClosing" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ProductionPlanningClosing" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ProductionPlanningClosing" exception
	And I close current window

Scenario: Opening the List form Documents "Production planning correction" (ProductionPlanningCorrection)

	Given I open "ProductionPlanningCorrection" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ProductionPlanningCorrection" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ProductionPlanningCorrection" exception
	And I close current window

Scenario: Opening the List form Documents "Purchase invoice" (PurchaseInvoice)

	Given I open "PurchaseInvoice" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PurchaseInvoice" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PurchaseInvoice" exception
	And I close current window

Scenario: Opening the List form Documents "Purchase order" (PurchaseOrder)

	Given I open "PurchaseOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PurchaseOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PurchaseOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Purchase order closing" (PurchaseOrderClosing)

	Given I open "PurchaseOrderClosing" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PurchaseOrderClosing" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PurchaseOrderClosing" exception
	And I close current window

Scenario: Opening the List form Documents "Purchase return" (PurchaseReturn)

	Given I open "PurchaseReturn" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PurchaseReturn" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PurchaseReturn" exception
	And I close current window

Scenario: Opening the List form Documents "Purchase return order" (PurchaseReturnOrder)

	Given I open "PurchaseReturnOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents PurchaseReturnOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents PurchaseReturnOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Reconciliation statement" (ReconciliationStatement)

	Given I open "ReconciliationStatement" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ReconciliationStatement" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ReconciliationStatement" exception
	And I close current window

Scenario: Opening the List form Documents "Retail goods receipt" (RetailGoodsReceipt)

	Given I open "RetailGoodsReceipt" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents RetailGoodsReceipt" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents RetailGoodsReceipt" exception
	And I close current window

Scenario: Opening the List form Documents "Retail receipt correction" (RetailReceiptCorrection)

	Given I open "RetailReceiptCorrection" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents RetailReceiptCorrection" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents RetailReceiptCorrection" exception
	And I close current window

Scenario: Opening the List form Documents "Retail return receipt" (RetailReturnReceipt)

	Given I open "RetailReturnReceipt" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents RetailReturnReceipt" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents RetailReturnReceipt" exception
	And I close current window

Scenario: Opening the List form Documents "Retail sales receipt" (RetailSalesReceipt)

	Given I open "RetailSalesReceipt" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents RetailSalesReceipt" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents RetailSalesReceipt" exception
	And I close current window

Scenario: Opening the List form Documents "Retail shipment confirmation" (RetailShipmentConfirmation)

	Given I open "RetailShipmentConfirmation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents RetailShipmentConfirmation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents RetailShipmentConfirmation" exception
	And I close current window

Scenario: Opening the List form Documents "Sales invoice" (SalesInvoice)

	Given I open "SalesInvoice" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents SalesInvoice" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents SalesInvoice" exception
	And I close current window

Scenario: Opening the List form Documents "Sales order" (SalesOrder)

	Given I open "SalesOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents SalesOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents SalesOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Sales order closing" (SalesOrderClosing)

	Given I open "SalesOrderClosing" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents SalesOrderClosing" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents SalesOrderClosing" exception
	And I close current window

Scenario: Opening the List form Documents "Sales report from trade agent" (SalesReportFromTradeAgent)

	Given I open "SalesReportFromTradeAgent" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents SalesReportFromTradeAgent" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents SalesReportFromTradeAgent" exception
	And I close current window

Scenario: Opening the List form Documents "Sales report to consignor" (SalesReportToConsignor)

	Given I open "SalesReportToConsignor" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents SalesReportToConsignor" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents SalesReportToConsignor" exception
	And I close current window

Scenario: Opening the List form Documents "Sales return" (SalesReturn)

	Given I open "SalesReturn" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents SalesReturn" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents SalesReturn" exception
	And I close current window


Scenario: Opening the List form Documents "Sales return order" (SalesReturnOrder)

	Given I open "SalesReturnOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents SalesReturnOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents SalesReturnOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Shipment confirmation" (ShipmentConfirmation)

	Given I open "ShipmentConfirmation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ShipmentConfirmation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ShipmentConfirmation" exception
	And I close current window

Scenario: Opening the List form Documents "Stock adjustment as surplus" (StockAdjustmentAsSurplus)

	Given I open "StockAdjustmentAsSurplus" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents StockAdjustmentAsSurplus" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents StockAdjustmentAsSurplus" exception
	And I close current window

Scenario: Opening the List form Documents "Stock adjustment as write-off" (StockAdjustmentAsWriteOff)

	Given I open "StockAdjustmentAsWriteOff" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents StockAdjustmentAsWriteOff" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents StockAdjustmentAsWriteOff" exception
	And I close current window

Scenario: Opening the List form Documents "Time sheet" (TimeSheet)

	Given I open "TimeSheet" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents TimeSheet" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents TimeSheet" exception
	And I close current window

Scenario: Opening the List form Documents "Unbundling" (Unbundling)

	Given I open "Unbundling" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents Unbundling" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents Unbundling" exception
	And I close current window

Scenario: Opening the List form Documents "Vendors advances closing" (VendorsAdvancesClosing)

	Given I open "VendorsAdvancesClosing" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents VendorsAdvancesClosing" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents VendorsAdvancesClosing" exception
	And I close current window

Scenario: Opening the List form Documents "Visitor counter" (VisitorCounter)

	Given I open "VisitorCounter" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents VisitorCounter" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents VisitorCounter" exception
	And I close current window

Scenario: Opening the List form Documents "Work order" (WorkOrder)

	Given I open "WorkOrder" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents WorkOrder" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents WorkOrder" exception
	And I close current window

Scenario: Opening the List form Documents "Work order closing" (WorkOrderClosing)

	Given I open "WorkOrderClosing" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents WorkOrderClosing" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents WorkOrderClosing" exception
	And I close current window

Scenario: Opening the List form Documents "Work sheet" (WorkSheet)

	Given I open "WorkSheet" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents WorkSheet" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents WorkSheet" exception
	And I close current window

Scenario: Opening the List form Documents "Debit/Credit note" (DebitCreditNote)

	Given I open "DebitCreditNote" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents DebitCreditNote" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents DebitCreditNote" exception
	And I close current window

Scenario: Opening the List form Documents "Expense accruals" (ExpenseAccruals)

	Given I open "ExpenseAccruals" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents ExpenseAccruals" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents ExpenseAccruals" exception
	And I close current window

Scenario: Opening the List form Documents "Revenue accruals" (RevenueAccruals)

	Given I open "RevenueAccruals" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents RevenueAccruals" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents RevenueAccruals" exception
	And I close current window

Scenario: Opening the List form Documents "Outgoing message" (OutgoingMessage)

	Given I open "OutgoingMessage" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents OutgoingMessage" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents OutgoingMessage" exception
	And I close current window

Scenario: Opening the List form Documents "Taxes operation" (TaxesOperation)

	Given I open "TaxesOperation" document default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Documents TaxesOperation" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Documents TaxesOperation" exception
	And I close current window

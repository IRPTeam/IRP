
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Documents - ObjectForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Open choise form "TimeSheet"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.TimeSheet.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form TimeSheet" exception
	And I close current window


Scenario: Open choise form "EmployeeFiring"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.EmployeeFiring.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form EmployeeFiring" exception
	And I close current window

Scenario: Open choise form "EmployeeHiring"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.EmployeeHiring.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form EmployeeHiring" exception
	And I close current window

Scenario: Open choise form "EmployeeSickLeave"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.EmployeeSickLeave.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form EmployeeSickLeave" exception
	And I close current window

Scenario: Open choise form "EmployeeTransfer"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.EmployeeTransfer.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form EmployeeTransfer" exception
	And I close current window

Scenario: Open choise form "EmployeeVacation"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.EmployeeVacation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form EmployeeVacation" exception
	And I close current window

Scenario: Open choise form "VisitorCounter"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.VisitorCounter.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form VisitorCounter" exception
	And I close current window

Scenario: Open choise form "ProductionCostsAllocation"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.ProductionCostsAllocation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form ProductionCostsAllocation" exception
	And I close current window

Scenario: Open choise form "EmployeeCashAdvance"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.EmployeeCashAdvance.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form EmployeeCashAdvance" exception
	And I close current window

Scenario: Open choise form "ForeignCurrencyRevaluation"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.ForeignCurrencyRevaluation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form ForeignCurrencyRevaluation" exception
	And I close current window

Scenario: Open choise form "Payroll"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.Payroll.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form Payroll" exception
	And I close current window

Scenario: Open choise form "SalesReportToConsignor"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.SalesReportToConsignor.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form SalesReportToConsignor" exception
	And I close current window

Scenario: Open choise form "SalesReportFromTradeAgent"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.SalesReportFromTradeAgent.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form SalesReportFromTradeAgent" exception
	And I close current window

Scenario: Open choise form "WorkOrder"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.WorkOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form WorkOrder" exception
	And I close current window

Scenario: Open choise form "WorkSheet"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.WorkSheet.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form WorkSheet" exception
	And I close current window

Scenario: Open choise form "ChequeBondTransaction"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.ChequeBondTransaction.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form ChequeBondTransaction" exception
	And I close current window

Scenario: Open choise form "CashStatement"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.CashStatement.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form CashStatement" exception
	And I close current window

Scenario: Open choise form "ReconsiliationStatement"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.ReconciliationStatement.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form ReconsiliationStatement" exception
	And I close current window

Scenario: Open choise form "GoodsReceipt"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.GoodsReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form GoodsReceipt" exception
	And I close current window

Scenario: Open choise form "RetailReturnReceipt"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.RetailReturnReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form RetailReturnReceipt" exception
	And I close current window

Scenario: Open choise form "CreditNote"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.CreditNote.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form CreditNote" exception
	And I close current window

Scenario: Open choise form "DeditNote"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.DebitNote.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form DeditNote" exception
	And I close current window

Scenario: Open choise form "BankReceipt"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.BankReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form BankReceipt" exception
	And I close current window

Scenario: Open choise form "PurchaseReturn"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.PurchaseReturn.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form PurchaseReturn" exception
	And I close current window

Scenario: Open choise form "ShipmentConfirmation"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.ShipmentConfirmation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form ShipmentConfirmation" exception
	And I close current window

Scenario: Open choise form "CashReceipt"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.CashReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form CashReceipt" exception
	And I close current window

Scenario: Open choise form "BankPayment"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.BankPayment.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form BankPayment" exception
	And I close current window

Scenario: Open choise form "Labeling"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.Labeling.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form Labeling" exception
	And I close current window

Scenario: Open choise form "StockAdjustmentAsWriteOff"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.StockAdjustmentAsWriteOff.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form StockAdjustmentAsWriteOff" exception
	And I close current window

Scenario: Open choise form "StockAdjustmentAsSurplus"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.StockAdjustmentAsSurplus.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form StockAdjustmentAsSurplus" exception
	And I close current window

Scenario: Open choise form "OpeningEntry"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.OpeningEntry.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form OpeningEntry" exception
	And I close current window

Scenario: Open choise form "CashExpense"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.CashExpense.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form CashExpense" exception
	And I close current window

Scenario: Open choise form "IncomingPaymentOrder"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.IncomingPaymentOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form IncomingPaymentOrder" exception
	And I close current window

Scenario: Open choise form "OutgoingPaymentOrder"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.OutgoingPaymentOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form OutgoingPaymentOrder" exception
	And I close current window

Scenario: Open choise form "Bundling"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.Bundling.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form Bundling" exception
	And I close current window

Scenario: Open choise form "CashPayment"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.CashPayment.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form CashPayment" exception
	And I close current window

Scenario: Open choise form "PhysicalInventory"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.PhysicalInventory.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form PhysicalInventory" exception
	And I close current window

Scenario: Open choise form "Unbundling"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.Unbundling.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form Unbundling" exception
	And I close current window

Scenario: Open choise form "CashRevenue"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.CashRevenue.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form CashRevenue" exception
	And I close current window

Scenario: Open choise form "ItemStockAdjustment"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.ItemStockAdjustment.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form ItemStockAdjustment" exception
	And I close current window

Scenario: Open choise form "ManualRegisterEntry"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.ItemStockAdjustment.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form ManualRegisterEntry" exception
	And I close current window

Scenario: Open choise form "SalesOrderClosing"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.SalesOrderClosing.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form SalesOrderClosing" exception
	And I close current window

Scenario: Open choise form "PlannedReceiptReservation"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.PlannedReceiptReservation.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form PlannedReceiptReservation" exception
	And I close current window

Scenario: Open choise form "PurchaseOrderClosing"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.PurchaseOrderClosing.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form PurchaseOrderClosing" exception
	And I close current window


Scenario: Open choise form "JournalEntry"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.JournalEntry.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form JournalEntry" exception
	And I close current window

Scenario: Open choise form "MoneyTransfer"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.MoneyTransfer.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form MoneyTransfer" exception
	And I close current window

Scenario: Open choise form "RetailSalesReceipt"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.RetailSalesReceipt.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form RetailSalesReceipt" exception
	And I close current window

Scenario: Open choise form "SalesInvoice"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.SalesInvoice.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form SalesInvoice" exception
	And I close current window

Scenario: Open choise form "PurchaseOrder"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.PurchaseOrder.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form PurchaseOrder" exception
	And I close current window

Scenario: Open choise form "VisitorCounter"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.VisitorCounter.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form VisitorCounter" exception
	And I close current window

Scenario: Open choise form "DebitCreditNote"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.DebitCreditNote.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form DebitCreditNote" exception
	And I close current window

Scenario: Open choise form "ExpenseAccruals"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.ExpenseAccruals.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form ExpenseAccruals" exception
	And I close current window

Scenario: Open choise form "RevenueAccruals"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Document.RevenueAccruals.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open document choise form RevenueAccruals" exception
	And I close current window
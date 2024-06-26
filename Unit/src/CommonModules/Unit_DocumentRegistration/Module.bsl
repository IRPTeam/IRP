
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("DocumentRegistration");	
	Return TestList;
EndFunction

#EndRegion

#Region Test

Function DocumentRegistration() Export
	ArrayOfErrors = New Array();
	
	_DocumentReistration(ArrayOfErrors);
	
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Document registration errors: " + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Procedure _DocumentReistration(ArrayOfErrors)
	
	Ignored_Documents = GeIgnored_Documents();
	Ignored_Fields = GetIgnored_Fields();
	
	For Each DocMetadata In Metadata.Documents Do
		
		If Ignored_Documents.Find(DocMetadata.Name) <> Undefined Then
			Continue;
		EndIf;
		
		Info = Documents[DocMetadata.Name].GetInformationAboutMovements(Documents[DocMetadata.Name].EmptyRef());
		
		If Not Info.QueryTextsMasterTables.Count() Then
			Continue;
		EndIf;
				
		QuerySchema = New QuerySchema();
		QuerySchema.SetQueryText(StrConcat(Info.QueryTextsMasterTables, ";"));
		
		For Each Batch In QuerySchema.QueryBatch Do
			If TypeOf(Batch) <> Type("QuerySchemaSelectQuery") Then
				Continue;
			EndIf;
			
			For Each Reg In DocMetadata.RegisterRecords Do
				
				NameSegments = StrSplit(Reg.Name, "_");
				If NameSegments.Count() = 2 And StrLen(NameSegments[0]) = 2 Then
					Continue; // register from extension
				EndIf;
	
				If Upper(Batch.PlacementTable) <> Upper(Reg.Name) Then
					Continue;
				EndIf;
				
				Compare_BatchColumns_And_RegFields(ArrayOfErrors, 
				                                   Ignored_Fields, 
				                                   Batch.Columns, 
				                                   Reg.Dimensions, 
				                                   DocMetadata.Name, 
				                                   Reg.Name, 
				                                   "Dimension");
				
				Compare_BatchColumns_And_RegFields(ArrayOfErrors, 
				                                   Ignored_Fields, 
				                                   Batch.Columns, 
				                                   Reg.Resources, 
				                                   DocMetadata.Name, 
				                                   Reg.Name, 
				                                   "Resource");
				
				Compare_BatchColumns_And_RegFields(ArrayOfErrors, 
				                                   Ignored_Fields, 
				                                   Batch.Columns, 
				                                   Reg.StandardAttributes, 
				                                   DocMetadata.Name, 
				                                   Reg.Name, 
				                                   "Standard attributes");
				
			EndDo;
	   EndDo;
	EndDo;
EndProcedure 

Procedure PutFieldsToArray(ArrayOfFields, Ignored_Fields, Key1, Key2);
	If Ignored_Fields[Key1] <> Undefined And Ignored_Fields[Key1][Key2] <> Undefined Then
		For Each ArrayItem In Ignored_Fields[Key1][Key2] Do
			ArrayOfFields.Add(ArrayItem);
		EndDo;
	EndIf;
EndProcedure
			
Procedure Compare_BatchColumns_And_RegFields(ArrayOfErrors, 
											 Ignored_Fields,
	                                         BatchColumns, 
	                                         RegFields, 
	                                         DocName,
	                                         RegName,
	                                         FieldPresentation)
	For Each Field In RegFields Do
		
		If IsIgnored_Field(Ignored_Fields, DocName, RegName, Field.Name) Then
			Continue;
		EndIf;
		
		If BatchColumns.Find(Field.Name) = Undefined Then
			ArrayOfErrors.Add(StrTemplate("Document[%1]: Register[%2]: %3[%4]", DocName, RegName, FieldPresentation, Field.Name));
		EndIf;
	EndDo;		
EndProcedure

Function IsIgnored_Field(Ignored_Fields, DocName, RegName, FieldName)
	If StrStartsWith(FieldName, "DELETE_") Then
		Return True;
	EndIf;
	
	ArrayOfFields = New Array();
			
	PutFieldsToArray(ArrayOfFields, Ignored_Fields, DocName, RegName);
	PutFieldsToArray(ArrayOfFields, Ignored_Fields, DocName, "*");
	PutFieldsToArray(ArrayOfFields, Ignored_Fields, "*",     RegName);
	PutFieldsToArray(ArrayOfFields, Ignored_Fields, "*",     "*");
			
	For Each ItemOfArray In ArrayOfFields Do 
		If ItemOfArray = "*" Then
			_FieldName = FieldName;
		Else
			_FieldName = ItemOfArray;
		EndIf;
		
		If _FieldName = FieldName Then
			Return True;
		EndIf;
		
	EndDo;
	
	Return False;
EndFunction

Function GeIgnored_Documents()
	Array = New Array();
//	Array.Add("OpeningEntry");
	Array.Add("VendorsAdvancesClosing");
	Array.Add("CustomersAdvancesClosing");
	Array.Add("ForeignCurrencyRevaluation");
	Return Array;
EndFunction

Function GetIgnored_Fields()
	Array = New Array();
	
	// Document.Register.Dimension * - for all
	
	// standard attributes
	Array.Add("*.*.Active");
	Array.Add("*.*.LineNumber");
	Array.Add("*.*.Recorder");
	
	// technical dimensions
	Array.Add("*.*.CurrencyMovementType");
	Array.Add("*.*.TransactionCurrency");
	Array.Add("*.*.RevaluatedCurrency");
	Array.Add("*.T2014S_AdvancesInfo.Key");
	Array.Add("*.T2014S_AdvancesInfo.UniqueID");
	Array.Add("*.T2015S_TransactionsInfo.UniqueID");
	Array.Add("*.T3010S_RowIDInfo.UniqueID");
	Array.Add("*.T1040T_AccountingAmounts.DrCurrency");
	Array.Add("*.T1040T_AccountingAmounts.CrCurrency");
	Array.Add("*.T1040T_AccountingAmounts.DrCurrencyAmount");
	Array.Add("*.T1040T_AccountingAmounts.CrCurrencyAmount");
		
	// technical registers
	Array.Add("*.T6020S_BatchKeysInfo.*");
	Array.Add("*.T6010S_BatchesInfo.*");
	
	// excludes
	Array.Add("Payroll.R5021T_Revenues.ItemKey");
	Array.Add("Payroll.R5021T_Revenues.AdditionalAnalytic");
	Array.Add("Payroll.R5021T_Revenues.Project");

	Array.Add("Payroll.R5022T_Expenses.ItemKey");
	Array.Add("Payroll.R5022T_Expenses.FixedAsset");
	Array.Add("Payroll.R5022T_Expenses.LedgerType");
	Array.Add("Payroll.R5022T_Expenses.AdditionalAnalytic");
	Array.Add("Payroll.R5022T_Expenses.Project");
	
	Array.Add("BankPayment.R5022T_Expenses.ItemKey");
	Array.Add("BankPayment.R5022T_Expenses.FixedAsset");
	Array.Add("BankPayment.R5022T_Expenses.LedgerType");
	
	Array.Add("BankReceipt.R5021T_Revenues.ItemKey");
	Array.Add("BankReceipt.R5021T_Revenues.AdditionalAnalytic");
	
	Array.Add("Production.R4010B_ActualStocks.SerialLotNumber");
	
	Array.Add("WorkSheet.R5022T_Expenses.FixedAsset");
	Array.Add("WorkSheet.R5022T_Expenses.LedgerType");

	Array.Add("StockAdjustmentAsWriteOff.R5022T_Expenses.FixedAsset");
	Array.Add("StockAdjustmentAsWriteOff.R5022T_Expenses.LedgerType");
	
	// temporarily until refactoring (query contains *)
	Array.Add("AdditionalCostAllocation.R6070T_OtherPeriodsExpenses.*");
	Array.Add("AdditionalCostAllocation.T6060S_BatchCostAllocationInfo.*");

	Array.Add("AdditionalRevenueAllocation.R6080T_OtherPeriodsRevenues.*");
	Array.Add("AdditionalRevenueAllocation.T6070S_BatchRevenueAllocationInfo.*");
	
	Array.Add("CashPayment.R3010B_CashOnHand.*");
	Array.Add("CashPayment.R5010B_ReconciliationStatement.*");
	Array.Add("CashPayment.R3015B_CashAdvance.*");
	
	Array.Add("CashReceipt.R3010B_CashOnHand.*");
	Array.Add("CashReceipt.R5010B_ReconciliationStatement.*");
	Array.Add("CashReceipt.R3015B_CashAdvance.*");
	
	Array.Add("CashExpense.R3010B_CashOnHand.*");
	Array.Add("CashExpense.R5022T_Expenses.*");
	Array.Add("CashExpense.R3027B_EmployeeCashAdvance.*");
	
	Array.Add("CashRevenue.R3010B_CashOnHand.*");
	Array.Add("CashRevenue.R3027B_EmployeeCashAdvance.*");
	Array.Add("CashRevenue.R5021T_Revenues.*");
	
	Array.Add("ChequeBondTransactionItem.R3016B_ChequeAndBonds.*");
	Array.Add("ChequeBondTransactionItem.R3035T_CashPlanning.*");
	
	Array.Add("DepreciationCalculation.R8510B_BookValueOfFixedAsset.*");
	Array.Add("DepreciationCalculation.R5022T_Expenses.*");
	
	Array.Add("EmployeeCashAdvance.R5022T_Expenses.*");
	
	Array.Add("SalesReturn.R2005T_SalesSpecialOffers.*");
	Array.Add("SalesReturn.R2012B_SalesOrdersInvoiceClosing.*");
	Array.Add("SalesReturn.R4014B_SerialLotNumber.*");
	Array.Add("SalesReturn.R4031B_GoodsInTransitIncoming.*");
	Array.Add("SalesReturn.R5021T_Revenues.*");
	
	Array.Add("StockAdjustmentAsSurplus.R4011B_FreeStocks.*");
	Array.Add("StockAdjustmentAsSurplus.R4014B_SerialLotNumber.*");
	Array.Add("StockAdjustmentAsSurplus.R4052T_StockAdjustmentAsSurplus.*");

	Array.Add("StockAdjustmentAsWriteOff.R4011B_FreeStocks.*");
	Array.Add("StockAdjustmentAsWriteOff.R4014B_SerialLotNumber.*");
	Array.Add("StockAdjustmentAsWriteOff.R4051T_StockAdjustmentAsWriteOff.*");
	
	Array.Add("ShipmentConfirmation.R2011B_SalesOrdersShipment.*");
	Array.Add("ShipmentConfirmation.R2013T_SalesOrdersProcurement.*");
	Array.Add("ShipmentConfirmation.R4014B_SerialLotNumber.*");
	Array.Add("ShipmentConfirmation.R4022B_StockTransferOrdersShipment.*");
	Array.Add("ShipmentConfirmation.R4032B_GoodsInTransitOutgoing.*");
	Array.Add("ShipmentConfirmation.R4034B_GoodsShipmentSchedule.*");
	
	Array.Add("CommissioningOfFixedAsset.R4014B_SerialLotNumber.Store");

	Array.Add("DecommissioningOfFixedAsset.R4011B_FreeStocks.*");
	Array.Add("DecommissioningOfFixedAsset.R4014B_SerialLotNumber.*");

	Array.Add("CreditNote.R5010B_ReconciliationStatement.*");
	Array.Add("CreditNote.R5022T_Expenses.*");
	
	Array.Add("DebitNote.R5010B_ReconciliationStatement.*");
	Array.Add("DebitNote.R5021T_Revenues.*");

	Array.Add("GoodsReceipt.R1011B_PurchaseOrdersReceipt.*");
	Array.Add("GoodsReceipt.R2013T_SalesOrdersProcurement.*");
	Array.Add("GoodsReceipt.R4014B_SerialLotNumber.*");
	Array.Add("GoodsReceipt.R4017B_InternalSupplyRequestProcurement.*");
	Array.Add("GoodsReceipt.R4021B_StockTransferOrdersReceipt.*");
	Array.Add("GoodsReceipt.R4031B_GoodsInTransitIncoming.*");
	Array.Add("GoodsReceipt.R4033B_GoodsReceiptSchedule.*");
	Array.Add("GoodsReceipt.R4035B_IncomingStocks.*");
	Array.Add("GoodsReceipt.R4036B_IncomingStocksRequested.*");

	Array.Add("InventoryTransfer.R4014B_SerialLotNumber.*");
	Array.Add("InventoryTransfer.R4036B_IncomingStocksRequested.*");
	Array.Add("InventoryTransfer.R4021B_StockTransferOrdersReceipt.*");
	Array.Add("InventoryTransfer.R4022B_StockTransferOrdersShipment.*");

	Array.Add("InventoryTransferOrder.R4016B_InternalSupplyRequestOrdering.*");
	Array.Add("InventoryTransferOrder.R4020T_StockTransferOrders.*");
	Array.Add("InventoryTransferOrder.R4021B_StockTransferOrdersReceipt.*");
	Array.Add("InventoryTransferOrder.R4022B_StockTransferOrdersShipment.*");

	Array.Add("ItemStockAdjustment.R4010B_ActualStocks.*");
	Array.Add("ItemStockAdjustment.R4014B_SerialLotNumber.*");
	Array.Add("ItemStockAdjustment.R4051T_StockAdjustmentAsWriteOff.*");
	Array.Add("ItemStockAdjustment.R4052T_StockAdjustmentAsSurplus.*");
	
	Array.Add("ProductionPlanning.R4035B_IncomingStocks.*");
	Array.Add("ProductionPlanning.R7010T_DetailingSupplies.*");
	Array.Add("ProductionPlanning.R7020T_MaterialPlanning.*");
	Array.Add("ProductionPlanning.R7030T_ProductionPlanning.*");
	Array.Add("ProductionPlanning.T7010S_BillOfMaterials.*");

	Array.Add("ProductionPlanningCorrection.R4035B_IncomingStocks.*");
	Array.Add("ProductionPlanningCorrection.R7010T_DetailingSupplies.*");
	Array.Add("ProductionPlanningCorrection.R7020T_MaterialPlanning.*");
	Array.Add("ProductionPlanningCorrection.R7030T_ProductionPlanning.*");
	Array.Add("ProductionPlanningCorrection.T7010S_BillOfMaterials.*");

	Array.Add("PurchaseInvoice.R1001T_Purchases.*");
	Array.Add("PurchaseInvoice.R1005T_PurchaseSpecialOffers.*");
	Array.Add("PurchaseInvoice.R1011B_PurchaseOrdersReceipt.*");
	Array.Add("PurchaseInvoice.R1012B_PurchaseOrdersInvoiceClosing.*");
	Array.Add("PurchaseInvoice.R4014B_SerialLotNumber.*");
	Array.Add("PurchaseInvoice.R4017B_InternalSupplyRequestProcurement.*");
	Array.Add("PurchaseInvoice.R4031B_GoodsInTransitIncoming.*");
	Array.Add("PurchaseInvoice.R4035B_IncomingStocks.*");
	Array.Add("PurchaseInvoice.R4036B_IncomingStocksRequested.*");
	Array.Add("PurchaseInvoice.R5022T_Expenses.*");
	Array.Add("PurchaseInvoice.R6070T_OtherPeriodsExpenses.*");

	Array.Add("PurchaseOrder.R1010T_PurchaseOrders.*");
	Array.Add("PurchaseOrder.R1011B_PurchaseOrdersReceipt.*");
	Array.Add("PurchaseOrder.R1012B_PurchaseOrdersInvoiceClosing.*");
	Array.Add("PurchaseOrder.R1014T_CanceledPurchaseOrders.*");
	Array.Add("PurchaseOrder.R4016B_InternalSupplyRequestOrdering.*");
	Array.Add("PurchaseOrder.R4033B_GoodsReceiptSchedule.*");
	
	Array.Add("ModernizationOfFixedAsset.R4011B_FreeStocks.*");
	Array.Add("ModernizationOfFixedAsset.R4014B_SerialLotNumber.*");
	
	Array.Add("PurchaseReturn.R1001T_Purchases.*");
	Array.Add("PurchaseReturn.R1002T_PurchaseReturns.*");
	Array.Add("PurchaseReturn.R1005T_PurchaseSpecialOffers.*");
	Array.Add("PurchaseReturn.R1012B_PurchaseOrdersInvoiceClosing.*");
	Array.Add("PurchaseReturn.R4014B_SerialLotNumber.*");
	Array.Add("PurchaseReturn.R4032B_GoodsInTransitOutgoing.*");
	Array.Add("PurchaseReturn.R5022T_Expenses.*");

	Array.Add("PurchaseReturnOrder.R1010T_PurchaseOrders.*");
	Array.Add("PurchaseReturnOrder.R1012B_PurchaseOrdersInvoiceClosing.*");

	Array.Add("RetailGoodsReceipt.R4014B_SerialLotNumber.*");

	Array.Add("RetailReturnReceipt.R2005T_SalesSpecialOffers.*");
	Array.Add("RetailReturnReceipt.R2050T_RetailSales.*");
	Array.Add("RetailReturnReceipt.R3050T_PosCashBalances.*");
	Array.Add("RetailReturnReceipt.R4011B_FreeStocks.*");
	Array.Add("RetailReturnReceipt.R4014B_SerialLotNumber.*");
	Array.Add("RetailReturnReceipt.R5021T_Revenues.*");
	
	Array.Add("BankReceipt.R5022T_Expenses.*");

	Array.Add("Production.R4035B_IncomingStocks.*");
	Array.Add("Production.R4036B_IncomingStocksRequested.*");
	Array.Add("Production.R7040T_ManualMaterialsCorretionInProduction.*");

	Array.Add("RetailSalesReceipt.R2005T_SalesSpecialOffers.*");
	Array.Add("RetailSalesReceipt.R2050T_RetailSales.*");
	Array.Add("RetailSalesReceipt.R3050T_PosCashBalances.*");
	Array.Add("RetailSalesReceipt.R4014B_SerialLotNumber.*");
	Array.Add("RetailSalesReceipt.R4032B_GoodsInTransitOutgoing.*");
	Array.Add("RetailSalesReceipt.R5021T_Revenues.*");

	Array.Add("SalesInvoice.R2005T_SalesSpecialOffers.*");
	Array.Add("SalesInvoice.R2011B_SalesOrdersShipment.*");
	Array.Add("SalesInvoice.R4014B_SerialLotNumber.*");
	Array.Add("SalesInvoice.R4032B_GoodsInTransitOutgoing.*");
	Array.Add("SalesInvoice.R4034B_GoodsShipmentSchedule.*");
	Array.Add("SalesInvoice.R5021T_Revenues.*");
	Array.Add("SalesInvoice.R6080T_OtherPeriodsRevenues.*");

	Array.Add("SalesOrder.R2010T_SalesOrders.*");
	Array.Add("SalesOrder.R2011B_SalesOrdersShipment.*");
	Array.Add("SalesOrder.R2012B_SalesOrdersInvoiceClosing.*");
	Array.Add("SalesOrder.R2014T_CanceledSalesOrders.*");
	Array.Add("SalesOrder.R4011B_FreeStocks.*");
	Array.Add("SalesOrder.R4012B_StockReservation.*");
	Array.Add("SalesOrder.R4034B_GoodsShipmentSchedule.*");
	Array.Add("SalesOrder.R4037B_PlannedReceiptReservationRequests.*");

	Array.Add("SalesReportFromTradeAgent.R5021T_Revenues.*");
	
	Array.Add("WorkOrder.R4011B_FreeStocks.*");
	Array.Add("WorkOrder.R4012B_StockReservation.*");

	Array.Add("SalesReturnOrder.R2010T_SalesOrders.*");
	Array.Add("SalesReturnOrder.R2012B_SalesOrdersInvoiceClosing.*");
	
	Array.Add("PhysicalInventory.R4010B_ActualStocks.*");
	Array.Add("PhysicalInventory.R4011B_FreeStocks.*");
	
	// maybe bugs
	Array.Add("ChequeBondTransactionItem.R1020B_AdvancesToVendors.Project");
	Array.Add("ChequeBondTransactionItem.R1021B_VendorsTransactions.Project");
	Array.Add("ChequeBondTransactionItem.R2020B_AdvancesFromCustomers.Project");
	Array.Add("ChequeBondTransactionItem.R2021B_CustomersTransactions.Project");

	Array.Add("DebitCreditNote.R1020B_AdvancesToVendors.Order");
	Array.Add("DebitCreditNote.R2020B_AdvancesFromCustomers.Order");
	Array.Add("DebitCreditNote.T2015S_TransactionsInfo.Key");
	
	Array.Add("PurchaseInvoice.T2015S_TransactionsInfo.Key");
	Array.Add("PurchaseInvoice.T2015S_TransactionsInfo.IsCustomerTransaction");
	
	Array.Add("PurchaseOrderClosing.T2014S_AdvancesInfo.IsCustomerAdvance");

	Array.Add("PurchaseReturn.R1021B_VendorsTransactions.Order");
	Array.Add("PurchaseReturn.T2015S_TransactionsInfo.Order");
	Array.Add("PurchaseReturn.T2015S_TransactionsInfo.Key");
	Array.Add("PurchaseReturn.T2015S_TransactionsInfo.IsCustomerTransaction");

	Array.Add("RetailReturnReceipt.R2021B_CustomersTransactions.Order");
	Array.Add("RetailReturnReceipt.R2021B_CustomersTransactions.Project");
	Array.Add("RetailReturnReceipt.R3011T_CashFlow.PlanningPeriod");
	
	Array.Add("BankPayment.R2021B_CustomersTransactions.Order");
	Array.Add("BankPayment.R5015B_OtherPartnersTransactions.Basis");

	Array.Add("BankReceipt.R1021B_VendorsTransactions.Order");

	Array.Add("RetailSalesReceipt.R2021B_CustomersTransactions.Project");
	Array.Add("RetailSalesReceipt.R3011T_CashFlow.PlanningPeriod");
	Array.Add("RetailSalesReceipt.T2015S_TransactionsInfo.Date");
	Array.Add("RetailSalesReceipt.T2015S_TransactionsInfo.Key");
	Array.Add("RetailSalesReceipt.T2015S_TransactionsInfo.IsVendorTransaction");
	Array.Add("RetailSalesReceipt.T2015S_TransactionsInfo.Project");
	Array.Add("RetailReturnReceipt.R5015B_OtherPartnersTransactions.Basis");

	Array.Add("SalesInvoice.T2015S_TransactionsInfo.Key");
	Array.Add("SalesInvoice.T2015S_TransactionsInfo.IsVendorTransaction");

	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.RowKey");
	Array.Add("SalesOrderClosing.T2014S_AdvancesInfo.IsVendorAdvance");

	Array.Add("SalesReportFromTradeAgent.R2001T_Sales.SalesPerson");
	Array.Add("SalesReportFromTradeAgent.T2015S_TransactionsInfo.Key");
	Array.Add("SalesReportFromTradeAgent.T2015S_TransactionsInfo.IsVendorTransaction");
	
	Array.Add("WorkSheet.R4010B_ActualStocks.SerialLotNumber");
	Array.Add("WorkSheet.R5022T_Expenses.Project");
	Array.Add("WorkSheet.R5022T_Expenses.AdditionalAnalytic");

	Array.Add("SalesReturn.R2021B_CustomersTransactions.Order");
	Array.Add("SalesReturn.T2015S_TransactionsInfo.Order");
	Array.Add("SalesReturn.T2015S_TransactionsInfo.Key");
	Array.Add("SalesReturn.T2015S_TransactionsInfo.IsVendorTransaction");

	Array.Add("SalesReportToConsignor.T2015S_TransactionsInfo.Key");
	Array.Add("SalesReportToConsignor.T2015S_TransactionsInfo.IsCustomerTransaction");

	Array.Add("StockAdjustmentAsSurplus.R5021T_Revenues.AdditionalAnalytic");
	Array.Add("StockAdjustmentAsSurplus.R5021T_Revenues.Project");
	Array.Add("StockAdjustmentAsSurplus.R4031B_GoodsInTransitIncoming.Basis");

	Array.Add("StockAdjustmentAsWriteOff.R5022T_Expenses.AdditionalAnalytic");
	Array.Add("StockAdjustmentAsWriteOff.R5022T_Expenses.Project");
	Array.Add("StockAdjustmentAsWriteOff.R4032B_GoodsInTransitOutgoing.Basis");
	
	Array.Add("PhysicalInventory.R4032B_GoodsInTransitOutgoing.Basis");
	Array.Add("PhysicalInventory.R4031B_GoodsInTransitIncoming.Basis");
	Array.Add("PlannedReceiptReservation.R4037B_PlannedReceiptReservationRequests.ItemKey");

	Array.Add("Bundling.R4010B_ActualStocks.SerialLotNumber");

	Array.Add("Unbundling.R4010B_ActualStocks.SerialLotNumber");

	Array.Add("CashPayment.R2021B_CustomersTransactions.Order");
	Array.Add("CashPayment.R5015B_OtherPartnersTransactions.Basis");

	Array.Add("CashReceipt.R1021B_VendorsTransactions.Order");
	Array.Add("CashReceipt.R3026B_SalesOrdersCustomerAdvance.PaymentType");
	Array.Add("CashReceipt.R3026B_SalesOrdersCustomerAdvance.PaymentTerminal");
	Array.Add("CashReceipt.R3026B_SalesOrdersCustomerAdvance.BankTerm");
	Array.Add("CashReceipt.R5015B_OtherPartnersTransactions.Basis");

	Array.Add("CashStatement.R3011T_CashFlow.PlanningPeriod");
	Array.Add("CashStatement.R3035T_CashPlanning.Partner");
	Array.Add("CashStatement.R3035T_CashPlanning.LegalName");
	Array.Add("CashStatement.R3035T_CashPlanning.PlanningPeriod");

	Array.Add("CashTransferOrder.R3035T_CashPlanning.Partner");
	Array.Add("CashTransferOrder.R3035T_CashPlanning.LegalName");
	Array.Add("ChequeBondTransactionItem.T2015S_TransactionsInfo.Key");

	Array.Add("MoneyTransfer.R3011T_CashFlow.PlanningPeriod");
	Array.Add("MoneyTransfer.R3035T_CashPlanning.Partner");
	Array.Add("MoneyTransfer.R3035T_CashPlanning.LegalName");
	Array.Add("MoneyTransfer.T1040T_AccountingAmounts.RowKey");
	
	// resources
	
	Array.Add("BankPayment.R3050T_PosCashBalances.Commission");
	Array.Add("BankPayment.R5022T_Expenses.AmountCost");
	Array.Add("BankPayment.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("BankPayment.T2014S_AdvancesInfo.IsSalesOrderClose");
	Array.Add("BankPayment.T2015S_TransactionsInfo.IsDue");

	Array.Add("BankReceipt.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("BankReceipt.T2014S_AdvancesInfo.IsSalesOrderClose");
	Array.Add("BankReceipt.T2015S_TransactionsInfo.IsDue");

	Array.Add("CashPayment.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("CashPayment.T2014S_AdvancesInfo.IsSalesOrderClose");
	Array.Add("CashPayment.T2015S_TransactionsInfo.IsDue");

	Array.Add("CashReceipt.R3026B_SalesOrdersCustomerAdvance.Commission");
	Array.Add("CashReceipt.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("CashReceipt.T2014S_AdvancesInfo.IsSalesOrderClose");
	Array.Add("CashReceipt.T2015S_TransactionsInfo.IsDue");

	Array.Add("ChequeBondTransactionItem.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("ChequeBondTransactionItem.T2014S_AdvancesInfo.IsSalesOrderClose");
	Array.Add("ChequeBondTransactionItem.T2015S_TransactionsInfo.IsDue");

	Array.Add("CreditNote.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("CreditNote.T2014S_AdvancesInfo.IsSalesOrderClose");
	Array.Add("CreditNote.T2015S_TransactionsInfo.IsPaid");

	Array.Add("DebitNote.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("DebitNote.T2014S_AdvancesInfo.IsSalesOrderClose");
	Array.Add("DebitNote.T2015S_TransactionsInfo.IsPaid");

	Array.Add("EmployeeCashAdvance.T2015S_TransactionsInfo.IsDue");

	Array.Add("EmployeeFiring.T9510S_Staffing.Branch");
	Array.Add("EmployeeFiring.T9510S_Staffing.Position");
	Array.Add("EmployeeFiring.T9510S_Staffing.EmployeeSchedule");
	Array.Add("EmployeeFiring.T9510S_Staffing.ProfitLossCenter");

	Array.Add("EmployeeHiring.T9510S_Staffing.Fired");
	Array.Add("EmployeeTransfer.T9510S_Staffing.Fired");

	Array.Add("Payroll.R5021T_Revenues.AmountWithTaxes");
	Array.Add("Payroll.R5022T_Expenses.AmountWithTaxes");
	Array.Add("Payroll.R5022T_Expenses.AmountCost");

	Array.Add("PlannedReceiptReservation.R4037B_PlannedReceiptReservationRequests.Quantity");

	Array.Add("Production.R7010T_DetailingSupplies.EntryDemandQuantity");
	Array.Add("Production.R7010T_DetailingSupplies.CorrectedDemandQuantity");
	Array.Add("Production.R7010T_DetailingSupplies.NeededProduceQuantity");
	Array.Add("Production.R7010T_DetailingSupplies.ReservedProduceQuantity");
	Array.Add("Production.R7010T_DetailingSupplies.RequestProcurementQuantity");
	Array.Add("Production.R7010T_DetailingSupplies.OrderTransferQuantity");
	Array.Add("Production.R7010T_DetailingSupplies.ConfirmedTransferQuantity");
	Array.Add("Production.R7010T_DetailingSupplies.OrderPurchaseQuantity");
	Array.Add("Production.R7010T_DetailingSupplies.ConfirmedPurchaseQuantity");

	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.OrderedQuantity");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.ReOrderedQuantity");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.ReceiptQuantity");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.ShippedQuantity");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.SalesQuantity");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.OrderedNetAmount");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.OrderedTotalAmount");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.ReOrderedNetAmount");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.ReOrderedTotalAmount");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.SalesNetAmount");
	Array.Add("PurchaseInvoice.R2013T_SalesOrdersProcurement.SalesTotalAmount");
	Array.Add("PurchaseInvoice.T2015S_TransactionsInfo.IsPaid");

	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.OrderedQuantity");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.PurchaseQuantity");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.ReceiptQuantity");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.ShippedQuantity");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.SalesQuantity");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.OrderedNetAmount");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.OrderedTotalAmount");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.PurchaseNetAmount");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.PurchaseTotalAmount");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.SalesNetAmount");
	Array.Add("PurchaseOrder.R2013T_SalesOrdersProcurement.SalesTotalAmount");

	Array.Add("PurchaseOrderClosing.T2014S_AdvancesInfo.Amount");
	Array.Add("PurchaseOrderClosing.T2014S_AdvancesInfo.IsSalesOrderClose");

	Array.Add("PurchaseReturn.T2015S_TransactionsInfo.IsPaid");

	Array.Add("RetailSalesReceipt.T2015S_TransactionsInfo.IsPaid");

	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.OrderedQuantity");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.ReOrderedQuantity");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.PurchaseQuantity");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.ReceiptQuantity");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.ShippedQuantity");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.OrderedNetAmount");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.OrderedTotalAmount");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.ReOrderedNetAmount");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.ReOrderedTotalAmount");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.PurchaseNetAmount");
	Array.Add("SalesInvoice.R2013T_SalesOrdersProcurement.PurchaseTotalAmount");
	Array.Add("SalesInvoice.T2015S_TransactionsInfo.IsPaid");

	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.ReOrderedQuantity");	
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.PurchaseQuantity");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.ReceiptQuantity");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.ShippedQuantity");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.SalesQuantity");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.ReOrderedNetAmount");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.ReOrderedTotalAmount");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.PurchaseNetAmount");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.PurchaseTotalAmount");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.SalesNetAmount");
	Array.Add("SalesOrder.R2013T_SalesOrdersProcurement.SalesTotalAmount");

	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.ReOrderedQuantity");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.PurchaseQuantity");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.ReceiptQuantity");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.ShippedQuantity");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.SalesQuantity");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.ReOrderedNetAmount");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.ReOrderedTotalAmount");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.PurchaseNetAmount");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.PurchaseTotalAmount");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.SalesNetAmount");
	Array.Add("SalesOrderClosing.R2013T_SalesOrdersProcurement.SalesTotalAmount");
	Array.Add("SalesOrderClosing.R3026B_SalesOrdersCustomerAdvance.Commission");
	Array.Add("SalesOrderClosing.T2014S_AdvancesInfo.Amount");
	Array.Add("SalesOrderClosing.T2014S_AdvancesInfo.IsPurchaseOrderClose");

	Array.Add("SalesReportFromTradeAgent.T2015S_TransactionsInfo.IsPaid");
	Array.Add("SalesReportToConsignor.T2015S_TransactionsInfo.IsPaid");

	Array.Add("SalesReturn.T2015S_TransactionsInfo.IsPaid");

	Array.Add("StockAdjustmentAsSurplus.R5021T_Revenues.AmountWithTaxes");

	Array.Add("StockAdjustmentAsWriteOff.R5022T_Expenses.AmountCost");

	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.InvoiceTaxAmount");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.IndirectCostAmount");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.IndirectCostTaxAmount");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.ExtraCostAmountByRatio");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.ExtraCostTaxAmountByRatio");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.ExtraDirectCostAmount");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.ExtraDirectCostTaxAmount");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.AllocatedCostAmount");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.AllocatedCostTaxAmount");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.AllocatedRevenueAmount");
	Array.Add("Unbundling.T6050S_ManualBundleAmountValues.AllocatedRevenueTaxAmount");

	Array.Add("WorkSheet.R5022T_Expenses.AmountCost");

	Array.Add("DebitCreditNote.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("DebitCreditNote.T2014S_AdvancesInfo.IsSalesOrderClose");
	
	Array.Add("OpeningEntry.CashInTransit.BasisDocument");
	Array.Add("OpeningEntry.R4014B_SerialLotNumber.Store");
	Array.Add("OpeningEntry.T2014S_AdvancesInfo.Order");
	Array.Add("OpeningEntry.T2014S_AdvancesInfo.IsPurchaseOrderClose");
	Array.Add("OpeningEntry.T2014S_AdvancesInfo.IsSalesOrderClose");
	Array.Add("OpeningEntry.T2015S_TransactionsInfo.Order");
	Array.Add("OpeningEntry.T2015S_TransactionsInfo.IsPaid");
	Array.Add("OpeningEntry.R5015B_OtherPartnersTransactions.Basis");
	Array.Add("OpeningEntry.R3021B_CashInTransitIncoming.Basis");
	
	Map = New Map();
	
	For Each ExcludeItem In Array Do
		Segments = StrSplit(ExcludeItem, ".");
		_Doc = Segments[0];
		_Reg = Segments[1];
		_Field = Segments[2];
		
		If Map[_Doc] = Undefined Then
			Map.Insert(_Doc, New Map());
		EndIf;
		
		If Map[_Doc][_Reg] = Undefined Then
			Map[_Doc].Insert(_Reg, New Array());
		EndIf;
		
		If Map[_Doc][_Reg].Find(_Field) = Undefined Then
			Map[_Doc][_Reg].Add(_Field);
		EndIf;
	EndDo;
	
	Return Map;
EndFunction

#EndRegion

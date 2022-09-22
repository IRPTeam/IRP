#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	if StrCompare(Param.NameTemplate, "SalesOrderPrint") = 0 Then
		Return SalesOrderPrint(Ref, Param);
	EndIf; 
EndFunction

// Sales order print.
// 
// Parameters:
//  Ref - DocumentRef.SalesOrder
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales order print
Function SalesOrderPrint(Ref, Param)
		
	Template = GetTemplate("SalesOrderPrint");
	Template.LanguageCode = Param.LayoutLang;
	Query = New Query;
	Text =
		"SELECT
		|	SalesOrder.Number AS Number,
		|	SalesOrder.Date AS Date,
		|	SalesOrder.Company.Description_en AS Company,
		|	SalesOrder.Partner.Description_en AS Partner,
		|	SalesOrder.Author AS Author,
		|	SalesOrder.Ref AS Ref,
		|	SalesOrder.Currency.Description_en AS Currency
		|FROM
		|	Document.SalesOrder AS SalesOrder
		|WHERE
		|	SalesOrder.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SalesOrderItemList.ItemKey.Item.Description_en AS Item,
		|	SalesOrderItemList.ItemKey.Description_en AS ItemKey,
		|	SalesOrderItemList.Quantity AS Quantity,
		|	SalesOrderItemList.Unit.Description_en AS Unit,
		|	SalesOrderItemList.Price AS Price,
		|	SalesOrderItemList.TaxAmount AS TaxAmount,
		|	SalesOrderItemList.TotalAmount AS TotalAmount,
		|	SalesOrderItemList.NetAmount AS NetAmount,	
		|	SalesOrderItemList.OffersAmount AS OffersAmount,
		|	SalesOrderItemList.Ref AS Ref,
		|	SalesOrderItemList.Key AS Key
		|FROM
		|	Document.SalesOrder.ItemList AS SalesOrderItemList
		|WHERE
		|	SalesOrderItemList.Ref = &Ref
		|	AND NOT SalesOrderItemList.Cancel
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SalesOrderTaxList.Ref AS Ref,
		|	SalesOrderTaxList.Tax AS Tax,
		|	MIN(SalesOrderTaxList.LineNumber) AS LineNumber
		|FROM
		|	Document.SalesOrder.TaxList AS SalesOrderTaxList
		|WHERE
		|	SalesOrderTaxList.Ref = &Ref
		|	AND SalesOrderTaxList.Key IN
		|		(SELECT
		|
		|			SalesOrderItemList.Key AS Key
		|		FROM
		|			Document.SalesOrder.ItemList AS SalesOrderItemList
		|		WHERE
		|			SalesOrderItemList.Ref = &Ref
		|			AND NOT SalesOrderItemList.Cancel)
		|GROUP BY
		|	SalesOrderTaxList.Ref,
		|	SalesOrderTaxList.Tax
		|
		|ORDER BY
		|	LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SalesOrderTaxList.Ref AS Ref,
		|	SalesOrderTaxList.LineNumber AS LineNumber,
		|	SalesOrderTaxList.Key AS Key,
		|	SalesOrderTaxList.Tax AS Tax,
		|	SalesOrderTaxList.TaxRate AS TaxRate
		|FROM
		|	Document.SalesOrder.TaxList AS SalesOrderTaxList
		|WHERE
		|	SalesOrderTaxList.Ref = &Ref";

	LCode = Param.DataLang;	
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text,"SalesOrder.Company",LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text,"SalesOrder.Partner",LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text,"SalesOrder.Currency",LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text,"SalesOrderItemList.ItemKey.Item",LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text,"SalesOrderItemList.ItemKey",LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text,"SalesOrderItemList.Unit",LCode);
	//Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text,"SalesOrderTaxList.Tax",LCode);
	Query.Text = Text;
		
	Query.Parameters.Insert("Ref", Ref);
	Selection			= Query.ExecuteBatch();
	SelectionHeader		= Selection[0].Select(); 
	SelectionItems		= Selection[1].Unload();
	SelectionItems.Indexes.Add("Ref");
	SelectionHeaderTAX	= Selection[2].Unload();
	SelectionPercentTAX	= Selection[3].Unload();

	AreaCaption			= Template.GetArea("Caption");
	AreaHeader			= Template.GetArea("Header");
	AreaItemListHeader	= Template.GetArea("ItemListHeader|ItemColumn");
	AreaItemList		= Template.GetArea("ItemList|ItemColumn");
	AreaFooter			= Template.GetArea("Footer");
	AreaListHeaderTAX	= Template.GetArea("ItemListHeaderTAX|ColumnTAX");
	AreaListTAX			= Template.GetArea("ItemListTAX|ColumnTAX");

	Spreadsheet = New SpreadsheetDocument;
	Spreadsheet.LanguageCode = Param.LayoutLang;
		
	While SelectionHeader.Next() Do
        AreaCaption.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaCaption);

		AreaHeader.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaHeader);
		
		Spreadsheet.Put(AreaItemListHeader);
		For It = 0 To SelectionHeaderTAX.Count() - 1 Do
			AreaListHeaderTAX.Parameters.NameTAX = LocalizationEvents.DescriptionRefLocalization(SelectionHeaderTAX[It].Tax, Spreadsheet.LanguageCode);
			Spreadsheet.Join(AreaListHeaderTAX);
		EndDo;
		
		Choice	= New Structure("Ref", SelectionHeader.Ref);
		FindRow = SelectionItems.FindRows(Choice);
		
		Number		= 0;
		TotalSum	= 0;
		TotalTax	= 0;
		TotalNet	= 0;
		TotalOffers	= 0;
		For Each It In FindRow Do
			Number = Number + 1;
			AreaItemList.Parameters.Fill(It);	
			AreaItemList.Parameters.Number = Number;
			Spreadsheet.Put(AreaItemList);
			
			For ItTax = 0 To SelectionHeaderTAX.Count() - 1 Do
				Tax = SelectionHeaderTAX[ItTax].Tax;
				ChoiceTax	= New Structure("Ref, Key, Tax", SelectionHeader.Ref, It.Key, Tax);
				FindRowTax		= SelectionPercentTAX.FindRows(ChoiceTax);
				For Each ItPercent In FindRowTax Do
					AreaListTAX.Parameters.PercentTax = ItPercent.TaxRate;
					Spreadsheet.Join(AreaListTAX);
				EndDo;
			EndDo;
			TotalSum	= TotalSum + It.TotalAmount;
			TotalTax	= TotalTax + It.TaxAmount;
			TotalOffers	= TotalOffers + It.OffersAmount;
			TotalNet	= TotalNet + It.NetAmount
		EndDo;
	EndDo;
	
	AreaFooter.Parameters.Number		= Number;
	AreaFooter.Parameters.Total			= TotalSum;
	AreaFooter.Parameters.Currency		= SelectionHeader.Currency;
	AreaFooter.Parameters.Total			= TotalSum;
	AreaFooter.Parameters.TotalTax		= TotalTax;
	AreaFooter.Parameters.TotalNet		= TotalNet;
	AreaFooter.Parameters.TotalOffers	= TotalOffers;
	AreaFooter.Parameters.Manager		= SelectionHeader.Author;
	Spreadsheet.Put(AreaFooter);
	
	Return Spreadsheet;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();

	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
#Region NewRegistersPosting
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
		Return Tables;
	EndIf;

	Parameters.IsReposting = False;

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();

#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion

	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.SalesOrder.ItemList");

	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod",
			New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;
	
	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4037B_PlannedReceiptReservationRequests.CheckBalance(Ref,
		LineNumberAndItemKeyFromItemList, PostingServer.GetQueryTableByName("R4037B_PlannedReceiptReservationRequests",
		Parameters), PostingServer.GetQueryTableByName("R4037B_PlannedReceiptReservationRequests_Exists", Parameters),
		AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesOrder.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(R4037B_PlannedReceiptReservationRequests_Exists());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R2010T_SalesOrders());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2014T_CanceledSalesOrders());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	QueryArray.Add(R4037B_PlannedReceiptReservationRequests());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(R3024B_SalesOrdersToBePaid());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
	|	SalesOrderItemList.Ref.Company AS Company,
	|	SalesOrderItemList.Store AS Store,
	|	SalesOrderItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
	|	SalesOrderItemList.ItemKey AS ItemKey,
	|	SalesOrderItemList.Ref AS Order,
	|	SalesOrderItemList.Quantity AS UnitQuantity,
	|	SalesOrderItemList.QuantityInBaseUnit AS Quantity,
	|	SalesOrderItemList.Unit,
	|	SalesOrderItemList.ItemKey.Item AS Item,
	|	SalesOrderItemList.Ref.Date AS Period,
	|	SalesOrderItemList.Key AS RowKey,
	|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
	|	SalesOrderItemList.ProcurementMethod,
	|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
	|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
	|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.IncomingReserve) AS
	|		IsProcurementMethod_IncomingReserve,
	|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.NoReserve)
	|	OR SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.IncomingReserve) AS
	|		IsProcurementMethod_NonReserve,
	|	SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
	|	SalesOrderItemList.TotalAmount AS Amount,
	|	SalesOrderItemList.Ref.Currency AS Currency,
	|	SalesOrderItemList.Cancel AS IsCanceled,
	|	SalesOrderItemList.CancelReason,
	|	SalesOrderItemList.NetAmount,
	|	SalesOrderItemList.Ref.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,
	|	SalesOrderItemList.OffersAmount,
	|	&StatusInfoPosting AS StatusInfoPosting,
	|	SalesOrderItemList.Ref.Branch AS Branch,
	|	CASE
	|		WHEN SalesOrderItemList.ReservationDate = DATETIME(1, 1, 1)
	|			THEN SalesOrderItemList.Ref.Date
	|		ELSE SalesOrderItemList.ReservationDate
	|	END AS ReservationDate,
	|	SalesOrderItemList.SalesPerson
	|INTO ItemList
	|FROM
	|	Document.SalesOrder.ItemList AS SalesOrderItemList
	|WHERE
	|	SalesOrderItemList.Ref = &Ref
	|	AND &StatusInfoPosting";
EndFunction

Function R2010T_SalesOrders()
	Return "SELECT
		   |	*
		   |INTO R2010T_SalesOrders
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled";
EndFunction

Function R2011B_SalesOrdersShipment()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R2011B_SalesOrdersShipment
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService";
EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R2012B_SalesOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled";
EndFunction

Function R2013T_SalesOrdersProcurement()
	Return "SELECT
		   |	ItemList.Quantity AS OrderedQuantity,
		   |	*
		   |INTO R2013T_SalesOrdersProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND ItemList.IsProcurementMethod_Purchase";
EndFunction

Function R2014T_CanceledSalesOrders()
	Return "SELECT
		   |	*
		   |INTO R2014T_CanceledSalesOrders
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.isCanceled";
EndFunction

#Region Stock

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND ItemList.IsProcurementMethod_Stock";
EndFunction

Function R4012B_StockReservation()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.ReservationDate AS Period,
		   |	*
		   |INTO R4012B_StockReservation
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND ItemList.IsProcurementMethod_Stock";
EndFunction

#EndRegion

Function R4034B_GoodsShipmentSchedule()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.DeliveryDate AS Period,
		   |	ItemList.Order AS Basis,
		   |	*
		   |INTO R4034B_GoodsShipmentSchedule
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND NOT ItemList.DeliveryDate = DATETIME(1, 1, 1)
		   |	AND ItemList.UseItemsShipmentScheduling";
EndFunction

Function R2022B_CustomersPaymentPlanning()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	SalesOrderPaymentTerms.Ref.Date AS Period,
		   |	SalesOrderPaymentTerms.Ref.Company AS Company,
		   |	SalesOrderPaymentTerms.Ref.Branch AS Branch,
		   |	SalesOrderPaymentTerms.Ref AS Basis,
		   |	SalesOrderPaymentTerms.Ref.LegalName AS LegalName,
		   |	SalesOrderPaymentTerms.Ref.Partner AS Partner,
		   |	SalesOrderPaymentTerms.Ref.Agreement AS Agreement,
		   |	SUM(SalesOrderPaymentTerms.Amount) AS Amount
		   |INTO R2022B_CustomersPaymentPlanning
		   |FROM
		   |	Document.SalesOrder.PaymentTerms AS SalesOrderPaymentTerms
		   |WHERE
		   |	SalesOrderPaymentTerms.Ref = &Ref
		   |	AND SalesOrderPaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.Prepaid)
		   |	AND &StatusInfoPosting
		   |GROUP BY
		   |	SalesOrderPaymentTerms.Ref.Date,
		   |	SalesOrderPaymentTerms.Ref.Company,
		   |	SalesOrderPaymentTerms.Ref.Branch,
		   |	SalesOrderPaymentTerms.Ref.Branch,
		   |	SalesOrderPaymentTerms.Ref,
		   |	SalesOrderPaymentTerms.Ref.LegalName,
		   |	SalesOrderPaymentTerms.Ref.Partner,
		   |	SalesOrderPaymentTerms.Ref.Agreement,
		   |	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R4037B_PlannedReceiptReservationRequests()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType, 
		   |	*
		   |	INTO R4037B_PlannedReceiptReservationRequests
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsProcurementMethod_IncomingReserve";
EndFunction

Function R4037B_PlannedReceiptReservationRequests_Exists()
	Return "SELECT *
		   |	INTO R4037B_PlannedReceiptReservationRequests_Exists
		   |FROM
		   |	AccumulationRegister.R4037B_PlannedReceiptReservationRequests AS R4037B_PlannedReceiptReservationRequests
		   |WHERE
		   |	R4037B_PlannedReceiptReservationRequests.Recorder = &Ref";
EndFunction

Function T3010S_RowIDInfo()
	Return
		"SELECT
		|	RowIDInfo.RowRef AS RowRef,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	RowIDInfo.RowID AS RowID,
		|	RowIDInfo.Basis AS Basis,
		|	ItemList.Key AS Key,
		|	ItemList.Price AS Price,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.Unit AS Unit
		|INTO T3010S_RowIDInfo
		|FROM
		|	Document.SalesOrder.ItemList AS ItemList
		|		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function R3024B_SalesOrdersToBePaid()
	Return 
	"SELECT
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	PaymentTerms.Ref.Date AS Period,
	|	PaymentTerms.Ref.Company,
	|	PaymentTerms.Ref.Branch,
	|	PaymentTerms.Ref.Currency,
	|	PaymentTerms.Ref.Partner,
	|	PaymentTerms.Ref.LegalName,
	|	PaymentTerms.Ref AS Order,
	|	SUM(PaymentTerms.Amount) AS Amount
	|INTO R3024B_SalesOrdersToBePaid
	|FROM
	|	Document.SalesOrder.PaymentTerms AS PaymentTerms
	|WHERE
	|	PaymentTerms.Ref = &Ref
	|	AND (PaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.Prepaid)
	|	AND PaymentTerms.CanBePaid)
	|	AND &StatusInfoPosting
	|GROUP BY
	|	PaymentTerms.Ref,
	|	PaymentTerms.Ref.Branch,
	|	PaymentTerms.Ref.Company,
	|	PaymentTerms.Ref.Currency,
	|	PaymentTerms.Ref.Date,
	|	PaymentTerms.Ref.LegalName,
	|	PaymentTerms.Ref.Partner,
	|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

#EndRegion

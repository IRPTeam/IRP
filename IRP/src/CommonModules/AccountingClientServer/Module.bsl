
Procedure BeforeWriteAccountingDocument(Object, MainTableName, ArrayOfIdentifiers) Export
	DeleteUnusedRowsFromAnalyticsTable(Object, MainTableName);
	CompanyLadgerTypes = AccountingServer.GetLadgerTypesByCompany(Object);
	
	For Each Operation In ArrayOfIdentifiers Do
		
		If Not Operation.ByRow Then
			For Each LadgerType In CompanyLadgerTypes Do
				UpdateAccountingAnalytics(Object, Undefined, "", Operation.Identifier, LadgerType);
			EndDo; // CompanyLadgerTypes
		Else
			For Each LadgerType In CompanyLadgerTypes Do
				For Each Row In Object[MainTableName] Do
					UpdateAccountingAnalytics(Object, Row, Row.Key, Operation.Identifier, LadgerType);
				EndDo; // Object[MainTableName]
			EndDo; // CompanyLadgerTypes
		EndIf;
		
	EndDo; // ArrayOfIdentifiers
EndProcedure

Procedure UpdateAccountingAnalytics(Object, Row, RowKey, Identifier, LadgerType)
	AnalyticRow = Undefined;
	Filter = New Structure();
	Filter.Insert("Key"       , RowKey);
	Filter.Insert("Identifier", Identifier);
	Filter.Insert("LadgerType", LadgerType);
	AnalyticRows = Object.AccountingRowAnalytics.FindRows(Filter);
	If AnalyticRows.Count() > 1 Then
		Raise StrTemplate("More than 1 analytic rows by filter: Key[%1] Identifier[%2] LadgerType[%3]",
				Filter.Key, Filter.Identifier, Filter.LadgerType);
	ElsIf AnalyticRows.Count() = 1 Then
		AnalyticRow = AnalyticRows[0];
		If AnalyticRow.IsFixed Then
			Return;
		EndIf;
	EndIf;
				
	AnalyticData = GetAccountingAnalytics(Object, Row, Identifier, LadgerType);

	If AnalyticRow = Undefined Then
		AnalyticRow = Object.AccountingRowAnalytics.Add();
		AnalyticRow.Key = RowKey;
		FillAccountingAnalytics(AnalyticRow, AnalyticData, Object.AccountingExtDimensions);
	Else
		If AccountingAnalyticsIsChanged(AnalyticRow, AnalyticData, Object.AccountingExtDimensions) Then
			FillAccountingAnalytics(AnalyticRow, AnalyticData, Object.AccountingExtDimensions);
		EndIf;
	EndIf;
EndProcedure


Function GetDataByAccountingAnalytics(BasisRef, AnalyticsRow) Export
	RowData = New Structure(GetColumnsAccountingRowAnalytics());
	FillPropertyValues(RowData, AnalyticsRow);
	RowData.Insert("Key", AnalyticsRow.Key);
	
	If TypeOf(BasisRef) = Type("DocumentRef.BankPayment") Then
		Return AccountingServer.GetDataByAccountingAnalytics_BankPayment(BasisRef, RowData);
	ElsIf TypeOf(BasisRef) = Type("DocumentRef.PurchaseInvoice") Then
		Return AccountingServer.GetDataByAccountingAnalytics_PurchaseInvoice(BasisRef, RowData);
	EndIf;
EndFunction

Function GetAccountingAnalytics(Object, TableRow, Identifier, LadgerType) Export
	If TypeOf(Object.Ref) = Type("DocumentRef.BankPayment") Then
		
		RowData = Undefined;
		If TableRow <> Undefined Then
			RowData = New Structure("Key, Partner, Agreement, BasisDocument");
			FillPropertyValues(RowData, TableRow);
		EndIf;
		
		ObjectData = New Structure("Ref, Date, Company, Account");
		FillPropertyValues(ObjectData, Object);
		
		Return AccountingServer.GetAccountingAnalytics_BankPayment(ObjectData, RowData, Identifier, LadgerType);
	ElsIf TypeOf(Object.Ref) = Type("DocumentRef.PurchaseInvoice") Then
		
		RowData = Undefined;
		If TableRow <> Undefined Then
			RowData = New Structure("Key, ItemKey, Store");
			FillPropertyValues(RowData, TableRow);
		EndIf;
		
		ObjectData = New Structure("Ref, Date, Company, Partner, Agreement");
		FillPropertyValues(ObjectData, Object);
		
		Return AccountingServer.GetAccountingAnalytics_PurchaseInvoice(ObjectData, RowData, Identifier, LadgerType);
	EndIf;
EndFunction

Procedure FillAccountingAnalytics(AnalyticRow, AnalyticData, AccountingExtDimensions) Export
	AnalyticRow.Identifier = AnalyticData.Identifier;
	AnalyticRow.LadgerType = AnalyticData.LadgerType;
	
	AnalyticRow.AccountDebit = AnalyticData.Debit;
	FillAccountingExtDimensions(AnalyticData.DebitExtDimensions, AccountingExtDimensions);
	
	AnalyticRow.AccountCredit = AnalyticData.Credit;
	FillAccountingExtDimensions(AnalyticData.CreditExtDimensions, AccountingExtDimensions);
EndProcedure

Procedure FillAccountingExtDimensions(ArrayOfData, AccountingExtDimensions)
	For Each ExtDim In ArrayOfData Do
		Filter = New Structure();
		Filter.Insert("Key"          , ExtDim.Key);
		Filter.Insert("AnalyticType" , ExtDim.AnalyticType);
		Filter.Insert("Identifier"   , ExtDim.Identifier);
		Filter.Insert("LadgerType"   , ExtDim.LadgerType);
		AccountingExtDimensionRows = AccountingExtDimensions.FindRows(Filter);
		For Each RowForDelete In AccountingExtDimensionRows Do
			AccountingExtDimensions.Delete(RowForDelete);
		EndDo;
	EndDo;
	
	For Each ExtDim In ArrayOfData Do
		NewRow = AccountingExtDimensions.Add();
		NewRow.Key              = ExtDim.Key;
		NewRow.AnalyticType     = ExtDim.AnalyticType;
		NewRow.Identifier       = ExtDim.Identifier;
		NewRow.LadgerType       = ExtDim.LadgerType;
		NewRow.ExtDimensionType = ExtDim.ExtDimensionType;
		NewRow.ExtDimension     = ExtDim.ExtDimension;
	EndDo;
EndProcedure

Function AccountingAnalyticsIsChanged(AnalyticRow, AnalyticData, AccountingExtDimensions) Export
	
	// TEST
	Return True;
	
	ActualRow = New Structure(GetColumnsAccountingRowAnalytics());
	FillAccountingAnalytics(ActualRow, AnalyticData, AccountingExtDimensions);
	
	IsEqual = True;
	For Each KeyValue In ActualRow Do
		CurrentValue = AnalyticRow[TrimAll(KeyValue.Key)];
		NewValue     = ActualRow[TrimAll(KeyValue.Key)];
		
		If CurrentValue <> NewValue Then
			IsEqual = False;
			Break;
		EndIf;
		
		
		
	EndDo;
	Return Not IsEqual;
EndFunction

Function GetColumnsAccountingRowAnalytics()
	Return
	"Identifier, LadgerType, 
	|AccountDebit,
	|AccountCredit";
EndFunction

Procedure DeleteUnusedRowsFromAnalyticsTable(Object, MainTableName) Export
	// AccountingRowAnalytics
	ArrayForDelete = New Array();
	For Each Row In Object.AccountingRowAnalytics Do
		If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AccountingRowAnalytics.Delete(ItemForDelete);
	EndDo;
	
	// AccountingExtDimensions
	ArrayForDelete.Clear();
	For Each Row In Object.AccountingExtDimensions Do
		If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AccountingExtDimensions.Delete(ItemForDelete);
	EndDo;
EndProcedure

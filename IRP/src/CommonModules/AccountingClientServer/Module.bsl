
Procedure UpdateAccountingDataInDocument(Object, MainTableName, Filter_LedgerType = Undefined, IgnoreFixed = False) Export
	Period = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Object.Ref, Object.Date);
	LedgerTypes = AccountingServer.GetLedgerTypesByCompany(Object.Ref, Period, Object.Company);
	
	DeleteUnusedRowsFromAnalyticsTable(Object, Period, LedgerTypes, MainTableName);
	
	For Each LedgerType In LedgerTypes Do
		// filter by ledger type
		If Filter_LedgerType <> Undefined Then
			If LedgerType <> Filter_LedgerType Then
				Continue;
			EndIf;
		EndIf;
		
		OperationsInfo = AccountingServer.GetAccountingOperationsByLedgerType(Object.Ref, Period, LedgerType);
		
		For Each OperationInfo In OperationsInfo Do
			If Not OperationInfo.ByRow Then
				UpdateAccountingAnalyticsInDocument(Object, Undefined, "", 
					OperationInfo.Operation, LedgerType, OperationInfo.MetadataName, MainTableName, IgnoreFixed);
			Else
				For Each Row In Object[MainTableName] Do
					UpdateAccountingAnalyticsInDocument(Object, Row, Row.Key, 
						OperationInfo.Operation, LedgerType, OperationInfo.MetadataName, MainTableName, IgnoreFixed);
				EndDo;
			EndIf;
		EndDo;
		
	EndDo;
EndProcedure

Procedure UpdateAccountingAnalyticsInDocument(Object, Row, RowKey, Operation, LedgerType, MetadataName, MainTableName, IgnoreFixed)
	AnalyticRow = Undefined;
	Filter = New Structure();
	If ValueIsFilled(RowKey) Then
		Filter.Insert("Key" , RowKey);
	EndIf;
	
	Filter.Insert("Operation"  , Operation);
	Filter.Insert("LedgerType" , LedgerType);
	
	AnalyticRows = Object.AccountingRowAnalytics.FindRows(Filter);
	
	If AnalyticRows.Count() > 1 Then
		Raise StrTemplate("More than 1 analytic rows by filter: Key[%1] Operation[%2] LedgerType[%3]", Filter.Key, Filter.Operation, Filter.LedgerType);
	ElsIf AnalyticRows.Count() = 1 Then
		AnalyticRow = AnalyticRows[0];
		If AnalyticRow.IsFixed And Not IgnoreFixed Then
			Return;
		EndIf;
	Else
		AnalyticRow = Object.AccountingRowAnalytics.Add();
		AnalyticRow.Key = RowKey;		
	EndIf;
	
	DocumentData = AccountingServer.GetDocumentData(Object, Row, MainTableName);
	Parameters = New Structure();
	Parameters.Insert("ObjectData"   , DocumentData.ObjectData);
	Parameters.Insert("RowData"      , DocumentData.RowData);
	Parameters.Insert("Operation"    , Operation);
	Parameters.Insert("LedgerType"   , LedgerType);
	Parameters.Insert("MetadataName" , MetadataName);
	
	AnalyticData = AccountingServer.GetAccountingAnalytics(Parameters, MetadataName);

	AnalyticRow.IsFixed = False;
	FillAccountingAnalytics(AnalyticRow, AnalyticData, Object.AccountingExtDimensions);
EndProcedure

Procedure FillAccountingAnalytics(AnalyticRow, AnalyticData, AccountingExtDimensions) Export
	AnalyticRow.Operation = AnalyticData.Operation;
	AnalyticRow.LedgerType = AnalyticData.LedgerType;
	
	AnalyticRow.AccountDebit = AnalyticData.Debit;
	FillAccountingExtDimensions(AnalyticData.DebitExtDimensions, AccountingExtDimensions);
	
	AnalyticRow.AccountCredit = AnalyticData.Credit;
	FillAccountingExtDimensions(AnalyticData.CreditExtDimensions, AccountingExtDimensions);
EndProcedure

Procedure FillAccountingExtDimensions(ArrayOfData, AccountingExtDimensions)
	For Each ExtDim In ArrayOfData Do
		Filter = New Structure();
		If ValueIsFilled(ExtDim.Key) Then
			Filter.Insert("Key" , ExtDim.Key);
		EndIf;
		Filter.Insert("AnalyticType" , ExtDim.AnalyticType);
		Filter.Insert("Operation"    , ExtDim.Operation);
		Filter.Insert("LedgerType"   , ExtDim.LedgerType);
		AccountingExtDimensionRows = AccountingExtDimensions.FindRows(Filter);
		For Each RowForDelete In AccountingExtDimensionRows Do
			AccountingExtDimensions.Delete(RowForDelete);
		EndDo;
	EndDo;
	
	For Each ExtDim In ArrayOfData Do
		NewRow = AccountingExtDimensions.Add();
		NewRow.Key              = ExtDim.Key;
		NewRow.AnalyticType     = ExtDim.AnalyticType;
		NewRow.Operation        = ExtDim.Operation;
		NewRow.LedgerType       = ExtDim.LedgerType;
		NewRow.ExtDimensionType = ExtDim.ExtDimensionType;
		NewRow.ExtDimension     = ExtDim.ExtDimension;
	EndDo;
EndProcedure

Function GetColumnsAccountingRowAnalytics()
	Return
	"Key,
	|Operation, 
	|LedgerType, 
	|AccountDebit,
	|AccountCredit,
	|IsFixed";
EndFunction

Function GetDataByAccountingAnalytics(BasisRef, AnalyticsRow) Export
	RowData = New Structure(GetColumnsAccountingRowAnalytics());
	FillPropertyValues(RowData, AnalyticsRow);
	RowData.Insert("Key", AnalyticsRow.Key);
	Return AccountingServer.GetDataByAccountingAnalytics(BasisRef, RowData);
EndFunction

Procedure DeleteUnusedRowsFromAnalyticsTable(Object, Period, LedgerTypes, MainTableName) Export
		
	// AccountingRowAnalytics
	ArrayForDelete = New Array();
	For Each Row In Object.AccountingRowAnalytics Do
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
	
		Operations = New Array();	
		OperationsInfo = AccountingServer.GetAccountingOperationsByLedgerType(Object.Ref, Period, Row.LedgerType);
		For Each OperationInfo In OperationsInfo Do
			Operations.Add(OperationInfo.Operation);
		EndDo;
		If Operations.Find(Row.Operation) = Undefined Then
			ArrayForDelete.Add(Row);
		EndIf;
		
		If Not ValueIsFilled(Row.Key) Then
			Continue;
		EndIf;
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
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		Operations = New Array();	
		OperationsInfo = AccountingServer.GetAccountingOperationsByLedgerType(Object.Ref, Period, Row.LedgerType);
		For Each OperationInfo In OperationsInfo Do
			Operations.Add(OperationInfo.Operation);
		EndDo;
		If Operations.Find(Row.Operation) = Undefined Then
			ArrayForDelete.Add(Row);
		EndIf;
		
		If Not ValueIsFilled(Row.Key) Then
			Continue;
		EndIf;
		If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AccountingExtDimensions.Delete(ItemForDelete);
	EndDo;
EndProcedure

Function GetParametersEditAccounting(Object, CurrentData, MainTableName, Filter_LedgerType = Undefined) Export
	Parameters = New Structure();
	Parameters.Insert("DocumentRef", Object.Ref);
	Parameters.Insert("MainTableName"     , MainTableName);
	Parameters.Insert("ArrayOfLedgerTypes", AccountingServer.GetLedgerTypesByCompany(Object.Ref, Object.Date, Object.Company));
	Parameters.Insert("RowKey", CurrentData.Key);
	
	Parameters.Insert("AccountingAnalytics", New Array());
	For Each RowAnalytics In Object.AccountingRowAnalytics Do
		If Not (RowAnalytics.Key = CurrentData.Key Or Not ValueIsFilled(RowAnalytics.Key)) Then
			Continue;
		EndIf;
		
		If Filter_LedgerType <> Undefined Then
			If RowAnalytics.LedgerType <> Filter_LedgerType Then
				Continue;
			EndIf;
		EndIf;
		
		NewAnalyticRow = New Structure();
		NewAnalyticRow.Insert("Key"           , RowAnalytics.Key);
		NewAnalyticRow.Insert("LedgerType"    , RowAnalytics.LedgerType);
		NewAnalyticRow.Insert("Operation"     , RowAnalytics.Operation);
		NewAnalyticRow.Insert("AccountDebit"  , RowAnalytics.AccountDebit);
		NewAnalyticRow.Insert("AccountCredit" , RowAnalytics.AccountCredit);
		
		NewAnalyticRow.Insert("IsFixed"       , RowAnalytics.IsFixed);
		
		NewAnalyticRow.Insert("DebitExtDimensions"  , New Array());
		NewAnalyticRow.Insert("CreditExtDimensions" , New Array());
	
		For Each RowExtDimensions In Object.AccountingExtDimensions Do
			If RowExtDimensions.Key <> RowAnalytics.Key
				Or RowExtDimensions.Operation <> RowAnalytics.Operation
				Or RowExtDimensions.LedgerType <> RowAnalytics.LedgerType Then
				Continue;
			EndIf;
			NewExtDimension = New Structure();
			NewExtDimension.Insert("ExtDimensionType", RowExtDimensions.ExtDimensionType);
			NewExtDimension.Insert("ExtDimension"    , RowExtDimensions.ExtDimension);
			If RowExtDimensions.AnalyticType = PredefinedValue("Enum.AccountingAnalyticTypes.Debit") Then
				NewAnalyticRow.DebitExtDimensions.Add(NewExtDimension);
			ElsIf RowExtDimensions.AnalyticType = PredefinedValue("Enum.AccountingAnalyticTypes.Credit") Then
				NewAnalyticRow.CreditExtDimensions.Add(NewExtDimension);
			Else
				Raise "Analytic type is not defined";
			EndIf;
		EndDo;
		Parameters.AccountingAnalytics.Add(NewAnalyticRow);
	EndDo;
	Return Parameters;
EndFunction


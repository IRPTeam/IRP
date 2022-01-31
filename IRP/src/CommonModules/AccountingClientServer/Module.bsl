
Procedure BeforeWriteAccountingDocument(Object, MainTableName, Filter_LadgerType = Undefined) Export
	DeleteUnusedRowsFromAnalyticsTable(Object, MainTableName);
	CompanyLadgerTypes = AccountingServer.GetLadgerTypesByCompany(Object.Ref, Object.Date, Object.Company);
	Period = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Object.Ref, Object.Date);
	For Each LadgerType In CompanyLadgerTypes Do
		If Filter_LadgerType <> Undefined Then
			If LadgerType <> Filter_LadgerType Then
				Continue;
			EndIf;
		EndIf;
		LadgerTypeAccountingOperations = AccountingServer.GetAccountingOperationsByLadgerType(Object.Ref, Period, LadgerType);
		For Each Operation In LadgerTypeAccountingOperations Do
			If Not Operation.ByRow Then
				UpdateAccountingAnalytics(Object, Undefined, "", 
					Operation.Identifier, LadgerType, Operation.MetadataName, MainTableName);
			Else
				For Each Row In Object[MainTableName] Do
					UpdateAccountingAnalytics(Object, Row, Row.Key, 
						Operation.Identifier, LadgerType, Operation.MetadataName, MainTableName);
				EndDo;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure UpdateAccountingAnalytics(Object, Row, RowKey, Identifier, LadgerType, MetadataName, MainTableName)
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
				
	AnalyticData = GetAccountingAnalytics(Object, Row, Identifier, LadgerType, MetadataName, MainTableName);

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

Function GetAccountingAnalytics(Object, TableRow, Identifier, LadgerType, MetadataName, MainTableName) Export
	DocumentData = AccountingServer.GetDocumentData(Object, TableRow, MainTableName);
	Parameters = New Structure();
	Parameters.Insert("ObjectData"   , DocumentData.ObjectData);
	Parameters.Insert("RowData"      , DocumentData.RowData);
	Parameters.Insert("Identifier"   , Identifier);
	Parameters.Insert("LadgerType"   , LadgerType);
	Parameters.Insert("MetadataName" , MetadataName);
	Return AccountingServer.GetAccountingAnalytics(Parameters, MetadataName);
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
	"Identifier, 
	|LadgerType, 
	|AccountDebit,
	|AccountCredit";
EndFunction

Function GetDataByAccountingAnalytics(BasisRef, AnalyticsRow) Export
	RowData = New Structure(GetColumnsAccountingRowAnalytics());
	FillPropertyValues(RowData, AnalyticsRow);
	RowData.Insert("Key", AnalyticsRow.Key);
	Return AccountingServer.GetDataByAccountingAnalytics(BasisRef, RowData);
EndFunction

Procedure DeleteUnusedRowsFromAnalyticsTable(Object, MainTableName) Export
	// AccountingRowAnalytics
	ArrayForDelete = New Array();
	For Each Row In Object.AccountingRowAnalytics Do
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

Function GetParametersEditTrialBallanceAccounts(Object, CurrentData, MainTableName, Filter_LadgerType = Undefined) Export
	Parameters = New Structure();
	Parameters.Insert("DocumentRef", Object.Ref);
	Parameters.Insert("MainTableName"     , MainTableName);
	Parameters.Insert("ArrayOfLadgerTypes", AccountingServer.GetLadgerTypesByCompany(Object.Ref, Object.Date, Object.Company));
	Parameters.Insert("RowKey", CurrentData.Key);
	
	Parameters.Insert("AccountingAnalytics", New Array());
	For Each RowAnalytics In Object.AccountingRowAnalytics Do
		If Not (RowAnalytics.Key = CurrentData.Key Or Not ValueIsFilled(RowAnalytics.Key)) Then
			Continue;
		EndIf;
		
		If Filter_LadgerType <> Undefined Then
			If RowAnalytics.LadgerType <> Filter_LadgerType Then
				Continue;
			EndIf;
		EndIf;
		
		NewAnalyticRow = New Structure();
		NewAnalyticRow.Insert("Key"           , RowAnalytics.Key);
		NewAnalyticRow.Insert("LadgerType"    , RowAnalytics.LadgerType);
		NewAnalyticRow.Insert("Identifier"    , RowAnalytics.Identifier);
		NewAnalyticRow.Insert("AccountDebit"  , RowAnalytics.AccountDebit);
		NewAnalyticRow.Insert("AccountCredit" , RowAnalytics.AccountCredit);
		
		NewAnalyticRow.Insert("DebitExtDimensions" , New Array());
		NewAnalyticRow.Insert("CreditExtDimensions" , New Array());
	
		For Each RowExtDimensions In Object.AccountingExtDimensions Do
			If RowExtDimensions.Key <> RowAnalytics.Key
				Or RowExtDimensions.Identifier <> RowAnalytics.Identifier
				Or RowExtDimensions.LadgerType <> RowAnalytics.LadgerType Then
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


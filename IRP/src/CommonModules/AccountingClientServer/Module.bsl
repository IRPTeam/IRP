
Procedure UpdateAccountingTables(Object, 
		                         AccountingRowAnalytics, 
		                         AccountingExtDimensions,
		                         MainTableName, 
		                         Filter_LedgerType = Undefined, 
		                         IgnoreFixed = False,
		                         AddInfo = Undefined) Export
		                         
	AccountingServer.UpdateAccountingTables(Object, 
											AccountingRowAnalytics,
											AccountingExtDimensions,
		                                    MainTableName, 
		                                    Filter_LedgerType, 
		                                    IgnoreFixed,
		                                    AddInfo);
EndProcedure

Function GetParametersEditAccounting(Object, 
		                             AccountingRowAnalytics, 
		                             AccountingExtDimensions, 
		                             CurrentData, 
		                             MainTableName, 
		                             Filter_LedgerType = Undefined) Export
	Parameters = New Structure();
	Parameters.Insert("DocumentRef"       , Object.Ref);
	Parameters.Insert("ArrayOfLedgerTypes", AccountingServer.GetLedgerTypesByCompany(Object.Ref, Object.Date, Object.Company));
	Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
	Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
	If ValueIsFilled(MainTableName) Then
		Parameters.Insert("MainTableName"     , MainTableName);
		Parameters.Insert("RowKey"            , CurrentData.Key);
	Else
		Parameters.Insert("MainTableName"     , Undefined);
		Parameters.Insert("RowKey"            , "");		
	EndIf;			
	
	Parameters.Insert("AccountingAnalytics", New Array());
	For Each RowAnalytics In AccountingRowAnalytics Do
		If Not (RowAnalytics.Key = Parameters.RowKey Or Not ValueIsFilled(RowAnalytics.Key)) Then
			Continue;
		EndIf;
		
		If Filter_LedgerType <> Undefined And RowAnalytics.LedgerType <> Filter_LedgerType Then
			Continue;
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
	
		For Each RowExtDimensions In AccountingExtDimensions Do
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

Function GetDocumentMainTable(Doc) Export
	MainTable = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(Doc, "ItemList") Then
		MainTable = "ItemList";
	ElsIf CommonFunctionsClientServer.ObjectHasProperty(Doc, "PaymentList") Then
		MainTable = "PaymentList";		
	ElsIf CommonFunctionsClientServer.ObjectHasProperty(Doc, "Transactions") Then
		MainTable = "Transactions";
	ElsIf CommonFunctionsClientServer.ObjectHasProperty(Doc, "Calculations") Then
		MainTable = "Calculations";	
	ElsIf CommonFunctionsClientServer.ObjectHasProperty(Doc, "CostList") Then
		MainTable = "CostList";	
	EndIf;
	Return MainTable;
EndFunction
	

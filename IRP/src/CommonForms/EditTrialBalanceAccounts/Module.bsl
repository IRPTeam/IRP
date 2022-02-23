
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocumentRef   = Parameters.DocumentRef;
	ThisObject.MainTableName = Parameters.MainTableName;
	ThisObject.RowKey        = Parameters.RowKey;
	
	For Each CompanyLedgerType In Parameters.ArrayOfLedgerTypes Do
		ThisObject.Items.LedgerType.ChoiceList.Add(CompanyLedgerType, String(CompanyLedgerType));
	EndDo;
	If Parameters.ArrayOfLedgerTypes.Count() Then
		ThisObject.LedgerType = Parameters.ArrayOfLedgerTypes[0];
	EndIf;
	
	FillAccountingAnalytics(Parameters.AccountingAnalytics);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Not ThisObject.AccountingAnalytics.Count() Then
		DefaultAnalytics = GetDefaultAccountingAnalytics(ThisObject.FormOwner.Object, ThisObject.MainTableName, ThisObject.RowKey);
		FillAccountingAnalytics(DefaultAnalytics.AccountingAnalytics);
	EndIf;
	SetVisibleByLedgerType();
	ClearColumnTitle();
EndProcedure

&AtClient
Procedure SetByDefault(Command)
	DefaultAnalytics = 
		GetDefaultAccountingAnalytics(ThisObject.FormOwner.Object, ThisObject.MainTableName, ThisObject.RowKey, ThisObject.LedgerType);
	
	ArrayForDelete = New Array();
	For Each Row In ThisObject.AccountingAnalytics Do
		If Row.LedgerType = ThisObject.LedgerType Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		ThisObject.AccountingAnalytics.Delete(ItemForDelete);
	EndDo;
	
	FillAccountingAnalytics(DefaultAnalytics.AccountingAnalytics);
	
	SetVisibleByLedgerType();
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure();
	Result.Insert("AccountingAnalytics" , New Array());
	Result.Insert("DocumentRef"         , ThisObject.DocumentRef);
	Result.Insert("RowKey"              , ThisObject.RowKey);
	For Each Row In ThisObject.AccountingAnalytics Do
		NewRow = New Structure("AccountDebit,
								|ExtDimensionTypeDr1,
								|ExtDimensionTypeDr2,
								|ExtDimensionTypeDr3,
								|ExtDimensionDr1,
								|ExtDimensionDr2,
								|ExtDimensionDr3,
								|AccountCredit,
								|ExtDimensionTypeCr1,
								|ExtDimensionTypeCr2,
								|ExtDimensionTypeCr3,
								|ExtDimensionCr1,
								|ExtDimensionCr2,
								|ExtDimensionCr3,
								|Key,
								|LedgerType,
								|Identifier,
								|IsFixed");
		FillPropertyValues(NewRow, Row);
		Result.AccountingAnalytics.Add(NewRow);
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure LedgerTypeOnChange(Item)
	SetVisibleByLedgerType();
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure SetVisibleByLedgerType()
	If Not ValueIsFilled(ThisObject.LedgerType) Then
		Return;
	EndIf;
	For Each Row In ThisObject.AccountingAnalytics Do
		Row.IsVisible = (Row.LedgerType = ThisObject.LedgerType);
	EndDo;
EndProcedure

&AtServer
Procedure FillAccountingAnalytics(ArrayOfAnalytics)	
	For Each AccountingAnalytic In ArrayOfAnalytics Do
		NewRow = ThisObject.AccountingAnalytics.Add();
		NewRow.Key = AccountingAnalytic.Key;
		
		NewRow.LedgerType = AccountingAnalytic.LedgerType;
		NewRow.Identifier = AccountingAnalytic.Identifier;
		
		// Debit
		NewRow.AccountDebit = AccountingAnalytic.AccountDebit;
		Counter = 1;
		For Each Row In AccountingAnalytic.DebitExtDimensions Do
			NewRow["ExtDimensionTypeDr" + Counter] = Row.ExtDimensionType;
			NewRow["ExtDimensionDr" + Counter] = Row.ExtDimension;
			Counter = Counter + 1;
		EndDo;
		
		// Credit
		NewRow.AccountCredit = AccountingAnalytic.AccountCredit;
		Counter = 1;
		For Each Row In AccountingAnalytic.CreditExtDimensions Do
			NewRow["ExtDimensionTypeCr" + Counter] = Row.ExtDimensionType;
			NewRow["ExtDimensionCr" + Counter] = Row.ExtDimension;
			Counter = Counter + 1;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure AccountingAnalyticsOnActivateRow(Item)
	CurrentData = Items.AccountingAnalytics.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	SetColumnTitle(CurrentData);
EndProcedure

&AtClient
Procedure AccountingAnalyticsAccountDebitOnChange(Item)
	CurrentData = Items.AccountingAnalytics.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
		
	CurrentData.ExtDimensionTypeDr1 = Undefined;
	CurrentData.ExtDimensionTypeDr2 = Undefined;
	CurrentData.ExtDimensionTypeDr3 = Undefined;
	
	If ValueIsFilled(CurrentData.AccountDebit) Then
		Counter = 1;
		ArrayOfExtDimensions = GetExtDimensionTypes(CurrentData.AccountDebit);
		For Each ExtDim In ArrayOfExtDimensions Do
			CurrentData["ExtDimensionTypeDr" + Counter] = ExtDim.ExtDimensionType;
			If ExtDim.ArrayOfTypes.Find(TypeOf(CurrentData["ExtDimensionDr" + Counter])) = Undefined Then
				CurrentData["ExtDimensionDr" + Counter] = Undefined;
			EndIf;
			Counter = Counter + 1;
		EndDo;
	EndIf;
	SetColumnTitle(CurrentData);
EndProcedure

&AtClient
Procedure AccountingAnalyticsAccountCreditOnChange(Item)
	CurrentData = Items.AccountingAnalytics.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	CurrentData.ExtDimensionTypeCr1 = Undefined;
	CurrentData.ExtDimensionTypeCr2 = Undefined;
	CurrentData.ExtDimensionTypeCr3 = Undefined;
	
	If ValueIsFilled(CurrentData.AccountCredit) Then
		Counter = 1;
		ArrayOfExtDimensions = GetExtDimensionTypes(CurrentData.AccountCredit);
		For Each ExtDim In ArrayOfExtDimensions Do
			CurrentData["ExtDimensionTypeCr" + Counter] = ExtDim.ExtDimensionType;
			If ExtDim.ArrayOfTypes.Find(TypeOf(CurrentData["ExtDimensionCr" + Counter])) = Undefined Then
				CurrentData["ExtDimensionCr" + Counter] = Undefined;
			EndIf;
			Counter = Counter + 1;
		EndDo;
	EndIf;
	SetColumnTitle(CurrentData);
EndProcedure

&AtServerNoContext
Function GetExtDimensionTypes(Account)
	Result = New Array();
	For Each ExtDim In Account.ExtDimensionTypes Do
		Result.Add(New Structure("ExtDimensionType, ArrayOfTypes", 
			ExtDim.ExtDimensionType, ExtDim.ExtDimensionType.ValueType.Types()));
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure SetColumnTitle(CurrentData)
	For i = 1 To 3 Do
		ColumnTitle = " ";
		If ValueIsFilled(CurrentData["ExtDimensionTypeDr" + i]) Then
			ColumnTitle = String(CurrentData["ExtDimensionTypeDr" + i]);
		ENdIf;
		ThisObject.Items["AccountingAnalyticsExtDimensionDr" + i].Title = ColumnTitle;
	EndDo;
	
	For i = 1 To 3 Do
		ColumnTitle = " ";
		If ValueIsFilled(CurrentData["ExtDimensionTypeCr" + i]) Then
			ColumnTitle = String(CurrentData["ExtDimensionTypeCr" + i]);
		ENdIf;
		ThisObject.Items["AccountingAnalyticsExtDimensionCr" + i].Title = ColumnTitle;
	EndDo;
EndProcedure

&AtClient
Procedure ClearColumnTitle()
	ThisObject.Items.AccountingAnalyticsExtDimensionDr1.Title = " ";
	ThisObject.Items.AccountingAnalyticsExtDimensionDr2.Title = " ";
	ThisObject.Items.AccountingAnalyticsExtDimensionDr3.Title = " ";
	ThisObject.Items.AccountingAnalyticsExtDimensionCr1.Title = " ";
	ThisObject.Items.AccountingAnalyticsExtDimensionCr2.Title = " ";
	ThisObject.Items.AccountingAnalyticsExtDimensionCr3.Title = " ";
EndProcedure

&AtServer
Function GetDefaultAccountingAnalytics(Val Object, MainTableName, RowKey, Filter_LedgerType = Undefined)
	AccountingClientServer.BeforeWriteAccountingDocument(Object, MainTableName, Filter_LedgerType);
	CurrentData = New Structure("Key" , RowKey);
	Result = AccountingClientServer.GetParametersEditTrialBalanceAccounts(Object, CurrentData, MainTableName, Filter_LedgerType);
	Return Result;
EndFunction

&AtClient
Procedure AccountingAnalyticsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure AccountingAnalyticsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure AccountingAnalyticsOnChange(Item)
	CurrentData = Items.AccountingAnalytics.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.IsFixed = True;
EndProcedure


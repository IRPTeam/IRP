
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocumentRef   = Parameters.DocumentRef;
	ThisObject.MainTableName = Parameters.MainTableName;
	ThisObject.RowKey        = Parameters.RowKey;
	
	For Each CompanyLadgerType In Parameters.ArrayOfLadgerTypes Do
		ThisObject.Items.LadgerType.ChoiceList.Add(CompanyLadgerType, String(CompanyLadgerType));
	EndDo;
	If Parameters.ArrayOfLadgerTypes.Count() Then
		ThisObject.LadgerType = Parameters.ArrayOfLadgerTypes[0];
	EndIf;
	
	FillAccountingAnalytics(Parameters.AccountingAnalytics);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Not ThisObject.AccountingAnalytics.Count() Then
		DefaultAnalytics = GetDefaultAccountingAnalytics(ThisObject.FormOwner.Object, ThisObject.MainTableName, ThisObject.RowKey);
		FillAccountingAnalytics(DefaultAnalytics.AccountingAnalytics);
	EndIf;
	SetVisibleByLadgerType();
EndProcedure

&AtClient
Procedure SetByDefault(Command)
	DefaultAnalytics = 
		GetDefaultAccountingAnalytics(ThisObject.FormOwner.Object, ThisObject.MainTableName, ThisObject.RowKey, ThisObject.LadgerType);
	
	ArrayForDelete = New Array();
	For Each Row In ThisObject.AccountingAnalytics Do
		If Row.LadgerType = ThisObject.LadgerType Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		ThisObject.AccountingAnalytics.Delete(ItemForDelete);
	EndDo;
	
	FillAccountingAnalytics(DefaultAnalytics.AccountingAnalytics);
	
	SetVisibleByLadgerType();
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure("AccountingAnalytics, DocumentRef", New Array(), ThisObject.DocumentRef);
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
								|LadgerType,
								|Identifier,
								|IsFixed");
		FillPropertyValues(NewRow, Row);
		Result.AccountingAnalytics.Add(NewRow);
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure LadgerTypeOnChange(Item)
	SetVisibleByLadgerType();
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure SetVisibleByLadgerType()
	If Not ValueIsFilled(ThisObject.LadgerType) Then
		Return;
	EndIf;
	For Each Row In ThisObject.AccountingAnalytics Do
		Row.IsVisible = (Row.LadgerType = ThisObject.LadgerType);
	EndDo;
EndProcedure

&AtServer
Procedure FillAccountingAnalytics(ArrayOfAnalytics)
	ThisObject.Items.AccountingAnalyticsExtDimensionDr1.Title = "";
	ThisObject.Items.AccountingAnalyticsExtDimensionDr2.Title = "";
	ThisObject.Items.AccountingAnalyticsExtDimensionDr3.Title = "";
	ThisObject.Items.AccountingAnalyticsExtDimensionCr1.Title = "";
	ThisObject.Items.AccountingAnalyticsExtDimensionCr2.Title = "";
	ThisObject.Items.AccountingAnalyticsExtDimensionCr3.Title = "";
	
	For Each AccountingAnalytic In ArrayOfAnalytics Do
		NewRow = ThisObject.AccountingAnalytics.Add();
		NewRow.Key = ThisObject.RowKey;
		
		NewRow.LadgerType = AccountingAnalytic.LadgerType;
		NewRow.Identifier = AccountingAnalytic.Identifier;
		
		// Debit
		NewRow.AccountDebit = AccountingAnalytic.AccountDebit;
		Counter = 1;
		For Each Row In AccountingAnalytic.DebitExtDimensions Do
			NewRow["ExtDimensionTypeDr" + Counter] = Row.ExtDimensionType;
			NewRow["ExtDimensionDr" + Counter] = Row.ExtDimension;
			//ThisObject.Items["AccountingAnalyticsExtDimensionDr" + Counter].Title = String(Row.ExtDimensionType);
			Counter = Counter + 1;
		EndDo;
		
		// Credit
		NewRow.AccountCredit = AccountingAnalytic.AccountCredit;
		Counter = 1;
		For Each Row In AccountingAnalytic.CreditExtDimensions Do
			NewRow["ExtDimensionTypeCr" + Counter] = Row.ExtDimensionType;
			NewRow["ExtDimensionCr" + Counter] = Row.ExtDimension;
			//ThisObject.Items["AccountingAnalyticsExtDimensionCr" + Counter].Title = String(Row.ExtDimensionType);
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
	ThisObject.Items.AccountingAnalyticsExtDimensionDr1.Title = String(CurrentData.ExtDimensionTypeDr1);
	ThisObject.Items.AccountingAnalyticsExtDimensionDr2.Title = String(CurrentData.ExtDimensionTypeDr2);
	ThisObject.Items.AccountingAnalyticsExtDimensionDr3.Title = String(CurrentData.ExtDimensionTypeDr3);
	ThisObject.Items.AccountingAnalyticsExtDimensionCr1.Title = String(CurrentData.ExtDimensionTypeCr1);
	ThisObject.Items.AccountingAnalyticsExtDimensionCr2.Title = String(CurrentData.ExtDimensionTypeCr2);
	ThisObject.Items.AccountingAnalyticsExtDimensionCr3.Title = String(CurrentData.ExtDimensionTypeCr3);
EndProcedure


&AtServer
Function GetDefaultAccountingAnalytics(Val Object, MainTableName, RowKey, Filter_LadgerType = Undefined)
	AccountingClientServer.BeforeWriteAccountingDocument(Object, MainTableName, Filter_LadgerType);
	CurrentData = New Structure("Key" , RowKey);
	Result = AccountingClientServer.GetParametersEditTrialBallanceAccounts(Object, CurrentData, MainTableName, Filter_LadgerType);
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


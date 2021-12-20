
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocumentRef = Parameters.DocumentRef;
	ThisObject.AccountingAnalyticsType = Parameters.AccountingAnalyticsType;
	
	For Each CompanyLadgerType In Parameters.ArrayOfLadgerTypes Do
		ThisObject.Items.LadgerType.ChoiceList.Add(CompanyLadgerType, String(CompanyLadgerType));
	EndDo;
	If Parameters.ArrayOfLadgerTypes.Count() Then
		ThisObject.LadgerType = Parameters.ArrayOfLadgerTypes[0];
	EndIf;
	
	For Each AccountingAnalytic In Parameters.AccountingAnalytics Do
		NewRow = ThisObject.AccountingAnalytics.Add();
		NewRow.Key = Parameters.RowKey;
		
		NewRow.LadgerType = AccountingAnalytic.LadgerType;
		NewRow.Identifier = AccountingAnalytic.Identifier;
		
		// Debit
		If AccountingAnalytic.Property("Debit") Then
			NewRow.AccountDebit = AccountingAnalytic.Debit;
			Counter = 1;
			For Each ExtDim In AccountingAnalytic.DebitExtDimensions Do
				NewRow["ExtDimensionTypeDr" + Counter] = ExtDim.Value.ExtDimensionType;
				NewRow["ExtDimensionDr" + Counter] = ExtDim.Value.ExtDimensionValue;
				Counter = Counter + 1;
			EndDo;
		EndIf;
		// Credit
		If AccountingAnalytic.Property("Credit") Then
			NewRow.AccountCredit = AccountingAnalytic.Credit;
			Counter = 1;
			For Each ExtDim In AccountingAnalytic.CreditExtDimensions Do
				NewRow["ExtDimensionTypeCr" + Counter] = ExtDim.Value.ExtDimensionType;
				NewRow["ExtDimensionCr" + Counter] = ExtDim.Value.ExtDimensionValue;
				Counter = Counter + 1;
			EndDo;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure("AccountingAnalytics, DocumentRef, AccountingAnalyticsType", 
		New Array(), ThisObject.DocumentRef, ThisObject.AccountingAnalyticsType);
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
								|Identifier");
		FillPropertyValues(NewRow, Row);
		Result.AccountingAnalytics.Add(NewRow);
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure



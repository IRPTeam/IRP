
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each CompanyLadgerType In Parameters.ArrayOfLadgerTypes Do
		ThisObject.Items.LadgerType.ChoiceList.Add(CompanyLadgerType, String(CompanyLadgerType));
	EndDo;
	If Parameters.ArrayOfLadgerTypes.Count() Then
		ThisObject.LadgerType = Parameters.ArrayOfLadgerTypes[0];
	EndIf;
	
	For Each AccountingAnalytic In Parameters.AccountingAnalytics Do
		NewRow = ThisObject.AccountingAnalytics.Add();
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

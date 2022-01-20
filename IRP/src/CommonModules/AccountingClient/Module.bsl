
Procedure EditTrialBallanceAccounts(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	Form.Modified = True;
	
	DebitType = PredefinedValue("Enum.AccountingAnalyticTypes.Debit");
	CreditType = PredefinedValue("Enum.AccountingAnalyticTypes.Credit");
	
	For Each Row In Result.AccountingAnalytics Do
		DeleteAccountingRows(Object, Row.Key);
		NewRow = Object.AccountingRowAnalytics.Add();
		NewRow.Key = Row.Key;
		NewRow.IsFixed = Row.IsFixed;
		NewRow.Identifier    = Row.Identifier;
		NewRow.LadgerType    = Row.LadgerType;
		NewRow.AccountDebit  = Row.AccountDebit;
		NewRow.AccountCredit = Row.AccountCredit;
		
		AddExtDimensionRow(Object, Row, DebitType, Row.ExtDimensionTypeDr1, Row.ExtDimensionDr1);
		AddExtDimensionRow(Object, Row, DebitType, Row.ExtDimensionTypeDr2, Row.ExtDimensionDr2);
		AddExtDimensionRow(Object, Row, DebitType, Row.ExtDimensionTypeDr3, Row.ExtDimensionDr3);
		
		AddExtDimensionRow(Object, Row, CreditType, Row.ExtDimensionTypeCr1, Row.ExtDimensionCr1);
		AddExtDimensionRow(Object, Row, CreditType, Row.ExtDimensionTypeCr2, Row.ExtDimensionCr2);
		AddExtDimensionRow(Object, Row, CreditType, Row.ExtDimensionTypeCr3, Row.ExtDimensionCr3);
		
	EndDo;
EndProcedure

Procedure DeleteAccountingRows(Object, KeyForDelete)
	// AccountingRowAnalytics
	ArrayForDelete = New Array();
	For Each Row In Object.AccountingRowAnalytics Do
		If Row.Key = KeyForDelete Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AccountingRowAnalytics.Delete(ItemForDelete);
	EndDo;
	
	// AccountingExtDimensions
	ArrayForDelete.Clear();
	For Each Row In Object.AccountingExtDimensions Do
		If Row.Key = KeyForDelete Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AccountingExtDimensions.Delete(ItemForDelete);
	EndDo;
EndProcedure

Procedure AddExtDimensionRow(Object, AnalyticRow, AnalyticType, ExtDimType, ExtDim)
	NewRow = Object.AccountingExtDimensions.Add();
	NewRow.Key = AnalyticRow.Key;
	NewRow.Identifier   = AnalyticRow.Identifier;
	NewRow.LadgerType   = AnalyticRow.LadgerType;
	NewRow.AnalyticType = AnalyticType;
	NewRow.ExtDimensionType = ExtDimType;
	NewRow.ExtDimension     = ExtDim;
EndProcedure

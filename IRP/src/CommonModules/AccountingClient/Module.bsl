
Procedure OpenFormEditAccounting(Object, Form, CurrentData, TableName) Export	
	FormParameters = AccountingClientServer.GetParametersEditAccounting(Object, CurrentData, TableName);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object1", Object);
	NotifyParameters.Insert("For1m"  , Form);
	Notify = New NotifyDescription("EditAccounting", ThisObject, NotifyParameters);
	OpenForm("CommonForm.EditAccounting", FormParameters, Form, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure OpenFormSelectLedgerType(FormOwner, BasisRef, ArrayOfJournalEntries) Export
	FormParameters = New Structure();
	FormParameters.Insert("ArrayOfJournalEntries", ArrayOfJournalEntries);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("FormOwner" , FormOwner);
	NotifyParameters.Insert("BasisRef"  , BasisRef);
	Notify = New NotifyDescription("SelectLedgerType", ThisObject, NotifyParameters);
	OpenForm("Document.JournalEntry.Form.SelectLedgerType", FormParameters, FormOwner, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure OpenFormJournalEntry(FormOwner, BasisRef, JournalEntryRef, LedgerTypeRef) Export
	FormParameters = New Structure();
	FormParameters.Insert("Key", JournalEntryRef);
	
	FillingValues = New Structure();
	FillingValues.Insert("Basis"      , BasisRef);
	FillingValues.Insert("LedgerType" , LedgerTypeRef);
	
	FormParameters.Insert("FillingValues", FillingValues);
	OpenForm("Document.JournalEntry.ObjectForm", FormParameters, FormOwner);
EndProcedure

Procedure EditAccounting(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	Form.Modified = True;
	
	DebitType = PredefinedValue("Enum.AccountingAnalyticTypes.Debit");
	CreditType = PredefinedValue("Enum.AccountingAnalyticTypes.Credit");
	
	Object.AccountingRowAnalytics.Clear();
	Object.AccountingExtDimensions.Clear();
	
	For Each Row In Result.AccountingAnalytics Do
		NewRow = Object.AccountingRowAnalytics.Add();
		NewRow.Key = Row.Key;
		NewRow.IsFixed = Row.IsFixed;
		NewRow.Operation     = Row.Operation;
		NewRow.LedgerType    = Row.LedgerType;
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

Procedure SelectLedgerType(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	OpenFormJournalEntry(AdditionalParameters.FormOwner, 
		AdditionalParameters.BasisRef, 
		Result.JournalEntryRef, 
		Result.LedgerTypeRef);
EndProcedure

Procedure AddExtDimensionRow(Object, AnalyticRow, AnalyticType, ExtDimType, ExtDim)
	If Not ValueIsFilled(ExtDim) Then
		Return;
	EndIf;
	NewRow = Object.AccountingExtDimensions.Add();
	NewRow.Key = AnalyticRow.Key;
	NewRow.Operation    = AnalyticRow.Operation;
	NewRow.LedgerType   = AnalyticRow.LedgerType;
	NewRow.AnalyticType = AnalyticType;
	NewRow.ExtDimensionType = ExtDimType;
	NewRow.ExtDimension     = ExtDim;
EndProcedure

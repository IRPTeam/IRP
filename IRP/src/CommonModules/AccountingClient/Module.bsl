
Procedure OpenFormEditAccounting(Object, Form, CurrentData, TableName) Export	
	FormParameters = AccountingClientServer.GetParametersEditAccounting(Object,
											                            Form.AccountingRowAnalytics,
											                            Form.AccountingExtDimensions, 
																		CurrentData, 
																		TableName);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , Form);
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

Procedure OpenFormSelectLedgerType_MultipleDocuments(FormOwner, ArrayOfDocuments, ArrayOfLedgerTypes) Export
	FormParameters = New Structure();
	FormParameters.Insert("MultipleDocuments", True);
	FormParameters.Insert("ArrayOfLedgerTypes", ArrayOfLedgerTypes);
	FormParameters.Insert("ArrayOfDocuments", ArrayOfDocuments);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("FormOwner" , FormOwner);
	NotifyParameters.Insert("ArrayOfDocuments"  , ArrayOfDocuments);
	Notify = New NotifyDescription("SelectLedgerType_MultipleDocuments", ThisObject, NotifyParameters);
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
	
	ArrayForDelete_Analytics = New Array();
	ArrayForDelete_Dimensions = New Array();
	
	ProcessedKeys = New Array();
	
	For Each Row In Result.AccountingAnalytics Do
		If ProcessedKeys.Find(Row.Key) <> Undefined Then
			Continue;
		EndIf;
		
		If ValueIsFilled(Row.Key) Then
			ProcessedKeys.Add(Row.Key);
			
			For Each Row_Analytics In Form.AccountingRowAnalytics Do
				If Row_Analytics.Key = Row.Key Then
					ArrayForDelete_Analytics.Add(Row_Analytics);
				EndIf;
			EndDo;
	
			For Each Row_Dimensions In Form.AccountingExtDimensions Do
				If Row_Dimensions.Key = Row.Key Then
					ArrayForDelete_Dimensions.Add(Row_Dimensions);
				EndIf;
			EndDo;
		
		EndIf;
	EndDo;
	
	For Each ArrayItem In ArrayForDelete_Analytics Do
		Form.AccountingRowAnalytics.Delete(ArrayItem);
	EndDo;
	
	For Each ArrayItem In ArrayForDelete_Dimensions Do
		Form.AccountingExtDimensions.Delete(ArrayItem);
	EndDo;
	
	ArrayForDelete_Analytics.Clear();
	ArrayForDelete_Dimensions.Clear();
	
	For Each Row In Form.AccountingRowAnalytics Do
		If Not ValueIsFilled(Row.Key) Then
			ArrayForDelete_Analytics.Add(Row);
		EndIf;
	EndDo;
	
	For Each ArrayItem In ArrayForDelete_Analytics Do
		Form.AccountingRowAnalytics.Delete(ArrayItem);
	EndDo;
	
	For Each Row In Form.AccountingExtDimensions Do
		If Not ValueIsFilled(Row.Key) Then
			ArrayForDelete_Dimensions.Add(Row);
		EndIf;
	EndDo;
	
	For Each ArrayItem In ArrayForDelete_Dimensions Do
		Form.AccountingExtDimensions.Delete(ArrayItem);
	EndDo;
	
	For Each Row In Result.AccountingAnalytics Do
		NewRow = Form.AccountingRowAnalytics.Add();
		NewRow.Key = Row.Key;
		NewRow.IsFixed = Row.IsFixed;
		NewRow.Operation     = Row.Operation;
		NewRow.LedgerType    = Row.LedgerType;
		NewRow.AccountDebit  = Row.AccountDebit;
		NewRow.AccountCredit = Row.AccountCredit;
		
		AddExtDimensionRow(Object, Form, Row, DebitType, Row.ExtDimensionTypeDr1, Row.ExtDimensionDr1);
		AddExtDimensionRow(Object, Form, Row, DebitType, Row.ExtDimensionTypeDr2, Row.ExtDimensionDr2);
		AddExtDimensionRow(Object, Form, Row, DebitType, Row.ExtDimensionTypeDr3, Row.ExtDimensionDr3);
		
		AddExtDimensionRow(Object, Form, Row, CreditType, Row.ExtDimensionTypeCr1, Row.ExtDimensionCr1);
		AddExtDimensionRow(Object, Form, Row, CreditType, Row.ExtDimensionTypeCr2, Row.ExtDimensionCr2);
		AddExtDimensionRow(Object, Form, Row, CreditType, Row.ExtDimensionTypeCr3, Row.ExtDimensionCr3);
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

Procedure SelectLedgerType_MultipleDocuments(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	AccountingServer.CreateJE_ByArrayRefs(AdditionalParameters.ArrayOfDocuments, Result.ArrayOfLedgerTypes);
EndProcedure

Procedure AddExtDimensionRow(Object, Form, AnalyticRow, AnalyticType, ExtDimType, ExtDim)
	If Not ValueIsFilled(ExtDim) Then
		Return;
	EndIf;
	NewRow = Form.AccountingExtDimensions.Add();
	NewRow.Key = AnalyticRow.Key;
	NewRow.Operation    = AnalyticRow.Operation;
	NewRow.LedgerType   = AnalyticRow.LedgerType;
	NewRow.AnalyticType = AnalyticType;
	NewRow.ExtDimensionType = ExtDimType;
	NewRow.ExtDimension     = ExtDim;
EndProcedure

Procedure OpenHistoryByStatus(DocumentRef, FormOwner, AddInfo = Undefined) Export
	If Not ValueIsFilled(DocumentRef) Then
		Return;
	EndIf;
	
	Filter = New Structure("Object", DocumentRef);
	OpenParameters = New Structure("Filter", Filter);
	OpenForm("InformationRegister."
		+ ObjectStatusesServer.GetObjectStatusesInformationRegisterName(DocumentRef)
		+ ".Form.ListForm", OpenParameters, FormOwner, , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure StatusStartChoice(Object, Form, ArrayOfFilters, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	ChoiceForm = GetForm("Catalog.ObjectStatuses.ChoiceForm", , Item, Form.UUID, , Form.URL);
	For Each Filter In ArrayOfFilters Do
		FilterItem = ChoiceForm.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.LeftValue = New DataCompositionField(Filter.FieldName);
		FilterItem.RightValue = Filter.Value;
		FilterItem.ComparisonType = Filter.ComparisonType;
	EndDo;
	ChoiceForm.Open();
EndProcedure

Procedure StatusEditTextChange(Object,
                               Form,
                               ArrayOfFilters, 
                               AdditionalParameters, 
                               Item, 
                               Text, 
                               StandardProcessing) Export
	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter",
	                                                DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters",
	                                                DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

Function GetAvailableStatusesByCheque(ChequeBondTransactionRef, ChequeRef) Export
	Return ObjectStatusesServer.GetAvailableStatusesByCheque(ChequeBondTransactionRef, ChequeRef);
EndFunction
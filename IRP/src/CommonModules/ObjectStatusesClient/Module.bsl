Procedure OpenHistoryByStatus(DocumentRef, FormOwner, AddInfo = Undefined) Export
	If Not ValueIsFilled(DocumentRef) Then
		Return;
	EndIf;

	Filter = New Structure("Object", DocumentRef);
	OpenParameters = New Structure("Filter", Filter);
	OpenForm("InformationRegister." + ObjectStatusesServer.GetObjectStatusesInformationRegisterName(DocumentRef)
		+ ".Form.ListForm", OpenParameters, FormOwner, , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure StatusEditTextChange(Object, Form, ArrayOfFilters, AdditionalParameters, Item, Text, StandardProcessing) Export
	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter"   , DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters" , DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure


&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.ProfitLossCenter = Parameters.ProfitLossCenter;
 	ThisObject.ExpenseType = Parameters.ExpenseType;
	ThisObject.Detail = Parameters.Detail;
	
	If Parameters.ReadOnly Then
		Items.ProfitLossCenter.ReadOnly = True;
		Items.ExpenseType.ReadOnly = True;
		Items.Detail.ReadOnly = True;
		Items.FormSave.Visible = False;
	EndIf;

EndProcedure

&AtClient
Procedure Save(Command)
	
	Result = New Structure();
	Result.Insert("ProfitLossCenter", ProfitLossCenter);
	Result.Insert("ExpenseType", ExpenseType);
	Result.Insert("Detail", Detail);
	
	Close(Result);

EndProcedure

#Region EXPENSE_TYPE

&AtClient
Procedure ExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsExpense", True,
		DataCompositionComparisonType.Equal));

	OpenSettings.FillingData = New Structure();
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("CurrentRow", New Structure("ExpenseType", ExpenseType));

	DocumentsClient.ExpenseAndRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);

EndProcedure

&AtClient
Procedure ExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.ExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion


#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "");
EndProcedure

#EndRegion

#Region PAYMENT_LIST

Procedure PaymentListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.PaymentListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

#Region PAYMENT_LIST_COLUMNS

Procedure PaymentListAccountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListAccountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#Region ItemFormEvents

#Region COMPANY

Procedure CompanyOnChange(Object) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

Procedure DataPeriodOnChange(Object, Period) Export
	Object.BegOfPeriod = Period.StartDate;
	Object.EndOfPeriod = Period.EndDate;
EndProcedure

Procedure StatusOnChange(Object) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

Procedure BranchOnChange(Object) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

Procedure DateOnChange(Object) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

Procedure NumberOnChange(Object) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object.Object, Object.ThisForm);
EndProcedure

#Region FinancialMovementType

Procedure PaymentListFinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListFinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

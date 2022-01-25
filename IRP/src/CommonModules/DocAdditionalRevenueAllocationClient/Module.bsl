
Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", 
																	True, DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure("OurCompany", True);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#Region GroupTitleDecorationsEvents

Procedure DecorationGroupTitleCollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLabelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLabelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

#EndRegion

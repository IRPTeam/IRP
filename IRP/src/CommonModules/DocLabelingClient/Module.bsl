#Region FormEvents

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
	
	// GroupTitle
	If ValueIsFilled(Object.Ref) Then
		DocLabelingClient.ChangeGroupTitleTitle(Object, Form);
		DocLabelingClient.ChangeTitleCollapse(Object, Form, False);
	Else
		DocLabelingClient.ChangeTitleCollapse(Object, Form, True);
	EndIf;
	
EndProcedure

#EndRegion


#Region ItemDescription

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#EndRegion


#Region GroupTitle

Procedure ChangeGroupTitleTitle(Object, Form) Export
	TitleArray = New Array;
	If ValueIsFilled(Object.Date) Then
		TitleArray.Add(Object.Date);
	EndIf;
	If ValueIsFilled(Object.Number) Then
		TitleArray.Add(Object.Number);
	EndIf;
	Form.Items.DecorationGroupTitleCollapsedLabel.Title = StrConcat(TitleArray, " | ");
	Form.Items.DecorationGroupTitleUncollapsedLabel.Title = StrConcat(TitleArray, " | ");
EndProcedure

Procedure ChangeTitleCollapse(Object, Form, TitleVisible = True) Export
	Form.Items.GroupTitleCollapsed.Visible = Not TitleVisible;
	Form.Items.GroupTitleUncollapsed.Visible = TitleVisible;
	Form.Items.GroupTitleItems.Visible = TitleVisible;
EndProcedure

#Region GroupTitleDecorationsEvents

Procedure DecorationGroupTitleCollapsedPictureClick(Object, Form, Item) Export
	DocLabelingClient.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLalelClick(Object, Form, Item) Export
	DocLabelingClient.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object, Form, Item) Export
	DocLabelingClient.ChangeTitleCollapse(Object, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLalelClick(Object, Form, Item) Export
	DocLabelingClient.ChangeTitleCollapse(Object, Form, False);
EndProcedure

#EndRegion

#EndRegion


#Region ItemItemList

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	If Form.InputType = "Item" Then
		OpenSettings = DocumentsClient.GetOpenSettingsStructure();
		
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
		DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	EndIf;
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	If Form.InputType = "Item" Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
	EndIf;
EndProcedure

#EndRegion
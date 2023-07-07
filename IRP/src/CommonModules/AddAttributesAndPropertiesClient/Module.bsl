
Procedure AddAttributeStartChoice(Form, Item, StandardProcessing, AddInfo = Undefined) Export
	If TypeOf(Form[Item.Name]) = Type("CatalogRef.AddAttributeAndPropertyValues") Then
		StandardProcessing = False;
		PropertyOwner = Form[Item.Name + "_owner"]; // ChartOfCharacteristicTypesRef.AddAttributeAndProperty 
		Filter = New Structure("Owner", PropertyOwner);
		OpenArgs = New Structure("Filter", Filter);
		OpenForm("Catalog.AddAttributeAndPropertyValues.ChoiceForm", OpenArgs, Item);
	EndIf;
EndProcedure

Procedure SetRequiredAtAllSets(Object, Form, Command) Export
	Types = New TypeDescription("Boolean");
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	Notify = New NotifyDescription("SetRequiredAtAllSetsEnd", ThisObject, NotifyParameters);
	ShowInputValue(Notify, False, R().SuggestionToUser_1, Types);
EndProcedure

Procedure SetRequiredAtAllSetsEnd(Result, AddionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Object = AddionalParameters.Object;
	AddAttributesAndPropertiesServer.SetRequiredAtAllSets(Object.Ref, Result);
EndProcedure

Procedure AddAttributeButtonClick(Form, Item, AddInfo = Undefined) Export
	NameParts = StrSplit(Item.Name, "_", False);
	CommandName = NameParts[NameParts.Count() - 1];
	If CommandName = "EditURL" Then
		Form.Items["__" + NameParts[0] + "Pages"].CurrentPage = Form.Items["__" + NameParts[0] + "PageEdit"]; 
	ElsIf CommandName = "SaveURL" Then
		Form.Items["__" + NameParts[0] + "_URL"].Title = Form["__" + NameParts[0]];
		Form.Items["__" + NameParts[0] + "Pages"].CurrentPage = Form.Items["__" + NameParts[0] + "PageURL"]; 
	ElsIf CommandName = "URL" Then
		GotoURL(Form["__" + NameParts[0]]);
	EndIf; 
EndProcedure

#Region HTML

Procedure UpdateObjectAddAttributeHTML(Form, OwnerRef) Export
	Form.AddAttributeViewHTML = AddAttributesAndPropertiesServer.HTMLAddAttributes();
EndProcedure

Function AddAttributeInfoForHTML(ItemRef, UUID, FileRef = Undefined) Export
	Filter = New Structure("ShowInHTML", True);
	Return AddAttributesAndPropertiesServer.PrepareDataForHTML(ItemRef, Filter);
EndFunction

#EndRegion

// @strict-types

// Add attribute start choice.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  Item - FormField, CheckBox - Item
//  StandardProcessing - Boolean - Standard processing
//  AddInfo - Undefined - Add info
Procedure AddAttributeStartChoice(Form, Item, StandardProcessing, AddInfo = Undefined) Export
	If TypeOf(Form[Item.Name]) = Type("CatalogRef.AddAttributeAndPropertyValues") Then
		StandardProcessing = False;
		PropertyOwner = Form[Item.Name + "_owner"]; // ChartOfCharacteristicTypesRef.AddAttributeAndProperty 
		Filter = New Structure("Owner", PropertyOwner);
		OpenArgs = New Structure("Filter", Filter);
		OpenForm("Catalog.AddAttributeAndPropertyValues.ChoiceForm", OpenArgs, Item);
	EndIf;
EndProcedure

// Set required at all sets.
// 
// Parameters:
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
//  Command - FormCommand - Command
Procedure SetRequiredAtAllSets(Object, Form, Command) Export
	Types = New TypeDescription("Boolean");
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	Notify = New NotifyDescription("SetRequiredAtAllSetsEnd", ThisObject, NotifyParameters);
	ShowInputValue(Notify, False, R().SuggestionToUser_1, Types);
EndProcedure

// Set required at all sets end.
// 
// Parameters:
//  Result Result
//  AddionalParameters Addional parameters
Procedure SetRequiredAtAllSetsEnd(Result, AddionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Object = AddionalParameters.Object;
	AddAttributesAndPropertiesServer.SetRequiredAtAllSets(Object.Ref, Result);
EndProcedure

#Region HTML
// Update object add attribute HTML.
// 
// Parameters:
//  Form Form
//  OwnerRef Owner ref
Procedure UpdateObjectAddAttributeHTML(Form, OwnerRef) Export
	Form.AddAttributeViewHTML = AddAttributesAndPropertiesServer.HTMLAddAttributes();
EndProcedure

// Add attribute info for HTML.
// 
// Parameters:
//  ItemRef Item ref
//  UUID UUID
//  FileRef - Undefined - File ref
// 
// Returns:
//  Map - Add attribute info for HTML
Function AddAttributeInfoForHTML(ItemRef, UUID, FileRef = Undefined) Export
	Filter = New Structure("ShowInHTML", True);
	Str = AddAttributesAndPropertiesServer.PrepareDataForHTML(ItemRef, Filter);

	For Each Row In Str.Get("Properties") Do
		Row.Icon = PutToTempStorage(Row.Icon, UUID);
	EndDo;
	For Each Row In Str.Get("Attributes") Do
		Row.Icon = PutToTempStorage(Row.Icon, UUID);
	EndDo;
	Return Str;

EndFunction

#EndRegion

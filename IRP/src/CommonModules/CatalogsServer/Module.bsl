// @strict-types

#Region Public

// Add not active filter for data choosing.
// 
// Parameters:
//  Source - CatalogManager - Source
//  Parameters - Structure - Parameters
Procedure SetParametersForDataChoosing(Source, Parameters) Export
	SourceMetadata = Source.EmptyRef().Metadata();
	If Not Metadata.Catalogs.Contains(SourceMetadata) Then
		Return;
	EndIf;
	
	SetParameterFilterForHidingNotActive(Parameters, SourceMetadata);
EndProcedure

// On create at server object.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute -
//  Cancel - Boolean - Cancel
//  StandardProcessing - Boolean - Standard processing
Procedure OnCreateAtServerObject(Form, MainAttribute, Cancel, StandardProcessing) Export
	
	FormNamesArray = StrSplit(Form.FormName, ".");
	CatalogFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	
	ExternalCommandsServer.CreateCommands(Form, CatalogFullName, Enums.FormTypes.ObjectForm);
	InternalCommandsServer.CreateCommands(Form, MainAttribute, CatalogFullName, Enums.FormTypes.ObjectForm);
	
	If Form.Items.Find("Code") <> Undefined And Not ThisIsEditingException(CatalogFullName) Then
		NumberEditingAvailable = SessionParametersServer.GetSessionParameter("NumberEditingAvailable"); // Boolean
		Form.Items.Code.ReadOnly = Not NumberEditingAvailable;
	EndIf;

EndProcedure

// On create at server list form.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute -
//  Cancel - Boolean - Cancel
//  StandardProcessing - Boolean - Standard processing
Procedure OnCreateAtServerListForm(Form, MainAttribute, Cancel, StandardProcessing) Export
	
	FormNamesArray = StrSplit(Form.FormName, ".");
	CatalogFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	
	ExternalCommandsServer.CreateCommands(Form, CatalogFullName, Enums.FormTypes.ListForm);
	InternalCommandsServer.CreateCommands(Form, MainAttribute, CatalogFullName, Enums.FormTypes.ListForm);
	
EndProcedure

// On create at server choice form.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute -
//  Cancel - Boolean - Cancel
//  StandardProcessing - Boolean - Standard processing
Procedure OnCreateAtServerChoiceForm(Form, MainAttribute, Cancel, StandardProcessing) Export
	
	FormNamesArray = StrSplit(Form.FormName, ".");
	CatalogFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	
	ExternalCommandsServer.CreateCommands(Form, CatalogFullName, Enums.FormTypes.ChoiceForm);
	InternalCommandsServer.CreateCommands(Form, MainAttribute, CatalogFullName, Enums.FormTypes.ChoiceForm);
	
EndProcedure

#EndRegion

#Region Internal

Procedure SetSessionParameters() Export

	Data = New Map;
	For Each ContentItem In Metadata.CommonAttributes.NotActive.Content Do
		If ContentItem.Use = Metadata.ObjectProperties.CommonAttributeUse.Use  Then
			Data.Insert(ContentItem.Metadata.FullName(), False);
		EndIf;
	EndDo;
	SessionParameters.NotActiveCatalogsShowing = New FixedMap(Data);
	
EndProcedure

#EndRegion

#Region Private

Procedure SetParameterFilterForHidingNotActive(Parameters, SourceMetadata)
	ShowNotActive = SessionParameters.NotActiveCatalogsShowing.Get(SourceMetadata.FullName());
	If ShowNotActive = False Then
		If Not Parameters.Property("Filter") Then
			Parameters.Insert("Filter", New Structure); 
		EndIf;
		Parameters.Filter.Insert("NotActive", False);
	EndIf;
EndProcedure

// This is editing exception.
// 
// Parameters:
//  CatalogName - String - Catalog name
// 
// Returns:
//  Boolean - This is editing exception
Function ThisIsEditingException(CatalogName)
	
	If CatalogName = "Catalog.Currencies"
			OR CatalogName = "Catalog.Incoterms"
			OR CatalogName = "Catalog.RetailCustomers" Then
		Return True;
	EndIf;
	
	Return False;
	
EndFunction

#EndRegion

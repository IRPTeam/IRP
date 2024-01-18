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
	
	ExternalCommandsServer.CreateCommands(Form, CatalogFullName, Enums.FormTypes.ListForm);
	InternalCommandsServer.CreateCommands(Form, MainAttribute, CatalogFullName, Enums.FormTypes.ListForm);
	
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

#EndRegion

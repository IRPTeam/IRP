// @strict-types
// @skip-check module-structure-top-region

#Region FormEventHandlers

// On create at server.
// 
// Parameters:
//  Cancel - Boolean - Cancel
//  StandardProcessing - Boolean - Standard processing
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CommandDescription = DataProcessors.InternalCommands.GetCommandDescription(StrSplit(FormName, ".")[3]);
EndProcedure

// On open.
// 
// Parameters:
//  Cancel - Boolean - Cancel
&AtClient
Procedure OnOpen(Cancel)
	Cancel = True;
EndProcedure

#EndRegion

#Region Public

// See InternalCommandsClient.Form_RunCommandAction
&AtClient
Procedure RunCommandAction(Form, MainAttribute, Targets, AddInfo = Undefined) Export

	NameParts = StrSplit(Form.FormName, ".");
	FullName = NameParts[0] + "." + NameParts[1];
	
	ShowingStatus = ChangeShowingStatus(FullName);  

	ParamShowNotActive = New DataCompositionParameter("ShowNotActive");
	For Each ParameterItem In MainAttribute.Parameters.Items Do // DataCompositionParameter
		If ParameterItem.Parameter = ParamShowNotActive Then
			ParameterItem.Value = ShowingStatus; 
		EndIf;
	EndDo;
	
	Form.RefreshDataRepresentation();
	
EndProcedure

#EndRegion

#Region PrivateServer

// Change showing status.
// 
// Parameters:
//  ObjectFullName - String - Object full name
// 
// Returns:
//  Boolean - Change showing status
&AtServer
Function ChangeShowingStatus(ObjectFullName)
	
	NotActiveCatalogsShowingMap = New Map(SessionParameters.NotActiveCatalogsShowing);
	NotActiveCatalogsShowingMap[ObjectFullName] = Not NotActiveCatalogsShowingMap[ObjectFullName];
	
	Result = NotActiveCatalogsShowingMap[ObjectFullName]; // Boolean
	
	SessionParameters.NotActiveCatalogsShowing = New FixedMap(NotActiveCatalogsShowingMap);
	
	Return Result;
	
EndFunction

#EndRegion

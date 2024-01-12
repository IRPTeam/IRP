// @strict-types

#Region Internal

// Run command action.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute - Main form attribute
//  Targets - AnyRef, Array - Command target
//  AddInfo - Undefined -  Add info
Procedure RunCommandAction(Form, MainAttribute, Targets, AddInfo = Undefined) Export

	NameParts = StrSplit(Form.FormName, ".");
	FullName = NameParts[0] + "." + NameParts[1];
	
	ShowingStatus = InternalCommand_ShowNotActive_Server.ChangeShowingStatus(FullName);  

	ParamShowNotActive = New DataCompositionParameter("ShowNotActive");
	For Each ParameterItem In MainAttribute.Parameters.Items Do
		If ParameterItem.Parameter = ParamShowNotActive Then
			ParameterItem.Value = ShowingStatus; 
		EndIf;
	EndDo;
	
	Form.RefreshDataRepresentation();
	
EndProcedure

#EndRegion
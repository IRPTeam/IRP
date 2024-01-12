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

	InternalCommand_SetNotActive_Server.CommandProcessingAtServer(Targets, AddInfo);
	
EndProcedure

#EndRegion

#Region Private

// Run action after running.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute - Main form attribute
//  Targets - AnyRef, Array - Command target
//  AddInfo - Undefined - Add info
Procedure AfterRunning(Form, MainAttribute, Targets, AddInfo = Undefined) Export
	
	If TypeOf(Targets) = Type("Array") Then
		For Each Target In Targets Do
			NotifyChanged(Target);
		EndDo;
	Else
		NotifyChanged(Targets);
	EndIf;
	
	Form.RefreshDataRepresentation();
	
EndProcedure

#EndRegion

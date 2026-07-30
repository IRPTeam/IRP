
&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocumentsServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsBatchReallocate = (Object.CalculationMode = PredefinedValue("Enum.CalculationMode.LandedCostBatchReallocate"));
	Form.Items.CalculationMode.ReadOnly = Not FOServer.IsUseBatchReallocate();
	Form.Items.Company.ReadOnly = IsBatchReallocate;
	Form.Items.Company.AutoMarkIncomplete = Not IsBatchReallocate;
EndProcedure

&AtClient
Procedure CalculationModeOnChange(Item)
	If Object.CalculationMode = PredefinedValue("Enum.CalculationMode.LandedCostBatchReallocate") Then
		Object.Company = Undefined;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure CompanyOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion
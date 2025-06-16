// @strict-types

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Object.Ref.IsEmpty() Then
		Cancel = True;
	EndIf;
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	SetVisible();
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisible();
EndProcedure

#EndRegion

#Region FormItemsEvents

// Description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure AcceptForExecution(Command)
	AcceptForExecutionServer();
EndProcedure

&AtClient
Procedure Comleted(Command)
	ComletedAtServer();
	Close();
EndProcedure

&AtClient
Procedure Canceled(Command)
	If IsBlankString(Object.Comment) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_149, "Object.Comment");
		Return;
	EndIf;
	
	ComletedAtServer(True);
	Close();
EndProcedure

#EndRegion

#Region Other

&AtServer
Procedure SetVisible()
	
	Items.UserGroup.Visible = Not Object.UserGroup.IsEmpty();
	Items.Position.Visible = Not Object.Position.IsEmpty();
	Items.Branch.Visible = Not Object.Branch.IsEmpty();
	Items.ProfitLossCenter.Visible = Not Object.ProfitLossCenter.IsEmpty();
	
	Items.AcceptForExecution.Visible = Object.CurrentExecutor.IsEmpty();
	
	//@skip-check statement-type-change, property-return-type
	If Object.TaskType = Enums.TaskTypes.Execution Then
		Items.FormComleted.Title = R().Task_Result_Execution;
		Items.FormCanceled.Title = R().Task_Result_Execution_Not;
		
	ElsIf Object.TaskType = Enums.TaskTypes.Verification Then
		Items.FormComleted.Title = R().Task_Result_Verification;
		Items.FormCanceled.Title = R().Task_Result_Verification_Not;
		
	ElsIf Object.TaskType = Enums.TaskTypes.Confirmation Then
		Items.FormComleted.Title = R().Task_Result_Confirmation;
		Items.FormCanceled.Title = R().Task_Result_Confirmation_Not;
		
	EndIf;
	
	Items.FormComleted.Enabled = Not Object.Executed;
	Items.FormCanceled.Enabled = Not Object.Executed;
	
EndProcedure

&AtServer
Procedure AcceptForExecutionServer()
	
	Object.CurrentExecutor = SessionParameters.CurrentUser;
	Object.AcceptetionForExecutionDate = CommonFunctionsServer.GetCurrentSessionDate();
	
	Write();
	
EndProcedure

&AtServer
Procedure ComletedAtServer(Canceled = False)
	
	ServerObject = FormAttributeToValue("Object");
	ServerObject.Canceled = Canceled;
	ServerObject.ExecuteTask();
	
	ThisObject.Read();
		
EndProcedure

#EndRegion
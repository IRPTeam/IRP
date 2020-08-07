
#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	For Each PayButton In Parameters.PayButtons Do
		NewCommand = Commands.Add(PayButton.Value);
		NewCommand.Action = "PayButtonPress";
		NewCommand.Title = PayButton.Presentation;
		NewItem = Items.Add(PayButton.Value, Type("FormButton"), Items.GroupButtons);
		NewItem.Type = FormButtonType.UsualButton;
		NewItem.Title = PayButton.Presentation;
		NewItem.CommandName = NewCommand.Name;
		NewItem.Font = New Font(NewItem.Font, , 20, True);
	EndDo;

EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure PayButtonPress(Command)
	ButtonNameIndex = Number(StrReplace(Command.Name, "Button", ""));
	Close(ButtonNameIndex);
EndProcedure

&AtClient
Procedure CloseButton(Command)
	Close();
EndProcedure

#EndRegion

#EndRegion
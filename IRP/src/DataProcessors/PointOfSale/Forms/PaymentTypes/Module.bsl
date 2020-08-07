

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
	EndDo;

EndProcedure

&AtClient
Procedure PayButtonPress(Command)
	ButtonNameIndex = Number(StrReplace(Command, "Button", ""));
	Close(ButtonNameIndex);
EndProcedure


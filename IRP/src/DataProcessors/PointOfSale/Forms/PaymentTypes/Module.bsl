#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	For Each PayButton In Parameters.PayButtons Do
		NewCommand = Commands.Add(PayButton.Value);
		NewCommand.Action = "PayButtonPress";
		NewCommand.Title = PayButton.Presentation;
		ShortcutKeyByCommandName = GetShortcutKeyByCommandName(PayButton.Value);
		If ShortcutKeyByCommandName <> Undefined Then
			NewCommand.Shortcut = New Shortcut(ShortcutKeyByCommandName);
		EndIf;
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

#Region Internal

&AtServer
Function GetShortcutKeyByCommandName(CommandName)
	KeysMap = New Map();
	KeysMap.Insert("Button0", Key.Num1);
	KeysMap.Insert("Button1", Key.Num2);
	KeysMap.Insert("Button2", Key.Num3);
	KeysMap.Insert("Button3", Key.Num4);
	KeysMap.Insert("Button4", Key.Num5);
	KeysMap.Insert("Button5", Key.Num6);
	KeysMap.Insert("Button6", Key.Num7);
	KeysMap.Insert("Button7", Key.Num8);
	KeysMap.Insert("Button8", Key.Num9);
	Return KeysMap.Get(CommandName);
EndFunction

#EndRegion
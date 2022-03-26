// @strict-types

#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	ButtonsArray = Parameters.PayButtons; // Array of See POSClient.ButtonSetings
	PayButtonsParent = New Map; 
	
	For Each ButtonSettings In ButtonsArray Do 
		If PayButtonsParent.Get(ButtonSettings.PaymentType.Parent) = Undefined Then
			ButtonsList = New Array;
			ButtonsList.Add(ButtonSettings);
			PayButtonsParent.Insert(ButtonSettings.PaymentType.Parent, ButtonsList);
		Else
			PayButtonsParent.Get(ButtonSettings.PaymentType.Parent).Add(ButtonSettings);
		EndIf;
	EndDo;


	For Each PayGroup In PayButtonsParent Do
		GroupIndex = 0;
		PayButtonsIntoGroup = PayGroup.Value; // Array of See POSClient.ButtonSetings
		For Index = 0 To PayButtonsIntoGroup.UBound() Do
			ButtonSettings = PayButtonsIntoGroup[Index]; 
			ButtonName = StrTemplate("PayButton_%1_%2", GroupIndex, Index);

			NewPayment = LinkedPayButtons.Add();
			NewPayment.ButtonName = ButtonName;
			FillPropertyValues(NewPayment, ButtonSettings);

			NewCommand = Commands.Add(ButtonName);
			NewCommand.Action = "PayButtonPress";
			NewCommand.Title = String(ButtonSettings.PaymentType);
			NewCommand.Shortcut = New Shortcut(Key["Num" + (Index + 1)]);
			NewItem = Items.Add(ButtonName, Type("FormButton"), Items.PaymentTypesButtons);
			NewItem.Type = FormButtonType.UsualButton;
			NewItem.Title = String(ButtonSettings.PaymentType);
			NewItem.CommandName = NewCommand.Name;
			NewItem.Font = StyleFonts.ExtraLargeTextFont;
		EndDo;
	EndDo;

EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure PayButtonPress(Command)
	
	FindPaymentType = LinkedPayButtons.FindRows(New Structure("ButtonName", Command.Name));
	Result = POSClient.ButtonSetings();
	FillPropertyValues(Result, FindPaymentType[0]);

	Close(Result);
	
EndProcedure

&AtClient
Procedure CloseButton(Command)
	
	Close();
	
EndProcedure

#EndRegion

#EndRegion

#Region Internal

#EndRegion
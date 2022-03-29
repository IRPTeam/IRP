// @strict-types

#Region Events

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	ButtonsArray = Parameters.PayButtons; // Array of See POSClient.ButtonSetings
	CreateFormElement(ButtonsArray);
	
	Items.BackToSelectGroup.Shortcut = New Shortcut(Key["Num0"]);
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetHotKey();
EndProcedure

&AtServer
Procedure CreateFormElement(ButtonsArray)

	PayButtonsParent = New Map; 
	
	For Each ButtonSettings In ButtonsArray Do 
		If ButtonSettings.PaymentType.Parent.IsEmpty() Then
			ButtonsList = New Array;
			ButtonsList.Add(ButtonSettings);
			PayButtonsParent.Insert(ButtonSettings.PaymentType, ButtonsList);
		ElsIf PayButtonsParent.Get(ButtonSettings.PaymentType.Parent) = Undefined Then
			ButtonsList = New Array;
			ButtonsList.Add(ButtonSettings);
			PayButtonsParent.Insert(ButtonSettings.PaymentType.Parent, ButtonsList);
		Else
			PayButtonsParent.Get(ButtonSettings.PaymentType.Parent).Add(ButtonSettings);
		EndIf;
	EndDo;

	GroupIndex = 0;
	For Each PayGroup In PayButtonsParent Do
		
		PayButtonsIntoGroup = PayGroup.Value; // Array of See POSClient.ButtonSetings
		
		ButtonName = StrTemplate("Page_%1", GroupIndex);
		NewCommand = Commands.Add(ButtonName);
		NewCommand.Action = "PayButtonGroup";
		NewCommand.Title = String(PayGroup.Key);
			
		NewItem = Items.Add(ButtonName, Type("FormButton"), Items.PaymentGroup);
		NewItem.Type = FormButtonType.UsualButton;
		NewItem.Title = "[" + String(GroupIndex + 1) + "] " + String(PayGroup.Key) + ?(PayButtonsIntoGroup.Count() > 1, " >", "");
		NewItem.CommandName = NewCommand.Name;
		NewItem.Font = StyleFonts.ExtraLargeTextFont;
		NewItem.HorizontalStretch = True;
		
		NewPageItem = Items.Add("ButtonPage_" + GroupIndex, Type("FormGroup"), Items.PaymentPages);
		NewPageItem.Type = FormGroupType.Page;
		NewPageItem.Title = String(PayGroup.Key);
		
		
		For Index = 0 To PayButtonsIntoGroup.UBound() Do
			ButtonSettings = PayButtonsIntoGroup[Index]; 
			ButtonName = StrTemplate("PayButton_%1_%2", GroupIndex, Index);

			NewPayment = LinkedPayButtons.Add();
			NewPayment.ButtonName = ButtonName;
			FillPropertyValues(NewPayment, ButtonSettings);

			NewCommand = Commands.Add(ButtonName);
			NewCommand.Action = "PayButtonPress";
			NewCommand.Title = String(ButtonSettings.PaymentType);
			
			NewItem = Items.Add(ButtonName, Type("FormButton"), NewPageItem);
			NewItem.Type = FormButtonType.UsualButton;
			NewItem.Title = "[" + String(Index + 1) + "] " + String(ButtonSettings.PaymentType);
			NewItem.CommandName = NewCommand.Name;
			NewItem.Font = StyleFonts.ExtraLargeTextFont;
			NewItem.HorizontalStretch = True;
		EndDo;
		GroupIndex = GroupIndex + 1;
	EndDo;
	
	If GroupIndex = 1 Then
		Items.PaymentPages.CurrentPage = NewPageItem;
	EndIf;
	
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure PayButtonPress(Command)
	
	ReturnValueAndCloseForm(Command.Name);
	
EndProcedure

&AtClient
Procedure ReturnValueAndCloseForm(Val CommandName)

	FindPaymentType = LinkedPayButtons.FindRows(New Structure("ButtonName", CommandName));
	Result = POSClient.ButtonSetings();
	FillPropertyValues(Result, FindPaymentType[0]);

	Close(Result);
EndProcedure

&AtClient
Procedure PayButtonGroup(Command)
	ButtonPage = Items.Find("Button" + Command.Name);
	If ButtonPage.ChildItems.Count() = 1 Then
		ReturnValueAndCloseForm(ButtonPage.ChildItems[0].CommandName)
	Else
		Items.PaymentPages.CurrentPage = Items.Find("Button" + Command.Name);
		SetHotKey();
	EndIf;
	
EndProcedure

&AtClient
Procedure BackToSelectGroup(Command)
	
	Items.PaymentPages.CurrentPage = Items.PaymentGroup;
	SetHotKey();
	
EndProcedure

&AtClient
Procedure CloseButton(Command)
	
	Close();
	
EndProcedure

&AtClient
Procedure SetHotKey()
	
	For Each Page In Items.PaymentPages.ChildItems Do
		For Each Item In Page.ChildItems Do
			
			Item.Shortcut = New Shortcut(Key.None);
			
		EndDo;	
	EndDo;
	
	For Each Item In Items.PaymentPages.CurrentPage.ChildItems Do
		
		Array = StrSplit(Item.Name, "_");
		Num = Number(Array[Array.UBound()]) + 1;
		Item.Shortcut = New Shortcut(Key["Num" + Num]);
		
	EndDo;
	
EndProcedure

#EndRegion

#EndRegion

#Region Internal

#EndRegion

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	If Parameters.Key.IsEmpty() Then
		If ValueIsFilled(Object.Parent) Then
			Object.LedgerType = Object.Parent.LedgerType;
			Object.LedgerTypeVariant = Object.Parent.LedgerTypeVariant;
		EndIf;
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;	
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure LedgerTypeOnChange(Item)
	LedgerTypeOnChangeAtServer();
EndProcedure

&AtServer
Procedure LedgerTypeOnChangeAtServer()
	If ValueIsFilled(Object.LedgerType) Then
		Object.LedgerTypeVariant = Object.LedgerType.LedgerTypeVariant;
	Else
		Object.LedgerTypeVariant = Undefined;
	EndIf;
EndProcedure

&AtClient
Procedure ParentOnChange(Item)
	ParentOnChangeAtServer()
EndProcedure

&AtServer
Procedure ParentOnChangeAtServer()
	If ValueIsFilled(Object.Parent) Then
		Object.LedgerType = Object.Parent.LedgerType;
	Else
		Object.LedgerType = Undefined;
	EndIf;
	LedgerTypeOnChangeAtServer();
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsParrentFilled = ValueIsFilled(Object.Parent);
	Form.Items.LedgerType.ReadOnly = IsParrentFilled;
	Form.Items.LedgerTypeVariant.ReadOnly = IsParrentFilled;
EndProcedure




















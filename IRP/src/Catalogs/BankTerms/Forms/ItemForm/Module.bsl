#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetVisible();
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion

#Region Actions

&AtClient
Procedure BankTermTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure SetVisible()
	If Object.BankTermType = PredefinedValue("Enum.BankTermTypes.PaymentAgent") Then
		SetVisibleByBankTermType(False);
	ElsIf Object.BankTermType = PredefinedValue("Enum.BankTermTypes.PaymentTerminal") Then
		SetVisibleByBankTermType(True);
	EndIf;
EndProcedure

&AtClient
Procedure SetVisibleByBankTermType(isTerminal)
	Items.PaymentTypesAccount.Visible = isTerminal;
	Items.PaymentTypesLegalName.Visible = Not isTerminal;
	Items.PaymentTypesLegalNameContract.Visible = Not isTerminal;
	Items.PaymentTypesPartner.Visible = Not isTerminal;
	Items.PaymentTypesPartnerTerms.Visible = Not isTerminal;
EndProcedure

#EndRegion


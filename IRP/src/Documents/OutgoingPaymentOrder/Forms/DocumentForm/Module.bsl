#Region FormEvents

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

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocOutgoingPaymentOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListOnChange(Item)
	For Each Row In Object.PaymentList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocOutgoingPaymentOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocOutgoingPaymentOrderClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
EndProcedure

#EndRegion

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocOutgoingPaymentOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocOutgoingPaymentOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocOutgoingPaymentOrderClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocOutgoingPaymentOrderClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocOutgoingPaymentOrderClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocOutgoingPaymentOrderClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemAccount

&AtClient
Procedure AccountOnChange(Item, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocOutgoingPaymentOrderClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocOutgoingPaymentOrderClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure StatusOnChange(Item, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.StatusOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrencyOnChange(Item, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PlaningPeriodOnChange(Item, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.PlaningPeriodOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocOutgoingPaymentOrderClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocOutgoingPaymentOrderClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text,
		StandardProcessing);
EndProcedure

#Region Partner

&AtClient
Procedure PaymentListPartnerOnChange(Item, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocOutgoingPaymentOrderClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocOutgoingPaymentOrderClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Payee

&AtClient
Procedure PaymentListPayeeOnChange(Item, AddInfo = Undefined) Export
	DocOutgoingPaymentOrderClient.PaymentListPayeeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPayeeStartChoice(Item, ChoiceData, StandardProcessing)
	DocOutgoingPaymentOrderClient.PaymentListPayeeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPayeeEditTextChange(Item, Text, StandardProcessing)
	DocOutgoingPaymentOrderClient.PaymentListPayeeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion
#Region ExternalCommands

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

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V5(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

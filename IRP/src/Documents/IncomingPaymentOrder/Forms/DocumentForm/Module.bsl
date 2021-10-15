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

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocIncomingPaymentOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocIncomingPaymentOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocIncomingPaymentOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocIncomingPaymentOrderClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocIncomingPaymentOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocIncomingPaymentOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocIncomingPaymentOrderClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocIncomingPaymentOrderClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocIncomingPaymentOrderClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocIncomingPaymentOrderClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemAccount

&AtClient
Procedure AccountOnChange(Item, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocIncomingPaymentOrderClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocIncomingPaymentOrderClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure CurrencyOnChange(Item, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure StatusOnChange(Item, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.StatusOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PlaningPeriodOnChange(Item, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.PlaningPeriodOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocIncomingPaymentOrderClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocIncomingPaymentOrderClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text,
		StandardProcessing);
EndProcedure

#Region Partner

&AtClient
Procedure PaymentListPartnerOnChange(Item, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocIncomingPaymentOrderClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocIncomingPaymentOrderClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Payee

&AtClient
Procedure PaymentListPayerOnChange(Item, AddInfo = Undefined) Export
	DocIncomingPaymentOrderClient.PaymentListPayerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPayerStartChoice(Item, ChoiceData, StandardProcessing)
	DocIncomingPaymentOrderClient.PaymentListPayerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPayerEditTextChange(Item, Text, StandardProcessing)
	DocIncomingPaymentOrderClient.PaymentListPayerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
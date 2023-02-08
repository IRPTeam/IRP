// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	//@skip-check property-return-type
	OpenSettings = Parameters.OpenSettings; // See EquipmentAcquiringClient.OpenPaymentFormSettings
	isReturn = OpenSettings.isReturn;
	RRNCode = OpenSettings.RRNCode;
	Hardware = OpenSettings.Hardware;
	Amount = OpenSettings.Amount;
	Interactive = OpenSettings.Interactive;
	
	Items.FormPayment_PayByPaymentCard.Visible = Not isReturn;
	Items.FormPayment_ReturnPaymentByPaymentCard.Visible = isReturn;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Not Interactive And Amount > 0 Then
		If isReturn Then
			Payment_ReturnPaymentByPaymentCard();
		Else
			Payment_PayByPaymentCard();
		EndIf;
	EndIf;
EndProcedure

#Region Acquiring

&AtClient
Async Procedure Payment_PayByPaymentCard()
	
	Items.DecorationProblem.Visible = False;
	
	PaymentSettings = EquipmentAcquiringClient.PayByPaymentCardSettings();
	PaymentSettings.In.Amount = Amount;
	PaymentSettings.Form.ElementToHideAndShow = Items.DecorationWaiting;
	PaymentSettings.Form.ElementToLock = ThisObject;
	
	Result = Await EquipmentAcquiringClient.PayByPaymentCard(Hardware, PaymentSettings);
	
	If Result Then
		Close(PaymentSettings);
	Else
		Items.DecorationProblem.Visible = True;
	EndIf;
EndProcedure

&AtClient
Async Procedure Payment_ReturnPaymentByPaymentCard()
	
	Items.DecorationProblem.Visible = False;
	
	PaymentSettings = EquipmentAcquiringClient.ReturnPaymentByPaymentCardSettings();
	PaymentSettings.In.Amount = Amount;
	PaymentSettings.InOut.RRNCode = RRNCode;
	PaymentSettings.Form.ElementToHideAndShow = Items.DecorationWaiting;
	PaymentSettings.Form.ElementToLock = ThisObject;
	
	Result = Await EquipmentAcquiringClient.ReturnPaymentByPaymentCard(Hardware, PaymentSettings);
	If Result Then
		Close(PaymentSettings);
	Else
		Items.DecorationProblem.Visible = True;
	EndIf;
EndProcedure

&AtClient
Async Procedure Payment_CancelPaymentByPaymentCard()
	
	Items.DecorationProblem.Visible = False;
	
	PaymentSettings = EquipmentAcquiringClient.CancelPaymentByPaymentCardSettings();
	PaymentSettings.In.Amount = Amount;
	
	If Await EquipmentAcquiringClient.CancelPaymentByPaymentCard(Hardware, PaymentSettings) Then
		PaymentInfo = CommonFunctionsServer.SerializeJSON(PaymentSettings);
	Else
		Items.DecorationProblem.Visible = True;
	EndIf;
	
EndProcedure

&AtClient
Async Procedure Payment_EmergencyReversal()
	
	Items.DecorationProblem.Visible = False;
	
	PaymentSettings = EquipmentAcquiringClient.EmergencyReversalSettings();
	
	If Await EquipmentAcquiringClient.EmergencyReversal(Hardware, PaymentSettings) Then
		PaymentInfo = CommonFunctionsServer.SerializeJSON(PaymentSettings);
	Else
		Items.DecorationProblem.Visible = True;
	EndIf;
EndProcedure

#EndRegion

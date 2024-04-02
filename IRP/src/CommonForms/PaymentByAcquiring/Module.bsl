// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	//@skip-check property-return-type
	OpenSettings = Parameters.OpenSettings; // See EquipmentAcquiringAPIClient.OpenPaymentFormSettings
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
	
	PaymentSettings = EquipmentAcquiringAPIClient.PayByPaymentCardSettings();
	PaymentSettings.In.Amount = Amount;
	PaymentSettings.Form.ElementToHideAndShow = Items.DecorationWaiting;
	PaymentSettings.Form.ElementToLock = ThisObject;
	
	Result = Await EquipmentAcquiringAPIClient.PayByPaymentCard(Hardware, PaymentSettings);
	
	If Result Then
		Close(PaymentSettings);
	Else
		Items.DecorationProblem.Visible = True;
	EndIf;
EndProcedure

&AtClient
Async Procedure Payment_ReturnPaymentByPaymentCard()
	
	Items.DecorationProblem.Visible = False;
	
	PaymentSettings = EquipmentAcquiringAPIClient.ReturnPaymentByPaymentCardSettings();
	PaymentSettings.In.Amount = Amount;
	PaymentSettings.InOut.RRNCode = RRNCode;
	PaymentSettings.Form.ElementToHideAndShow = Items.DecorationWaiting;
	PaymentSettings.Form.ElementToLock = ThisObject;
	
	Result = Await EquipmentAcquiringAPIClient.ReturnPaymentByPaymentCard(Hardware, PaymentSettings);
	If Result Then
		Close(PaymentSettings);
	Else
		Items.DecorationProblem.Visible = True;
	EndIf;
EndProcedure

&AtClient
Async Procedure Payment_CancelPaymentByPaymentCard()
	
	Items.DecorationProblem.Visible = False;
	
	PaymentSettings = EquipmentAcquiringAPIClient.CancelPaymentByPaymentCardSettings();
	PaymentSettings.In.Amount = Amount;
	
	If Await EquipmentAcquiringAPIClient.CancelPaymentByPaymentCard(Hardware, PaymentSettings) Then
		//@skip-check module-unused-local-variable
		PaymentInfo = CommonFunctionsServer.SerializeJSON(PaymentSettings);
	Else
		Items.DecorationProblem.Visible = True;
	EndIf;
	
EndProcedure

&AtClient
Async Procedure Payment_EmergencyReversal()
	
	Items.DecorationProblem.Visible = False;
	
	PaymentSettings = EquipmentAcquiringAPIClient.EmergencyReversalSettings();
	
	If Await EquipmentAcquiringAPIClient.EmergencyReversal(Hardware, PaymentSettings) Then
		//@skip-check module-unused-local-variable
		PaymentInfo = CommonFunctionsServer.SerializeJSON(PaymentSettings);
	Else
		Items.DecorationProblem.Visible = True;
	EndIf;
EndProcedure

#EndRegion

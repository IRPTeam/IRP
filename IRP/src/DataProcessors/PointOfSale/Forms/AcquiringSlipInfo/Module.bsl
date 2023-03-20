// @strict-types


&AtClient
Procedure Update(Command)
	Settings = EquipmentAcquiringServer.GetAcquiringHardwareSettings();
	Settings.Account = Row.Account;
	Row.Hardware = EquipmentAcquiringServer.GetAcquiringHardware(Settings);
EndProcedure

&AtClient
Async Function Payment_Settlement(PaymentRow)
	
	PaymentSettings = EquipmentAcquiringClient.SettlementSettings();
	PaymentSettings.In.DeviceID = PaymentRow.Amount;
	PaymentSettings.InOut.RRNCode = PaymentRow.RRNCode;
	PaymentSettings.Form.ElementToLock = ThisObject;
	PaymentSettings.Form.ElementToHideAndShow = Items.GroupWait;
	Result = Await EquipmentAcquiringClient.ReturnPaymentByPaymentCard(PaymentRow.Hardware, PaymentSettings);
	
	If Result Then
		PaymentRow.PaymentInfo = CommonFunctionsServer.SerializeJSON(PaymentSettings);
		PaymentRow.PaymentDone = True;
	EndIf;
	Return Result;
EndFunction
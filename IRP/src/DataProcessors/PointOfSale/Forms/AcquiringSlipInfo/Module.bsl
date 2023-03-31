// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	BankPaymentTypesValue = POSServer.GetBankPaymentTypesValue(Parameters.Branch);
	
	For Each Row In BankPaymentTypesValue Do
		
		If Row.Account.Acquiring.IsEmpty() Then
			Continue;
		EndIf;
		
		NewRow = AccountList.Add();
		NewRow.Account = Row.Account;
		NewRow.Hardware = Row.Account.Acquiring;
	EndDo;
	
EndProcedure

&AtClient
Procedure Update(Command)
	For Each RowID In Items.AccountList.SelectedRows Do
		//@skip-check invocation-parameter-type-intersect
		CurrentRow = AccountList.FindByID(RowID);
		Payment_Settlement(CurrentRow);
	EndDo;
EndProcedure

&AtClient
Async Function Payment_Settlement(PaymentRow)
	
	SettlementSettings = EquipmentAcquiringClient.SettlementSettings();
	Result = Await EquipmentAcquiringClient.Settlement(PaymentRow.Hardware, SettlementSettings);
	
	If Result Then
		PaymentRow.SlipInfo = SettlementSettings.Out.Slip;
	EndIf;
	Return Result;
	
EndFunction
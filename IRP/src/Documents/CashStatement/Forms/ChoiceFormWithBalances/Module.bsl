
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.Parameters.SetParameterValue("Company" , Parameters.Company);
	ThisObject.List.Parameters.SetParameterValue("Account" , Parameters.POSAccount);
	ThisObject.List.Parameters.SetParameterValue("ReceiptingAccount" , Parameters.ReceiptingAccount);
	ThisObject.List.Parameters.SetParameterValue("ReceiptingBranch"  , Parameters.Branch);
	ThisObject.CloseOnChoice = True;
	Items.List.ChoiceMode = True;
EndProcedure

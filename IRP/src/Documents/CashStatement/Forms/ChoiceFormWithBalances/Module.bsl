
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.Parameters.SetParameterValue("Company" , Parameters.Company);
	ThisObject.List.Parameters.SetParameterValue("Branch"  , Parameters.Branch);
	ThisObject.List.Parameters.SetParameterValue("Account" , Parameters.POSAccount);
	ThisObject.CloseOnChoice = True;
	Items.List.ChoiceMode = True;
EndProcedure

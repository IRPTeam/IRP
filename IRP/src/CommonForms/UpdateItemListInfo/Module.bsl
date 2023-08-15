&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Items.Stores.Enabled = False;
	Items.PriceTypes.Enabled = False;
	Items.Prices.Enabled = False;
	Items.PaymentTerm.Enabled = False;
	Items.TaxRates.Enabled = False;
	Items.PaymentAgent.Enabled = False;

	For Each Question In Parameters.QuestionsParameters Do
		ThisObject[Question.Action] = True;
		Items[Question.Action].Enabled = True;
		Items[Question.Action].Title = Question.QuestionText;
	EndDo;
EndProcedure

&AtClient
Procedure CheckAll(Command)
	ChangeCheck(True);
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	ChangeCheck(False);	
EndProcedure

&AtClient
Procedure ChangeCheck(Value)
	If Items.PaymentTerm.Enabled Then
		ThisObject.PaymentTerm = Value;
	EndIf;
	
	If Items.PriceTypes.Enabled Then
		ThisObject.PriceTypes = Value;
	EndIf;
	
	If Items.Prices.Enabled Then
	ThisObject.Prices = Value;
	EndIf;
	
	If Items.Stores.Enabled Then
		ThisObject.Stores = Value;
	EndIf;
	
	If Items.TaxRates.Enabled Then
		ThisObject.TaxRates = Value;
	EndIf;
	
	If Items.PaymentAgent.Enabled Then
		ThisObject.PaymentAgent = Value;
	EndIf;
EndProcedure

&AtClient
Procedure OK(Command)
	Actions = New Structure();

	If Stores Then
		Actions.Insert("UpdateStores", "UpdateStores");
	EndIf;
	
	If PriceTypes Then
		Actions.Insert("UpdatePriceTypes", "UpdatePriceTypes");
	EndIf;
	
	If Prices Then
		Actions.Insert("UpdatePrices", "UpdatePrices");
	EndIf;
	
	If PaymentTerm Then
		Actions.Insert("UpdatePaymentTerm", "UpdatePaymentTerm");
	EndIf;
	
	If TaxRates Then
		Actions.Insert("UpdateTaxRates", "UpdateTaxRates");
	EndIf;
	
	If PaymentAgent Then
		Actions.Insert("UpdatePaymentAgent", "UpdatePaymentAgent");
	EndIf;
	
	Close(Actions);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure
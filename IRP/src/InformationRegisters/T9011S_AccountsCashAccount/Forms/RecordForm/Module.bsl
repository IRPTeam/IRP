
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All"     , R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("CashAccount" , Metadata.Catalogs.CashAccounts.ObjectPresentation);
	
	If ValueIsFilled(Record.CashAccount) Then
		ThisObject.RecordType = "CashAccount";
	Else
		ThisObject.RecordType = "All";
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure RecordTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If ThisObject.RecordType <> "CashAccount" Then
		CurrentObject.CashAccount = Undefined;
		CurrentObject.Currency = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.CashAccount.Visible = ThisObject.RecordType = "CashAccount";
	Items.Currency.Visible = ThisObject.RecordType = "CashAccount";
	Items.AccountTransit.Visible = ThisObject.Record.CashAccount.Type <> Enums.CashAccountTypes.Transit;
EndProcedure

&AtClient
Procedure CashAccountOnChange(Item)
	If ValueIsFilled(Record.CashAccount) Then
		Record.Currency = CommonFunctionsServer.GetRefAttribute(Record.CashAccount, "Currency");
	Else
		Record.Currency = Undefined;
	EndIf;
	SetVisible();
EndProcedure


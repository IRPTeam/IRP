
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
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.CashAccount.Visible = ThisObject.RecordType = "CashAccount";
EndProcedure

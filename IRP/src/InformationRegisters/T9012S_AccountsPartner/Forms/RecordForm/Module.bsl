
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All"     , R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("Partner"   , Metadata.Catalogs.Partners.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("Agreement" , Metadata.Catalogs.Agreements.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("Currency"  , Metadata.Catalogs.Currencies.ObjectPresentation);
	
	If ValueIsFilled(Record.Partner) Then
		ThisObject.RecordType = "Partner";
	ElsIf ValueIsFilled(Record.Agreement) Then
		ThisObject.RecordType = "Agreement";
	ElsIf ValueIsFilled(Record.Currency) Then
		ThisObject.RecordType = "Currency";
	Else
		ThisObject.RecordType = "All";
	EndIf;
	SetVisible();
EndProcedure

&AtClient
Procedure RecordTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure VendorOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure CustomerOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure OtherOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure AgreementOnChange(Item)
	If ValueIsFilled(Record.Agreement) Then
		AgreementType = CommonFunctionsServer.GetRefAttribute(Record.Agreement, "Type");
		Record.Customer = (AgreementType = PredefinedValue("Enum.AgreementTypes.Customer"));
		Record.Vendor = (AgreementType = PredefinedValue("Enum.AgreementTypes.Vendor"));
		Record.Other = (AgreementType = PredefinedValue("Enum.AgreementTypes.Other"));
	EndIf;	
	SetVisible();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If ThisObject.RecordType <> "Partner" Then
		CurrentObject.Partner = Undefined;
	EndIf;

	If ThisObject.RecordType <> "Agreement" Then
		CurrentObject.Agreement = Undefined;
	EndIf;
	
	If ThisObject.RecordType <> "Currency" Then
		CurrentObject.Currency = Undefined;
	EndIf;
	
	If Not CurrentObject.Vendor Then
		CurrentObject.AccountAdvancesVendor = Undefined;
		CurrentObject.AccountTransactionsVendor = Undefined;
	EndIf;
	
	If Not CurrentObject.Customer Then
		CurrentObject.AccountAdvancesCustomer = Undefined;
		CurrentObject.AccountTransactionsCustomer = Undefined;
	EndIf;
	
	If Not CurrentObject.Other Then
		CurrentObject.AccountTransactionsOther = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.Partner.Visible   = ThisObject.RecordType = "Partner";
	Items.Agreement.Visible = ThisObject.RecordType = "Agreement";
	Items.Currency.Visible  = ThisObject.RecordType = "Currency";
	
	Items.GroupVendor.Visible                 = Record.Vendor;
	Items.AccountAdvancesVendor.Visible       = Record.Vendor;
	Items.AccountTransactionsVendor.Visible   = Record.Vendor;
	
	Items.GroupCustomer.Visible               = Record.Customer;
	Items.AccountAdvancesCustomer.Visible     = Record.Customer;
	Items.AccountTransactionsCustomer.Visible = Record.Customer;
	
	Items.GroupOther.Visible                  = Record.Other;
	Items.AccountTransactionsOther.Visible    = Record.Other;
EndProcedure


&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All"     , R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("Partner"   , Metadata.Catalogs.Partners.ObjectPresentation);
	ThisObject.Items.RecordType.ChoiceList.Add("Agreement" , Metadata.Catalogs.Agreements.ObjectPresentation);
	
	If ValueIsFilled(Record.Partner) Then
		ThisObject.RecordType = "Partner";
	ElsIf ValueIsFilled(Record.Agreement) Then
		ThisObject.RecordType = "Agreement";
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
	If ThisObject.RecordType <> "Partner" Then
		CurrentObject.Partner = Undefined;
	EndIf;

	If ThisObject.RecordType <> "Agreement" Then
		CurrentObject.Agreement = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.Partner.Visible   = ThisObject.RecordType = "Partner";
	Items.Agreement.Visible = ThisObject.RecordType = "Agreement";
EndProcedure

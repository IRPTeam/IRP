
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All"     , R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("Tax"   , Metadata.Catalogs.Taxes.ObjectPresentation);
	
	If ValueIsFilled(Record.Tax) Then
		ThisObject.RecordType = "Tax";
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
	If ThisObject.RecordType <> "Tax" Then
		CurrentObject.Tax = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.Tax.Visible   = ThisObject.RecordType = "Tax";
EndProcedure


&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All"      , R().AccountingInfo_06);
	ThisObject.Items.RecordType.ChoiceList.Add("Employee" , Metadata.Catalogs.FixedAssets.ObjectPresentation);
	
	If ValueIsFilled(Record.Employee) Then
		ThisObject.RecordType = "Employee";
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
	If ThisObject.RecordType <> "Employee" Then
		CurrentObject.Employee = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.Employee.Visible = ThisObject.RecordType = "Employee";
EndProcedure

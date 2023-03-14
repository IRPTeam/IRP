
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All"      , R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("ExpenseRevenue" , Metadata.Catalogs.ExpenseAndRevenueTypes.ObjectPresentation);
	
	If ValueIsFilled(Record.ExpenseRevenue) Then
		ThisObject.RecordType = "ExpenseRevenue";
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
	If ThisObject.RecordType <> "ExpenseRevenue" Then
		CurrentObject.ExpenseRevenue = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.ExpenseRevenue.Visible = ThisObject.RecordType = "ExpenseRevenue";
EndProcedure

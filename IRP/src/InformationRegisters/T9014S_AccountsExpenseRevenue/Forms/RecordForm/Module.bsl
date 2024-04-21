
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Items.RecordType.ChoiceList.Add("All", R().CLV_1);
	ThisObject.Items.RecordType.ChoiceList.Add("ProfitLossCenter", R().AccountingInfo_03);
	ThisObject.Items.RecordType.ChoiceList.Add("ExpenseRevenue", R().AccountingInfo_04);
	ThisObject.Items.RecordType.ChoiceList.Add("ExpenseRevenueAndProfitLossCenter", R().AccountingInfo_05);
	
	If ValueIsFilled(Record.ExpenseRevenue) And ValueIsFilled(Record.ProfitLossCenter) Then
		ThisObject.RecordType = "ExpenseRevenueAndProfitLossCenter";
	ElsIf ValueIsFilled(Record.ExpenseRevenue) Then
		ThisObject.RecordType = "ExpenseRevenue";
	ElsIf ValueIsFilled(Record.ProfitLossCenter) Then
		ThisObject.RecordType = "ProfitLossCenter";
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
Procedure ExpenseOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure RevenueOnChange(Item)
	SetVisible();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If ThisObject.RecordType <> "ExpenseRevenue" And ThisObject.RecordType <> "ExpenseRevenueAndProfitLossCenter" Then
		CurrentObject.ExpenseRevenue = Undefined;
	EndIf;
	
	If ThisObject.RecordType <> "ProfitLossCenter" And ThisObject.RecordType <> "ExpenseRevenueAndProfitLossCenter" Then
		CurrentObject.ProfitLossCenter = Undefined;
	EndIf;
	
	If Not Record.Expense Then
		CurrentObject.AccountExpense = Undefined;
	EndIf;
	
	If Not Record.Revenue Then
		CurrentObject.AccountRevenue = Undefined;
	EndIf;
EndProcedure

&AtServer
Procedure SetVisible()
	Items.ExpenseRevenue.Visible = (ThisObject.RecordType = "ExpenseRevenue" Or ThisObject.RecordType = "ExpenseRevenueAndProfitLossCenter");
	Items.ProfitLossCenter.Visible = (ThisObject.RecordType = "ProfitLossCenter" Or ThisObject.RecordType = "ExpenseRevenueAndProfitLossCenter");

	Items.AccountExpense.Visible = Record.Expense;
	Items.AccountRevenue.Visible = Record.Revenue;
EndProcedure



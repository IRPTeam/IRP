
&AtClient
Procedure ObjectAttributeTextEditEnd(Item)
	FillFilterList();
	Modified = True;
EndProcedure

&AtClient
Procedure Clear(Command)
	FillDataOnServer(PredefinedValue("Catalog.RetailCustomers.EmptyRef"));
	FillFilterList();
EndProcedure

&AtClient
Procedure CodeOnChange(Item)
	If Not isEmptyRetailCustomerByCode(RetailCustomer.Code) Then
		List.SettingsComposer.Settings.Filter.Items.Clear();
		FilterItem = List.SettingsComposer.Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.LeftValue = New DataCompositionField(Item.Name);
		FilterItem.Use = True;
		FilterItem.ComparisonType = DataCompositionComparisonType.Contains;
		FilterItem.RightValue = RetailCustomer[Item.Name];
		FillByRow();
		Modified = False;
	Else
		Modified = True;
	EndIf;
EndProcedure

&AtClient
Procedure FillFilterList()
	List.SettingsComposer.Settings.Filter.Items.Clear();
	For Each FilterField In Items.GroupFilter.ChildItems Do
		If IsBlankString(RetailCustomer[FilterField.Name]) Then
			Continue;
		EndIf;
		FilterItem = List.SettingsComposer.Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.LeftValue = New DataCompositionField(FilterField.Name);
		FilterItem.Use = True;
		FilterItem.ComparisonType = DataCompositionComparisonType.Contains;
		FilterItem.RightValue = RetailCustomer[FilterField.Name];
	EndDo;
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	FillByRow();
EndProcedure

&AtClient
Procedure FillByRow()
	If Items.List.CurrentRow = Undefined Then
		Return;	
	EndIf;
	FillDataOnServer(Items.List.CurrentData.Ref);
EndProcedure

&AtServer
Procedure FillDataOnServer(Ref)
	ValueToFormAttribute(?(Ref.IsEmpty(), Catalogs.RetailCustomers.CreateItem(), Ref.GetObject()), "RetailCustomer");
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Not Parameters.RetailCustomer.IsEmpty() Then
		FillDataOnServer(Parameters.RetailCustomer);
	Else
		If Parameters.Property("CurrentRow") Then
			FillDataOnServer(Parameters.CurrentRow);
		EndIf;
	EndIf;
EndProcedure

&AtServerNoContext
Function isEmptyRetailCustomerByCode(Code)
	Query = New Query;
	Query.Text =
		"SELECT
		|	RetailCustomers.Ref
		|FROM
		|	Catalog.RetailCustomers AS RetailCustomers
		|WHERE
		|	RetailCustomers.Code = &Code";
	
	Query.SetParameter("Code", Code);
	
	Return Query.Execute().IsEmpty();
EndFunction

&AtClient
Procedure AfterWrite(WriteParameters)
	Close(RetailCustomer.Ref);
EndProcedure






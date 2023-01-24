
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.RetailCustomer = Parameters.RetailCustomer;
	ThisObject.ItemKey = Parameters.ItemKey;
	
	SetListParameters();

EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	Choose(Undefined);
EndProcedure

&AtClient
Procedure RetailCustomerOnChange(Item)
	SetListParameters();
	Items.List.Refresh();
EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	SetListParameters();
	Items.List.Refresh();
EndProcedure

&AtClient
Procedure Choose(Command)
	CurrentData = Items.List.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Close(CurrentData.RetailSalesReceipt);
EndProcedure

&AtServer
Procedure SetListParameters()
	
	CustomerField = New DataCompositionField("RetailCustomer");
	CustomerFilter = GetFilterItem(CustomerField);
	CustomerFilter.RightValue = ThisObject.RetailCustomer;
	CustomerFilter.Use = ValueIsFilled(ThisObject.RetailCustomer);
	
	ItemKeyField = New DataCompositionField("ItemKey");
	ItemKeyFilter = GetFilterItem(ItemKeyField);
	ItemKeyFilter.RightValue = ThisObject.ItemKey;
	ItemKeyFilter.Use = ValueIsFilled(ThisObject.ItemKey);
	
EndProcedure

&AtServer
Function GetFilterItem(Field)
	
	ListFilter = List.SettingsComposer.Settings.Filter.Items;
	For Each FilterItem In ListFilter Do
		If FilterItem.LeftValue = Field Then
			Return FilterItem;
		EndIf;
	EndDo;
	
	FilterItem = ListFilter.Add(Type("DataCompositionFilterItem"));
	FilterItem.LeftValue = Field;
	
	Return FilterItem;
	
EndFunction


&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.RetailCustomer = Parameters.RetailCustomer;
	ThisObject.ItemKey = Parameters.ItemKey;
	
	If ValueIsFilled(Parameters.ReturnItemsAddress) Then
		ThisObject.List.SettingsComposer.Settings.AdditionalProperties.Insert(
			"ReturnItemsAddress", Parameters.ReturnItemsAddress);
	EndIf;
	
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
	Close(GetRetailSalesReceiptData(CurrentData.RetailSalesReceipt));
EndProcedure

&AtServerNoContext
Procedure ListOnGetDataAtServer(ItemName, Settings, Rows)
	ReturnItemsAddress = Undefined;
	If Settings.AdditionalProperties.Property("ReturnItemsAddress", ReturnItemsAddress) Then
		TableFilter = New Structure("ItemKey,RetailSalesReceipt");
		ReturnItemsTable = GetFromTempStorage(ReturnItemsAddress);
		If TypeOf(ReturnItemsTable) = Type("ValueTable") Then
			For Each RowItem In Rows Do
				FillPropertyValues(TableFilter, RowItem.Value.Data);
				ReturnRows = ReturnItemsTable.FindRows(TableFilter);
				If ReturnRows.Count() > 0 Then
					RowItem.Value.Data.Selected = ReturnRows[0].Quantity;
				EndIf;
			EndDo;
		EndIf;
	EndIf;
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

&AtServer
Function GetRetailSalesReceiptData(RetailSalesReceipt)
	
	Result = New Map;
	
	ReturnItemsTable = Undefined;
	ReturnItemsAddress = Undefined;
	If ThisObject.List.SettingsComposer.Settings.AdditionalProperties.Property("ReturnItemsAddress", ReturnItemsAddress) Then
		ReturnItemsTable = GetFromTempStorage(ReturnItemsAddress);
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	R2050T_RetailSalesTurnovers.ItemKey,
	|	R2050T_RetailSalesTurnovers.RetailSalesReceipt,
	|	SUM(R2050T_RetailSalesTurnovers.QuantityTurnover) AS Quantity,
	|	SUM(R2050T_RetailSalesTurnovers.AmountTurnover) AS Amount
	|FROM
	|	AccumulationRegister.R2050T_RetailSales.Turnovers AS R2050T_RetailSalesTurnovers
	|WHERE
	|	R2050T_RetailSalesTurnovers.RetailSalesReceipt = &RetailSalesReceipt
	|GROUP BY
	|	R2050T_RetailSalesTurnovers.RetailSalesReceipt,
	|	R2050T_RetailSalesTurnovers.ItemKey
	|HAVING
	|	SUM(R2050T_RetailSalesTurnovers.QuantityTurnover) > 0";
	
	Query.SetParameter("RetailSalesReceipt", RetailSalesReceipt);
	QuerySelection = Query.Execute().Select();
	
	TableFilter = New Structure("ItemKey,RetailSalesReceipt");
	While QuerySelection.Next() Do
		AvailableQuantity = QuerySelection.Quantity;
		If TypeOf(ReturnItemsTable) = Type("ValueTable") Then
			FillPropertyValues(TableFilter, QuerySelection);
			ReturnRows = ReturnItemsTable.FindRows(TableFilter);
			If ReturnRows.Count() > 0 Then
				AvailableQuantity = Max(AvailableQuantity - ReturnRows[0].Quantity, 0);
			EndIf;
		EndIf;
		If AvailableQuantity > 0 Then
			Result.Insert(
				QuerySelection.ItemKey, 
				New Structure(
					"RetailSalesReceipt, Quantity, Price", 
					QuerySelection.RetailSalesReceipt, 
					AvailableQuantity,
					Round(QuerySelection.Amount / AvailableQuantity, 2)));
		EndIf;
	EndDo;
	
	Return Result;
	
EndFunction
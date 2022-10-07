
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.RowKey = Parameters.RowKey;
	ArrayOfProductTreeRows = New Array();
	CreateProductionTreeAtServer(ArrayOfProductTreeRows, Parameters.BillOfMaterialRows, True);
	DrawProductionTree(ThisObject.ProductionTree, ArrayOfProductTreeRows);
	If Parameters.ReadOnlyStores Then
		Items.FormOk.Enabled = False;
		Items.ProductionTreeSurplusStore.ReadOnly = True;
		Items.ProductionTreeWriteofStore.ReadOnly = True;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandTree", 1, True);
EndProcedure

&AtClient
Procedure ExpandTree() Export
	RowIDInfoClient.ExpandTree(Items.ProductionTree, ThisObject.ProductionTree.GetItems());
EndProcedure

&AtClient
Procedure Ok(Command)
	ArrayOfResult = New Array();
	GetResultByTree(ThisObject.ProductionTree, ArrayOfResult);
	Close(New Structure("RowKey, ArrayOfRows", ThisObject.RowKey, ArrayOfResult));
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure ProductionTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ProductionTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure GetResultByTree(RowOwner, ArrayOfResult)
	For Each Row In RowOwner.GetItems() Do
		Result = New Structure("InputID, OutputID, UniqueID, ItemKey, SemiproductStore, MaterialStore, ReleaseStore");
		FillPropertyValues(Result, Row);
		If Row.IsProduct Then
			Result.ReleaseStore = Row.SurplusStore;
		ElsIf Row.IsSemiproduct Then
			Result.SemiproductStore = Row.WriteoffStore;
			Result.ReleaseStore  = Row.SurplusStore;
		ElsIf Row.IsMaterial Then
			Result.MaterialStore = Row.WriteoffStore;
		EndIf;
		ArrayOfResult.Add(Result);
		GetResultByTree(Row, ArrayOfResult);
	EndDo;
EndProcedure

&AtServer
Procedure DrawProductionTree(RowOwner, ArrayOfProductTreeRows)
	For Each Row In ArrayOfProductTreeRows Do
		NewRow = RowOwner.GetItems().Add();
		FillPropertyValues(NewRow, Row);
		DrawProductionTree(NewRow, Row.Rows);
	EndDo;
EndProcedure

&AtServer
Function GetRowsByInputID(BillOfMaterialRows, InputID)
	ArrayOfResult = New Array();
	For Each Row In BillOfMaterialRows Do
		If TrimAll(Row.InputID) = TrimAll(InputID) Then	
			ArrayOfResult.Add(Row);
		EndIf;
	EndDo;
	Return ArrayOfResult;
EndFunction

&AtServer
Procedure CreateProductionTreeAtServer(RowOwner, BillOfMaterialRows, IsTopLevel = False)
	If IsTopLevel Then
		
		//Top level products
		RowsByInputID = GetRowsByInputID(BillOfMaterialRows, "");
		For Each Row In RowsByInputID Do
			NewRow1 = New Structure("Rows", New Array());
			RowOwner.Add(NewRow1);
			NewRow1.Insert("Item"          , Row.ItemKey.Item);
			NewRow1.Insert("ItemKey"       , Row.ItemKey);
			NewRow1.Insert("Unit"          , Row.Unit);
			NewRow1.Insert("Quantity"      , Row.Quantity);
			NewRow1.Insert("MaterialStore" , Row.MaterialStore);
			NewRow1.Insert("ReleaseStore"  , Row.ReleaseStore);
			NewRow1.Insert("InputID"       , Row.InputID);
			NewRow1.Insert("OutputID"      , Row.OutputID);
			NewRow1.Insert("UniqueID"      , Row.UniqueID);
			NewRow1.Insert("IsProduct"     , True);
			NewRow1.Insert("ItemPicture"   , 0);
			NewRow1.Insert("SurplusStore"  , Row.ReleaseStore);
			NewRow1.Insert("SurplusStoreEnable" , True);
			CreateProductionTreeAtServer(NewRow1, BillOfMaterialRows);
		EndDo;
		Return;
	EndIf;

	RowsByInputID = GetRowsByInputID(BillOfMaterialRows, RowOwner.OutputID);
	For Each Row In RowsByInputID Do
		NewRow2 = New Structure("Rows", New Array());
		RowOwner.Rows.Add(NewRow2);
		NewRow2.Insert("Item"          , Row.ItemKey.Item);
		NewRow2.Insert("ItemKey"       , Row.ItemKey);
		NewRow2.Insert("Unit"          , Row.Unit);
		NewRow2.Insert("Quantity"      , Row.Quantity);
		NewRow2.Insert("MaterialStore" , Row.MaterialStore);
		NewRow2.Insert("ReleaseStore"  , Row.ReleaseStore);
		NewRow2.Insert("InputID"       , Row.InputID);
		NewRow2.Insert("OutputID"      , Row.OutputID);
		NewRow2.Insert("UniqueID"      , Row.UniqueID);
		If Row.IsSemiproduct Then
			NewRow2.Insert("IsSemiproduct" , True);
			NewRow2.Insert("ItemPicture"   , 2);
			NewRow2.Insert("WriteoffStore" , Row.SemiproductStore);
			NewRow2.Insert("SurplusStore"  , Row.ReleaseStore);
			NewRow2.Insert("WriteoffStoreEnable" , True);
			NewRow2.Insert("SurplusStoreEnable"  , True);
			CreateProductionTreeAtServer(NewRow2, BillOfMaterialRows);
		ElsIf Row.IsMaterial Then
			NewRow2.Insert("WriteoffStore"  , Row.MaterialStore);
			NewRow2.Insert("WriteoffStoreEnable" , True);
			NewRow2.Insert("IsMaterial"  , True);
			NewRow2.Insert("ItemPicture" , 3);
		ElsIf Row.IsService Then
			NewRow2.Insert("IsService"   , True);
			NewRow2.Insert("ItemPicture" , 1);
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure
	

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.MainFilter = Parameters.Filter;

	If Parameters.Property("SetAllCheckedOnOpen") Then
		ThisObject.SetAllCheckedOnOpen = Parameters.SetAllCheckedOnOpen;
	EndIf;
	
	// Fill ResultTable
	For Each RowIdInfo In Parameters.TablesInfo.RowIDInfoRows Do
		NewRow = ThisObject.ResultsTable.Add();
		FillPropertyValues(NewRow, RowIdInfo);
		For Each RowItemList In Parameters.TablesInfo.ItemListRows Do
			If RowIdInfo.Key = RowItemList.Key Then
				FillPropertyValues(NewRow, RowItemList, "ItemKey, Item, Store");
				NewRow.BasisUnit = ?(ValueIsFilled(RowItemList.ItemKey.Unit), 
				RowItemList.ItemKey.Unit, RowItemList.ItemKey.Item.Unit);
			EndIf;
		EndDo;
	EndDo;
				
	FillBasisesTree();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
	If ThisObject.SetAllCheckedOnOpen Then
		SetChecked(True, ThisObject.BasisesTree.GetItems());
	EndIf;
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.BasisesTree, ThisObject.BasisesTree.GetItems());
EndProcedure

&AtServer
Procedure FillBasisesTree();
	ThisObject.BasisesTree.GetItems().Clear();	
	BasisesTable = RowIDInfoServer.GetBasises(ThisObject.MainFilter.Ref, ThisObject.MainFilter);	
	
	TreeReverseInfo = RowIDInfoServer.CreateBasisesTreeReverse(BasisesTable);
	RowIDInfoServer.CreateBasisesTree(TreeReverseInfo, BasisesTable, ThisObject.ResultsTable.Unload(), ThisObject.BasisesTree.GetItems());	
EndProcedure

&AtClient
Procedure Ok(Command)
	FillingValues = GetFillingValues();
	Close(New Structure("Operation, FillingValues", "AddLinkedDocumentRows", FillingValues));
EndProcedure

&AtServer
Procedure CollectResultTableRecursive(BasisesTreeRows)
	For Each TreeRow In BasisesTreeRows Do
		If TreeRow.DeepLevel And TreeRow.Use And Not TreeRow.Linked Then
			NewRowResultTable = ThisObject.ResultsTable.Add(); 
			FillPropertyValues(NewRowResultTable, TreeRow);
			NewRowResultTable.Quantity = TreeRow.QuantityInBaseUnit;
		EndIf;
		CollectResultTableRecursive(TreeRow.GetItems());
	EndDo;
EndProcedure

&AtServer
Function GetFillingValues()
	ThisObject.ResultsTable.Clear();
	CollectResultTableRecursive(ThisObject.BasisesTree.GetItems());
	
	ExtractedData = RowIDInfoServer.ExtractData(ThisObject.ResultsTable.Unload(), ThisObject.MainFilter.Ref);
	FillingValues = RowIDInfoServer.ConvertDataToFillingValues(ThisObject.MainFilter.Ref.Metadata(), ExtractedData);
	Return FillingValues;
EndFunction

&AtClient
Procedure Cancel(Command)
	Close(Undefined);	
EndProcedure

&AtClient
Procedure CheckAll(Command)
	SetChecked(True, ThisObject.BasisesTree.GetItems());
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	SetChecked(False, ThisObject.BasisesTree.GetItems());
EndProcedure

&AtClient
Procedure SetChecked(Value, TreeRows)
	For Each TreeRow In TreeRows Do
		If Not TreeRow.Linked Then
			TreeRow.Use = Value;
		EndIf;
		SetChecked(Value, TreeRow.GetItems());
	EndDo;	
EndProcedure

&AtClient
Procedure BasisesTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure BasisesTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);	
EndProcedure


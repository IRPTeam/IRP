&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Ref = Parameters.Ref;
	ResultsTableTmp = ThisObject.ResultsTable.Unload().CopyColumns();
	For Each RowIdInfo In Parameters.TablesInfo.RowIDInfoRows Do
		If Not ValueIsFilled(RowIdInfo.CurrentStep) Then
			Continue;
		EndIf;
		NewRow = ResultsTableTmp.Add();
		FillPropertyValues(NewRow, RowIdInfo);
		For Each RowItemList In Parameters.TablesInfo.ItemListRows Do
			If RowIdInfo.Key = RowItemList.Key Then
				FillPropertyValues(NewRow, RowItemList, "ItemKey, Item, Store");
				NewRow.BasisUnit = ?(ValueIsFilled(RowItemList.ItemKey.Unit), RowItemList.ItemKey.Unit,
					RowItemList.ItemKey.Item.Unit);
			EndIf;
		EndDo;
	EndDo;
	ArrayOfColumns = New Array();
	For Each Column In ResultsTableTmp.Columns Do
		ArrayOfColumns.Add(Column.Name);
	EndDo;
	ResultsTableTmp.GroupBy(StrConcat(ArrayOfColumns, ","));
	ThisObject.ResultsTable.Load(ResultsTableTmp);
	FillBasisesTree(Parameters.SelectedRowInfo);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.BasisesTree, ThisObject.BasisesTree.GetItems());
EndProcedure

&AtServer
Procedure FillBasisesTree(SelectedRowInfo)
	ThisObject.BasisesTree.GetItems().Clear();

	TmpBasisTable = ThisObject.ResultsTable.Unload();

	BasisesTable = TmpBasisTable.CopyColumns();
	For Each Row In TmpBasisTable Do
		If ValueIsFilled(Row.Basis) Then
			FillPropertyValues(BasisesTable.Add(), Row);
		EndIf;
	EndDo;
	TreeReverseInfo = RowIDInfoServer.CreateBasisesTreeReverse(BasisesTable);

	RowIDInfoServer.CreateBasisesTree(TreeReverseInfo, BasisesTable, ThisObject.ResultsTable.Unload(),
		ThisObject.BasisesTree.GetItems());
	LastRow = Undefined;
	GetLastRowRecursive(ThisObject.BasisesTree.GetItems(), LastRow);
	If LastRow = Undefined Then
		BasisesInfo = RowIDInfoServer.GetBasisesInfo(ThisObject.Ref, SelectedRowInfo.SelectedRow.Key, 
			SelectedRowInfo.SelectedRow.Key);
		LastRow = ThisObject.BasisesTree.GetItems().Add();
		
		FillPropertyValues(LastRow, SelectedRowInfo.SelectedRow);
		FillPropertyValues(LastRow, BasisesInfo);
		LastRow.RowPresentation = String(LastRow.Item) + " (" + String(LastRow.ItemKey) + ")";
	EndIf;
	
	RowIDInfoServer.CreateChildrenTree(ThisObject.Ref, SelectedRowInfo.SelectedRow.Key, LastRow.RowID, LastRow.GetItems());
EndProcedure

&AtClient
Procedure BasisesTreeSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.BasisesTree.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Not ValueIsFilled(CurrentData.DocRef) Then
		Return;
	EndIf;
	OpenParameters = New Structure();
	OpenParameters.Insert("Key", CurrentData.DocRef);
	OpenForm(GetMetadataFullName(CurrentData.DocRef) + ".ObjectForm", OpenParameters);
EndProcedure

&AtServerNoContext
Function GetMetadataFullName(Ref)
	Return Ref.Metadata().FullName();
EndFunction

&AtServer
Procedure GetLastRowRecursive(TreeItems, LastRow)
	For Each Row In TreeItems Do
		If LastRow <> Undefined Then
			Return;
		EndIf;
		If ValueIsFilled(Row.Key) Then
			LastRow = Row;
		EndIf;
		GetLastRowRecursive(Row.GetItems(), LastRow)
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

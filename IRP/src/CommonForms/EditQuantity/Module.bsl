
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Ref = Parameters.Ref;
	ThisObject.SelectedRowKey = Parameters.SelectedRowInfo.SelectedRow.Key;
	
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
	CommonFormActions.ExpandTree(Items.BasisesTree, ThisObject.BasisesTree.GetItems());
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
	TreeReverseInfo = RowIDInfoPrivileged.CreateBasisesTreeReverse(BasisesTable);
	RowIDInfoPrivileged.CreateBasisesTree(TreeReverseInfo, BasisesTable, ThisObject.ResultsTable.Unload(),
		ThisObject.BasisesTree.GetItems());
		
	LastRow = Undefined;
	GetLastRowRecursive(ThisObject.BasisesTree.GetItems(), LastRow);
	If LastRow = Undefined Then
		BasisesInfo = RowIDInfoPrivileged.GetBasisesInfo(ThisObject.Ref, SelectedRowInfo.SelectedRow.Key, SelectedRowInfo.SelectedRow.Key);
		LastRow = ThisObject.BasisesTree.GetItems().Add();
		
		FillPropertyValues(LastRow, SelectedRowInfo.SelectedRow);
		FillPropertyValues(LastRow, BasisesInfo);
		LastRow.RowPresentation = String(LastRow.Item) + " (" + String(LastRow.ItemKey) + ")";
	EndIf;
	ArrayOfChildrens = RowIDInfoPrivileged.CreateChildrenTree2(ThisObject.Ref, SelectedRowInfo.SelectedRow.Key, LastRow.RowID, LastRow.GetItems());
	ThisObject.Childrens.Clear();
	For Each ChildrenItem In ArrayOfChildrens Do
		FillPropertyValues(ThisObject.Childrens.Add(), ChildrenItem);
	EndDo;
EndProcedure

&AtClient
Procedure BasisesTreeSelection(Item, RowSelected, Field, StandardProcessing)
	If Field.Name = "BasisesTreeQuantity" Or Field.Name = "BasisesTreeUnit" Then
		Return;
	EndIf;
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

&AtClient
Procedure BasisesTreeUnitOnChange(Item)
	Return;
EndProcedure

&AtClient
Procedure BasisesTreeQuantityOnChange(Item)
	Return;
EndProcedure

&AtClient
Function GetUserData()
	UserData = New Structure("Quantity, Unit", 0, Undefined);
	GetUserData_Recurion(ThisObject.BasisesTree.GetItems(), UserData);
	Return UserData;
EndFunction

&AtClient
Procedure GetUserData_Recurion(TreeRows, UserData)
	For Each Row In TreeRows Do
		If Row.Key = ThisObject.SelectedRowKey Then
			UserData.Quantity = Row.Quantity;
			UserData.Unit = Row.Unit;
		Else
			GetUserData_Recurion(Row.GetItems(), UserData);
		EndIf;
	EndDo;
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

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure Ok(Command)
	UserData = GetUserData();
	HaveErrors = EditQuantityAtServer(UserData);
	ThisObject.FormOwner.Read();
	If Not HaveErrors Then
		Close();
	EndIf;
EndProcedure

&AtServer
Function EditQuantityAtServer(UserData)
	ArrayOfChildrens = New Array();
	For Each Row In ThisObject.Childrens Do
		ArrayOfChildrens.Add(Row.Children);
	EndDo;
	
	Return RowIDInfoPrivileged.EditQuantity(ThisObject.Ref, 
		ThisObject.SelectedRowKey, UserData.Quantity, UserData.Unit, ArrayOfChildrens);
EndFunction


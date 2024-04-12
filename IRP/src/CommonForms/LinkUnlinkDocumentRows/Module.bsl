&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.MainFilter = Parameters.Filter;
	If Parameters.SelectedRowInfo.SelectedRow <> Undefined Then
		ThisObject.CurrentLineNumber = Parameters.SelectedRowInfo.SelectedRow.LineNumber;
	EndIf;
	
	If Parameters.SelectedRowInfo.Property("ArrayOfFilterExcludeFields") Then
		ThisObject.ArrayOfFilterExcludeFields = StrConcat(Parameters.SelectedRowInfo.ArrayOfFilterExcludeFields, ",");
	EndIf;
	If Parameters.Filter.Property("VisibleFields") Then
		ThisObject.VisibleFields = Parameters.Filter.VisibleFields;	
	EndIf;
	
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

	FillItemListRows(Parameters.TablesInfo.ItemListRows);
	If Parameters.SelectedRowInfo.SelectedRow <> Undefined Then
		FillResultsTree(Parameters.SelectedRowInfo.SelectedRow);
		FillBasisesTree(Parameters.SelectedRowInfo);
	EndIf;
	
	ThisObject.SettingKey = ThisObject.MainFilter.Ref.Metadata().Name;
	
	DisableCalculateRowsOnLinkRows = 
		CommonSettingsStorage.Load("Documents.LinkUnlinkDocumentRows.Settings.DisableCalculateRowsOnLinkRows", ThisObject.SettingKey);
	If DisableCalculateRowsOnLinkRows = Undefined Then
		DisableCalculateRowsOnLinkRows = UserSettingsServer.LinkUnlinkDocumentRows_Settings_DisableCalculateRowsOnLinkRows();
	EndIf;
	
	ThisObject.CalculateRows = Not DisableCalculateRowsOnLinkRows;

	UseReverseBasisesTreeSetting = 
		CommonSettingsStorage.Load("Documents.LinkUnlinkDocumentRows.Settings.UseReverseBasisesTree", ThisObject.SettingKey);
	If UseReverseBasisesTreeSetting = Undefined Then
		UseReverseBasisesTreeSetting = UserSettingsServer.LinkUnlinkDocumentRows_Settings_UseReverseBasisesTreeOnLinkRows();
	EndIf;
	
	ThisObject.UseReverseBasisesTree = UseReverseBasisesTreeSetting;
	
	Items.BasisesTree.Visible = Not ThisObject.UseReverseBasisesTree;
	Items.BasisesTreeReverse.Visible = ThisObject.UseReverseBasisesTree;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);

	If ValueIsFilled(ThisObject.CurrentLineNumber) Then
		ItemListRow = ThisObject.ItemListRows.FindRows(New Structure("LineNumber", ThisObject.CurrentLineNumber));
		If ItemListRow.Count() Then
			Items.ItemListRows.CurrentRow = ItemListRow[0].GetID();
		EndIf;
	EndIf;

	SetIsLinkedItemListRows();
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	CommonFormActions.ExpandTree(Items.BasisesTree, ThisObject.BasisesTree.GetItems());
	CommonFormActions.ExpandTree(Items.BasisesTreeReverse, ThisObject.BasisesTreeReverse.GetItems());
	CommonFormActions.ExpandTree(Items.ResultsTree, ThisObject.ResultsTree.GetItems());
	SetButtonsEnabled();
EndProcedure

&AtClient
Procedure CalculateRowsOnChange(Item)
	SaveUserSettingAtServer();
EndProcedure

&AtClient
Procedure UseReverseBasisesTreeOnChange(Item)
	SaveUserSettingAtServer();
	Items.BasisesTree.Visible = Not ThisObject.UseReverseBasisesTree;
	Items.BasisesTreeReverse.Visible = ThisObject.UseReverseBasisesTree;
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtServer
Procedure SaveUserSettingAtServer()
	CommonSettingsStorage.Save("Documents.LinkUnlinkDocumentRows.Settings.DisableCalculateRowsOnLinkRows", 
		ThisObject.SettingKey, Not ThisObject.CalculateRows);
	CommonSettingsStorage.Save("Documents.LinkUnlinkDocumentRows.Settings.UseReverseBasisesTree", 
		ThisObject.SettingKey, ThisObject.UseReverseBasisesTree);		
EndProcedure

&AtClient
Procedure ItemListRowsOnActivateRow(Item)
	RefreshTrees();
EndProcedure

&AtClient
Procedure BasisesTreeOnActivateRow(Item)
	SetButtonsEnabled();
EndProcedure

&AtClient
Procedure ResultsTreeOnActivateRow(Item)
	SetButtonsEnabled();
EndProcedure

&AtClient
Procedure SetButtonsEnabled()
	Items.Link.Enabled = IsCanLink().IsCan;
	Items.Unlink.Enabled = IsCanUnlink().IsCan;
EndProcedure

&AtClient
Procedure RefreshTrees()
	SelectedRowInfo = RowIDInfoClient.GetSelectedRowInfo(Items.ItemListRows.CurrentData, StrSplit(ThisObject.ArrayOfFilterExcludeFields, ","));
	If SelectedRowInfo.SelectedRow = Undefined Then
		Return;
	EndIf;
	
	FillResultsTree(SelectedRowInfo.SelectedRow);
	FillBasisesTree(SelectedRowInfo);
	
	ExpandAllTrees();
	RowID = Undefined;
	SetCurrentRowInResultsTree(ThisObject.ResultsTree.GetItems(), SelectedRowInfo.SelectedRow.Key, RowID);
	If RowID <> Undefined Then
		Items.ResultsTree.CurrentRow = RowID;
	EndIf;
EndProcedure

&AtServer
Procedure FillItemListRows(ItemListRows)
	For Each Row In ItemListRows Do
		NewRow = ThisObject.ItemListRows.Add();
		FillPropertyValues(NewRow, Row);
		SerialLotNumberPresentation = "";
		If ValueIsFilled(Row.SerialLotNumber) Then
			SerialLotNumberPresentation = " (" + Row.SerialLotNumber + ")";
		EndIf;
		NewRow.RowPresentation = "" + Row.Item + " (" + Row.ItemKey + ")" + SerialLotNumberPresentation;
		NewRow.Picture = 0;

		If ValueIsFilled(NewRow.ItemKey) And ValueIsFilled(NewRow.Unit) And ValueIsFilled(NewRow.Quantity) Then
			ConvertationResult = RowIDInfoServer.ConvertQuantityToQuantityInBaseUnit(NewRow.ItemKey, NewRow.Unit, NewRow.Quantity);

			NewRow.QuantityInBaseUnit =  ConvertationResult.QuantityInBaseUnit;
			NewRow.BasisUnit          =  ConvertationResult.BasisUnit;
		Else
			NewRow.QuantityInBaseUnit = NewRow.Quantity;
			NewRow.BasisUnit          = NewRow.Unit;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure ShowQuantityInBasisUnitOnChange(Item)
	ThisObject.Items.ItemListRowsBasisUnit.Visible = ThisObject.ShowQuantityInBasisUnit;
	ThisObject.Items.ItemListRowsQuantityInBaseUnit.Visible = ThisObject.ShowQuantityInBasisUnit;
EndProcedure

&AtClient
Procedure ShowLinkedDocumentsOnChange(Item)
	ThisObject.Items.ResultsTree.Visible = ThisObject.ShowLinkedDocuments;
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure SetIsLinkedItemListRows()
	For Each Row In ItemListRows Do
		If ThisObject.ResultsTable.FindRows(New Structure("Key", Row.Key)).Count() Then
			Row.Picture = 1;
		Else
			Row.Picture = 0;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure SetAlreadyLinkedInfo(TreeRows, Key)
	For Each TreeRow In TreeRows Do
		If TreeRow.DeepLevel And Key = TreeRow.Key Then
			ThisObject.LinkedRowID = TreeRow.RowID;
			If TypeOf(TreeRow.Basis) = Type("DocumentRef.ShipmentConfirmation") 
				Or TypeOf(TreeRow.Basis) = Type("DocumentRef.GoodsReceipt") Then
				ThisObject.ShippingReceipt = True;
			Else
				ThisObject.ShippingReceipt = False;
			EndIf;
		EndIf;
		SetAlreadyLinkedInfo(TreeRow.GetItems(), Key);
	EndDo;
EndProcedure

&AtClient
Procedure SetCurrentRowInResultsTree(TreeRows, Key, RowID)
	If RowID <> Undefined Then
		Return;
	EndIf;
	For Each TreeRow In TreeRows Do
		If TreeRow.DeepLevel And Key = TreeRow.Key Then
			RowID = TreeRow.GetID();
			Break;
		EndIf;
		SetCurrentRowInResultsTree(TreeRow.GetItems(), Key, RowID);
	EndDo;
EndProcedure

&AtServer
Procedure FillResultsTree(SelectedRow)
	ThisObject.ResultsTree.GetItems().Clear();
	If SelectedRow = Undefined Then
		Return;
	EndIf;

	TmpBasisTable = ThisObject.ResultsTable.Unload();

	BasisesTable = TmpBasisTable.CopyColumns();
	For Each Row In TmpBasisTable Do
		If ValueIsFilled(Row.Basis) Then
			FillPropertyValues(BasisesTable.Add(), Row);
		EndIf;
	EndDo;
	TreeReverseInfo = RowIDInfoPrivileged.CreateBasisesTreeReverse(BasisesTable);

	RowIDInfoPrivileged.CreateBasisesTree(TreeReverseInfo, BasisesTable, ThisObject.ResultsTable.Unload(), ThisObject.ResultsTree.GetItems());

	ThisObject.LinkedRowID = "";
	ThisObject.ShippingReceipt = False;

	SetAlreadyLinkedInfo(ThisObject.ResultsTree.GetItems(), SelectedRow.Key);
	FillVisibleFields(ThisObject.ResultsTree, "ResultsTree");
EndProcedure

&AtServer
Procedure FillBasisesTree(SelectedRowInfo)
	ThisObject.BasisesTree.GetItems().Clear();

	BasisesTable = CreateBasisesTable(SelectedRowInfo);
	TreeReverseInfo = RowIDInfoPrivileged.CreateBasisesTreeReverse(BasisesTable);
	RowIDInfoPrivileged.CreateBasisesTree(TreeReverseInfo, BasisesTable, ThisObject.ResultsTable.Unload(), ThisObject.BasisesTree.GetItems());
	FillVisibleFields(ThisObject.BasisesTree, "BasisesTree");
	
	ThisObject.BasisesTreeReverse.GetItems().Clear();
	
	DeepLevelRows = GetDeepLevelRows(ThisObject.BasisesTree.GetItems());
	DeepLevelRowsCopy = DeepLevelRows.Copy();
	DeepLevelRowsCopy.GroupBy("Item, ItemKey, Unit, BasisUnit, RowPresentation");
	For Each Row In DeepLevelRowsCopy Do
		NewRow = ThisObject.BasisesTreeReverse.GetItems().Add();
		FillPropertyValues(NewRow, Row);
		
		Filter = New Structure("Item, ItemKey, Unit, BasisUnit");
		FillPropertyValues(Filter, Row);
		For Each OriginalRow In DeepLevelRows.FindRows(Filter) Do
			TopLevelRow = GetTopLevelRow(OriginalRow.Parent);
			CopyTreeBranch(ThisObject.BasisesTreeReverse, NewRow.GetItems(), TopLevelRow);
		EndDo;
	EndDo;
	FillVisibleFields(ThisObject.BasisesTreeReverse, "BasisesTreeReverse");
EndProcedure

&AtServer
Function GetDeepLevelRows(Tree)
	DeepLevelRows = New ValueTable();
	DeepLevelRows.Columns.Add("Item");
	DeepLevelRows.Columns.Add("ItemKey");
	DeepLevelRows.Columns.Add("Unit");
	DeepLevelRows.Columns.Add("BasisUnit");
	DeepLevelRows.Columns.Add("RowPresentation");
	DeepLevelRows.Columns.Add("Parent");
	
	_GetDeepLevelRows(Tree, DeepLevelRows);
	Return DeepLevelRows;
EndFunction

&AtServer
Procedure _GetDeepLevelRows(TreeRows, DeepLevelRows)
	For Each Row In TreeRows Do
		If Row.DeepLevel Then
			NewRow = DeepLevelRows.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Parent = Row.GetParent();
		Else
			_GetDeepLevelRows(Row.GetItems(), DeepLevelRows)
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function GetTopLevelRow(val Parent)
	TopLevelRow = Undefined;
	_GetTopLevelRow(Parent, TopLevelRow);
	Return TopLevelRow;
EndFunction
	
&AtServer
Procedure _GetTopLevelRow(Parent, TopLevelRow)
	If TopLevelRow <> Undefined Then
		Return;
	EndIf;
	RowParent = Parent.GetParent();
	If RowParent = Undefined Then
		TopLevelRow = Parent;
	Else
		_GetTopLevelRow(RowParent, TopLevelRow);
	EndIf;
EndProcedure	

&AtServer
Procedure CopyTreeBranch(Tree, Parent, TopLevelRow)
	RowKey = TopLevelRow.Key;
	For Each Row In TopLevelRow.GetItems() Do
		If Row.DeepLevel Then
			RowKey = Row.Key;
			Break;
		EndIf;
	EndDo;
	
	If FindRowInTree(Tree, TopLevelRow.Basis, RowKey) <> Undefined Then
		Return;
	EndIf;
	
	NewRow = Parent.Add();
	FillPropertyValues(NewRow, TopLevelRow);
	
	For Each Row In TopLevelRow.GetItems() Do
		If Row.DeepLevel Then
			FillPropertyValues(NewRow, Row, ,"Basis, RowPresentation, Picture, IsMainDocument");
		Else
			CopyTreeBranch(Tree, NewRow.GetItems(), Row);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function FindRowInTree(Tree, Basis, RowKey)
	FoundedRow = Undefined;
	_FindRowInTree(Tree, Basis, RowKey, FoundedRow);
	Return FoundedRow;
EndFunction

&AtServer
Procedure _FindRowInTree(Tree, Basis, RowKey, FoundedRow)
	If FoundedRow <> Undefined Then
		Return;
	EndIf;
	For Each Row In Tree.GetItems() Do
		If Row.Basis = Basis And Row.Key = RowKey Then
			FoundedRow = Row;
		Else
			_FindRowInTree(Row, Basis, RowKey, FoundedRow);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure FillVisibleFields(Tree, TreeName)
	If ThisObject.VisibleFields <> Undefined Then
		RowIDInfoPrivileged.FillVisibleFields(Tree, ThisObject.VisibleFields); 
		For Each Field In ThisObject.VisibleFields Do
			Items["" + TreeName + Field.Key + "Presentation"].Visible = True;
		EndDo;
	EndIf;	
EndProcedure

&AtClient
Procedure Ok(Command)
	FillingValues = GetFillingValues();
	Close(New Structure("Operation, FillingValues, CalculateRows", 
		"LinkUnlinkDocumentRows", FillingValues, ThisObject.CalculateRows));
EndProcedure

&AtServer
Function GetFillingValues()
	BasisesTable = ThisObject.ResultsTable.Unload();
	AddInfo = New Structure();
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "IsLinkRows", True);
	ExtractedData = RowIDInfoPrivileged.ExtractData(BasisesTable, ThisObject.MainFilter.Ref, AddInfo);	
	FillingValues = RowIDInfoPrivileged.ConvertDataToFillingValues(ThisObject.MainFilter.Ref.Metadata(), ExtractedData, ThisObject.MainFilter.Ref);	
	Return FillingValues;
EndFunction

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

#Region Link

&AtClient
Procedure Link(Command)
	LinkAtClient();
EndProcedure

&AtClient
Procedure BasisesTreeSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	LinkAtClient();
EndProcedure

&AtClient
Procedure LinkAtClient()
	LinkInfo = IsCanLink();
	If Not LinkInfo.IsCan Then
		Return;
	EndIf;

	FillPropertyValues(ThisObject.ResultsTable.Add(), LinkInfo);

	RefreshTrees();
	SetIsLinkedItemListRows();
EndProcedure

&AtClient
Function IsCanLink(ItemListRowsData = Undefined, BasisesTreeData = Undefined)
	Result = New Structure("IsCan", False);

	If ItemListRowsData = Undefined Then
		ItemListRowsData = Items.ItemListRows.CurrentData;
		If ItemListRowsData = Undefined Then
			Return Result;
		EndIf;
	EndIf;
	
	If ItemListRowsData.IsExternalLinked Then
		Return Result;
	EndIf;
	
	If BasisesTreeData = Undefined Then
		If ThisObject.UseReverseBasisesTree Then
			BasisesTreeData = Items.BasisesTreeReverse.CurrentData;
		Else
			BasisesTreeData = Items.BasisesTree.CurrentData;
		EndIf;
		If BasisesTreeData = Undefined Then
			Return Result;
		EndIf;
	EndIf;

	If Not BasisesTreeData.DeepLevel Then
		Return Result;
	EndIf;
	
	Result.IsCan = True;
	Result.Insert("Key"     , ItemListRowsData.Key);
	Result.Insert("Item"    , ItemListRowsData.Item);
	Result.Insert("ItemKey" , ItemListRowsData.ItemKey);
	Result.Insert("Store"   , ItemListRowsData.Store);

	QuantityInBaseUnit = 0;
	If ValueIsFilled(ItemListRowsData.ItemKey) 
		And ValueIsFilled(ItemListRowsData.Unit) 
		And ValueIsFilled(ItemListRowsData.Quantity) Then
		ConvertationResult = RowIDInfoServer.ConvertQuantityToQuantityInBaseUnit(ItemListRowsData.ItemKey,
			ItemListRowsData.Unit, ItemListRowsData.Quantity);
			
		QuantityInBaseUnit = ConvertationResult.QuantityInBaseUnit;
		Result.Insert("BasisUnit", ConvertationResult.BasisUnit);
	Else
		QuantityInBaseUnit = BasisesTreeData.QuantityInBaseUnit;
		Result.Insert("BasisUnit", BasisesTreeData.BasisUnit);
	EndIf;
	If ValueIsFilled(ItemListRowsData.Unit) Then
		Result.Insert("Unit", ItemListRowsData.Unit);
	Else
		Result.Insert("Unit", BasisesTreeData.BasisUnit);
	EndIf;
	
	If TypeOf(BasisesTreeData.Basis) = Type("DocumentRef.ShipmentConfirmation") 
		Or TypeOf(BasisesTreeData.Basis) = Type("DocumentRef.GoodsReceipt") Then
		Result.Insert("QuantityInBaseUnit", Min(BasisesTreeData.QuantityInBaseUnit, QuantityInBaseUnit));
		Result.Insert("BasisUnit", BasisesTreeData.BasisUnit);
		Result.Insert("Unit", BasisesTreeData.BasisUnit);
	Else
		Result.Insert("QuantityInBaseUnit", QuantityInBaseUnit);
	EndIf;

	Result.Insert("RowRef"      , BasisesTreeData.RowRef);
	Result.Insert("CurrentStep" , BasisesTreeData.CurrentStep);
	Result.Insert("Basis"       , BasisesTreeData.Basis);
	Result.Insert("BasisKey"    , BasisesTreeData.BasisKey);
	Result.Insert("RowID"       , BasisesTreeData.RowID);
	Return Result;
EndFunction

&AtClient
Procedure BeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure BeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

#EndRegion

#Region Unlink

&AtClient
Procedure Unlink(Command)
	UnlinkInfo = IsCanUnlink();
	If Not UnlinkInfo.IsCan Then
		Return;
	EndIf;

	Filter = New Structure("Key, RowID, BasisKey");
	FillPropertyValues(Filter, UnlinkInfo);

	For Each Row In ThisObject.ResultsTable.FindRows(Filter) Do
		ThisObject.ResultsTable.Delete(Row);
	EndDo;

	RefreshTrees();
	SetIsLinkedItemListRows();
EndProcedure

&AtClient
Procedure UnlinkAll(Command)
	ArrayForDelete = New Array();
	For Each Row In ThisObject.ResultsTable Do
		UnlinkInfo = IsCanUnlink(Row);
		If UnlinkInfo.IsCan Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		ThisObject.ResultsTable.Delete(ItemForDelete);
	EndDo;
	RefreshTrees();
	SetIsLinkedItemListRows();
EndProcedure

&AtClient
Function IsCanUnlink(ResultsTableData = Undefined)
	Result = New Structure("IsCan", False);

	If ResultsTableData = Undefined Then
		ResultsTreeData = Items.ResultsTree.CurrentData;
		If ResultsTreeData = Undefined Then
			Return Result;
		EndIf;
	Else
		ArrayOfItemListRows = ThisObject.ItemListRows.FindRows(New Structure("Key", ResultsTableData.Key));
		For Each ItemOfItemListRows In ArrayOfItemListRows Do
			If ItemOfItemListRows.IsExternalLinked Then
				Return Result;
			EndIf;
		EndDo;
		
		Result.IsCan = True;
		Result.Insert("Key"      , ResultsTableData.Key);
		Result.Insert("RowID"    , ResultsTableData.RowID);
		Result.Insert("BasisKey" , ResultsTableData.BasisKey);
		Return Result;
	EndIf;
	
	ArrayOfItemListRows = ThisObject.ItemListRows.FindRows(New Structure("Key", ResultsTreeData.Key));
	For Each ItemOfItemListRows In ArrayOfItemListRows Do
		If ItemOfItemListRows.IsExternalLinked Then
			Return Result;
		EndIf;
	EndDo;
	
	If ResultsTreeData.DeepLevel Then
		Result.IsCan = True;
		Result.Insert("Key"      , ResultsTreeData.Key);
		Result.Insert("RowID"    , ResultsTreeData.RowID);
		Result.Insert("BasisKey" , ResultsTreeData.BasisKey);
	EndIf;
	Return Result;
EndFunction

#EndRegion

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtServer
Function CreateBasisesTable(SelectedRowInfo)
	FullFilter = New Structure();
	For Each KeyValue In ThisObject.MainFilter Do
		FullFilter.Insert(KeyValue.Key, KeyValue.Value);
	EndDo;

	If SelectedRowInfo.FilterBySelectedRow <> Undefined Then
		For Each KeyValue In SelectedRowInfo.FilterBySelectedRow Do
			FullFilter.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
	EndIf;

	BasisesTable = RowIDInfoPrivileged.GetBasises(ThisObject.MainFilter.Ref, FullFilter);

	AlreadyLinkedRows = ThisObject.ResultsTable.FindRows(New Structure("Key", SelectedRowInfo.SelectedRow.Key));
	
	// filter by already linked
	For Each Row In AlreadyLinkedRows Do
		Filter = New Structure();
		Filter.Insert("RowID"    , Row.RowID);
		Filter.Insert("BasisKey" , Row.BasisKey);
		Filter.Insert("Basis"    , Row.Basis);
		ArrayAlreadyLinked = BasisesTable.FindRows(Filter);
		For Each ItemArray In ArrayAlreadyLinked Do
			BasisesTable.Delete(ItemArray);
		EndDo;
	EndDo;

	ArrayForDelete = New Array();

	If ValueIsFilled(ThisObject.LinkedRowID) Then
		For Each Row In BasisesTable Do
			If ThisObject.ShippingReceipt Then
				If Not (TypeOf(Row.Basis) = Type("DocumentRef.ShipmentConfirmation") 
					Or TypeOf(Row.Basis) = Type("DocumentRef.GoodsReceipt")) Then
					ArrayForDelete.Add(Row);
				EndIf;
			Else
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
	EndIf;

	For Each ItemArray In ArrayForDelete Do
		BasisesTable.Delete(ItemArray);
	EndDo;
	
	// filter by serial lot number
	ArrayForDelete = New Array();
	If SelectedRowInfo.SelectedRow.Property("SerialLotNumber") Then
		SerialLotNumber = SelectedRowInfo.SelectedRow.SerialLotNumber;
		If ValueIsFilled(SerialLotNumber) Then
			For Each Row In BasisesTable Do
				SingleRowInfo = RowIDInfoServer.GetSerialLotNumber_SingleRowInfo(Row.Basis, Row.BasisKey);
				BasisSerialLotNumber = SingleRowInfo.Get(Row.BasisKey);
				If ValueIsFilled(BasisSerialLotNumber) 
					And BasisSerialLotNumber <> SerialLotNumber Then
						ArrayForDelete.Add(Row);
				EndIf;
			EndDo;
		EndIf;
	EndIf;
	
	For Each ItemArray In ArrayForDelete Do
		BasisesTable.Delete(ItemArray);
	EndDo;
		
	Return BasisesTable;
EndFunction

&AtClient
Procedure AutoLink(Command)
	For Each ItemListRow In ThisObject.ItemListRows Do
		RowInfo = RowIDInfoClient.GetSelectedRowInfo(ItemListRow, StrSplit(ThisObject.ArrayOfFilterExcludeFields, ","));
		NeedAutoLink = NeedAutoLinkAtServer(RowInfo);
		If NeedAutoLink.IsOk Then
			LinkInfo = IsCanLink(ItemListRow, NeedAutoLink.BaseInfo);
			If LinkInfo.IsCan Then
				FillPropertyValues(ThisObject.ResultsTable.Add(), LinkInfo);
			EndIf;
		EndIf;
	EndDo;
	RefreshTrees();
	SetIsLinkedItemListRows();
EndProcedure

&AtServer
Function NeedAutoLinkAtServer(RowInfo)
	NeedAutoLink = New Structure("IsOk, BaseInfo", False, New Structure());
	NeedAutoLink.BaseInfo.Insert("DeepLevel", True);
	NeedAutoLink.BaseInfo.Insert("QuantityInBaseUnit");
	NeedAutoLink.BaseInfo.Insert("BasisUnit");
	NeedAutoLink.BaseInfo.Insert("RowRef");
	NeedAutoLink.BaseInfo.Insert("CurrentStep");
	NeedAutoLink.BaseInfo.Insert("Basis");
	NeedAutoLink.BaseInfo.Insert("BasisKey");
	NeedAutoLink.BaseInfo.Insert("RowID");

	BasisesTable = CreateBasisesTable(RowInfo);

	If BasisesTable.Count() = 1 Then
		FillPropertyValues(NeedAutoLink.BaseInfo, BasisesTable[0]);
		NeedAutoLink.IsOk = True;
	Else
		
		BasisesTable.Columns.Add("Priority");
		Priority = 0;
		For Each Row In BasisesTable Do
			Row.Priority = Priority;
			Priority = Priority - 1; 
		EndDo;   
		BasisesTable.Sort("Priority");
		
		For Each Row In BasisesTable Do
			If RowInfo.SelectedRow.QuantityInBaseUnit = Row.QuantityInBaseUnit Then
				FillPropertyValues(NeedAutoLink.BaseInfo, Row);
				NeedAutoLink.IsOk = True;
				Break;
			EndIf;
		EndDo;
	EndIf;
	Return NeedAutoLink;
EndFunction

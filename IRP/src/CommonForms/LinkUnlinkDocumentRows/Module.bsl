
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.MainFilter = Parameters.Filter;
	
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
	
	FillItemListRows(Parameters.TablesInfo.ItemListRows);
	FillResultsTree(Parameters.SelectedRowInfo.SelectedRow);
	FillBasisesTree(Parameters.SelectedRowInfo.FilterBySelectedRow);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.BasisesTree, ThisObject.BasisesTree.GetItems());
	RowIDInfoClient.ExpandTree(Items.ResultsTree, ThisObject.ResultsTree.GetItems());
	SetButtonsEnabled();
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
	SelectedRowInfo = RowIDInfoClient.GetSelectedRowInfo(Items.ItemListRows.CurrentData);
	FillResultsTree(SelectedRowInfo.SelectedRow);
	FillBasisesTree(SelectedRowInfo.FilterBySelectedRow);
	
	ExpandAllTrees();
EndProcedure	

&AtServer
Procedure FillItemListRows(ItemListRows)
	For Each Row In ItemListRows Do
		NewRow = ThisObject.ItemListRows.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.RowPresentation = "" + Row.Item + ", " + Row.ItemKey;
		NewRow.Picture = 0;
	EndDo;
EndProcedure

&AtServer
Procedure SetAlreadyLinkedInfo(TreeRows)
	For Each TreeRow In TreeRows Do
		If TreeRow.DeepLevel Then
			ThisObject.LinkedRowID = TreeRow.RowID;
			If TypeOf(TreeRow.Basis) = Type("DocumentRef.ShipmentConfirmation")
				Or TypeOf(TreeRow.Basis) = Type("DocumentRef.GoodsReceipt") Then
				ThisObject.ShipingReceipt = True;
			Else
				ThisObject.ShipingReceipt = False;
			EndIf;
		EndIf;
		SetAlreadyLinkedInfo(TreeRow.GetItems());
	EndDo;
EndProcedure

&AtServer
Procedure FillResultsTree(SelectedRow)
	ThisObject.ResultsTree.GetItems().Clear();
	If SelectedRow = Undefined Then
		Return;
	EndIf;
	
	TmpBasisTable = ThisObject.ResultsTable.Unload().Copy(New Structure("Key", SelectedRow.Key));
	BasisesTable = TmpBasisTable.CopyColumns();
	For Each Row In TmpBasisTable Do
		If ValueIsFilled(Row.Basis) Then
			FillPropertyValues(BasisesTable.Add(), Row);
		EndIf;
	EndDo;
	TreeReverseInfo = RowIDInfoServer.CreateBasisesTreeReverse(BasisesTable);
	
	RowIDInfoServer.CreateBasisesTree(TreeReverseInfo, BasisesTable, ThisObject.ResultsTable.Unload(), ThisObject.ResultsTree.GetItems());	
	
	ThisObject.LinkedRowID = "";
	ThisObject.ShipingReceipt = False;
		
	SetAlreadyLinkedInfo(ThisObject.ResultsTree.GetItems());
EndProcedure	

&AtServer
Procedure FillBasisesTree(FilterBySelectedRow)
	ThisObject.BasisesTree.GetItems().Clear();
	
	FullFilter = New Structure();
	For Each KeyValue In ThisObject.MainFilter Do
		FullFilter.Insert(KeyValue.Key, KeyValue.Value);
	EndDo;
	
	If FilterBySelectedRow <> Undefined Then
		For Each KeyValue In FilterBySelectedRow Do
			FullFilter.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
	EndIf;
	
	BasisesTable = RowIDInfoServer.GetBasises(ThisObject.MainFilter.Ref, FullFilter);
	
	// filter by already linked
	For Each Row In ThisObject.ResultsTable Do
		Filter = New Structure();
		Filter.Insert("RowID"   , Row.RowID);
		Filter.Insert("BasisKey", Row.BasisKey);
		Filter.Insert("Basis"   , Row.Basis);
		ArrayAlredyLinked = BasisesTable.FindRows(Filter);
		For Each ItemArray In ArrayAlredyLinked Do
			BasisesTable.Delete(ItemArray);
		EndDo;
	EndDo;
	
	ArrayForDelete = New Array();
	If ValueIsFilled(ThisObject.LinkedRowID) Then
		For Each Row In BasisesTable Do
			If Row.RowID <> ThisObject.LinkedRowID Then
				ArrayForDelete.Add(Row);
				Continue;
			EndIf;
			If ThisObject.ShipingReceipt Then 
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
	
	TreeReverseInfo = RowIDInfoServer.CreateBasisesTreeReverse(BasisesTable);
		
	RowIDInfoServer.CreateBasisesTree(TreeReverseInfo, BasisesTable, ThisObject.ResultsTable.Unload(), ThisObject.BasisesTree.GetItems());
EndProcedure

&AtClient
Procedure Ok(Command)
	FillingValues = GetFillingValues();
	Close(New Structure("Operation, FillingValues", "LinkUnlinkDocumentRows", FillingValues));
EndProcedure

&AtServer
Function GetFillingValues()
	BasisesTable = ThisObject.ResultsTable.Unload();
	ExtractedData = RowIDInfoServer.ExtractData(BasisesTable, ThisObject.MainFilter.Ref);
	FillingValues = RowIDInfoServer.ConvertDataToFillingValues(ThisObject.MainFilter.Ref.Metadata(), ExtractedData);
	Return FillingValues;
EndFunction

&AtClient
Procedure Cancel(Command)
	Close(Undefined);	
EndProcedure

#Region Link

&AtClient
Procedure Link(Command)
	LinkInfo = IsCanLink();
	If Not LinkInfo.IsCan Then
		Return;
	EndIf;
	
	FillPropertyValues(ThisObject.ResultsTable.Add(), LinkInfo);
	
	RefreshTrees();
EndProcedure

&AtClient
Function IsCanLink()
	Result = New Structure("IsCan", False);
	
	ItemListRowsCurrentData = Items.ItemListRows.CurrentData;
	If ItemListRowsCurrentData = Undefined Then
		Return Result;
	EndIf;
	
	BasisesTreeCurrentData = Items.BasisesTree.CurrentData;
	If BasisesTreeCurrentData = Undefined Then
		Return Result;
	EndIf;
	
	If Not BasisesTreeCurrentData.DeepLevel Then
		Return Result;
	EndIf;
	
	Result.IsCan = True;
	Result.Insert("Key"         , ItemListRowsCurrentData.Key);
	Result.Insert("Item"        , ItemListRowsCurrentData.Item);
	Result.Insert("ItemKey"     , ItemListRowsCurrentData.ItemKey);
	Result.Insert("Store"       , ItemListRowsCurrentData.Store);
	
	If ValueIsFilled(ItemListRowsCurrentData.ItemKey)
		And ValueIsFilled(ItemListRowsCurrentData.Unit)
		And ValueIsFilled(ItemListRowsCurrentData.Quantity) Then
		ConvertationResult = ConvertQuantityToQuantityInBaseUnit(ItemListRowsCurrentData.ItemKey, 
		                                                         ItemListRowsCurrentData.Unit, 
		                                                         ItemListRowsCurrentData.Quantity);
		
		Result.Insert("QuantityInBaseUnit" , ConvertationResult.QuantityInBaseUnit);
		Result.Insert("BasisUnit"          , ConvertationResult.BasisUnit);		                                                   
	Else
		Result.Insert("QuantityInBaseUnit" , BasisesTreeCurrentData.QuantityInBaseUnit);
		Result.Insert("BasisUnit"          , BasisesTreeCurrentData.BasisUnit);
	EndIf;
	
	If ValueIsFilled(ItemListRowsCurrentData.Unit) Then
		Result.Insert("Unit" , ItemListRowsCurrentData.Unit);
	Else
		Result.Insert("Unit" , BasisesTreeCurrentData.Unit);
	EndIf;
	
	Result.Insert("RowRef"      , BasisesTreeCurrentData.RowRef);
	Result.Insert("CurrentStep" , BasisesTreeCurrentData.CurrentStep);
	Result.Insert("Basis"       , BasisesTreeCurrentData.Basis);
	Result.Insert("BasisKey"    , BasisesTreeCurrentData.BasisKey);
	Result.Insert("RowID"       , BasisesTreeCurrentData.RowID);
	Return Result;
EndFunction

&AtServer
Function ConvertQuantityToQuantityInBaseUnit(ItemKey, Unit, Quantity)
	Return Catalogs.Units.ConvertQuantityToQuantityInBaseUnit(ItemKey, Unit, Quantity);
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
	LinkInfo = IsCanUnlink();
	If Not LinkInfo.IsCan Then
		Return;
	EndIf;
	
	Filter = New Structure("Key, RowID, BasisKey");
	FillPropertyValues(Filter, LinkInfo);
	
	For Each Row In ThisObject.ResultsTable.FindRows(Filter) Do
		ThisObject.ResultsTable.Delete(Row);
	EndDo;
	
	RefreshTrees();	
EndProcedure

&AtClient
Function IsCanUnlink()
	Result = New Structure("IsCan", False);
	
	ResultsTreeCurrentData = Items.ResultsTree.CurrentData;
	If ResultsTreeCurrentData = Undefined Then
		Return Result;
	EndIf;
	
	If ResultsTreeCurrentData.DeepLevel Then
		Result.IsCan = True;
		Result.Insert("Key"      , ResultsTreeCurrentData.Key);
		Result.Insert("RowID"    , ResultsTreeCurrentData.RowID);
		Result.Insert("BasisKey" , ResultsTreeCurrentData.BasisKey);
	EndIf;
	Return Result;
EndFunction

#EndRegion

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

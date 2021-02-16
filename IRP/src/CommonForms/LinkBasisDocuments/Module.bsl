
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.MainFilter = Parameters.Filter;
	ThisObject.Mode = "LinkExists";
	
	FillItemListRows(Parameters.TablesInfo.ItemListRows);
	
	FillResultsTree(Parameters.TablesInfo.RowIDInfoRows);
			
	FillDocumentsTree(Parameters.SelectedRowInfo.SelectedRow, 
		Parameters.SelectedRowInfo.FilterBySelectedRow);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.DocumentsTree, ThisObject.DocumentsTree.GetItems());
	RowIDInfoClient.ExpandTree(Items.ResultsTree, ThisObject.ResultsTree.GetItems());
EndProcedure

&AtClient
Procedure ItemListRowsOnActivateRow(Item)
	SelectedRowInfo = RowIDInfoClient.GetSelectedRowInfo(Items.ItemListRows.CurrentData);
	FillDocumentsTree(SelectedRowInfo.SelectedRow, SelectedRowInfo.FilterBySelectedRow);
	RowIDInfoClient.ExpandTree(Items.DocumentsTree, ThisObject.DocumentsTree.GetItems());
EndProcedure

&AtClient
Procedure DocumentsTreeOnActivateRow(Item)
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

&AtServer
Procedure FillItemListRows(ItemListRows)
	For Each Row In ItemListRows Do
		NewRow = ThisObject.ItemListRows.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.RowPresentation = 
		"" + Row.Item + ", " + Row.ItemKey + ", " + Row.Store;
		NewRow.Picture = 3;
	EndDo;
EndProcedure

&AtServer
Procedure FillResultsTree(RowIDInfoRows)
	RowIDInfoTable = New ValueTable();
	RowIDInfoTable.Columns.Add("Key");
	RowIDInfoTable.Columns.Add("RowID"); 
	RowIDInfoTable.Columns.Add("Quantity"); 
	RowIDInfoTable.Columns.Add("Basis");
	RowIDInfoTable.Columns.Add("CurrentStep");
	RowIDInfoTable.Columns.Add("NextStep");
	RowIDInfoTable.Columns.Add("RowRef");
	For Each ItemOfArray In RowIDInfoRows Do
		NewRow = RowIDInfoTable.Add();
		For Each KeyValue In ItemOfArray Do
			NewRow[KeyValue.Key] = KeyValue.Value;
		EndDo;
	EndDo;
	RowIDInfoTableGrouped = RowIDInfoTable.Copy();
	RowIDInfoTableGrouped.GroupBy("Key", "Quantity");
	For Each Row In RowIDInfoTableGrouped Do
		ArrayOfTopLevelRows = ThisObject.ItemListRows.FindRows(New Structure("Key", Row.Key));
		For Each TopLevelRow In ArrayOfTopLevelRows Do
			TopLevelNewRow = ThisObject.ResultsTree.GetItems().Add();
			FillPropertyValues(TopLevelNewRow, TopLevelRow);
			TopLevelNewRow.Level = 1;
			TopLevelNewRow.Picture = 3;
			TopLevelNewRow.Quantity = Row.Quantity;
			TopLevelNewRow.RowPresentation = 
			"" + TopLevelRow.Item + ", " + TopLevelRow.ItemKey + ", " + TopLevelRow.Store;
			
			ArrayOfSecondLevelRows = RowIDInfoTable.FindRows(New Structure("Key", Row.Key));
			
			For Each SecondLevelRow In ArrayOfSecondLevelRows Do
				SecondLevelNewRow = TopLevelNewRow.GetItems().Add();		
				FillPropertyValues(SecondLevelNewRow, SecondLevelRow);
				SecondLevelNewRow.Level = 2;
				SecondLevelNewRow.Picture = 2;
				SecondLevelNewRow.RowPresentation = String(SecondLevelRow.Basis);
			EndDo;
		EndDo;
	EndDo;
EndProcedure	

&AtServer
Procedure FillDocumentsTree(SelectedRow, FilterBySelectedRow);
	FullFilter = New Structure();
	For Each KeyValue In ThisObject.MainFilter Do
		FullFilter.Insert(KeyValue.Key, KeyValue.Value);
	EndDo;
	
	If FilterBySelectedRow <> Undefined Then
		For Each KeyValue In FilterBySelectedRow Do
			FullFilter.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
	EndIf;
	
	BasisesTable = RowIDInfo.GetBasisesForSalesInvoice(FullFilter);
	
	TopLevelTable = BasisesTable.Copy(,"Basis");
	TopLevelTable.GroupBy("Basis");
	
	ThisObject.DocumentsTree.GetItems().Clear();
	
	For Each TopLevelRow In TopLevelTable Do
		TopLevelNewRow = ThisObject.DocumentsTree.GetItems().Add();
		TopLevelNewRow.Basis = TopLevelRow.Basis;
		
		TopLevelNewRow.RowPresentation = String(TopLevelRow.Basis);
		TopLevelNewRow.Level = 1;
		TopLevelNewRow.Picture = 2;
		
		SecondLevelRows = BasisesTable.FindRows(New Structure("Basis", TopLevelNewRow.Basis));
		
		For Each SecondLevelRow In SecondLevelRows Do
			SecondLevelNewRow = TopLevelNewRow.GetItems().Add();
			FillPropertyValues(SecondLevelNewRow, SecondLevelRow);
			
			SecondLevelNewRow.RowPresentation = 
			"" + SecondLevelRow.Item + ", " + SecondLevelRow.ItemKey + ", " + SecondLevelRow.Store;
			SecondLevelNewRow.Level   = 2;
			SecondLevelNewRow.Picture = 3;
			
			If SelectedRow <> Undefined Then
				UnitFactorFrom = Catalogs.Units.GetUnitFactor(SecondLevelRow.BasisUnit, SecondLevelRow.Quantity);
				UnitFactorTo = Catalogs.Units.GetUnitFactor(SelectedRow.Unit, SelectedRow.Quantity);
				SecondLevelNewRow.Quantity = ?(UnitFactorTo = 0, 0, SecondLevelRow.Quantity * UnitFactorFrom / UnitFactorTo);
				SecondLevelNewRow.Unit = SelectedRow.Unit;
			Else
				SecondLevelNewRow.Quantity = SecondLevelRow.Quantity;
				SecondLevelNewRow.Unit = SecondLevelRow.BasisUnit;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	ArrayOfRowIDInfo = New Array();
	For Each TopLevelRow In ThisObject.ResultsTree.GetItems() Do
		For Each SecondLevelRow In TopLevelRow.GetItems() Do
			NewRowIDInfo = New Structure();
			NewRowIDInfo.Insert("Key"          , SecondLevelRow.Key);
			NewRowIDInfo.Insert("RowID"        , SecondLevelRow.RowID);
			NewRowIDInfo.Insert("Quantity"     , SecondLevelRow.Quantity);
			NewRowIDInfo.Insert("Basis"        , SecondLevelRow.Basis);
			NewRowIDInfo.Insert("CurrentStep"  , SecondLevelRow.CurrentStep);
			//NewRowIDInfo.Insert("NextStep"     , SecondLevelRow.NextStep);
			NewRowIDInfo.Insert("RowRef"       , SecondLevelRow.RowRef);
			ArrayOfRowIDInfo.Add(NewRowIDInfo);
		EndDo;
	EndDo;
	Close(ArrayOfRowIDInfo);
EndProcedure

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
	
	Filter = New Structure();
	Filter.Insert("Key"   , LinkInfo.Key);
	Filter.Insert("Level" , 1);
	TreeRowID = RowIDInfoClient.FindRowInTree(Filter, ThisObject.ResultsTree);
	If TreeRowID = Undefined Then
		TopLevelNewRow = ThisObject.ResultsTree.GetItems().Add();
	Else
		TopLevelNewRow = ThisObject.ResultsTree.FindByID(TreeRowID);
	EndIf;
	
	FillPropertyValues(TopLevelNewRow, LinkInfo);
	TopLevelNewRow.Level = 1;
	TopLevelNewRow.Picture = 3;
	TopLevelNewRow.RowID = "";
	TopLevelNewRow.RowRef = Undefined;
	TopLevelNewRow.RowPresentation = 
	"" + LinkInfo.Item + ", " + LinkInfo.ItemKey + ", " + LinkInfo.Store;
	
	
	SecondLevelNewRow = TopLevelNewRow.GetItems().Add();		
	FillPropertyValues(SecondLevelNewRow, LinkInfo);
	SecondLevelNewRow.Level = 2;
	SecondLevelNewRow.Picture = 2;
	SecondLevelNewRow.RowPresentation = String(LinkInfo.Basis);
		
	SetButtonsEnabled();
	RowIDInfoClient.ExpandTree(Items.ResultsTree, ThisObject.ResultsTree.GetItems());
EndProcedure

&AtClient
Function IsCanLink()
	Result = New Structure("IsCan", False);
	
	ItemListRowsCurrentData = Items.ItemListRows.CurrentData;
	If ItemListRowsCurrentData = Undefined Then
		Return Result;
	EndIf;
	
	DocumentsTreeCurrentData = Items.DocumentsTree.CurrentData;
	If DocumentsTreeCurrentData = Undefined Then
		Return Result;
	EndIf;
	
	If DocumentsTreeCurrentData.Level = 2 Then
		Filter = New Structure();
		Filter.Insert("Key"   , ItemListRowsCurrentData.Key);
		Filter.Insert("RowID" , DocumentsTreeCurrentData.RowID);
		Filter.Insert("Basis" , DocumentsTreeCurrentData.Basis);
		If RowIDInfoClient.FindRowInTree(Filter, ThisObject.ResultsTree) <> Undefined Then
			Return Result;
		Else
			Result.IsCan = True;
			Result.Insert("Item"        , ItemListRowsCurrentData.Item);
			Result.Insert("ItemKey"     , ItemListRowsCurrentData.ItemKey);
			Result.Insert("Store"       , ItemListRowsCurrentData.Store);
			Result.Insert("Quantity"    , ItemListRowsCurrentData.Quantity);
			Result.Insert("Unit"        , ItemListRowsCurrentData.Unit);
			Result.Insert("RowRef"      , DocumentsTreeCurrentData.RowRef);
			Result.Insert("CurrentStep" , DocumentsTreeCurrentData.CurrentStep);
	
			Result.Insert("Key"      , ItemListRowsCurrentData.Key);
			Result.Insert("Basis"    , DocumentsTreeCurrentData.Basis);
			Result.Insert("RowID"    , DocumentsTreeCurrentData.RowID);
		EndIf;
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region Unlink

&AtClient
Procedure Unlink(Command)
	LinkInfo = IsCanUnlink();
	If Not LinkInfo.IsCan Then
		Return;
	EndIf;
	
	Filter = New Structure();
	Filter.Insert("RowID" , LinkInfo.RowID);
	Filter.Insert("Level" , 2);
	TreeRowID = RowIDInfoClient.FindRowInTree(Filter, ThisObject.ResultsTree);	
	SecondLevelRow = ThisObject.ResultsTree.FindByID(TreeRowID);
	SecondLevelRow.GetParent().GetItems().Delete(SecondLevelRow);
	TopLevelRowsForDelete = New Array();
	For Each TopLevelRow In ThisObject.ResultsTree.GetItems() Do
		If Not TopLevelRow.GetItems().Count() Then
			TopLevelRowsForDelete.Add(TopLevelRow);
		EndIf;
	EndDo;
	For Each Row In TopLevelRowsForDelete Do
		ThisObject.ResultsTree.GetItems().Delete(Row);
	EndDo;
EndProcedure

&AtClient
Function IsCanUnlink()
	Result = New Structure("IsCan", False);
	
	ResultsTreeCurrentData = Items.ResultsTree.CurrentData;
	If ResultsTreeCurrentData = Undefined Then
		Return Result;
	EndIf;
	
	If ResultsTreeCurrentData.Level = 2 Then
		Result.IsCan = True;
		Result.Insert("Key"   , ResultsTreeCurrentData.Key);
		Result.Insert("RowID" , ResultsTreeCurrentData.RowID);
	EndIf;
	Return Result;
EndFunction

#EndRegion







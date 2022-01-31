
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.BasisRowID = Parameters.BasisRowID;
	List.Parameters.SetParameterValue("Company", Parameters.Company);
	
	If Parameters.SelectedRows.Count() Then
		SelectedRowsTable = New ValueTable();
		SelectedRowsTable.Columns.Add("Use");
		SelectedRowsTable.Columns.Add("BasisRowID");
		SelectedRowsTable.Columns.Add("RowID");
		SelectedRowsTable.Columns.Add("Document");
		SelectedRowsTable.Columns.Add("Store");
		SelectedRowsTable.Columns.Add("ItemKey");
		For Each Row In Parameters.SelectedRows Do
			FillPropertyValues(SelectedRowsTable.Add(), Row);
		EndDo;
		SelectedRowsTable.FillValues(True, "Use");
		SelectedRowsTableCopy = SelectedRowsTable.Copy();
		SelectedRowsTableCopy.GroupBy("Document");
		For Each Row In SelectedRowsTableCopy Do
			SaveRowsToResultTree(Row.Document, SelectedRowsTable.Copy(New Structure("Document", Row.Document)));
		EndDo;
		ClearDocumentsWithOutRows();
	EndIf;
	
	Items.GroupRowEditor.CurrentPage = Items.GroupDocuments;
EndProcedure

&AtClient
Procedure Ok(Command)
	ArrayOfSelectedRows = New Array();
	For Each Row_TopLevel In ThisObject.ResultTree.GetItems() Do
		For Each Row_Second_Level In Row_TopLevel.GetItems() Do
			SelectedRow = New Structure();
			SelectedRow.Insert("BasisRowID", ThisObject.BasisRowID);
			SelectedRow.Insert("RowID"     , Row_Second_Level.RowID);
			SelectedRow.Insert("Document"  , Row_Second_Level.Document);
			SelectedRow.Insert("Store"     , Row_Second_Level.Store);
			SelectedRow.Insert("ItemKey"   , Row_Second_Level.ItemKey);
			ArrayOfSelectedRows.Add(SelectedRow);
		EndDo;
	EndDo;
	Close(New Structure("SelectedRows, BasisRowID", ArrayOfSelectedRows, ThisObject.BasisRowID));	
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
		AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.ResultTree, ThisObject.ResultTree.GetItems());
EndProcedure

&AtClient
Procedure SwitchToSelectRowsStep()
	CurrentData = Items.List.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FillDocumentRows(CurrentData.Document, ThisObject.BasisRowID);
	Items.GroupRowEditor.CurrentPage = Items.GroupRows;
EndProcedure

&AtServer
Procedure FillDocumentRows(Document, BasisRowID)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	&BasisRowID AS BasisRowID,
	|	T6020S_BatchKeysInfo.RowID,
	|	T6020S_BatchKeysInfo.Recorder AS Document,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|WHERE
	|	T6020S_BatchKeysInfo.Recorder = &Document
	|	AND T6020S_BatchKeysInfo.RowID <> """"
	|	AND T6020S_BatchKeysInfo.Direction = VALUE(Enum.BatchDirection.Receipt)
	|	AND T6020S_BatchKeysInfo.Recorder REFS Document.PurchaseInvoice";
	Query.SetParameter("Document", Document);
	Query.SetParameter("BasisRowID", BasisRowID);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	ThisObject.DocumentRows.Clear();
	While QuerySelection.Next() Do
		NewRow = ThisObject.DocumentRows.Add();
		FillPropertyValues(NewRow, QuerySelection);
		For Each Row_TopLevel In ThisObject.ResultTree.GetItems() Do
			For Each Row_Second_Level In Row_TopLevel.GetItems() Do
				If Row_Second_Level.RowID = QuerySelection.RowID 
					And Row_Second_Level.Document = QuerySelection.Document Then
						NewRow.Use = True;
				EndIf;
			EndDo;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure SelectDocument(Command)
	SwitchToSelectRowsStep();
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	SwitchToSelectRowsStep();
EndProcedure

&AtClient
Procedure EditorCancel(Command)
	Items.GroupRowEditor.CurrentPage = Items.GroupDocuments;
EndProcedure

&AtClient
Procedure EditorOk(Command)
	If ThisObject.DocumentRows.Count() Then
		Document = ThisObject.DocumentRows[0].Document;
		ArrayOfRows = New Array();
		For Each Row In ThisObject.DocumentRows Do
			NewRow = New Structure("Use, BasisRowID, RowID, Document, Store, ItemKey");
			FillPropertyValues(NewRow, Row);
			ArrayOfRows.Add(NewRow);
		EndDo;
		SaveRowsToResultTree(Document, ArrayOfRows);
	EndIf;
	ClearDocumentsWithOutRows();
	RowIDInfoClient.ExpandTree(Items.ResultTree, ThisObject.ResultTree.GetItems());
	Items.GroupRowEditor.CurrentPage = Items.GroupDocuments;
EndProcedure

&AtServer
Procedure SaveRowsToResultTree(Document, RowsForSave)
	DocumentFound = False;
	For Each Row_TopLevel In ThisObject.ResultTree.GetItems() Do
		If Row_TopLevel.Document = Document Then
			DocumentFound = True;
			Break;
		EndIf;
	EndDo;
	If Not DocumentFound Then
		Row_TopLevel = ThisObject.ResultTree.GetItems().Add();
		Row_TopLevel.Level = 1;
		Row_TopLevel.Document = Document;
	Else
		Row_TopLevel.GetItems().Clear();
	EndIf;
	For Each Row In RowsForSave Do
		If Not Row.Use Then
			Continue;
		EndIf;
		NewRow_SecondLevel = Row_TopLevel.GetItems().Add();
		NewRow_SecondLevel.Level = 2;
		FillPropertyValues(NewRow_SecondLevel, Row);
	EndDo;
EndProcedure

&AtServer
Procedure ClearDocumentsWithOutRows();
	ArrayForDelete = New Array();
	For Each Row In ThisObject.ResultTree.GetItems() Do
		If Not Row.GetItems().Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		ThisObject.ResultTree.GetItems().Delete(ItemForDelete);
	EndDo;
EndProcedure

&AtClient
Procedure ResultTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ResultTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentRowsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentRowsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure


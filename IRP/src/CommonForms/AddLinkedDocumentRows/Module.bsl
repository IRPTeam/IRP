
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.MainFilter = Parameters.Filter;

	If Parameters.Property("SetAllCheckedOnOpen") Then
		ThisObject.SetAllCheckedOnOpen = Parameters.SetAllCheckedOnOpen;
	EndIf;
	
	If Parameters.Property("SeparateByBasedOn") Then
		ThisObject.SeparateByBasedOn = Parameters.SeparateByBasedOn;		
	EndIf;
	
	For Each Row_IdInfo In Parameters.TablesInfo.RowIDInfoRows Do
		NewRow = ThisObject.ResultsTable.Add();
		FillPropertyValues(NewRow, Row_IDInfo);
		For Each Row_ItemList In Parameters.TablesInfo.ItemListRows Do
			If Row_IdInfo.Key = Row_ItemList.Key Then
				FillPropertyValues(NewRow, Row_ItemList, "ItemKey, Item, Store");
				NewRow.BasisUnit = ?(ValueIsFilled(Row_ItemList.ItemKey.Unit), 
				Row_ItemList.ItemKey.Unit, Row_ItemList.ItemKey.Item.Unit);
			EndIf;
		EndDo;
	EndDo;
				
	FillDocumentsTree();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
	If ThisObject.SetAllCheckedOnOpen Then
		SetChecked(True);
	EndIf;
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	RowIDInfoClient.ExpandTree(Items.DocumentsTree, ThisObject.DocumentsTree.GetItems());
EndProcedure

&AtServer
Procedure FillDocumentsTree();
		
	BasisesTable = RowIDInfoServer.GetBasises(ThisObject.MainFilter.Ref, ThisObject.MainFilter);
	
	TopLevelTable = BasisesTable.Copy(,"Basis");
	TopLevelTable.GroupBy("Basis");
	
	ThisObject.DocumentsTree.GetItems().Clear();
	
	For Each TopLevelRow In TopLevelTable Do
		TopLevelNewRow = ThisObject.DocumentsTree.GetItems().Add();
		TopLevelNewRow.Basis = TopLevelRow.Basis;
		
		TopLevelNewRow.RowPresentation = String(TopLevelRow.Basis);
		TopLevelNewRow.Level = 1;
		TopLevelNewRow.Picture = 1;
		
		SecondLevelRows = BasisesTable.FindRows(New Structure("Basis", TopLevelNewRow.Basis));
		
		For Each SecondLevelRow In SecondLevelRows Do
			SecondLevelNewRow = TopLevelNewRow.GetItems().Add();
			FillPropertyValues(SecondLevelNewRow, SecondLevelRow);
			
			SecondLevelNewRow.RowPresentation = 
			"" + SecondLevelRow.Item + ", " + SecondLevelRow.ItemKey + ", " + SecondLevelRow.Store;
			SecondLevelNewRow.Level   = 2;
			SecondLevelNewRow.Picture = 0;
			
			SecondLevelNewRow.Quantity = SecondLevelRow.Quantity;
			SecondLevelNewRow.BasisUnit = SecondLevelRow.BasisUnit;
			Filter = New Structure();
			Filter.Insert("RowID"    , SecondLevelRow.RowID);
			Filter.Insert("BasisKey" , SecondLevelRow.Key);
			Filter.Insert("Basis"    , SecondLevelRow.Basis);
			If ThisObject.ResultsTable.FindRows(Filter).Count() Then
				SecondLevelNewRow.Use = True;
				SecondLevelNewRow.Linked = True;
			EndIf;
			
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	FillingValues = GetFillingValues();
	Close(New Structure("Operation, FillingValues", "AddLinkedDocumentRows", FillingValues));
EndProcedure

&AtServer
Function GetFillingValues()
	BasisesTable = ThisObject.ResultsTable.Unload().CopyColumns();
	For Each TopLevelRow In ThisObject.DocumentsTree.GetItems() Do
		For Each SecondLevelRow In TopLevelRow.GetItems() Do
			If SecondLevelRow.Use And Not SecondLevelRow.Linked Then
				FillPropertyValues(BasisesTable.Add(), SecondLevelRow);
			EndIf;
		EndDo;
	EndDo;
	
	ExtractedData = RowIDInfoServer.ExtractData(BasisesTable);
	FillingValues = RowIDInfoServer.ConvertDataToFillingValues(ThisObject.MainFilter.Ref.Metadata(), 
		ExtractedData, ThisObject.SeparateByBasedOn);
	Return FillingValues;
EndFunction

&AtClient
Procedure Cancel(Command)
	Close(Undefined);	
EndProcedure

&AtClient
Procedure CheckAll(Command)
	SetChecked(True);
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	SetChecked(False);
EndProcedure

&AtClient
Procedure SetChecked(Value)
	For Each TopLevelRow In ThisObject.DocumentsTree.GetItems() Do
		For Each SecondLevelRow In TopLevelRow.GetItems() Do
			SecondLevelRow.Use = Value;
		EndDo;
	EndDo;	
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);	
EndProcedure


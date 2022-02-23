
#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	Return;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	Return;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocAdditionalRevenueAllocationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocAdditionalRevenueAllocationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocAdditionalRevenueAllocationClient.OnOpen(Object, ThisObject, Cancel);
	RefreshRowsAllocationTreesAtClient();
	SetVisibilityAllocations();
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	RefreshRowsAllocationTreesAtClient();
	SetVisibilityAllocations();
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocAdditionalRevenueAllocationServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export
	Form.Items.GroupByRows.Visible = Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByRows");
	Form.Items.GroupByDocuments.Visible = Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByDocuments");
EndProcedure

&AtClient
Procedure SetVisibilityAllocations() Export
	If Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByDocuments") Then
		CurrentData = ThisObject.Items.RevenueDocuments.CurrentData;
		If CurrentData = Undefined Then
			Return;
		EndIf;
		For Each Row In Object.AllocationDocuments Do
			Row.Visible = Row.Key = CurrentData.Key;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure AllocationModeOnChange(Item)
	If Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByDocuments") Then
		Object.RevenueList.Clear();
		Object.AllocationList.Clear();
		SetVisibilityAvailability(Object, ThisObject);
	ElsIf Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByRows") Then
		Object.RevenueDocuments.Clear();
		Object.AllocationDocuments.Clear();
		SetVisibilityAvailability(Object, ThisObject);
		RefreshRowsAllocationTreesAtClient();
	EndIf;
EndProcedure

&AtClient
Procedure RefreshRowsAllocationTreesAtClient()
	If Not Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByRows") Then
		Return;
	EndIf;
	RefreshRowsAllocationTreesAtServer();
	
	RowIDInfoClient.ExpandTree(Items.RevenueRows, ThisObject.RevenueRows.GetItems());
	RowIDInfoClient.ExpandTree(Items.AllocationRows, ThisObject.AllocationRows.GetItems());
EndProcedure

&AtServer
Procedure RefreshRowsAllocationTreesAtServer()
	// Revenue rows
	ThisObject.RevenueRows.GetItems().Clear();
	
	BasisTable = Object.RevenueList.Unload();
	BasisTable.GroupBy("Basis");
	For Each RowBasis In BasisTable Do
		NewRow_TopLevel = ThisObject.RevenueRows.GetItems().Add();
		NewRow_TopLevel.Level = 1;
		NewRow_TopLevel.Document = RowBasis.Basis;
		For Each RowDetail In Object.RevenueList.FindRows(New Structure("Basis", RowBasis.Basis)) Do
			NewRow_SecondLevel = NewRow_TopLevel.GetItems().Add();
			NewRow_SecondLevel.Level = 2;
			FillPropertyValues(NewRow_SecondLevel, RowDetail);
		EndDo;
	EndDo;
	
	// Allocation rows
	ThisObject.AllocationRows.GetItems().Clear();
	
	BasisTable = Object.AllocationList.Unload();
	BasisTable.GroupBy("Document");
	For Each RowBasis In BasisTable Do
		NewRow_TopLevel = ThisObject.AllocationRows.GetItems().Add();
		NewRow_TopLevel.Level = 1;
		NewRow_TopLevel.Document = RowBasis.Document;
		For Each RowDetail In Object.AllocationList.FindRows(New Structure("Document", RowBasis.Document)) Do
			NewRow_SecondLevel = NewRow_TopLevel.GetItems().Add();
			NewRow_SecondLevel.Level = 2;
			FillPropertyValues(NewRow_SecondLevel, RowDetail);
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure RevenueDocumentsOnChange(Item)
	For Each Row In Object.RevenueDocuments Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = String(New UUID());
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure RevenueDocumentsDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	Notify = New NotifyDescription("RevenueDocumentsDocumentStartChoiceEnd", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company" , Object.Company);
	FormParameters.Insert("Ref"     , Object.Ref);
	FormParameters.Insert("Date"    , Object.Date);
	ArrayOfSelectedDocuments = New Array();
	For Each Row In Object.RevenueDocuments Do
		ArrayOfSelectedDocuments.Add(Row.Document);
	EndDo;
	FormParameters.Insert("SelectedDocuments", ArrayOfSelectedDocuments);
	
	OpenForm("Document.AdditionalRevenueAllocation.Form.FormSelectRevenueDocument",
		FormParameters,
		Item,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure RevenueRowsBeforeDeleteRow(Item, Cancel)
	Cancel = True;	
EndProcedure

&AtClient
Procedure AllocationRowsBeforeDeleteRow(Item, Cancel)
	Cancel = True;	
EndProcedure

&AtClient
Procedure AllocationRowsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	CurrentData = Items.RevenueRows.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	Notify = New NotifyDescription("AllocationRowsBeforeAddRowEnd", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company" , Object.Company);
	FormParameters.Insert("BasisRowID", CurrentData.RowID);
	
	ArrayOfSelectedRows = New Array();
	For Each Row In Object.AllocationList Do
		If Row.BasisRowID <> CurrentData.RowID Then
			Continue;
		EndIf;
		SelectedRow = New Structure();
		
		SelectedRow.Insert("BasisRowID", Row.BasisRowID);
		SelectedRow.Insert("RowID"     ,Row.RowID);
		SelectedRow.Insert("Document"  , Row.Document);
		SelectedRow.Insert("Store"     , Row.Store);
		SelectedRow.Insert("ItemKey"   , Row.ItemKey);
		ArrayOfSelectedRows.Add(SelectedRow)
	EndDo;
	
	FormParameters.Insert("SelectedRows", ArrayOfSelectedRows);
	
	OpenForm("Document.AdditionalRevenueAllocation.Form.FormSelectAllocationRows",
		FormParameters,
		Item,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure RevenueRowsOnActivateRow(Item)
	ThisObject.TotalAllocationRows = 0;
	CurrentData = Items.RevenueRows.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	IsSecondLevel = CurrentData.Level = 2;
	Items.AllocationRowsAdd.Enabled = IsSecondLevel;
	
	// Set visible
	For Each Row_TopLevel In ThisObject.AllocationRows.GetItems() Do
		SecondLevelIsVisible = False;
		For Each Row_SecondLevel In Row_TopLevel.GetItems() Do
			If Row_SecondLevel.BasisRowID = CurrentData.RowID Then
				SecondLevelIsVisible = True;
				Row_SecondLevel.Visible = True;
				ThisObject.TotalAllocationRows = ThisObject.TotalAllocationRows +
				Row_SecondLevel.Amount;
			Else
				Row_SecondLevel.Visible = False;
			EndIf;
		EndDo;
		Row_TopLevel.Visible = SecondLevelIsVisible;
	EndDo;
EndProcedure

&AtClient
Procedure RevenueRowsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	Notify = New NotifyDescription("RevenueRowsBeforeAddRowEnd", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company" , Object.Company);
	FormParameters.Insert("Ref"     , Object.Ref);
	FormParameters.Insert("Date"    , Object.Date);
	
	ArrayOfSelectedRows = New Array();
	For Each Row In Object.RevenueList Do
		SelectedRow = New Structure();
		SelectedRow.Insert("RowID", Row.RowID);
		SelectedRow.Insert("Basis", Row.Basis);
		ArrayOfSelectedRows.Add(SelectedRow);
	EndDo;
	FormParameters.Insert("SelectedRows", ArrayOfSelectedRows);
	
	OpenForm("Document.AdditionalRevenueAllocation.Form.FormSelectRevenueRows",
		FormParameters,
		Item,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure RevenueRowsBeforeAddRowEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ThisObject.Modified = True;
	// Add new rows
	For Each ResultRow In Result.SelectedRows Do
		If Object.RevenueList.FindRows(New Structure("RowID, Basis", ResultRow.RowID, ResultRow.Basis)).Count() Then
			Continue;
		EndIf;
		NewRow = Object.RevenueList.Add();
		FillPropertyValues(NewRow, ResultRow);
	EndDo;
	
	// Remove unused rows from Revenue list
	ArrayForDelete = New Array();
	For Each Row In Object.RevenueList Do
		If DocumentsClientServer.FindRowInArrayOfStructures(Result.SelectedRows, "RowID, Basis", 
			Row.RowID, Row.Basis) = Undefined Then
				ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.RevenueList.Delete(ItemForDelete);
	EndDo;
	
	// Remove unused rows from Allocation list
	ArrayForDelete = New Array();
	For Each Row In Object.AllocationList Do
		If DocumentsClientServer.FindRowInArrayOfStructures(Result.SelectedRows, "RowID", 
			Row.BasisRowID) = Undefined Then
				ArrayForDelete.Add(Row);
		EndIf;		
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AllocationList.Delete(ItemForDelete);
	EndDo;
	
	RefreshRowsAllocationTreesAtClient();
EndProcedure

&AtClient
Procedure AllocationRowsBeforeAddRowEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	ThisObject.Modified = True;
	
	// Add new rows
	For Each ResultRow In Result.SelectedRows Do
		If Object.AllocationList.FindRows(New Structure("BasisRowID, RowID, Document", 
			ResultRow.BasisRowID, ResultRow.RowID, ResultRow.Document)).Count() Then
			Continue;
		EndIf;
		NewRow = Object.AllocationList.Add();
		FillPropertyValues(NewRow, ResultRow);
	EndDo;
	
	// Remove unused rows from Allocation list
	ArrayForDelete = New Array();
	For Each Row In Object.AllocationList Do
		If Result.BasisRowID <> Row.BasisRowID Then
			Continue;
		EndIf;
		If DocumentsClientServer.FindRowInArrayOfStructures(Result.SelectedRows, "BasisRowID, RowID, Document", 
			Row.BasisRowID, Row.RowID, Row.Document) = Undefined Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AllocationList.Delete(ItemForDelete);
	EndDo;
	
	RefreshRowsAllocationTreesAtClient();
	
	CurrentRow = Undefined;
	For Each Row_TopLevel In ThisObject.RevenueRows.GetItems() Do
		For Each Row_SecondLevel In Row_TopLevel.GetItems() Do
			If Row_SecondLevel.RowID = Result.BasisRowID Then
				CurrentRow = Row_SecondLevel.GetID();
				Break;
			EndIf;
		EndDo;
		If CurrentRow <> Undefined Then
			Break;
		EndIf;
	EndDo;

	If CurrentRow <> Undefined Then
		Items.RevenueRows.CurrentRow = CurrentRow;
	EndIf;
EndProcedure

&AtClient
Procedure AllocateRevenueAmount(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	Result = AllocateRevenueAmountAtServer();
	For Each Row_TopLevel In ThisObject.AllocationRows.GetItems() Do
		For Each Row_SecondLevel In Row_TopLevel.GetItems() Do
			For Each Row In Result.ArrayOfAllocatedAmounts Do
				If Row_SecondLevel.BasisRowID = Row.BasisRowID
				 	And Row_SecondLevel.RowID = Row.RowID Then
						Row_SecondLevel.Amount = Row.Amount;
					Break;
				EndIf;
			EndDo;
		EndDo;
	EndDo;
EndProcedure

&AtServer
Function AllocateRevenueAmountAtServer()
	Result = New Structure("ArrayOfAllocatedAmounts", New Array());
	AllocationListTable = Object.AllocationList.Unload();
	For Each Row_RevenueList In Object.RevenueList Do
		BatchKeyInfoTable = GetBatchKeyInfo(AllocationListTable.Copy(New Structure("BasisRowID", Row_RevenueList.RowID)));
		Total = 0;
		ColumnName = "";
		If Object.AllocationMethod = Enums.AllocationMethod.ByAmount Then
			ColumnName = "Amount";
		ElsIf Object.AllocationMethod = Enums.AllocationMethod.ByQuantity Then
			ColumnName = "Quantity";
		ElsIf Object.AllocationMethod = Enums.AllocationMethod.ByWeight Then
			ColumnName = "Weight";
		EndIf;
	
		Total = BatchKeyInfoTable.Total(ColumnName);
	
		If Total = 0 Then
			Continue;
		EndIf;
		
		TotalAllocated = 0;
		MaxRow = Undefined;
	
		For Each Row_BatchKeyInfo In BatchKeyInfoTable Do
			Amount = (Row_RevenueList.Amount / Total) * Row_BatchKeyInfo[ColumnName];
			Amount = Round(Amount, 2 , RoundMode.Round15as10);
			TotalAllocated = TotalAllocated + Amount;
			
			AllocatedAmount = New Structure("BasisRowID, RowID, Amount", Row_RevenueList.RowID, Row_BatchKeyInfo.RowID, Amount);
			Result.ArrayOfAllocatedAmounts.Add(AllocatedAmount);
			
			AllocationListRows = Object.AllocationList.FindRows(New Structure("BasisRowID, RowID", Row_RevenueList.RowID, Row_BatchKeyInfo.RowID));
			
			If AllocationListRows.Count() Then
				AllocationListRows[0].Amount = Amount;
			
				If MaxRow = Undefined Then
					MaxRow = AllocationListRows[0];
				Else
					If MaxRow.Amount < AllocationListRows[0].Amount Then
						MaxRow = AllocationListRows[0];
					EndIf;
				EndIf;
				
			EndIf;
			
		EndDo;
		
		If Row_RevenueList.Amount <> TotalAllocated And MaxRow <> Undefined Then
			MaxRow.Amount = MaxRow.Amount + (Row_RevenueList.Amount - TotalAllocated);
			For Each Row In Result.ArrayOfAllocatedAmounts Do
				If Row.BasisRowID = MaxRow.BasisRowID And Row.RowID = MaxRow.RowID Then
					Row.Amount = MaxRow.Amount;
					Break;
				EndIf;
			EndDo;
		EndIf;
		
	EndDo;
	Return Result;
EndFunction

&AtServerNoContext
Function GetBatchKeyInfo(FilterTable)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	FilterTable.RowID,
	|	FilterTable.Document,
	|	FilterTable.Store,
	|	FilterTable.ItemKey
	|INTO FilterTable
	|FROM
	|	&FilterTable AS FilterTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	FilterTable.RowID,
	|	FilterTable.Document,
	|	FilterTable.ItemKey,
	|	FilterTable.Store,
	|	SUM(T6020S_BatchKeysInfo.Amount) AS Amount,
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(CASE
	|		WHEN T6020S_BatchKeysInfo.ItemKey.Weight <> 0
	|			THEN T6020S_BatchKeysInfo.ItemKey.Weight
	|		ELSE T6020S_BatchKeysInfo.ItemKey.Item.Weight
	|	END) AS Weight
	|FROM
	|	FilterTable AS FilterTable
	|		INNER JOIN InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		ON FilterTable.Document = T6020S_BatchKeysInfo.Recorder
	|		AND FilterTable.Store = T6020S_BatchKeysInfo.Store
	|		AND FilterTable.ItemKey = T6020S_BatchKeysInfo.ItemKey
	|GROUP BY
	|	FilterTable.Document,
	|	FilterTable.ItemKey,
	|	FilterTable.RowID,
	|	FilterTable.Store";
	Query.SetParameter("FilterTable", FilterTable);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

&AtClient
Procedure RevenueDocumentsDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	CurrentData = ThisObject.Items.RevenueDocuments.CurrentData;
	If CurrentData <> Undefined Then
		CurrentData.Document = Result.Document;
		CurrentData.Currency = Result.Currency;
		CurrentData.Amount   = Result.Amount;
	EndIf;
EndProcedure

&AtClient
Procedure RevenueDocumentsAfterDeleteRow(Item)
	ArrayForDelete = New Array();
	For Each Row In Object.AllocationDocuments Do
		If Not Object.RevenueDocuments.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;	
	For Each Row In ArrayForDelete Do
		Object.AllocationDocuments.Delete(Row);
	EndDo;
EndProcedure

&AtClient
Procedure RevenueDocumentsOnActivateRow(Item)
	SetVisibilityAllocations();
EndProcedure

&AtClient
Procedure AllocationDocumentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	CurrentData = Items.RevenueDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	NewRow = Object.AllocationDocuments.Add();
	NewRow.Key = CurrentData.Key;
	NewRow.Visible = True;
	Items.AllocationDocuments.CurrentRow = NewRow.GetID();
EndProcedure

&AtClient
Procedure AllocationDocumentsDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	Notify = New NotifyDescription("AllocationDocumentsDocumentStartChoiceEnd", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company" , Object.Company);

	OpenForm("Document.AdditionalRevenueAllocation.Form.FormSelectAllocationDocument",
		FormParameters,
		Item,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AllocationDocumentsDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	CurrentData = ThisObject.Items.AllocationDocuments.CurrentData;
	If CurrentData <> Undefined Then
		CurrentData.Document = Result.Document;
	EndIf;
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocAdditionalRevenueAllocationClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocAdditionalRevenueAllocationClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocAdditionalRevenueAllocationClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocAdditionalRevenueAllocationClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocAdditionalRevenueAllocationClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocAdditionalRevenueAllocationClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocAdditionalRevenueAllocationClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocAdditionalRevenueAllocationClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

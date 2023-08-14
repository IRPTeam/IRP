
&AtClient
Procedure FillDocuments(Command)
	DocumentList.Clear();
	FillDocumentsAtServer();
EndProcedure

&AtServer
Procedure FillDocumentsAtServer()
	QueryTxt =  
	"SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref) AS DocumentType
	|INTO AllDocuments
	|FROM
	|	Document.RetailSalesReceipt AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.GoodsReceipt AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.Bundling AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.InternalSupplyRequest AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.InventoryTransfer AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.InventoryTransferOrder AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.ItemStockAdjustment AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.PhysicalCountByLocation AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.PhysicalInventory AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.PurchaseInvoice AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.PurchaseOrder AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.PurchaseReturn AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.PurchaseReturnOrder AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.RetailReturnReceipt AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.SalesInvoice AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.SalesOrder AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.SalesReportFromTradeAgent AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.SalesReportToConsignor AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.SalesReturn AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.SalesReturnOrder AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.ShipmentConfirmation AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.StockAdjustmentAsSurplus AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.StockAdjustmentAsWriteOff AS Doc
	|
	|UNION
	|
	|SELECT
	|	Doc.Ref,
	|	VALUETYPE(Doc.Ref)
	|FROM
	|	Document.Unbundling AS Doc
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDocuments.Ref.Date AS Date,
	|	AllDocuments.Ref,
	|	AllDocuments.DocumentType,
	|	CASE
	|		WHEN AllDocuments.Ref.Posted
	|			THEN 0
	|		WHEN AllDocuments.Ref.DeletionMark
	|			THEN 1
	|		ELSE 2
	|	END AS Picture
	|FROM
	|	AllDocuments AS AllDocuments
	|WHERE
	|	AllDocuments.Ref.Date BETWEEN &StartDate AND &EndDate
	|
	|ORDER BY
	|	AllDocuments.Ref.Date";
	
	Query = New Query(QueryTxt);
	Query.SetParameter("StartDate", Period.StartDate);
	Query.SetParameter("EndDate", Period.EndDate);
	Result = Query.Execute().Unload();
	
	DocumentList.Load(Result);
EndProcedure

&AtClient
Procedure CheckDocuments(Command)
	ThisObject.ErrorsGroups.Clear();
	CheckList.GetItems().Clear();
	CheckDocumentsAtServer();
	Items.PagesDocuments.CurrentPage = Items.PageCheck;
EndProcedure

&AtServer
Procedure CheckDocumentsAtServer()
	
	DocumentErrors = New Array;
	ErrorsGroupsTable = ThisObject.ErrorsGroups.Unload();
	CheckListTree = FormAttributeToValue("CheckList");
	
	TypesTable = ThisObject.DocumentList.Unload(, "DocumentType");
	TypesTable.GroupBy("DocumentType");
	For Each TypeItem In TypesTable Do
		 DocumentsRows = DocumentList.FindRows(New Structure("DocumentType", TypeItem.DocumentType));
		 DocumentTable = DocumentList.Unload(DocumentsRows, "Ref, Date, Picture");
		 ErrorsTree = AdditionalDocumentTableControl.CheckDocumentArray(DocumentTable.UnloadColumn("Ref"));
		 
		 For Each DocRow In ErrorsTree.Rows Do
			ParentRow = CheckListTree.Rows.Add();
			ParentRow.Ref = DocRow.Ref;
			ParentRow.LineNumber = DocRow.Rows.Count();
			DocumentRow = DocumentTable.Find(DocRow.Ref);
			ParentRow.Date = DocumentRow.Date;
			ParentRow.Picture = DocumentRow.Picture;
			DocumentErrors.Clear();
			
			For Each ErrorRow In DocRow.Rows Do
				NewRow = ParentRow.Rows.Add();
				FillPropertyValues(NewRow, ErrorRow.Error);
				NewRow.Date = ParentRow.Date;
				NewRow.Picture = ParentRow.Picture;
				
				ErrorRecord = ErrorsGroupsTable.Find(NewRow.ErrorID, "ErrorID");
				If ErrorRecord = Undefined Then
					ErrorRecord = ErrorsGroupsTable.Add();
					ErrorRecord.ErrorID = NewRow.ErrorID;
				EndIf;
				
				ErrorRecord.Cases = ErrorRecord.Cases + 1;
				
				If DocumentErrors.Find(ErrorRecord.ErrorID) = Undefined Then
					DocumentErrors.Add(ErrorRecord.ErrorID);
					ErrorRecord.Documents = ErrorRecord.Documents + 1; 
				EndIf;
			EndDo;
		 EndDo;
	EndDo;
	
	ThisObject.ErrorsGroups.Load(ErrorsGroupsTable);
	
	CheckListTree.Rows.Sort("Date, Ref, ErrorID, LineNumber", True);
	ValueToFormAttribute(CheckListTree, "CheckList");
EndProcedure

&AtClient
Procedure QuickFixError(Command)
	CurrentErrorRow = Items.ErrorsGroups.CurrentRow;
	If CurrentErrorRow = Undefined Then
		Return;
	EndIf;

	ErrorRecord = ThisObject.ErrorsGroups.FindByID(CurrentErrorRow);
	ErrorID = ErrorRecord.ErrorID;
	
	Map = New Map;
	For Each DocumentRow In ThisObject.CheckList.GetItems() Do
		For Each ErrorRow In DocumentRow.GetItems() Do
			If ErrorRow.Fixed OR ErrorRow.ErrorID <> ErrorID Then
				Continue;
			EndIf;
			DocRefErrors = Map.Get(ErrorRow.Ref);
			If DocRefErrors = Undefined Then
				DocRefErrors = New Structure;
				DocRefErrors.Insert(ErrorID, New Structure("Result, RowKey", New Array, New Array));
				Map.Insert(ErrorRow.Ref, DocRefErrors);
			EndIf;
			DocRefErrors[ErrorID].RowKey.Add(ErrorRow.RowKey);
		EndDo;
	EndDo;
	
	RunQuickFixLoop(Map);
	
	ErrorRecord.Fixed = True;
EndProcedure

&AtClient
Procedure QuickFix(Command)
	Map = New Map;
	For Each RowID In Items.CheckList.SelectedRows Do
		
		Row = CheckList.FindByID(RowID);
		
		If Row.Fixed Then
			Continue;
		EndIf;
		
		DocRefErrors = Map.Get(Row.Ref);
		If DocRefErrors = Undefined Then
			Map.Insert(Row.Ref, New Structure);
			DocRefErrors = Map.Get(Row.Ref);
		EndIf;
		
		If Not DocRefErrors.Property(Row.ErrorID) Then
			DocRefErrors.Insert(Row.ErrorID, New Structure("Result, RowKey", New Array, New Array));
		EndIf;
		
		DocRefErrors[Row.ErrorID].RowKey.Add(Row.RowKey);
	EndDo;
	
	RunQuickFixLoop(Map);
EndProcedure

&AtClient
Procedure RunQuickFixLoop(Map)
	TotalDocument = Map.Count();
	While True Do
		CurrentDoc = New Map;
		For Each Doc In Map Do
			CurrentDoc.Insert(Doc.Key, Doc.Value);
			Map.Delete(Doc.Key);
			
			If CurrentDoc.Count() > Int(TotalDocument / 100) Then
				Break;
			EndIf;
		EndDo;
		
		If CurrentDoc.Count() = 0 Then
			Break;
		EndIf;
		
		UserInterruptProcessing();
		Status("Quick fix. Left: " + Map.Count(), 100 * (TotalDocument - Map.Count()) / TotalDocument, Doc.Key);
		
		Result = QuickFixAtServer(CurrentDoc);
		SetFlagFixed(Result);
	EndDo;
	ShowMessageBox(, R().InfoMessage_005);
EndProcedure

&AtServerNoContext
Function QuickFixAtServer(Val CurrentDoc)
	For Each Doc In CurrentDoc Do
		For Each Error In Doc.Value Do
			Try
				Error.Value.Result = AdditionalDocumentTableControl.QuickFix(Doc.Key, Error.Value.RowKey, Error.Key);
			Except
				Errors = "Errors in " + Doc.Key + Chars.LF + ErrorProcessing.BriefErrorDescription(ErrorInfo());
				CommonFunctionsClientServer.ShowUsersMessage(Errors);
				Error.Value.Result.Add(Errors);
			EndTry;
		EndDo;
	EndDo;
	Return CurrentDoc;
EndFunction

&AtClient
Procedure SetFlagFixed(DocsData)
	For Each DocumentData In DocsData Do
		For Each ErrorRow In DocumentData.Value Do
			If ErrorRow.Value.Result.Count() = 0 Then
				FixedArray = New Array;
				For Each RowKeyValue In ErrorRow.Value.RowKey Do
					FixedArray.Add(RowKeyValue);
				EndDo;
				If FixedArray.Count() = 0 Then
					Continue;
				EndIf;
				
				For Each CheckRow In ThisObject.CheckList.GetItems() Do
					If CheckRow.Ref = DocumentData.Key Then
						AllFixed = True;
						For Each CheckSubRow In CheckRow.GetItems() Do
							If CheckSubRow.ErrorID = ErrorRow.Key And FixedArray.Find(CheckSubRow.RowKey) <> Undefined Then
								CheckSubRow.Fixed = True;
							EndIf;
							AllFixed = AllFixed And CheckSubRow.Fixed;
						EndDo;
						CheckRow.Fixed = AllFixed;
						Break;
					EndIf;
				EndDo;
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure DocumentListRefOnChange(Item)
	CurrentData = Items.DocumentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	ElsIf Not ValueIsFilled(CurrentData.Ref) Then
		CurrentData.DocumentType = "";
	Else
		CurrentData.DocumentType = TypeOf(CurrentData.Ref);
	EndIf;
EndProcedure

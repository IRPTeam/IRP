
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
	|	AllDocuments.DocumentType
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
	CheckList.GetItems().Clear();
	CheckDocumentsAtServer();
	Items.PagesDocuments.CurrentPage = Items.PageCheck;
EndProcedure

&AtServer
Procedure CheckDocumentsAtServer()
	TypesTable = ThisObject.DocumentList.Unload(, "DocumentType");
	TypesTable.GroupBy("DocumentType");
	For Each TypeItem In TypesTable Do
		 DocumentsRows = DocumentList.FindRows(New Structure("DocumentType", TypeItem.DocumentType));
		 DocumentTable = DocumentList.Unload(DocumentsRows, "Ref, Date");
		 ErrorsTree = AdditionalDocumentTableControl.CheckDocumentArray(DocumentTable.UnloadColumn("Ref"));
		 For Each DocRow In ErrorsTree.Rows Do
			ParentRow = CheckList.GetItems().Add();
			ParentRow.Ref = DocRow.Ref;
			ParentRow.LineNumber = DocRow.Rows.Count();
			ParentRow.Date = DocumentTable.Find(DocRow.Ref).Date;
			For Each ErrorRow In DocRow.Rows Do
				NewRow = ParentRow.GetItems().Add();
				FillPropertyValues(NewRow, ErrorRow.Error);
				NewRow.Date = ParentRow.Date;
			EndDo;
		 EndDo;
	EndDo;	
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
		
	EndDo;
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

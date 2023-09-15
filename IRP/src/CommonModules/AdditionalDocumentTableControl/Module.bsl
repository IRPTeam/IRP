
// @strict-types

// Check document.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocument -
//  ListOfErrors - Array of String, String, Undefined - 
//  DetailResult - Array of String -
// 
// Returns:
//  Array of See DetailResult
Function CheckDocument(Document, ListOfErrors = Undefined, DetailResult = False) Export
	DocType = TypeOf(Document);
	DocName = Document.Metadata().Name;
	If Not Metadata.DefinedTypes.AdditionalTableControlDocument.Type.ContainsType(DocType) Then
		//@skip-check invocation-parameter-type-intersect, property-return-type
		Raise StrTemplate(R().ATC_001, DocType); // Unknown document type
	EndIf;
	
	If ListOfErrors = Undefined Then
		ArrayOfErrors = New Array;
	ElsIf TypeOf(ListOfErrors) = Type("String") Then
		ArrayOfErrors = New Array; // Array of String
		ArrayOfErrors.Add(ListOfErrors);    
	Else
		ArrayOfErrors = ListOfErrors;
	EndIf;
	Result = AdditionalTableControl(Document, DocName, ArrayOfErrors);
	
	If DetailResult Then
		Return Result.DetailErrors;
	Else
		Return Result.Errors;
	EndIf;
	
EndFunction

// Check document array.
// 
// Parameters:
//  DocumentArray - Array of DefinedType.AdditionalTableControlDocument - Document array
// 
// Returns:
//  ValueTree - Check document array:
// * Ref - DefinedType.AdditionalTableControlDocument
// * Error - See DetailResult
Function CheckDocumentArray(DocumentArray) Export
	
	Result = New ValueTree();
	Result.Columns.Add("Ref", Metadata.DefinedTypes.AdditionalTableControlDocument.Type);
	Result.Columns.Add("Error");
	
	If DocumentArray.Count() = 0 Then
		Return Result;
	EndIf;
	
	DocType = TypeOf(DocumentArray[0]);
	If Not Metadata.DefinedTypes.AdditionalTableControlDocument.Type.ContainsType(DocType) Then
		//@skip-check invocation-parameter-type-intersect, property-return-type
		Raise StrTemplate(R().ATC_001, DocType); // Unknown document type
	EndIf;
	
	AdditionalTableControlForDocumentArray(DocumentArray, Result);
	
	Return Result;
	
EndFunction

// Get error list.
// 
// Returns:
//  ValueList
Function GetErrorList() Export
	Return AdditionalDocumentTableControlReuse.GetErrorList();
EndFunction

// Additional table control.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocument - Document
//  DocName - String - Doc name
//  ArrayOfErrors - Array of String - Array of errors
// 
// Returns:
//  Structure - Additional table control:
// * Errors - Array -
// * DetailErrors - Array of See DetailResult
Function AdditionalTableControl(Document, DocName, ArrayOfErrors)
	
	Exceptions = Constants.AdditionalTableControlExceptions.GetData();
	Result = CheckDocumentsResult(Document, DocName);
	
	Errors = New Array; // Array of String
	DetailErrors = New Array; //Array of See DetailResult
	For Each Query In Result Do
		QueryResult = Query.Unload(); // See Document.SalesInvoice.ItemList
		For Each Row In QueryResult Do 
			For Each Column In QueryResult.Columns Do
				If StrStartsWith(Column.Name, "Error") Then
					
					If ArrayOfErrors.Count() > 0 And Not ArrayOfErrors.Find(Column.Name) = Undefined Then
						Continue;
					EndIf;
					
					If Not Exceptions.Find(Column.Name) = Undefined Then
						Continue;
					EndIf;
					
					If Row[Column.Name] = True Then // Can be NULL
						Str = DetailResult();
						Str.Ref = Document;
						Str.ErrorID = Column.Name;
						Str.LineNumber = Row.LineNumber;
						Str.RowKey = Row.Key;
						DetailErrors.Add(Str);
						
						//	@skip-check invocation-parameter-type-intersect, property-return-type
						If Row.LineNumber > 0 Then
							Errors.Add(StrTemplate(R()["ATC_" + Column.Name], Row.LineNumber));
						Else
							Errors.Add(R()["ATC_" + Column.Name]);
						EndIf;
					EndIf;
				EndIf;
			EndDo;
		EndDo;
	EndDo;
	
	ResultErrors = New Structure();
	ResultErrors.Insert("Errors", Errors);
	ResultErrors.Insert("DetailErrors", DetailErrors);
	Return ResultErrors;
	
EndFunction

// Additional table control for document array.
// 
// Parameters:
//  DocumentArray - Array of DefinedType.AdditionalTableControlDocument - Document array
//  DocName - String - Doc name
//  Result - See CheckDocumentArray
Procedure AdditionalTableControlForDocumentArray(DocumentArray, Result)
	RefRowsCash = New Map;
	CheckResult = CheckResultForDocumentArray(DocumentArray);
	For Each Query In CheckResult Do
		QueryResult = Query.Unload();
		If QueryResult.Columns.Count() = 1 Then
			Continue;
		EndIf;
		//@skip-check property-return-type, statement-type-change
		For Each Row In QueryResult Do
			RefRow = RefRowsCash.Get(Row.Ref);
			If RefRow = Undefined Then
				RefRow = Result.Rows.Add();
				RefRow.Ref = Row.Ref;
				RefRowsCash.Insert(Row.Ref, RefRow);
			EndIf; 
			For Each Column In QueryResult.Columns Do
				If StrStartsWith(Column.Name, "Error") Then
					If Row[Column.Name] = True Then // Can be NULL
						DetailError = DetailResult();
						DetailError.Ref = RefRow.Ref;
						DetailError.LineNumber = Row.LineNumber;
						DetailError.RowKey = Row.Key;
						DetailError.ErrorID = Column.Name;
						
						ErrorRow = RefRow.Rows.Add();
						ErrorRow.Ref = RefRow.Ref;
						ErrorRow.Error = DetailError;
					EndIf;
				EndIf;
			EndDo;
		EndDo;
	EndDo;
EndProcedure

// Detail result.
// 
// Returns:
//  Structure - Detail result:
// * Ref - Undefined -
// * ErrorID - String -
// * RowKey - String -
// * LineNumber - Number -
Function DetailResult()
	Str = New Structure();
	Str.Insert("Ref", Undefined);
	Str.Insert("ErrorID", "");
	Str.Insert("RowKey", "");
	Str.Insert("LineNumber", 0);
	Return Str;
EndFunction

// Check documents result.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocument -
//  DocName - String -
//
// Returns:
//  Array Of QueryResult
Function CheckDocumentsResult(Document, DocName)
	Result = AdditionalDocumentTableControlReuse.GetQuery(DocName);
	
	Query = New Query(Result.Query);
	Query.SetParameter("Headers", GetHeaderTable(Document));
	Query.SetParameter("ItemList", Document.ItemList.Unload());
	
	If Result.Tables.RowIDInfo = Undefined Then
		Query.SetParameter("RowIDInfo", Document.RowIDInfo.Unload());
	Else
		Query.SetParameter("RowIDInfo", Result.Tables.RowIDInfo);
	EndIf;
		
	If Result.Tables.SpecialOffers = Undefined Then
		Query.SetParameter("SpecialOffers", Document.SpecialOffers.Unload());
	Else
		Query.SetParameter("SpecialOffers", Result.Tables.SpecialOffers);
	EndIf;
		
	If Result.Tables.SerialLotNumbers = Undefined Then
		Query.SetParameter("SerialLotNumbers", Document.SerialLotNumbers.Unload());
	Else
		Query.SetParameter("SerialLotNumbers", Result.Tables.SerialLotNumbers);
	EndIf;
	
	If Result.Tables.SourceOfOrigins = Undefined Then
		Query.SetParameter("SourceOfOrigins", Document.SourceOfOrigins.Unload());
	Else
		Query.SetParameter("SourceOfOrigins", Result.Tables.SourceOfOrigins);
	EndIf;
	
	If Result.Tables.Payments = Undefined Then
		Query.SetParameter("Payments", Document.Payments.Unload());
	Else
		Query.SetParameter("Payments", Result.Tables.Payments);
	EndIf;
	
  	Return Query.ExecuteBatch();
EndFunction

Function CheckResultForDocumentArray(DocumentArray)
	Query = New Query;
	Query.SetParameter("Refs", DocumentArray);
	Query.Text = AdditionalDocumentTableControlReuse.GetQueryForDocumentArray(DocumentArray[0].Metadata().Name);
 	Return Query.ExecuteBatch();
EndFunction

// Get header table.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocument -  Document
// 
// Returns:
//  ValueTable -  Get header table
Function GetHeaderTable(Document)
	
	Header = New ValueTable();
	DocumentMetadata = Document.Metadata(); // MetadataObjectDocument
	
	For Each AttributeDescription In DocumentMetadata.StandardAttributes Do
		Header.Columns.Add(AttributeDescription.Name, AttributeDescription.Type, AttributeDescription.Synonym);
	EndDo;
	For Each AttributeDescription In DocumentMetadata.Attributes Do
		Header.Columns.Add(AttributeDescription.Name, AttributeDescription.Type, AttributeDescription.Synonym);
	EndDo;
	For Each AttributeDescription In Metadata.CommonAttributes Do
		If Not AttributeDescription.Content.Find(DocumentMetadata) = Undefined 
				AND AttributeDescription.Content.Find(DocumentMetadata).Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
			Header.Columns.Add(AttributeDescription.Name, AttributeDescription.Type, AttributeDescription.Synonym);
		EndIf;
	EndDo;
	
	DocumentRecord = Header.Add();
	FillPropertyValues(DocumentRecord, Document);
	
	Return Header;
	
EndFunction

#Region EventHandler

// Fill check processing additional table control document fill check processing.
// 
// Parameters:
//  Source - DefinedType.AdditionalTableControlDocument - Source
//  Cancel - Boolean -  Cancel
//  CheckedAttributes - Array of String -  Checked attributes
Procedure FillCheckProcessing_AdditionalTableControlDocumentFillCheckProcessing(Source, Cancel, CheckedAttributes) Export
	
	If Not FOServer.isUseAdditionalTableControlDocument() Then
		Return;
	EndIf;
	
	Result = CheckDocument(Source, New Array);
	If Result.Count() = 0 Then
		Return;
	EndIf;
	Cancel = True;
	
	//@skip-check property-return-type, invocation-parameter-type-intersect
	CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_009, Source));
	For Each ResultItem In Result Do
		CommonFunctionsClientServer.ShowUsersMessage(ResultItem);
	EndDo;
	
EndProcedure

#EndRegion

#Region QuickFix

// Quick fix.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array of String - Row IDList
//  ErrorID - String - Error ID
// 
// Returns:
//  Array of String - Array of errors
Function QuickFix(Document, RowIDList, ErrorID) Export
	SetSafeMode(True);
	Result = Eval(ErrorID + "(Document, RowIDList)");
	Return Result;
EndFunction

// Error net amount greater total amount.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorNetAmountGreaterTotalAmount(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error quantity is zero.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorQuantityIsZero(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error quantity in base unit is zero.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorQuantityInBaseUnitIsZero(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error offers amount in item list not equal offers amount in offers list.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error item type is not service.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorItemTypeIsNotService(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error item type use serial numbers.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorItemTypeUseSerialNumbers(Document, RowIDList)
	Result = New Array; // Array of String
	If RowIDList.Count() = 0 Then
		Return Result;
	EndIf;
	
	DocObject = Document.GetObject(); // DocumentObject.SalesInvoice
	
	For Each RowKey In RowIDList Do
		Row = DocObject.ItemList.FindRows(New Structure("Key", RowKey));
		Row[0].UseSerialLotNumber = True;
	EndDo;
	
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	
	Return Result;
EndFunction

// Error item type doesn't use serial numbers.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorItemTypeNotUseSerialNumbers(Document, RowIDList)
	Result = New Array; // Array of String
	If RowIDList.Count() = 0 Then
		Return Result;
	EndIf;
	
	DocObject = Document.GetObject(); // DocumentObject.SalesInvoice
	
	For Each RowKey In RowIDList Do
		Row = DocObject.ItemList.FindRows(New Structure("Key", RowKey));
		Row[0].UseSerialLotNumber = False;
	EndDo;
	
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	
	Return Result;
EndFunction

// Error use serial but serial not set.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorUseSerialButSerialNotSet(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error not the same quantity in serial list table and in item list.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorNotTheSameQuantityInSerialListTableAndInItemList(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error item not equal item in item key.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorItemNotEqualItemInItemKey(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error total amount minus net amount not equal tax amount.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorTotalAmountMinusNetAmountNotEqualTaxAmount(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error quantity in item list not equal quantity in row ID.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorQuantityInItemListNotEqualQuantityInRowID(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error quantity not equal quantity in base unit.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorQuantityNotEqualQuantityInBaseUnit(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error not filled quantity in source of origins.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorNotFilledQuantityInSourceOfOrigins(Document, RowIDList)
	Result = New Array; // Array of String
	If RowIDList.Count() = 0 Then
		Return Result;
	EndIf;
	
	DocObject = Document.GetObject(); // DocumentObject.SalesInvoice
	
	For Each RowKey In RowIDList Do
		RowItemList = DocObject.ItemList.FindRows(New Structure("Key", RowKey));
		RowSerialLotNumbers = DocObject.SerialLotNumbers.FindRows(New Structure("Key", RowKey));
		If RowSerialLotNumbers.Count() = 0 Then
			Rows = DocObject.SourceOfOrigins.FindRows(New Structure("Key", RowKey));
			If Not Rows.Count() = 0 Then
				Rows[0].Quantity = RowItemList[0].Quantity;
			Else
				NewRow = DocObject.SourceOfOrigins.Add();
				NewRow.Key = RowKey;
				NewRow.Quantity = RowItemList[0].Quantity;
			EndIf;
		Else
			For Each SerialRow In RowSerialLotNumbers Do
				Rows = DocObject.SourceOfOrigins.FindRows(New Structure("Key, SerialLotNumber", RowKey, SerialRow.SerialLotNumber));
				If Not Rows.Count() = 0 Then
					Rows[0].Quantity = SerialRow.Quantity;
				Else
					NewRow = DocObject.SourceOfOrigins.Add();
					NewRow.Key = RowKey;
					NewRow.SerialLotNumber = SerialRow.SerialLotNumber;
					NewRow.Quantity = SerialRow.Quantity;
				EndIf;
			EndDo;
		EndIf;
	EndDo;
	
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	
	Return Result;
EndFunction

// Error quantity in source of origins diff quantity in serial lot number.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorQuantityInSourceOfOriginsDiffQuantityInSerialLotNumber(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error quantity in source of origins diff quantity in item list.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorQuantityInSourceOfOriginsDiffQuantityInItemList(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

// Error not fillen unit.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorNotFilledUnit(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add(R().ATC_NotSupported);
	Return Result;
EndFunction

Function ErrorNotFilledInventoryOrigin(Document, RowIDList)
	Result = New Array; // Array of String
	If RowIDList.Count() = 0 Then
		Return Result;
	EndIf;
	
	DocObject = Document.GetObject(); // DocumentObject.SalesInvoice
	
	For Each RowKey In RowIDList Do
		RowsItemList = DocObject.ItemList.FindRows(New Structure("Key", RowKey));
		For Each RowItemList In RowsItemList Do
			RowItemList.InventoryOrigin = Enums.InventoryOriginTypes.OwnStocks;
		EndDo;
	EndDo;
	
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	
	Return Result;
EndFunction

Function ErrorNotFilledPaymentMethod(Document, RowIDList)
	Result = New Array; // Array of String
	DocObject = Document.GetObject(); // DocumentObject.RetailSalesReceipt
	DocObject.PaymentMethod = Enums.ReceiptPaymentMethods.FullCalculation;
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	Return Result;
EndFunction

Function ErrorNotFilledPurchaseTransactionType(Document, RowIDList)
	Result = New Array; // Array of String
	DocObject = Document.GetObject(); // DocumentObject.PurchaseInvoice
	DocObject.TransactionType = Enums.PurchaseTransactionTypes.Purchase;
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	Return Result;
EndFunction

Function ErrorNotFilledSalesTransactionType(Document, RowIDList)
	Result = New Array; // Array of String
	DocObject = Document.GetObject(); // DocumentObject.SalesInvoice
	DocObject.TransactionType = Enums.SalesTransactionTypes.Sales;
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	Return Result;
EndFunction

Function ErrorNotFilledSalesReturnTransactionType(Document, RowIDList)
	Result = New Array; // Array of String
	DocObject = Document.GetObject(); // DocumentObject.SalesReturn
	DocObject.TransactionType = Enums.SalesReturnTransactionTypes.ReturnFromCustomer;
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	Return Result;
EndFunction

Function ErrorNotFilledPurchaseReturnTransactionType(Document, RowIDList)
	Result = New Array; // Array of String
	DocObject = Document.GetObject(); // DocumentObject.PurchaseReturn
	DocObject.TransactionType = Enums.PurchaseReturnTransactionTypes.ReturnToVendor;
	If DocObject.Posted Then
		DocObject.Write(DocumentWriteMode.Posting);
	Else
		DocObject.Write(DocumentWriteMode.Write);
	EndIf;
	Return Result;
EndFunction

#EndRegion

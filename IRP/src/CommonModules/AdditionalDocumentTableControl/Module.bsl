
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
					
					If Row[Column.Name] = True Then // Can be NULL
						Str = DetailResult();
						Str.Ref = Document;
						Str.ErrorID = Column.Name;
						Str.LineNumber = Row.LineNumber;
						Str.RowKey = Row.Key;
						DetailErrors.Add(Str);
						
						//	@skip-check invocation-parameter-type-intersect, property-return-type
						Errors.Add(StrTemplate(R()["ATC_" + Column.Name], Row.LineNumber));
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
	Query.SetParameter("ItemList", Document.ItemList.Unload());
	
	If Result.Tables.RowIDInfo = Undefined Then
		Query.SetParameter("RowIDInfo", Document.RowIDInfo.Unload());
	Else
		Query.SetParameter("RowIDInfo", Result.Tables.RowIDInfo);
	EndIf;
	
	If Result.Tables.TaxList = Undefined Then
		Query.SetParameter("TaxList", Document.TaxList.Unload());
	Else
		Query.SetParameter("TaxList", Result.Tables.TaxList);
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
	
  	Return Query.ExecuteBatch();
EndFunction

#Region EventHandler

// Before write additional table control document before write.
// 
// Parameters:
//  Source - DefinedType.AdditionalTableControlDocument - Source
//  Cancel - Boolean - Cancel
//  WriteMode - DocumentWriteMode - Write mode
//  PostingMode - DocumentPostingMode - Posting mode
Procedure BeforeWrite_AdditionalTableControlDocumentBeforeWrite(Source, Cancel, WriteMode, PostingMode) Export
	If WriteMode = DocumentWriteMode.Posting Then
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
	EndIf;
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

// Error tax amount in item list not equal tax amount in tax list.
// 
// Parameters:
//  Document - DocumentRefDocumentName - Document
//  RowIDList - Array Of String - Row IDList
// 
// Returns:
//  Array of String
//@skip-check module-unused-method
Function ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList(Document, RowIDList)
	Result = New Array; // Array of String
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	
	DocObject.DataExchange.Load = True;
	DocObject.Write();
	
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	Result.Add("Not supported");
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
	
	DocObject.Write(DocumentWriteMode.Posting);
	
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
	Raise "Not supported";
	Result = New Array; // Array of String
	Result.Add("Not supported");
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
	Raise "Not supported";
	Result = New Array; // Array of String
	Result.Add("Not supported");
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
	Raise "Not supported";
	Result = New Array; // Array of String
	Result.Add("Not supported");
	Return Result;
EndFunction

#EndRegion

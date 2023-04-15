// @strict-types

// Check document.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocument -
//  ListOfErrors - Array of String, String, Undefined - 
// 
// Returns:
//  Array of String
Function CheckDocument(Document, ListOfErrors = Undefined) Export
	DocType = TypeOf(Document);
	DocName = Document.Metadata().Name;
	If Not Metadata.DefinedTypes.AdditionalTableControlDocument.Type.ContainsType(DocType) Then
		//@skip-check invocation-parameter-type-intersect, property-return-type
		Raise StrTemplate(R().ATC_001, DocType);
	EndIf;
	
	If ListOfErrors = Undefined Then
		ArrayOfErrors = New Array;
	ElsIf TypeOf(ListOfErrors) = Type("String") Then
		ArrayOfErrors = New Array;
		ArrayOfErrors.Add(ListOfErrors);    
	Else
		ArrayOfErrors = ListOfErrors;
	EndIf;
	
	Return AdditionalTableControl(Document, DocName, ArrayOfErrors);
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
//  Document - DefinedType.AdditionalTableControlDocument -
//  DocName - String -  
//	ArrayOfErrors - Array Of String
//   
// Returns:
//  Array of String
Function AdditionalTableControl(Document, DocName, ArrayOfErrors)
	
	Result = CheckDocumentsResult(Document, DocName);
	Errors = New Array; // Array of String
	For Each Query In Result Do
		QueryResult = Query.Unload(); // ValueTable
		For Each Row In QueryResult Do
			For Each Column In QueryResult.Columns Do
				If StrStartsWith(Column.Name, "Error") Then
					
					If ArrayOfErrors.Count() > 0 And Not ArrayOfErrors.Find(Column.Name) = Undefined Then
						Continue;
					EndIf;
					
					If Row[Column.Name] = True Then // Can be NULL
						//@skip-check invocation-parameter-type-intersect, property-return-type
						Errors.Add(StrTemplate(R()["ATC_" + Column.Name], Row.LineNumber));
					EndIf;
				EndIf;
			EndDo;
		EndDo;
	EndDo;
	
	Return Errors;
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
	Query.SetParameter("RowIDInfo", Document.RowIDInfo.Unload());
	
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

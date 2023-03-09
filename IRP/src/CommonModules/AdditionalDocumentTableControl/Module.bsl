// @strict-types

// Check document.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocObject, DefinedType.AdditionalTableControlDocRef -
// 
// Returns:
//  Array of String
Function CheckDocument(Document) Export
	DocType = TypeOf(Document);
	DocName = Document.Metadata().Name;
	If Metadata.DefinedTypes.AdditionalTableControlDocRef.Type.ContainsType(DocType) Then
	ElsIf Metadata.DefinedTypes.AdditionalTableControlDocObject.Type.ContainsType(DocType) Then
	Else
		Raise StrTemplate(R().ATC_001, DocType);
	EndIf;
	
	Return AdditionalTableControl(Document, DocName);
EndFunction

// Additional table control.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocObject, DefinedType.AdditionalTableControlDocRef -
//  DocName - String -
//   
// Returns:
//  Array of String
Function AdditionalTableControl(Document, DocName)
	
	Result = CheckDocumentsResult(Document, DocName);
	Errors = New Array; // Array of String

	For Each Row In Result Do
		For Each Column In Result.Columns Do
			If StrStartsWith(Column.Name, "Error") Then
				If Row[Column.Name] Then
					Errors.Add(StrTemplate(R()["ATC_" + Column.Name], Row.LineNumber));
				EndIf;
			EndIf;
		EndDo;
	EndDo;
	
	Return Errors;
EndFunction

// Check documents result.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocObject, DefinedType.AdditionalTableControlDocRef -
//  DocName - String -
//
// // Returns:
//  ValueTable - Check documents result:
//	* Key - String
//	* LineNumber - Number
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
	Return Query.Execute().Unload();
EndFunction

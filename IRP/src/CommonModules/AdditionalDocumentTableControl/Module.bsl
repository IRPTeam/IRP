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
		DocManager = Documents[Document.Metadata().Name]; // DocumentManagerDocumentName
	ElsIf Metadata.DefinedTypes.AdditionalTableControlDocObject.Type.ContainsType(DocType) Then
		DocManager = Document; // DocumentManagerDocumentName
	Else
		Raise StrTemplate(R().ATC_001, DocType);
	EndIf;
	
	Tables = TablesStructure();
	// @skip-check dynamic-access-method-not-found, unknown-method-property
	DocManager.SetTablesForAdditionalCheck(Tables, Document);
	Return AdditionalTableControl(Tables, DocName);
EndFunction

// Additional table control.
// 
// Parameters:
//  Tables - See TablesStructure
//  DocName - String -
//   
// Returns:
//  Array of String
Function AdditionalTableControl(Tables, DocName)
	
	Result = CheckDocumentsResult(Tables, DocName);
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
//  Tables - See TablesStructure
//  DocName - String -
//
// // Returns:
//  ValueTable - Check documents result:
//	* Key - String
//	* LineNumber - Number
Function CheckDocumentsResult(Tables, DocName)
	
	Query = AdditionalDocumentTableControlReuse.GetQuery(DocName);
	Query.SetParameter("ItemList", Tables.ItemList);
	Query.SetParameter("RowIDInfo", Tables.RowIDInfo);
	
	If Not Tables.TaxList = Undefined Then
		Query.SetParameter("TaxList", Tables.TaxList);
	EndIf;
	
	If Not Tables.SpecialOffers = Undefined Then
		Query.SetParameter("SpecialOffers", Tables.SpecialOffers);
	EndIf;
		
	If Not Tables.SerialLotNumbers = Undefined Then
		Query.SetParameter("SerialLotNumbers", Tables.SerialLotNumbers);
	EndIf;
	Return Query.Execute().Unload();
EndFunction

// Tables structure.
// 
// Returns:
//  Structure - Tables structure:
// * ItemList - ValueTable -
// * SpecialOffers - ValueTable -
// * TaxList - ValueTable -
// * SerialLotNumbers - ValueTable -
// * RowIDInfo - ValueTable -
Function TablesStructure() Export
	
	Str = New Structure;
	Str.Insert("ItemList", Undefined);
	Str.Insert("SpecialOffers", Undefined);
	Str.Insert("TaxList", Undefined);
	Str.Insert("SerialLotNumbers", Undefined);
	Str.Insert("RowIDInfo", Undefined);
	Return Str;
EndFunction
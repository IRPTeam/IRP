
// @strict-types

#Region AccumulationRegisters

// Fill posting table.
// 
// Parameters:
//  PostingTable - AccountingRegisterRecordSetAccountingRegisterName - Posting table:
//  MetadataObject - MetadataObjectAccumulationRegister -
Procedure FillPostingTable(PostingTable, MetadataObject) Export
	If Not GetFunctionalOption("UseObjectAccess") Then
		Return;
	EndIf;
	
	CalculateAndUpdateAccessKey_AccumulationRegisters(PostingTable, MetadataObject);
EndProcedure

Procedure CalculateAndUpdateAccessKey_AccumulationRegisters(PostingTable, MetadataObject)
	
	For Each Row In PostingTable Do
	
		AccessKeyRef = GetAndCalculatedAccessKey(Row, MetadataObject);
		
		If AccessKeyRef = Undefined Then
			Return;
		EndIf;
		
	EndDo;
	
EndProcedure

// Update access keys Document.
// 
// Parameters:
//  UpdateAll - Boolean - Update all
//  AccumulationRegistersMetadata - MetadataObjectAccumulationRegister - Document metadata
Procedure UpdateAccessKeys_AccumulationRegisters(UpdateAll = False, AccumulationRegistersMetadata = Undefined) Export
	If UpdateAll Then
		Text = 
		"SELECT
		|	Doc.Ref
		|FROM
		|	Document.%1 AS Doc
		|
		|ORDER BY
		|	Doc.Date";
	Else
		Text = 
		"SELECT
		|	Doc.Ref,
		|	T9100A_ObjectAccessMap.ObjectAccessKeys
		|FROM
		|	Document.%1 AS Doc
		|		LEFT JOIN InformationRegister.T9100A_ObjectAccessMap AS T9100A_ObjectAccessMap
		|		ON Doc.Ref = T9100A_ObjectAccessMap.ObjectRef
		|WHERE
		|	T9100A_ObjectAccessMap.ObjectAccessKeys IS NULL
		|
		|ORDER BY
		|	Doc.Date";
	EndIf;             
	
	If AccumulationRegistersMetadata = Undefined Then 
		For Each Doc In Metadata.Documents Do
			Query = New Query(StrTemplate(Text, Doc.Name));
			DocSelect = Query.Execute().Select();
			While DocSelect.Next() Do
				//@skip-check invocation-parameter-type-intersect, property-return-type
				CalculateAndUpdateAccessKey_Document(DocSelect.Ref);
			EndDo;
		EndDo;   
	Else
	    Query = New Query(StrTemplate(Text, AccumulationRegistersMetadata.Name));
		DocSelect = Query.Execute().Select();
		While DocSelect.Next() Do
			//@skip-check invocation-parameter-type-intersect, property-return-type
			CalculateAndUpdateAccessKey_Document(DocSelect.Ref);
		EndDo;
	EndIf;
	
EndProcedure

#EndRegion

#Region Document

Procedure BeforeWrite_ObjectAccessDocument(Source, Cancel, WriteMode, PostingMode) Export
	
	If Cancel Then
		Return;
	EndIf;
	
	If Not GetFunctionalOption("UseObjectAccess") Then
		Return;
	EndIf;
	
	CalculateAndUpdateAccessKey_Document(Source);
	
EndProcedure

Procedure CalculateAndUpdateAccessKey_Document(Source)
	AccessKeyRef = GetAndCalculatedAccessKey(Source, Source.Metadata());
	
	If AccessKeyRef = Undefined Then
		Return;
	EndIf;
	
	// If not set ref, then can not use RLS on create or update mode
	If Source = Source.Ref Then
		Ref = Source.Ref;
	ElsIf Source.IsNew() Then
		Ref = Source.GetNewObjectRef();
	Else
		Ref = Source.Ref;
	EndIf;
	If Ref.IsEmpty() Then
		Ref = Documents[Source.Metadata().Name].GetRef();
		Source.SetNewObjectRef(Ref);
	EndIf;

	Query = New Query;
	Query.Text =
		"SELECT TRUE FROM InformationRegister.T9100A_ObjectAccessMap AS T9100A_ObjectAccessMap
		|WHERE
		|	T9100A_ObjectAccessMap.ObjectRef = &ObjectRef
		|	AND T9100A_ObjectAccessMap.ObjectAccessKeys = &ObjectAccessKeys";
	
	Query.SetParameter("ObjectRef", Ref);
	Query.SetParameter("ObjectAccessKeys", AccessKeyRef);
	QueryResult = Query.Execute();
	
	If QueryResult.IsEmpty() Then
		Reg = InformationRegisters.T9100A_ObjectAccessMap.CreateRecordManager();
		Reg.ObjectAccessKeys = AccessKeyRef;
		Reg.ObjectRef = Ref;
		Reg.Write();
	EndIf;
EndProcedure

// Update access keys Document.
// 
// Parameters:
//  UpdateAll - Boolean - Update all
//  DocumentMetadata - MetadataObjectDocument - Document metadata
Procedure UpdateAccessKeys_Document(UpdateAll = False, DocumentMetadata = Undefined) Export
	If UpdateAll Then
		Text = 
		"SELECT
		|	Doc.Ref
		|FROM
		|	Document.%1 AS Doc
		|
		|ORDER BY
		|	Doc.Date";
	Else
		Text = 
		"SELECT
		|	Doc.Ref,
		|	T9100A_ObjectAccessMap.ObjectAccessKeys
		|FROM
		|	Document.%1 AS Doc
		|		LEFT JOIN InformationRegister.T9100A_ObjectAccessMap AS T9100A_ObjectAccessMap
		|		ON Doc.Ref = T9100A_ObjectAccessMap.ObjectRef
		|WHERE
		|	T9100A_ObjectAccessMap.ObjectAccessKeys IS NULL
		|
		|ORDER BY
		|	Doc.Date";
	EndIf;             
	
	If DocumentMetadata = Undefined Then 
		For Each Doc In Metadata.Documents Do
			Query = New Query(StrTemplate(Text, Doc.Name));
			DocSelect = Query.Execute().Select();
			While DocSelect.Next() Do
				//@skip-check invocation-parameter-type-intersect, property-return-type
				CalculateAndUpdateAccessKey_Document(DocSelect.Ref);
			EndDo;
		EndDo;   
	Else
	    Query = New Query(StrTemplate(Text, DocumentMetadata.Name));
		DocSelect = Query.Execute().Select();
		While DocSelect.Next() Do
			//@skip-check invocation-parameter-type-intersect, property-return-type
			CalculateAndUpdateAccessKey_Document(DocSelect.Ref);
		EndDo;
	EndIf;
	
EndProcedure

#EndRegion

#Region Service

Function GetAndCalculatedAccessKey(Source, MetadataObject)
	Module = MetadataInfo.GetManager(MetadataObject.FullName()); // DocumentManager.RetailSalesReceipt
	Try
		AccessKeys = Module.GetAccessKey(Source);
	Except
		// Object not connected to access subsystem
		Return Undefined;		
	EndTry;
	
	If AccessKeys.Count() = 0 Then
		// Object not using access keys
		Return Undefined;
	EndIf;
	
	Keys = New ValueTable();
	Keys.Columns.Add("Key", New TypeDescription("String"));
	MaxCount = 0;
	For Each Attribute In Metadata.Catalogs.ObjectAccessKeys.TabularSections.FilterDataList.Attributes Do
		If Not StrStartsWith(Attribute.Name, "ValueRef") Then
			Continue;
		EndIf;
		MaxCount = MaxCount + 1;
		Keys.Columns.Add("ValueRef" + MaxCount, Metadata.Catalogs.ObjectAccessKeys.TabularSections.FilterDataList.Attributes["ValueRef" + MaxCount].Type);
	EndDo;
	
	For Each AccessKey In AccessKeys Do
		If TypeOf(AccessKey.Value) = Type("Array") Then
			//@skip-check dynamic-access-method-not-found
			If AccessKey.Value.Count() > MaxCount Then
				//@skip-check property-return-type
				Raise R().Error_MaximumAccessKey;
			EndIf;
			
			//@skip-check invocation-parameter-type-intersect
			SortedArray = CommonFunctionsServer.SortArray(AccessKey.Value);
			NewRow = Keys.Add();
			NewRow.Key = AccessKey.Key;			
			//@skip-check dynamic-access-method-not-found
			For Index = 0 To SortedArray.Count() - 1 Do
				NewRow["ValueRef" + (Index + 1)] = SortedArray[Index];
			EndDo;
		Else
			NewRow = Keys.Add();
			NewRow.Key = AccessKey.Key;
			//@skip-check property-return-type
			NewRow.ValueRef1 = AccessKey.Value;
		EndIf;
	EndDo; 
	
	Keys.Sort("Key");
	
	HASH = CommonFunctionsServer.GetMD5(Keys, True, True);

	Query = New Query;
	Query.Text =
		"SELECT
		|	ObjectAccessKeys.Ref
		|FROM
		|	Catalog.ObjectAccessKeys AS ObjectAccessKeys
		|WHERE
		|	ObjectAccessKeys.Code = &Code";
	
	Query.SetParameter("Code", HASH);
	
	QueryResult = Query.Execute().Select();
	
	If QueryResult.Next() Then
		//@skip-check property-return-type
		AccessKeyRef = QueryResult.Ref; // CatalogRef.ObjectAccessKeys
	Else	
		NewKey = Catalogs.ObjectAccessKeys.CreateItem();
		NewKey.Code = HASH;
		NewKey.FilterDataList.Load(Keys);
		NewKey.Write();
		AccessKeyRef = NewKey.Ref;
	EndIf;

	Return AccessKeyRef;

EndFunction

#EndRegion

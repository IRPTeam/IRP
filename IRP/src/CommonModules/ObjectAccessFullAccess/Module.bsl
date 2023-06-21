// @strict-types

// On write object access on write.
// 
// Parameters:
//  Source - DefinedType.typeAccessDocument -
//  Cancel - Boolean - Cancel
//  WriteMode - DocumentWriteMode -
//  PostingMode - DocumentPostingMode -
Procedure BeforeWrite_ObjectAccessOnWrite(Source, Cancel, WriteMode, PostingMode) Export
	If Cancel Then
		Return;
	EndIf;
	
	If Not GetFunctionalOption("UseObjectAccess") Then
		Return;
	EndIf;
	
	CalculateAndUpdateAccessKey(Source);
	
EndProcedure

// Calculate and update access key.
// 
// Parameters:
//  Source - DocumentRefDocumentName, DocumentObjectDocumentName -
Procedure CalculateAndUpdateAccessKey(Source)
	Module = MetadataInfo.GetManager(Source.Metadata().FullName()); // DocumentManager.RetailSalesReceipt
	
	AccessKeys = Module.GetAccessKey(Source);
	Keys = New ValueTable();
	Keys.Columns.Add("Key", New TypeDescription("String"));
	Keys.Columns.Add("ValueSimpleType", Metadata.Catalogs.ObjectAccessKeys.TabularSections.FilterDataList.Attributes.ValueSimpleType.Type);
	Keys.Columns.Add("ValueRef", Metadata.Catalogs.ObjectAccessKeys.TabularSections.FilterDataList.Attributes.ValueRef.Type);
	
	For Each AccessKey In AccessKeys Do
		If TypeOf(AccessKey.Value) = Type("Array") Then
			For Each Value In AccessKey.Value Do
				FillKeysTables(Keys, AccessKey.Key, Value);
			EndDo;
		Else
			FillKeysTables(Keys, AccessKey.Key, AccessKey.Value);
		EndIf;
	EndDo; 
	
	Keys.Sort("Key, ValueSimpleType, ValueRef");
	
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

	// If not set ref, then can not use RLS on create or update mode
	If Source.Ref.IsEmpty() Then
		Ref = Documents[Source.Metadata().Name].GetRef();
		Source.SetNewObjectRef(Ref);
	Else
		Ref = Source.Ref;
	EndIf;

	Reg = InformationRegisters.T9100A_ObjectAccessMap.CreateRecordManager();
	Reg.ObjectAccessKeys = AccessKeyRef;
	Reg.ObjectRef = Ref;
	Reg.Write();
EndProcedure

Procedure FillKeysTables(Keys, PathKey, Value)
	NewRow = Keys.Add();
	NewRow.Key = PathKey;
	If Keys.Columns.ValueRef.ValueType.ContainsType(TypeOf(Value)) Then
		//@skip-check property-return-type
		NewRow.ValueRef = Value;
	ElsIf Keys.Columns.ValueSimpleType.ValueType.ContainsType(TypeOf(Value)) Then
		//@skip-check property-return-type
		NewRow.ValueSimpleType = Value;
	Else
		//@skip-check property-return-type
		Raise R().ACS_UnknownValueType;
	EndIf;
EndProcedure

Procedure UpdateAccessKeys(UpdateAll = False, DocumentMetadata = Undefined) Export
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
				CalculateAndUpdateAccessKey(DocSelect.Ref);
			EndDo;
		EndDo;   
	Else
	    Query = New Query(StrTemplate(Text, DocumentMetadata.Name));
		DocSelect = Query.Execute().Select();
		While DocSelect.Next() Do
			//@skip-check invocation-parameter-type-intersect, property-return-type
			CalculateAndUpdateAccessKey(DocSelect.Ref);
		EndDo;
	EndIf;
	
EndProcedure
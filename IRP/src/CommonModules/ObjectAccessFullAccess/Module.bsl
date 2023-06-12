// @strict-types

// On write object access on write.
// 
// Parameters:
//  Source - DefinedType.typeAccessToObject -
//  Cancel - Boolean - Cancel
Procedure OnWrite_ObjectAccessOnWrite(Source, Cancel) Export
	If Cancel Then
		Return;
	EndIf;
	
	If Not GetFunctionalOption("UseObjectAccess") Then
		Return;
	EndIf;
	
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

	Reg = InformationRegisters.T9100A_ObjectAccessMap.CreateRecordManager();
	Reg.ObjectAccessKeys = AccessKeyRef;
	Reg.ObjectRef = Source.Ref;
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

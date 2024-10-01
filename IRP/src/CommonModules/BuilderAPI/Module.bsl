// @strict-types

#Region Public

#Region ForClient
// Initialize for client.
// 
// Parameters:
//  DocName - String - Document name ex. SalesOrder
//  InitialData - Structure - First initial data
//  FillingData - Structure - Filling data
//  DefaultTable - String - Default table name
//  
// Returns:
//  String - Initialize
Function InitializeAtClient(DocName, InitialData = Undefined, FillingData = Undefined, DefaultTable = Undefined) Export
	Wrapper = Initialize(DocName, InitialData, FillingData, DefaultTable);
	Context = ValueToStringInternal(Wrapper);
	Return Context;
EndFunction

// Set property from client.
// 
// Parameters:
//  Context - String - See InitializeAtClient Wrapper
//  PropertyName - String - Property name
//  Value - Arbitrary - Value
//  MainTableName - String - Main table name
// 
// Returns:
//  Structure - Set property:
// * Context - String -
// * Cache - Structure -
Function SetPropertyAtClient(Context, PropertyName, Value, MainTableName = Undefined) Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper
	Result = SetProperty(Wrapper, PropertyName, Value, MainTableName);
	Result.Context = ValueToStringInternal(Result.Context);
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

// Set row property.
// 
// Parameters:
//  Context - String - Context
//  Row - Structure, String, Number - Row or Row key or Row index
//  ColumnName - String - Column name
//  Value - Arbitrary - Value
//  TableName - Undefined, String - Table name
// 
// Returns:
//  Structure - Set row property:
// * Context - String -
// * Cache - Structure -
Function SetRowPropertyAtClient(Context, Row, ColumnName, Value, TableName = Undefined) Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper
	Result = SetRowProperty(Wrapper, Row, ColumnName, Value, TableName);
	Result.Context = ValueToStringInternal(Result.Context);
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

// Write.
// 
// Parameters:
//  Context - String - Context
//  WriteMode - DocumentWriteMode - Write mode
//  PostingMode - DocumentPostingMode - Posting mode
// 
// Returns:
//  Structure - Write:
// * Context - String -
// * Ref - DocumentRefDocumentName -
Function WriteAtClient(Context, WriteMode = Undefined, PostingMode = Undefined) Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper
	Result = Write(Wrapper, WriteMode, PostingMode);
	Result.Context = ValueToStringInternal(Result.Context);
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

// Add row.
// 
// Parameters:
//  Context - String -
//  TableName - String - Table name
// 
// Returns:
//  Structure:
// 	 * Context - String -
// 	 * RowKey - String -
Function AddRowAtClient(Context, TableName = Undefined) Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper
	Row = AddRow(Wrapper, TableName, True);
	Result = New Structure();
	Result.Insert("Context", ValueToStringInternal(Wrapper));
	Result.Insert("RowKey", Row);
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

#EndRegion

#Region ForServer

// Initialize for server.
// 
// Parameters:
//  Doc - String, DocumentRefDocumentName - Document name ex. SalesOrder, or Document ref
//  InitialData - Structure - First initial data
//  FillingData - Structure - Filling data
//  DefaultTable - String - Default table name
//  DocInfo - Structure:
//   * DocMetadata - MetadataObjectDocument
//   * DocObject - DocumentObjectDocumentName
// 
// Returns:
//  See CreateWrapper
Function Initialize(Doc = Undefined, InitialData = Undefined, FillingData = Undefined, DefaultTable = Undefined, DocInfo = Undefined) Export
	
	If DocInfo = Undefined Then
		If TypeOf(Doc) = Type("String") Then
			DocMetadata = Metadata.Documents[Doc];
			DocObject = Documents[DocMetadata.Name].CreateDocument();
			DocObject.Fill(FillingData);
		Else
			DocMetadata = Doc.Metadata();
			If Doc.IsEmpty() Then
				DocObject = Documents[DocMetadata.Name].CreateDocument();
			Else
				DocObject = Doc.GetObject();
			EndIf;
		EndIf;
	Else
		DocMetadata = DocInfo.DocMetadata;
		DocObject = DocInfo.DocObject;
	EndIf;
	
	Wrapper = CreateWrapper(DefaultTable);
	
	For Each Attr In DocMetadata.StandardAttributes Do
		FillAttrInfo(Wrapper, DocObject, Attr);
	EndDo;
	For Each Attr In DocMetadata.Attributes Do
		FillAttrInfo(Wrapper, DocObject, Attr);
	EndDo;
	For Each Attr In Metadata.CommonAttributes Do
		If CommonFunctionsServer.isCommonAttributeUseForMetadata(Attr.Name, DocMetadata) Then
			FillAttrInfo(Wrapper, DocObject, Attr);
		EndIf;
	EndDo;
	For Each Table In DocMetadata.TabularSections Do
		Wrapper.Object.Insert(Table.Name, New ValueTable());
		Wrapper.Tables.Insert(Table.Name, New Structure("_TableName_", Table.Name));
		For Each Column In Table.StandardAttributes Do // StandardAttributeDescriptions
			//@skip-check invocation-parameter-type-intersect
			FillColumnInfo(Wrapper, DocObject, Table, Column);
		EndDo;
		For Each Column In Table.Attributes Do
			FillColumnInfo(Wrapper, DocObject, Table, Column);
		EndDo;
		
		For Each Row In DocObject[Table.Name] Do // ValueTableRow
			//@skip-check dynamic-access-method-not-found
			FillPropertyValues(Wrapper.Object[Table.Name].Add(), Row);
		EndDo;
	EndDo;
	
	If InitialData <> Undefined Then
		FillInitData(Wrapper, InitialData);
	EndIf;
	Return Wrapper
EndFunction

// Set property.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  PropertyName - String - Property name
//  Value - Arbitrary - Value
//  MainTableName - String - Main table name
// 
// Returns:
//  Structure - Set property:
// * Context - See CreateWrapper
// * Cache - Structure -
Function SetProperty(Wrapper, PropertyName, Value, MainTableName = Undefined) Export
	Property = Wrapper.Attr[PropertyName]; // Arbitrary
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	If MainTableName = Undefined Then
		MainTableName = Wrapper.DefaultTable;
	EndIf;
	ServerParameters.TableName = MainTableName;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Value, True);
	Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Cache", Parameters.Cache);
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

// Set row property.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  Row - Structure, String, Number, ValueTableRow - Row or Row key or Row index
//  ColumnName - String - Column name
//  Value - Arbitrary - Value
//  TableName - Undefined, String - Table name. If empty - get from wrapper as defaul table
// 
// Returns:
//  Structure - Set row property:
// * Context - See CreateWrapper
// * Cache - Structure -
Function SetRowProperty(Wrapper, Row, ColumnName, Value, TableName = Undefined) Export
	If TableName = Undefined Then
		TableName = Wrapper.DefaultTable;
	EndIf;
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object); // Structure
	ServerParameters.TableName = TableName;
	
	Rows = New Array(); // Array Of ValueTableRow
	If TypeOf(Row) = Type("Number") Then
		//@skip-check invocation-parameter-type-intersect
		Rows.Add(Wrapper.Object[TableName][0]);
	ElsIf TypeOf(Row) = Type("String") Then
		//@skip-check invocation-parameter-type-intersect, dynamic-access-method-not-found
		Rows.Add(Wrapper.Object[TableName].FindRows(New Structure("Key", Row))[0]);
	Else
		Rows.Add(Row);
	EndIf;
	
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	
	//@skip-check dynamic-access-method-not-found
	isPropertyExists = Wrapper.Tables[TableName].Property(ColumnName); // Boolean
	If isPropertyExists Then
		Property = Wrapper.Tables[TableName][ColumnName]; // Structure
		ControllerClientServer_V2.API_SetProperty(Parameters, Property, Value, True);
	EndIf;
	
	Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Cache", Parameters.Cache);
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

// Execute command.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  Row - Structure, String, Number, ValueTableRow - Row or Row key or Row index
//  CommandName - String - Command name
//  TableName - Undefined, String - Table name. If empty - get from wrapper as defaul table
// 
// Returns:
//  Structure - Set row property:
// * Context - See CreateWrapper
// * Cache - Structure -
Function ExecuteCommand(Wrapper, Row, CommandName, TableName = Undefined) Export
	If TableName = Undefined Then
		TableName = Wrapper.DefaultTable;
	EndIf;
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object); // Structure
	ServerParameters.TableName = TableName;
	
	Rows = New Array(); // Array Of ValueTableRow
	If TypeOf(Row) = Type("Number") Then
		//@skip-check invocation-parameter-type-intersect
		Rows.Add(Wrapper.Object[TableName][0]);
	ElsIf TypeOf(Row) = Type("String") Then
		//@skip-check invocation-parameter-type-intersect, dynamic-access-method-not-found
		Rows.Add(Wrapper.Object[TableName].FindRows(New Structure("Key", Row))[0]);
	Else
		Rows.Add(Row);
	EndIf;
	
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	
	ControllerClientServer_V2.API_SetProperty(Parameters, New Structure("DataPath", CommandName), Undefined, True);
	
	Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Cache", Parameters.Cache);
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

// Write.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  WriteMode - DocumentWriteMode - Write mode
//  PostingMode - DocumentPostingMode - Posting mode
//  Object - DocumentObjectDocumentName - Update current object
//  CheckFilling - Boolean - 
// 
// Returns:
//  Structure - Write:
// * Context - See CreateWrapper
// * Ref - DocumentRefDocumentName, CatalogRefCatalogName -
// * Object - DocumentObjectDocumentName, CatalogObjectCatalogName - If set Object at parameter then returned updated object
Function Write(Wrapper, WriteMode = Undefined, PostingMode = Undefined, Object = Undefined, CheckFilling = False) Export
	ObjMetadata = Wrapper.Object.Ref.Metadata(); // MetadataObjectCatalog, MetadataObjectDocument 
	Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Object", Undefined);
	Result.Insert("Ref", Undefined);
	If Metadata.Documents.Contains(ObjMetadata) Then
		If Not Object = Undefined Then
			Doc = Object; // DocumentObjectDocumentName
		ElsIf ValueIsFilled(Wrapper.Object.Ref) Then
			Doc = Wrapper.Object.Ref.GetObject(); // DocumentObjectDocumentName
		Else
			Doc = Documents[ObjMetadata.Name].CreateDocument(); // DocumentObjectDocumentName
		EndIf;
		
		FillPropertyValues(Doc, Wrapper.Object, , "Number");
		If Not ValueIsFilled(Doc.Date) Then
			Doc.Date = CommonFunctionsServer.GetCurrentSessionDate();
		EndIf;
		For Each Table In ObjMetadata.TabularSections Do
			DocTable = Doc[Table.Name]; // TabularSection
			LoadTable = Wrapper.Object[Table.Name]; // ValueTable
			DocTable.Load(LoadTable);
		EndDo;
		
		For Each KeyValue In Wrapper.Object.AdditionalProperties Do
			Doc.AdditionalProperties.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
		
		If Object = Undefined Then
			
			If CheckFilling Then
				If Not Doc.CheckFilling() Then
					Raise "Error on posting document";
				EndIf;
			EndIf;
			
			Doc.Write(
				?(
					WriteMode = Undefined, 
					?(Doc.Posted, DocumentWriteMode.Posting, DocumentWriteMode.Write), 
					WriteMode
				),
				?(PostingMode = Undefined , DocumentPostingMode.Regular , PostingMode)
			);
			Wrapper.Object.Ref = Doc.Ref;
		Else
			Result.Insert("Object", Doc);
		EndIf;
		Result.Ref = Doc.Ref;
	ElsIf Metadata.Catalogs.Contains(ObjMetadata) Then
		WrapperObject = Wrapper.Object; // CatalogObject
		If Not Object = Undefined Then
			Ctlg = Object;
		ElsIf ValueIsFilled(WrapperObject.Ref) Then
			Ctlg = WrapperObject.Ref.GetObject();
			If ObjMetadata.CodeLength > 0 Then
				Ctlg.Code = WrapperObject.Code;
			EndIf;
		ElsIf WrapperObject.IsFolder Then
			Ctlg = Catalogs[ObjMetadata.Name].CreateFolder();
		Else
			Ctlg = Catalogs[ObjMetadata.Name].CreateItem();
		EndIf;
		
		FillPropertyValues(Ctlg, WrapperObject, , "Code");
		For Each Table In ObjMetadata.TabularSections Do
			CtlgTable = Ctlg[Table.Name]; // TabularSection
			LoadTable = WrapperObject[Table.Name]; // ValueTable
			CtlgTable.Load(LoadTable);
		EndDo;
		
		For Each KeyValue In Wrapper.Object.AdditionalProperties Do
			Doc.AdditionalProperties.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
				
		If Object = Undefined Then
			If CheckFilling Then
				If Not Ctlg.CheckFilling() Then
					Raise "Error on posting document";
				EndIf;
			EndIf;
			Ctlg.Write();
			WrapperObject.Ref = Ctlg.Ref;
		Else
			Result.Insert("Object", Ctlg);
		EndIf;
		Result.Ref = Ctlg.Ref;
	Else
		//@skip-warning
		Raise StrTemplate(R().Exc_010, ObjMetadata.FullName());
	EndIf;
	
	//@skip-check constructor-function-return-section
	Return Result;
EndFunction

// Add row.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  TableName - String - Table name
//  ReturnRowKey - Boolean -
// 
// Returns:
//  ValueTableRow, String
Function AddRow(Wrapper, TableName = Undefined, ReturnRowKey = False) Export
	If TableName = Undefined Then
		TableName = Wrapper.DefaultTable;
	EndIf;
	WrapperTable = Wrapper.Object[TableName]; // See Document.SalesInvoice.ItemList
	NewRow = WrapperTable.Add();
	NewRow.Key = String(New UUID());
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	ServerParameters.TableName = TableName;
	Rows = New Array(); // Array Of DocumentTabularSectionRow.SalesInvoice.ItemList
	Rows.Add(NewRow);
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.AddNewRow(TableName, Parameters);
	NewRow = WrapperTable.FindRows(New Structure("Key", NewRow.Key))[0];
	If ReturnRowKey Then
		Return NewRow.Key;
	Else
		Return NewRow;
	EndIf;
EndFunction

// Set row tax rate.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  Row - See AddRow
//  Tax - CatalogRef.Taxes - Tax
//  TaxRate - CatalogRef.TaxRates - Tax rate
//  TableName - String - Table name
// 
// Returns:
//  Structure - Set row tax rate:
// 		* Context - See CreateWrapper
// 		* Cache - Structure -
// @skip-check method-param-value-type
Function SetRowTaxRate(Wrapper, Row, Tax, TaxRate, TableName) Export
	If TableName = Undefined Then
		TableName = Wrapper.DefaultTable;
	EndIf;
	Property = New Structure();
	Property.Insert("DataPath", StrTemplate("%1.%2", TableName, ""));
	Property.Insert("_TableName_", TableName);
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	ServerParameters.TableName = String(Property._TableName_);
	Rows = New Array(); // Array Of ValueTableRow
	//@skip-check invocation-parameter-type-intersect
	Rows.Add(Row);
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	
	TaxInfo = Undefined; // Structure
	For Each Info In Parameters.ArrayOfTaxInfo Do
		//@skip-check property-return-type
		If Info.Tax = Tax Then
			TaxInfo = Info;
			Break;
		EndIf;
	EndDo;
	
	If TaxInfo = Undefined Then
		Raise "Tax not allowed for document, check tax settings";
	EndIf;
	
	//@skip-check property-return-type
	Parameters.Rows[0].TaxRates[TaxInfo.Name] = TaxRate;

	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined, True);
	Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Cache", Parameters.Cache);
	Return Result;
EndFunction

// Delete row.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  Row - Structure, String, Number, ValueTableRow - Row or Row key or Row index
//  TableName - Undefined, String - Table name. If empty - get from wrapper as defaul table
Procedure DeleteRow(Wrapper, Row, TableName = Undefined) Export
	If TableName = Undefined Then
		TableName = Wrapper.DefaultTable;
	EndIf;

	RowToRemove = Undefined;
	If TypeOf(Row) = Type("Number") Then
		//@skip-check statement-type-change
		RowToRemove = Wrapper.Object[TableName][0];
	ElsIf TypeOf(Row) = Type("String") Then
		//@skip-check statement-type-change, dynamic-access-method-not-found
		RowToRemove = Wrapper.Object[TableName].FindRows(New Structure("Key", Row))[0];
	Else
		RowToRemove = Row;
	EndIf;
	
	//@skip-check dynamic-access-method-not-found
	Wrapper.Object[TableName].Delete(RowToRemove);
	
	Rows = New Array(); // Array Of ValueTableRow
	For Each Row In Wrapper.Object[TableName] Do
		Rows.Add(Row);
	EndDo;
	
	Property = New Structure();
	Property.Insert("DataPath", StrTemplate("%1.%2", TableName, ""));
	Property.Insert("_TableName_", TableName);
	
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object); // Structure
	ServerParameters.TableName = TableName;
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	
	ControllerClientServer_V2.DeleteRows(TableName, Parameters);
	
EndProcedure
#EndRegion

#Region Filling

// Get wrapper from context.
// 
// Parameters:
//  Context - String - Context
// 
// Returns:
//  See CreateWrapper
Function GetWrapperFromContext(Context) Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper 
	Return Wrapper;
EndFunction

#EndRegion

#EndRegion

#Region Service

// Create wrapper.
// 
// Returns:
//  Structure - Create wrapper:
// * Object - Structure:
// 	** Ref - DocumentRefDocumentName -
// * Attr - Structure:
// 	** Key - String - Attribute name
// 	** Value - Arbitrary - Attribute value
// * Tables - Structure:
// 	** Key - String - Table name
// 	** Value - ValueTable - Table
// * DefaultTable - Undefined, String - Default table name
// * AdditionalProperties - Structure
Function CreateWrapper(DefaultTable = Undefined) Export
	Wrapper = New Structure("Object", New Structure());
	Wrapper.Insert("Attr"    , New Structure());
	Wrapper.Insert("Tables" , New Structure());
	Wrapper.Insert("DefaultTable" , DefaultTable);
	Wrapper.Insert("AdditionalProperties" , New Structure);
	Return Wrapper
EndFunction

// Fill init data.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  InitialData - Structure:
//  * Key - String -
//  * Value - Arbitrary -
Procedure FillInitData(Wrapper, InitialData)
	For Each KeyValue In InitialData Do
		//@skip-check invocation-parameter-type-intersect
		isValueExists = Wrapper.Object.Property(KeyValue.Key);
		
		If isValueExists And TypeOf(InitialData[KeyValue.Key]) = Type("Array") Then
			Array = Wrapper.Object[KeyValue.Key]; // Array
			For Each InitRow In InitialData[KeyValue.Key] Do // Structure
				FillPropertyValues(Array.Add(), InitRow);
			EndDo;
		Else
			If isValueExists Then
				Wrapper.Object[KeyValue.Key] = InitialData[KeyValue.Key];
			EndIf;
		EndIf;
	EndDo;
EndProcedure

// Fill attr info.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  DocObject - DocumentObjectDocumentName - Doc object
//  Attr - StandardAttributeDescription, MetadataObjectAttribute, MetadataObjectCommonAttribute - Attr
Procedure FillAttrInfo(Wrapper, DocObject, Attr)
	Wrapper.Object.Insert(Attr.Name, DocObject[Attr.Name]);
	AttrInfo = New Structure();
	AttrInfo.Insert("DataPath", Attr.Name);
	Wrapper.Attr.Insert(Attr.Name, AttrInfo);
EndProcedure

// Fill column info.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  DocObject - DocumentObjectDocumentName - Doc object
//  Table - MetadataObjectTabularSection - Table
//  Column - StandardAttributeDescriptions, MetadataObjectAttribute - Column
Procedure FillColumnInfo(Wrapper, DocObject, Table, Column)
	WrapperTable = Wrapper.Object[Table.Name]; // ValueTable
	WrapperTable.Columns.Add(Column.Name, Column.Type);
	ColumnInfo = New Structure();
	ColumnInfo.Insert("DataPath", StrTemplate("%1.%2", Table.Name, Column.Name));
	ColumnInfo.Insert("_TableName_", Table.Name);
	TableStructure = Wrapper.Tables[Table.Name]; // Structure
	TableStructure.Insert(Column.Name, ColumnInfo);
EndProcedure

#EndRegion

// @strict-types

#Region Public

#Region ForClient
// Initialize for client.
// 
// Parameters:
//  DocName - String - Document name ex. SalesOrder
//  InitialData - Structure - First initial data
// 
// Returns:
//  String - Initialize
Function InitializeAtClient(DocName, InitialData = Undefined) Export
	Wrapper = Initialize(DocName, InitialData);
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
	Return Result;
EndFunction

// Set row property.
// 
// Parameters:
//  Context - String - Context
//  Row - Array of Structure - Row
//  ColumnName - String - Column name
//  Value - Arbitrary - Value
//  TableName - String - Table name
// 
// Returns:
//  Structure - Set row property:
// * Context - String -
// * Cache - Structure -
Function SetRowPropertyAtClient(Context, Row, ColumnName, Value, TableName) Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper
	Result = SetRowProperty(Wrapper, Row, ColumnName, Value, TableName);
	Result.Context = ValueToStringInternal(Result.Context);
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
	Return Result;
EndFunction

#EndRegion

#Region ForServer

// Initialize for server.
// 
// Parameters:
//  DocName - String - Document name ex. SalesOrder
//  InitialData - Structure - First initial data
// 
// Returns:
//  See CreateWrapper
Function Initialize(DocName, InitialData = Undefined, FillingData = Undefined) Export
	DocMetadata = Metadata.Documents[DocName];
	DocObject = Documents[DocMetadata.Name].CreateDocument();
	DocObject.Fill(FillingData);
	
	Wrapper = CreateWrapper();
	
	For Each Attr In DocMetadata.StandardAttributes Do
		FillAttrInfo(Wrapper, DocObject, Attr);
	EndDo;
	For Each Attr In DocMetadata.Attributes Do
		FillAttrInfo(Wrapper, DocObject, Attr);
	EndDo;
	For Each Table In DocMetadata.TabularSections Do
		Wrapper.Object.Insert(Table.Name, New ValueTable());
		Wrapper.Tables.Insert(Table.Name, New Structure("_TableName_", Table.Name));
		For Each Column In Table.StandardAttributes Do
			FillColumnInfo(Wrapper, DocObject, Table, Column);
		EndDo;
		For Each Column In Table.Attributes Do
			FillColumnInfo(Wrapper, DocObject, Table, Column);
		EndDo;
		
		For Each Row In DocObject[Table.Name] Do
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
	ServerParameters.TableName = MainTableName;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Value);
	Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Cache", Parameters.Cache);
	Return Result;
EndFunction

// Set row property.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  Row - Array of Structure - Row
//  ColumnName - String - Column name
//  Value - Arbitrary - Value
//  TableName - String - Table name
// 
// Returns:
//  Structure - Set row property:
// * Context - See CreateWrapper
// * Cache - Structure -
Function SetRowProperty(Wrapper, Row, ColumnName, Value, TableName) Export
	Property = Wrapper.Tables[TableName][ColumnName]; // Structure
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object); // Structure
	//@skip-check property-return-type
	ServerParameters.TableName = String(Property._TableName_);
	Rows = New Array();
	Rows.Add(Row);
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Value);
	Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Cache", Parameters.Cache);
	Return Result;
EndFunction

// Write.
// 
// Parameters:
//  Wrapper - See CreateWrapper
//  WriteMode - DocumentWriteMode - Write mode
//  PostingMode - DocumentPostingMode - Posting mode
// 
// Returns:
//  Structure - Write:
// * Context - See CreateWrapper
// * Ref - DocumentRefDocumentName -
Function Write(Wrapper, WriteMode = Undefined, PostingMode = Undefined) Export
	DocMetadata = Wrapper.Object.Ref.Metadata();
	
	If ValueIsFilled(Wrapper.Object.Ref) Then
		Doc = Wrapper.Object.Ref.GetObject();
	Else
		Doc = Documents[DocMetadata.Name].CreateDocument();
	EndIf;
	
	FillPropertyValues(Doc, Wrapper.Object, , "Number");
	
	If Not ValueIsFilled(Doc.Date) Then
		Doc.Date = CurrentSessionDate();
	EndIf;
	For Each Table In DocMetadata.TabularSections Do
		DocTable = Doc[Table.Name]; // TabularSection
		LoadTable = Wrapper.Object[Table.Name]; // ValueTable
		DocTable.Load(LoadTable);
	EndDo;
	Doc.Write(?(WriteMode = Undefined, DocumentWriteMode.Write, WriteMode),
		?(PostingMode = Undefined , DocumentPostingMode.Regular , PostingMode));
	Wrapper.Object.Ref = Doc.Ref;
		Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Ref", Doc.Ref);
	Return Result;
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
Function CreateWrapper()
	Wrapper = New Structure("Object", New Structure());
	Wrapper.Insert("Attr"    , New Structure());
	Wrapper.Insert("Tables" , New Structure());
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
			For Each InitRow In InitialData[KeyValue.Key] Do
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
//  Attr - StandardAttributeDescription, MetadataObjectAttribute - Attr
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
//  Column - StandardAttributeDescription, MetadataObjectAttribute - Column
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


Function AddRow(Wrapper, TableName) Export
	NewRow = Wrapper.Object[TableName].Add();
	NewRow.Key = String(New UUID());
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	ServerParameters.TableName = TableName;
	Rows = New Array();
	Rows.Add(NewRow);
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.AddNewRow(TableName, Parameters);
	Return Wrapper.Object[TableName].FindRows(New Structure("Key", NewRow.Key))[0];
EndFunction

Function SetRowTaxRate(Wrapper, Row, Tax, TaxRate, TableName) Export
	Property = New Structure();
	Property.Insert("DataPath", StrTemplate("%1.%2", TableName, ""));
	Property.Insert("_TableName_", TableName);
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	ServerParameters.TableName = String(Property._TableName_);
	Rows = New Array();
	Rows.Add(Row);
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	
	TaxInfo = Undefined;
	For Each Info In Parameters.ArrayOfTaxInfo Do
		If Info.Tax = Tax Then
			TaxInfo = Info;
			Break;
		EndIf;
	EndDo;
	
	If TaxInfo = Undefined Then
		Raise "Tax not allowed for document, check tax settings";
	EndIf;
	
	Parameters.Rows[0][TaxInfo.Name] = TaxRate;
	Parameters.FormTaxColumnsExists = True;
	
	Parameters.Cache.Insert(TableName, New Array());
		
	NewCacheRow = New Structure();
	NewCacheRow.Insert("Key", Row.Key);
	NewCacheRow.Insert(TaxInfo.Name, TaxRate);
	Parameters.Cache[TableName].Add(NewCacheRow);
	
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined);
	Result = New Structure();
	Result.Insert("Context", Wrapper);
	Result.Insert("Cache", Parameters.Cache);
	Return Result;
EndFunction

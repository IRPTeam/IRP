// @strict-types

#Region Public

// Initialize.
// 
// Parameters:
//  DocName - String - Document name
//  InitialData - Structure - First initial data
// 
// Returns:
//  String - Initialize
Function Initialize(DocName, InitialData = Undefined) Export
	
	DocMetadata = Metadata.Documents[DocName];
	DocObject = Documents[DocMetadata.Name].CreateDocument();
	DocObject.Fill(Undefined);
	
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
	EndDo;
	
	If InitialData <> Undefined Then
		FillInitData(Wrapper, InitialData);
	EndIf;
	
	Context = ValueToStringInternal(Wrapper);
	Return Context;
EndFunction

// Set property.
// 
// Parameters:
//  Context - String - Context
//  PropertyName - String - Property name
//  Value - Arbitrary - Value
//  MainTableName - String - Main table name
// 
// Returns:
//  Structure - Set property:
// * Context - String -
// * Cache - Structure -
Function SetProperty(Context, PropertyName, Value, MainTableName = "PaymentList") Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper
	Property = Wrapper.Attr[PropertyName]; // Arbitrary
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	ServerParameters.TableName = MainTableName;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Value);
	Result = New Structure();
	Result.Insert("Context", ValueToStringInternal(Wrapper));
	Result.Insert("Cache", Parameters.Cache);
	Return Result;
EndFunction

// Set row property.
// 
// Parameters:
//  Context - String - Context
//  Row - ValueTableRow - Row
//  ColumnName - String - Column name
//  Value - Arbitrary - Value
//  TableName - String - Table name
// 
// Returns:
//  Structure - Set row property:
// * Context - String -
// * Cache - Structure -
Function SetRowProperty(Context, Row, ColumnName, Value, TableName = "PaymentList") Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper
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
	Result.Insert("Context", ValueToStringInternal(Wrapper));
	Result.Insert("Cache", Parameters.Cache);
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
Function Write(Context, WriteMode = Undefined, PostingMode = Undefined) Export
	Wrapper = ValueFromStringInternal(Context); // See CreateWrapper
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
	Result.Insert("Context", ValueToStringInternal(Wrapper));
	Result.Insert("Ref", Doc.Ref);
	Return Result;
EndFunction

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

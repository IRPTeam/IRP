// @strict-types

&AtClient
Var DocumentTables; //Structure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocumentRef = Parameters.DocumentRef;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocumentTables = InitializeDocumentTables();
	CreateDocumentTables(DocumentTables);
	UpdateTables();
EndProcedure

&AtClient
Procedure SaveToDocument(Command)
	For Each KeyValue In DocumentTables Do
		If Not KeyValue.Value Then
			Continue;
		EndIf;
		FormDataStructure = ThisObject.FormOwner.Object; //FormDataStructure
		DocumentTable = FormDataStructure[KeyValue.Key]; //FormDataCollection 
		DocumentTable.Clear();
		
		Table = ThisObject[KeyValue.Key]; //FormDataCollection
		For Each Row In Table Do
			NewRow = DocumentTable.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

// Create document tables.
// 
// Parameters:
//  DocumentTables - Structure - Document tables
&AtServer
Procedure CreateDocumentTables(DocumentTables)
	Tables = New ValueTable();
	Tables.Columns.Add("TableName", New TypeDescription("String"));
	Tables.Columns.Add("TableColumns", New TypeDescription("Array"));
	ArrayOfAttributes = New Array(); //Array of FormAttribute
	DocumentMetadata = ThisObject.DocumentRef.Metadata();
	For Each KeyValue In DocumentTables Do
		TableName = KeyValue.Key;
		TabularSection = DocumentMetadata.TabularSections.Find(TableName);
		IsTableExists = (TabularSection <> Undefined);
		DocumentTables[TableName] = IsTableExists;
		
		If IsTableExists  Then
			NewTable = Tables.Add();
			NewTable.TableName = TableName;
			TableColumns = New Array(); //Array of String
			ArrayOfAttributes.Add(New FormAttribute(TableName, New TypeDescription("ValueTable")));
			For Each Column In TabularSection.Attributes Do
				ArrayOfAttributes.Add(New FormAttribute(Column.Name, Column.Type, TableName, Column.Synonym));
				TableColumns.Add(Column.Name);
			EndDo;
			NewTable.TableColumns = TableColumns;
		EndIf;
	EndDo;
	
	ChangeAttributes(ArrayOfAttributes);
	
	For Each Table In Tables Do
		ItemGroup = ThisObject.Items.Add("Group" + Table.TableName, Type("FormGroup"), Items.Pages); //FormGroupType
		ItemGroup.Type = FormGroupType.Page;
		ItemGroup.Title = Table.TableName;
		
		ItemTable = ThisObject.Items.Add(Table.TableName, Type("FormTable"), ItemGroup);
		ItemTable.DataPath = Table.TableName;
		For Each ColumnName In Table.TableColumns Do
			ItemColumn = ThisObject.Items.Add(Table.TableName + ColumnName, Type("FormField"), ItemTable);
			ItemColumn.Type = FormFieldType.InputField;
			ItemColumn.DataPath = Table.TableName + "." + ColumnName;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure UpdateTables()
	For Each KeyValue In DocumentTables Do
		TableName = KeyValue.Key;
		If Not KeyValue.Value Then
			Continue;
		EndIf;
		Table = ThisObject[TableName]; //FormDataCollection
		Table.Clear();
		
		DocumentTable = ThisObject.FormOwner.Object[TableName]; //FormDataCollection
		
		For Each Row In DocumentTable Do
			Table = ThisObject[TableName]; //FormDataCollection
			NewRow = Table.Add(); 
			FillPropertyValues(NewRow, Row);
		EndDo;
		CurrentTable = ThisObject[TableName]; //FormDataCollection
		ThisObject.Items["Group" + TableName].Title = StrTemplate("%1 (%2)",
			ThisObject.Items["Group" + TableName].Title, CurrentTable.Count());
	EndDo;
EndProcedure

&AtServer
Function InitializeDocumentTables()
	DocumentTables = New Structure();
	For Each Table In ThisObject.DocumentRef.Metadata().TabularSections Do
		DocumentTables.Insert(Table.Name, False);
	EndDo;
	Return DocumentTables;
EndFunction

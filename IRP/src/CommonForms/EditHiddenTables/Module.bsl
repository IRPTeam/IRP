
&AtClient
Var DocumentTables;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocumentRef = Parameters.DocumentRef;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	CreateDocumentTables(DocumentTables);
	UpdateTables();
EndProcedure

&AtClient
Procedure SaveToDocument(Command)
	For Each KeyValue In DocumentTables Do
		If Not KeyValue.Value Then
			Continue;
		EndIf;
		ThisObject.FormOwner.Object[KeyValue.Key].Clear();
		For Each Row In ThisObject[KeyValue.Key] Do
			FillPropertyValues(ThisObject.FormOwner.Object[KeyValue.Key].Add(), Row);
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtServer
Procedure CreateDocumentTables(DocumentTables)
	Tables = New ValueTable();
	Tables.Columns.Add("TableName");
	Tables.Columns.Add("TableCoumns");
	ArrayOfAttributes = New Array();
	DocumentMetadata = ThisObject.DocumentRef.Metadata();
	For Each KeyValue In DocumentTables Do
		TableName = KeyValue.Key;
		TabularSection = DocumentMetadata.TabularSections.Find(TableName);
		IsTableExists = (TabularSection <> Undefined);
		DocumentTables[TableName] = IsTableExists;
		
		If IsTableExists  Then
			NewTable = Tables.Add();
			NewTable.TableName = TableName;
			TableColumns = New Array();
			ArrayOfAttributes.Add(New FormAttribute(TableName, New TypeDescription("ValueTable")));
			For Each Column In TabularSection.Attributes Do
				ArrayOfAttributes.Add(New FormAttribute(Column.Name, Column.Type, TableName, Column.Synonym));
				TableColumns.Add(Column.Name);
			EndDo;
			NewTable.TableCoumns = TableColumns;
		EndIf;
	EndDo;
	
	ChangeAttributes(ArrayOfAttributes);
	
	For Each Table In Tables Do
		ItemGroup = ThisObject.Items.Add("Group" + Table.TableName, Type("FormGroup"), ThisObject);
		ItemGroup.Type = FormGroupType.UsualGroup;
		ItemGroup.Title = Table.TableName;
		ItemGroup.Behavior = UsualGroupBehavior.Collapsible;
		ItemTable = ThisObject.Items.Add(Table.TableName, Type("FormTable"), ItemGroup);
		ItemTable.DataPath = Table.TableName;
		For Each ColumnName In Table.TableCoumns Do
			ItemColumn = ThisObject.Items.Add(Table.TableName + ColumnName, Type("FormField"), ItemTable);
			ItemColumn.Type = FormFieldType.InputField;
			ItemColumn.DataPath = Table.TableName + "." + ColumnName;
		EndDo;
		ItemGroup.Hide();
	EndDo;
EndProcedure

&AtClient
Procedure UpdateTables()
	For Each KeyValue In DocumentTables Do
		TableName = KeyValue.Key;
		If Not KeyValue.Value Then
			Continue;
		EndIf;
		ThisObject[TableName].Clear();
		For Each Row In ThisObject.FormOwner.Object[TableName] Do
			FillPropertyValues(ThisObject[TableName].Add(), Row);
		EndDo;
		ThisObject.Items["Group" + TableName].Title = StrTemplate("%1 [%2]",
			ThisObject.Items["Group" + TableName].Title, ThisObject[TableName].Count());
	EndDo;
EndProcedure

DocumentTables = New Structure();

DocumentTables.Insert("RowIDInfo"             , False);
DocumentTables.Insert("Currencies"            , False);
DocumentTables.Insert("TaxList"               , False);
DocumentTables.Insert("SpecialOffers"         , False);
DocumentTables.Insert("SerialLotNumbers"      , False);
DocumentTables.Insert("ShipmentConfirmations" , False);
DocumentTables.Insert("GoodsReceipts"         , False);
DocumentTables.Insert("PaymentTerms"          , False);
DocumentTables.Insert("AddAttributes"         , False);
DocumentTables.Insert("DataSet"               , False);
DocumentTables.Insert("DataPrice"             , False);


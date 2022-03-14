
Function CreateDocument(DocMetadata) Export
	//DocMetadata = Metadata.Documents.ShipmentConfirmation;
	//DocMetadata.TabularSections.ItemList.Attributes.
	DocObject = Documents[DocMetadata.Name].CreateDocument();
	DocObject.Fill(Undefined);
	Wrapper = New Structure("Object", New Structure());
	Wrapper.Insert("_DocumentMetadata_" , DocMetadata);
	Wrapper.Insert("_DocumentObject_"   , DocObject);
	Wrapper.Insert("Attr"    , New Structure());
	Wrapper.Insert("Tables" , New Structure());
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
	Return Wrapper;
EndFunction

Procedure FillAttrInfo(Wrapper, DocObject, Attr)
	Wrapper.Object.Insert(Attr.Name, DocObject[Attr.Name]);
	AttrInfo = New Structure();
	AttrInfo.Insert("DataPath", Attr.Name);
	Wrapper.Attr.Insert(Attr.Name, AttrInfo);
EndProcedure

Procedure FillColumnInfo(Wrapper, DocObject, Table, Column)
	Wrapper.Object[Table.Name].Columns.Add(Column.Name, Column.Type);
	ColumnInfo = New Structure();
	ColumnInfo.Insert("DataPath", StrTemplate("%1.%2", Table.Name, Column.Name));
	ColumnInfo.Insert("_TableName_", Table.Name);
	Wrapper.Tables[Table.Name].Insert(Column.Name, ColumnInfo);
EndProcedure

Procedure SetProperty(Wrapper, Property, Value) Export
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	ServerParameters.TableName = "ItemList"; // временно, должно зависить от документа
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Value);
EndProcedure

Function AddRow(Wrapper, Table) Export
	NewRow = Wrapper.Object[Table._TableName_].Add();
	NewRow.Key = String(New UUID());
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	ServerParameters.TableName = Table._TableName_;
	Rows = New Array();
	Rows.Add(NewRow);
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.AddNewRow(Table._TableName_, Parameters);
	Return Wrapper.Object[Table._TableName_].FindRows(New Structure("Key", NewRow.Key))[0];
EndFunction

Procedure SetRowProperty(Wrapper, Row, Property, Value) Export
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper.Object);
	ServerParameters.TableName = Property._TableName_;
	Rows = New Array();
	Rows.Add(Row);
	ServerParameters.Rows = Rows;
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Value);
EndProcedure

Function Write(Wrapper, WriteMode = Undefined, PostingMode = Undefined) Export
	Doc = Wrapper._DocumentObject_;
	FillPropertyValues(Doc, Wrapper.Object, , "Number");
	For Each Table In Wrapper._DocumentMetadata_.TabularSections Do
		Doc[Table.Name].Load(Wrapper.Object[Table.Name]);
	EndDo;
	Doc.Write(?(WriteMode = Undefined, DocumentWriteMode.Write, WriteMode),
		?(PostingMode = Undefined , DocumentPostingMode.Regular , PostingMode));
	Return Doc.Ref;
EndFunction



Function CreateDocument(DocMetadata) Export
	//DocMetadata = Metadata.Documents.ShipmentConfirmation;
	//DocMetadata.TabularSections.ItemList.Attributes.
	Wrapper = New Structure("Object", New Structure());
	Wrapper.Insert("_DocumentMetadata_" , DocMetadata);
	Wrapper.Insert("_DocumentObject_"   , Documents[Wrapper._DocumentMetadata_.Name].CreateDocument());
	Wrapper.Insert("Atr"   , DocMetadata.Attributes);
	Wrapper.Insert("Table" , New Structure());
	For Each Atr In DocMetadata.StandardAttributes Do
		Wrapper.Object.Insert(Atr.Name);
	EndDo;
	For Each Atr In DocMetadata.Attributes Do
		Wrapper.Object.Insert(Atr.Name);
	EndDo;
	For Each Table In DocMetadata.TabularSections Do
		Wrapper.Object.Insert(Table.Name, New ValueTable());
		Wrapper.Table.Insert(Table.Name, New Structure());
		For Each Column In Table.StandardAttributes Do
			Wrapper[Table.Name].Columns.Add(Column.Name, Column.Type);
		EndDo;
		For Each Column In Table.Attributes Do
			Wrapper.Object[Table.Name].Columns.Add(Column.Name, Column.Type);
			Wrapper.Table[Table.Name].Insert(Column.Name, Column);
		EndDo;
	EndDo;
	Return Wrapper;
EndFunction

Procedure SetProperty(Wrapper, Property, Value) Export
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Wrapper);
	ServerParameters.TableName = "ItemList"; // временно, должно зависить от документа
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	ControllerClientServer_V2.API_SetProperty(Parameters, Property, Value);
EndProcedure

Function AddRow(Wrapper, Table) Export
	Return Undefined;
EndFunction

Function SetRowProperty(Wrapper, Row, Property, Value) Export
	Return Undefined;
EndFunction

Function Write(Wrapper, WriteMode = Undefined, PostingMode = Undefined) Export
	Doc = Documents[Wrapper._DocumentMetadata_.Name].CreateDocument();
	FillPropertyValues(Doc, Wrapper.Object, , "Number");
	For Each Table In Wrapper._DocumentMetadata_.TabularSections Do
		Doc[Table.Name].Load(Wrapper.Object[Table.Name]);
	EndDo;
	Doc.Write(?(WriteMode = Undefined, DocumentWriteMode.Write, WriteMode),
		?(PostingMode = Undefined , DocumentPostingMode.Regular , PostingMode));
	Return Doc.Ref;
EndFunction



&AtClient
Procedure FillByDefault(Command)
	FillByDefaultAtServer();
EndProcedure

&AtServer
Procedure FillByDefaultAtServer()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SystemAttributesSets.Ref,
	|	SystemAttributesSets.PredefinedDataName
	|FROM
	|	Catalog.SystemAttributesSets AS SystemAttributesSets
	|WHERE
	|	NOT SystemAttributesSets.DeletionMark
	|	AND SystemAttributesSets.Predefined";
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		Obj = QuerySelection.Ref.GetObject();
		Obj.Attributes.Clear();
		
		DocMetadata = Metadata.Documents[StrSplit(QuerySelection.PredefinedDataName ,"_")[1]];
		If DocMetadata.TabularSections.Find("ItemList") <> Undefined
			And DocMetadata.TabularSections.ItemList.Attributes.Find("Store") <> Undefined Then
			
			NewRow = Obj.Attributes.Add();
			NewRow.Attribute = ChartsOfCharacteristicTypes.SystemAttributes.Store;
			NewRow.Collection = True;
		EndIf;
		
		Obj.Write();
	EndDo;	
EndProcedure

&AtClient
Procedure UpdateRegister(Command)
	UpdateRegisterAtServer();
EndProcedure

&AtServer
Procedure UpdateRegisterAtServer()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SystemAttributesSets.Ref,
	|	SystemAttributesSets.PredefinedDataName
	|FROM
	|	Catalog.SystemAttributesSets AS SystemAttributesSets
	|WHERE
	|	NOT SystemAttributesSets.DeletionMark
	|	AND SystemAttributesSets.Predefined";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		NameSegments = StrSplit(QuerySelection.PredefinedDataName, "_");
		DocMetadataFullName = NameSegments[0] + "." + NameSegments[1];
		DocMetadataName = NameSegments[1];
		
		ArrayOfAttributes = SystemAttributesServer.GetSystemAttributes(DocMetadataFullName);
		
		QueryDoc = New Query();
		QueryDoc.Text = 
		"SELECT
		|	Doc.Ref
		|FROM
		|	Document.%1 AS Doc";
		QueryDoc.Text = StrTemplate(QueryDoc.Text, DocMetadataName);
		QueryDocResult = QueryDoc.Execute();
		QueryDocSelection = QueryDocResult.Select();
		
		While QueryDocSelection.Next() Do
		
			RecordSet = InformationRegisters.SystemAttributes.CreateRecordSet();
			RecordSet.Filter.Object.Set(QueryDocSelection.Ref);
	
			For Each Attr In ArrayOfAttributes Do
				Values = Documents[DocMetadataName].GetSystemAttributeValues(QueryDocSelection.Ref, Attr);
		
				If Values = Undefined Then
					Continue;
				EndIf;
			
				ValueTable = New ValueTable();
				ValueTable.Columns.Add("Value");
				For Each Value In Values Do
					ValueTable.Add().Value = Value;
				EndDo;
				ValueTable.GroupBy("Value");
				
				LineNumber = 1;
				For Each TableRow In ValueTable Do
					If Not ValueIsFilled(TableRow.Value) Then
						Continue;
					EndIf;
					Record = RecordSet.Add();
					Record.Object = QueryDocSelection.Ref;
					Record.Property = Attr;
					Record.Key = LineNumber;
					Record.Value = TableRow.Value;
					LineNumber = LineNumber + 1;
				EndDo;
			EndDo;
			RecordSet.AdditionalProperties.Insert("SystemRecord", True);
			RecordSet.Write();		
		EndDo;		
	EndDo;
EndProcedure



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

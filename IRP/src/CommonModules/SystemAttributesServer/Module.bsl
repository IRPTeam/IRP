
Procedure OnWrite_SystemAttributesOnWrite(Source, Cancel) Export
	SetPrivilegedMode(True);
		
	ArrayOfAttributes = GetSystemAttributes(Source.Metadata().FullName());
	
	RecordSet = InformationRegisters.SystemAttributes.CreateRecordSet();
	RecordSet.Filter.Object.Set(Source.Ref);
	
	For Each Attr In ArrayOfAttributes Do
		Values = Documents[Source.Metadata().Name].GetSystemAttributeValues(Source, Attr);
		
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
			Record.Object = Source.Ref;
			Record.Property = Attr;
			Record.Key = LineNumber;
			Record.Value = TableRow.Value;
			LineNumber = LineNumber + 1;
		EndDo;

	EndDo;
	
	RecordSet.AdditionalProperties.Insert("SystemRecord", True);
	RecordSet.Write();
EndProcedure

Procedure OutputSystemAttributes(Form, PlaceInFront = "", ListName = "List") Export
	ArrayOfSystemAttributes = GetSystemAttributes(Form[ListName].MainTable);
	For Each Attr In ArrayOfSystemAttributes Do
		AttrPresentation = String(Attr); 
		If ValueIsFilled(PlaceInFront) Then
			NewColumn = Form.Items.Insert(Attr.PredefinedDataName, Type("FormField"), Form.Items[ListName], Form.Items[PlaceInFront]);
		Else
			NewColumn = Form.Items.Add(Attr.PredefinedDataName, Type("FormField"), Form.Items[ListName]);
		EndIf;
		
		If StrFind(AttrPresentation, " ") = 0 Then
			NewColumn.DataPath = "List.Ref." + AttrPresentation;
		Else
			NewColumn.DataPath = "List.Ref.[" + AttrPresentation +"]";
		EndIf;
		
		NewColumn.Title = AttrPresentation;
		NewColumn.Visible = True;
	EndDo;
Endprocedure

Function GetSystemAttributes(MetadataFullName) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SystemAttributesSets.Ref
	|FROM
	|	Catalog.SystemAttributesSets AS SystemAttributesSets
	|WHERE
	|	SystemAttributesSets.PredefinedDataName = &PredefinedDataName
	|	AND NOT SystemAttributesSets.DeletionMark";
	Query.SetParameter("PredefinedDataName", StrReplace(MetadataFullName, ".", "_"));
	Try // temp
		QueryResult = Query.Execute();
	Except
		Return New Array();
	EndTry;
	QueryTable = QueryResult.Unload();
	
	ArrayOfAttributes = New Array();
	
	If QueryTable.Count() = 1 Then
		For Each Row In QueryTable[0].Ref.Attributes Do
			ArrayOfAttributes.Add(Row.Attribute);
		EndDo;
	EndIf;
	
	Return ArrayOfAttributes;
EndFunction

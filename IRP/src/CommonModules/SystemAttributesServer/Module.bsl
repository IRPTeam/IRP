
Procedure OnWrite_SystemAttributesOnWrite(Source, Cancel) Export
	SetPrivilegedMode(True);
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SystemAttributesSets.Ref
	|FROM
	|	Catalog.SystemAttributesSets AS SystemAttributesSets
	|WHERE
	|	SystemAttributesSets.PredefinedDataName = &PredefinedDataName";
	Query.SetParameter("PredefinedDataName", StrReplace(Source.Metadata().FullName(), ".", "_"));
	Try // temp
	QueryResult = Query.Execute();
	Except
		Return;
	EndTry;
	QuerySelection = QueryResult.Select();
	
	RecordSet = InformationRegisters.SystemAttributes.CreateRecordSet();
	RecordSet.Filter.Object.Set(Source.Ref);
	
	If QuerySelection.Next() Then
		For Each Row In QuerySelection.Ref.Attributes Do
			Values = Documents[Source.Metadata().Name].GetSystemAttributeValues(Source, Row.Attribute);
			
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
				Record.Property = Row.Attribute;
				Record.Key = LineNumber;
				Record.Value = TableRow.Value;
				LineNumber = LineNumber + 1;
			EndDo;

		EndDo;
	EndIf;
	
	RecordSet.AdditionalProperties.Insert("SystemRecord", True);
	RecordSet.Write();
EndProcedure

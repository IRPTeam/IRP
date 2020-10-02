
Procedure BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters) Export
	TransferParameters = New Structure();
	TransferParameters.Insert("Unmarked", True);
	TransferParameters.Insert("Posted", True);
	If Parameters.Property("Filter") Then
		For Each KeyValue In Parameters.Filter Do
			TransferParameters.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
	EndIf;
	ArrayOfFilterFromCurrentData = StrSplit(Parameters.FilterFromCurrentData, ",");
	For Each ItemOfFilterFromCurrentData In ArrayOfFilterFromCurrentData Do
		If ValueIsFilled(CurrentData[TrimAll(ItemOfFilterFromCurrentData)]) Then
			TransferParameters.Insert(ItemOfFilterFromCurrentData, CurrentData[TrimAll(ItemOfFilterFromCurrentData)]);
		EndIf;
	EndDo;
		
	FilterStructure = CreateFilterByParameters(TransferParameters, Parameters.TableName);
	FormParameters = New Structure("CustomFilter", FilterStructure);
	
	OpenForm("DocumentJournal." + Parameters.TableName + ".Form.ChoiceForm",
		FormParameters,
		Item,
		Form.UUID,
		,
		Form.URL,
		Parameters.Notify,
		FormWindowOpeningMode.LockWholeInterface);
EndProcedure

Function CreateFilterByParameters(Parameters, TableName)
	
	QueryParameters = New Structure;
	QueryTextArray = New Array;
	QueryText = "SELECT ALLOWED
		|	Obj.Ref,
		|	Obj.Ref.Company AS Company,
		|	Obj.Ref.Partner AS Partner,
		|	Obj.Ref.LegalName AS LegalName,
		|	Obj.Ref.Agreement AS Agreement,
		|	Obj.Ref.DocumentAmount AS DocumentAmount
		|FROM
		|	DocumentJournal.%1 AS Obj
		|WHERE
		|	True";
	QueryTextArray.Add(StrTemplate(QueryText,TableName));
	If Parameters.Property("Type") Then
		QueryParameters.Insert("Type", Parameters.Type);
		QueryTextArray.Add("
			|	AND Obj.Type = &Type");
	EndIf;
	
	If Parameters.Property("Unmarked") Then
		QueryParameters.Insert("Unmarked", Parameters.Unmarked);
		QueryTextArray.Add("
			|	AND NOT Obj.DeletionMark = &Unmarked");
	EndIf;
	
	If Parameters.Property("Partner") Then
		QueryParameters.Insert("Partner", Parameters.Partner);
		QueryTextArray.Add("
			|	AND Obj.Ref.Partner = &Partner");
	EndIf;
	
	If Parameters.Property("LegalName") Then
		QueryParameters.Insert("LegalName", Parameters.LegalName);
		QueryTextArray.Add("
			|	AND Obj.Ref.LegalName = &LegalName");
	EndIf;
	
	If Parameters.Property("Agreement") Then
		QueryParameters.Insert("Agreement", Parameters.Agreement);
		QueryTextArray.Add("
			|	AND Obj.Ref.Agreement = &Agreement");
	EndIf;
	
	If Parameters.Property("Company") Then
		QueryParameters.Insert("Company", Parameters.Company);
		QueryTextArray.Add("
			|	AND Obj.Ref.Company = &Company");
	EndIf;
	
	If Parameters.Property("Agreement_ApArPostingDetail") Then
		QueryParameters.Insert("Agreement_ApArPostingDetail", Parameters.Agreement_ApArPostingDetail);
		QueryTextArray.Add("
			|	AND Obj.Ref.Agreement.ApArPostingDetail = &Agreement_ApArPostingDetail");
	EndIf;
	
	If Parameters.Property("Posted") Then
		QueryParameters.Insert("Posted", Parameters.Posted);
		QueryTextArray.Add("
			|	AND Obj.Ref.Posted = &Posted");
	EndIf;
	
	ListQueryText = StrConcat(QueryTextArray);
	
	FilterStructure = New Structure;
	FilterStructure.Insert("QueryText", ListQueryText);
	FilterStructure.Insert("QueryParameters", QueryParameters);
	
	Return FilterStructure;
EndFunction
Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export

	CustomFilter = Undefined;
	If Parameters.Property("CustomFilter", CustomFilter) Then
		Form.List.CustomQuery = True;
		Form.List.QueryText = CustomFilter.QueryText;
		For Each QueryParameter In CustomFilter.QueryParameters Do
			Form.List.Parameters.SetParameterValue(QueryParameter.Key, QueryParameter.Value);
		EndDo;
	EndIf;
EndProcedure

Function CreateFilterByParameters(Parameters) Export
	
	QueryParameters = New Structure;
	QueryTextArray = New Array;
	
	QueryTextArray.Add("SELECT ALLOWED
		|	Obj.Ref,
		|	Obj.Ref.Company AS Company,
		|	Obj.Ref.Partner AS Partner,
		|	Obj.Ref.LegalName AS LegalName,
		|	Obj.Ref.DocumentAmount AS DocumentAmount
		|FROM
		|	DocumentJournal.DocumentsForOutgoingPayment AS Obj
		|WHERE
		|	True");
	
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
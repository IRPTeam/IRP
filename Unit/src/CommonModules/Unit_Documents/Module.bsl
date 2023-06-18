
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("DocumentManagerCheck");	
	Return TestList;
EndFunction

#EndRegion

#Region Document

Function DocumentManagerCheck() Export
	ArrayOfErrors = New Array();
	
	ArrayOfExclude = GetExclude_Documents();
	
	For Each Doc In Metadata.Documents Do
		If ArrayOfExclude.Find(Doc.FullName()) <> Undefined Then
			Continue;
		EndIf;
			
		EmptyRef = Documents[Doc.Name].EmptyRef();			
		Try
			Documents[Doc.Name].GetPrintForm(EmptyRef, "");
		Except
			ArrayOfErrors.Add("GetPrintForm error:" + Doc.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
		
		Try
			Documents[Doc.Name].GetInformationAboutMovements(EmptyRef);
		Except
			ArrayOfErrors.Add("GetInformationAboutMovements error:" + Doc.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
		
		Try
			Documents[Doc.Name].GetAccessKey(EmptyRef);
		Except
			ArrayOfErrors.Add("GetAccessKey error:" + Doc.FullName());
			ArrayOfErrors.Add(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			ArrayOfErrors.Add("--------------------------");
			ArrayOfErrors.Add();
		EndTry;
		
	EndDo;		
		
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse(StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function GetExclude_Documents()
	ArrayOfExcluded = New Array();
	Return ArrayOfExcluded;
EndFunction

#EndRegion

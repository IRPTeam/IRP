
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("CatalogCodeIsNumber12");	
	Return TestList;
EndFunction

#EndRegion

#Region Test

Function CatalogCodeIsNumber12() Export
	ArrayOfErrors = New Array();
	
	ArrayOfExclude = GetExclude_Catalogs();
	
	For Each Cat In Metadata.Catalogs Do
		If ArrayOfExclude.Find(Cat.FullName()) <> Undefined Then
			Continue;
		EndIf;
			
		If Cat.CodeType <> Metadata.ObjectProperties.CatalogCodeType.Number Then
			ArrayOfErrors.Add("Wrong type, should be Number: " + Cat.FullName());
			Continue;
		EndIf;
		If Cat.CodeLength <> 12 Then
			ArrayOfErrors.Add("Wrong lenght, should be 12: " + Cat.FullName());
		EndIf;
	EndDo;		
		
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Wrong catalog code: " + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function GetExclude_Catalogs()
	ArrayOfExcluded = New Array();
	ArrayOfExcluded.Add("Catalog.Currencies");
	ArrayOfExcluded.Add("Catalog.MovementRules");
	ArrayOfExcluded.Add("Catalog.ReportOptions");
	ArrayOfExcluded.Add("Catalog.RetailCustomers");
	Return ArrayOfExcluded;
EndFunction

#EndRegion
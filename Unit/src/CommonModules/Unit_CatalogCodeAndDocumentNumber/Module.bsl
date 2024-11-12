
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("CatalogCodeIsNumber12");	
	TestList.Add("DocumentCodeIsNumber12");	
	Return TestList;
EndFunction

#EndRegion

#Region Document

Function DocumentCodeIsNumber12() Export
	ArrayOfErrors = New Array();
	
	ArrayOfExclude = GetExclude_Documents();
	
	For Each Doc In Metadata.Documents Do
		If ArrayOfExclude.Find(Doc.FullName()) <> Undefined Then
			Continue;
		EndIf;
			
		If Doc.NumberType <> Metadata.ObjectProperties.DocumentNumberType.Number Then
			ArrayOfErrors.Add("Wrong type, should be Number: " + Doc.FullName());
			Continue;
		EndIf;
		If Doc.NumberLength <> 12 Then
			ArrayOfErrors.Add("Wrong lenght, should be 12: " + Doc.FullName());
		EndIf;
	EndDo;		
		
	If ArrayOfErrors.Count() Then
		Unit_Service.assertFalse("Wrong document code: " + Chars.LF +
			StrConcat(ArrayOfErrors, Chars.LF));
	EndIf;
	Return "";
EndFunction

Function GetExclude_Documents()
	ArrayOfExcluded = New Array();
	Return ArrayOfExcluded;
EndFunction

#EndRegion

#Region Catalogs

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
	ArrayOfExcluded.Add("Catalog.AccessKey");
	ArrayOfExcluded.Add("Catalog.Currencies");
	ArrayOfExcluded.Add("Catalog.MovementRules");
	ArrayOfExcluded.Add("Catalog.ReportOptions");
	ArrayOfExcluded.Add("Catalog.RetailCustomers");
	ArrayOfExcluded.Add("Catalog.ExternalFunctions");
	ArrayOfExcluded.Add("Catalog.ObjectAccessKeys");
	ArrayOfExcluded.Add("Catalog.Incoterms");
	ArrayOfExcluded.Add("Catalog.TR_Cities");
	ArrayOfExcluded.Add("Catalog.TR_CitySubdivisions");
	ArrayOfExcluded.Add("Catalog.TR_ESF_Address");
	ArrayOfExcluded.Add("Catalog.TR_ESF_DeliveryTerms");
	ArrayOfExcluded.Add("Catalog.TR_ESF_eFaturaXSLT");
	ArrayOfExcluded.Add("Catalog.TR_ESF_ePrefix");
	ArrayOfExcluded.Add("Catalog.TR_ESF_ItemCustomsCodes");
	ArrayOfExcluded.Add("Catalog.TR_ESF_TaxExemptionReasons");
	ArrayOfExcluded.Add("Catalog.TR_ESF_TransportModes");
	ArrayOfExcluded.Add("Catalog.TR_TaxAuthorities");
	ArrayOfExcluded.Add("Catalog.Unit_ErrorTypes");
	Return ArrayOfExcluded;
EndFunction

#EndRegion
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure

&AtClient
Procedure FillDefaultDescriptions(Command)
	FillDefaultDescriptionsAtServer();
EndProcedure

&AtServer
Procedure FillDefaultDescriptionsAtServer()
	Query = New Query;
	Query.Text =
		"SELECT
		|	AddAttributeAndPropertySets.Ref
		|FROM
		|	Catalog.AddAttributeAndPropertySets AS AddAttributeAndPropertySets";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		Obj = SelectionDetailRecords.Ref.GetObject(); // CatalogObject.AddAttributeAndPropertySets
		CurrentUserLang = ?(IsBlankString(SessionParameters.LocalizationCode), "en", SessionParameters.LocalizationCode);
		
		DataType = Metadata.FindByFullName(StrReplace(Obj.PredefinedDataName, "_", "."));
		
		If DataType = Undefined Then
			Continue;
		EndIf;
		
		Obj["Description_" + CurrentUserLang] = DataType.Synonym;
		
		Obj.Write();
	EndDo;
EndProcedure

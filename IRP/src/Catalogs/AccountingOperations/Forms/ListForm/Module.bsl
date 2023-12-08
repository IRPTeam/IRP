

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
EndProcedure

&AtClient
Procedure FillDefaultDescriptions(Command)
	FillDefaultDescriptionsAtServer()
EndProcedure

&AtServer
Procedure FillDefaultDescriptionsAtServer()
	Query = New Query;
	Query.Text =
	"SELECT
	|	AccountingOperations.Ref
	|FROM
	|	Catalog.AccountingOperations AS AccountingOperations";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		Obj = QuerySelection.Ref.GetObject();
		CurrentUserLang = ?(IsBlankString(SessionParameters.LocalizationCode), "en", SessionParameters.LocalizationCode);
		DataType = Metadata.FindByFullName(StrReplace(Obj.PredefinedDataName, "_", "."));
		
		If DataType <> Undefined Then
			Obj["Description_" + CurrentUserLang] = DataType.Synonym;
			Obj.Write();
			Continue;
		EndIf;

		ArrayOfPrefix = New Array();
		ArrayOfPrefix.Add("en");
		ArrayOfPrefix.Add("ru");
		ArrayOfPrefix.Add("tr");
	
		For Each Prefix In ArrayOfPrefix Do
			If R(CurrentUserLang).Property(Obj.PredefinedDataName) Then
				Obj["Description_" + CurrentUserLang] = R(CurrentUserLang)[Obj.PredefinedDataName];
				Obj.Write();
			EndIf;
		EndDo;
		
	EndDo;
EndProcedure

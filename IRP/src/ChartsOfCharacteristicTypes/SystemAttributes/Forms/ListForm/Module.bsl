
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ChartsOfCharacteristicTypesServer.OnCreateAtServerListForm(ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure FillDefaultDescriptions(Command)
	FillDefaultDescriptionsAtServer();
	ThisObject.Items.List.Refresh();
EndProcedure

&AtServer
Procedure FillDefaultDescriptionsAtServer()
	Query = New Query;
	Query.Text =
	"SELECT
	|	SystemAttributes.Ref
	|FROM
	|	ChartOfCharacteristicTypes.SystemAttributes AS SystemAttributes";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Langs = New Array();
	For Each Attr In Metadata.CommonAttributes Do
		If StrStartsWith(Attr.Name, "Description_") Then
			Langs.Add(StrReplace(Attr.Name, "Description_", ""));
		EndIf;
	EndDo;
	
	While QuerySelection.Next() Do
		Obj = QuerySelection.Ref.GetObject();
		
		For Each Lang In Langs Do
			If Upper(Lang) = Upper("hash") Then
				Continue;
			EndIf;
			Obj["Description_" + Lang] = 
				LocalizationReuse.Strings(Lang)["SystemAttribute_" + Obj.PredefinedDataName];
			Obj.Write();
		EndDo;
	EndDo;
EndProcedure

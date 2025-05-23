
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
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SystemAttributes.Ref,
	|	SystemAttributes.PredefinedDataName
	|FROM
	|	ChartOfCharacteristicTypes.SystemAttributes AS SystemAttributes
	|WHERE
	|	SystemAttributes.Predefined";
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		ChartsOfCharacteristicTypes.SystemAttributes.UpdatePredefinedNames(QuerySelection.PredefinedDataName);
	EndDo;

EndProcedure

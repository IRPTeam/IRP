&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	If Parameters.Filter.Property("CustomFilterByItem") Then
		ThisObject.CustomFilterByItem = Parameters.Filter.CustomFilterByItem;
	EndIf;
	UpdateFiltersInList();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAvailableSpecificationsByItem" Then
		UpdateFiltersInList();
	EndIf;
EndProcedure

&AtServer
Procedure UpdateFiltersInList()
	If ThisObject.CustomFilterByItem <> Undefined Then
		ThisObject.List.Filter.Items.Clear();
		FilterItem = ThisObject.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
		FilterItem.LeftValue = New DataCompositionField("Ref");
		FilterItem.ComparisonType = DataCompositionComparisonType.InList;
		FilterItem.RightValue = Catalogs.Specifications.GetAvailableSpecificationsByItem(ThisObject.CustomFilterByItem);
	EndIf;
EndProcedure
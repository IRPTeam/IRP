&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ParentOnChange(Item)
	Return;
EndProcedure

&AtClient
Procedure NextPossibleStatusesStatusStartChoice(Item, ChoiceData, StandardProcessing)
	ObjectStatusesClient.StatusStartChoice(Object,
	                                       ThisObject,
	                                       GetArrayOfFilters(),
	                                       Item,
	                                       ChoiceData,
	                                       StandardProcessing);
EndProcedure

&AtClient
Procedure NextPossibleStatusesStatusEditTextChange(Item, Text, StandardProcessing)
	ObjectStatusesClient.StatusEditTextChange(Object,
	                                          ThisObject,
	                                          GetArrayOfFilters(),
	                                          New Structure(),
	                                          Item,
	                                          Text,
	                                          StandardProcessing);
EndProcedure

&AtClient
Function GetArrayOfFilters()
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", Object.Parent, DataCompositionComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", Object.Ref, DataCompositionComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFolder", False, DataCompositionComparisonType.Equal));
	Return ArrayOfFilters;
EndFunction
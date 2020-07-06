&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	SetVisible();
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ParentOnChange(Item)
	SetVisible();
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

&AtServer
Procedure SetVisible()
	IsIncomingCheque = (Object.Parent = Catalogs.ObjectStatuses.ChequeBondIncoming)
		Or (Object.Parent = Catalogs.ObjectStatuses.ChequeBondOutgoing);
	
	Items.GroupPagesCheque.Visible = IsIncomingCheque;
	Items.Posting.Visible = Not IsIncomingCheque;
EndProcedure

&AtClient
Function GetArrayOfFilters()
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", Object.Parent, DataCompositionComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", Object.Ref, DataCompositionComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFolder", False, DataCompositionComparisonType.Equal));
	Return ArrayOfFilters;
EndFunction


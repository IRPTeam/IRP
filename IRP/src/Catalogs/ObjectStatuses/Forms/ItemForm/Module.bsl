&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsCheque = 
	Object.Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondIncoming")
	Or Object.Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondOutgoing");
	
	IsProductionPlanningCorrection = Object.Parent = PredefinedValue("Catalog.ObjectStatuses.ProductionPlanningCorrection");
	
	Form.Items.GroupPosting.Visible = IsCheque;
	Form.Items.GroupUsers.Visible = IsProductionPlanningCorrection;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ParentOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure NextPossibleStatusesStatusStartChoice(Item, ChoiceData, StandardProcessing)
	ObjectStatusesClient.StatusStartChoice(Object, ThisObject, GetArrayOfFilters(), Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure NextPossibleStatusesStatusEditTextChange(Item, Text, StandardProcessing)
	ObjectStatusesClient.StatusEditTextChange(Object, ThisObject, GetArrayOfFilters(), New Structure(), Item, Text, StandardProcessing);
EndProcedure

&AtClient
Function GetArrayOfFilters()
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent"   , Object.Parent, DataCompositionComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref"      , Object.Ref, DataCompositionComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFolder" , False, DataCompositionComparisonType.Equal));
	Return ArrayOfFilters;
EndFunction

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion

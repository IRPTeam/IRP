#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Object.Ref.IsEmpty() Then
		Items.GroupContent.Visible = False;
	Else
		SegmentParameter = ContentSegment.Parameters.Items.Find("Segment");
		SegmentParameter.Value = Object.Ref;
		SegmentParameter.Use = True;
	EndIf;
	
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure Check(Command)
	CheckAtServer(Object.Ref);
	Items.ContentSegment.Refresh();
EndProcedure

&AtServerNoContext
Procedure CheckAtServer(Segment)
	Catalogs.ItemSegments.CheckContent(Segment);
EndProcedure

&AtClient
Procedure ContentSegmentBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	
	FillingValues = New Structure;
	FillingValues.Insert("Segment", Object.Ref);
	If Clone And Items.ContentSegment.CurrentData <> Undefined Then
		FillingValues.Insert("Item", Items.ContentSegment.CurrentData.Item);
		FillingValues.Insert("ItemKey", Items.ContentSegment.CurrentData.ItemKey);
	EndIf;
	FormParameters = New Structure("FillingValues", FillingValues);
	
	OpenForm("InformationRegister.ItemSegments.RecordForm", FormParameters,,,,, 
		New NotifyDescription("AddRowFinish", ThisObject));
EndProcedure

&AtClient
Procedure AddRowFinish(Result, AddInfo) Export
	Items.ContentSegment.Refresh();
EndProcedure
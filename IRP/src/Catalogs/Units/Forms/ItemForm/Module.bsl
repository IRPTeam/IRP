
#Region FormEvents

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

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtClient
Procedure SizeOnChange(Item)
	CommonFunctionsClientServer.CalculateVolume(Object);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	LockFormAttribute(True);
EndProcedure
#EndRegion

#Region FormItemsEvent
&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure UnlockAttribute(Command)
	UnlockAttributeAtServer();
EndProcedure
#EndRegion

#Region Private

#Region LockAttributes
&AtServer
Procedure UnlockAttributeAtServer()
	LockAttribute = LockDataModificationPriveleged.IsLockFormAttribute(Object.Ref);
	LockFormAttribute(LockAttribute);
EndProcedure

&AtServer
Function ListLockAttribute()
	Array = New Array;
	Array.Add("Item");
	Array.Add("BasisUnit");
	Array.Add("Quantity");
	Return Array;
EndFunction

&AtServer
Procedure LockFormAttribute(LockAttribute)
	For Each Attr In ListLockAttribute() Do
		Items[Attr].ReadOnly = LockAttribute;
	EndDo;
EndProcedure
#EndRegion

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

#EndRegion
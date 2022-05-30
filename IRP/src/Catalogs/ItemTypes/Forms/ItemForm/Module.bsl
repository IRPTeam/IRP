#Region FormEvents

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("UpdateAddAttributeAndPropertySets", New Structure(), ThisObject);
	Notify("UpdateTypeOfItemType", New Structure(), ThisObject);
	Notify("UpdateAffectPricing", New Structure(), ThisObject);
	Notify("UpdateAffectPricingMD5", New Structure(), ThisObject);
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

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupMainPages);
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
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	If Object.Type = PredefinedValue("Enum.ItemTypes.Service") Then
		Object.UseSerialLotNumber = False;
		Object.StockBalanceDetail = PredefinedValue("Enum.StockBalanceDetail.ByItemKey");
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure UseSerialLotNumberOnChange(Item)
	If Not Object.UseSerialLotNumber Then
		Object.StockBalanceDetail = PredefinedValue("Enum.StockBalanceDetail.ByItemKey");
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	VisibleOfSerialLotNumber = (Object.Type = PredefinedValue("Enum.ItemTypes.Product"));
	Form.Items.UseSerialLotNumber.Visible  = VisibleOfSerialLotNumber;
	Form.Items.StockBalanceDetail.Visible = VisibleOfSerialLotNumber;
	If VisibleOfSerialLotNumber Then
		Form.Items.StockBalanceDetail.ReadOnly = Not Object.UseSerialLotNumber;
	EndIf;
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

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
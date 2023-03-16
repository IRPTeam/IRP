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
		Object.SingleRow = False;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure SingleRowOnChange(Item)
	If Object.SingleRow Then
		Object.AlwaysAddNewRowAfterScan = True;
		Object.UseLineGrouping = False;
		Object.UseQuantityLimit = False;
	EndIf; 
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure AlwaysAddNewRowAfterScanOnChange(Item)
	If Object.AlwaysAddNewRowAfterScan Then
		Object.UseLineGrouping = False;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure UseQuantityLimitOnChange(Item)
	If Object.UseQuantityLimit Then
		Object.UseLineGrouping = False;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsProduct = (Object.Type = PredefinedValue("Enum.ItemTypes.Product"));
	Form.Items.UseSerialLotNumber.ReadOnly = Not IsProduct;
	Form.Items.PageSerialLotNumbersSettings.Visible = IsProduct And Object.UseSerialLotNumber;
	Form.Items.StockBalanceDetail.ReadOnly = Not Object.UseSerialLotNumber;
	Form.Items.AlwaysAddNewRowAfterScan.ReadOnly = IsProduct And Object.UseSerialLotNumber And Object.SingleRow;
	
	Form.Items.UseQuantityLimit.ReadOnly = Object.SingleRow;
	Form.Items.QuantityLimit.Visible = Object.UseQuantityLimit And Not Object.SingleRow;
	
	Form.Items.UseLineGrouping.ReadOnly = Object.SingleRow 
		Or Object.AlwaysAddNewRowAfterScan
		Or Object.UseQuantityLimit;
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
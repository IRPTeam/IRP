#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	Params = New Structure();
	Params.Insert("ItemKey", ItemKey);
	Params.Insert("SerialLotNumber", CurrentObject.Ref);
	BarcodeServer.UpdateBarcode(Barcode, Params);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	FillParamsOnCreate();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	OwnerSelectChange();
EndProcedure

&AtClient
Procedure OwnerSelectOnChange(Item)
	OwnerSelectChange();
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

#EndRegion

#Region Private

&AtClient
Procedure OwnerSelectChange()
	Items.Owner.Visible = OwnerSelect = "Manual";
	If Not OwnerSelect = "Manual" Then
		Object.SerialLotNumberOwner = ThisObject[OwnerSelect];
	EndIf;
EndProcedure
&AtServer
Procedure FillParamsOnCreate()
	OwnerSelect = "Manual";

	If Not Parameters.ItemType.IsEmpty() Then
		ItemType = Parameters.ItemType;
		Items.OwnerSelect.ChoiceList.Add("ItemType", ItemType);
		OwnerSelect = "ItemType";
	EndIf;
	If Not Parameters.Item.IsEmpty() Then
		Item = Parameters.Item;
		Items.OwnerSelect.ChoiceList.Add("Item", Item);
		OwnerSelect = "Item";
	EndIf;
	If Not Parameters.ItemKey.IsEmpty() Then
		ItemKey = Parameters.ItemKey;
		Items.OwnerSelect.ChoiceList.Add("ItemKey", ItemKey);
		OwnerSelect = "ItemKey";
	EndIf;
	If Not IsBlankString(Parameters.Barcode) Then
		Barcode = Parameters.Barcode;
		Object.Description = Barcode;
	EndIf;
	// delete manual, if have other types
	If Items.OwnerSelect.ChoiceList.Count() > 1 Then
		Items.OwnerSelect.ChoiceList.Delete(0);
	EndIf;
EndProcedure
#EndRegion
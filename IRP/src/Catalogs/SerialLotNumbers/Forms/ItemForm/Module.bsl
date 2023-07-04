#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	Params = New Structure();
	Params.Insert("ItemKey", ThisObject.ItemKey);
	Params.Insert("SerialLotNumber", CurrentObject.Ref);
	BarcodeServer.UpdateBarcode(ThisObject.Barcode, Params);
	SetVisibilityAvailability(CurrentObject, ThisObject);
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
	If Parameters.Key.IsEmpty() Then
		FillParamsOnCreate();
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.Owner.Visible = Form.OwnerSelect = "Manual";
	Form.Items.CreateBarcodeWithSerialLotNumber.Visible = Not ValueIsFilled(Object.Ref);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ThisObject.OwnerSelect = "Manual";
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	If ThisObject.CreateBarcodeWithSerialLotNumber And Not Parameters.ItemKey.IsEmpty() And OwnerSelect = "ItemKey" Then
		Option = New Structure();
		Option.Insert("ItemKey", ItemKey);
		Option.Insert("SerialLotNumber", Object.Ref);
		BarcodeServer.UpdateBarcode(TrimAll(Object.Description), Option);
	EndIf;
	ThisObject.CreateBarcodeWithSerialLotNumber = False;
EndProcedure

&AtClient
Procedure OwnerSelectOnChange(Item)
	UpdateAttributesByOwner();
EndProcedure

&AtClient
Procedure OwnerOnChange(Item)
	UpdateAttributesByOwner();
EndProcedure

&AtClient
Procedure UpdateAttributesByOwner()
	If OwnerSelect <> "Manual" Then
		Object.SerialLotNumberOwner = ThisObject[OwnerSelect];
	EndIf;
	
	OwnerInfo = GetOwnerInfo(Object.SerialLotNumberOwner);
	Object.StockBalanceDetail          = OwnerInfo.StockBalanceDetail;
	Object.EachSerialLotNumberIsUnique = OwnerInfo.EachSerialLotNumberIsUnique;
EndProcedure

&AtServerNoContext
Function GetOwnerInfo(OwnerRef)
	Result = New Structure();
	Result.Insert("StockBalanceDetail", Undefined);
	Result.Insert("EachSerialLotNumberIsUnique", False);
	
	If Not ValueIsFilled(OwnerRef) Then
		Return Result;
	EndIf;
	
	Result.StockBalanceDetail = SerialLotNumbersServer.GetStockBalanceDetailByOwner(OwnerRef);
	Result.EachSerialLotNumberIsUnique = SerialLotNumbersServer.isEachSerialLotNumberIsUniqueByOwner(OwnerRef);
	
	Return Result;
EndFunction

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

&AtServer
Procedure FillParamsOnCreate()
	ThisObject.OwnerSelect = "Manual";

	If Not Parameters.ItemType.IsEmpty() Then
		ThisObject.ItemType = Parameters.ItemType;
		Object.SerialLotNumberOwner = Parameters.ItemType;
		Items.OwnerSelect.ChoiceList.Add("ItemType", ItemType);
		ThisObject.OwnerSelect = "ItemType";
	EndIf;
	
	If Not Parameters.Item.IsEmpty() Then
		ThisObject.Item = Parameters.Item;
		Object.SerialLotNumberOwner = Parameters.Item;
		Items.OwnerSelect.ChoiceList.Add("Item", Item);
		ThisObject.OwnerSelect = "Item";
	EndIf;
	
	If Not Parameters.ItemKey.IsEmpty() Then
		ThisObject.ItemKey = Parameters.ItemKey;
		Object.SerialLotNumberOwner = Parameters.ItemKey;
		Items.OwnerSelect.ChoiceList.Add("ItemKey", ItemKey);
		ThisObject.OwnerSelect = "ItemKey";
	EndIf;
	
	If Not IsBlankString(Parameters.Barcode) Then
		ThisObject.Barcode = Parameters.Barcode;
		Object.Description = ThisObject.Barcode;
	EndIf;
	
	If Not IsBlankString(Parameters.Description) Then
		Object.Description = Parameters.Description;
	EndIf;
	
	OwnerInfo = GetOwnerInfo(Object.SerialLotNumberOwner);
	Object.StockBalanceDetail          = OwnerInfo.StockBalanceDetail;
	Object.EachSerialLotNumberIsUnique = OwnerInfo.EachSerialLotNumberIsUnique;
	
	// delete manual, if have other types
	If Items.OwnerSelect.ChoiceList.Count() > 1 Then
		Items.OwnerSelect.ChoiceList.Delete(0);
	EndIf;
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, Exit, WarningText, StandardProcessing)
	Close(Object.Ref);
EndProcedure

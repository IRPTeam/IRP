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
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		FillParamsOnCreate();
		FillInheritConsignorsInfo();
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	
	IsUseCommissionTrading = FOServer.IsUseCommissionTrading();
	Items.ConsignorInfoMode.Visible = Items.ConsignorInfoMode.Visible And IsUseCommissionTrading;
	Items.InheritConsignorsInfo.Visible = Items.InheritConsignorsInfo.Visible And IsUseCommissionTrading;
	Items.ConsignorsInfo.Visible = Items.ConsignorsInfo.Visible And IsUseCommissionTrading;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.Owner.Visible = Form.OwnerSelect = "Manual";
	Form.Items.CreateBarcodeWithSerialLotNumber.Visible = Not ValueIsFilled(Object.Ref);
	
	Form.Items.GroupConsignorInfo.Visible = Form.UseConsignorInfo;
	
	If Not (TypeOf(Object.SerialLotNumberOwner) = Type("CatalogRef.Items") 
		Or TypeOf(Object.SerialLotNumberOwner) = Type("CatalogRef.ItemKeys")) Then
		Form.ConsignorInfoMode = "Own";
	EndIf;
		
	Form.Items.ConsignorsInfo.Visible = Form.ConsignorInfoMode = "Own";
	Form.Items.InheritConsignorsInfo.Visible = Form.ConsignorInfoMode = "Inherit";
	
	Form.Items.GroupRelatedSerialLotNumbers.Visible = Object.HasRelatedSerialLotNumbers;
	Form.Items.SourceOfOrigin.Visible = Object.EachSerialLotNumberIsUnique;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ThisObject.OwnerSelect = "Manual";
	FillInheritConsignorsInfo();
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
	FillInheritConsignorsInfo();
	SetVisibilityAvailability(Object, ThisObject);
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

&AtClient
Procedure HasRelatedSerialLotNumbersOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure EachSerialLotNumberIsUniqueOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);	
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

&AtClient
Procedure ConsignorInfoModeOnChange(Item)
	If ThisObject.ConsignorInfoMode = "Inherit" Then
		Object.ConsignorsInfo.Clear();
	Else // Onw
		Object.ConsignorsInfo.Clear();
		For Each Row In ThisObject.InheritConsignorsInfo Do
			NewRow = Object.ConsignorsInfo.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	EndIf;
	ThisObject.Modified = True;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure FillInheritConsignorsInfo()
	ThisObject.UseConsignorInfo = False;
	
	ThisObject.ConsignorInfoMode = ?(Object.ConsignorsInfo.Count()>0, "Own", "Inherit");
	
	_itemKey  = Catalogs.ItemKeys.EmptyRef();
	_item     = Catalogs.Items.EmptyRef();
	_itemType = Catalogs.ItemTypes.EmptyRef();
	
	If TypeOf(Object.SerialLotNumberOwner) = Type("CatalogRef.Items") Then
		_item     = Object.SerialLotNumberOwner;
		_itemType = Object.SerialLotNumberOwner.ItemType;
	EndIf;
	If TypeOf(Object.SerialLotNumberOwner) = Type("CatalogRef.ItemKeys") Then
		_itemKey  = Object.SerialLotNumberOwner;
		_Item     = _itemKey.Item;
		_itemType = _item.ItemType;
	EndIf;
		
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemKeysConsignorsInfo.Company AS Company,
	|	ItemKeysConsignorsInfo.Consignor AS Consignor,
	|	0 AS Priority
	|FROM
	|	Catalog.ItemKeys.ConsignorsInfo AS ItemKeysConsignorsInfo
	|WHERE
	|	ItemKeysConsignorsInfo.Ref = &RefItemKey
	|
	|UNION
	|
	|SELECT
	|	ItemsConsignorsInfo.Company,
	|	ItemsConsignorsInfo.Consignor,
	|	1
	|FROM
	|	Catalog.Items.ConsignorsInfo AS ItemsConsignorsInfo
	|WHERE
	|	ItemsConsignorsInfo.Ref = &RefItem";
	Query.SetParameter("RefItemKey", _itemKey);
	Query.SetParameter("RefItem"   , _item);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Table0 = QueryTable.Copy(New Structure("Priority", 0));
	Table1 = QueryTable.Copy(New Structure("Priority", 1));
	
	If Table0.Count() > 0 Then
		ThisObject.InheritConsignorsInfo.Load(Table0);
	ElsIf Table1.Count() > 0 Then
		ThisObject.InheritConsignorsInfo.Load(Table1);
	EndIf;	
	
	If ValueIsFilled(_itemType) Then
		ThisObject.UseConsignorInfo = _itemType.SingleRow;
	EndIf;	
EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion
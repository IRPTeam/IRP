
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocumentsServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	BuildForm();
	SetVisible();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPriceListClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	WriteSavedItems(Object, CurrentObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	If Object.PriceListType = Enums.PriceListTypes.PriceByItemKeys Then
		FillItemKeyList();
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAffectPricing" And Object.PriceListType = PredefinedValue("Enum.PriceListTypes.PriceByProperties") Then
		DrawFormTablePriceKeyList();
	EndIf;
	
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	BuildForm();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	If Object.PriceListType = Enums.PriceListTypes.PriceByProperties Then
		SaveTablePriceKeyList(Cancel, CurrentObject, WriteParameters);
	EndIf;
EndProcedure
#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure PriceTypeOnChange(Item)
	SetVisible();
EndProcedure
&AtClient
Procedure PriceListTypeOnChange(Item)
	BuildForm();
	SetVisible();
EndProcedure
#EndRegion

#Region FormTableItemsEventHandlers

#Region PriceKeyList

&AtClient
Procedure ItemTypeOnChange(Item)
	DrawFormTablePriceKeyList();
EndProcedure

&AtClient
Procedure PriceKeyListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPriceListClient.PriceKeyListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PriceKeyListItemEditTextChange(Item, Text, StandardProcessing)
	DocPriceListClient.PriceKeyListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PriceKeyListItemOnChange(Item)
	CurrentData = Items.PriceKeyList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.InputUnit = GetInputUnit(CurrentData.Item);
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);
EndProcedure

&AtClient
Procedure PriceKeyListInputPriceOnChange(Item)
	CurrentData = Items.PriceKeyList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);	
EndProcedure

&AtClient
Procedure PriceKeyListInputUnitOnChange(Item)
	CurrentData = Items.PriceKeyList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);	
EndProcedure

#EndRegion

#Region ItemKeyList

&AtClient
Procedure ItemKeyListOnStartEdit(Item, NewRow, Clone)
	CurrentData = ThisObject.Items.ItemKeyList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If NewRow Or Clone Then
		CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemKeyListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPriceListClient.ItemKeyListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemKeyListItemEditTextChange(Item, Text, StandardProcessing)
	DocPriceListClient.ItemKeyListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemKeyListItemKeyOnChange(Item)
	CurrentData = Items.ItemKeyList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.InputUnit = GetInputUnit(CurrentData.ItemKey);
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);
EndProcedure

&AtClient
Procedure ItemKeyListInputPriceOnChange(Item)
	CurrentData = Items.ItemKeyList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);	
EndProcedure

&AtClient
Procedure ItemKeyListInputUnitOnChange(Item)
	CurrentData = Items.ItemKeyList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);	
EndProcedure

#EndRegion

#Region ItemList

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPriceListClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPriceListClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.InputUnit = GetInputUnit(CurrentData.Item);
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);		
EndProcedure

&AtClient
Procedure ItemListInputPriceOnChange(Item)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);	
EndProcedure

&AtClient
Procedure ItemListInputUnitOnChange(Item)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.Price = CalculatePrice(CurrentData.InputPrice, CurrentData.InputUnit);	
EndProcedure

#EndRegion

&AtServer
Function GetInputUnit(Item_ItemKey)
	If TypeOf(Item_ItemKey) = Type("CatalogRef.Items") Then
		Return Item_ItemKey.Unit;
	ElsIf TypeOf(Item_ItemKey) = Type("CatalogRef.ItemKeys") Then
		If ValueIsFilled(Item_ItemKey.Unit) Then
			Return Item_ItemKey.Unit;
		Else
			Return Item_ItemKey.Item.Unit;
		EndIf;
	EndIf;
EndFunction

&AtServer
Function CalculatePrice(InputPrice, InputUnit)
	If Not ValueIsFilled(InputUnit) Or InputUnit.Quantity = 0 Then
		Return 0;
	EndIf;
	Return InputPrice / InputUnit.Quantity; 
EndFunction

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure FillByRules(Command)
	ExternalDataProc = ServiceSystemServer.GetObjectAttribute(Object.PriceType, "ExternalDataProc");
	Info = AddDataProcServer.AddDataProcInfo(ExternalDataProc);
	Info.Insert("Settings", PutSettingsToTempStorage(Object.PriceType));
	CallMethodAddDataProc(Info);
	NotifyDescription = New NotifyDescription("OpenFormProcEnd", ThisObject);
	AddDataProcClient.OpenFormAddDataProc(Info, NotifyDescription);
EndProcedure

&AtServer
Procedure FillItemKeyList()
	For Each Row In Object.ItemKeyList Do
		Row.Item = Row.ItemKey.Item;
	EndDo;

	RowMap = New Map();

	For Each Row In Object.ItemKeyList Do
		RowMap.Insert(Row.Key, Row);
		Row.Item = Row.ItemKey.Item;

		If TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder") Then
			Row.ItemType = Row.Item.ItemType.Type;
		EndIf;
	EndDo;

	Query = New Query();
	Query.Text =
	"SELECT
	|	SavedItems.Key,
	|	SavedItems.Item
	|FROM
	|	InformationRegister.SavedItems AS SavedItems
	|WHERE
	|	SavedItems.ObjectRef = &ObjectRef";

	Query.SetParameter("ObjectRef", Object.Ref);

	QueryResult = Query.Execute();

	SelectionDetailRecords = QueryResult.Select();

	While SelectionDetailRecords.Next() Do
		If RowMap[SelectionDetailRecords.Key] = Undefined Then
			Continue;
		EndIf;

		RowMap[SelectionDetailRecords.Key].Item = SelectionDetailRecords.Item;
			//
		If TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder") Then
			RowMap[SelectionDetailRecords.Key].ItemType = RowMap[SelectionDetailRecords.Key].Item.ItemType.Type;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject, Object.PriceType);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	If AdditionalParameters.FoundedItems.Count() Then
		SetVisible();
		ItemData = AdditionalParameters.FoundedItems[0];
		If Object.PriceListType = PredefinedValue("Enum.PriceListTypes.PriceByItemKeys") Then
			SearchInItemKeyList = Object.ItemKeyList.FindRows(New Structure("ItemKey", ItemData.ItemKey));
			If SearchInItemKeyList.Count() Then
				Items.ItemKeyList.CurrentRow = SearchInItemKeyList[0].GetID();
			Else
				NewItemKeyListRow = Object.ItemKeyList.Add();
				NewItemKeyListRow.ItemKey = ItemData.ItemKey;
				NewItemKeyListRow.Item = ItemData.Item;
				NewItemKeyListRow.Key = New UUID();
				UnitInfo = GetItemInfo.ItemUnitInfo(ItemData.ItemKey);
				NewItemKeyListRow.InputUnit = UnitInfo.Unit;
				Items.ItemKeyList.CurrentRow = NewItemKeyListRow.GetID();
			EndIf;
		ElsIf Object.PriceListType = PredefinedValue("Enum.PriceListTypes.PriceByItems") Then
			SearchInItemList = Object.ItemList.FindRows(New Structure("Item", ItemData.Item));
			If SearchInItemList.Count() Then
				Items.ItemList.CurrentRow = SearchInItemList[0].GetID();
			Else
				NewItemListRow = Object.ItemList.Add();
				NewItemListRow.Item = ItemData.Item;
				UnitInfo = GetItemInfo.ItemUnitInfo(ItemData.Item);
				NewItemListRow.InputUnit = UnitInfo.Unit;
				Items.ItemList.CurrentRow = NewItemListRow.GetID();
			EndIf;
		Else
			Return;
		EndIf;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, StrConcat(AdditionalParameters.Barcodes, ",")));
	EndIf;
EndProcedure
#EndRegion

#Region Initialize

&AtServer
Procedure BuildForm()
	If Object.PriceListType = Enums.PriceListTypes.PriceByItemKeys Then
		FillItemKeyList();
	EndIf;

	If Object.PriceListType = Enums.PriceListTypes.PriceByProperties Then
		DrawFormTablePriceKeyList();
	EndIf;
EndProcedure

#EndRegion

#Region Private

&AtServer
Function GetSavedData()
	If ValueIsFilled(ThisObject.DynamicDataForm) Then
		SavedDataStructure = CommonFunctionsServer.DeserializeXMLUseXDTO(ThisObject.DynamicDataForm);
	Else
		SavedDataStructure = New Structure();
		SavedDataStructure.Insert("Fields", New Structure());
		TableInfo = New Structure("Name, FormTableName, Columns", "PriceKeyList", "PriceKeyList", New Array());

		SavedDataStructure.Fields.Insert("Table", TableInfo);
	EndIf;
	Return SavedDataStructure;
EndFunction

&AtClient
Procedure OpenFormProcEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Modified = True;
		// load data from externall proc
	LoadDataAtServer(Result);
EndProcedure

&AtServer
Function PriceKeyListHaveError()
	SavedDataStructure = GetSavedData();
		// Fill cheking
	HaveError = False;

	ArrayOfFixedColumns = New Array();
	ArrayOfFixedColumns.Add(New Structure("FormName, Name", "PriceKeyListItem", "Item"));

	RowIndex = 0;
	For Each Row In ThisObject.PriceKeyList Do
			// Fixed columns	
		For Each Column In ArrayOfFixedColumns Do
			If Items[Column.FormName].AutoMarkIncomplete = True And Not ValueIsFilled(Row[Column.Name]) Then
				MessageText = StrTemplate(R().Error_010, Column.Name);
				CommonFunctionsClientServer.ShowUsersMessage(MessageText, "PriceKeyList[" + RowIndex + "]."
					+ Column.Name, ThisObject.PriceKeyList);
				HaveError = True;
			EndIf;
		EndDo;
			
			// Dynamic columns
		For Each Column In SavedDataStructure.Fields.Table.Columns Do
			If Items[Column.FormName].AutoMarkIncomplete And Not ValueIsFilled(Row[Column.Name]) Then
				MessageText = "";
				If Column.Name = "Price" Then
					Continue;
				Else
					MessageText = StrTemplate(R().Error_010, String(ThisObject[Column.OwnerName]));
				EndIf;
				CommonFunctionsClientServer.ShowUsersMessage(MessageText, "PriceKeyList[" + RowIndex + "]."
					+ Column.Name, ThisObject.PriceKeyList);
				HaveError = True;
			EndIf;
		EndDo;
		RowIndex = RowIndex + 1;

	EndDo;

	Return HaveError;
EndFunction

&AtServer
Procedure SetSavedData(SavedDataStructure)
	ThisObject.DynamicDataForm = CommonFunctionsServer.SerializeXMLUseXDTO(SavedDataStructure);
EndProcedure

&AtServer
Function GetUniqueName(NamePart)
	Return NamePart + StrReplace(String(New UUID()), "-", "");
EndFunction

&AtServer
Function GetItemAttributes(Item)
	If ValueIsFilled(Object.ItemType) Then
		ArrayOfAttributes = New Array();
		For Each Row In Object.ItemType.AvailableAttributes Do
			If Not Row.AffectPricing Then
				Continue;
			EndIf;
			AttributeStructure = New Structure("Attribute, InterfaceGroup", Row.Attribute, Undefined);
			ArrayOfAttributes.Add(AttributeStructure);
		EndDo;
		Return AddAttributesAndPropertiesServer.FormAttributes(ArrayOfAttributes);
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Function GetDataPrice()
	TableOfResult = New ValueTable();
	TableOfResult.Columns.Add("Item");
	TableOfResult.Columns.Add("Price");
	TableOfResult.Columns.Add("Key");
	TableOfResult.Columns.Add("InputUnit");
	TableOfResult.Columns.Add("InputPrice");
	
	TableOfKeys = Object.DataSet.Unload();
	TableOfKeys.GroupBy("Key");

	For Each Row In TableOfKeys Do
		For Each RowPrice In Object.DataPrice.Unload(New Structure("Key", Row.Key), 
			"Item, Price, Key, InputUnit, InputPrice") Do
			NewRow = TableOfResult.Add();
			FillPropertyValues(NewRow, RowPrice);
		EndDo;
	EndDo;
	TableOfResult.GroupBy("Item, Price, Key, InputUnit, InputPrice");
	Return TableOfResult;
EndFunction

&AtServer
Function GetAttributeValue(Key, Attribute)
	TableOfValues = Object.DataSet.Unload(New Structure("Key, Attribute", Key, Attribute));
	If TableOfValues.Count() Then
		Return TableOfValues[0].Value;
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Procedure LoadDataAtServer(DataForLoad)
	If Not DataForLoad.Property("PriceListType") Then
		Return;
	EndIf;

	Object.PriceListType = DataForLoad.PriceListType;
	If Object.PriceListType = Enums.PriceListTypes.PriceByItems Then
		Object.ItemList.Clear();
		For Each Row In DataForLoad.ItemList Do
			NewRow = Object.ItemList.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	ElsIf Object.PriceListType = Enums.PriceListTypes.PriceByItemKeys Then
		Object.ItemKeyList.Clear();
		For Each Row In DataForLoad.ItemKeyList Do
			NewRow = Object.ItemKeyList.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	ElsIf Object.PriceListType = Enums.PriceListTypes.PriceByProperties Then
		Object.DataSet.Clear();
		Object.DataPrice.Clear();
		Object.ItemType = DataForLoad.ItemType;
		For Each Row In DataForLoad.DataSet Do
			NewRow = Object.DataSet.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
		For Each Row In DataForLoad.DataPrice Do
			NewRow = Object.DataPrice.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
		DrawFormTablePriceKeyList();
	EndIf;
	SetVisible();
EndProcedure

&AtServer
Procedure DrawFormTablePriceKeyList()
	ThisObject.PriceKeyList.Clear();

	SavedDataStructure = GetSavedData();

	Table = SavedDataStructure.Fields.Table;
		// Delete/Create column
	ArrayOfOwners = New Array();
	For Each Column In Table.Columns Do
		ArrayOfOwners.Add(Column.DataPath);
		Items.Delete(Items[Column.FormName]);
		If Column.OwnerName <> Undefined Then
			ArrayOfOwners.Add(Column.OwnerName);
		EndIf;
	EndDo;

	ThisObject.ChangeAttributes( , ArrayOfOwners);

	Table.Columns.Clear();

	ChoiceParametersMap = New Map();
	ArrayOfAttributes = New Array();

	If ValueIsFilled(Object.ItemType) Then

		For Each i In GetItemAttributes(Object.ItemType).FormAttributesInfo Do
			ColumnName = Table.Name + i.Name;
			ColumnOwnerName = Table.Name + i.Name_owner;

			ColumnStr = New Structure("Name, DataPath, OwnerName, FormName", ColumnName, Table.Name + "." + ColumnName,
				ColumnOwnerName, "");
			Table.Columns.Add(ColumnStr);

			NewColumn = New FormAttribute(ColumnName, i.Type, Table.Name, i.Title);
			ArrayOfAttributes.Add(NewColumn);

			NewColumnOwner = New FormAttribute(ColumnOwnerName, i.Type_owner);
			ArrayOfAttributes.Add(NewColumnOwner);

			ChoiceParametersMap.Insert(ColumnName, New Structure(Table.Name + i.Name_owner, i.Ref));
		EndDo;

	EndIf;

	// Create columns InputPrice	
	NewColumn_InputPrice = New FormAttribute("InputPrice", Metadata.DefinedTypes.typePrice.Type, Table.Name, "Input price");
	ArrayOfAttributes.Add(NewColumn_InputPrice);
	
	Table.Columns.Add(
			New Structure("Name, DataPath, OwnerName, FormName", NewColumn_InputPrice.Name, Table.Name + "."
		+ NewColumn_InputPrice.Name, Undefined, ""));
		
	// Create columns Price	
	NewColumn_Price = New FormAttribute("Price", Metadata.DefinedTypes.typePrice.Type, Table.Name, "Price");
	ArrayOfAttributes.Add(NewColumn_Price);

	Table.Columns.Add(
			New Structure("Name, DataPath, OwnerName, FormName", NewColumn_Price.Name, Table.Name + "."
		+ NewColumn_Price.Name, Undefined, ""));

	
	ThisObject.ChangeAttributes(ArrayOfAttributes);
		
		// Form columns	
	For Each i In ChoiceParametersMap Do
		For Each j In ChoiceParametersMap[i.Key] Do
			ThisObject[j.Key] = j.Value;
		EndDo;
	EndDo;

	For Each Column In Table.Columns Do
		NewFormColumn = Items.Add(GetUniqueName(Column.Name), Type("FormField"), Items[Table.FormTableName]);
		NewFormColumn.Type = FormFieldType.InputField;
		NewFormColumn.DataPath = Table.Name + "." + Column.Name;
		NewFormColumn.AutoMarkIncomplete = True;
		
		If Upper(Column.Name) = Upper("InputPrice") Then
			NewFormColumn.SetAction("OnChange", "PriceKeyListInputPriceOnChange");
			NewFormColumn.AutoMarkIncomplete = False;
		EndIf;

		Column.FormName = NewFormColumn.Name;

		If ChoiceParametersMap.Get(Column.Name) <> Undefined Then
			ArrayOfChoiceParameters = New Array();
			For Each i In ChoiceParametersMap[Column.Name] Do
				ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.Owner", i.Value));
			EndDo;
			NewFormColumn.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
		EndIf;
	EndDo;
		
		// Fill table from data set	
	DataPrice = GetDataPrice();
	For Each Row In DataPrice Do
		NewRow = ThisObject.PriceKeyList.Add();
		NewRow.Price      = Row.Price;
		NewRow.Item       = Row.Item;
		NewRow.InputUnit  = Row.InputUnit;
		NewRow.InputPrice = Row.InputPrice;
		
		For Each Column In SavedDataStructure.Fields.Table.Columns Do
			If Column.Name = "Price" Or Column.Name = "InputPrice" Then
				Continue;
			EndIf;
			NewRow[Column.Name] = GetAttributeValue(Row.Key, ThisObject[Column.OwnerName]);
		EndDo;
	EndDo;

	SetSavedData(SavedDataStructure);
EndProcedure

&AtServer
Function PutSettingsToTempStorage(PriceTypeRef)
	Return PutToTempStorage(PriceTypeRef.ExternalDataProcSettings.Get(), ThisObject.UUID);
EndFunction

&AtServer
Procedure SaveTablePriceKeyList(Cancel, CurrentObject, WriteParameters)
	SavedDataStructure = GetSavedData();

	If WriteParameters.WriteMode = DocumentWriteMode.Posting And PriceKeyListHaveError() Then
		Cancel = True;
		Return;
	EndIf;
		
		// Save data
	CurrentObject.DataSet.Clear();
	CurrentObject.DataPrice.Clear();

	For Each Row In ThisObject.PriceKeyList Do
		NewRowPrice = CurrentObject.DataPrice.Add();
		NewRowPrice.Key        = New UUID();
		NewRowPrice.Price      = Row.Price;
		NewRowPrice.Item       = Row.Item;
		NewRowPrice.InputUnit  = Row.InputUnit;
		NewRowPrice.InputPrice = Row.InputPrice;

		If SavedDataStructure.Fields.Table.Columns.Count() <= 1 Then
			NewRow = CurrentObject.DataSet.Add();
			NewRow.Key = NewRowPrice.Key;
		Else
			For Each Column In SavedDataStructure.Fields.Table.Columns Do
				If Column.Name = "Price" Or Column.Name = "InputPrice" Then
					Continue;
				EndIf;
				NewRow = CurrentObject.DataSet.Add();
				NewRow.Key = NewRowPrice.Key;
				NewRow.Attribute = ThisObject[Column.OwnerName];
				NewRow.Value = Row[Column.Name];
			EndDo;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure CallMethodAddDataProc(Info)
	AddDataProcServer.CallMethodAddDataProc(Info);
EndProcedure

&AtServer
Procedure SetVisible()
	Items.GroupPriceKeyList.Visible = Object.PriceListType = Enums.PriceListTypes.PriceByProperties;
	Items.GroupItemKeyList.Visible = Object.PriceListType = Enums.PriceListTypes.PriceByItemKeys;
	Items.GroupItemList.Visible = Object.PriceListType = Enums.PriceListTypes.PriceByItems;
	Items.FillByRules.Visible = ValueIsFilled(Object.PriceType.ExternalDataProc);
EndProcedure
#EndRegion

#Region FormEvents

&AtServerNoContext
Procedure WriteSavedItems(Object, CurrentObject) Export

	ObjectRef = CurrentObject.Ref;
	ItemKeyListTmp = Object.ItemKeyList.Unload();
	ItemKeyListTmpFilter = New Structure("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef"));
	ItemKeyList = ItemKeyListTmp.Copy(ItemKeyListTmpFilter);
	If ItemKeyList.Count() = 0 Then
		RecordSet = InformationRegisters.SavedItems.CreateRecordSet();
		RecordSet.Filter.ObjectRef.Set(ObjectRef);
		RecordSet.Write(True);
		Return;
	EndIf;

	ItemKeyList.Columns.Add("ObjectRef");
	ItemKeyList.FillValues(ObjectRef, "ObjectRef");

	RecordSet = InformationRegisters.SavedItems.CreateRecordSet();
	RecordSet.Filter.ObjectRef.Set(ObjectRef);

	RecordSet.Load(ItemKeyList);
	RecordSet.Write(True);

EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region ExternalCommands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

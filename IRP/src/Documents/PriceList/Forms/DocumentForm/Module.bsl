#Region FormEvents

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

&AtServerNoContext
Procedure WriteSavedItems(Object, CurrentObject) Export
	
	ObjectRef = CurrentObject.Ref;
	ItemKeyList = Object.ItemKeyList.Unload().Copy(New Structure("ItemKey", PredefinedValue("Catalog.ItemKeys.EmptyRef")));
	
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

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	If Object.PriceListType = Enums.PriceListTypes.PriceByItemKeys Then
		FillItemKeyList();
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAffectPricing"
		And Object.PriceListType = PredefinedValue("Enum.PriceListTypes.PriceByProperties") Then
		DrawFormTablePriceKeyList();
	EndIf;
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
	EndIf;
EndProcedure

&AtClient
Procedure ItemTypeOnChange(Item)
	DrawFormTablePriceKeyList();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	If Object.PriceListType = Enums.PriceListTypes.PriceByProperties Then
		SaveTablePriceKeyList(Cancel, CurrentObject, WriteParameters);
	EndIf;
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
Procedure ItemKeyListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPriceListClient.ItemKeyListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemKeyListItemEditTextChange(Item, Text, StandardProcessing)
	DocPriceListClient.ItemKeyListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPriceListClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPriceListClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PriceListTypeOnChange(Item)
	BuildForm();
	SetVisible();
EndProcedure

#EndRegion

&AtServer
Procedure SetVisible()
	ShowAlfaTestingSaas = GetFunctionalOption("ShowAlfaTestingSaas");
	Items.GroupPriceKeyList.Visible = Object.PriceListType = Enums.PriceListTypes.PriceByProperties And ShowAlfaTestingSaas;
	Items.GroupItemKeyList.Visible = Object.PriceListType = Enums.PriceListTypes.PriceByItemKeys And ShowAlfaTestingSaas;
	Items.GroupItemList.Visible = Object.PriceListType = Enums.PriceListTypes.PriceByItems;
	Items.FillByRules.Visible = ValueIsFilled(Object.PriceType.ExternalDataProc);
	Items.PriceListType.Visible = ShowAlfaTestingSaas;
EndProcedure

&AtServer
Procedure BuildForm()
	If Object.PriceListType = Enums.PriceListTypes.PriceByItemKeys Then
		FillItemKeyList();
	EndIf;
	
	If Object.PriceListType = Enums.PriceListTypes.PriceByProperties Then
		DrawFormTablePriceKeyList();
	EndIf;
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
	
	Query = New Query;
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
		NewRowPrice.Key = New UUID();
		NewRowPrice.Price = Row.Price;
		NewRowPrice.Item = Row.Item;
		
		If SavedDataStructure.Fields.Table.Columns.Count() <= 1 Then
			NewRow = CurrentObject.DataSet.Add();
			NewRow.Key = NewRowPrice.Key;
		Else
			For Each Column In SavedDataStructure.Fields.Table.Columns Do
				If Column.Name = "Price" Then
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
				MessageText = StrTemplate(R()["Error_010"], Column.Name);
				CommonFunctionsClientServer.ShowUsersMessage(MessageText
					, "PriceKeyList[" + RowIndex + "]." + Column.Name
					, ThisObject.PriceKeyList);
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
					MessageText = StrTemplate(R()["Error_010"], String(ThisObject[Column.OwnerName]));
				EndIf;
				CommonFunctionsClientServer.ShowUsersMessage(MessageText
					, "PriceKeyList[" + RowIndex + "]." + Column.Name
					, ThisObject.PriceKeyList);
				HaveError = True;
			EndIf;
		EndDo;
		RowIndex = RowIndex + 1;
		
	EndDo;
	
	Return HaveError;
EndFunction

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
			
			Table.Columns.Add(New Structure("Name, DataPath, OwnerName, FormName"
					, ColumnName
					, Table.Name + "." + ColumnName
					, ColumnOwnerName
					, ""));
			
			NewColumn = New FormAttribute(ColumnName, i.Type, Table.Name, i.Title);
			ArrayOfAttributes.Add(NewColumn);
			
			NewColumnOwner = New FormAttribute(ColumnOwnerName, i.Type_owner);
			ArrayOfAttributes.Add(NewColumnOwner);
			
			ChoiceParametersMap.Insert(ColumnName, New Structure(Table.Name + i.Name_owner, i.Ref));
		EndDo;
		
	EndIf;
	
	// Create columns Price	
	NewColumn_Price = New FormAttribute("Price", Metadata.DefinedTypes.typePrice.Type, Table.Name, "Price");
	ArrayOfAttributes.Add(NewColumn_Price);
	
	Table.Columns.Add(
		New Structure("Name, DataPath, OwnerName, FormName"
			, NewColumn_Price.Name
			, Table.Name + "." + NewColumn_Price.Name
			, Undefined
			, ""));
	
	ThisObject.ChangeAttributes(ArrayOfAttributes);
	
	// Form columns	
	For Each i In ChoiceParametersMap Do
		For Each j In ChoiceParametersMap[i.Key] Do
			ThisObject[j.Key] = j.Value;
		EndDo;
	EndDo;
	
	For Each Column In Table.Columns Do
		NewFormColumn = Items.Add(GetUniqueName(Column.Name)
				, Type("FormField")
				, Items[Table.FormTableName]);
		NewFormColumn.Type = FormFieldType.InputField;
		NewFormColumn.DataPath = Table.Name + "." + Column.Name;
		NewFormColumn.AutoMarkIncomplete = True;
		
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
		NewRow.Price = Row.Price;
		NewRow.Item = Row.Item;
		
		For Each Column In SavedDataStructure.Fields.Table.Columns Do
			If Column.Name = "Price" Then
				Continue;
			EndIf;
			NewRow[Column.Name] = GetAttributeValue(Row.Key, ThisObject[Column.OwnerName]);
		EndDo;
	EndDo;
	
	SetSavedData(SavedDataStructure);
EndProcedure

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


&AtServer
Function GetSavedData()
	If ValueIsFilled(ThisObject.DynamicDataForm) Then
		SavedDataStructure = CommonFunctionsServer.DeserializeXMLUseXDTO(ThisObject.DynamicDataForm);
	Else
		SavedDataStructure = New Structure();
		SavedDataStructure.Insert("Fields", New Structure());
		TableInfo = New Structure("Name, FormTableName, Columns"
				, "PriceKeyList"
				, "PriceKeyList"
				, New Array());
		
		SavedDataStructure.Fields.Insert("Table", TableInfo);
	EndIf;
	Return SavedDataStructure;
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
	
	TableOfKeys = Object.DataSet.Unload();
	TableOfKeys.GroupBy("Key");
	
	For Each Row In TableOfKeys Do
		For Each RowPrice In Object.DataPrice.Unload(New Structure("Key", Row.Key), "Item, Price, Key") Do
			NewRow = TableOfResult.Add();
			FillPropertyValues(NewRow, RowPrice);
		EndDo;
	EndDo;
	TableOfResult.GroupBy("Item, Price, Key");
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

&AtClient
Procedure PriceTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure FillByRules(Command)
	ExternalDataProc = ServiceSystemServer.GetObjectAttribute(Object.PriceType, "ExternalDataProc");
	Info = AddDataProcServer.AddDataProcInfo(ExternalDataProc);
	Info.Insert("Settings", PutSettingsToTempStorage(Object.PriceType));
	CallMetodAddDataProc(Info);
	NotifyDescription = New NotifyDescription("OpenFormProcEnd", ThisObject);
	AddDataProcClient.OpenFormAddDataProc(Info, NotifyDescription);
EndProcedure

&AtClient
Procedure OpenFormProcEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Modified = True;
	// load data from externall proc
	LoadDataAtServer(Result);
EndProcedure

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
Function PutSettingsToTempStorage(PriceTypeRef)
	Return PutToTempStorage(PriceTypeRef.ExternalDataProcSettings.Get(), ThisObject.UUID);
EndFunction

&AtServerNoContext
Procedure CallMetodAddDataProc(Info)
	AddDataProcServer.CallMetodAddDataProc(Info);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	BuildForm();
EndProcedure


#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControll()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);	
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure


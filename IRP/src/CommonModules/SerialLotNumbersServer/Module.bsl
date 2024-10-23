
// Fill settings add new serial.
// 
// Parameters:
//  Str - Structure:
// * RowKey - String -
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumbers - Array of Structure:
// ** SerialLotNumber - CatalogRef.SerialLotNumbers -
// ** Quantity - Number -
// 
// Returns:
//  Structure - Fill settings add new serial:
// * RowKey - String -
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumbers - Array of Structure:
// ** SerialLotNumber - CatalogRef.SerialLotNumbers -
// ** Quantity - Number -
Function FillSettingsAddNewSerial(Str = Undefined) Export
	Result = New Structure();
	Result.Insert("RowKey", "");
	Result.Insert("Item", Catalogs.Items.EmptyRef());
	Result.Insert("ItemKey", Catalogs.ItemKeys.EmptyRef());
	Result.Insert("SerialLotNumbers", New Array());
	
	If Not Str = Undefined Then
		Result.RowKey = Str.RowKey;
		Result.Item = Str.Item;
		Result.ItemKey = Str.ItemKey;
		For Each Row In Str.SerialLotNumbers Do
			Result.SerialLotNumbers.Add(
					New Structure("SerialLotNumber, Quantity", Row.SerialLotNumber, Row.Quantity));
		EndDo;
	EndIf;
	Return Result;
EndFunction

// Check serial lot number name.
// 
// Parameters:
//  Object - CatalogObject.SerialLotNumbers - Object
//  Cancel - Boolean - Cancel
// 
// Returns:
//  Boolean - Check serial lot number name
Function CheckSerialLotNumberName(Object, Cancel) Export
	RegExpSettings = isSerialLotNumberNameMatchRegExp(Object.Description, Object.SerialLotNumberOwner);
	If Not RegExpSettings.isMatch Then
		Cancel = True;
	EndIf;
	Return RegExpSettings;
EndFunction

// Check serial lot number unique.
// 
// Parameters:
//  Object - CatalogObject.SerialLotNumbers - Object
//  Cancel - Boolean - Cancel
// 
// Returns:
//  ValueTable - Check serial lot number name
Function CheckSerialLotNumberUnique(Object, Cancel) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SerialLotNumbers.Ref,
	|	SerialLotNumbers.Description,
	|	SerialLotNumbers.Code
	|FROM
	|	Catalog.SerialLotNumbers AS SerialLotNumbers
	|WHERE
	|	SerialLotNumbers.Description = &Description
	|	AND SerialLotNumbers.DeletionMark = &DeletionMark
	|	AND SerialLotNumbers.SerialLotNumberOwner = &SerialLotNumberOwner
	|	AND SerialLotNumbers.Ref <> &Ref";
	
	Query.SetParameter("Description"          , Object.Description);
	Query.SetParameter("DeletionMark"         , Object.DeletionMark);
	Query.SetParameter("SerialLotNumberOwner" , Object.SerialLotNumberOwner);
	Query.SetParameter("Ref"                  , Object.Ref);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	If QueryTable.Count() Then
		Cancel = True;
	EndIf;
	
	Return QueryTable;
EndFunction

Function IsItemKeyWithSerialLotNumbers(ItemKey, AddInfo = Undefined) Export
	If Not ValueIsFilled(ItemKey) Then
		Return False;
	EndIf;

	Return ItemKey.Item.ItemType.UseSerialLotNumber;
EndFunction

// Check filling.
// 
// Parameters:
//  Object - DocumentObject
// 
// Returns:
//  Boolean - Check filling
Function CheckFilling(Object) Export
	IsOk = True;
	If TypeOf(Object) = Type("DocumentObject.PhysicalInventory") Then
		Return CheckFillingPhysicalInventory(Object);
	EndIf;	
	For Each Row In Object.ItemList Do
		If Not Row.UseSerialLotNumber Then
			Continue;
		EndIf;

		ArrayOfSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", Row.Key));
		If Not ArrayOfSerialLotNumbers.Count() Then
			IsOk = False;
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, Metadata.Catalogs.SerialLotNumbers.Presentation()), "ItemList[" + Format(
				(Row.LineNumber - 1), "NZ=0; NG=0;") + "].SerialLotNumbersPresentation", Object);
		Else
			QuantityBySerialLotNumber = 0;
			For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
				QuantityBySerialLotNumber = QuantityBySerialLotNumber + RowSerialLotNumber.Quantity;
			EndDo;
			If Row.Quantity <> QuantityBySerialLotNumber Then
				IsOk = False;
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().Error_078, Row.Quantity, QuantityBySerialLotNumber), "ItemList[" + Format(
					(Row.LineNumber - 1), "NZ=0; NG=0;") + "].Quantity", Object);

			EndIf;
		EndIf;
	EndDo;
	
	Serials = Object.SerialLotNumbers.Unload();
	Serials.GroupBy("SerialLotNumber", "Quantity");
	For Each Serial In Serials Do
		
		If Serial.Quantity = 1 Then
			Continue;
		EndIf;
		
		If Serial.SerialLotNumber.EachSerialLotNumberIsUnique Then
			IsOk = False;
			SerialsID = Object.SerialLotNumbers.FindRows(New Structure("SerialLotNumber", Serial.SerialLotNumber));
			
			For Each Row In SerialsID Do
				For Each ItemRow In Object.ItemList.FindRows(New Structure("Key", Row.Key)) Do
					CommonFunctionsClientServer.ShowUsersMessage(
						StrTemplate(R().Error_113, Serial.SerialLotNumber), "ItemList[" + Format(
						(ItemRow.LineNumber - 1), "NZ=0; NG=0;") + "].SerialLotNumbersPresentation", Object);
				EndDo;
			EndDo;
		EndIf;
	EndDo;
	
	Return IsOk;
EndFunction

// Check filling PhysicalInventory.
// 
// Parameters:
//  Object - DocumentObject.PhysicalInventory
// 
// Returns:
//  Boolean - Check filling
Function CheckFillingPhysicalInventory(Object)
	IsOk = True;
	
	Serials = Object.ItemList.Unload();
	Serials.GroupBy("SerialLotNumber", "PhysCount");
	For Each Serial In Serials Do
		
		If Serial.PhysCount = 1 Then
			Continue;
		EndIf;
		
		If Serial.SerialLotNumber.EachSerialLotNumberIsUnique Then
			IsOk = False;
			SerialsID = Object.ItemList.FindRows(New Structure("SerialLotNumber", Serial.SerialLotNumber));
			
			For Each Row In SerialsID Do
				For Each ItemRow In Object.ItemList.FindRows(New Structure("Key", Row.Key)) Do
					CommonFunctionsClientServer.ShowUsersMessage(
						StrTemplate(R().Error_113, Serial.SerialLotNumber),
						 "ItemList[" + Format((ItemRow.LineNumber - 1), "NZ=0; NG=0;") + "].SerialLotNumber", Object);
				EndDo;
			EndDo;
		EndIf;
	EndDo;
	
	Return IsOk;
EndFunction

// Create new serial lot number.
// 
// Parameters:
//  Options - See GetSeriallotNumerOptions
// 
// Returns:
//  CatalogRef.SerialLotNumbers
Function CreateNewSerialLotNumber(Options) Export
	
	NewSerial = Catalogs.SerialLotNumbers.CreateItem();
	NewSerial.Description = Options.Description;
	NewSerial.SerialLotNumberOwner = Options.Owner;
	NewSerial.StockBalanceDetail = GetStockBalanceDetailByOwner(Options.Owner);
	NewSerial.EachSerialLotNumberIsUnique = GetItemTypeByOwner(Options.Owner).EachSerialLotNumberIsUnique;
	If NewSerial.CheckFilling() Then
		NewSerial.Write();
	Else
		Return Catalogs.SerialLotNumbers.EmptyRef();
	EndIf;
	
	Return NewSerial.Ref;
EndFunction

// Get seriallot numer options.
// 
// Returns:
//  Structure - Get seriallot numer options:
// * Description - String -
// * Owner - Undefined -
// * Barcode - String -
Function GetSeriallotNumerOptions() Export
	
	Str = New Structure();
	Str.Insert("Description", "");
	Str.Insert("Owner", Undefined);
	Str.Insert("Barcode", "");
	
	Return Str;
EndFunction

// Is serial lot number name match reg exp.
// 
// Parameters:
//  Value - String - Description or Barcode
//  Owner - Undefined, CatalogRef.ItemKeys, CatalogRef.Items, CatalogRef.ItemTypes - Serial lot number owner
// 
// Returns:
//  See GetRegExpSettings
Function isSerialLotNumberNameMatchRegExp(Value, Owner) Export
	
	Str = GetSerialLotNumbersRegExpRules(Owner);
	If Str.ItemType.RegExpSerialLotNumbersRules.Count() Then
		Str.isMatch = CommonFunctionsServer.Regex(Value, Str.RegExp);
	Else
		Str.isMatch = True;
	EndIf;
	
	Return Str;
	
EndFunction

// Get serial lot numbers reg exp rules.
// 
// Parameters:
//  Owner - Undefined, CatalogRef.ItemKeys, CatalogRef.Items, CatalogRef.ItemTypes - Owner
// 
// Returns:
//  See GetRegExpSettings
Function GetSerialLotNumbersRegExpRules(Owner)
	Str = GetRegExpSettings();
	ItemType = Owner;
	If Owner = Undefined Then
		Return Str;
	ElsIf TypeOf(Owner) = Type("CatalogRef.ItemKeys") Then
		ItemType = Owner.Item.ItemType;
	ElsIf TypeOf(Owner) = Type("CatalogRef.Items") Then
		ItemType = Owner.ItemType;
	EndIf;
	
	Str.ItemType = ItemType;
	Str.RegExp = ItemType.RegExpSerialLotNumbersRules.UnloadColumn("RegExp");
	Str.Example = ItemType.RegExpSerialLotNumbersRules.UnloadColumn("Example");
	Return Str;
	
EndFunction

// Get reg exp settings.
// 
// Returns:
//  Structure - Get reg exp settings:
// * RegExp - Array of String -
// * Example - Array of String -
// * ItemType - CatalogRef.ItemTypes -
// * isMatch - Boolean -
Function GetRegExpSettings() Export
	Str = New Structure;
	Str.Insert("RegExp", New Array);
	Str.Insert("Example", New Array);
	Str.Insert("ItemType", Catalogs.ItemTypes.EmptyRef());
	Str.Insert("isMatch", True);
	
	Return Str;
EndFunction

// Get new serial lot number.
// 
// Parameters:
//  Barcode - String - Barcode
//  ItemKey - CatalogRef.ItemKeys - Item key
// 
// Returns:
//  CatalogRef.SerialLotNumbers
Function GetNewSerialLotNumber(Barcode, ItemKey) Export
	Options = GetSeriallotNumerOptions();
	Options.Barcode = Barcode;
	Options.Owner = ItemKey;
	Options.Description = Barcode;
	SerialLotNumber = CreateNewSerialLotNumber(Options);
	If Not SerialLotNumber.IsEmpty() Then
		Option = New Structure();
		Option.Insert("ItemKey", ItemKey);
		Option.Insert("SerialLotNumber", SerialLotNumber);
		BarcodeServer.UpdateBarcode(Barcode, Option);
	EndIf;
	Return SerialLotNumber;
EndFunction

// Get stock balance detail by owner.
// 
// Parameters:
//  Owner - See Catalog.SerialLotNumbers.SerialLotNumberOwner
// 
// Returns:
//  Boolean - Get stock balance detail by owner
Function GetStockBalanceDetailByOwner(Owner) Export
	ItemType = GetItemTypeByOwner(Owner);
	Return ItemType.StockBalanceDetail = Enums.StockBalanceDetail.BySerialLotNumber;
EndFunction

// Is each serial lot number is unique by owner.
// 
// Parameters:
//  Owner - See Catalog.SerialLotNumbers.SerialLotNumberOwner
// 
// Returns:
//  Boolean - Is each serial lot number is unique by owner
Function isEachSerialLotNumberIsUniqueByOwner(Owner) Export
	ItemType = GetItemTypeByOwner(Owner);
	Return ItemType.EachSerialLotNumberIsUnique;
EndFunction

// Get item type by owner.
// 
// Parameters:
//  Owner - See Catalog.SerialLotNumbers.SerialLotNumberOwner
// 
// Returns:
//  CatalogRef.ItemTypes - Get item type by owner
Function GetItemTypeByOwner(Owner) Export
	ItemType = Catalogs.ItemTypes.EmptyRef(); 
	If Not ValueIsFilled(Owner) Then
		
	ElsIf TypeOf(Owner) = Type("CatalogRef.ItemKeys") Then
		ItemType = Owner.Item.ItemType;
	ElsIf TypeOf(Owner) = Type("CatalogRef.Items") Then
		ItemType = Owner.ItemType;
	ElsIf TypeOf(Owner) = Type("CatalogRef.ItemTypes") Then
		ItemType = Owner;
	EndIf;
	Return ItemType;
EndFunction

// Set uniq.
// 
// Parameters:
//  Object - See Catalog.SerialLotNumbers.Form.EditListOfSerialLotNumbers
Procedure SetUnique(Object) Export
	For Each Row In Object.SerialLotNumbers Do
		Row.isUnique = Row.SerialLotNumber.EachSerialLotNumberIsUnique;
		If Row.isUnique Then
			Row.Locked = PutToTempStorage(PictureLib.LockedRows.GetBinaryData(), Object.UUID);
		Else
			Row.Locked = "";
		EndIf;
	EndDo;
EndProcedure

Function GetWrongSerialLotNumbers(ArrayOfItemKeys) Export
	ArrayOfWrongSerialLotNumbers = New Array();
	
	For Each Row In ArrayOfItemKeys Do
		For Each RowSLN In Row.SerialLotNumbers Do
			If Not ValueIsFilled(RowSLN.SerialLotNumber) Then
				ArrayOfWrongSerialLotNumbers.Add(New Structure("Key, SerialLotNumber"));
				Continue;
			EndIf;
			IsWrongSerialLotNumber = True;
			Owner = RowSLN.SerialLotNumber.SerialLotNumberOwner;
			If Not ValueIsFilled(Owner) Then
				IsWrongSerialLotNumber = False;
			ElsIf Owner = Row.ItemKey Then
				IsWrongSerialLotNumber = False;
			ElsIf Owner = Row.ItemKey.Item Then
				IsWrongSerialLotNumber = False;
			ElsIf Owner = Row.ItemKey.Item.ItemType Then
				IsWrongSerialLotNumber = False;
			EndIf;
			If IsWrongSerialLotNumber Then
				ArrayOfWrongSerialLotNumbers.Add(New Structure("Key, SerialLotNumber", Row.Key, RowSLN.SerialLotNumber));
			EndIf;
		EndDo;
	EndDo;
	
	Return ArrayOfWrongSerialLotNumbers;
EndFUnction

Procedure UpdateSerialLotNumbersPresentation(Object) Export
	For Each RowItemList In Object.ItemList Do
		ArrayOfSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", RowItemList.Key));
		RowItemList.SerialLotNumbersPresentation.Clear();		
		SerialCount = 0;
		For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
			RowItemList.SerialLotNumbersPresentation.Add(RowSerialLotNumber.SerialLotNumber);
			SerialCount = SerialCount + RowSerialLotNumber.Quantity;
		EndDo;
		If RowItemList.UseSerialLotNumber Then
			RowItemList.SerialLotNumberIsFilling = SerialCount > 0;
		EndIf;
	EndDo;
EndProcedure

// Get Serial lot number table.
// 
// Returns:
//  ValueTable - Get standard item table:
// * Key - String -
// * Quantity - DefinedType.typeQuantity
// * Barcode  - DefinedType.typeBarcode
Function GetSerialLotNumberTable() Export
	
	Table = New ValueTable();
	
	Table.Columns.Add(
		"Key", 
		New TypeDescription("String"), 
		"Key", 
		15);
		
	Table.Columns.Add(
		"Quantity", 
		Metadata.DefinedTypes.typeQuantity.Type, 
		Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym, 
		15);
		
	Table.Columns.Add(
		"SerialLotNumber", 
		New TypeDescription("String", , New StringQualifiers(Metadata.Catalogs.SerialLotNumbers.DescriptionLength)), 
		Metadata.InformationRegisters.Barcodes.Resources.SerialLotNumber.Synonym, 
		30);
		
	Return Table;
	
EndFunction

// Search by barcodes.
// 
// Parameters:
//  SerialLotNumberTable - See GetSerialLotNumberTable
//  AddInfo - Structure
// 
// Returns:
//  ValueTable:
// * Key - String
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * Quantity - DefinedType.typeQuantity
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * Unit - CatalogRef.Units -
// * ItemKeyUnit - CatalogRef.Units -
// * ItemUnit - CatalogRef.Units -
// * hasSpecification - Boolean -
// * ItemType - CatalogRef.ItemTypes -
// * UseSerialLotNumber - Boolean - Always TRUE
// * Image - CatalogRef.Files -
Function SearchBySerialLotNumber_WithKey(SerialLotNumberTable, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text = "SELECT
	|	SerialLotNumberTable.Key,
	|	SerialLotNumberTable.SerialLotNumber,
	|	SerialLotNumberTable.Quantity
	|INTO tmpSerialTable
	|FROM
	|	&SerialLotNumberTable AS SerialLotNumberTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpSerialTable.Key,
	|	SerialLotNumbersCatalog.Ref AS SerialLotNumber,
	|	tmpSerialTable.Quantity,
	|	CAST(SerialLotNumbersCatalog.SerialLotNumberOwner AS Catalog.ItemKeys) AS ItemKey
	|INTO tmpMain
	|FROM
	|	tmpSerialTable AS tmpSerialTable
	|		INNER JOIN Catalog.SerialLotNumbers AS SerialLotNumbersCatalog
	|		ON tmpSerialTable.SerialLotNumber = SerialLotNumbersCatalog.Description
	|WHERE
	|	SerialLotNumbersCatalog.SerialLotNumberOwner REFS Catalog.ItemKeys
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpMain.Key,
	|	tmpMain.SerialLotNumber,
	|	tmpMain.Quantity,
	|	tmpMain.ItemKey.Item AS Item,
	|	tmpMain.ItemKey,
	|	CASE
	|		WHEN tmpMain.ItemKey.Unit = Value(Catalog.Units.EmptyRef)
	|			THEN tmpMain.ItemKey.Item.Unit
	|		ELSE tmpMain.ItemKey.Unit
	|	END AS Unit,
	|	tmpMain.ItemKey.Unit AS ItemKeyUnit,
	|	tmpMain.ItemKey.Item.Unit AS ItemUnit,
	|	NOT tmpMain.ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	tmpMain.ItemKey.Item.ItemType AS ItemType,
	|	TRUE AS UseSerialLotNumber
	|INTO tmpFullData
	|FROM
	|	tmpMain AS tmpMain
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AttachedFiles.Owner AS Item,
	|	VALUE(Catalog.ItemKeys.EmptyRef) AS ItemKey,
	|	MAX(AttachedFiles.File) AS File,
	|	MIN(AttachedFiles.Priority) AS Priority
	|INTO Images
	|FROM
	|	InformationRegister.AttachedFiles AS AttachedFiles
	|		INNER JOIN tmpFullData AS MainData
	|		ON MainData.Item = AttachedFiles.Owner
	|WHERE
	|	AttachedFiles.Priority = 0
	|GROUP BY
	|	AttachedFiles.Owner,
	|	VALUE(Catalog.ItemKeys.EmptyRef)
	|
	|UNION ALL
	|
	|SELECT
	|	AttachedFiles.Owner.Item,
	|	AttachedFiles.Owner AS Item,
	|	MAX(AttachedFiles.File) AS File,
	|	MIN(AttachedFiles.Priority) AS Priority
	|FROM
	|	InformationRegister.AttachedFiles AS AttachedFiles
	|		INNER JOIN tmpFullData AS MainData
	|		ON MainData.ItemKey = AttachedFiles.Owner
	|WHERE
	|	AttachedFiles.Priority = 0
	|GROUP BY
	|	AttachedFiles.Owner.Item,
	|	AttachedFiles.Owner
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MainData.ItemKey,
	|	MainData.Item,
	|	MainData.SerialLotNumber,
	|	MainData.Unit,
	|	MainData.ItemKeyUnit,
	|	MainData.ItemUnit,
	|	MainData.hasSpecification,
	|	MainData.ItemType,
	|	MainData.UseSerialLotNumber,
	|	MainData.Key,
	|	MainData.Quantity,
	|	Images.File AS Image
	|FROM
	|	tmpFullData AS MainData
	|		LEFT JOIN Images AS Images
	|		ON CASE
	|			WHEN Images.ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)
	|				THEN MainData.Item = Images.Item
	|			ELSE MainData.ItemKey = Images.ItemKey
	|		END";
	Query.SetParameter("SerialLotNumberTable", SerialLotNumberTable);
	QueryExecution = Query.Execute();
	QueryUnload = QueryExecution.Unload();
	
	Return QueryUnload;

EndFunction

// Create commands.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  ObjectMetadata - MetadataObject - Object Metadata
//  FormType - EnumRef.FormTypes - Form type
Procedure CreateCommands(Form, ObjectMetadata, FormType) Export
	If Not FormType = Enums.FormTypes.ObjectForm 
			Or Not Form.Commands.Find("OpenSerialLotNumbersTree") = Undefined 
			Or Not Form.Items.Find("ItemListOpenSerialLotNumbersTree") = Undefined Then
		Return;
	EndIf;
		
	If ObjectMetadata.TabularSections.Find("SerialLotNumbers") = Undefined Then
		Return;
	EndIf;
		
	ItemListForm = Form.Items.Find("ItemList"); // FormTable
	If ItemListForm = Undefined Then
		Return;
	EndIf;
	
	If Form.Commands.Find("OpenSerialLotNumbersTree") = Undefined Then
		CommandForm = Form.Commands.Add("OpenSerialLotNumbersTree");
		CommandForm.Representation = ButtonRepresentation.Picture;
		CommandForm.Picture = PictureLib.ListViewModeTree;
		CommandForm.Action = "OpenSerialLotNumbersTree";
		R().Property("OpenSLNTree_Button_Title",   CommandForm.Title);
		R().Property("OpenSLNTree_Button_ToolTip", CommandForm.ToolTip);
	EndIf;
	
	If Form.Items.Find("ItemListOpenSerialLotNumbersTree") = Undefined Then
		CommandButton = Form.Items.Add("ItemListOpenSerialLotNumbersTree", Type("FormButton"), ItemListForm.CommandBar); // FormButton
		CommandButton.CommandName = "OpenSerialLotNumbersTree";
	EndIf;	
EndProcedure


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

Procedure FillSerialLotNumbersUse(Object, AddInfo = Undefined) Export
	For Each RowItemList In Object.ItemList Do
		RowItemList.UseSerialLotNumber = IsItemKeyWithSerialLotNumbers(RowItemList.ItemKey);
	EndDo;
EndProcedure

Function IsItemKeyWithSerialLotNumbers(ItemKey, AddInfo = Undefined) Export
	If Not ValueIsFilled(ItemKey) Then
		Return False;
	EndIf;

	Return ItemKey.Item.ItemType.UseSerialLotNumber;
EndFunction

// Check filling.
// 
// Parameters:
//  Object - DocumentObject.SalesInvoice
// 
// Returns:
//  Boolean - Check filling
Function CheckFilling(Object) Export
	IsOk = True;
	For Each Row In Object.ItemList Do
		If Not IsItemKeyWithSerialLotNumbers(Row.ItemKey) Then
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
						StrTemplate(R().Error_111, Serial.SerialLotNumber), "ItemList[" + Format(
						(ItemRow.LineNumber - 1), "NZ=0; NG=0;") + "].SerialLotNumbersPresentation", Object);
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
//  
Function CreateNewSerialLotNumber(Options) Export
	
	NewSerial = Catalogs.SerialLotNumbers.CreateItem();
	NewSerial.Description = Options.Description;
	NewSerial.SerialLotNumberOwner = Options.Owner;
	NewSerial.StockBalanceDetail = GetStockBalanceDetailByOwner(Options.Owner);
	NewSerial.EachSerialLotNumberIsUnique = GetItemTypeByOwner(Options.Owner).EachSerialLotNumberIsUnique;
	If NewSerial.CheckFilling() Then
		NewSerial.Write();
	EndIf;
	NewSerial.Write();
	
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
	Str.isMatch = CommonFunctionsClientServer.Regex(Value, Str.RegExp);
	
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

Function isAnyMovementBySerial(SerialLotNumberRef) Export
	
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	R4010B_ActualStocks.SerialLotNumber
		|FROM
		|	AccumulationRegister.R4010B_ActualStocks AS R4010B_ActualStocks
		|WHERE
		|	R4010B_ActualStocks.SerialLotNumber = &SerialLotNumber";
	
	Query.SetParameter("SerialLotNumber", SerialLotNumberRef);
	
	Return Not Query.Execute().IsEmpty();
	
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
	Options = SerialLotNumbersServer.GetSeriallotNumerOptions();
	Options.Barcode = Barcode;
	Options.Owner = ItemKey;
	Options.Description = Barcode;
	SerialLotNumber = SerialLotNumbersServer.CreateNewSerialLotNumber(Options);
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

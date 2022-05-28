
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
	NewSerial.StockBalanceDetail = Catalogs.SerialLotNumbers.GetStockBalanceDetailByOwner(Options.Owner);
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
	
	Option = New Structure();
	Option.Insert("ItemKey", ItemKey);
	Option.Insert("SerialLotNumber", SerialLotNumber);
	BarcodeServer.UpdateBarcode(Barcode, Option);
	
	Return SerialLotNumber;
EndFunction

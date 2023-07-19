
#Region Info

Function Tests() Export
	TestList = New Array;
	TestList.Add("CreateItems");
	Return TestList;
EndFunction

#EndRegion

#Region Items

Function CreateItems() Export
	Data = GenerateDataForAccessTest();
	Return "";
EndFunction

#EndRegion

#Region Service

Function GenerateDataForAccessTest()
	
	Data = New Structure;
	Data.Insert("ItemType", Catalogs.ItemTypes.GetRef(New UUID("11111111-1111-1111-1111-111111111111")));
	Data.Insert("Unit", Catalogs.Units.GetRef(New UUID("11111111-1111-1111-1111-111111111111")));
	Data.Insert("ItemList", New Array);
	
	//@skip-check reading-attribute-from-database
	If Not IsBlankString(Data.ItemType.DataVersion) Then
		Return Data;
	EndIf;
	
	ItemType = Catalogs.ItemTypes.CreateItem();
	ItemType.Description_en = "DG. Item type";	
	ItemType.SetNewObjectRef(Data.ItemType);
	ItemType.Type = Enums.ItemTypes.Product;
	ItemType.Write();
	
	Unit = Catalogs.Units.CreateItem();
	Unit.Description_en = "DG. Unit";	
	Unit.SetNewObjectRef(Data.Unit);
	Unit.Write();
	
	CommonFunctionsClientServer.ShowUsersMessage("Item. Start date: " + CurrentSessionDate());
	For Index = 0 To 10000 Do
		Item = Catalogs.Items.CreateItem();
		Item.Description_en = "DG. Item: " + Index;	
		Item.ItemType = Data.ItemType;
		Item.Unit = Data.Unit;
		Item.Write();
		
		Str = New Structure;
		Str.Insert("Item", Item.Ref);
		Str.Insert("ItemKey", Catalogs.ItemKeys.EmptyRef());
		Str.Insert("Barcode", "");
		Data.ItemList.Add(Str);
	EndDo;
	CommonFunctionsClientServer.ShowUsersMessage("Item. End date: " + CurrentSessionDate());

	CommonFunctionsClientServer.ShowUsersMessage("Item key. Start date: " + CurrentSessionDate());
	For Index = 0 To Data.ItemList.Count() - 1 Do
		Row = Data.ItemList[Index];
		ItemKey = Catalogs.ItemKeys.CreateItem();
		ItemKey.Description_en = "DG. Item key: " + Index;	
		ItemKey.Item = Row.Item;
		ItemKey.Write();
		
		Row.ItemKey = ItemKey.Ref;
	EndDo;
	CommonFunctionsClientServer.ShowUsersMessage("Item key. End date: " + CurrentSessionDate());
	
	CommonFunctionsClientServer.ShowUsersMessage("Barcode. Start date: " + CurrentSessionDate());
	For Index = 0 To Data.ItemList.Count() - 1 Do
		Row = Data.ItemList[Index];
		Barcode = "DG" + Format(Index, "ND=12; NLZ=; NG=;");
		
		Reg = InformationRegisters.Barcodes.CreateRecordManager();
		Reg.Barcode = Barcode;
		Reg.ItemKey = Row.ItemKey;
		Reg.Unit = Data.Unit;
		Reg.Write();
		Row.Barcode = Barcode;
	EndDo;
	CommonFunctionsClientServer.ShowUsersMessage("Barcode. End date: " + CurrentSessionDate());
	
	Return Data;
EndFunction

Procedure AddAccessRow(AccessGroup, Key, Ref, Modify)
	NewRow = AccessGroup.ObjectAccess.Add();
	NewRow.Key = Key;
	NewRow.ValueRef = Ref;
	NewRow.Modify = Modify;
EndProcedure

#EndRegion
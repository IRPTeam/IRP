
Function CheckUnitForItem(ItemObject) Export 
	Return GetItemInfo.CheckUnitForItem(ItemObject);
EndFunction

Function CheckUnitForItemKey(ItemObject) Export
	Return GetItemInfo.CheckUnitForItemKey(ItemObject);
EndFunction

Procedure CheckUniqueDescriptions(Cancel, Object) Export
	CommonFunctionsServer.CheckUniqueDescription(Cancel, Object);
EndProcedure

Procedure FillCheckProcessing_Catalog_SerialLotNumbers(Cancel, Object) Export
	If Object.IsNew() Then
		Return;
	EndIf;
	
	RegIsFilled = R4014B_SerialLotNumber_IsFilled(Object.Ref);
	
	If Object.StockBalanceDetail <> Object.Ref.StockBalanceDetail And RegIsFilled Then
		ShowUserMessage(Cancel, Object, "StockBalanceDetail");
	EndIf;
	
	If Object.BatchBalanceDetail <> Object.Ref.BatchBalanceDetail And RegIsFilled Then
		ShowUserMessage(Cancel, Object, "BatchBalanceDetail");
	EndIf;

	If Object.SerialLotNumberOwner <> Object.Ref.SerialLotNumberOwner And RegIsFilled Then
		ShowUserMessage(Cancel, Object, "SerialLotNumberOwner");
	EndIf;
EndProcedure

Procedure FillCheckProcessing_Catalog_SourceOfOrigins(Cancel, Object) Export
	If Object.IsNew() Then
		Return;
	EndIf;
	
	RegIsFilled = R9010B_SourceOfOriginStock_IsFilled(Object.Ref);
	
	If Object.SourceOfOriginOwner <> Object.Ref.SourceOfOriginOwner And RegIsFilled Then
		ShowUserMessage(Cancel, Object, "SourceOfOriginOwner");
	EndIf;
	
	If Object.BatchBalanceDetail <> Object.Ref.BatchBalanceDetail And RegIsFilled Then
		ShowUserMessage(Cancel, Object, "BatchBalanceDetail");
	EndIf;
EndProcedure

Procedure FillCheckProcessing_Catalog_ItemTypes(Cancel, Object) Export
	If Object.IsNew() Then
		Return;
	EndIf;
	
	RegIsFilled = R4010B_ActualStocs_R4050B_StockInventory_IsFilled(Object.Ref);
	
	If Object.Type <> Object.Ref.Type And RegIsFilled Then
		ShowUserMessage(Cancel, Object, "Type");
	EndIf;
	
	If Object.UseSerialLotNumber <> Object.Ref.UseSerialLotNumber And RegIsFilled Then
		ShowUserMessage(Cancel, Object, "UseSerialLotNumber");
	EndIf;

	If Object.StockBalanceDetail <> Object.Ref.StockBalanceDetail And RegIsFilled Then
		ShowUserMessage(Cancel, Object, "StockBalanceDetail");
	EndIf;
EndProcedure

Procedure FillCheckProcessing_Catalog_Items(Cancel, Object) Export
	If Object.IsNew() Then
		Return;
	EndIf;
	
	If Object.ItemType <> Object.Ref.ItemType And R4010B_ActualStocs_R4050B_StockInventory_IsFilled(Object.Ref) Then
		NewItemType = Object.ItemType;
		OldItemType = Object.Ref.ItemType;
		
		If NewItemType.Type <> OldItemType.Type 
			Or NewItemType.UseSerialLotNumber <> OldItemType.UseSerialLotNumber 
			Or NewItemType.StockBalanceDetail <> OldItemType.StockBalanceDetail Then
			
			RegIsFilled_ItemType = R4010B_ActualStocs_R4050B_StockInventory_IsFilled(OldItemType);
			If RegIsFilled_ItemType Then	  
				ShowUserMessage(Cancel, Object, "ItemType");
			EndIf;
			
		EndIf;
	EndIf;
EndProcedure

Procedure FillCheckProcessing_Catalog_ItemKeys(Cancel, Object) Export
	If Object.IsNew() Then
		Return;
	EndIf;
	
	If Object.Specification <> Object.Ref.Specification And R4010B_ActualStocs_R4050B_StockInventory_IsFilled(Object.Ref) Then
		ShowUserMessage(Cancel, Object, "Specification");
	EndIf;
EndProcedure

Function R4010B_ActualStocs_R4050B_StockInventory_IsFilled(Ref)
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	Reg.ItemKey AS ItemKey
		|FROM
		|	AccumulationRegister.R4010B_ActualStocks AS Reg
		|WHERE
		|	Reg.%1 = &Ref
		|
		|UNION ALL
		|
		|SELECT TOP 1
		|	Reg.ItemKey
		|FROM
		|	AccumulationRegister.R4050B_StockInventory AS Reg
		|WHERE
		|	Reg.%1 = &Ref";
		
	RefType = TypeOf(Ref);
	
	If RefType = Type("CatalogRef.ItemTypes") Then
		Condition = "ItemKey.Item.ItemType"; 
	ElsIf RefType = Type("CatalogRef.Items") Then
		Condition = "ItemKey.Item";
	ElsIf RefType = Type("CatalogRef.ItemKeys") Then
		Condition = "ItemKey";
	Else
		Raise StrTemplate("Unknown ref type: %1", RefType);
	EndIf;
	
	Query.Text = StrTemplate(Query.Text, Condition);
	Query.SetParameter("Ref", Ref);
	Return Not Query.Execute().IsEmpty();	
EndFunction

Function R4014B_SerialLotNumber_IsFilled(Ref) Export	
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	Reg.SerialLotNumber
		|FROM
		|	AccumulationRegister.R4014B_SerialLotNumber AS Reg
		|WHERE
		|	Reg.SerialLotNumber = &Ref";
	Query.SetParameter("Ref", Ref);
	Return Not Query.Execute().IsEmpty();
EndFunction

Function R9010B_SourceOfOriginStock_IsFilled(Ref) Export	
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	Reg.SourceOfOrigin
		|FROM
		|	AccumulationRegister.R9010B_SourceOfOriginStock AS Reg
		|WHERE
		|	Reg.SourceOfOrigin = &Ref";
	Query.SetParameter("Ref", Ref);
	Return Not Query.Execute().IsEmpty();
EndFunction

Procedure ShowUserMessage(Cancel, Object, AttributeName)
	Cancel = True;
	Attributes = Object.Metadata().Attributes;
	MessageText = StrTemplate(R().Error_141, Attributes[AttributeName].Synonym);
	CommonFunctionsClientServer.ShowUsersMessage(MessageText, AttributeName, Object);	
EndProcedure

Procedure FillCheckProcessing_BankReceipt_CurrencyExchange(Object, Cancel) Export
	MoneyDocumentsServer.FillCheckProcessing_BankReceipt_CurrencyExchange(Object, Cancel);
EndProcedure

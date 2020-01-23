Function SearchByBarcodes(Barcodes, PriceType = Undefined, PricePeriod = Undefined) Export
	
	ReturnValue = New Array;
	Query = New Query;
	Query.Text = "SELECT
		|	Barcodes.ItemKey AS ItemKey,
		|	Barcodes.ItemKey.Item AS Item,
		|	ISNULL(Barcodes.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
		|	Barcodes.Unit AS Unit,
		|	0 AS Price,
		|	1 AS Quantity,
		|	Value(Catalog.PriceTypes.EmptyRef) AS PriceType,
		|	Barcodes.Barcode AS Barcode
		|FROM
		|	InformationRegister.Barcodes AS Barcodes
		|WHERE
		|	Barcodes.Barcode In(&Barcodes)";
	Query.SetParameter("Barcodes", Barcodes);
	QueryExecution = Query.Execute();
	If QueryExecution.IsEmpty() Then
		Return ReturnValue;
	EndIf;
	QueryUnload = QueryExecution.Unload();
	
	// TODO: Refact by query
	If PriceType <> Undefined Then
		If PricePeriod = Undefined Then
			PricePeriod = CurrentDate();
		EndIf;
		PrePriceTable = QueryUnload.Copy( , "ItemKey, PriceType, Unit");
		PrePriceTable.FillValues(PriceType, "PriceType");
		ItemsInfo = GetItemInfo.ItemPriceInfoByTable(PrePriceTable, PricePeriod);
		For Each Row In ItemsInfo Do
			Filter = New Structure;
			Filter.Insert("ItemKey", Row.ItemKey);
			FoundedRows = QueryUnload.FindRows(Filter);
			For Each FoundedRow In FoundedRows Do
				FoundedRow.Price = Row.Price;
			EndDo;
		EndDo;
	EndIf;
	
	For Each Row In QueryUnload Do
		ItemStructure = New Structure;
		For Each Column In QueryUnload.Columns Do
			ItemStructure.Insert(Column.Name, Row[Column.Name]);
		EndDo;
		ReturnValue.Add(ItemStructure);
	EndDo;
	
	Return ReturnValue;
	
EndFunction

Function GetBarcodesByItemKey(ItemKey) Export
	
	ReturnValue = New Array;
	
	Query = New Query;
	Query.Text = "SELECT
	|	Barcodes.Barcode
	|FROM
	|	InformationRegister.Barcodes AS Barcodes
	|WHERE
	|	Barcodes.ItemKey = &ItemKey
	|GROUP BY
	|	Barcodes.Barcode";
	Query.SetParameter("ItemKey", ItemKey);
	QueryExecution = Query.Execute();
	QueryUnload = QueryExecution.Unload();
	ReturnValue = QueryUnload.UnloadColumn("Barcode");
	
	Return ReturnValue;
	
EndFunction

Function GetBarcodePicture(BarcodeParameters) Export
	
	Return New Picture;
	
EndFunction

Function GetQRPicture(BarcodeParameters) Export
	
	Return New Picture;
	
EndFunction


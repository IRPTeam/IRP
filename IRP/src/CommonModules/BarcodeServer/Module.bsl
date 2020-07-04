Function SearchByBarcodes(Barcodes, AddInfo) Export
	
	ReturnValue = New Array;
	Query = New Query;
	Query.Text = "SELECT
		|	Barcodes.ItemKey AS ItemKey,
		|	Barcodes.ItemKey.Item AS Item,
		|	ISNULL(Barcodes.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
		|	Barcodes.Unit AS Unit,
		|	1 AS Quantity,
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
	PricePeriod = CurrentDate();
	PriceType = Catalogs.PriceTypes.EmptyRef();
	If AddInfo.Property("PriceType", PriceType) Then
		AddInfo.Property("PricePeriod", PricePeriod);
		QueryUnload.Columns.Add("Price", Metadata.DefinedTypes.typePrice.Type);		
		PervPriceTable = QueryUnload.Copy( , "ItemKey, Unit");
		PervPriceTable.Columns.Add("PriceType", New TypeDescription("CatalogRef.PriceTypes"));
		PervPriceTable.FillValues(PriceType, "PriceType");
		ItemsInfo = GetItemInfo.ItemPriceInfoByTable(PervPriceTable, PricePeriod);
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


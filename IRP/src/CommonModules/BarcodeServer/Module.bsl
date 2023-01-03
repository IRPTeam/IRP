// @strict-types

// Search by barcodes.
// 
// Parameters:
//  Barcodes - Array of DefinedType.typeBarcode - Barcodes
//  Settings - See BarcodeClient.GetBarcodeSettings
// 
// Returns:
//  Array of Structure:
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * Unit - CatalogRef.Units -
// * Quantity - DefinedType.typeQuantity
// * ItemKeyUnit - CatalogRef.Units -
// * ItemUnit - CatalogRef.Units -
// * hasSpecification - Boolean -
// * Barcode  - DefinedType.typeBarcode
// * ItemType - CatalogRef.ItemTypes -
// * UseSerialLotNumber - Boolean -
// * AlwaysAddNewRowAfterScan - Boolean -
Function SearchByBarcodes(Val Barcodes, Settings) Export

	ReturnValue = New Array();
	Query = New Query();
	Query.Text = "SELECT
	|	Barcodes.ItemKey AS ItemKey,
	|	Barcodes.ItemKey.Item AS Item,
	|	ISNULL(Barcodes.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
	|	Barcodes.SourceOfOrigin AS SourceOfOrigin,
	|	Barcodes.Unit AS Unit,
	|	1 AS Quantity,
	|	Barcodes.ItemKey.Unit AS ItemKeyUnit,
	|	Barcodes.ItemKey.Item.Unit AS ItemUnit,
	|	NOT Barcodes.ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	Barcodes.Barcode AS Barcode,
	|	Barcodes.ItemKey.Item.ItemType AS ItemType,
	|	Barcodes.ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
	|	Barcodes.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Service) AS isService,
	|	Barcodes.ItemKey.Item.ItemType.AlwaysAddNewRowAfterScan AS AlwaysAddNewRowAfterScan
	|FROM
	|	InformationRegister.Barcodes AS Barcodes
	|WHERE
	|	Barcodes.Barcode In (&Barcodes)";
	Query.SetParameter("Barcodes", Barcodes);
	QueryExecution = Query.Execute();
	If QueryExecution.IsEmpty() Then
		Return ReturnValue;
	EndIf;
	QueryUnload = QueryExecution.Unload();
	
	// TODO: Refact by query
	If Not Settings.PriceType = Undefined Then
		QueryUnload.Columns.Add("Price", Metadata.DefinedTypes.typePrice.Type);
		PreviousPriceTable = QueryUnload.Copy( , "ItemKey, Unit, ItemKeyUnit, ItemUnit, hasSpecification");
		PreviousPriceTable.Columns.Add("PriceType", New TypeDescription("CatalogRef.PriceTypes"));
		PreviousPriceTable.FillValues(Settings.PriceType, "PriceType");
		ItemsInfo = GetItemInfo.ItemPriceInfoByTable(PreviousPriceTable, Settings.PricePeriod);
		For Each Row In ItemsInfo Do
			Filter = New Structure();
			Filter.Insert("ItemKey", Row.ItemKey);
			FoundedRows = QueryUnload.FindRows(Filter);
			For Each FoundedRow In FoundedRows Do
				FoundedRow.Price = Row.Price;
			EndDo;
		EndDo;
	EndIf;

	For Each Row In QueryUnload Do
		ItemStructure = New Structure();
		For Each Column In QueryUnload.Columns Do
			ItemStructure.Insert(Column.Name, Row[Column.Name]);
		EndDo;
		ReturnValue.Add(ItemStructure);
	EndDo;

	Return ReturnValue;

EndFunction

// Search by barcodes.
// 
// Parameters:
//  BarcodeTable - See GetBarcodeTable
//  AddInfo - Structure
// 
// Returns:
//  ValueTable:
// * Key - String
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * Unit - CatalogRef.Units -
// * Quantity - DefinedType.typeQuantity
// * ItemKeyUnit - CatalogRef.Units -
// * ItemUnit - CatalogRef.Units -
// * hasSpecification - Boolean -
// * Barcode  - DefinedType.typeBarcode
// * ItemType - CatalogRef.ItemTypes -
// * UseSerialLotNumber - Boolean -
// * Image - CatalogRef.Files -
Function SearchByBarcodes_WithKey(BarcodeTable, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text = "SELECT
	|	BarcodeTable.Key,
	|	BarcodeTable.Barcode,
	|	BarcodeTable.Quantity
	|INTO BarcodeTable
	|FROM
	|	&BarcodeTable AS BarcodeTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Barcodes.ItemKey AS ItemKey,
	|	Barcodes.ItemKey.Item AS Item,
	|	ISNULL(Barcodes.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
	|	Barcodes.Unit AS Unit,
	|	Barcodes.ItemKey.Unit AS ItemKeyUnit,
	|	Barcodes.ItemKey.Item.Unit AS ItemUnit,
	|	NOT Barcodes.ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	Barcodes.ItemKey.Item.ItemType AS ItemType,
	|	Barcodes.ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
	|	BarcodeTable.Key,
	|	BarcodeTable.Barcode,
	|	BarcodeTable.Quantity
	|INTO MainData
	|FROM
	|	BarcodeTable AS BarcodeTable
	|		LEFT JOIN InformationRegister.Barcodes AS Barcodes
	|		ON BarcodeTable.Barcode = Barcodes.Barcode
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
	|		INNER JOIN MainData AS MainData
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
	|		INNER JOIN MainData AS MainData
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
	|	MainData.Barcode,
	|	MainData.Quantity,
	|	Images.File AS Image
	|FROM
	|	MainData AS MainData
	|		LEFT JOIN Images AS Images
	|		ON CASE
	|			WHEN Images.ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)
	|				THEN MainData.Item = Images.Item
	|			ELSE MainData.ItemKey = Images.ItemKey
	|		END";
	Query.SetParameter("BarcodeTable", BarcodeTable);
	QueryExecution = Query.Execute();
	QueryUnload = QueryExecution.Unload();
	
	Return QueryUnload;

EndFunction

// Get standard item table.
// 
// Returns:
//  ValueTable - Get standard item table:
// * Key - String -
// * Quantity - DefinedType.typeQuantity
// * Barcode  - DefinedType.typeBarcode
Function GetBarcodeTable() Export
	Table = New ValueTable();
	Table.Columns.Add("Key", New TypeDescription("String"), "Key", 15);
	Table.Columns.Add("Quantity", Metadata.DefinedTypes.typeQuantity.Type, Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym, 15);
	Table.Columns.Add("Barcode", Metadata.DefinedTypes.typeBarcode.Type, Metadata.InformationRegisters.Barcodes.Dimensions.Barcode.Synonym, 20);
	Return Table
EndFunction

// Get barcodes by item key.
// 
// Parameters:
//  ItemKey - CatalogRef.ItemKeys - Item key
// 
// Returns:
//  Array of DefinedType.typeBarcode - Get barcodes by item key
Function GetBarcodesByItemKey(ItemKey) Export

	ReturnValue = New Array();

	Query = New Query();
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

// Get barcode picture.
// 
// Parameters:
//  BarcodeParameters - See GetBarcodeDrawParameters
// 
// Returns:
//  Picture - Get barcode picture
Function GetBarcodePicture(BarcodeParameters) Export

	Return New Picture();

EndFunction

// Get QRPicture.
// 
// Parameters:
//  BarcodeParameters - See GetBarcodeDrawParameters
// 
// Returns:
//  Picture - Get QRPicture
Function GetQRPicture(BarcodeParameters) Export

	Return New Picture();

EndFunction

// Get barcode draw parameters.
// 
// Returns:
//  Structure - Get barcode draw parameters:
// * Width - Number -
// * Height - Number -
// * Barcode - String -
// * CodeType - String -
// * ShowText - Boolean -
// * SizeOfFont - Number -
Function GetBarcodeDrawParameters() Export
	BarcodeParameters = New Structure;
	BarcodeParameters.Insert("Width", 0);
	BarcodeParameters.Insert("Height", 0);
	BarcodeParameters.Insert("Barcode", "");
	BarcodeParameters.Insert("CodeType", "");
	BarcodeParameters.Insert("ShowText", True);
	BarcodeParameters.Insert("SizeOfFont", 14);
	Return BarcodeParameters;
EndFunction

// Update barcode.
// 
// Parameters:
//  Barcode - DefinedType.typeBarcode - Barcode
//  Params - Undefined - Params
//  AddInfo - Undefined - Add info
Procedure UpdateBarcode(Barcode, Params = Undefined, AddInfo = Undefined) Export

	If IsBlankString(Barcode) Then
		Return;
	EndIf;

	NewBarcode = InformationRegisters.Barcodes.CreateRecordSet();
	NewBarcode.Filter.Barcode.Set(TrimAll(Barcode));
	If Not Params = Undefined Then
		Row = NewBarcode.Add();
		FillPropertyValues(Row, Params);
		Row.Barcode = TrimAll(Barcode);

		If Row.Unit.IsEmpty() Then
			Row.Unit = GetItemInfo.ItemUnitInfo(Row.ItemKey).Unit;
		EndIf;
	EndIf;
	NewBarcode.Write();
EndProcedure
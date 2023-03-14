
// Save scanned barcode.
// 
// Parameters:
//  Basis - DocumentRef - Any basis document ref
//  Barcode - DefinedType.typeBarcode, Array - Array or single barcode to save 
Procedure SaveBarcode(Basis, Barcode, Quantity = 1) Export

	NewBarcode = CreateRecordManager();

	NewBarcode.InfoID = New UUID();
	NewBarcode.Period = CommonFunctionsServer.GetCurrentSessionDate();
	NewBarcode.User = SessionParameters.CurrentUser;
	NewBarcode.Basis = Basis;
	NewBarcode.Barcode = Barcode;
	NewBarcode.Count = Quantity;

	NewBarcode.Write();

EndProcedure

// Clear scanned history by basis.
// 
// Parameters:
//  Basis - DocumentRef - Any basis document ref
Procedure ClearHistoryByBasis(Basis) Export
	If Not ValueIsFilled(Basis) Then
		Return;
	EndIf;

	NewBarcodeSet = CreateRecordSet();
	NewBarcodeSet.Filter.Basis.Set(Basis);
	NewBarcodeSet.Write();

EndProcedure

// Get all scanned barcode by  basis.
// 
// Parameters:
//  Basis - DocumentRef - Any basis document ref
// 
// Returns:
//  ValueTable - All scanned barcode with Item key and Items
Function GetAllScannedBarcode(Basis) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	Barcodes.Barcode,
	|	Barcodes.ItemKey.Item AS Item,
	|	Barcodes.ItemKey,
	|	Barcodes.SerialLotNumber,
	|	Barcodes.Unit,
	|	T1010S_ScannedBarcode.Count AS ScannedQuantity
	|FROM
	|	InformationRegister.T1010S_ScannedBarcode AS T1010S_ScannedBarcode
	|		LEFT JOIN InformationRegister.Barcodes AS Barcodes
	|		ON T1010S_ScannedBarcode.Barcode = Barcodes.Barcode
	|WHERE
	|	T1010S_ScannedBarcode.Basis = &Basis";

	Query.SetParameter("Basis", Basis);

	QueryResult = Query.Execute().Unload();

	Return QueryResult;

EndFunction

// Union document and scanned data.
// 
// Parameters:
//  Basis - DocumentRef - Any basis document ref
//  CurrentOwnnerItemList - ValueTable - Current item list at form owner
//  UseSerialLot - Boolean - use serial lot number
//  CurrentOwnnerSerialLotNumbers - ValueTable, Undefined - Current item list at form owner
// 
// Returns:
//  ValueTable - All scanned barcode with Item key and Items
Function GetCommonTable(Basis, CurrentOwnnerItemList, UseSerialLot = False, CurrentOwnnerSerialLotNumbers = Undefined) Export

	If CurrentOwnnerSerialLotNumbers = Undefined Then
		CurrentOwnnerSerialLotNumbers = New ValueTable();
		CurrentOwnnerSerialLotNumbers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
		CurrentOwnnerSerialLotNumbers.Columns.Add("Quantity", New TypeDescription("Number"));
		CurrentOwnnerSerialLotNumbers.Columns.Add("SerialLotNumber", New TypeDescription("CatalogRef.SerialLotNumbers"));
	EndIf;

	Query = New Query();
	Query.Text =
	"SELECT
	|	Barcodes.ItemKey,
	|	Barcodes.Unit,
	|	Barcodes.SerialLotNumber,
	|	SUM(T1010S_ScannedBarcode.Count) AS ScannedQuantity
	|INTO ScannedInfo
	|FROM
	|	InformationRegister.T1010S_ScannedBarcode AS T1010S_ScannedBarcode
	|		LEFT JOIN InformationRegister.Barcodes AS Barcodes
	|		ON T1010S_ScannedBarcode.Barcode = Barcodes.Barcode
	|WHERE
	|	T1010S_ScannedBarcode.Basis = &Basis
	|GROUP BY
	|	Barcodes.ItemKey,
	|	Barcodes.Unit,
	|	Barcodes.SerialLotNumber
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemsList.Key,
	|	ItemsList.ItemKey,
	|	ItemsList.Quantity AS Quantity,
	|	ItemsList.Unit
	|INTO ItemsList
	|FROM
	|	&DocumentItemList AS ItemsList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SerialLotNumbers.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity AS Quantity
	|INTO SerialLotNumbers
	|FROM
	|	&DocumentISerialLotNumbers AS SerialLotNumbers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemsList.ItemKey,
	|	ISNULL(SerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
	|	ISNULL(SerialLotNumbers.Quantity, ItemsList.Quantity) AS Quantity,
	|	ItemsList.Unit
	|INTO DocumentData
	|FROM
	|	ItemsList AS ItemsList
	|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
	|		ON ItemsList.Key = SerialLotNumbers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocumentData.ItemKey,
	|	DocumentData.SerialLotNumber,
	|	DocumentData.Quantity,
	|	DocumentData.Unit,
	|	0 AS ScannedQuantity
	|INTO VTAll
	|FROM
	|	DocumentData AS DocumentData
	|
	|UNION ALL
	|
	|SELECT
	|	ScannedInfo.ItemKey,
	|	ScannedInfo.SerialLotNumber,
	|	0,
	|	ScannedInfo.Unit,
	|	ScannedInfo.ScannedQuantity
	|FROM
	|	ScannedInfo AS ScannedInfo
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VTAll.ItemKey.Item AS Item,
	|	VTAll.ItemKey,
	|	VTAll.ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
	|	VTAll.SerialLotNumber,
	|	VTAll.SerialLotNumber AS ScannedSerialLotNumber,
	|	SUM(VTAll.Quantity) AS Quantity,
	|	VTAll.Unit,
	|	SUM(VTAll.ScannedQuantity) AS ScannedQuantity
	|FROM
	|	VTAll AS VTAll
	|GROUP BY
	|	VTAll.ItemKey.Item,
	|	VTAll.ItemKey,
	|	VTAll.SerialLotNumber,
	|	VTAll.Unit,
	|	VTAll.ItemKey.Item.ItemType.UseSerialLotNumber";

	Query.SetParameter("Basis", Basis);
	Query.SetParameter("DocumentItemList", CurrentOwnnerItemList);
	Query.SetParameter("DocumentISerialLotNumbers", CurrentOwnnerSerialLotNumbers);
	
	QueryResult = Query.Execute().Unload();
	If Not UseSerialLot Then
		QueryResult.GroupBy("Item, ItemKey, Unit", "Quantity, ScannedQuantity");
	EndIf;

	Return QueryResult;

EndFunction
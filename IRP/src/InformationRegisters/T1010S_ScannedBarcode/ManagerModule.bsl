
// Save scanned barcode.
// 
// Parameters:
//  Basis - DocumentRef - Any basis document ref
//  Barcode - DefinedType.typeBarcode, Array - Array or single barcode to save 
Procedure SaveBarcode(Basis, Barcode, Quantity = 1) Export

	NewBarcode = InformationRegisters.T1010S_ScannedBarcode.CreateRecordManager();

	NewBarcode.InfoID = New UUID();
	NewBarcode.Period = CurrentDate();
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

	NewBarcodeSet = InformationRegisters.T1010S_ScannedBarcode.CreateRecordSet();
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
// 
// Returns:
//  ValueTable - All scanned barcode with Item key and Items
Function GetCommonTable(Basis, CurrentOwnnerItemList) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	Barcodes.ItemKey,
	|	Barcodes.Unit,
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
	|	Barcodes.Unit
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocumentData.ItemKey,
	|	DocumentData.Quantity AS Quantity,
	|	DocumentData.Unit
	|INTO DocumentData
	|FROM
	|	&DocumentItemList AS DocumentData
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocumentData.ItemKey,
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
	|	SUM(VTAll.Quantity) AS Quantity,
	|	VTAll.Unit,
	|	SUM(VTAll.ScannedQuantity) AS ScannedQuantity
	|FROM
	|	VTAll AS VTAll
	|GROUP BY
	|	VTAll.ItemKey.Item,
	|	VTAll.ItemKey,
	|	VTAll.Unit";

	Query.SetParameter("Basis", Basis);
	Query.SetParameter("DocumentItemList", CurrentOwnnerItemList);

	QueryResult = Query.Execute().Unload();

	Return QueryResult;

EndFunction
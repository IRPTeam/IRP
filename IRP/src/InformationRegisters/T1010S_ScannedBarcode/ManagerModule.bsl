
// Save scanned barcode.
// 
// Parameters:
//  Basis - DocumentRef - Any basis document ref
//  Barcode - DefinedType.typeBarcode, Array - Array or single barcode to save 
Procedure SaveBarcode(Basis, Barcode) Export
	
	NewBarcode = InformationRegisters.T1010S_ScannedBarcode.CreateRecordManager();
	
	NewBarcode.ID = New UUID();
	NewBarcode.Period = CurrentDate();
	NewBarcode.User = SessionParameters.CurrentUser;
	NewBarcode.Basis = Basis;
	NewBarcode.Barcode = Barcode;
	NewBarcode.Count = 1;
	
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
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Barcodes.Barcode,
		|	Barcodes.ItemKey.Item AS Item,
		|	Barcodes.ItemKey,
		|	Barcodes.SerialLotNumber,
		|	Barcodes.Unit,
		|	T1010S_ScannedBarcode.Count
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

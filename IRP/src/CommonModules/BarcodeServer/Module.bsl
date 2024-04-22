// @strict-types

// Search by barcodes.
// 
// Parameters:
//  Barcodes - Array of DefinedType.typeBarcode - Barcodes
//  Settings - See BarcodeClient.GetBarcodeServerSettings
// 
// Returns:
//  Structure:
//  * FoundedItems - Array of See FillFoundedItems
//  * Barcodes - Array of DefinedType.typeBarcode -
Function SearchByBarcodes(Val Barcodes, Settings) Export

	Result = New Structure;
	Result.Insert("FoundedItems", New Array);
	Result.Insert("Barcodes", New Array);

	If Barcodes.Count() = 0 Then
		Return Result;
	EndIf;

	If Settings.SaveScannedBarcode Then
		For Each Barcode In Barcodes Do
			If Not IsBlankString(Barcode) Then
				InformationRegisters.T1010S_ScannedBarcode.SaveBarcode(Settings.BarcodeBasis, Barcode);
			EndIf;
		EndDo;
	EndIf;
	
	If Settings.SearchUserByBarcode Then
		FillUsersByBarcode(Barcodes, Result);
		Return Result;
	EndIf;

	BarcodeVT = New ValueTable();
	BarcodeVT.Columns.Add("Barcode", Metadata.DefinedTypes.typeBarcode.Type);

	For Each Row In Barcodes Do
		NewRow = BarcodeVT.Add();
		//@skip-check property-return-type
		NewRow.Barcode = Row;
	EndDo;

	QueryTable = GetItemInfoByBarcode(Settings, BarcodeVT);
	
	For Each Row In QueryTable Do
		If Row.BarcodeEmpty Then
			//@skip-check typed-value-adding-to-untyped-collection
			Result.Barcodes.Add(Row.Barcode);
		Else
			ItemStructure = FillFoundedItems(Row, QueryTable);
			//@skip-check typed-value-adding-to-untyped-collection
			Result.FoundedItems.Add(ItemStructure);
		EndIf;
	EndDo;
	Return Result;
EndFunction

// Fill founded items.
// 
// Parameters:
//  Row - ValueTableRow Of See GetItemInfoByBarcode - 
//  QueryTable - See GetItemInfoByBarcode
// 
// Returns:
//  Structure:
//   * ItemType - CatalogRef.ItemTypes -
//   * Item - CatalogRef.Items -
//   * ItemKey - CatalogRef.ItemKeys -
//   * SerialLotNumber - CatalogRef.SerialLotNumbers -
//   * Unit - CatalogRef.Units -
//   * Quantity - DefinedType.typeQuantity
//   * BarcodeEmpty - Boolean -
//   * PriceType - CatalogRef.PriceTypes -
//   * Date  - Date -
//   * hasSpecification - Boolean -
//   * Barcode - String -
//   * UseSerialLotNumber - Boolean -
//   * isService - Boolean -
//   * isCertificate - Boolean -
//   * AlwaysAddNewRowAfterScan - Boolean -
//   * EachSerialLotNumberIsUnique - Boolean -
//   * ControlCodeString - Boolean -
//   * SourceOfOrigin - CatalogRef.SourceOfOrigins -
//   * ControlCodeStringType - EnumRef.ControlCodeStringType -
Function FillFoundedItems(Val Row, QueryTable) Export
	ItemStructure = New Structure();
	For Each Column In QueryTable.Columns Do
		ItemStructure.Insert(Column.Name, Row[Column.Name]);
	EndDo;
	//@skip-check constructor-function-return-section
	Return ItemStructure
EndFunction

// Get item info by barcode.
// Has to be the same as See GetItemInfo.GetInfoByItemsKey
// 
// 
// Parameters:
//  Settings - See BarcodeClient.GetBarcodeServerSettings
//  BarcodeVT - ValueTable - Barcode VT:
// * Barcode - String -
// 
// Returns:
//  ValueTable - Get item info by barcode:
//  * ItemType - CatalogRef.ItemTypes -
//  * Item - CatalogRef.Items -
//  * ItemKey - CatalogRef.ItemKeys -
//  * SerialLotNumber - CatalogRef.SerialLotNumbers -
//  * Unit - CatalogRef.Units -
//  * ItemKeyUnit - CatalogRef.Units -
//  * ItemUnit - CatalogRef.Units -
//  * Quantity - DefinedType.typeQuantity
//  * BarcodeEmpty - Boolean -
//  * PriceType - CatalogRef.PriceTypes -
//  * Date  - Date -
//  * hasSpecification - Boolean -
//  * Barcode - String -
//  * UseSerialLotNumber - Boolean -
//  * isService - Boolean -
//  * isCertificate - Boolean -
//  * AlwaysAddNewRowAfterScan - Boolean -
//  * EachSerialLotNumberIsUnique - Boolean -
//  * ControlCodeString - Boolean -
//  * SourceOfOrigin - CatalogRef.SourceOfOrigins -
//  * ControlCodeStringType - EnumRef.ControlCodeStringType -
Function GetItemInfoByBarcode(Settings, BarcodeVT)
	Query = New Query();
	Query.Text = 
		"SELECT
		|	BarcodeList.Barcode
		|INTO VTBarcode
		|FROM
		|	&BarcodeList AS BarcodeList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Barcodes.ItemKey.Item.ItemType AS ItemType,
		|	Barcodes.ItemKey.Item AS Item,
		|	Barcodes.ItemKey AS ItemKey,
		|	ISNULL(Barcodes.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
		|	Barcodes.Unit AS Unit,
		|	Barcodes.ItemKey.Unit AS ItemKeyUnit,
		|	Barcodes.ItemKey.Item.Unit AS ItemUnit,
		|	1 AS Quantity,
		|	Barcodes.ItemKey IS NULL AS BarcodeEmpty,
		|	&PriceType AS PriceType,
		|	&Date AS Date,
		|	NOT Barcodes.ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
		|	VTBarcode.Barcode AS Barcode,
		|	Barcodes.ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
		|	Barcodes.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Service) OR Barcodes.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Certificate) AS isService,
		|	Barcodes.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Certificate) AS isCertificate,
		|	Barcodes.ItemKey.Item.ItemType.AlwaysAddNewRowAfterScan AS AlwaysAddNewRowAfterScan,
		|	ISNULL(Barcodes.SerialLotNumber.EachSerialLotNumberIsUnique, False) AS EachSerialLotNumberIsUnique,
		|	CASE WHEN &IgnoreCodeStringControl THEN 
		|		False 
		|	ELSE 
		|		Barcodes.ItemKey.Item.ControlCodeString 
		|	END AS ControlCodeString,
		|	Barcodes.SourceOfOrigin AS SourceOfOrigin,
		|	Barcodes.ItemKey.Item.ControlCodeStringType AS ControlCodeStringType
		|FROM
		|	VTBarcode AS VTBarcode
		|		LEFT JOIN InformationRegister.Barcodes AS Barcodes
		|		ON VTBarcode.Barcode = Barcodes.Barcode";
	Query.SetParameter("BarcodeList", BarcodeVT);
	Query.SetParameter("PriceType", Settings.PriceType);
	Query.SetParameter("Date", CommonFunctionsServer.GetCurrentSessionDate());
	Query.SetParameter("IgnoreCodeStringControl", SessionParameters.Workstation.IgnoreCodeStringControl);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable
EndFunction

// Fill users by barcode.
// 
// Parameters:
//  Barcodes - Array of DefinedType.typeBarcode - Barcodes
//  Result - Structure - Result:
// * FoundedItems - Array of Structure -
// * Barcodes - Array of DefinedType.typeBarcode -
// 
// Returns:
//  Structure - Fill users by barcode:
// * FoundedItems - Array of Structure:
// 	** User - CatalogRef.Users -
// 	** Barcode - DefinedType.typeBarcode -
// * Barcodes - Array of DefinedType.typeBarcode -
Function FillUsersByBarcode(Barcodes, Result)
	UsersDataByBarcode = GetUsersDataByBarcode(Barcodes);
	If UsersDataByBarcode.Count() = 0 Then
		Result.Barcodes.Add(Barcodes[0]);
	Else
		Result.FoundedItems.Add(New Structure("User, Barcode", UsersDataByBarcode[0].User, UsersDataByBarcode[0].Barcode));
	EndIf;
	Return Result;
EndFunction

// Get users data by barcode.
// 
// Parameters:
//  Barcodes - Array of DefinedType.typeBarcode - Barcodes
// 
// Returns:
//  ValueTable - Get users data by barcode:
//  * User - CatalogRef.Users -
//  * Barcode - DefinedType.typeBarcode -
Function GetUsersDataByBarcode(Barcodes)
	Query = New Query();
	Query.Text = 
		"SELECT
		|	Users.Ref AS User,
		|	Users.UserID AS Barcode
		|FROM
		|	Catalog.Users AS Users
		|WHERE
		|	NOT Users.DeletionMark
		|	AND Users.UserID IN (&Barcodes)";
	Query.SetParameter("Barcodes", Barcodes);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable
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

	BarcodeParameters.CodeType = "QR"; 
	Return GetBarcodePicture(BarcodeParameters);

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

// Get document barcode.
// 
// Parameters:
//  Source - DocumentRefDocumentName - Source
// 
// Returns:
//  String - Document barcode
Function GetDocumentBarcode(Source) Export
	Str = New Structure();
	Str.Insert("Type", Source.Metadata().Name);
	Str.Insert("Code", String(Source.UUID()));
	Return CommonFunctionsServer.SerializeJSON(Str);
EndFunction
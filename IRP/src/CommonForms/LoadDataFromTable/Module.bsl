// @strict-types

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	LoadType = "Barcode";
	HeadersRows = 2;
	
	InputFieldsForLoadData = Undefined;
	Parameters.Property("FieldsForLoadData", InputFieldsForLoadData);
	
	FieldsForLoadData = New Structure;
	If TypeOf(InputFieldsForLoadData) = Type("Structure") Then
		For Each InputField In InputFieldsForLoadData Do
			If InputField.Key = "Item" 
					Or InputField.Key = "ItemKey" 
					Or InputField.Key = "Quantity" Then
				Continue;
			EndIf;
			
			InputFieldDescription = InputField.Value; // Structure
			FieldType = InputFieldDescription["Type"]; // TypeDescription
			FieldTypes = FieldType.Types();
			
			If FieldTypes.Count() = 1 And (FieldTypes[0] = Type("String") 
					Or FieldTypes[0] = Type("Number")
					Or FieldTypes[0] = Type("Boolean")
					Or FieldTypes[0] = Type("Date")) Then
				FieldDescription = GetAddFieldDescription();
				FillPropertyValues(FieldDescription, InputFieldDescription);
				FieldsForLoadData.Insert("Field_" + FieldDescription.Name, FieldDescription);
			EndIf;
		EndDo;
	EndIf;
	ThisObject["AdditionalFields"] = FieldsForLoadData;
	
	CreateAdditionalFields();
	
	FillColumns();
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	OwnerUUID = FormOwner.UUID;
EndProcedure

#EndRegion

#Region ItemsHandler

&AtClient
Procedure TemplateOnChange(Item)
	isTemplateChanged = True;
EndProcedure

&AtClient
Procedure TemplateSelection(Item, Area, StandardProcessing)
	If Area.Top <= HeadersRows Then
		StandardProcessing = False;
	EndIf;
EndProcedure

&AtClient
Procedure ResultSelection(Item, Area, StandardProcessing)
	StandardProcessing = False;
	Area.Protection = True;
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure Next(Command)
	
	If Items.PagesMain.CurrentPage = Items.PageTemplate Then
		
		FillResult();
		
	Else
		
		LoadDataDescription = LoadDataFromTableClient.GetLoadDataDescription();
		LoadDataDescription.Address = ResultStore;
		
		AdditionalFieldsArray = New Array; // Array of String
		FieldsForLoadData = ThisObject["AdditionalFields"]; // Structure
		For Each FieldForLoad In FieldsForLoadData Do
			FieldDescription = FieldForLoad.Value; // See GetAddFieldDescription
			If FieldDescription.toShow Then
				AdditionalFieldsArray.Add(FieldDescription.Name);
			EndIf;
		EndDo;
		If AdditionalFieldsArray.Count() > 0 Then
			LoadDataDescription.GroupColumns =
				LoadDataDescription.GroupColumns + ", " +
				StrConcat(AdditionalFieldsArray, ", "); 
		EndIf;
		
		Close(LoadDataDescription);
		
	EndIf;
	
EndProcedure

&AtClient
Procedure Back(Command)
	ChangePage(Items);
EndProcedure

&AtClientAtServerNoContext
Procedure ChangePage(Items)
	If Items.PagesMain.CurrentPage = Items.PageTemplate Then
		Items.FormBack.Enabled = True;
		Items.ClearTemplate.Enabled = False;
		Items.PagesMain.CurrentPage = Items.PageResult;
	Else
		Items.FormBack.Enabled = False;
		Items.ClearTemplate.Enabled = True;
		Items.PagesMain.CurrentPage = Items.PageTemplate;
	EndIf;
EndProcedure

&AtClient
Procedure ClearTemplate(Command)
	FillColumns();
EndProcedure

#EndRegion

#Region SetType

&AtClient
Procedure LoadTypeOnChange(Item)
	FillColumns();
EndProcedure

#EndRegion

#Region Service

#Region AdditionalFields

&AtServer
Procedure CreateAdditionalFields()
	
	FieldsForLoadData = ThisObject["AdditionalFields"]; // Structure
	BooleanType = New TypeDescription("Boolean");
	
	NewAttributes = New Array; // Array of FormAttribute
	For Each ColumnItem In FieldsForLoadData Do
		ColumnDescription = ColumnItem.Value; // See GetAddFieldDescription
		FormAttribute = New FormAttribute(
			ColumnItem.Key, 
			BooleanType,	, 
			ColumnDescription.Synonym);
		NewAttributes.Add(FormAttribute);
	EndDo;
	
	ThisObject.ChangeAttributes(NewAttributes);
	
	For Each ColumnItem In FieldsForLoadData Do
		ColumnDescription = ColumnItem.Value; // See GetAddFieldDescription
		ThisObject[ColumnItem.Key] = ColumnDescription.toShow;
	EndDo;
	
	For Each ColumnItem In FieldsForLoadData Do
		ColumnKey = ColumnItem.Key; // String
		ColumnDescription = ColumnItem.Value; // See GetAddFieldDescription
		
		NewFormItem = Items.Add(ColumnKey, Type("FormField"), Items.GroupAdditionalFields);
		NewFormItem.Type = FormFieldType.CheckBoxField;
		NewFormItem.TitleLocation = FormItemTitleLocation.Right;
		NewFormItem.DataPath = ColumnKey;
		NewFormItem.SetAction("OnChange", "AdditionalFieldOnChange");
	EndDo;
	
EndProcedure

// Additional field on change.
// 
// Parameters:
//  Item - FormField - Item
&AtClient
Procedure AdditionalFieldOnChange(Item)
	
	FieldsForLoadData = ThisObject["AdditionalFields"]; // Structure
	ColumnDescription = FieldsForLoadData[Item.Name]; // See GetAddFieldDescription
	
	CurrentData = ThisObject[Item.Name]; // Boolean
	ColumnDescription.toShow = CurrentData; 
	
	FillColumns();
	
EndProcedure

#EndRegion

#Region FillTemplate

&AtServer
Procedure FillColumns()
	
	TemplateSpreadsheet = New SpreadsheetDocument();		
	
	Index = 0;
	Columns = GetColumnList();
	For Each Column In Columns Do
		Index = Index + 1;
		ColumnInfo = Column.Value; // See GetColumnInfo

		Area = TemplateSpreadsheet.Area(1, Index);
		Area.ContainsValue = True;
		Area.ValueType = New TypeDescription("String");
		Area.Value = String(Column.Key);
		
		Area = TemplateSpreadsheet.Area(2, Index);
		Area.Text = ColumnInfo.Name; 
		Area.ColumnWidth = ColumnInfo.Size;
		Area.BackColor = WebColors.Beige;
		Area.Font = StyleFonts.LargeTextFont;
		Area.HorizontalAlign = HorizontalAlign.Center;
		Area.Protection = True;
	EndDo;
	
	TemplateSpreadsheet.Area("R1").Visible = False;
	TemplateSpreadsheet.FixedTop = HeadersRows;
	
EndProcedure

// Get column list.
// 
// Returns:
//  KeyAndValue:
// * Key - String
// * Value - see GetColumnInfo
&AtServer
Function GetColumnList()
	
	Columns = New Structure;
	
	If "Barcode" = LoadType Then
		Barcode = GetColumnInfo();
		Barcode.Type = New TypeDescription(Metadata.DefinedTypes.typeBarcode.Type);
		Barcode.Name = Metadata.InformationRegisters.Barcodes.Dimensions.Barcode.Synonym;
		Barcode.Size = 20;
		Columns.Insert("Barcode", Barcode);
		
	ElsIf "SerialLotNumber" = LoadType Then
		Item = GetColumnInfo();
		Item.Type = New TypeDescription("String");
		Item.Name = Metadata.Catalogs.SerialLotNumbers.Synonym;
		Item.Size = 30;
		Columns.Insert("SerialLotNumber", Item);
		
	ElsIf "ItemKey" = LoadType Then
		Item = GetColumnInfo();
		Item.Type = New TypeDescription("String");
		Item.Name = Metadata.Catalogs.Items.Synonym;
		Item.Size = 20;
		Columns.Insert("Item", Item);
		
		ItemKey = GetColumnInfo();
		ItemKey.Type = New TypeDescription("String");
		ItemKey.Name = Metadata.Catalogs.ItemKeys.Synonym;
		ItemKey.Size = 20;
		Columns.Insert("ItemKey", ItemKey);
	EndIf;
	
	Quantity = GetColumnInfo();
	Quantity.Type = New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type);
	Quantity.Name = Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym;
	Quantity.Size = 20;
	Columns.Insert("Quantity", Quantity);
	
	FieldsForLoadData = ThisObject["AdditionalFields"]; // Structure
	For Each FieldForLoad In FieldsForLoadData Do
		FieldDescription = FieldForLoad.Value; // See GetAddFieldDescription
		If FieldDescription.toShow Then
			NewField = GetColumnInfo();
			NewField.Type = FieldDescription.Type;
			NewField.Name = FieldDescription.Synonym;
			NewField.Size = 20;
			Columns.Insert(FieldDescription.Name, NewField);
		EndIf;
	EndDo;
		
	Return Columns;
	
EndFunction

// Get column info.
// 
// Returns:
//  Structure - Get column info:
// * Type - TypeDescription -
// * Name - String -
// * Size - Number -
&AtServer
Function GetColumnInfo()
	Info = New Structure();
	Info.Insert("Type", New TypeDescription());
	Info.Insert("Name", "");
	Info.Insert("Size", 15);
	Return Info;
EndFunction

// Get add field description.
// 
// Returns:
//  Structure - Get additional field description:
//	* Name - String -
//	* Synonym - String -
//	* Type - TypeDescription, Undefined -
//	* toShow - Boolean -
&AtClientAtServerNoContext
Function GetAddFieldDescription()
	
	Result = New Structure;
	
	Result.Insert("Name", "");
	Result.Insert("Synonym", "");
	Result.Insert("Type", Undefined);
	Result.Insert("toShow", False);
	
	Return Result; 
	
EndFunction

&AtServer
Function GetTemplateData() 
	
	Result = New Array(); // Array of Structure
	Columns = GetColumnList();
	
	MainColumn = ?(LoadType = "ItemKey", 2, 1);
	
	For RowIndex = 3 To ThisObject.TemplateSpreadsheet.TableHeight Do
		If IsBlankString(GetAreaText(ThisObject.TemplateSpreadsheet, RowIndex, MainColumn)) Then
			ErrorTemplate = "";
			R().Property("Error_010", ErrorTemplate);
			ErrorText = StrTemplate(ErrorTemplate, GetAreaText(ThisObject.TemplateSpreadsheet, 2, MainColumn));
			FillError(RowIndex, MainColumn, ErrorText);
			Continue;
		EndIf;
		NewRecord = New Structure;
		NewRecord.Insert("Index", RowIndex - 2);
		For ColumnIndex = 1 To ThisObject.TemplateSpreadsheet.TableWidth Do
			ColumnKey = GetAreaText(ThisObject.TemplateSpreadsheet, 1, ColumnIndex); // String
			ColumnInfo = Columns[ColumnKey]; // See GetColumnInfo
			CellValue = GetCellValue(ColumnInfo.Type, ThisObject.TemplateSpreadsheet, RowIndex, ColumnIndex);
			NewRecord.Insert(ColumnKey, CellValue); 
		EndDo;
		Result.Add(NewRecord);
	EndDo;
	
	Return Result;
	
EndFunction

#EndRegion

#Region FillResult

&AtClient
Procedure FillResult()
	If Not isTemplateChanged Then
		Return;
	EndIf;
	FillResultTable();
	isTemplateChanged = False;
EndProcedure

&AtServer
Procedure FillResultTable()
	
	ClearAllErrors();
	
	ItemTable = GetItemTable();
	If ErrorList.Count() > 0 Then
		Return;
	EndIf;
	ResultStore = PutToTempStorage(ItemTable, OwnerUUID);
	
	ChangePage(Items);
	ResultSpreadsheet = New SpreadsheetDocument();
	
	Index = 0;
	For Each Column In ItemTable.Columns Do
		Index = Index + 1;
		
		Area = ResultSpreadsheet.Area(1, Index);
		Area.ContainsValue = True;
		Area.ValueType = New TypeDescription("String");
		Area.Value = Column.Name;
		
		Area = ResultSpreadsheet.Area(2, Index);
		Area.Text = Column.Title;
		Area.ColumnWidth = Column.Width;
		Area.BackColor = WebColors.Beige;
		Area.Font = StyleFonts.LargeTextFont;
		Area.HorizontalAlign = HorizontalAlign.Center;
		Area.Protection = True;
	EndDo;
	
	ResultSpreadsheet.Area("R1").Visible = False;
	ResultSpreadsheet.FixedTop = HeadersRows;

	ImageNumber = GetColumnNumber("Image", ResultSpreadsheet);

	AreaToFill = GetResultRow(ItemTable);
	PictureMap = New Map;
	FillColor = False;
	For Each Row In ItemTable Do
		AreaToFill.Parameters.Fill(Row);
		
		AreaToFill.Area("R1").BackColor = ?(FillColor, WebColors.Azure, WebColors.White);
		FillColor = Not FillColor;
		
		If Not Row.Image.IsEmpty() AND ShowOrHideImage Then
			PictureData = PictureMap.Get(Row.Image);
			If PictureData = Undefined Then
				PictureFromRef = Row.Image.Preview.Get(); // BinaryData
				PictureData = New Picture(PictureFromRef);
				PictureMap.Insert(Row.Image, PictureData);
			EndIf;
			
			AreaToFill.Area(1, ImageNumber).Picture = PictureData;
			AreaToFill.Area(1, ImageNumber).PictureSize = PictureSize.Proportionally;
		EndIf;
		
		ResultSpreadsheet.Put(AreaToFill);
	EndDo;
	
	HideResultColumn(ItemTable);
	
	CheckResultTable();
	
EndProcedure

&AtServer
Function GetItemTable()
	
	ItemTable = New ValueTable();
	
	TemplateData = GetTemplateData();
	If ErrorList.Count() > 0 Then
		Return ItemTable;
	EndIf;
	
	ErrorValueNotFound = "";
	R().Property("LDT_ValueNotFound", ErrorValueNotFound);
	
	ErrorTooMuchFound = "";
	R().Property("LDT_TooMuchFound", ErrorTooMuchFound);
	
	If LoadType = "Barcode" Then
		BarcodeTable = BarcodeServer.GetBarcodeTable();
		For Each TableRow In TemplateData Do
			NewRow = BarcodeTable.Add();
			TableRow = TableRow; // Structure
			NewRow.Key = String(TableRow["Index"]);
			FillPropertyValues(NewRow, TableRow);
			NewRow.Quantity = ?(NewRow.Quantity = 0, 1, NewRow.Quantity);
		EndDo;
		ItemTable = GetItemInfo.ByBarcodeTable(BarcodeTable);
	
	ElsIf LoadType = "SerialLotNumber" Then
		SerialLotNumberTable = SerialLotNumbersServer.GetSerialLotNumberTable();
		For Each TableRow In TemplateData Do
			NewRow = SerialLotNumberTable.Add();
			TableRow = TableRow; // Structure
			NewRow.Key = String(TableRow["Index"]);
			FillPropertyValues(NewRow, TableRow);
			NewRow.Quantity = ?(NewRow.Quantity = 0, 1, NewRow.Quantity);
		EndDo;
		ItemTable = GetItemInfo.BySerialLotNumberStringTable(SerialLotNumberTable);
		
	ElsIf LoadType = "ItemKey" Then
		ItemKeyTable = GetItemInfo.GetItemAndItemKeysInputTable();
		RowIndex = 2;
		For Each TableRow In TemplateData Do
			TableRow = TableRow; // Structure
			RowIndex = RowIndex + 1;
			
			NewRow = ItemKeyTable.Add();
			NewRow.Key = String(TableRow["Index"]);
			
			RowQuantity = TableRow["Quantity"]; // DefinedType.typeQuantity
			NewRow.Quantity = ?(RowQuantity = 0, 1, RowQuantity);
			
			ItemString = TableRow["Item"]; // String
			If not IsBlankString(ItemString) Then
				ItemArray = GetItemInfo.SearchItemByString(ItemString); // Array of CatalogRef.Items
				If ItemArray.Count() = 0 Then
					FillError(RowIndex, 1, StrTemplate(ErrorValueNotFound, ItemString));
				ElsIf ItemArray.Count() > 1 Then
					FillError(RowIndex, 1, StrTemplate(ErrorTooMuchFound, ItemString));
				Else
					NewRow.Item = ItemArray[0];
				EndIf;
			EndIf;
			
			ItemKeyString = TableRow["ItemKey"]; // String
			ItemKeyArray = GetItemInfo.SearchItemKeyByString(ItemKeyString, NewRow.Item); // Array of CatalogRef.ItemKeys
			If ItemKeyArray.Count() = 0 Then
				FillError(RowIndex, 2, StrTemplate(ErrorValueNotFound, ItemKeyString));
			ElsIf ItemKeyArray.Count() > 1 Then
				FillError(RowIndex, 2, StrTemplate(ErrorTooMuchFound, ItemKeyString));
			Else
				NewRow.ItemKey = ItemKeyArray[0];
			EndIf;
		EndDo;
		ItemTable = GetItemInfo.ByItemAndItemKeysDescriptionsTable(ItemKeyTable);
		
	EndIf;
	
	NewFields = New Array; // Array of String
	ThereAreAdditionalFields = False;
	FieldsForLoadData = ThisObject["AdditionalFields"]; // Structure
	For Each FieldForLoad In FieldsForLoadData Do
		FieldDescription = FieldForLoad.Value; // See GetAddFieldDescription
		If FieldDescription.toShow Then
			ItemTable.Columns.Add(FieldDescription.Name, FieldDescription.Type, FieldDescription.Synonym, 20);
			ThereAreAdditionalFields = True;
			NewFields.Add(FieldDescription.Name);
		EndIf;
	EndDo;
	
	If ThereAreAdditionalFields Then
		NewFieldsString = StrConcat(NewFields, ",");
		For Each TableRow In TemplateData Do
			RowKey = String(TableRow["Index"]);
			ItemTableRows = ItemTable.FindRows(New Structure("Key", RowKey));
			For Each ItemTableRow In ItemTableRows Do
				FillPropertyValues(ItemTableRow, TableRow, NewFieldsString);
			EndDo;
		EndDo;
	EndIf;
	
	Return ItemTable;
	
EndFunction

&AtServer
Procedure HideResultColumn(ItemTable)
	
	Index = 0;
	For Each Column In ItemTable.Columns Do
		Index = Index + 1;
		If Column.Name = "Key" Then
			ResultSpreadsheet.Area("C" + Index).Visible = False;
		ElsIf Column.Name = "hasSpecification" Then
			ResultSpreadsheet.Area("C" + Index).Visible = False;
		ElsIf Column.Name = "UseSerialLotNumber" Then
			ResultSpreadsheet.Area("C" + Index).Visible = False;
		ElsIf Column.Name = "SerialLotNumber" Then
			Table = ItemTable.Copy(, "UseSerialLotNumber");
			Table.GroupBy("UseSerialLotNumber");
			If Table.Count() = 1 And Not Table[0].UseSerialLotNumber Then
				ResultSpreadsheet.Area("C" + Index).Visible = False;
			Else	
				ResultSpreadsheet.Area("C" + Index).Visible = True;
			EndIf;
		ElsIf Column.Name = "Barcode" Then
			ResultSpreadsheet.Area("C" + Index).HorizontalAlign = HorizontalAlign.Center;
		EndIf;
	EndDo;
	
EndProcedure

&AtServer
Procedure CheckResultTable(Row = 0)
	
	ItemNumber = GetColumnNumber("Item", ResultSpreadsheet);
	ItemKeyNumber = GetColumnNumber("ItemKey", ResultSpreadsheet);
	
	UseSerialLotNumber = GetColumnNumber("UseSerialLotNumber", ResultSpreadsheet);
	SerialLotNumber = GetColumnNumber("SerialLotNumber", ResultSpreadsheet);
	
	ErrorNotFilled = "";
	R().Property("S_027", ErrorNotFilled);
	
	ErrorWrongFilled = "";
	R().Property("Error_108", ErrorWrongFilled);
	
	For Index = HeadersRows + 1 To ResultSpreadsheet.TableHeight Do
		If Row Then
			Index = Row;
			ClearRowError(Row);
		EndIf;
		
		Item = GetArea(ResultSpreadsheet, Index, ItemNumber).Value; // CatalogRef.Items
		If Item.IsEmpty() Then
			FillError(Index, ItemNumber, ErrorNotFilled);
		EndIf;
		
		ItemKey = GetArea(ResultSpreadsheet, Index, ItemKeyNumber).Value; // CatalogRef.ItemKeys
		If ItemKey.IsEmpty() Then
			FillError(Index, ItemKeyNumber, ErrorNotFilled);
		EndIf;
		
		UseSerialLot = GetArea(ResultSpreadsheet, Index, UseSerialLotNumber).Value; // Boolean
		SerialLot = GetArea(ResultSpreadsheet, Index, SerialLotNumber).Value; // CatalogRef.SerialLotNumbers
		If UseSerialLot And SerialLot.IsEmpty() Then
			FillError(Index, SerialLotNumber, ErrorNotFilled);
		ElsIf Not UseSerialLot And Not SerialLot.IsEmpty() Then
			FillError(Index, SerialLotNumber, ErrorWrongFilled);
		EndIf;
		
		If Row Then
			Break;
		EndIf;
	EndDo;
	
EndProcedure

&AtClient
Procedure ErrorListOnActivateRow(Item)
	
	If Items.ErrorList.CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Items.PagesMain.CurrentPage = Items.PageTemplate Then
		CurrentSpreadsheet = ThisObject.TemplateSpreadsheet;
		CurrentSpreadsheetItem = Items.Template;
	Else
		CurrentSpreadsheet = ThisObject.ResultSpreadsheet;
		CurrentSpreadsheetItem = Items.Result;
	EndIf;
	
	Array = New Array; // Array of SpreadsheetDocumentRange
	ResultArea = CurrentSpreadsheet.Area(Items.ErrorList.CurrentData.Row, Items.ErrorList.CurrentData.Column);
	Array.Add(ResultArea);
	
	CurrentSpreadsheetItem.SetSelectedAreas(Array);
	CurrentItem = CurrentSpreadsheetItem;
	
EndProcedure

// Fill error.
// 
// Parameters:
//  Row - Number - Row
//  Column - Number - Column
//  ErrorText - String - Text
&AtServer
Procedure FillError(Row, Column, ErrorText)
	
	CurrentSpreadsheet = ?(Items.PagesMain.CurrentPage = Items.PageTemplate, TemplateSpreadsheet, ResultSpreadsheet);
	GetArea(CurrentSpreadsheet, Row, Column).Comment.Text = ErrorText;	
	
	NewRow = ErrorList.Add();
	NewRow.Row = Row;
	NewRow.Column = Column;
	NewRow.ErrorText = ErrorText;
	ErrorList.Sort("Row, Column");
	
EndProcedure

&AtServer
Procedure ClearRowError(Row)
	
	RowList = ErrorList.FindRows(New Structure("Row", Row));
	For Each RowInList In RowList Do
		ErrorList.Delete(RowInList);
	EndDo;
	
	For Index = 1 To ResultSpreadsheet.TableWidth Do
		GetArea(ResultSpreadsheet, Row, Index).Comment.Text = "";
	EndDo;
	
EndProcedure

&AtServer
Procedure ClearAllErrors()
	
	ErrorList.Clear();
	
	For IndexRow = 1 To TemplateSpreadsheet.TableHeight Do
		For IndexColumn = 1 To TemplateSpreadsheet.TableWidth Do
			GetArea(TemplateSpreadsheet, IndexRow, IndexColumn).Comment.Text = "";
		EndDo;
	EndDo;
	
	For IndexRow = 1 To ResultSpreadsheet.TableHeight Do
		For IndexColumn = 1 To ResultSpreadsheet.TableWidth Do
			GetArea(ResultSpreadsheet, IndexRow, IndexColumn).Comment.Text = "";
		EndDo;
	EndDo;
	
EndProcedure

&AtClient
Procedure ResultOnChangeAreaContent(Item, Area, AdditionalParameters)
	CheckResultTable(Area.Top);
EndProcedure

// Get area.
// 
// Parameters:
//  SprSheet - SpreadsheetDocument - Spr sheet
//  Row - Number - Row
//  Column - Number - Column
// 
// Returns:
//  SpreadsheetDocumentRange - Get area
&AtClientAtServerNoContext
Function GetArea(SprSheet, Row, Column)
	Return SprSheet.Area(Row, Column);
EndFunction

// Get area text.
// 
// Parameters:
//  SprSheet - SpreadsheetDocument - Spr sheet
//  Row - Number - Row
//  Column - Number - Column
//  FullText - Boolean - Full text
// 
// Returns:
//  String - Get area text
&AtClientAtServerNoContext
Function GetAreaText(SprSheet, Row, Column, FullText = False)
	SheetArea = GetArea(SprSheet, Row, Column);
	If FullText Then
		Return SheetArea.Text;
	EndIf;
	Return TrimAll(SheetArea.Text);
EndFunction

// Get cell value.
// 
// Parameters:
//  TypeValue - TypeDescription - Type value
//  SprSheet - SpreadsheetDocument - Spreadsheet
//  RowIndex - Number - Row index
//  ColumnIndex - Number - Column index
// 
// Returns:
//  Arbitrary - Get cell value
&AtServer
Function GetCellValue(TypeValue, SprSheet, RowIndex, ColumnIndex)
	CellText = GetAreaText(SprSheet, RowIndex, ColumnIndex); // String
	Try
		Return TypeValue.AdjustValue(CellText);
	Except
		ErrorTemplate = "";
		R().Property("LDT_FailReading", ErrorTemplate);
		ErrorText = StrTemplate(ErrorTemplate, CellText);
		FillError(RowIndex, ColumnIndex, ErrorText);
		Return TypeValue.AdjustValue();
	EndTry;
EndFunction

&AtServer
Function GetResultRow(ItemTable)

	TmpSP = New SpreadsheetDocument();
	Index = 0;
	For Each Column In ItemTable.Columns Do
		Index = Index + 1;
		Area = TmpSP.Area(1, Index);
		Area.ContainsValue = True;
		Area.ValueType = Column.ValueType;
		Area.Parameter = Column.Name;
		Area.FillType = SpreadsheetDocumentAreaFillType.Parameter;
		Area.Indent = 1;
	EndDo;
	
	Area = TmpSP.Area(1, 1, 1, ItemTable.Columns.Count());
	Area.Name = "Row";
	Return TmpSP.GetArea("Row");
	
EndFunction

#EndRegion

#Region SpreadSheet

// Get column number.
// 
// Parameters:
//  Name - String - Name
//  SprSheet - SpreadsheetDocument - Spr sheet
// 
// Returns:
//  Number - Get column number
&AtServer
Function GetColumnNumber(Name, SprSheet)
	For Index = 1 To SprSheet.TableWidth Do
		Area = SprSheet.Area(1, Index);
		If Area.Text = Name Then
			Return Index;
		EndIf;
	EndDo;
	Return 0;
EndFunction

#EndRegion

#EndRegion

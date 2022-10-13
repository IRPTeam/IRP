// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	LoadType = "Barcode";
	
	HeadersRows = 2;
	FillColumns();
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetSettings();
	OwnerUUID = FormOwner.UUID;
EndProcedure

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

&AtClient
Procedure ShowImages(Command)
	ShowOrHideImage = Not ShowOrHideImage;
	If ShowOrHideImage Then
		//@skip-warning
		Items.FormShowImages.BackColor = CommonFunctionsServer.GetStyleByName("ActivityColor");
	Else
		//@skip-warning
		Items.FormShowImages.BackColor = CommonFunctionsServer.GetStyleByName("ButtonBackColor");
	EndIf;
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure Next(Command)
	SetPage(1);
EndProcedure

&AtClient
Procedure Back(Command)
	SetPage(-1);
EndProcedure

&AtClient
Procedure ClearTemplate(Command)
	FillColumns();
EndProcedure

#EndRegion

#Region SetType

&AtClient
Procedure LoadTypeOnChange(Item)
	SetSettings();
	FillColumns();
EndProcedure

&AtClient
Procedure SetSettings()
	If Not StrCompare("Barcode", LoadType) Then
		SearchType = "";
		Items.SearchType.Visible = False;
	Else
		If IsBlankString(SearchType) Then
			SearchType = "Code";
		EndIf;
	EndIf; 
EndProcedure

#EndRegion

#Region Service

#Region FillTemplate
&AtServer
Procedure FillColumns()
	
	Columns = GetColumnList();
	Template = New SpreadsheetDocument();		
	Index = 0;
	For Each Column In Columns Do
		Index = Index + 1;

		ColumnInfo = Column.Value; // See GetColumnInfo

		//@skip-check invocation-parameter-type-intersect
		Area = Template.Area(1, Index);
		Area.ContainsValue = True;
		Area.ValueType = New TypeDescription("String");
		Area.Value = String(Column.Key);
		
		//@skip-check invocation-parameter-type-intersect
		Area = Template.Area(2, Index);
		Area.Text = ColumnInfo.Name; 
		Area.ColumnWidth = ColumnInfo.Size;
		Area.BackColor = WebColors.Beige;
		Area.Font = StyleFonts.LargeTextFont;
		Area.HorizontalAlign = HorizontalAlign.Center;
		Area.Protection = True;

	EndDo;
	Template.Area("R1").Visible = False;
	Template.FixedTop = HeadersRows;
	
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
	If Not StrCompare("Item", LoadType) Then
		Item = GetColumnInfo();
		Item.Type = New TypeDescription("String");
		Item.Name = Metadata.Catalogs.Items.Synonym;
		Item.Size = 20;
		Columns.Insert("Item", Item);
	ElsIf Not StrCompare("ItemKey", LoadType) Then
		ItemKey = GetColumnInfo();
		ItemKey.Type = New TypeDescription("String");
		ItemKey.Name = Metadata.Catalogs.ItemKeys.Synonym;
		ItemKey.Size = 20;
		Columns.Insert("ItemKey", ItemKey);
	ElsIf Not StrCompare("Barcode", LoadType) Then
		Barcode = GetColumnInfo();
		Barcode.Type = New TypeDescription(Metadata.DefinedTypes.typeBarcode.Type);
		Barcode.Name = Metadata.InformationRegisters.Barcodes.Dimensions.Barcode.Synonym;
		Barcode.Size = 20;
		Columns.Insert("Barcode", Barcode);
	EndIf;
	
	Quantity = GetColumnInfo();
	Quantity.Type = New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type);
	Quantity.Name = Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym;
	Quantity.Size = 20;
	Columns.Insert("Quantity", Quantity);
		
	Return Columns
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

#EndRegion

#Region FillResult

&AtClient
Procedure FillResult()
	If Not isTemplateChanged Then
		Return;
	EndIf;
	ErrorList.Clear();
	FillResultTable();
	
EndProcedure

&AtServer
Procedure FillResultTable()
	
	ItemTable = GetItemTable();
	ResultStore = PutToTempStorage(ItemTable, OwnerUUID);	
	Index = 0;
	
	Result = New SpreadsheetDocument();
	
	For Each Column In ItemTable.Columns Do
		Index = Index + 1;
		//@skip-check invocation-parameter-type-intersect
		Area = Result.Area(1, Index);
		Area.ContainsValue = True;
		Area.ValueType = New TypeDescription("String");
		Area.Value = Column.Name;
		
		//@skip-check invocation-parameter-type-intersect
		Area = Result.Area(2, Index);
		Area.Text = Column.Title;
		Area.ColumnWidth = Column.Width;
		Area.BackColor = WebColors.Beige;
		Area.Font = StyleFonts.LargeTextFont;
		Area.HorizontalAlign = HorizontalAlign.Center;
		Area.Protection = True;
		
	EndDo;
	Result.Area("R1").Visible = False;
	Result.FixedTop = HeadersRows;

	ImageNumber = GetColumnNumber("Image", Result);

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
			
			//@skip-check invocation-parameter-type-intersect
			AreaToFill.Area(1, ImageNumber).Picture = PictureData;
			//@skip-check invocation-parameter-type-intersect
			AreaToFill.Area(1, ImageNumber).PictureSize = PictureSize.Proportionally;
		EndIf;
		
		Result.Put(AreaToFill);
	EndDo;
	
	HideResultColumn(ItemTable);
	
	CheckResultTable();
	
EndProcedure

&AtServer
Function GetItemTable()
	If Not StrCompare("Barcode", LoadType) Then
		BarcodeNumber = GetColumnNumber("Barcode", Template);
		BarcodeArray = GetColumnArray(BarcodeNumber, Template); // Array of String
		
		QuantityNumber = GetColumnNumber("Quantity", Template);
		QuantityArray = GetColumnArray(QuantityNumber, Template); // Array of String
		
		BarcodeTable = BarcodeServer.GetBarcodeTable();
		For Index = 0 To BarcodeArray.UBound() Do
			NewRow = BarcodeTable.Add();
			NewRow.Key = String(Index);
			NewRow.Barcode = BarcodeArray[Index];
			Quantity = QuantityArray[Index];
			NewRow.Quantity = ?(IsBlankString(Quantity), 1, Number(Quantity));
		EndDo;
		ItemTable = GetItemInfo.ByBarcodeTable(BarcodeTable);
	EndIf;
	
	Return ItemTable;
EndFunction

&AtServer
Procedure HideResultColumn(ItemTable)
	
	Index = 0;
	For Each Column In ItemTable.Columns Do
		Index = Index + 1;
		//@skip-check invocation-parameter-type-intersect
		If Column.Name = "Key" Then
			Result.Area("C" + Index).Visible = False;
		ElsIf Column.Name = "hasSpecification" Then
			Result.Area("C" + Index).Visible = False;
		ElsIf Column.Name = "UseSerialLotNumber" Then
			Result.Area("C" + Index).Visible = False;
		ElsIf Column.Name = "SerialLotNumber" Then
			Table = ItemTable.Copy(, "UseSerialLotNumber");
			Table.GroupBy("UseSerialLotNumber");
			If Table.Count() = 1 And Not Table[0].UseSerialLotNumber Then
				Result.Area("C" + Index).Visible = False;
			Else	
				Result.Area("C" + Index).Visible = True;
			EndIf;
		ElsIf Column.Name = "Barcode" Then
			Result.Area("C" + Index).HorizontalAlign = HorizontalAlign.Center;
		EndIf;
	EndDo;
	
	
EndProcedure

&AtServer
Procedure CheckResultTable(Row = 0)
	
	BarcodeNumber = GetColumnNumber("Barcode", Result);
	ItemNumber = GetColumnNumber("Item", Result);
	ItemKeyNumber = GetColumnNumber("ItemKey", Result);
	
	UseSerialLotNumber = GetColumnNumber("UseSerialLotNumber", Result);
	SerialLotNumber = GetColumnNumber("SerialLotNumber", Result);
	
	For Index = HeadersRows + 1 To Result.TableHeight Do
		If Row Then
			Index = Row;
			ClearRowError(Row);
		EndIf;
		
		Barcode = GetArea(Result, Index, BarcodeNumber).Value; // String
		If Not IsBlankString(Barcode) Then
			Item = GetArea(Result, Index, ItemNumber).Value; // CatalogRef.Items
			If Item.IsEmpty() Then
				//@skip-check statement-type-change
				GetArea(Result, Index, ItemNumber).Comment.Text = R().S_027;
				FillError(Index, ItemNumber, R().S_027);
			EndIf;
			
			ItemKey = GetArea(Result, Index, ItemKeyNumber).Value; // CatalogRef.ItemKeys
			If ItemKey.IsEmpty() Then
				//@skip-check statement-type-change
				GetArea(Result, Index, ItemKeyNumber).Comment.Text = R().S_027;
				FillError(Index, ItemKeyNumber, R().S_027);
			EndIf;
		EndIf;
		
		UseSerialLot = GetArea(Result, Index, UseSerialLotNumber).Value; // Boolean
		SerialLot = GetArea(Result, Index, SerialLotNumber).Value; // CatalogRef.SerialLotNumbers
		If UseSerialLot And SerialLot.IsEmpty() Then
			//@skip-check statement-type-change
			GetArea(Result, Index, SerialLotNumber).Comment.Text = R().S_027;
			FillError(Index, SerialLotNumber, R().S_027);
		ElsIf Not UseSerialLot And Not SerialLot.IsEmpty() Then
			//@skip-check statement-type-change
			GetArea(Result, Index, SerialLotNumber).Comment.Text = R().Error_108;
			FillError(Index, SerialLotNumber, R().Error_108);
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
	
	Array = New Array;
	//@skip-check invocation-parameter-type-intersect
	Array.Add(Result.Area(Items.ErrorList.CurrentData.Row, Items.ErrorList.CurrentData.Column));
	Items.Result.SetSelectedAreas(Array);
	CurrentItem = Items.Result;
EndProcedure

// Fill error.
// 
// Parameters:
//  Row - Number - Row
//  Column - Number - Column
//  Text - String - Text
&AtServer
Procedure FillError(Row, Column, Text)
	
	NewRow = ErrorList.Add();
	NewRow.Row = Row;
	NewRow.Column = Column;
	NewRow.ErrorText = Text;
	
	ErrorList.Sort("Row, Column");
EndProcedure

&AtServer
Procedure ClearRowError(Row)
	
	RowList = ErrorList.FindRows(New Structure("Row", Row));
	For Each RowInList In RowList Do
		ErrorList.Delete(RowInList);
	EndDo;
	
	For Index = 1 To Result.TableWidth Do
		GetArea(Result, Row, Index).Comment.Text = "";
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
&AtServer
Function GetArea(SprSheet, Row, Column)
	//@skip-check invocation-parameter-type-intersect		
	Return SprSheet.Area(Row, Column);
EndFunction

&AtServer
Function GetResultRow(ItemTable)

	TmpSP = New SpreadsheetDocument();
	Index = 0;
	For Each Column In ItemTable.Columns Do
		Index = Index + 1;
		//@skip-check invocation-parameter-type-intersect
		Area = TmpSP.Area(1, Index);
		Area.ContainsValue = True;
		Area.ValueType = Column.ValueType;
		Area.Parameter = Column.Name;
		Area.FillType = SpreadsheetDocumentAreaFillType.Parameter;
		Area.Indent = 1;
	EndDo;
	
	//@skip-check invocation-parameter-type-intersect
	Area = TmpSP.Area(1, 1, 1, ItemTable.Columns.Count());
	Area.Name = "Row";
	Return TmpSP.GetArea("Row");
	
EndFunction

#EndRegion

#Region ChangePages

&AtClient
Procedure SetPage(Index)
	
	StepNumber = StepNumber + Index;
	
	Items.FormBack.Visible = StepNumber > 0;
	Items.ClearTemplate.Visible = StepNumber = 0;
	
	PageLimit = 2;
	If StepNumber > PageLimit Then
		StepNumber = PageLimit;
	EndIf;
	
	If StepNumber = 0 Then
		Items.PagesMain.CurrentPage = Items.PageTemplate;
	ElsIf StepNumber = 1 Then
		Items.PagesMain.CurrentPage = Items.PageResult;
		
		FillResult();
		isTemplateChanged = False;		
	ElsIf StepNumber = 2 Then
		Close(ResultStore);
	EndIf;
	
EndProcedure

#EndRegion

#Region SpreadSheet

&AtServer
Function GetColumnNumber(Name, SprSheet)
	For Index = 1 To SprSheet.TableWidth Do
		//@skip-check invocation-parameter-type-intersect
		Area = SprSheet.Area(1, Index);
		If Area.Text = Name Then
			Return Index;
		EndIf;
	EndDo;
	Return 0;
EndFunction

&AtServer
Function GetColumnArray(ColumnNumber, SprSheet)
	Array = New Array;
	For Index = HeadersRows + 1 To SprSheet.TableHeight Do
		//@skip-check invocation-parameter-type-intersect
		Area = SprSheet.Area(Index, ColumnNumber);
		Text = Area.Text;
		Array.Add(TrimAll(Text));
	EndDo;
	Return Array;
EndFunction
#EndRegion

#EndRegion

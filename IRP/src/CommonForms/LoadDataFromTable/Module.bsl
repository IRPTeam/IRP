// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	FillColumns();
	
EndProcedure

#Region ItemsHandler

&AtClient
Procedure TemplateOnChange(Item)
	isTemplateChanged = True;
EndProcedure

&AtClient
Procedure TemplateOnChangeAreaContent(Item, Area, AdditionalParameters)
	//TODO: Insert the handler content
EndProcedure

&AtClient
Procedure TemplateSelection(Item, Area, StandardProcessing)
	If Area.Top = 1 Then
		StandardProcessing = False;
	EndIf;
EndProcedure

&AtClient
Procedure ResultSelection(Item, Area, StandardProcessing)
	If Area.Top = 1 Then
		StandardProcessing = False;
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

#EndRegion

#Region Service

#Region FillTemplate
&AtServer
Procedure FillColumns()
	
	Columns = GetColumnList();
		
	Index = 0;
	For Each Column In Columns Do
		Index = Index + 1;
		//@skip-check invocation-parameter-type-intersect
		Area = Template.Area(1, Index);
		ColumnInfo = Column.Value; // See GetColumnInfo
		Area.Text = Column.Key;
		Area.ColumnWidth = ColumnInfo.Size;
		Area.BackColor = WebColors.Beige;
		Area.Font = StyleFonts.LargeTextFont;
		Area.TextPlacement = SpreadsheetDocumentTextPlacementType.Cut;
		Area.HorizontalAlign = HorizontalAlign.Center;
		Area.Protection = True;
		Area.ContainsValue = True;
		Area.ValueType = New TypeDescription("String");
		Area.Value = ColumnInfo.Name;
	EndDo;
	
	Template.FixedTop = 1;
	
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
	
	Item = GetColumnInfo();
	Item.Type = New TypeDescription("CatalogRef.ItemKeys");
	Item.Name = Metadata.Catalogs.Items.Synonym;
	Item.Size = 20;
	Columns.Insert("Item", Item);
	
	Item = GetColumnInfo();
	Item.Type = New TypeDescription("CatalogRef.Items");
	Item.Name = Metadata.Catalogs.Items.Synonym;
	Item.Size = 20;
	Columns.Insert("Item", Item);
	
	ItemKey = GetColumnInfo();
	ItemKey.Type = New TypeDescription("CatalogRef.ItemKeys");
	ItemKey.Name = Metadata.Catalogs.ItemKeys.Synonym;
	ItemKey.Size = 20;
	Columns.Insert("ItemKey", ItemKey);
	
	SerialLotNumber = GetColumnInfo();
	SerialLotNumber.Type = New TypeDescription("CatalogRef.SerialLotNumbers");
	SerialLotNumber.Name = Metadata.Catalogs.SerialLotNumbers.Synonym;
	SerialLotNumber.Size = 20;
	Columns.Insert("SerialLotNumber", SerialLotNumber);
	
	Unit = GetColumnInfo();
	Unit.Type = New TypeDescription("CatalogRef.Units");
	Unit.Name = Metadata.Catalogs.Units.Synonym;
	Unit.Size = 20;
	Columns.Insert("Unit", Unit);
	
	Barcode = GetColumnInfo();
	Barcode.Type = New TypeDescription(Metadata.DefinedTypes.typeBarcode.Type);
	Barcode.Name = Metadata.InformationRegisters.Barcodes.Dimensions.Barcode.Synonym;
	Barcode.Size = 20;
	Columns.Insert("Barcode", Barcode);
	
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
	
	FillResultTable();
	
EndProcedure

&AtServer
Procedure FillResultTable()
	
	BarcodeNumber = GetColumnNumber("Barcode");
	BarcodeArray = GetColumnArray(BarcodeNumber); // Array of String
	
	QuantityNumber = GetColumnNumber("Quantity");
	QuantityArray = GetColumnArray(QuantityNumber); // Array of String
	
	BarcodeTable = BarcodeServer.GetBarcodeTable();
	For Index = 0 To BarcodeArray.UBound() Do
		NewRow = BarcodeTable.Add();
		NewRow.Key = String(Index);
		NewRow.Barcode = BarcodeArray[Index];
		Quantity = QuantityArray[Index];
		NewRow.Quantity = ?(IsBlankString(Quantity), 1, Number(Quantity));
	EndDo;
	
	
	ItemTable = GetItemInfo.ByBarcodeTable(BarcodeTable);
	Index = 0;
	
	Result = New SpreadsheetDocument();
	
	For Each Column In ItemTable.Columns Do
		Index = Index + 1;
		//@skip-check invocation-parameter-type-intersect
		Area = Result.Area(1, Index);
		Area.Text = Column.Name;
		Area.ColumnWidth = Column.Width;
		Area.BackColor = WebColors.Beige;
		Area.Font = StyleFonts.LargeTextFont;
		Area.TextPlacement = SpreadsheetDocumentTextPlacementType.Cut;
		Area.HorizontalAlign = HorizontalAlign.Center;
		Area.Protection = True;
		Area.ContainsValue = True;
		Area.ValueType = New TypeDescription("String");
		Area.Value = Column.Title;
	EndDo;
	
	Result.FixedTop = 1;

	AreaToFill = GetResultRow(ItemTable);
	For Each Row In ItemTable Do
		AreaToFill.Parameters.Fill(Row);
		Result.Put(AreaToFill);
	EndDo;
	
EndProcedure

Function GetResultRow(ItemTable)

	TmpSP = New SpreadsheetDocument();
	Index = 0;
	For Each Column In ItemTable.Columns Do
		Index = Index + 1;
		//@skip-check invocation-parameter-type-intersect
		Area = TmpSP.Area(2, Index);
		Area.ContainsValue = True;
		Area.ValueType = Column.ValueType;
		Area.Parameter = Column.Name;
		Area.FillType = SpreadsheetDocumentAreaFillType.Parameter;
	EndDo;
	
	//@skip-check invocation-parameter-type-intersect
	Area = TmpSP.Area(2, 1, 2, ItemTable.Columns.Count());
	Area.Name = "Row";
	Return TmpSP.GetArea("Row");
	
EndFunction

#EndRegion

#Region ChangePages

&AtClient
Procedure SetPage(Index)
	
	StepNumber = StepNumber + Index;
	
	Items.FormBack.Visible = StepNumber > 0;
	
	PageLimit = 1;
	If StepNumber > PageLimit Then
		StepNumber = PageLimit;
	EndIf;
	
	If StepNumber = 0 Then
		Items.PagesMain.CurrentPage = Items.PageTemplate;
	ElsIf StepNumber = 1 Then
		Items.PagesMain.CurrentPage = Items.PageResult;
		
		FillResult();
		
	Else
		Return;
	EndIf;
	
EndProcedure

#EndRegion

#Region SpreadSheet

Function GetColumnNumber(Name)
	For Index = 1 To Template.TableWidth Do
		//@skip-check invocation-parameter-type-intersect
		Area = Template.Area(1, Index);
		If Area.Text = Name Then
			Return Index;
		EndIf;
	EndDo;
	Return 0;
EndFunction

Function GetColumnArray(ColumnNumber)
	Array = New Array;
	For Index = 2 To Template.TableHeight Do
		//@skip-check invocation-parameter-type-intersect
		Area = Template.Area(Index, ColumnNumber);
		Text = Area.Text;
		Array.Add(TrimAll(Text));
	EndDo;
	Return Array;
EndFunction
#EndRegion

#EndRegion

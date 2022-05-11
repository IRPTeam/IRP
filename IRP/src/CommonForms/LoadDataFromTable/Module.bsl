// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	FillColumns();
	
EndProcedure

#Region Commands

&AtClient
Procedure Next(Command)
	//TODO: Insert the handler content
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
		Area = Template.Area(1, Index);
		ColumnInfo = Column.Value; // See GetColumnInfo
		Area.Text = ColumnInfo.Name;
		Area.ColumnWidth = ColumnInfo.Size;
		Area.BackColor = WebColors.Beige;
		Area.Font = StyleFonts.LargeTextFont;
		Area.TextPlacement = SpreadsheetDocumentTextPlacementType.Cut;
		Area.HorizontalAlign = HorizontalAlign.Center;
		Area.Protection = True;
	EndDo;
	
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

#EndRegion

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	If Object.Ref.IsEmpty() Then
		If Parameters.Property("Item") Then
			Object.Item = Parameters.Item;
			Items.Item.ReadOnly = True;
		EndIf;
		Items.PackageUnit.ReadOnly = True;
		Items.PackageUnit.InputHint = R().InfoMessage_004;
	EndIf;
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	If Parameters.Property("SelectedFilters") Then
		For Each Row In Parameters.SelectedFilters Do
			ThisObject[Row.Name] = Row.Value;
			Items[Row.Name].ReadOnly = True;
		EndDo;
	EndIf;
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	RestoreSettings();
	Items.ConsignorsInfo.Visible = FOServer.IsUseCommissionTrading();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	PictureViewerClient.UpdateObjectPictures(ThisObject, Object.Ref);
	AddAttributesAndPropertiesClient.UpdateObjectAddAttributeHTML(ThisObject, Object.Ref);
	SetSettings();
	ChangingFormBySettings();
	SetVisibleCodeString();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
		UpdateAddAttributesHTMLDocument();
	EndIf;
	PictureViewerClient.HTMLEventAction(EventName, Parameter, Source, ThisObject);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	UpdateAddAttributesHTMLDocument();
	AddAttributesCreateFormControl();

	Items.PackageUnit.ReadOnly = False;
	Items.PackageUnit.InputHint = "";
EndProcedure

#EndRegion

#Region AddAttributeViewer

&AtClient
Async Procedure AddAttributesHTMLDocumentComplete(Item)
	UpdateAddAttributesHTMLDocument();
EndProcedure

&AtClient
Async Procedure UpdateAddAttributesHTMLDocument()
	If Items.ViewAdditionalAttribute.Check Then
		HTMLWindow = PictureViewerClient.InfoDocumentComplete(Items.AddAttributeViewHTML);
		JSON = AddAttributesAndPropertiesClient.AddAttributeInfoForHTML(Object.Ref, UUID);
		HTMLWindow.clearAll();
		HTMLWindow.fillData(JSON);
	EndIf;
EndProcedure

#EndRegion

#Region PictureViewer

&AtClient
Procedure HTMLViewControl(Command)
	PictureViewerClient.HTMLViewControl(ThisObject, Command.Name);
	If Items.ViewDetailsTree.Check And Items.ViewPictures.Check Then
		PictureViewerClient.HTMLViewControl(ThisObject, Commands.ViewDetailsTree.Name);
	EndIf;
	ChangingFormBySettings();
	SaveSettings();
EndProcedure

&AtClient
Procedure PictureViewHTMLOnClick(Item, EventData, StandardProcessing)
	PictureViewerClient.PictureViewHTMLOnClick(ThisObject, Item, EventData, StandardProcessing);
EndProcedure

&AtClient
Procedure PictureViewerHTMLDocumentComplete(Item)
	PictureViewerClient.UpdateHTMLPicture(Item, ThisObject);
EndProcedure

&AtClient
Procedure ViewDetailsTree(Command)
	PictureViewerClient.HTMLViewControl(ThisObject, Command.Name);
	If Items.ViewDetailsTree.Check And Items.ViewPictures.Check Then
		PictureViewerClient.HTMLViewControl(ThisObject, Commands.ViewPictures.Name);
	EndIf;
	ChangingFormBySettings();
	SaveSettings();
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region AddAttribute

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region FormElementEvents

&AtClient
Procedure ItemTypeOnChange(Item)
	AddAttributesCreateFormControl();
EndProcedure

&AtClient
Procedure SizeOnChange(Item)
	CommonFunctionsClientServer.CalculateVolume(Object);
EndProcedure

&AtClient
Procedure ControlCodeStringOnChange(Item)
	If Not Object.ControlCodeString Then
		Object.CheckCodeString = False;
		Object.ControlCodeStringType = Undefined;
	EndIf;
	SetVisibleCodeString();
EndProcedure

&AtClient
Procedure Tree_RefreshData(Command)
	RefreshDetailsTreeAtServer();
	Tree_ExpandAll(Command);
EndProcedure

&AtClient
Procedure Tree_ExpandAll(Command)
	For Each TreeRow In ThisObject.DetailsTree.GetItems() Do
		Items.DetailsTree.Expand(TreeRow.GetID(), True);
	EndDo;
EndProcedure

&AtClient
Procedure Tree_CollapseAll(Command)
	For Each TreeRow In ThisObject.DetailsTree.GetItems() Do
		Items.DetailsTree.Collapse(TreeRow.GetID());
	EndDo;
EndProcedure

&AtClient
Procedure DetailsTreeSelection(Item, RowSelected, Field, StandardProcessing)
	TableRow = ThisObject.DetailsTree.FindByID(RowSelected);
	If ValueIsFilled(TableRow.RefValue) Then
		ShowValue(, TableRow.RefValue);
	EndIf;
EndProcedure

#EndRegion

#Region Service

&AtClient
Procedure SetVisibleCodeString()
	Items.CheckCodeString.Visible = Object.ControlCodeString;
	Items.ControlCodeStringType.Visible = Object.ControlCodeString;
EndProcedure

&AtClient
Procedure SetSettings()
	PictureViewerClient.HTMLViewControl(ThisObject, "ViewPictures");
	PictureViewerClient.HTMLViewControl(ThisObject, "ViewAdditionalAttribute");
	PictureViewerClient.HTMLViewControl(ThisObject, "ViewDetailsTree");
EndProcedure

&AtClient
// @skip-check unknown-method-property
Procedure ChangingFormBySettings()
	If Items.ViewPictures.Check Then
		Items.GroupMainLeft.Group = ChildFormItemsGroup.Vertical;
	Else
		Items.GroupMainLeft.Group = ChildFormItemsGroup.Horizontal;
	EndIf;
	
	Items.DetailsTree.Visible = Items.ViewDetailsTree.Check;
	If Items.DetailsTree.Visible And ThisObject.DetailsTree.GetItems().Count() = 0 Then
		Tree_RefreshData(Undefined);
	EndIf;
	
EndProcedure	

&AtServer
Procedure SaveSettings()
	NewSettings = New Structure;
	NewSettings.Insert("ViewPictures", Items.ViewPictures.Check);
	NewSettings.Insert("ViewAdditionalAttribute", Items.ViewAdditionalAttribute.Check);
	NewSettings.Insert("ViewDetailsTree", Items.ViewDetailsTree.Check);
	CommonSettingsStorage.Save("Catalog_Item", "Settings", NewSettings);
EndProcedure	

&AtServer
Procedure RestoreSettings()
	
	Items.ViewPictures.Check = True;
	Items.ViewAdditionalAttribute.Check = True;
	
	RestoreSettings = CommonSettingsStorage.Load("Catalog_Item", "Settings"); // Structure
	If TypeOf(RestoreSettings) = Type("Structure") Then
		If RestoreSettings.Property("ViewPictures") Then
			Items.ViewPictures.Check = Not RestoreSettings.ViewPictures;
		EndIf;
		If RestoreSettings.Property("ViewAdditionalAttribute") Then
			Items.ViewAdditionalAttribute.Check = Not RestoreSettings.ViewAdditionalAttribute;
		EndIf;
		If RestoreSettings.Property("ViewDetailsTree") Then
			Items.ViewDetailsTree.Check = Not RestoreSettings.ViewDetailsTree;
		EndIf;
	EndIf;

EndProcedure

&AtServer
Procedure RefreshDetailsTreeAtServer()
	
	ThisObject.DetailsTree.GetItems().Clear();
	If Object.Ref.IsEmpty() Then
		Return;
	EndIf;
	
	Query = New Query;
	Query.SetParameter("Item", Object.Ref);
	
	
	// item keys
	ItemKeysRow = ThisObject.DetailsTree.GetItems().Add();
	ItemKeysRow.Description = Metadata.Catalogs.ItemKeys.Synonym;
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	ItemKeys.Ref,
	|	ItemKeys.Presentation AS Presentation
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Item = &Item
	|	AND NOT ItemKeys.DeletionMark
	|
	|ORDER BY
	|	Presentation";
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		ItemKeyRow = ItemKeysRow.GetItems().Add();
		ItemKeyRow.RefValue = QuerySelection.Ref; 
		ItemKeyRow.Description = QuerySelection.Presentation; 
	EndDo;
	
	
	// serial lot numbers
	SerialLotNumbersRow = ThisObject.DetailsTree.GetItems().Add();
	SerialLotNumbersRow.Description = Metadata.Catalogs.SerialLotNumbers.Synonym;
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	SerialLotNumbers.Ref,
	|	SerialLotNumbers.Presentation AS Presentation
	|FROM
	|	Catalog.SerialLotNumbers AS SerialLotNumbers
	|WHERE
	|	NOT SerialLotNumbers.DeletionMark
	|	AND SerialLotNumbers.SerialLotNumberOwner = &Item
	|
	|ORDER BY
	|	Presentation";
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		SerialLotNumberRow = SerialLotNumbersRow.GetItems().Add();
		SerialLotNumberRow.RefValue = QuerySelection.Ref; 
		SerialLotNumberRow.Description = QuerySelection.Presentation; 
	EndDo;
	
	
	// barcodes
	BarcodeRow = ThisObject.DetailsTree.GetItems().Add();
	BarcodeRow.Description = Metadata.InformationRegisters.Barcodes.Synonym;
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	Barcodes.Barcode AS Barcode
	|FROM
	|	InformationRegister.Barcodes AS Barcodes
	|WHERE
	|	Barcodes.ItemKey.Item = &Item
	|
	|ORDER BY
	|	Barcode";
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		BarcodeRow.GetItems().Add().Description = QuerySelection.Barcode; 
	EndDo;
	
	
	// prices
	PricesRow = ThisObject.DetailsTree.GetItems().Add();
	PricesRow.Description = Metadata.InformationRegisters.PricesByItems.Synonym;
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	PricesByItemsSliceLast.PriceType AS PriceType,
	|	PricesByItemsSliceLast.Period,
	|	PricesByItemsSliceLast.Price,
	|	PricesByItemsSliceLast.PriceType.Currency AS Currency
	|FROM
	|	InformationRegister.PricesByItems.SliceLast AS PricesByItemsSliceLast
	|WHERE
	|	PricesByItemsSliceLast.Item = &Item
	|
	|UNION ALL
	|
	|SELECT DISTINCT
	|	PricesByItemKeysSliceLast.PriceType AS PriceType,
	|	PricesByItemKeysSliceLast.Period,
	|	PricesByItemKeysSliceLast.Price,
	|	PricesByItemKeysSliceLast.PriceType.Currency
	|FROM
	|	InformationRegister.PricesByItemKeys.SliceLast AS PricesByItemKeysSliceLast
	|WHERE
	|	PricesByItemKeysSliceLast.ItemKey.Item = &Item
	|
	|ORDER BY
	|	PriceType";
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		PriceRow = PricesRow.GetItems().Add();
		PriceRow.Description = 
			StrTemplate("%1 (%2) - %3 (%4)", 
				QuerySelection.PriceType, 
				Format(QuerySelection.Period, "DLF=D;"),
				Format(QuerySelection.Price, "NZ=; NG=;"),
				QuerySelection.Currency);
		PriceRow.RefValue = QuerySelection.PriceType; 
	EndDo;
	
	
	// stocks
	StocksRow = ThisObject.DetailsTree.GetItems().Add();
	StocksRow.Description = Metadata.AccumulationRegisters.R4011B_FreeStocks.Synonym;
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	R4011B_FreeStocksBalance.Store AS Store,
	|	SUM(R4011B_FreeStocksBalance.QuantityBalance) AS Quantity,
	|	CASE
	|		WHEN R4011B_FreeStocksBalance.ItemKey.Unit = VALUE(Catalog.Units.EmptyRef)
	|			THEN R4011B_FreeStocksBalance.ItemKey.Item.Unit
	|		ELSE R4011B_FreeStocksBalance.ItemKey.Unit
	|	END AS Unit
	|FROM
	|	AccumulationRegister.R4011B_FreeStocks.Balance AS R4011B_FreeStocksBalance
	|WHERE
	|	R4011B_FreeStocksBalance.ItemKey.Item = &Item
	|GROUP BY
	|	R4011B_FreeStocksBalance.Store,
	|	CASE
	|		WHEN R4011B_FreeStocksBalance.ItemKey.Unit = VALUE(Catalog.Units.EmptyRef)
	|			THEN R4011B_FreeStocksBalance.ItemKey.Item.Unit
	|		ELSE R4011B_FreeStocksBalance.ItemKey.Unit
	|	END
	|
	|ORDER BY
	|	Store";
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		StockRow = StocksRow.GetItems().Add();
		StockRow.Description = 
			StrTemplate("%1 - %2 %3", 
				QuerySelection.Store, 
				Format(QuerySelection.Quantity, "NZ=; NG=;"),
				QuerySelection.Unit);
		StockRow.RefValue = QuerySelection.Store;
	EndDo;
	
EndProcedure

#EndRegion

#Region Public

Procedure FillAtServer(Object, Form) Export
	ItemTable = Form.FormAttributeToValue("ItemList");

	Query = New Query();
	Query.Text = 
	"SELECT
	|	Barcodes.ItemKey,
	|	MAX(Barcodes.Barcode) AS Barcode
	|INTO Barcodes_TT
	|FROM
	|	InformationRegister.Barcodes AS Barcodes
	|WHERE
	|	NOT Barcodes.ItemKey.Specification <> VALUE(Catalog.Specifications.EmptyRef)
	|GROUP BY
	|	Barcodes.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemKeys.Item AS Item,
	|	ItemKeys.Ref AS ItemKey,
	|	ItemKeys.Unit AS Unit,
	|	ItemKeys.Unit AS ItemKeyUnit,
	|	ItemKeys.Item.Unit AS ItemUnit,
	|	NOT ItemKeys.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	Barcodes_TT.Barcode AS Barcode,
	|	&PriceType AS PriceType
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|		LEFT JOIN Barcodes_TT AS Barcodes_TT
	|		ON ItemKeys.Ref = Barcodes_TT.ItemKey";
	Query.SetParameter("PriceType", Form.PriceType);
	ItemPriceTable = Query.Execute().Unload();
	If Not ItemPriceTable.Count() Then
		Return;
	EndIf;

	ItemsInfo = GetItemInfo.ItemPriceInfoByTable(ItemPriceTable, CommonFunctionsServer.GetCurrentSessionDate());

	PriceQuery = New Query();
	//@skip-check bsl-ql-hub
	PriceQuery.Text = 
	"SELECT
	|	ItemSource.Item,
	|	ItemSource.ItemKey,
	|	ItemSource.ItemUnit,
	|	ItemSource.ItemKeyUnit,
	|	ItemSource.PriceType,
	|	ItemSource.Barcode
	|INTO ItemTable
	|FROM
	|	&ItemSource AS ItemSource
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PriceSource.ItemKey,
	|	PriceSource.Price
	|INTO PriceTable
	|FROM
	|	&PriceSource AS PriceSource
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemTable.Item,
	|	ItemTable.ItemKey,
	|	CASE
	|		WHEN ItemTable.ItemKeyUnit = VALUE(Catalog.Units.EmptyRef)
	|			THEN ItemTable.ItemUnit
	|		ELSE ItemTable.ItemKeyUnit
	|	END AS Unit,
	|	ItemTable.PriceType,
	|	ItemTable.Barcode,
	|	1 AS Quantity,
	|	ItemTable.ItemKeyUnit,
	|	ItemTable.ItemUnit,
	|	NOT ItemTable.ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	ISNULL(PriceTable.Price, 0) AS Price
	|FROM
	|	ItemTable AS ItemTable
	|		LEFT JOIN PriceTable AS PriceTable
	|		ON ItemTable.ItemKey = PriceTable.ItemKey";
	PriceQuery.SetParameter("ItemSource", ItemPriceTable);
	PriceQuery.SetParameter("PriceSource", ItemsInfo);
	
	PriceQuerySelection = PriceQuery.Execute().Select();
	While PriceQuerySelection.Next() Do
		NewRow = ItemTable.Add();
		FillPropertyValues(NewRow, PriceQuerySelection);
		NewRow.BarcodeType = Form.BarcodeType;
	EndDo;

	Form.ValueToFormAttribute(ItemTable, "ItemList");

EndProcedure

Function PrintLabels(Object, Form) Export
	SpreadDocsArray = New Array();
	SpreadDoc  = New SpreadsheetDocument();
	SpreadDoc.PrintParametersName = "PrintParameters_PrintLabels";

	TemplateTableFilter = New Structure();
	TemplateTableFilter.Insert("Print", True);
	TemplateTable = Form.ItemList.Unload(TemplateTableFilter, "Template");
	TemplateTable.GroupBy("Template");
	ItemListTable = Form.FormAttributeToValue("ItemList");

	For Each TemplateRow In TemplateTable Do

		TemplateStructure = TemplateRow.Template.ValueOfTemplate.Get();

		Template = TemplateStructure.Spreadsheet;
		TemplateAreaParameters = TemplateStructure.ParametersMap;
		TemplateHash = TemplateStructure.Hash;

		TemplateFilter = New Structure();
		TemplateFilter.Insert("TemplateHash", TemplateHash);
		ItemListValue = ItemListTable.Copy(TemplateFilter, "Item, ItemKey, Barcode, Price, Unit, Quantity, BarcodeType");

		DataSourceScheme = Catalogs.PrintTemplates.GetTemplate("Template");

		ExternalDataProc = TemplateRow.Template.ExternalDataProc;
		If ValueIsFilled(ExternalDataProc) Then
			Info = AddDataProcServer.AddDataProcInfo(ExternalDataProc);
			Info.Create = True;
			AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
			If Not AddDataProc = Undefined Then
				SetDataSetFields(DataSourceScheme.DataSets.Get(0), AddDataProc);
				FillDataTable(ItemListValue, AddDataProc);
			EndIf;
		EndIf;

		Settings = DataSourceScheme.DefaultSettings;
		Settings.Structure.Clear();
		StructureGroup = Settings.Structure.Add(Type("DataCompositionGroup"));
		StructureGroup.Use = True;
		StructureGroup.Selection.Items.Add(Type("DataCompositionAutoSelectedField"));
		StructureGroup.Order.Items.Add(Type("DataCompositionAutoOrderItem"));

		For Each TemplateAreaParameter In TemplateAreaParameters Do
			TemplateAreaParameterKey = TemplateAreaParameter.Key;
			TemplateAreaParameterKey = StrReplace(TemplateAreaParameterKey, "{", "");
			TemplateAreaParameterKey = StrReplace(TemplateAreaParameterKey, "}", "");
			StructureGroupField = StructureGroup.GroupFields.Items.Add(Type("DataCompositionGroupField"));
			StructureGroupField.Use = True;
			StructureGroupField.Field = New DataCompositionField(TemplateAreaParameterKey);
			StructureGroupField = StructureGroup.GroupFields.Items.Add(Type("DataCompositionGroupField"));
			StructureGroupField.Use = True;
			StructureGroupField.Field = New DataCompositionField(TemplateAreaParameterKey);
		EndDo;

		For Each Column In ItemListValue.Columns Do
			StructureGroupField = StructureGroup.GroupFields.Items.Add(Type("DataCompositionGroupField"));
			StructureGroupField.Use = True;
			StructureGroupField.Field = New DataCompositionField(Column.Name);
		EndDo;

		SettingsComposer = New DataCompositionSettingsComposer();
		SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(DataSourceScheme));
		SettingsComposer.LoadSettings(Settings);
		SettingsComposerSettings = SettingsComposer.GetSettings();

		TemplateComposer = New DataCompositionTemplateComposer();
		ComposerOfTemplate = TemplateComposer.Execute(DataSourceScheme, SettingsComposerSettings, , , Type(
			"DataCompositionValueCollectionTemplateGenerator"));

		QueryTextArray = New Array();
		QueryTextArray.Add("SELECT");
		For Each Column In ItemListValue.Columns Do
			QueryTextArray.Add("ItemSource." + Column.Name + ",");
		EndDo;
		QueryTextArray.Add("True AS ItemSourceParameter
						   |	INTO Item_TT
						   |FROM
						   |	&ItemSource AS ItemSource
						   |;
						   |////////////////////////////////////////////////////////////////////////////////
						   |SELECT");
		For Each Column In ItemListValue.Columns Do
			QueryTextArray.Add("Item_TT." + Column.Name + ",");
		EndDo;
		QueryTextArray.Add("ItemSourceParameter
						   |FROM
						   |	Item_TT AS Item_TT");

		Query = New Query();
		Query.Text = StrConcat(QueryTextArray, Chars.LF);
		Query.SetParameter("ItemSource", ItemListValue);
		QueryExecution = Query.Execute();
		If QueryExecution.IsEmpty() Then
			Continue;
		Else
			QueryUnload = QueryExecution.Unload();
		EndIf;

		ExtDataSets = New Structure("DataSource", QueryUnload);
		CompositionProcessor = New DataCompositionProcessor();
		CompositionProcessor.Initialize(ComposerOfTemplate, ExtDataSets, Undefined, True);
		Result = New ValueTable();
		OutputProcessor = New DataCompositionResultValueCollectionOutputProcessor();
		OutputProcessor.SetObject(Result);
		OutputProcessor.Output(CompositionProcessor);

		TemplateFilter = New Structure();
		TemplateFilter.Insert("Template", TemplateRow.Template);
		TemplateArea = Template.GetArea();
		LabelsInRowIterator = 1;
		LabelsInColumnIterator = 1;

		For Each QuerySelection In Result Do
			For Each ItemMap In TemplateAreaParameters Do
				TemplateArea.Parameters[ItemMap.Key] = QuerySelection[ItemMap.Value];
			EndDo;

			If TemplateArea.Drawings.Count() Then
				For Each Drawing In TemplateArea.Drawings Do
					SetDrawingPicture(Drawing, QuerySelection);
				EndDo;
			EndIf;

			For LabelQuantityCounter = 1 To QuerySelection.Quantity Do
				If LabelsInColumnIterator > TemplateStructure.LabelsInColumn Then
					LabelsInRowIterator = 1;
					LabelsInColumnIterator = 1;
					SpreadDoc.PutHorizontalPageBreak();
					SpreadDoc.Put(TemplateArea);
				Else
					If LabelsInRowIterator > TemplateStructure.LabelsInRow Then
						LabelsInRowIterator = 1;
						LabelsInColumnIterator = LabelsInColumnIterator + 1;
						SpreadDoc.PutHorizontalPageBreak();
						SpreadDoc.Put(TemplateArea);
					Else
						LabelsInRowIterator = LabelsInRowIterator + 1;
						SpreadDoc.Join(TemplateArea);
					EndIf;
				EndIf;
			EndDo;
		EndDo;

		If Form.SplitTemplatesByPages Then
			SpreadDoc.PutHorizontalPageBreak();
			SpreadDoc.FitToPage = True;
			SpreadDocsArray.Add(SpreadDoc);

			SpreadDoc  = New SpreadsheetDocument();
			SpreadDoc.PrintParametersKey = TemplateStructure.PrintParametersKey;
		EndIf;
		SpreadDoc.PutHorizontalPageBreak();
	EndDo;

	If SpreadDoc.TableHeight <> 0 Then
		SpreadDoc.PutHorizontalPageBreak();
		SpreadDoc.FitToPage = True;
		SpreadDocsArray.Add(SpreadDoc);
	EndIf;

	Return SpreadDocsArray;
EndFunction

#EndRegion

#Region Private

Procedure SetDataSetFields(DataSet, AddDataProc)
	AvailableFields = AddDataProc.GetAvailableFields();
	For Each Row In AvailableFields Do
		NewField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
		NewField.Title = Row.Title;
		NewField.DataPath = Row.Name;
		NewField.Field = Row.Name;
		NewField.ValueType = Row.TypeDescription;
	EndDo;
EndProcedure

Procedure FillDataTable(DataTable, AddDataProc)

	AvailableFields = AddDataProc.GetAvailableFields();
	For Each Field In AvailableFields Do
		DataTable.Columns.Add(Field.Name, Field.TypeDescription, Field.Title);
	EndDo;

	For Each Row In DataTable Do
		For Each Field In AvailableFields Do
			If Not Field.SetByUser Then
				AddDataProc.FillFieldValue(Row, Field.Name);
			EndIf;
		EndDo;
	EndDo;

EndProcedure

Procedure SetDrawingPicture(Drawing, QuerySelection)
	BarcodeParameters = BarcodeServer.GetBarcodeDrawParameters();
	If Drawing.Name = "BarcodePicture" Then
		If ValueIsFilled(QuerySelection.Barcode) Then
			BarcodeParameters.Width = Round(Drawing.Width / 0.1);
			BarcodeParameters.Height = Round(Drawing.Height / 0.1);
			BarcodeParameters.Barcode = QuerySelection.Barcode;
			BarcodeParameters.CodeType = QuerySelection.BarcodeType;
			Drawing.Picture = BarcodeServer.GetBarcodePicture(BarcodeParameters);
		Else
			Drawing.Picture = New Picture();
		EndIf;
	ElsIf Drawing.Name = "QRPicture" Then
		If ValueIsFilled(QuerySelection.Barcode) Then
			BarcodeParameters.Barcode = QuerySelection.Barcode;
			Drawing.Picture = BarcodeServer.GetQRPicture(BarcodeParameters);
		Else
			Drawing.Picture = New Picture();
		EndIf;
	ElsIf Drawing.Name = "ItemPicture" Then
		Drawing.Picture = New Picture();
		ArrayOfFiles = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(QuerySelection.Item);
		If ArrayOfFiles.Count() Then
			If ArrayOfFiles[0].isPreviewSet Then
				Drawing.Picture = New Picture(ArrayOfFiles[0].Preview.Get());
			EndIf;
		EndIf;
	ElsIf Drawing.Name = "ItemKeyPicture" Then
		Drawing.Picture = New Picture();
		ArrayOfFiles = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(QuerySelection.ItemKey);
		If ArrayOfFiles.Count() Then
			If ArrayOfFiles[0].isPreviewSet Then
				Drawing.Picture =  New Picture(ArrayOfFiles[0].Preview.Get());
			EndIf;
		EndIf;
	EndIf;
EndProcedure

#EndRegion
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");

	CatalogObject = ThisObject.FormAttributeToValue("Object");
	TemplateStructure = CatalogObject.ValueOfTemplate.Get();
	If TemplateStructure <> Undefined Then
		Try
			ThisObject.TemplateSpreadsheet = TemplateStructure.Spreadsheet;
			ThisObject.LabelsInRow = TemplateStructure.LabelsInRow;
			ThisObject.LabelsInColumn = TemplateStructure.LabelsInColumn;
		Except
			ThisObject.TemplateSpreadsheet = Catalogs.PrintTemplates.GetTemplate("Default");
		EndTry;
	Else
		ThisObject.TemplateSpreadsheet = Catalogs.PrintTemplates.GetTemplate("Default");
	EndIf;

	DataSourceScheme = GenerateDataSourceScheme();
	SetAvailableFields(DataSourceScheme);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Not ValueIsFilled(ThisObject.PasteFieldAs) Then
		ThisObject.PasteFieldAs = Items.PasteType.ChoiceList.Get(0);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	TemplateStructure = New Structure();

	ParametersMap = GetTemplateParameters();
	TemplateStructure.Insert("ParametersMap", ParametersMap);

	TemplateStructure.Insert("LabelsInRow", ThisObject.LabelsInRow);
	TemplateStructure.Insert("LabelsInColumn", ThisObject.LabelsInColumn);

	SetByUserFields = New Array();

	If ValueIsFilled(Object.ExternalDataProc) Then
		Info = AddDataProcServer.AddDataProcInfo(Object.ExternalDataProc);
		Info.Create = True;
		AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
		If Not AddDataProc = Undefined Then
			AdditionalFields = AddDataProc.GetAvailableFields();

			For Each AdditionalField In AdditionalFields Do

				If AdditionalField.SetByUser Then
					AdditionalField.Insert("UUID", New UUID());
					SetByUserFields.Add(AdditionalField);
				EndIf;

			EndDo;
		EndIf;
	EndIf;

	TemplateStructure.Insert("SetByUserFields", SetByUserFields);

	TemplateStructure.Insert("Spreadsheet", ThisObject.TemplateSpreadsheet);
	TemplateStructure.Insert("Hash", GetHashMD5(ThisObject.TemplateSpreadsheet));

	TemplateStructure.Insert("PrintParametersKey", ThisObject.TemplateSpreadsheet.PrintParametersKey);

	CurrentObject.ValueOfTemplate = New ValueStorage(TemplateStructure, New Deflation(9));
EndProcedure

#EndRegion

#Region FormCommandEvents

&AtClient
Procedure GetDefault(Command)
	GetDefaultAtServer();
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure ExternalDataProcOnChange(Item)
	ExternalDataProcOnChangeAtServer();
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure ExternalDataProcOnChangeAtServer()
	DataSourceScheme = GenerateDataSourceScheme();
	SetAvailableFields(DataSourceScheme);
EndProcedure

&AtServer
Function GenerateDataSourceScheme()
	DataSourceScheme = New DataCompositionSchema();

	Source = DataSourceScheme.DataSources.Add();
	Source.Name = "DataSource";
	Source.ConnectionString = "";
	Source.DataSourceType = "Local";

	DataSet = DataSourceScheme.DataSets.Add(Type("DataCompositionSchemaDataSetObject"));
	DataSet.Name = "DataSource";
	DataSet.ObjectName = "DataSource";
	DataSet.DataSource = "DataSource";

	MainFieldsArray = GetMainFieldsArray();

	For Each MainField In MainFieldsArray Do

		NewField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
		NewField.Title = MainField.Title;
		NewField.DataPath = MainField.Name;
		NewField.Field = MainField.Name;
		NewField.ValueType = MainField.TypeDescription;

	EndDo;

	If ValueIsFilled(Object.ExternalDataProc) Then
		Info = AddDataProcServer.AddDataProcInfo(Object.ExternalDataProc);
		Info.Create = True;
		AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
		If Not AddDataProc = Undefined Then
			AdditionalFields = AddDataProc.GetAvailableFields();

			For Each AdditionalField In AdditionalFields Do

				NewField = DataSet.Fields.Add(Type("DataCompositionSchemaDataSetField"));
				NewField.Title = AdditionalField.Title;
				NewField.DataPath = AdditionalField.Name;
				NewField.Field = AdditionalField.Name;
				NewField.ValueType = AdditionalField.TypeDescription;

			EndDo;
		EndIf;
	EndIf;

	Return DataSourceScheme;
EndFunction

&AtServer
Procedure SetAvailableFields(DataSourceScheme)
	SettingsComposer = New DataCompositionSettingsComposer();
	SettingsComposer.Initialize(New DataCompositionAvailableSettingsSource(DataSourceScheme));
	SettingsComposer.LoadSettings(DataSourceScheme.DefaultSettings);

	DataCompositionAddress = PutToTempStorage(DataSourceScheme, New UUID());
	AvailableFields = SettingsComposer;
	AvailableFields.Initialize(New DataCompositionAvailableSettingsSource(DataCompositionAddress));
EndProcedure

&AtServer
Function GetMainFieldsArray()
	ReturnValue = New Array();

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "Item");
	FieldStructure.Insert("TypeDescription", New TypeDescription("CatalogRef.Items"));
	FieldStructure.Insert("Title", "Item");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "ItemKey");
	FieldStructure.Insert("TypeDescription", New TypeDescription("CatalogRef.ItemKeys"));
	FieldStructure.Insert("Title", "Item key");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "Price");
	FieldStructure.Insert("TypeDescription", New TypeDescription("String", , New StringQualifiers(1)));
	FieldStructure.Insert("Title", "Price");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "Barcode");
	FieldStructure.Insert("TypeDescription", New TypeDescription("String", , New StringQualifiers(1)));
	FieldStructure.Insert("Title", "Barcode");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "QR");
	FieldStructure.Insert("TypeDescription", New TypeDescription("String", , New StringQualifiers(1)));
	FieldStructure.Insert("Title", "QR");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "ItemPicture");
	FieldStructure.Insert("TypeDescription", New TypeDescription("String", , New StringQualifiers(1)));
	FieldStructure.Insert("Title", "Item picture");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "ItemKeyPicture");
	FieldStructure.Insert("TypeDescription", New TypeDescription("String", , New StringQualifiers(1)));
	FieldStructure.Insert("Title", "Item key picture");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "BarcodePicture");
	FieldStructure.Insert("TypeDescription", New TypeDescription("String", , New StringQualifiers(1)));
	FieldStructure.Insert("Title", "Barcode picture");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "QRPicture");
	FieldStructure.Insert("TypeDescription", New TypeDescription("String", , New StringQualifiers(1)));
	FieldStructure.Insert("Title", "QR picture");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	FieldStructure = New Structure();
	FieldStructure.Insert("Name", "Picture");
	FieldStructure.Insert("TypeDescription", New TypeDescription("String", , New StringQualifiers(1)));
	FieldStructure.Insert("Title", "Picture");
	FieldStructure.Insert("SetByUser", False);
	ReturnValue.Add(FieldStructure);

	Return ReturnValue;
EndFunction

&AtClient
Procedure OrderOrderAvailableFieldsSelection(Item, RowSelected, Field, StandardProcessing)
#If MobileAppClient Then
	Return;
#EndIf

	SelectedAreas = ThisObject.Items.TemplateSpreadsheet.GetSelectedAreas();

	If Not SelectedAreas.Count() Then
		Return;
	EndIf;

	RowSelectedString = String(RowSelected);

	If TypeOf(SelectedAreas[0]) = Type("SpreadsheetDocumentDrawing") And ThisObject.PasteFieldAs = "free" Then
		isPicture = RowSelectedString = "BarcodePicture" Or RowSelectedString = "QRPicture" Or RowSelectedString = "ItemPicture"
			Or RowSelectedString = "ItemKeyPicture" Or RowSelectedString = "Picture";
		If isPicture Then
			Return;
		Else
			RowSelectedValue = StrReplace(RowSelectedString, "[", "{");
			RowSelectedValue = StrReplace(RowSelectedValue, "]", "}");
			SelectedAreas[0].Text = SelectedAreas[0].Text + ?(ValueIsFilled(SelectedAreas[0].Text), " ", "") + "["
				+ RowSelectedValue + "]";
		EndIf;
	ElsIf TypeOf(SelectedAreas[0]) = Type("SpreadsheetDocumentRange") Then
		If SelectedAreas.Count() Then
			SelectedAreas[0].Merge();
		EndIf;
		If RowSelectedString = "BarcodePicture" Or RowSelectedString = "QRPicture" Or RowSelectedString = "ItemPicture"
			Or RowSelectedString = "ItemKeyPicture" Or RowSelectedString = "Picture" Then
			PlacePictureToCellsArea(TemplateSpreadsheet, SelectedAreas[0].Name, RowSelectedString);
		Else
			If ThisObject.PasteFieldAs = "fixed" Then
#If Not MobileAppClient Then
				SelectedAreas[0].FillType = SpreadsheetDocumentAreaFillType.Template;
#EndIf
				RowSelectedValue = StrReplace(RowSelectedString, "[", "{");
				RowSelectedValue = StrReplace(RowSelectedValue, "]", "}");
				SelectedAreas[0].Text = SelectedAreas[0].Text + ?(ValueIsFilled(SelectedAreas[0].Text), " ", "") + "["
					+ RowSelectedValue + "]";
			Else
				PlaceTextToCellsArea(TemplateSpreadsheet, SelectedAreas[0].Name, RowSelectedString);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure PlacePictureToCellsArea(SpreadsheetDocument, AreaRange, PictureName)
	DrawingPicture = Undefined;

	If PictureName = "Picture" Then
		NewPicture = PictureLib.EmptyPicture;
	Else
		For Each Drawing In SpreadsheetDocument.Drawings Do
			If Drawing.Name = PictureName Then
				DrawingPicture = Drawing;
			Else
				Continue;
			EndIf;
		EndDo;
		NewPicture = PictureLib[PictureName];
	EndIf;

	If DrawingPicture = Undefined Then
		SpreadsheetPicture = SpreadsheetDocument.Drawings.Add(SpreadsheetDocumentDrawingType.Picture);
	Else
		SpreadsheetPicture = DrawingPicture;
	EndIf;

	PictureIndex = SpreadsheetDocument.Drawings.IndexOf(SpreadsheetPicture);

	If PictureName = "Picture" Then
		SpreadsheetDocument.Drawings[PictureIndex].Name = PictureName + Format(PictureIndex, "NZ=0; NG=0;");
	Else
		SpreadsheetDocument.Drawings[PictureIndex].Name = PictureName;
	EndIf;

	SpreadsheetDocument.Drawings[PictureIndex].Picture = NewPicture;
	SpreadsheetDocument.Drawings[PictureIndex].Place(SpreadsheetDocument.Area(AreaRange));
	SpreadsheetDocument.Drawings[PictureIndex].PictureSize = PictureSize.Proportionally;
EndProcedure

&AtServer
Procedure PlaceTextToCellsArea(SpreadsheetDocument, AreaRange, TextName)
	SpreadsheetText = SpreadsheetDocument.Drawings.Add(SpreadsheetDocumentDrawingType.Text);
	TextIndex = SpreadsheetDocument.Drawings.IndexOf(SpreadsheetText);
	SpreadsheetDocument.Drawings[TextIndex].FillType = SpreadsheetDocumentAreaFillType.Template;
	TextName = StrReplace(TextName, "[", "{");
	TextName = StrReplace(TextName, "]", "}");
	SpreadsheetDocument.Drawings[TextIndex].Text = "[" + TextName + "]";
	SpreadsheetDocument.Drawings[TextIndex].Place(SpreadsheetDocument.Area(AreaRange));
EndProcedure

&AtServer
Function GetTemplateParameters()
	ReturnValue = New Map();
	ReturnValueIterator = 0;

	TemplateArea = ThisObject.TemplateSpreadsheet.GetArea();
	For ColumnIterator = 1 To TemplateArea.TableWidth Do

		For RowIterator = 1 To TemplateArea.TableHeight Do

			RowCell = TemplateArea.Area(RowIterator, ColumnIterator);

			If RowCell.FillType = SpreadsheetDocumentAreaFillType.Template Then

				ParametersArray = RecognizeTemplateInStringTemplate(RowCell.Text);

				For Each ItemOfArray In ParametersArray Do

					If ReturnValue.Get(ItemOfArray) = Undefined Then
						ReturnValueIterator = ReturnValueIterator + 1;

						ItemOfArrayValue = ItemOfArray;
						ItemOfArrayValue = StrReplace(ItemOfArrayValue, "{", "_");
						ItemOfArrayValue = StrReplace(ItemOfArrayValue, "}", "_");
						ItemOfArrayValue = StrReplace(ItemOfArrayValue, " ", "");
						ItemOfArrayValue = StrReplace(ItemOfArrayValue, ".", "");

						ReturnValue.Insert(ItemOfArray, ItemOfArrayValue);
					EndIf;

				EndDo;

			EndIf;

		EndDo;

	EndDo;

	Drawings = ThisObject.TemplateSpreadsheet.Drawings;
	For Each Drawing In Drawings Do
		If Drawing.DrawingType = SpreadsheetDocumentDrawingType.Text Then
			If Drawing.FillType = SpreadsheetDocumentAreaFillType.Template Then
				ParametersArray = RecognizeTemplateInStringTemplate(Drawing.Text);
				For Each ItemOfArray In ParametersArray Do
					If ReturnValue.Get(ItemOfArray) = Undefined Then

						ReturnValueIterator = ReturnValueIterator + 1;

						ItemOfArrayValue = ItemOfArray;
						ItemOfArrayValue = StrReplace(ItemOfArrayValue, "{", "_");
						ItemOfArrayValue = StrReplace(ItemOfArrayValue, "}", "_");
						ItemOfArrayValue = StrReplace(ItemOfArrayValue, " ", "");
						ItemOfArrayValue = StrReplace(ItemOfArrayValue, ".", "");

						ReturnValue.Insert(ItemOfArray, ItemOfArrayValue);
					EndIf;
				EndDo;
			EndIf;
		EndIf;
	EndDo;

	Return ReturnValue;
EndFunction

&AtServer
Function RecognizeTemplateInStringTemplate(StringTemplate)
	ReturnValue = New Array();

	Start = 0;
	End = 0;
	For Iterator = 1 To StrLen(StringTemplate) Do
		If Mid(StringTemplate, Iterator, 1) = "[" Then
			Start = Iterator + 1;
		EndIf;
		If Mid(StringTemplate, Iterator, 1) = "]" Then
			End = Iterator - 1;
		EndIf;
		If (Start > 0) And (End > 0) Then
			ReturnValue.Add(Mid(StringTemplate, Start, End - Start + 1));
			Start = 0;
			End  = 0;
		EndIf;
	EndDo;

	Return ReturnValue;
EndFunction

&AtServer
Function GetHashMD5(Data)
	XMLWriter = New XMLWriter();
	XMLWriter.SetString();
	XDTOSerializer.WriteXML(XMLWriter, Data);
	XML = XMLWriter.Close();

	Hash = New DataHashing(HashFunction.MD5);
	Hash.Append(XML);
	HashSum = Hash.HashSum;

	HashSumString = String(HashSum);
	HashSumString = StrReplace(HashSumString, " ", "");

	HashSumStringUUID = Left(HashSumString, 8) + "-" + Mid(HashSumString, 9, 4) + "-" + Mid(HashSumString, 15, 4) + "-"
		+ Mid(HashSumString, 18, 4) + "-" + Right(HashSumString, 12);
	Return HashSumStringUUID;
EndFunction

&AtServer
Procedure GetDefaultAtServer()
	Items.DataSchemeSource.ChoiceList.Clear();
	DataCompositionSchemaValueArray = New Array();

	TemplateSpreadsheetValue = Catalogs.PrintTemplates.GetTemplate("Default");
	DataCompositionSchemaValue = GenerateDataSourceScheme();
	DataCompositionSchemaValueArray.Add("Default");

	If ValueIsFilled(Object.ExternalDataProc) Then
		Info = AddDataProcServer.AddDataProcInfo(Object.ExternalDataProc);
		Info.Create = True;
		AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
		If Not AddDataProc = Undefined Then
			For Each AddDataProcTemplate In AddDataProc.Metadata().Templates Do
				If AddDataProcTemplate.TemplateType = Metadata.ObjectProperties.TemplateType.SpreadsheetDocument Then
					SpreadsheetDocumentName = AddDataProc.Metadata().Templates.Get(0).Name;
					TemplateSpreadsheetValue = AddDataProc.GetTemplate(SpreadsheetDocumentName);
				ElsIf AddDataProcTemplate.TemplateType = Metadata.ObjectProperties.TemplateType.DataCompositionSchema Then
					DataCompositionSchemaName = AddDataProc.Metadata().Templates.Get(0).Name;
					DataCompositionSchemaValue = AddDataProc.GetTemplate(DataCompositionSchemaName);
					FoundedArrayItem = DataCompositionSchemaValueArray.Find(DataCompositionSchemaName);
					If FoundedArrayItem = Undefined Then
						DataCompositionSchemaValueArray.Add(DataCompositionSchemaName);
					EndIf;
				EndIf;
			EndDo;
		EndIf;
	EndIf;

	Items.DataSchemeSource.ChoiceList.LoadValues(DataCompositionSchemaValueArray);

	ThisObject.TemplateSpreadsheet = TemplateSpreadsheetValue;
	SetAvailableFields(DataCompositionSchemaValue);
EndProcedure

#EndRegion
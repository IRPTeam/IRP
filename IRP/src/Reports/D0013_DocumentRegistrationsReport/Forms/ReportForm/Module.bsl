
#Region FormEvent

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Document = Parameters.Document;		
	DocumentRegisterRecords = Parameters.Document.Metadata().RegisterRecords;
	For Each RegisterRecord In DocumentRegisterRecords Do
		Items.FilterRegister.ChoiceList.Add(RegisterRecord.FullName(), RegisterRecord.Synonym);
	EndDo;

	Items.FilterRegister.ChoiceList.SortByPresentation();
	ThisObject.GenerateOnOpen = Parameters.GenerateOnOpen;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If ThisObject.GenerateOnOpen Then
		GenerateReportAtServer(ThisObject.ResultTable);
	EndIf;
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure GenerateReport(Command)
	ResultTable = New SpreadsheetDocument();
	GenerateReportAtServer(ThisObject.ResultTable);
EndProcedure

#EndRegion

#Region ElementEvents

&AtClient
Procedure DocumentOnChange(Item)
	GenerateReportAtServer(ThisObject.ResultTable);
EndProcedure

&AtClient
Procedure ResultTableDetailProcessing(Item, Details, StandardProcessing, AdditionalParameters)
	If TypeOf(Details) = Type("String") And StrStartsWith(Details, "OpenForm/") Then
		StandardProcessing = False;
		Filter = New Structure("Filter", New Structure("Recorder", Document));
		OpenForm(StrSplit(Details, "/")[1] + ".ListForm", Filter);
	EndIf;
EndProcedure

#EndRegion

#Region Service

&AtServer
Function CanBuildReport()
	If Not ValueIsFilled(ThisObject.Document) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_045);
		Return False;
	Else
		Return True;
	EndIf;
EndFunction

&AtServer
Function GetChequeBondTransactionItems(DocumentRef)
	Query = New Query();
	Query.Text =
		"SELECT
		|	ChequeBondTransactionItem.Ref
		|FROM
		|	Document.ChequeBondTransactionItem AS ChequeBondTransactionItem
		|WHERE
		|	ChequeBondTransactionItem.ChequeBondTransaction = &ChequeBondTransaction
		|	AND ChequeBondTransactionItem.Posted";
	Query.SetParameter("ChequeBondTransaction", DocumentRef);
	QueryResult = Query.Execute();
	Return QueryResult.Unload().UnloadColumn("Ref");
EndFunction

&AtServer
Function GetTechnicalRegisters()
	ArrayOfTechnicalRegisters = New Array();
	ArrayOfTechnicalRegisters.Add(Metadata.AccumulationRegisters.TM1010B_RowIDMovements);
	ArrayOfTechnicalRegisters.Add(Metadata.AccumulationRegisters.TM1010T_RowIDMovements);
	ArrayOfTechnicalRegisters.Add(Metadata.AccumulationRegisters.TM1020B_AdvancesKey);
	ArrayOfTechnicalRegisters.Add(Metadata.AccumulationRegisters.TM1030B_TransactionsKey);
	ArrayOfTechnicalRegisters.Add(Metadata.AccumulationRegisters.T1050T_AccountingQuantities);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T2010S_OffsetOfAdvances);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T2013S_OffsetOfAging);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T2014S_AdvancesInfo);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T2015S_TransactionsInfo);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T3010S_RowIDInfo);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6010S_BatchesInfo);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6020S_BatchKeysInfo);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6040S_BundleAmountValues);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6050S_ManualBundleAmountValues);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6060S_BatchCostAllocationInfo);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6070S_BatchRevenueAllocationInfo);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6080S_ReallocatedBatchesAmountValues);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6090S_CompositeBatchesAmountValues);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T6095S_WriteOffBatchesInfo);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T7010S_BillOfMaterials);
	ArrayOfTechnicalRegisters.Add(Metadata.InformationRegisters.T7051S_ProductionDurationDetails);
	Return ArrayOfTechnicalRegisters
EndFunction

#EndRegion

&AtServer
Procedure GenerateReportAtServer(Result)

	If Not CanBuildReport() Then
		Return;
	EndIf;

	Result.Clear();

	Template = Reports.D0013_DocumentRegistrationsReport.GetTemplate("Template");
	MainTitleArea = Template.GetArea("MainTitle");

	If TypeOf(ThisObject.Document) = Type("DocumentRef.ChequeBondTransaction") Then
		GenerateReportForOneDocument(ThisObject.Document, Result, Template, MainTitleArea);
		ArrayOfChequeBondTransactionItems = GetChequeBondTransactionItems(ThisObject.Document);
		MainTitleAreaLowSelection = Template.GetArea("MainTitleLowSelection");
		For Each ItemOfChequeBondTransactionItems In ArrayOfChequeBondTransactionItems Do
			GenerateReportForOneDocument(ItemOfChequeBondTransactionItems, Result, Template, MainTitleAreaLowSelection);
		EndDo;
	Else
		GenerateReportForOneDocument(ThisObject.Document, Result, Template, MainTitleArea);
	EndIf;
EndProcedure

// Generate report for one document.
// 
// Parameters:
//  DocumentRef - DocumentRefDocumentName - Document ref
//  Result - SpreadsheetDocument - Result
//  Template - SpreadsheetDocument - Template
//  MainTitleArea - SpreadsheetDocument - Main title area
&AtServer
Procedure GenerateReportForOneDocument(DocumentRef, Result, Template, MainTitleArea)
	Title = String(DocumentRef);
	MainTitleArea.Parameters.Document = String(DocumentRef);
	Result.Put(MainTitleArea);

	DocumentRegisterRecords = DocumentRef.Metadata().RegisterRecords; 

	TableOfDocumentRegisterRecords = New ValueTable();
	TableOfDocumentRegisterRecords.Columns.Add("RegisterRecord");
	TableOfDocumentRegisterRecords.Columns.Add("RegisterRecordPresentation");
	For Each RegisterRecord In DocumentRegisterRecords Do
		NewRow = TableOfDocumentRegisterRecords.Add();
		NewRow.RegisterRecord = RegisterRecord;
		NewRow.RegisterRecordPresentation = RegisterRecord.Synonym;
	EndDo;
	TableOfDocumentRegisterRecords.Sort("RegisterRecordPresentation");

	FilterRegisterMeta = Undefined;
	If Not IsBlankString(ThisObject.FilterRegister) Then
		FilterRegisterMeta = Metadata.FindByFullName(ThisObject.FilterRegister);
	EndIf;

	ArrayOfDocumentRegisterRecords = New Array(); // Array Of MetadataObject
	For Each Row In TableOfDocumentRegisterRecords Do
		
		If Not AccessRight("Read", Row.RegisterRecord) Then
			Continue;
		EndIf;
		
		If Not FilterRegisterMeta = Undefined Then
			If Row.RegisterRecord = FilterRegisterMeta Then
				ArrayOfDocumentRegisterRecords.Add(Row.RegisterRecord);
			EndIf;
		Else
			ArrayOfDocumentRegisterRecords.Add(Row.RegisterRecord);
		EndIf;
	EndDo;

	RegisterNumber = -1;

	ArrayOfTechnicalRegisters = GetTechnicalRegisters();
	
	For Each ObjectProperty In ArrayOfDocumentRegisterRecords Do

		RegisterName = ObjectProperty.FullName();

		If ThisObject.HideTechnicalRegisters And ArrayOfTechnicalRegisters.Find(ObjectProperty) <> Undefined Then
			Continue;
		EndIf;

		RegisterNumber = RegisterNumber + 1;

		ReportBuilder = New ReportBuilder();
		
		FieldPresentations = New Structure();
		ArrayOfFields = New Array();

		FieldPresentations.Insert("ItemKeyItem", Metadata.Catalogs.Items.ObjectPresentation);
		
		ListOfResources = GetListOfFields(ObjectProperty.Resources, FieldPresentations, New Array);
		ListOfDimensions = GetListOfFields(ObjectProperty.Dimensions, FieldPresentations, New Array);
		ListOfAttributes = GetListOfFields(ObjectProperty.Attributes, FieldPresentations, New Array);
		ListOfStandardAttributes = GetListOfFields(ObjectProperty.StandardAttributes, FieldPresentations, GetIgnoreList());

		ArrayOfFields.Add(New Structure("ListOfFields, ColumnName", ListOfStandardAttributes, "StandardAttributes"));
		ArrayOfFields.Add(New Structure("ListOfFields, ColumnName", ListOfDimensions, "Dimensions"));
		ArrayOfFields.Add(New Structure("ListOfFields, ColumnName", ListOfResources, "Resources"));
		ArrayOfFields.Add(New Structure("ListOfFields, ColumnName", ListOfAttributes, "Attributes"));

		PutDataProcessing(DocumentRef, ArrayOfFields, FieldPresentations, ReportBuilder, ObjectProperty);
		
		SetConditionalAppearance(ReportBuilder);
		
		If ReportBuilder.GetQuery().Execute().IsEmpty() Then
			Continue;
		EndIf;

		ReportBuilder.PutReportFooter = True;
		ReportBuilder.PutOveralls = False;
		ReportBuilder.PutTableFooter = False;
		ReportBuilder.PutReportHeader = False;
		ReportBuilder.DetailFillType = ReportBuilderDetailsFillType.Details;
		ReportBuilder.PutDetailRecords = True; 
		ReportBuilder.PutTableHeader = True; 
	
		Template = Reports.D0013_DocumentRegistrationsReport.GetTemplate("Template");
		TitleArea = Template.GetArea("Title");
		TitleArea.Parameters.RegisterName = ObjectProperty.Synonym;
		TitleArea.Areas.Title.DetailsUse = SpreadsheetDocumentDetailUse.Cell;
		TitleArea.Area(1, 1).Details = "OpenForm/" + RegisterName;
		Result.Put(TitleArea);
		Result.StartRowGroup();
		Template = New SpreadsheetDocument();
		ReportBuilder.Put(Template);
		
		Line1 = New Line(SpreadsheetDocumentCellLineType.Solid, 1);
		For W = 2 To Template.TableWidth Do
			For H = 1 To Template.TableHeight - 1 Do
				Area = Template.Area(H, W, H, W);
				Area.Outline(Line1, Line1, Line1, Line1);
			EndDo;
			If Area.ColumnWidth > 60 Then
				Area.ColumnWidth = 60;
			EndIf;
		EndDo;
		
		If ShowItemInItemKey And Not ReportBuilder.SelectedFields.Find("ItemKeyItem") = Undefined Then
			Area = Template.FindText("ItemKeyItem");
			If Not Area = Undefined Then
				Area.Text = FieldPresentations.ItemKeyItem;
			EndIf;
		EndIf;
		
		Result.Join(Template);
		Result.EndRowGroup();
	EndDo;
EndProcedure

&AtServer
Function GetIgnoreList()
	IgnoreList = New Array;
	IgnoreList.Add("Active");
	IgnoreList.Add("LineNumber");
	IgnoreList.Add("Recorder");
	Return IgnoreList;
EndFunction

&AtServer
Procedure SetConditionalAppearance(ReportBuilder)
	If Not ReportBuilder.SelectedFields.Find("RecordType") = Undefined Then
		Appearance = ReportBuilder.ConditionalAppearance.Add("ColorRecordTypeExpense");
		Appearance.Use = True;
		Appearance.Area.Add("RecordType", "RecordType", AppearanceAreaType.Field);
		Filter = Appearance.Filter.Add("RecordType");
		Filter.Value = AccumulationRecordType.Expense;
		Appearance.Appearance.TextColor.Value = WebColors.Red;
		Appearance.Appearance.TextColor.Use = True;
		
		Appearance = ReportBuilder.ConditionalAppearance.Add("ColorRecordTypeReceipt");
		Appearance.Use = True;
		Filter = Appearance.Filter.Add("RecordType");
		Filter.Value = AccumulationRecordType.Receipt;
		Appearance.Area.Add("RecordType");
		Appearance.Appearance.TextColor.Value = WebColors.Green;
		Appearance.Appearance.TextColor.Use = True;
	EndIf;
EndProcedure

&AtServer
Function GetListOfFields(ObjectMetadata, FieldsPresentations, IgnoreFields)
	ListOfFields = New Array;
	For Each Row In ObjectMetadata Do
		If Not IgnoreFields.Find(Row.Name) = Undefined Then
			Continue;
		EndIf;
		
		ListOfFields.Add(Row.Name);
		FieldsPresentations.Insert(Row.Name, Row.Synonym);
	EndDo;
	Return ListOfFields;
EndFunction

&AtServer
Function GetListOfFieldsByData(Data)
	ListOfFields = New Array;
	For Each Row In Data Do
		For Each El In Row.ListOfFields Do
			ListOfFields.Add(El);
		EndDo;
	EndDo;

	If ShowItemInItemKey And Not ListOfFields.Find("ItemKey") = Undefined Then
		ListOfFields.Insert(ListOfFields.Find("ItemKey"), "ItemKey.Item");
	EndIf;
	
	PeriodOrder = ListOfFields.Find("Period");
	If Not PeriodOrder = Undefined And PeriodOrder > 0 Then
		ListOfFields.Delete(PeriodOrder);
		ListOfFields.Insert(0, "Period");
	EndIf;
	
	Return ListOfFields;
EndFunction

&AtServer
Procedure PutDataProcessing(DocumentRef, ArrayOfFields,	FieldPresentations, ReportBuilder, ObjectProperty)

	If Not ArrayOfFields.Count() Then
		Return;
	EndIf;

	FilterByTransactionCurrency = ObjectProperty.Dimensions.Find("CurrencyMovementType") <> Undefined And ThisObject.OnlyTransactionCurrency;

	If Not ValueIsFilled(ReportBuilder.Text) Then
		ListOfFields = StrConcat(GetListOfFieldsByData(ArrayOfFields), ",");
		Text = 
			"SELECT ALLOWED %1
			|{SELECT %1}
			|FROM %2 
			|WHERE Recorder = &Recorder 
			|%3
			|ORDER BY %1";
			
		FilterByTransaction = ?(FilterByTransactionCurrency, "AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)" ,"");
		ReportBuilder.Text = StrTemplate(Text, ListOfFields, ObjectProperty.FullName(), FilterByTransaction);
		ReportBuilder.Parameters.Insert("Recorder", DocumentRef);
	EndIf;

	FillFieldPresentations(ReportBuilder, FieldPresentations);

EndProcedure

&AtServer
Procedure FillFieldPresentations(ReportBuilder, FieldPresentations)
	CollectionOfReportBuilder = StrSplit("AvailableFields, SelectedFields, ColumnDimensions, RowDimensions, Filter", ", ", False);
	For Each Row In CollectionOfReportBuilder Do
		For i = 0 To ReportBuilder[Row].Count() - 1 Do
			If Not ValueIsFilled(ReportBuilder[Row][i].Name) Then
				Continue;
			EndIf;
			If FieldPresentations.Property(ReportBuilder[Row][i].Name) Then
				ReportBuilder[Row][i].Presentation = FieldPresentations[ReportBuilder[Row][i].Name];
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure EditMovements(Command)
	
	FormParameters = New Structure("DocRef", Document);
	OpenForm("DataProcessor.EditDocumentsMovements.Form", FormParameters);
	
EndProcedure

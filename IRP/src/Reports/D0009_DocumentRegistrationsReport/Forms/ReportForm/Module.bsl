&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("Document") Then
		ThisObject.Document = Parameters.Document;		
		DocumentRegisterRecords = Parameters.Document.Metadata().RegisterRecords;
		For Each RegisterRecord In DocumentRegisterRecords Do
			Items.FilterRegister.ChoiceList.Add(RegisterRecord.FullName(), RegisterRecord.Synonym);
		EndDo;
	EndIf;

	Items.FilterRegister.ChoiceList.SortByPresentation();

	If Parameters.Property("PutInTable") Then
		ThisObject.PutInTable = Parameters.PutInTable;
	EndIf;
	
	Parameters.Property("GenerateOnOpen", ThisObject.GenerateOnOpen);
EndProcedure

&AtClient
Procedure DocumentOnChange(Item)
	GenerateReportAtServer(ThisObject.ResultTable);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If ThisObject.GenerateOnOpen Then
		GenerateReportAtServer(ThisObject.ResultTable);
	EndIf;
EndProcedure

&AtClient
Procedure GenerateReport(Command)
	GenerateReportAtServer(ThisObject.ResultTable);
EndProcedure

&AtServer
Function GetRegisterType(ObjectMetadata)
	If Metadata.AccumulationRegisters.IndexOf(ObjectMetadata) >= 0 Then
		Return "AccumulationRegister";
	ElsIf Metadata.InformationRegisters.IndexOf(ObjectMetadata) >= 0 Then
		Return "InformationRegister";
	Else
		Return "";
	EndIf;
EndFunction

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
Procedure GenerateReportAtServer(Result)

	If Not CanBuildReport() Then
		Return;
	EndIf;

	Result.Clear();

	Template = Reports.D0009_DocumentRegistrationsReport.GetTemplate("Template");
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
		NewRow.RegisterRecordPresentation = String(RegisterRecord);
	EndDo;
	TableOfDocumentRegisterRecords.Sort("RegisterRecordPresentation");

	ArrayOfDocumentRegisterRecords = New Array();
	For Each Row In TableOfDocumentRegisterRecords Do
		If ValueIsFilled(ThisObject.FilterRegister) Then
			If Upper(Row.RegisterRecord.FullName()) = Upper(ThisObject.FilterRegister) Then
				ArrayOfDocumentRegisterRecords.Add(Row.RegisterRecord);
			EndIf;
		Else
			ArrayOfDocumentRegisterRecords.Add(Row.RegisterRecord);
		EndIf;
	EndDo;

	RegisterNumber = -1;

	TableOfRegistrations = GetTableRegistrations(ArrayOfDocumentRegisterRecords, DocumentRef);

	For Each Row In TableOfRegistrations Do
		Row.Name = Upper(TrimAll(Row.Name));
	EndDo;

	ArrayOfTechnicalRegisters = New Array();
	ArrayOfTechnicalRegisters.Add(Upper("TM1010B_RowIDMovements"));
	ArrayOfTechnicalRegisters.Add(Upper("TM1010T_RowIDMovements"));
	ArrayOfTechnicalRegisters.Add(Upper("TM1020B_AdvancesKey"));
	ArrayOfTechnicalRegisters.Add(Upper("TM1030B_TransactionsKey"));
	
	ArrayOfTechnicalRegisters.Add(Upper("T1050T_AccountingQuantities"));
	
	ArrayOfTechnicalRegisters.Add(Upper("T2010S_OffsetOfAdvances"));
	ArrayOfTechnicalRegisters.Add(Upper("T2013S_OffsetOfAging"));
	ArrayOfTechnicalRegisters.Add(Upper("T2014S_AdvancesInfo"));
	ArrayOfTechnicalRegisters.Add(Upper("T2015S_TransactionsInfo"));

	ArrayOfTechnicalRegisters.Add(Upper("T3010S_RowIDInfo"));
	ArrayOfTechnicalRegisters.Add(Upper("T6010S_BatchesInfo"));
	ArrayOfTechnicalRegisters.Add(Upper("T6020S_BatchKeysInfo"));
	ArrayOfTechnicalRegisters.Add(Upper("T6040S_BundleAmountValues"));
	ArrayOfTechnicalRegisters.Add(Upper("T6050S_ManualBundleAmountValues"));
	ArrayOfTechnicalRegisters.Add(Upper("T6060S_BatchCostAllocationInfo"));
	ArrayOfTechnicalRegisters.Add(Upper("T6070S_BatchRevenueAllocationInfo"));
	ArrayOfTechnicalRegisters.Add(Upper("T6080S_ReallocatedBatchesAmountValues"));
	ArrayOfTechnicalRegisters.Add(Upper("T6090S_CompositeBatchesAmountValues"));
	ArrayOfTechnicalRegisters.Add(Upper("T6095S_WriteOffBatchesInfo"));
	ArrayOfTechnicalRegisters.Add(Upper("T7010S_BillOfMaterials"));
	ArrayOfTechnicalRegisters.Add(Upper("T7051S_ProductionDurationDetails"));
	
	For Each ObjectProperty In ArrayOfDocumentRegisterRecords Do

		RegisterName = ObjectProperty.FullName();

		If TableOfRegistrations.Find(Upper(RegisterName), "Name") = Undefined Then
			Continue;
		EndIf;

		If ThisObject.HideTechnicalRegisters And ArrayOfTechnicalRegisters.Find(Upper(StrSplit(RegisterName, ".")[1])) <> Undefined Then
			Continue;
		EndIf;

		If Not AccessRight("Read", ObjectProperty) Then
			Continue;
		EndIf;

		RegisterNumber = RegisterNumber + 1;

		ReportBuilder = New ReportBuilder();
		FieldPresentations = New Structure();
		ArrayOfFields = New Array();

		RegisterType = GetRegisterType(ObjectProperty);

		PutExpenseReceipt = False;
		StringExpenseReceipt = "";
		StringPeriod = "";
		If RegisterType = "InformationRegister" Or RegisterType = "AccumulationRegister" Then
			If RegisterType = "AccumulationRegister" 
			And ObjectProperty.RegisterType = Metadata.ObjectProperties.AccumulationRegisterType.Balance Then

				StringExpenseReceipt = ", RecordType";
				FieldPresentations.Insert("RecordType", "Record type");
				PutExpenseReceipt = True;

			EndIf;
			
			For Each StandardAttr In ObjectProperty.StandardAttributes Do
				If Upper(StandardAttr.Name) = Upper("Period") Then
					StringPeriod = ", Period";
					FieldPresentations.Insert("Period", "Period");
					Break;
				EndIf;
			EndDo;

			ListOfResources = GetListOfFields(ObjectProperty.Resources, FieldPresentations);
			ListOfDimensions = GetListOfFields(ObjectProperty.Dimensions, FieldPresentations);
			ListOfAttributes = GetListOfFields(ObjectProperty.Attributes, FieldPresentations);

			AddDataToArrayOfFields(ArrayOfFields, New Structure("ListOfFields, Width", StringExpenseReceipt, 10));
			AddDataToArrayOfFields(ArrayOfFields, New Structure("ListOfFields, Width", StringPeriod, 15));
			AddDataToArrayOfFields(ArrayOfFields, New Structure("ListOfFields, ColumnName, Width", ListOfResources, "Resources", 30));
			AddDataToArrayOfFields(ArrayOfFields, New Structure("ListOfFields, ColumnName, Width", ListOfDimensions, "Dimensions", 40));
			AddDataToArrayOfFields(ArrayOfFields, New Structure("ListOfFields, ColumnName, Width", ListOfAttributes, "Attributes", 20));

			FilterByTransactionCurrency = ObjectProperty.Dimensions.Find("CurrencyMovementType") <> Undefined
				And ThisObject.OnlyTransactionCurrency;

			PutDataProcessing(DocumentRef, 
				ArrayOfFields, 
				FieldPresentations, 
				ReportBuilder, 
				FilterByTransactionCurrency,
				ObjectProperty.FullName(), 
				ThisObject.PutInTable);
		Else
			Continue;
		EndIf;

		If ReportBuilder.GetQuery().Execute().IsEmpty() Then
			Continue;
		EndIf;

		ReportBuilder.PutReportFooter = True;
		ReportBuilder.PutOveralls = False;
		ReportBuilder.PutTableFooter = False;
		ReportBuilder.PutReportHeader = False;

		Template = Reports.D0009_DocumentRegistrationsReport.GetTemplate("Template");
		TitleArea = Template.GetArea("Title");
		TitleArea.Parameters.RegisterName = ObjectProperty.Synonym;
		TitleArea.Areas.Title.DetailsUse = SpreadsheetDocumentDetailUse.Cell;
		TitleArea.Area(1, 1).Details = RegisterName;
		Result.Put(TitleArea);
		Result.StartRowGroup();

		If PutExpenseReceipt Then
			PutRowNumber = Result.TableHeight;
		EndIf;

		ReportBuilder.Put(Result);

		If PutExpenseReceipt Then
			CurrentRowNumber = Result.TableHeight;
			For RowNumber = PutRowNumber + 2 To CurrentRowNumber - 1 Do
				PutArea = Result.Area(RowNumber, 2);
				If PutArea.Text = "Expense" Then
					PutArea.TextColor = WebColors.Red;
				ElsIf PutArea.Text = "Receipt" Then
					PutArea.TextColor = WebColors.Green;
				Else
					PutArea.TextColor = WebColors.Black;
				EndIf;
			EndDo;
		EndIf;

		Result.EndRowGroup();

	EndDo;

	Result.ShowGroups = True;
	Result.ShowHeaders = False;
	Result.ShowGrid = False;
	Result.ReadOnly = True;
	Result.FitToPage = True;

EndProcedure

&AtClient
Procedure ResultTableDetailProcessing(Item, Details, StandardProcessing, AdditionalParameters)
	If ValueIsFilled(Details) Then
		StandardProcessing = False;
		OpenForm(Details + ".ListForm");
	EndIf;
EndProcedure

&AtServer
Procedure AddDataToArrayOfFields(ArrayOfFields, Data)
	If ValueIsFilled(Data.ListOfFields) Then
		ArrayOfFields.Add(Data);
	EndIf;
EndProcedure

&AtServer
Function GetListOfFields(ObjectMetadata, FildsPresentations)
	ListOfFields = "";
	For Each Row In ObjectMetadata Do
		ListOfFields = ListOfFields + ", " + Row.Name;
		FildsPresentations.Insert(Row.Name, Row.Synonym);
	EndDo;
	Return ListOfFields;
EndFunction

&AtServer
Function GetListOfFieldsByData(Data)
	ListOfFields = "";
	For Each Row In Data Do
		ListOfFields = ListOfFields + Row.ListOfFields;
	EndDo;

	If ValueIsFilled(ListOfFields) Then
		ListOfFields = Mid(ListOfFields, 2);
	EndIf;

	If ShowItemInItemKey Then
		ListOfFields = StrReplace(ListOfFields, " ItemKey", "ItemKey.Item, ItemKey");
	EndIf;
	Return ListOfFields;
EndFunction

&AtServer
Procedure PutDataProcessing(DocumentRef, 
							ArrayOfFields, 
							FieldPresentations, 
							ReportBuilder, 
							FilterByTransactionCurrency,
							Val RegisterName, 
							Val PutInTable = False)

	If Not ArrayOfFields.Count() Then
		Return;
	EndIf;

	If Not ValueIsFilled(ReportBuilder.Text) Then
		ListOfFields = GetListOfFieldsByData(ArrayOfFields);
		ReportBuilder.Text = 
			"SELECT ALLOWED " + ListOfFields + "
			|{SELECT " + ListOfFields + "}
			|FROM " + RegisterName + " AS reg
			|WHERE reg.Recorder = &Recorder " 
			+ ?(FilterByTransactionCurrency,
			" AND reg.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)" ,"") + "
			|ORDER BY " + ListOfFields;
		ReportBuilder.Parameters.Insert("Recorder", DocumentRef);
	EndIf;

	FillFieldPresentations(FieldPresentations, ReportBuilder);

	TemplateDetails = ReportBuilder.Template.GetArea("Details");
	TemplateHeader = ReportBuilder.Template.GetArea("TableHeader");

	TemplateHeight = 0;
	CountRowToHeader = 0;

	For Each Row In ArrayOfFields Do

		Row.Insert("ColumnNumber", 0);

		If ValueIsFilled(Row.ListOfFields) Then

			Row.Insert("RowCount", 1);

			ColumnName = "";
			If Not Row.Property("ColumnName", ColumnName) Then
				ColumnName = "";
			Else
				CountRowToHeader = 1;
			EndIf;
			PrepareTemplateDetails(Row.ListOfFields, TemplateDetails, TemplateHeader, Row.ColumnNumber, Row.RowCount,
				ColumnName, PutInTable);
			TemplateHeight = Max(TemplateHeight, Row.RowCount);
		EndIf;
	EndDo;

	PrepareTemplateForOutput(TemplateDetails, TemplateHeader, TemplateHeight, CountRowToHeader);

	If Not PutInTable Then

		NumberOfCurrentColumn = 2;

		For Each Row In ArrayOfFields Do
			If Row.ColumnNumber > 0 Then
				OutlineOutputArea(TemplateDetails, TemplateHeader, TemplateHeight, Row.Width, NumberOfCurrentColumn);

				NumberOfCurrentColumn = NumberOfCurrentColumn + 1;
			EndIf;
		EndDo;
	Else
		TotalFieldsForOutput = ReportBuilder.AvailableFields.Count();
		CurrentWidth = -1;
		CurrentIndexOfArray = -1;

		For NumberOfCurrentColumn = 0 To TotalFieldsForOutput - 1 Do
			If CurrentIndexOfArray <= ArrayOfFields.Count() - 2 Then

				NumberNextColumn = ArrayOfFields[CurrentIndexOfArray + 1].ColumnNumber - 2;

				If NumberNextColumn <= NumberOfCurrentColumn Then
					CurrentIndexOfArray = CurrentIndexOfArray + 1;
					CurrentWidth = ArrayOfFields[CurrentIndexOfArray].Width;

					ColumnName = "";
					If ArrayOfFields[CurrentIndexOfArray].Property("ColumnName", ColumnName) Then

						If CurrentIndexOfArray <= ArrayOfFields.Count() - 2 Then
							NumberLastColumn = ArrayOfFields[CurrentIndexOfArray + 1].ColumnNumber - 2;
						Else
							NumberLastColumn = TotalFieldsForOutput;
						EndIf;

						For NumberTempColumn = NumberOfCurrentColumn To NumberLastColumn - 1 Do
							AddTitleToColumn(TemplateHeader, NumberTempColumn + 2, ColumnName);
						EndDo;

						Area = TemplateHeader.Area(1, NumberOfCurrentColumn + 2, 1, NumberLastColumn + 1);
						Area.Merge();

					EndIf;
				EndIf;
			EndIf;
			OutlineOutputArea(TemplateDetails, TemplateHeader, TemplateHeight, CurrentWidth, NumberOfCurrentColumn + 2);
		EndDo;
	EndIf;

	AreaDetails = TemplateDetails.GetArea("Details");
	AreaHeader = TemplateHeader.GetArea("TableHeader");

	ReportBuilder.DetailRecordsTemplate = AreaDetails;
	ReportBuilder.TableHeaderTemplate = AreaHeader;
EndProcedure

&AtServer
Procedure PrepareTemplateForOutput(TemplateDetails, TemplateHeader, TemplateHeight, Val AddCounter = 0)

	TemplateDetails.Area("Details").Name = "";
	TemplateDetails.Area(1, , TemplateHeight).Name = "Details";
	TemplateDetails.Area(1, , TemplateHeight).ColumnWidth = 20;
	TemplateDetails.Area(1, 1, TemplateHeight, 1).ColumnWidth = 2;

	TemplateHeader.Area("TableHeader").Name = "";
	TemplateHeader.Area(1, , TemplateHeight + AddCounter).Name = "TableHeader";
	TemplateHeader.Area(1, , TemplateHeight + AddCounter).ColumnWidth = 20;
	TemplateHeader.Area(1, 1, TemplateHeight + AddCounter, 1).ColumnWidth = 2;

EndProcedure

&AtServer
Procedure OutlineOutputArea(TemplateDetails, TemplateHeader, Val TemplateHeight, Val ColumnWidth, Val ColumnNumber)

	Line1 = New Line(SpreadsheetDocumentCellLineType.Solid, 1);
	Line2 = New Line(SpreadsheetDocumentCellLineType.Solid, 2);

	AreaDetails = TemplateDetails.Area(1, ColumnNumber, TemplateHeight, ColumnNumber);
	AreaHeader = TemplateHeader.Area(1, ColumnNumber, TemplateHeight + 1, ColumnNumber);

	AreaDetails.ColumnWidth = ColumnWidth;
	AreaDetails.Outline(Line1, Line1, Line1, Line1);

	AreaHeader.ColumnWidth = ColumnWidth;
	AreaHeader.Outline(Line2, Line2, Line2, Line2);

EndProcedure

&AtServer
Procedure AddTitleToColumn(TemplateHeader, Val ColumnNumber, Val TitleString)
	TemplateHeader.InsertArea(TemplateHeader.Area(TemplateHeader.Area("TableHeader").Top, ColumnNumber),
		TemplateHeader.Area(TemplateHeader.Area("TableHeader").Top, ColumnNumber),
		SpreadsheetDocumentShiftType.Vertical, False);

	TemplateHeader.InsertArea(TemplateHeader.Area(TemplateHeader.Area("TableHeader").Top, ColumnNumber),
		TemplateHeader.Area(TemplateHeader.Area("TableHeader").Top + 1, ColumnNumber),
		SpreadsheetDocumentShiftType.WithoutShift, False);

	TemplateHeaderTitle = TemplateHeader.Area(TemplateHeader.Area("TableHeader").Top, ColumnNumber);
	TemplateHeaderTitle.Text = TitleString;
	TemplateHeaderTitle.HorizontalAlign = HorizontalAlign.Center;
EndProcedure

&AtServer
Procedure PrepareTemplateDetails(ListOfFields, TemplateDetails, TemplateHeader, ColumnNumber, RowNumber,
	Val ColumnName = "", Val PutInTable = False)

	If Not PutInTable Then
		ColumnNumber = 0;

		ColumnIndex = 2;

		RowNumberHeader = RowNumber;
		ParameterName = TemplateDetails.Area(TemplateDetails.Area("Details").Top, ColumnIndex).Parameter;

		While ValueIsFilled(ParameterName) Do

			If StrFind(ListOfFields + ",", " " + ParameterName + ",") > 0 Then

				If ColumnNumber = 0 Then

					ColumnNumber = ColumnIndex;

					If ValueIsFilled(ColumnName) Then

						AddTitleToColumn(TemplateHeader, ColumnIndex, ColumnName);
						RowNumberHeader = RowNumberHeader + 1;

					EndIf;
				Else

					TemplateDetails.InsertArea(TemplateDetails.Area(TemplateDetails.Area("Details").Top, ColumnIndex),
						TemplateDetails.Area(TemplateDetails.Area("Details").Top + RowNumber, ColumnNumber),
						SpreadsheetDocumentShiftType.Vertical, False);

					TemplateHeader.InsertArea(TemplateHeader.Area(TemplateHeader.Area("TableHeader").Top, ColumnIndex),
						TemplateHeader.Area(TemplateHeader.Area("TableHeader").Top + RowNumberHeader, ColumnNumber),
						SpreadsheetDocumentShiftType.Vertical, False);

					RowNumber = RowNumber + 1;
					RowNumberHeader = RowNumberHeader + 1;

					For i = TemplateDetails.Area("Details").Top To TemplateDetails.Area("Details").Bottom + 8 Do
						TemplateDetails.DeleteArea(TemplateDetails.Area(i, ColumnIndex),
							SpreadsheetDocumentShiftType.Horizontal);
						TemplateHeader.DeleteArea(TemplateHeader.Area(i, ColumnIndex),
							SpreadsheetDocumentShiftType.Horizontal);
					EndDo;

					ColumnIndex = ColumnIndex - 1;

				EndIf;

			EndIf;

			ColumnIndex = ColumnIndex + 1;
			ParameterName = TemplateDetails.Area(TemplateDetails.Area("Details").Top, ColumnIndex).Parameter;

		EndDo;

	Else

		ColumnIndex = 2;

		ParameterName = TemplateDetails.Area(TemplateDetails.Area("Details").Top, ColumnIndex).Parameter;

		While ValueIsFilled(ParameterName) Do

			If StrFind(ListOfFields + ",", " " + ParameterName + ",") > 0 Then

				If ColumnNumber = 0 Then
					ColumnNumber = ColumnIndex;
				EndIf;

			EndIf;

			ColumnIndex = ColumnIndex + 1;
			ParameterName = TemplateDetails.Area(TemplateDetails.Area("Details").Top, ColumnIndex).Parameter;

		EndDo;

	EndIf;

EndProcedure

&AtServer
Function GetTableRegistrations(ArrayOfDocumentRegisterRecords, DocumentRef)
	QueryText = "";

	If Not ArrayOfDocumentRegisterRecords.Count() Then
		Return New ValueTable();
	EndIf;

	For Each Row In ArrayOfDocumentRegisterRecords Do		
		QueryText = QueryText + "
		|" + ?(QueryText = "", "", "UNION ALL ") + "
		|SELECT TOP 1 CAST(""" + Row.FullName() + """ AS STRING(200)) AS Name 
		|FROM " + Row.FullName() + "
		|WHERE Recorder = &Recorder";
	EndDo;

	Query = New Query(QueryText);
	Query.SetParameter("Recorder", DocumentRef);
	Return Query.Execute().Unload();
EndFunction

&AtServer
Procedure FillFieldPresentations(FieldPresentations, ReportBuilder)
	CollectionOfReportBuilder = New Structure("AvailableFields, SelectedFields, ColumnDimensions, RowDimensions, Filter");
	For Each Row In CollectionOfReportBuilder Do
		For i = 0 To ReportBuilder[Row.Key].Count() - 1 Do
			If Not ValueIsFilled(ReportBuilder[Row.Key][i].Name) Then
				Continue;
			EndIf;
			If FieldPresentations.Property(ReportBuilder[Row.Key][i].Name) Then
				ReportBuilder[Row.Key][i].Presentation = FieldPresentations[ReportBuilder[Row.Key][i].Name];
			EndIf;
		EndDo;
	EndDo;
EndProcedure
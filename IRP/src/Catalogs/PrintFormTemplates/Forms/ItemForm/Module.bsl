
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	SetVisibilityAvailability(Object, ThisObject);
	
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);

EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	
	SetVisibilityAvailability(Object, ThisObject);
	
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	
	SetVisibilityAvailability(Object, ThisObject);
	
	LoadTemplateData();
	LoadObjectsForPrinting();
	
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	
	RepeatingAreas = New Array;
	For Each TableRow In Object.Tables Do
		If TableRow.RepeatingArea Then
			TableIndex = Object.Tables.IndexOf(TableRow);
			RepeatingAreas.Add(TableRow);
			If TableRow.LineStart = 0 Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					R().S_027, "Object.Tables[" + Format(TableIndex, "NG=") + "].LineStart", "Object");
			EndIf;
			If TableRow.LineEnd = 0 Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					R().S_027, "Object.Tables[" + Format(TableIndex, "NG=") + "].LineEnd", "Object");
			EndIf;
			If TableRow.LineEnd < TableRow.LineStart Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					R().Exc_014, "Object.Tables[" + Format(TableIndex, "NG=") + "].LineEnd", "Object");
			EndIf;
		EndIf;
	EndDo;
	
	RepeatingAreaTable = Object.Tables.Unload(RepeatingAreas);
	RepeatingAreaTable.Sort("LineStart");
	For Each TableRow In RepeatingAreaTable Do
		TableIndex = RepeatingAreaTable.IndexOf(TableRow);
		If TableIndex > 0 And TableRow.LineStart <= RepeatingAreaTable[TableIndex].LineEnd Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
				R().Exc_015, "Object.Tables", "Object");
		EndIf;
	EndDo;
	
	If Cancel = True Then
		Return;
	EndIf;

	SaveTemplateData(CurrentObject);
	
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	
	SaveObjectsForPrinting(CurrentObject);
	
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	
	If EventName = "FormulaIsReady" Then
		
		If Source = "_PrintInfoPath" Then
			
			Object.PrintInfoPath = Parameter;
			
		ElsIf Items.DataPages.CurrentPage = Items.PageTables Then
			
			CurrentRow = Items.Tables.CurrentData;
			If CurrentRow = Undefined Then
				Return;
			Else
				CurrentRow.Expression = Parameter;
			EndIf;
			
		ElsIf Items.DataPages.CurrentPage = Items.PageParameters Then
			
			CurrentRow = Items.Parameters.CurrentData;
			If CurrentRow = Undefined Then
				Return;
			Else
				CurrentRow.Expression = Parameter;
			EndIf;
			
		EndIf;
		
	EndIf;
	
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure UseTablesOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure UsePrintInformationsOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure PrintFormTypeOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure PrintFormVariableTypeOnChange(Item)
	RefreshParameters(Undefined);
EndProcedure

&AtClient
Procedure LimitedAccessOnChange(Item)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlersParameters

&AtClient
Procedure ParametersExpressionOpening(Item, StandardProcessing)
	StandardProcessing = False;
	OpenExpressionParameter(Undefined);
EndProcedure

&AtClient
Procedure TablesExpressionOpening(Item, StandardProcessing)
	StandardProcessing = False;
	OpenExpressionTable(Undefined);
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure LoadFromFile(Command)
	
	Dialog = New FileDialog(FileDialogMode.Open);
	Dialog.CheckFileExist = True;
	Dialog.Multiselect = False;
	
	Dialog.Show(New CallbackDescription("LoadFromFileEnd", ThisObject));

EndProcedure

&AtClient
Procedure EditTemplate(Command)
	EditingMode = True;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure SaveTemplate(Command)
	EditingMode = False;
	Modified = True;
	RefreshParameters(Undefined);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure RefreshParameters(Command)
	If Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.TXT") Then
		ExpractParametersFromTemplateTXT();
	ElsIf  Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.MXL") Then
		ExpractParametersFromTemplateMXL();
	ElsIf  Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.FormattedText") Then
		ExpractParametersFromTemplateFormattedText();
	EndIf;
EndProcedure

&AtClient
Procedure OpenExpressionParameter(Command)
	
	CurrentRow = Items.Parameters.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	TableData = New Map;
	For Each TableRow In Object.Tables Do
		TableData.Insert(TableRow.Name, TableRow.Expression);
	EndDo;
	
	OpenForm("Catalog.PrintFormTemplates.Form.FormulaEditingParameter", 
		New Structure("Name, Table, Expression, TableData", 
			CurrentRow.Name, CurrentRow.Table, CurrentRow.Expression, TableData), 
		ThisObject, ,,,, FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtClient
Procedure OpenExpressionTable(Command)
	
	CurrentRow = Items.Tables.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	OpenForm("Catalog.PrintFormTemplates.Form.FormulaEditingTable", 
		New Structure("Name, Expression", CurrentRow.Name, CurrentRow.Expression), 
		ThisObject, ,,,, FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtClient
Procedure DeleteNotUsed(Command)
	OldParameters = Object.Parameters.FindRows(New Structure("ToDelete", True));
	For Each OldParameter In OldParameters Do
		Object.Parameters.Delete(OldParameter);
	EndDo;
EndProcedure

&AtClient
Procedure AddToTable(Command)
	
	CurrentRow = Items.Parameters.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	UsedTables = New Array;
	ExistingRows = Object.Parameters.FindRows(New Structure("Name", CurrentRow.Name));
	For Each ExistingRow In ExistingRows Do
		UsedTables.Add(ExistingRow.Table);
	EndDo;
	
	AvailableTables = New ValueList();
	For Each TableRow In Object.Tables Do
		If Not IsBlankString(TableRow.Name) And UsedTables.Find(TableRow.Name) = Undefined Then
			AvailableTables.Add(TableRow.Name);
		EndIf;
	EndDo;
	
	If AvailableTables.Count() > 0 Then
		AvailableTables.ShowChooseItem(New CallbackDescription("ChooseTableEnd", ThisObject, "Add"));
	EndIf;
	
EndProcedure

&AtClient
Procedure MoveToTable(Command)
	
	CurrentRow = Items.Parameters.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	UsedTables = New Array;
	ExistingRows = Object.Parameters.FindRows(New Structure("Name", CurrentRow.Name));
	For Each ExistingRow In ExistingRows Do
		UsedTables.Add(ExistingRow.Table);
	EndDo;
	
	AvailableTables = New ValueList();
	For Each TableRow In Object.Tables Do
		If Not IsBlankString(TableRow.Name) And UsedTables.Find(TableRow.Name) = Undefined Then
			AvailableTables.Add(TableRow.Name);
		EndIf;
	EndDo;
	
	If AvailableTables.Count() > 0 Then
		AvailableTables.ShowChooseItem(New CallbackDescription("ChooseTableEnd", ThisObject, "Move"));
	EndIf;
	
EndProcedure

&AtClient
Procedure RemoveFromTable(Command)
	
	CurrentRow = Items.Parameters.CurrentData;
	If CurrentRow = Undefined OR IsBlankString(CurrentRow.Table) Then
		Return;
	EndIf;
	
	ExistingRows = Object.Parameters.FindRows(New Structure("Name,Table", CurrentRow.Name, ""));
	If ExistingRows.Count() = 0 Then
		CurrentRow.Table = "";
	Else
		Object.Parameters.Delete(CurrentRow);
	EndIf;
	
EndProcedure

&AtClient
Procedure OpenPrintInfoPath(Command)
	
	OpenForm("Catalog.PrintFormTemplates.Form.FormulaEditingParameter", 
		New Structure("Name, Expression", "_PrintInfoPath", Object.PrintInfoPath), 
		ThisObject, ,,,, FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtClient
Procedure AddParameters(Command)
	UpdateParametersListForInsert();
	If ParametersListForInsert.Count() = 0 Then
		Return;
	EndIf;
	
	ShowChooseFromList(
		New CallbackDescription("AddParametersChoiceEnd", ThisObject), ParametersListForInsert);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion

#Region Private

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)

	If Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.TXT") Then
		Form.Items.TemplatePages.CurrentPage = Form.Items.PageTXT;
	ElsIf Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.MXL") Then
		Form.Items.TemplatePages.CurrentPage = Form.Items.PageMXL;
	ElsIf Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.FormattedText") Then
		Form.Items.TemplatePages.CurrentPage = Form.Items.PageFormattedText;
	EndIf;
	
	If Form.EditingMode Then
		Form.Items.EditTXT.Visible = False;
		Form.Items.SaveTXT.Visible = True;
		Form.Items.AddParametersTXT.Visible = True;
		Form.Items.TemplateTXT.ReadOnly = False;
		Form.Items.TemplateTXT.BackColor = WebColors.MintCream;
		
		Form.Items.EditMXL.Visible = False;
		Form.Items.SaveMXL.Visible = True;
		Form.Items.AddParametersMXL.Visible = True;
		Form.Items.TemplateMXL.Edit = True;
		Form.Items.TemplateMXL.ShowGrid = True;
		Form.Items.TemplateMXL.ShowHeaders = True;
		Form.Items.TemplateMXL.BorderColor = WebColors.Red;
		
		Form.Items.EditFT.Visible = False;
		Form.Items.SaveFT.Visible = True;
		Form.Items.AddParametersFT.Visible = True;
		Form.Items.TemplateFT.ReadOnly = False;
		Form.Items.TemplateFT.BackColor = WebColors.MintCream;
	Else
		Form.Items.EditTXT.Visible = True;
		Form.Items.SaveTXT.Visible = False;
		Form.Items.AddParametersTXT.Visible = False;
		Form.Items.TemplateTXT.ReadOnly = True;
		Form.Items.TemplateTXT.BackColor = WebColors.GhostWhite;
		
		Form.Items.EditMXL.Visible = True;
		Form.Items.SaveMXL.Visible = False;
		Form.Items.AddParametersMXL.Visible = False;
		Form.Items.TemplateMXL.Edit = False;
		Form.Items.TemplateMXL.ShowGrid = False;
		Form.Items.TemplateMXL.ShowHeaders = False;
		Form.Items.TemplateMXL.BorderColor = WebColors.Black;
		
		Form.Items.EditFT.Visible = True;
		Form.Items.SaveFT.Visible = False;
		Form.Items.AddParametersFT.Visible = False;
		Form.Items.TemplateFT.ReadOnly = True;
		Form.Items.TemplateFT.BackColor = WebColors.GhostWhite;
	EndIf;
	
	Form.Items.PageTables.Visible = Object.UseTables;
	Form.Items.ParametersTable.Visible = Object.UseTables;
	Form.Items.ParametersTablesGroup.Visible = Object.UseTables;
	Form.Items.ParametersContextMenuTableGroup.Visible = Object.UseTables;

	Form.Items.PrintInfoPath.Visible = Object.UsePrintInformations;
	Form.Items.OpenPrintInfoPath.Visible = Object.UsePrintInformations;
	
	Form.Items.PageAccess.Visible = Object.LimitedAccess;

EndProcedure

&AtServer
Procedure LoadTemplateData()
	
	RealObject = FormAttributeToValue("Object");
	TemplateData = RealObject.Template.Get();
	
	If Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.TXT") Then
		If TypeOf(TemplateData) = Type("String") Then
			TemplateTXT = TemplateData;
		EndIf;
		
	ElsIf Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.MXL") Then
		If TypeOf(TemplateData) = Type("SpreadsheetDocument") Then
			TemplateMXL = TemplateData;
		Else
			TemplateMXL = New SpreadsheetDocument();
		EndIf;
		
	ElsIf Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.FormattedText") Then
		If TypeOf(TemplateData) = Type("FormattedDocument") Then
			TemplateFormattedText = TemplateData;
		Else
			TemplateFormattedText = New FormattedDocument();
		EndIf;
		
	EndIf;
	 
EndProcedure

&AtServer
Procedure SaveTemplateData(RealObject)
	
	If Object.PrintFormType = Enums.PrintFormTypes.TXT Then
		RealObject.Template = New ValueStorage(TemplateTXT);
		
	ElsIf Object.PrintFormType = Enums.PrintFormTypes.MXL Then
		RealObject.Template = New ValueStorage(TemplateMXL);
		
	ElsIf Object.PrintFormType = Enums.PrintFormTypes.FormattedText Then
		RealObject.Template = New ValueStorage(TemplateFormattedText);
		
	EndIf;
	 
EndProcedure

&AtServer
Procedure LoadObjectsForPrinting()

	Query = New Query;
	Query.SetParameter("Ref", Object.Ref);
	Query.Text =
	"SELECT
	|	ObjectsPrintTemplates.Object
	|FROM
	|	InformationRegister.ObjectsPrintTemplates AS ObjectsPrintTemplates
	|WHERE
	|	ObjectsPrintTemplates.PrintTemplate = &Ref";
	
	ObjectsList.Clear();
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		ObjectsList.Add(QuerySelection.Object);
	EndDo;
	
EndProcedure

&AtServer
Procedure SaveObjectsForPrinting(CurrentObject)

	ObjectRecords = InformationRegisters.ObjectsPrintTemplates.CreateRecordSet();
	ObjectRecords.Filter.PrintTemplate.Set(CurrentObject.Ref, True);
	
	For Each ObjectsItem In ObjectsList Do
		Record = ObjectRecords.Add();
		Record.PrintTemplate = CurrentObject.Ref;
		Record.Object = ObjectsItem.Value;
	EndDo;
	
	ObjectRecords.Write(True);
	
	InternalCommandsServer.SetSessionParameters();
	
EndProcedure

&AtClient
Procedure LoadFromFileEnd(ChoosenFiles, AddInfo) Export
	
	If ChoosenFiles = Undefined Then
		Return;
	EndIf;
	
	If Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.TXT") Then
		TextDocument = New TextDocument();
		TextDocument.Read(ChoosenFiles[0]);
		TemplateTXT = TextDocument.GetText();
		
	ElsIf Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.MXL") Then
		ChoosenFile = New File(ChoosenFiles[0]);
		FileDescription = New Structure;
		FileDescription.Insert("Extension", ChoosenFile.Extension);
		FileDescription.Insert("BinaryData", New BinaryData(ChoosenFile.FullName));
		LoadFromFileAtServer(FileDescription);
	EndIf;
	
	Modified = True;
	RefreshParameters(Undefined);
	SetVisibilityAvailability(Object, ThisObject);
	
EndProcedure

&AtServer
Procedure LoadFromFileAtServer(FileDescription)
	
	TempName = GetTempFileName(FileDescription.Extension);
	FileDescription.BinaryData.Write(TempName);
	
	NewDocument = New SpreadsheetDocument();
	NewDocument.Read(TempName);
	ThisObject.TemplateMXL = NewDocument;
	
	DeleteFiles(TempName); 

EndProcedure

&AtServer
Procedure ExpractParametersFromTemplateTXT()
	
	For Each ParameterRow In Object.Parameters Do
		ParameterRow.ToDelete = True;
	EndDo;
	
	If Object.PrintFormVariableType = Enums.PrintFormVariableTypes.XMLStyle Then
		FindResults = StrFindAllByRegularExpression(TemplateTXT, "<[^>]*?>");
	ElsIf Object.PrintFormVariableType = Enums.PrintFormVariableTypes.WikiStyle Then
		FindResults = StrFindAllByRegularExpression(TemplateTXT, "\[[^\]]*?\]");
	ElsIf Object.PrintFormVariableType = Enums.PrintFormVariableTypes.CurlyBrace Then
		FindResults = StrFindAllByRegularExpression(TemplateTXT, "\{[^\}]*?\}");
	Else
		FindResults = New Array();
	EndIf;
	
	For Each FindResult In FindResults Do
		If Object.UsePrintInformations And StrFind(FindResult.Value, "PrintInfo.") > 0 Then
			Continue;
		EndIf;
		TextTag = TrimAll(FindResult.Value);
		ParameterRows = Object.Parameters.FindRows(New Structure("Name", TextTag));
		If ParameterRows.Count() = 0 Then
			Object.Parameters.Add().Name = TextTag;
		Else
			For Each ParameterRow In ParameterRows Do
				ParameterRow.ToDelete = False;
			EndDo;
		EndIf;
	EndDo;
	
	Object.Parameters.Sort("Name, Table");
	 
EndProcedure

&AtServer
Procedure ExpractParametersFromTemplateMXL()
	
	For Each ParameterRow In Object.Parameters Do
		ParameterRow.ToDelete = True;
	EndDo;
	
	AllTextArray = New Array; 
	For RowNum = 1 To TemplateMXL.TableHeight Do
		For ColNum = 1 To TemplateMXL.TableWidth Do
			CellText = TrimAll(TemplateMXL.Area("R" + Format(RowNum, "NG=;") + "C" + Format(ColNum, "NG=;")).Text);
			If Not IsBlankString(CellText) And AllTextArray.Find(CellText) = Undefined Then
				AllTextArray.Add(CellText);
			EndIf;
		EndDo;
	EndDo;
	AllText = StrConcat(AllTextArray, "  ");
	
	If Object.PrintFormVariableType = Enums.PrintFormVariableTypes.XMLStyle Then
		FindResults = StrFindAllByRegularExpression(AllText, "<[^>]*?>");
	ElsIf Object.PrintFormVariableType = Enums.PrintFormVariableTypes.WikiStyle Then
		FindResults = StrFindAllByRegularExpression(AllText, "\[[^\]]*?\]");
	ElsIf Object.PrintFormVariableType = Enums.PrintFormVariableTypes.CurlyBrace Then
		FindResults = StrFindAllByRegularExpression(AllText, "\{[^\}]*?\}");
	Else
		FindResults = New Array();
	EndIf;
	
	For Each FindResult In FindResults Do
		If Object.UsePrintInformations And StrFind(FindResult.Value, "PrintInfo.") > 0 Then
			Continue;
		EndIf;
		TextTag = TrimAll(FindResult.Value);
		ParameterRows = Object.Parameters.FindRows(New Structure("Name", TextTag));
		If ParameterRows.Count() = 0 Then
			Object.Parameters.Add().Name = TextTag;
		Else
			For Each ParameterRow In ParameterRows Do
				ParameterRow.ToDelete = False;
			EndDo;
		EndIf;
	EndDo;
	
	Object.Parameters.Sort("Name, Table");
	 
EndProcedure

&AtServer
Procedure ExpractParametersFromTemplateFormattedText()
	
	For Each ParameterRow In Object.Parameters Do
		ParameterRow.ToDelete = True;
	EndDo;
	
	PlaneText = TemplateFormattedText.GetText();
	
	If Object.PrintFormVariableType = Enums.PrintFormVariableTypes.XMLStyle Then
		FindResults = StrFindAllByRegularExpression(PlaneText, "<[^>]*?>");
	ElsIf Object.PrintFormVariableType = Enums.PrintFormVariableTypes.WikiStyle Then
		FindResults = StrFindAllByRegularExpression(PlaneText, "\[[^\]]*?\]");
	ElsIf Object.PrintFormVariableType = Enums.PrintFormVariableTypes.CurlyBrace Then
		FindResults = StrFindAllByRegularExpression(PlaneText, "\{[^\}]*?\}");
	Else
		FindResults = New Array();
	EndIf;
	
	For Each FindResult In FindResults Do
		If Object.UsePrintInformations And StrFind(FindResult.Value, "PrintInfo.") > 0 Then
			Continue;
		EndIf;
		TextTag = TrimAll(FindResult.Value);
		ParameterRows = Object.Parameters.FindRows(New Structure("Name", TextTag));
		If ParameterRows.Count() = 0 Then
			Object.Parameters.Add().Name = TextTag;
		Else
			For Each ParameterRow In ParameterRows Do
				ParameterRow.ToDelete = False;
			EndDo;
		EndIf;
	EndDo;
	
	Object.Parameters.Sort("Name, Table");
	 
EndProcedure

&AtClient
Procedure ChooseTableEnd(ChoosenTable, Action) Export
	
	If ChoosenTable = Undefined Then
		Return;
	EndIf;
	
	ChoosenTableName = ChoosenTable.Value;
	
	If Action = "Add" Then
		CurrentIndex = Object.Parameters.IndexOf(Items.Parameters.CurrentData);
		NewRow = Object.Parameters.Insert(CurrentIndex + 1);
		FillPropertyValues(NewRow, Items.Parameters.CurrentData);
		NewRow.Table = ChoosenTableName;
		
	ElsIf Action = "Move" Then
		Items.Parameters.CurrentData.Table = ChoosenTableName;
	EndIf;
	
	Modified = True;
	
EndProcedure

&AtClient
Procedure UpdateParametersListForInsert()

	ParametersListForInsert.Clear();
	
	TagBegin = "";
	TagEnd = "";
	If Object.PrintFormVariableType = PredefinedValue("Enum.PrintFormVariableTypes.XMLStyle") Then
		TagBegin = "<";
		TagEnd = ">";
	ElsIf Object.PrintFormVariableType = PredefinedValue("Enum.PrintFormVariableTypes.WikiStyle") Then
		TagBegin = "[";
		TagEnd = "]";
	ElsIf Object.PrintFormVariableType = PredefinedValue("Enum.PrintFormVariableTypes.CurlyBrace") Then
		TagBegin = "{";
		TagEnd = "}";
	EndIf;
	
	If Object.UsePrintInformations Then
		ParametersListForInsert.Add(TagBegin + "PrintInfo.Text" + TagEnd);
		ParametersListForInsert.Add(TagBegin + "PrintInfo.Logo" + TagEnd);
		ParametersListForInsert.Add(TagBegin + "PrintInfo.Seal" + TagEnd);
	EndIf;
	
	For Each Parameter In Object.Parameters Do
		If Not Parameter.ToDelete And Not IsBlankString(Parameter.Name) 
				And ParametersListForInsert.FindByValue(Parameter.Name) = Undefined Then
			ParametersListForInsert.Add(Parameter.Name);
		EndIf;
	EndDo;
	
EndProcedure	

&AtClient
Procedure AddParametersChoiceEnd(Result, AddInfo) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	NewParam = Result.Value;
	
	If Items.TemplatePages.CurrentPage = Items.PageTXT Then
		TemplateTXT = TemplateTXT + NewParam;
	ElsIf Items.TemplatePages.CurrentPage = Items.PageMXL Then
		Items.TemplateMXL.CurrentArea.Text = NewParam; 
	ElsIf Items.TemplatePages.CurrentPage = Items.PageFormattedText Then
		TemplateFormattedText.Add(NewParam, Type("FormattedDocumentText"));
	EndIf;
	
EndProcedure

#EndRegion

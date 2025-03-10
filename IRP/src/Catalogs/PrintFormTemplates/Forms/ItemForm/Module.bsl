
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	
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
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	OldParameters = Object.Parameters.FindRows(New Structure("ToDelete", True));
	For Each OldParameter In OldParameters Do
		Object.Parameters.Delete(OldParameter);
	EndDo;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	SaveTemplate(CurrentObject);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	
	ObjectRecords = InformationRegisters.ObjectsPrintTemplates.CreateRecordSet();
	ObjectRecords.Filter.PrintTemplate.Set(CurrentObject.Ref, True);
	
	For Each ObjectsItem In ObjectsList Do
		Record = ObjectRecords.Add();
		Record.PrintTemplate = CurrentObject.Ref;
		Record.Object = ObjectsItem.Value;
	EndDo;
	
	ObjectRecords.Write(True);
	
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	
	If EventName = "FormulaIsReady" Then
		
		CurrentRow = Items.Parameters.CurrentData;
		If CurrentRow = Undefined Then
			Return;
		Else
			CurrentRow.Expression = Parameter;
		EndIf;
		
	EndIf;
	
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlersParameters

&AtClient
Procedure ParametersExpressionOpening(Item, StandardProcessing)
	StandardProcessing = False;
	OpenExpression(Undefined);
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure EditTXT(Command)
	EditingMode = True;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure SaveTXT(Command)
	EditingMode = False;
	Modified = True;
	ProcessTemplateTXT();
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OpenExpression(Command)
	
	CurrentRow = Items.Parameters.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	OpenForm("Catalog.PrintFormTemplates.Form.FormulaEditing", 
		New Structure("Expression", CurrentRow.Expression), ThisObject, ,,,, FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

#EndRegion

#Region Private

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)

	If Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.TXT") Then
		Form.Items.TemplatePages.CurrentPage = Form.Items.PageTXT; 
	EndIf;
	
	Form.Items.EditTXT.Visible = Not Form.EditingMode;
	Form.Items.SaveTXT.Visible = Form.EditingMode;
	
	Form.Items.TemplateTXT.ReadOnly = Not Form.EditingMode;
	
	If Form.EditingMode Then
		Form.Items.TemplateTXT.BackColor = WebColors.MintCream;
	Else
		Form.Items.TemplateTXT.BackColor = WebColors.GhostWhite;
	EndIf;

EndProcedure

&AtServer
Procedure LoadTemplateData()
	
	RealObject = FormAttributeToValue("Object");
	TemplateData = RealObject.Template.Get();
	
	If Object.PrintFormType = PredefinedValue("Enum.PrintFormTypes.TXT") Then
		If TypeOf(TemplateData) = Type("String") Then
			TemplateTXT = TemplateData;
		EndIf;
		
	EndIf;
	 
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
Procedure SaveTemplate(RealObject)
	
	If Object.PrintFormType = Enums.PrintFormTypes.TXT Then
		RealObject.Template = New ValueStorage(TemplateTXT);
		
	EndIf;
	 
EndProcedure

&AtServer
Procedure ProcessTemplateTXT()
	
	For Each ParameterRow In Object.Parameters Do
		ParameterRow.ToDelete = True;
	EndDo;
	
	FindResults = StrFindAllByRegularExpression(TemplateTXT, "<[^>]*>");
	For Each FindResult In FindResults Do
		TextTag = TrimAll(FindResult.Value);
		ParameterRows = Object.Parameters.FindRows(New Structure("Name", TextTag));
		If ParameterRows.Count() = 0 Then
			Object.Parameters.Add().Name = TextTag;
		Else
			ParameterRows[0].ToDelete = False;
		EndIf;
	EndDo;
	
	Object.Parameters.Sort("Name");
	 
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
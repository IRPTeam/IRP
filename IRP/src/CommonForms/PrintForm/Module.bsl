
// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Result = Parameters.Result;
	Items.LayoutLang.ChoiceList.Clear();
	MetadataLanguages = LocalizationReuse.MetadataLanguages();
	For Each It In MetadataLanguages Do
		Items.LayoutLang.ChoiceList.Add(It.Key, It.Value);				
		Items.DataLang.ChoiceList.Add(It.Key, It.Value);
	EndDo;
	UseSavedPrintForms = FOServer.IsUseSavedPrintForms();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	EditResultSwitch();
EndProcedure

// Print form config selection.
// 
// Parameters:
//  Item - FormTable - Item
//  RowSelected - See CommonForm.PrintForm.Items.PrintFormConfig
//  Field - FormField - Field
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure PrintFormConfigSelection(Item, RowSelected, Field, StandardProcessing)
	If Field.Name = "PrintFormConfigPresentation" Or Field.Name = "PrintFormConfigNameTemplate" Then
		If Not Item.CurrentData = Undefined And ValueIsFilled(Item.CurrentData.Ref) Then
			StandardProcessing = False;
			ShowValue(, Item.CurrentData.Ref);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure Show(Command)
	SetVisiblePrintSetting(True);
EndProcedure

&AtClient
Procedure Hide(Command)
	SetVisiblePrintSetting(False);
EndProcedure

// Notification processing.
// 
// Parameters:
//  EventName - String - Event name
//  Parameter - See UniversalPrintServer.InitPrintParam
&AtClient
Procedure NotificationProcessing(EventName, Parameter)
	If EventName = "AddTemplatePrintForm" Then
		FillPrintFormConfig(Parameter);	
	EndIf;
EndProcedure

// Set current row to PrintFormConfig.
// 
// Parameters:
//  RowID - Number - Row ID
&AtClient
Procedure SetCurrentRowToPrintFormConfig(RowID)
	Items.PrintFormConfig.CurrentRow = RowID;
EndProcedure

// Fill print form config.
// 
// Parameters:
//  Parameter - See UniversalPrintServer.InitPrintParam
&AtClient
Procedure FillPrintFormConfig(Parameter)
	
	RefDoc = Parameter.RefDocument;
	NameTemplate = Parameter.NameTemplate;

	SearchArray = PrintFormConfig.FindRows(New Structure("Ref, NameTemplate", RefDoc, NameTemplate));
	If SearchArray.Count() = 0 Then
		NewStr = PrintFormConfig.Add();
		NewStr.Print = True;
		NewStr.Ref = RefDoc;
		NewStr.NameTemplate = NameTemplate;
		NewStr.Presentation = String(RefDoc);
		NewStr.CountCopy = Parameter.CountCopy;
		NewStr.BuilderLayout = Parameter.BuilderLayout;
		NewStr.LayoutLang = Parameter.LayoutLang;
		NewStr.DataLang = Parameter.DataLang;
		NewStr.IsSavedPrintForm = Parameter.IsSavedPrintForm;
		NewStr.TemplateRef = Parameter.TemplateRef;
		NewStr.Template = NameTemplate;
		NewStr.SpreadsheetDoc = Parameter.SpreadsheetDoc;
		ThisObject.IdResult	= PrintFormConfig.IndexOf(NewStr);
		If NewStr.BuilderLayout Then
			NewStr.Template = UniversalPrintServer.GetSynonymTemplate(RefDoc, NameTemplate);
			BuilderLayoutByParameters();
		EndIf;
		
		SetCurrentRowToPrintFormConfig(NewStr.GetID());
	Else
		SetCurrentRowToPrintFormConfig(SearchArray[0].GetID());
	EndIf;
	
	If PrintFormConfig.Count() = 1 And Items.PrintFormConfig.Visible Then
		SetVisiblePrintSetting(False);
		CurrentData = Items.PrintFormConfig.RowData(0);
		SetPropertiesByRowData(CurrentData);
		SetResult();
	ElsIf PrintFormConfig.Count() > 1 And Not Items.PrintFormConfig.Visible Then 
		SetVisiblePrintSetting(True);
	EndIf;

EndProcedure

&AtClient
Procedure PrintFormConfigOnActivateRow(Item)
	CurrentData = Item.CurrentData;
	If Not CurrentData = Undefined Then
		SetPropertiesByRowData(CurrentData);
		SetResult();
	EndIf;	
EndProcedure

&AtClient
Procedure LayoutLangOnChange(Item)
	RefreshTemplate();
EndProcedure

&AtClient
Procedure DataLangOnChange(Item)
	RefreshTemplate();
EndProcedure

&AtClient
Procedure PrintFormConfigOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		CurrentData = Items.PrintFormConfig.CurrentData;
		If Not CurrentData = Undefined Then
			PrintFormConfigOnActivateRow(Item);			
		EndIf;  
	EndIf;
EndProcedure

&AtClient
Procedure RefreshTemplate()
	SelectRows = Items.PrintFormConfig.SelectedRows;
	If SelectRows.Count() = 0 Then
		SelectRows = New Array;
		//@skip-check typed-value-adding-to-untyped-collection
		SelectRows.Add(PrintFormConfig.Get(ThisObject.IdResult));
	EndIf; 	
	For Each ItRow In SelectRows Do	
		SelectData = Items.PrintFormConfig.RowData(ItRow);
		If SelectData = Undefined Then
			SelectData = PrintFormConfig.Get(ThisObject.IdResult);
		EndIf;
		BuildDataRow(PrintFormConfig.IndexOf(SelectData));
	EndDo;
	SetResult();
EndProcedure

&AtServer
Procedure SetResult()
	CurrentData = PrintFormConfig.Get(ThisObject.IdResult);
	//@skip-check property-return-type, statement-type-change
	ThisObject.Result = CurrentData.SpreadsheetDoc; // SpreadsheetDocument
	
	If CurrentData.IsSavedPrintForm Then
		ThisObject.PrintSource = "FromHistory";
	Else
		ThisObject.PrintSource = "FromDocument";
	EndIf;
EndProcedure

&AtClient
Async Procedure PrintSourceOnChange(Item)
	CurrentData = PrintFormConfig.Get(ThisObject.IdResult);
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If CurrentData.IsSavedPrintForm And ThisObject.PrintSource = "FromDocument" Then
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_035, QuestionDialogMode.YesNo,, DialogReturnCode.No);
		If Answer = DialogReturnCode.Yes Then
			ClearSavedPrintForm();
		EndIf;
	EndIf;
	
	PrintSourceOnChangeAtServer();
	SetResult();
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtServer
Function CopyableSpreadsheetDocumentProperties()
	Return "FitToPage, Output," +
	"PageHeight, DuplexPrinting, Protection," +
	"PrinterName, LanguageCode, Copies, PrintScale," +
	"FirstPageNumber, PageOrientation, TopMargin," +
	"LeftMargin, BottomMargin, RightMargin, Collate," +
	"HeaderSize, FooterSize, PageSize, PrintAccuracy," +
	"BackgroundPicture, BlackAndWhite, PageWidth, PerPage";
EndFunction

&AtClient
Procedure Print(Command)
	PackageDocuments = PrintAtServer();
	PackageDocuments.Print();
EndProcedure

&AtServer
Function PackageWithOneSpreadsheetDocument(SpreadsheetDoc)
	SpreadsheetDocumentAddressInTemporaryStorage = PutToTempStorage(SpreadsheetDoc);
	PackageWithOneDocument = New RepresentableDocumentBatch;
	PackageWithOneDocument.Collate = True;
	PackageWithOneDocument.Content.Add(SpreadsheetDocumentAddressInTemporaryStorage);
	FillPropertyValues(PackageWithOneDocument, SpreadsheetDoc, "Output, DuplexPrinting, PrinterName, Copies, PrintAccuracy");
	If Not SpreadsheetDoc.Collate = Undefined Then
		PackageWithOneDocument.Collate = SpreadsheetDoc.Collate;
	EndIf;
	Return PackageWithOneDocument;
EndFunction

&AtServer
Function PrintAtServer()
	PackageDocuments = New RepresentableDocumentBatch;
	PackageDocuments.Collate = True;
	// setting the copy property to print the desired number of copies 
	// in the RepresentableDocumentBatch object did not produce the expected result	
	For Each ItPrint In PrintFormConfig Do
		Copies = ItPrint.CountCopy;
		For It = 0 To Copies - 1 Do
			SpreadsheetDoc = New SpreadsheetDocument;
			FillPropertyValues(SpreadsheetDoc, ItPrint.SpreadsheetDoc, CopyableSpreadsheetDocumentProperties());
			SpreadsheetDoc.Put(ItPrint.SpreadsheetDoc);
			PackageDocuments.Content.Add().Data = PackageWithOneSpreadsheetDocument(SpreadsheetDoc);
		EndDo;
	EndDo;
	Return PackageDocuments;
EndFunction

&AtClient
Procedure ResultOnChange(Item)
	CurrentData = Items.PrintFormConfig.CurrentData;
	If Not CurrentData = Undefined Then
		Items.PrintFormConfig.CurrentData.SpreadsheetDoc = SaveChangeResult();	
	EndIf;
EndProcedure

&AtServer
Function SaveChangeResult()
	NewSpreadsheetDoc = New SpreadsheetDocument;
	NewSpreadsheetDoc.LanguageCode = Result.LanguageCode;
	NewSpreadsheetDoc.Put(Result);
	FillPropertyValues(NewSpreadsheetDoc, Result, CopyableSpreadsheetDocumentProperties());
	Return NewSpreadsheetDoc;
EndFunction

&AtClient
Procedure EditResult(Command)
	//@skip-check property-return-type
	Items.FormEditResult.Check = Not Items.FormEditResult.Check;
	EditResultSwitch();
	
	If UseSavedPrintForms And Not Items.FormEditResult.Check Then
		If Items.PrintFormConfig.CurrentData <> Undefined Then
			SavePrintForms();
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ChangeLang(Command)
	isCheck = Not Items.ChangeLang.Check; // Boolean
	Items.ChangeLang.Check = isCheck;
	Items.LayoutLang.Visible = isCheck;
	Items.DataLang.Visible = isCheck;
	Items.PrintFormConfigLayoutLang.Visible = isCheck;
	Items.PrintFormConfigDataLang.Visible = isCheck;
EndProcedure

&AtClient
Procedure SendByMessage(Command)
	
	PrintCurrentData = Undefined;
	
	If PrintFormConfig.Count() = 1 Then
		PrintCurrentData = PrintFormConfig[0];
	ElsIf Items.PrintFormConfig.CurrentData <> Undefined Then
		PrintCurrentData = Items.PrintFormConfig.CurrentData;
	Else
		Return;
	EndIf;
	
	MessageParameters = New Structure;
	MessageParameters.Insert("BasisDocument", PrintCurrentData.Ref);
	MessageParameters.Insert("Subject", PrintCurrentData.NameTemplate);
	MessageParameters.Insert("FileRef", GetFileDocument(Result, PrintCurrentData.NameTemplate, PrintCurrentData.Ref));
	
	OpenForm("Document.OutgoingMessage.Form.DocumentForm", New Structure("FillingValues", MessageParameters), ThisObject, UUID);
	
EndProcedure

#EndRegion

#Region Private

&AtClient
Procedure EditResultSwitch()
	Items.GroupResultCommandBar.Visible = Items.FormEditResult.Check;
	Items.Result.Edit = Items.FormEditResult.Check;
EndProcedure

// Set visible print setting.
// 
// Parameters:
//  Visible - Boolean
&AtClient
Procedure SetVisiblePrintSetting(Visible)
	Items.PrintFormConfig.Visible = Visible;
	Items.FormHide.Visible = Visible;
	Items.FormShow.Visible = Not Visible;
EndProcedure

&AtClient
Procedure SetPropertiesByRowData(RowData)
	Items.LayoutLang.ReadOnly = Not RowData.BuilderLayout;
	Items.DataLang.ReadOnly = Not RowData.BuilderLayout;
	
	LayoutLang = RowData.LayoutLang;
	DataLang = RowData.DataLang;
	ThisObject.IdResult = PrintFormConfig.IndexOf(RowData);
EndProcedure

&AtServerNoContext
Function GetFileDocument(SpreadsheetDocument, NameTemplate, BasisDocument)
	Return FilesServer.GetFileForPrintDocument(SpreadsheetDocument, NameTemplate, BasisDocument);
EndFunction

&AtServer
Procedure PrintSourceOnChangeAtServer()
	
	SelectData = PrintFormConfig.Get(ThisObject.IdResult);

	If ThisObject.PrintSource = "FromDocument" OR Not UseSavedPrintForms Then
		
		If ValueIsFilled(SelectData.TemplateRef) Then
			SpreadsheetDoc = Catalogs.PrintFormTemplates.GetPrintForm(SelectData.TemplateRef, SelectData.Ref, True);
			If SpreadsheetDoc <> Undefined Then
				ThisObject.Result.Clear();
				ThisObject.Result.Put(SpreadsheetDoc);
			EndIf;
		Else
			BuildDataRow(SelectData);
		EndIf;
		
		SelectData.IsSavedPrintForm = False;
	
	ElsIf ThisObject.PrintSource = "FromHistory" Then
		
		SavedPrintForm = InformationRegisters.SavedPrintForms.GetSavedPrintForm(
				SelectData.Ref, SelectData.NameTemplate, SelectData.TemplateRef);
		If SavedPrintForm <> Undefined Then
			ThisObject.Result.Clear();
			ThisObject.Result.Put(SavedPrintForm);
		EndIf;
		
		SelectData.IsSavedPrintForm = True;
		
	EndIf;
	
EndProcedure

&AtServer
Procedure SavePrintForms()
	CurrentData = PrintFormConfig.Get(ThisObject.IdResult);
	InformationRegisters.SavedPrintForms.SaveToSavedPrintForms(
			CurrentData.Ref, CurrentData.NameTemplate, CurrentData.TemplateRef, Result);
	CurrentData.IsSavedPrintForm = True;
	ThisObject.PrintSource = "FromHistory";
EndProcedure

&AtServer
Procedure ClearSavedPrintForm()
	CurrentData = PrintFormConfig.Get(ThisObject.IdResult);
	InformationRegisters.SavedPrintForms.ClearSavedPrintForms(
			CurrentData.Ref, CurrentData.NameTemplate, CurrentData.TemplateRef);
	CurrentData.IsSavedPrintForm = False;
EndProcedure

&AtServer
Procedure BuilderLayoutByParameters()

	SelectData = PrintFormConfig.Get(ThisObject.IdResult);

	SavedPrintForm = Undefined;
	If UseSavedPrintForms Then
		SavedPrintForm = InformationRegisters.SavedPrintForms.GetSavedPrintForm(
				SelectData.Ref, SelectData.NameTemplate, SelectData.TemplateRef);
	EndIf;
	
	If SavedPrintForm <> Undefined Then
		SelectData.IsSavedPrintForm = True;
		SelectData.SpreadsheetDoc = SavedPrintForm;
	ElsIf ValueIsFilled(SelectData.TemplateRef) Then
		SelectData.SpreadsheetDoc = Catalogs.PrintFormTemplates.GetPrintForm(SelectData.TemplateRef, SelectData.Ref, True);
	Else
		BuildDataRow(SelectData);
	EndIf;

EndProcedure

&AtServer
Procedure BuildDataRow(DataID)
	
	If TypeOf(DataID) = Type("Number") Then
		DataRow = PrintFormConfig.Get(DataID);
	Else
		DataRow = DataID;
	EndIf;
	
	If Not ValueIsFilled(DataLang) Then
		DataLang = LocalizationReuse.GetLocalizationCode();
	EndIf;
	If Not ValueIsFilled(LayoutLang) Then
		LayoutLang = LocalizationReuse.GetInterfaceLocalizationCode();
	EndIf;
	
	Param = UniversalPrintServer.InitPrintParam(DataRow.Ref);
	FillPropertyValues(Param, DataRow);
	Param.DataLang = DataLang;
	Param.LayoutLang = LayoutLang;
	
	SpreadsheetDoc = UniversalPrintServer.BuildSpreadsheetDoc(Param.RefDocument, Param);
	
	DataRow.DataLang = DataLang;
	DataRow.LayoutLang = LayoutLang;
	DataRow.SpreadsheetDoc = SpreadsheetDoc;
	
EndProcedure
	
#EndRegion

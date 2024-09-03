
// @strict-types

#Region FormEventHandlers

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
Procedure OnOpen(Cancel)
	EditResultSwitch();
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
	FindObj = New Structure();
	RefDoc = Parameter.RefDocument;
	NameTemplate = Parameter.NameTemplate;
	FindObj.Insert("Ref", RefDoc);
	FindObj.Insert("NameTemplate", NameTemplate);
	SearchArray = PrintFormConfig.FindRows(FindObj);
	If SearchArray.Count() = 0 Then
		NewStr = PrintFormConfig.Add();
		NewStr.Print = True;
		NewStr.Presentation = "" + Parameter.RefDocument;
		NewStr.CountCopy = Parameter.CountCopy;
		NewStr.BuilderLayout = Parameter.BuilderLayout;
		NewStr.LayoutLang = Parameter.LayoutLang;
		NewStr.DataLang = Parameter.DataLang;
		NewStr.NameTemplate = NameTemplate;
		NewStr.Ref = Parameter.RefDocument;
		ThisObject.IdResult	= PrintFormConfig.IndexOf(NewStr);
		If Parameter.BuilderLayout Then
			NewStr.Template = UniversalPrintServer.GetSynonymTemplate(RefDoc, NameTemplate);
			NewStr.SpreadsheetDoc = UniversalPrintServer.BuildSpreadsheetDoc(RefDoc, Parameter);
		Else
			NewStr.Template = NameTemplate;
			NewStr.SpreadsheetDoc = Parameter.SpreadsheetDoc;
		EndIf;
		SetCurrentRowToPrintFormConfig(NewStr.GetID());
	Else
		SetCurrentRowToPrintFormConfig(SearchArray[0].GetID());
	EndIf;
	
	If PrintFormConfig.Count() = 1 And Items.PrintFormConfig.Visible Then
		SetVisiblePrintSetting(False);
		CurrentData = Items.PrintFormConfig.RowData(0);
		Items.LayoutLang.ReadOnly = Not CurrentData.BuilderLayout;
		Items.DataLang.ReadOnly = Not CurrentData.BuilderLayout;
		LayoutLang = CurrentData.LayoutLang;
		DataLang = CurrentData.DataLang;
		SetResult();
	ElsIf PrintFormConfig.Count() > 1 And Not Items.PrintFormConfig.Visible Then 
		SetVisiblePrintSetting(True);
	EndIf; 
EndProcedure

&AtClient
Procedure PrintFormConfigOnActivateRow(Item)
	CurrentData = Item.CurrentData;
	If Not CurrentData = Undefined Then
		Items.LayoutLang.ReadOnly = Not CurrentData.BuilderLayout;
		Items.DataLang.ReadOnly = Not CurrentData.BuilderLayout;
		LayoutLang = CurrentData.LayoutLang;
		DataLang = CurrentData.DataLang;
		ThisObject.IdResult = PrintFormConfig.IndexOf(CurrentData);
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
		Param = UniversalPrintServer.InitPrintParam(SelectData.Ref);
		FillPropertyValues(Param, SelectData);
		Param.DataLang = DataLang;
		Param.LayoutLang = LayoutLang;
		SpreadsheetDoc = UniversalPrintServer.BuildSpreadsheetDoc(Param.RefDocument, Param);
		Param.SpreadsheetDoc = SpreadsheetDoc;
		SelectData.DataLang = DataLang;
		SelectData.LayoutLang = LayoutLang;
		SelectData.SpreadsheetDoc = SpreadsheetDoc;
	EndDo;
	SetResult();
EndProcedure

&AtServer
Procedure SetResult()
	CurrentData = PrintFormConfig.Get(ThisObject.IdResult);
	//@skip-check property-return-type, statement-type-change
	ThisObject.Result = CurrentData.SpreadsheetDoc; // SpreadsheetDocument
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

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Result = Parameters.Result;
	Items.LayoutLang.ChoiceList.Clear();
	MetadataLanguages = LocalizationReuse.MetadataLanguages();
	For Each It In MetadataLanguages Do
		Items.LayoutLang.ChoiceList.Add(It.Key, It.Value);				
		Items.DataLang.ChoiceList.Add(It.Key, It.Value);
	EndDo;
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

&AtServerNoContext
Function GetFileDocument(SpreadsheetDocument, NameTemplate, BasisDocument)
	
	TempName = GetTempFileName("pdf");
	SpreadsheetDocument.Write(TempName, SpreadsheetDocumentFileType.PDF);
	FileDescription = New File(TempName);
	
	FileInfo = PictureViewerClientServer.FileInfo();
	FileInfo.FileID = String(New UUID());
	FileInfo.Extension = StrReplace(FileDescription.Extension, ".", "");
	FileInfo.FileName = NameTemplate + ".pdf";
	FileInfo.Insert("RequestBody", New BinaryData(TempName));
	FileInfo.MD5 = CommonFunctionsServer.GetMD5(SpreadsheetDocument);
	
	FileOwner = Undefined; // Undefined, DefinedType.typeFilesOwner
	If Metadata.DefinedTypes.typeFilesOwner.Type.ContainsType(TypeOf(BasisDocument)) Then
		FileOwner = BasisDocument;
	EndIf;
	FileRef = FilesServer.GetFileRefByBinaryData(FileInfo, FileOwner);
	
	DeleteFiles(TempName);
	
	Return FileRef;
	
EndFunction

#EndRegion

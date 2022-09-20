
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
	if Field.Name = "PrintFormConfigPresentation" OR Field.Name = "PrintFormConfigNameTemplate" Then
		If Item.CurrentData <> Undefined and ValueIsFilled(Item.CurrentData.Ref) Then
			StandardProcessing = False;
			ShowValue(, Item.CurrentData.Ref);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	EditResultSwitch();
EndProcedure

// Notification processing.
// 
// Parameters:
//  EventName - String - Event name
//  Parameter - See UniversalPrintServer.InitPrintParam
//  Source - Undefined
&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "AddTemplatePrintForm" Then
		FillPrintFormConfig(Parameter)	
	EndIf;
EndProcedure

// Fill print form config.
// 
// Parameters:
//  Parameter See UniversalPrintServer.InitPrintParam
&AtClient
Procedure FillPrintFormConfig(Parameter)
	FindObj = New Structure();
	RefDoc = Parameter.RefDocument;
	NameTemplate = Parameter.NameTemplate;
	FindObj.Insert("Ref", RefDoc);
	FindObj.Insert("NameTemplate", NameTemplate);
	If PrintFormConfig.FindRows(FindObj).Count() = 0 Then
		NewStr				= PrintFormConfig.Add();
		NewStr.Print		= True;
		NewStr.Presentation = "" + Parameter.RefDocument;
		NewStr.CountCopy	= Parameter.CountCopy;
		NewStr.BuilderLayout= Parameter.BuilderLayout;
		NewStr.LayoutLang	= Parameter.LayoutLang;
		NewStr.DataLang		= Parameter.DataLang;
		NewStr.NameTemplate = NameTemplate;
		NewStr.Template		= UniversalPrintServer.GetSynonymTemplate(RefDoc, NameTemplate);
		NewStr.Ref			= Parameter.RefDocument;
		if Parameter.BuilderLayout then
			NewStr.SpreadsheetDoc = UniversalPrintServer.BuildSpreadsheetDoc(RefDoc, Parameter);
		else
			NewStr.SpreadsheetDoc = Parameter.SpreadsheetDoc;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure PrintFormConfigOnActivateRow(Item)
	CurrentData = Item.CurrentData;
	if CurrentData <> Undefined Then
		Items.LayoutLang.ReadOnly = not CurrentData.BuilderLayout;
		Items.DataLang.ReadOnly = not CurrentData.BuilderLayout;
		LayoutLang = CurrentData.LayoutLang;
		DataLang = CurrentData.DataLang;
		SetResult(CurrentData.SpreadsheetDoc);
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
	if Clone Then
		CurrentData = Items.PrintFormConfig.CurrentData;
		if CurrentData <> Undefined Then
			PrintFormConfigOnActivateRow(Item)			
		EndIf;  
	EndIf;
EndProcedure


&AtClient
Procedure RefreshTemplate()
	SelectRows = Items.PrintFormConfig.SelectedRows;
	if SelectRows.Count() > 0 then
		For Each ItRow In SelectRows Do	
			SelectData = Items.PrintFormConfig.RowData(ItRow);
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
	EndIf;
	CurrentData = Items.PrintFormConfig.CurrentData;
	if CurrentData <> Undefined Then
		SetResult(CurrentData.SpreadsheetDoc);
	EndIf;
	
EndProcedure

// Set result.
// 
// Parameters:
//  SpreadsheetDoc -  SpreadsheetDocument 
&AtServer
Procedure SetResult(SpreadsheetDoc)
	Result = SpreadsheetDoc;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtServer
Function CopyableSpreadsheetDocumentProperties()
	Возврат "FitToPage,Output," +
	"PageHeight,DuplexPrinting,Protection," +
	"PrinterName,LanguageCode,Copies,PrintScale," +
	"FirstPageNumber,PageOrientation,TopMargin," +
	"LeftMargin,BottomMargin,RightMargin,Collate," +
	"HeaderSize,FooterSize,PageSize,PrintAccuracy," +
	"BackgroundPicture,BlackAndWhite,PageWidth,PerPage";
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
	PackageWithOneDocument.Состав.Add(SpreadsheetDocumentAddressInTemporaryStorage);
	FillPropertyValues(PackageWithOneDocument, SpreadsheetDoc, "Output, DuplexPrinting, PrinterName, Copies, PrintAccuracy");
	if SpreadsheetDoc.Collate <> Undefined Then
		PackageWithOneDocument.Collate = SpreadsheetDoc.Collate;
	EndIf;
	Return PackageWithOneDocument;
EndFunction


&AtServer
Function PrintAtServer()
	PackageDocuments = New RepresentableDocumentBatch;
	PackageDocuments.Collate = True;
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
	If CurrentData <> Undefined Then
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

#EndRegion

#Region Private



&AtClient
Procedure EditResultSwitch()
	//@skip-check property-return-type
	//@skip-check statement-type-change
	Items.GroupResultCommandBar.Visible = Items.FormEditResult.Check;
	//@skip-check property-return-type
	//@skip-check statement-type-change
	Items.Result.Edit = Items.FormEditResult.Check;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	//@skip-check property-return-type
	Result = Parameters.Result;
	
	Items.LayoutLang.ChoiceList.Clear();
	For Each It In Metadata.Languages Do
		If It.Name = "HASH" Then
			Continue;			
		EndIf; 
		Items.LayoutLang.ChoiceList.Add(It.LanguageCode, It.Name);				
		Items.DataLang.ChoiceList.Add(It.LanguageCode, It.Name);
	EndDo; 
	
EndProcedure


&AtClient
Procedure Show(Command)
	Items.PrintFormConfig.Visible = True;
	Items.FormHide.Visible = True;
	Items.FormShow.Visible = False;		
EndProcedure

&AtClient
Procedure Hide(Command)
	Items.PrintFormConfig.Visible = False;
	Items.FormHide.Visible = False;
	Items.FormShow.Visible = True;		
EndProcedure

#EndRegion
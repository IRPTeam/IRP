
#Region EventHandlers

Procedure AfterPostingDocument(Ref, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure BeforePostingDocument(Object, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Public

Function GetLastRetailSalesReceiptDoc(AddInfo = Undefined) Export
	Query = New Query;
	Query.Text = 
		"SELECT ALLOWED TOP 1
		|	RetailSalesReceipt.Ref AS Ref
		|FROM
		|	Document.RetailSalesReceipt AS RetailSalesReceipt
		|WHERE
		|	RetailSalesReceipt.Posted
		|
		|ORDER BY
		|	RetailSalesReceipt.Date DESC";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		Return SelectionDetailRecords.Ref; 
	EndDo;
	
	Return Documents.RetailSalesReceipt.EmptyRef();
EndFunction

Function GetRetailSalesReceiptPrint(Workstation, Ref, AddInfo = Undefined) Export	
	TemplateStructure = Workstation.PrintTemplate.ValueOfTemplate.Get();
	If TemplateStructure = Undefined Then
		Return New SpreadsheetDocument();
	Else		
		PrintTemplate = TemplateStructure.Spreadsheet;
	EndIf;		
	Return Documents.RetailSalesReceipt.GetPrintForm(Ref, PrintTemplate, "POS");	
EndFunction

#EndRegion
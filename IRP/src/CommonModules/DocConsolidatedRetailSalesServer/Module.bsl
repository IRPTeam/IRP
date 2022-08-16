#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");	
	AttributesArray.Add("OpeningDate");	
	AttributesArray.Add("ClosingDate");	
	AttributesArray.Add("FiscalHardware");	
	AttributesArray.Add("Status");	
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region Service

Function GetDocument(Company, Branch, Workstation) Export
	
	FiscalHardware = GetWorkstationFiscalHardware(Workstation);
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ConsolidatedRetailSales.Ref
	|FROM
	|	Document.ConsolidatedRetailSales AS ConsolidatedRetailSales
	|WHERE
	|	ConsolidatedRetailSales.Posted
	|	AND ConsolidatedRetailSales.Company = &Company
	|	AND ConsolidatedRetailSales.Branch = &Branch
	|	AND ConsolidatedRetailSales.Status = VALUE(Enum.ConsolidatedRetailSalesStatuses.Open)
	|	AND ConsolidatedRetailSales.FiscalHardware = &FiscalHardware";
	
	Query.SetParameter("Company", Company);
	Query.SetParameter("Branch", Branch);
	Query.SetParameter("FiscalHardware", FiscalHardware);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref
	EndIf;
	Return Undefined;
EndFunction

Function CreateDocument(Company, Branch, Workstation) Export
	FiscalHardware = GetWorkstationFiscalHardware(Workstation);
	FillingValues = New Structure();
	FillingValues.Insert("Date"           , CommonFunctionsServer.GetCurrentSessionDate());
	FillingValues.Insert("Company"        , Company);
	FillingValues.Insert("Branch"         , Branch);
	FillingValues.Insert("FiscalHardware" , FiscalHardware);
	FillingValues.Insert("OpeningDate"    , FillingValues.Date);
	FillingValues.Insert("Status"         , Enums.ConsolidatedRetailSalesStatuses.Open);
	
	Doc = Documents.ConsolidatedRetailSales.CreateDocument();
	Doc.Fill(FillingValues);
	Doc.Write(DocumentWriteMode.Posting);
	Return Doc.Ref;
EndFunction

Procedure CloseDocument(DocRef) Export
	DocObject = DocRef.GetObject();
	DocObject.ClosingDate = CommonFunctionsServer.GetCurrentSessionDate();
	DocObject.Status = Enums.ConsolidatedRetailSalesStatuses.Close;
	DocObject.Write(DocumentWriteMode.Posting);
EndProcedure

Procedure CancelDocument(DocRef) Export
	DocObject = DocRef.GetObject();
	DocObject.ClosingDate = CommonFunctionsServer.GetCurrentSessionDate();
	DocObject.Status = Enums.ConsolidatedRetailSalesStatuses.Cancel;
	DocObject.Write(DocumentWriteMode.Posting);
EndProcedure

Function GetWorkstationFiscalHardware(Workstation)
	EnabledHardwares = New Array();
	For Each Row In Workstation.HardwareList Do
		If Row.Enable Then
			EnabledHardwares.Add(Row.Hardware);
		EndIf;
	EndDo;
	
	If EnabledHardwares.Count() <> 1 Then
		Raise StrTemplate("Workstation have hardvare %1 enabled hardware, can not separate fiscal hardvare from other",
			EnabledHardwares.Count());
	EndIf;
	Return EnabledHardwares[0];
EndFunction

#EndRegion




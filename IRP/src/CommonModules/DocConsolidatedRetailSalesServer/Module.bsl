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
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");	
	AttributesArray.Add("OpeningDate");	
	AttributesArray.Add("ClosingDate");	
	AttributesArray.Add("CashAccount");	
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
	
	If Not UseConsolidatedRetailSales(Branch) Then
		Return Undefined;
	EndIf;
	
	If Not (ValueIsFilled(Workstation) And ValueIsFilled(Workstation.CashAccount)) Then
		Return Undefined;
	EndIf;
		
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
	|	AND ConsolidatedRetailSales.CashAccount = &CashAccount";
	
	Query.SetParameter("Company", Company);
	Query.SetParameter("Branch", Branch);
	Query.SetParameter("CashAccount", Workstation.CashAccount);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref
	EndIf;
	Return Undefined;
EndFunction

Function CreateDocument(Company, Branch, Workstation) Export
	OpeningDateTime = CommonFunctionsServer.GetCurrentSessionDate();
	
	FillingValues = New Structure();
	FillingValues.Insert("Company"        , Company);
	FillingValues.Insert("Branch"         , Branch);
	FillingValues.Insert("CashAccount"    , Workstation.CashAccount);
	FillingValues.Insert("OpeningDate"    , OpeningDateTime);
	FillingValues.Insert("Status"         , Enums.ConsolidatedRetailSalesStatuses.Open);
	
	Doc = Documents.ConsolidatedRetailSales.CreateDocument();
	Doc.Date = OpeningDateTime;
	Doc.Fill(FillingValues);
	Doc.Write(DocumentWriteMode.Posting);
	Return Doc.Ref;
EndFunction

Procedure CloseDocument(DocRef, UserData = Undefined) Export
	DocObject = DocRef.GetObject();
	DocObject.ClosingDate = CommonFunctionsServer.GetCurrentSessionDate();
	DocObject.Status = Enums.ConsolidatedRetailSalesStatuses.Close;
	If Not UserData = Undefined Then
		FillPropertyValues(DocObject, UserData, , "PaymentList");
		For Each Item in UserData.PaymentList Do
			FillPropertyValues(DocObject.PaymentList.Add(), Item);
		EndDo;
	EndIf;
	DocObject.Write(DocumentWriteMode.Posting);
EndProcedure

Procedure CancelDocument(DocRef) Export
	DocObject = DocRef.GetObject();
	DocObject.ClosingDate = CommonFunctionsServer.GetCurrentSessionDate();
	DocObject.Status = Enums.ConsolidatedRetailSalesStatuses.Cancel;
	DocObject.Write(DocumentWriteMode.Posting);
EndProcedure

Function IsClosedRetailDocument(DocRef) Export
	If Not FOServer.IsUseConsolidatedRetailSales() Then
		Return False;
	EndIf;
	
	Return ValueIsFilled(DocRef) And ValueIsFilled(DocRef.ConsolidatedRetailSales) 
			And DocRef.ConsolidatedRetailSales.Status = Enums.ConsolidatedRetailSalesStatuses.Close
			And DocRef.ConsolidatedRetailSales.Posted;
EndFunction

Function UseConsolidatedRetailSales(Branch, SalesReturnData = Undefined) Export
	Result = FOServer.IsUseConsolidatedRetailSales() 
		And ValueIsFilled(Branch)
		And Branch.UseConsolidatedRetailSales;
	If SalesReturnData = Undefined Then
		Return Result;
	EndIf;
	
	// for return document
	If Not SalesReturnData.ArrayOfSalesDocuments.Count() Then
		Return False;
	EndIf;
	
	IsSameDay = False;
	SalesReturnDate = ?(ValueIsFilled(SalesReturnData.Date), SalesReturnData.Date, CommonFunctionsServer.GetCurrentSessionDate());
	For Each SalesDocument In SalesReturnData.ArrayOfSalesDocuments Do
		If BegOfDay(SalesDocument.Date) = BegOfDay(SalesReturnDate) Then
			IsSameDay = True;
			Break;
		EndIf;
	EndDo;
	Return IsSameDay;
EndFunction

#EndRegion

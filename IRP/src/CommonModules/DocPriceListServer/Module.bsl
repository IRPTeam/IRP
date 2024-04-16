#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, );
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

Function GetChequeInfo(ChequeBondTransactionRef, ChequeRef) Export
	StatusDate = New Boundary(ChequeBondTransactionRef.Date, BoundaryType.Excluding);
	 
	Info = New Structure("Status, Amount, NewStatus, Currency");
	Info.Status = ObjectStatusesServer.GetLastStatusInfoByCheque(StatusDate, ChequeRef).Status;
	If Not ValueIsFilled(Info.Status) Then
		Info.NewStatus = ObjectStatusesServer.GetStatusByDefaultForCheque(ChequeRef);
	EndIf;
		
	Info.Amount = ChequeRef.Amount;
	Info.Currency = ChequeRef.Currency;
	Return Info;
EndFunction

#EndRegion

Function GetInfoForFillingBankDocument(ChequeRef) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Account,
	|	Doc.Company,
	|	Doc.Cheque.Amount AS Amount,
	|	Doc.Cheque.Currency AS Currency
	|FROM
	|	Document.ChequeBondTransactionItem AS Doc
	|WHERE
	|	Doc.Ref = &Ref";
	Query.SetParameter("Ref", ChequeRef);
	
	Result = New Structure("Company, Account, Currency, Amount");
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

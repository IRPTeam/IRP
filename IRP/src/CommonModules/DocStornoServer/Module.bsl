#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	DocumentsServer.ShowUserMessageOnCreateAtServer(Form);
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Return;
EndProcedure

#EndRegion

#Region LIST_FROM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function IsDocumentWithStorno(DocRef, StornoRef = Undefined) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Storno.Ref
	|FROM
	|	Document.Storno AS Storno
	|WHERE
	|	Storno.Posted
	|	AND Storno.Basis = &Basis
	|	AND CASE
	|		WHEN &Filter_Ref
	|			THEN Storno.Ref <> &Ref
	|		ELSE TRUE
	|	END";
	Query.SetParameter("Basis", DocRef);
	Query.SetParameter("Filter_Ref", ValueIsFilled(StornoRef));
	Query.SetParameter("Ref", StornoRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	EndIf;
	Return Undefined;
Endfunction

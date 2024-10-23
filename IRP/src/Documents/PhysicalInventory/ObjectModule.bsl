Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
	RowIDInfoPrivileged.BeforeWrite_RowID(ThisObject, Cancel, WriteMode, PostingMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	RowIDInfoPrivileged.OnWrite_RowID(ThisObject, Cancel);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.Posting_RowID(ThisObject, Cancel, PostingMode);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.UndoPosting_RowIDUndoPosting(ThisObject, Cancel);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.Status.Posting Then
		Query = New Query();
		Query.Text =
		"SELECT
		|	PhysicalCountByLocation.Ref
		|FROM
		|	Document.PhysicalCountByLocation AS PhysicalCountByLocation
		|WHERE
		|	NOT PhysicalCountByLocation.DeletionMark
		|	AND PhysicalCountByLocation.PhysicalInventory = &PhysicalInventory
		|	AND
		|	NOT PhysicalCountByLocation.Status.Posting";
		Query.SetParameter("PhysicalInventory", ThisObject.Ref);
		QueryResult = Query.Execute();
		QuerySelection = QueryResult.Select();
		If QuerySelection.Next() Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_075, "Object.Status");
			Cancel = True;
		EndIf;
	EndIf;
	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;
EndProcedure

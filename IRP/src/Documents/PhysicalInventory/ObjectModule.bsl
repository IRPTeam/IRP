
Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
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
EndProcedure

Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

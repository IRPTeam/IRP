
Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
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
	EndIf;
EndProcedure



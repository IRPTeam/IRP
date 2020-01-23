&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	// Add to tree delivery list
	AddToTree_DeliveryList(Parameters.DeliveryList);
EndProcedure

&AtServer
Procedure AddToTree_DeliveryList(ArrayOfDeliveryList)
	Query = New Query();
	Query.Text =
		"SELECT
		|	DeliveryList.Ref AS Ref
		|INTO tmp
		|FROM
		|	Document.DeliveryList AS DeliveryList
		|WHERE
		|	DeliveryList.Ref IN(&ArrayOfDeliveryList)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	DeliveryList.Ref AS Ref,
		|	CASE
		|		WHEN NOT tmp.Ref IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS Selected
		|FROM
		|	Document.DeliveryList AS DeliveryList
		|		LEFT JOIN tmp AS tmp
		|		ON (tmp.Ref = DeliveryList.Ref)
		|WHERE
		|	NOT DeliveryList.DeletionMark
		|	AND DeliveryList.Condition = VALUE(enum.DeliveryConditions.ForLoading)";
	Query.SetParameter("ArrayOfDeliveryList", ArrayOfDeliveryList);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Group_DeliveryList = TaskTree.GetItems().Add();
	Group_DeliveryList.Presentation = R()["TrackList_001"];
	Group_DeliveryList.GroupName = "DeliveryList";
	Group_DeliveryList.IsGroup = True;
	
	While QuerySelection.Next() Do
		Row_DeliveryList = Group_DeliveryList.GetItems().Add();
		Row_DeliveryList.Task = QuerySelection.Ref;
		Row_DeliveryList.Selected = QuerySelection.Selected;
		Row_DeliveryList.Presentation = Documents.DeliveryList.PresentationAsTask(QuerySelection.Ref);
	EndDo;
EndProcedure

&AtClient
Procedure TaskTreeBeforeAddRow(Item, Cancel, Clone, Parent, Folder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TaskTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = PrepareResult();
	Close(Result);
EndProcedure

&AtServer
Function PrepareResult()
	Result = New Structure();
	Result.Insert("DeliveryList", New Array());
	For Each Row In TaskTree.GetItems() Do
		
		// Delivery list
		If Row.GroupName = "DeliveryList" Then
			For Each SubRow In Row.GetItems() Do
				If SubRow.Selected Then
					Result.DeliveryList.Add(SubRow.Task);
				EndIf;
			EndDo;
		EndIf;
		
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure


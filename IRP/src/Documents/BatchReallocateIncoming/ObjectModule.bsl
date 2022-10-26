
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

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ItemList.LineNumber AS LineNumber,
	|	CAST(ItemList.Store AS Catalog.Stores) AS Store
	|into ttItemList
	|FROM
	|	&ItemList AS ItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Store AS Store,
	|	ItemList.Store.Company AS StoreCompany
	|FROM
	|	ttItemList AS ItemList
	|
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("ItemList", ThisObject.ItemList.Unload());
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		If ValueIsFilled(QuerySelection.StoreCompany) And Not QuerySelection.StoreCompany = ThisObject.Company Then
			Cancel = True;
			MessageText = StrTemplate(
				R().Error_Store_Company_Row,
				QuerySelection.Store,
				ThisObject.Company, 
				QuerySelection.LineNumber);
			CommonFunctionsClientServer.ShowUsersMessage(
				MessageText, 
				"Object.ItemList[" + (QuerySelection.LineNumber - 1) + "].Store", 
				"Object.ItemList");
		EndIf;
	EndDo;
	
EndProcedure

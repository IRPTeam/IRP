Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	RowIDInfoServer.BeforeWrite_RowID(ThisObject, Cancel, WriteMode, PostingMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	RowIDInfoServer.OnWrite_RowID(ThisObject, Cancel);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	RowIDInfoServer.Posting_RowID(ThisObject, Cancel, PostingMode);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	RowIDInfoServer.UndoPosting_RowIDUndoPosting(ThisObject, Cancel);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		FillPropertyValues(ThisObject, FillingData, RowIDInfoServer.GetSeparatorColumns(ThisObject.Metadata()));
		RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_PRR(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(, "Key, LineNumber, ItemKey, Store");
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS Key,
	|	CAST(ItemList.Store AS Catalog.Stores) AS Store
	|into ttItemList
	|FROM
	|	&ItemList AS ItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfo.Key AS Key,
	|	RowIDInfo.Basis AS Basis
	|into ttRowIDInfo
	|FROM
	|	&RowIDInfo AS RowIDInfo
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Store AS Store,
	|	ItemList.Store.Company AS StoreCompany,
	|	RowIDInfo.Basis AS Basis
	|FROM
	|	ttItemList AS ItemList
	|		LEFT JOIN ttRowIDInfo AS RowIDInfo
	|		ON ItemList.Key = RowIDInfo.Key
	|
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("ItemList", ThisObject.ItemList.Unload());
	Query.SetParameter("RowIDInfo", ThisObject.RowIDInfo.Unload());
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		If ValueIsFilled(QuerySelection.Basis) Then
			Continue;
		ElsIf ValueIsFilled(QuerySelection.StoreCompany) And Not QuerySelection.StoreCompany = ThisObject.Company Then
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
	If Not ThisObject.Company.IsEmpty() And Not ThisObject.Store.IsEmpty() Then
		StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.Store, "Company");
		If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
			Cancel = True;
			MessageText = StrTemplate(
				R().Error_Store_Company,
				ThisObject.Store,
				ThisObject.Company);
			CommonFunctionsClientServer.ShowUsersMessage(
				MessageText, 
				"Object.Store", 
				"Object");
		EndIf;
	EndIf;
	
EndProcedure

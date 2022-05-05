#Region EventHandlers

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	If Not FOServer.IsUseItemKey() Then
		AutoCreateItemKey();
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	PackageUnit = Undefined;
EndProcedure

#EndRegion

#Region Private

Procedure AutoCreateItemKey()
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	Table.Ref
	|FROM 
	|	Catalog.ItemKeys AS Table
	|WHERE
	|	Table.Item = &Item";
	Query.SetParameter("Item", ThisObject.Ref);
	QueryResult = Query.Execute();
	If QueryResult.IsEmpty() Then
		NewItem = Catalogs.ItemKeys.CreateItem();
		FillPropertyValues(NewItem, ThisObject, , "Parent, Owner, Ref, Unit, Code");
		NewItem.Item = ThisObject.Ref;
		NewItem.Write();
	Else
		QuerySelection = QueryResult.Select();
		While QuerySelection.Next() Do
			ExistsItem = QuerySelection.Ref.GetObject();
			ExistsItem.DeletionMark = ThisObject.DeletionMark;
			ExistsItem.Write();
		EndDo;
	EndIf;
EndProcedure

#EndRegion
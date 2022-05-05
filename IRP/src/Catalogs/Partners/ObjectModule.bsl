Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	If Not FOServer.IsUseCompanies() Then
		AutoCreateLegalName();
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure AutoCreateLegalName()
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	Table.Ref
	|FROM 
	|	Catalog.Companies AS Table
	|WHERE
	|	Table.Partner = &Partner";
	Query.SetParameter("Partner", ThisObject.Ref);
	QueryResult = Query.Execute();
	If QueryResult.IsEmpty() Then
		NewItem = Catalogs.Companies.CreateItem();
		FillPropertyValues(NewItem, ThisObject, , "Parent, Owner, Ref, Code");
		NewItem.Type = Enums.CompanyLegalType.Company;
		NewItem.Partner = ThisObject.Ref;
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

﻿#Region WriteDataToCatalog

Function FindCatalogItem(Deep, Parent, Level, Value, Country, IDInfoType)
	Result = New Structure("Success, Ref", False, Undefined);

	ConditionString = "Parent";
	For i = 2 To Deep Do
		ConditionString = ConditionString + ".Parent";
	EndDo;

	Query = New Query();
	Query.Text =
	"SELECT
	|	IDInfoAddresses.Ref AS Ref
	|FROM
	|	Catalog.IDInfoAddresses AS IDInfoAddresses
	|WHERE
	|	IDInfoAddresses.%1 = VALUE(Catalog.IDInfoAddresses.EmptyRef)
	|	AND IDInfoAddresses.Country = &Country
	|	AND IDInfoAddresses.Parent = &Parent
	|	AND IDInfoAddresses.Level = &Level
	|	AND IDInfoAddresses.Description_en = &Value
	|	AND IDInfoAddresses.Owner = &Owner
	|	AND NOT IDInfoAddresses.DeletionMark";

	Query.Text = StrTemplate(Query.Text, ConditionString);
	Query.SetParameter("Country", Country);
	Query.SetParameter("Level", Level);
	Query.SetParameter("Value", Value);
	Query.SetParameter("Parent", ?(ValueIsFilled(Parent), Parent, Catalogs.IDInfoAddresses.EmptyRef()));
	Query.SetParameter("Owner", IDInfoType);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Result.Success = True;
		Result.Ref = QuerySelection.Ref;
		Return Result;
	Else
		Return Result;
	EndIf;
EndFunction

Function CreateCatalogItem(Parent, Level, Value, Country, IDInfoType)
	Result = New Structure("Success, Ref, ErrorMessage", False, Undefined, "");

	NewItem = Catalogs.IDInfoAddresses.CreateItem();
	NewItem.Owner = IDInfoType;
	NewItem.Parent = Parent;
	NewItem.Level = Level;
	If TypeOf(Value) = Type("Structure") Then
		FillPropertyValues(NewItem, Value);
	Else
		NewItem.Description_en = Value;
	EndIf;

	NewItem.Country = Country;
	Try
		NewItem.Write();
	Except
		Result.ErrorMessage = String(ErrorDescription());
		Return Result;
	EndTry;

	Result.Success = True;
	Result.Ref = NewItem.Ref;

	Return Result;
EndFunction

Function WriteDataToCatalog(Values, Country, IDInfoType) Export
	Deep = 1;
	CurrentParent = Catalogs.IDInfoAddresses.EmptyRef();
	BeginTransaction(DataLockControlMode.Managed);
	Try
		For Each Row In Values Do
			If CommonFunctionsClientServer.ObjectHasProperty(Row, "Value") Then
				CatalogItem = FindCatalogItem(Deep, CurrentParent, Row.Level, Row.Value, Country, IDInfoType);
			Else
				CatalogItem = FindCatalogItem(Deep, CurrentParent, Row.Description_en, Row.Description_en, Country, IDInfoType);
			EndIf;
			
			If Not CatalogItem.Success Then
				If CommonFunctionsClientServer.ObjectHasProperty(Row, "Value") Then
					CatalogItem = CreateCatalogItem(CurrentParent, Row.Level, Row.Value, Country, IDInfoType);
				Else
					DescriptionStructure = New Structure();
					DescriptionStructure.Insert("Description_en"   , Row.Description_en);
					DescriptionStructure.Insert("Description_ru"   , Row.Description_ru);
					DescriptionStructure.Insert("Description_tr"   , Row.Description_tr);
					DescriptionStructure.Insert("Description_hash" , Row.Description_hash);
					CatalogItem = CreateCatalogItem(CurrentParent, Row.Level, DescriptionStructure, Country, IDInfoType);
				EndIf;
				
				If Not CatalogItem.Success Then
					Raise CatalogItem.ErrorMessage;
				Else
					CurrentParent = CatalogItem.Ref;
				EndIf;
			Else
				CurrentParent = CatalogItem.Ref;
			EndIf;
			Deep = Deep + 1;
		EndDo;
		CommitTransaction();
	Except
		RollbackTransaction();
		Raise ErrorDescription();
	EndTry;

	Return CatalogItem.Ref;
EndFunction

#EndRegion

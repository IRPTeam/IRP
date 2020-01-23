
Function GetJoinDocumentsStructureParameters() Export
	Parameters = New Structure();
	
	Parameters.Insert("HaveItemList", False);
	Parameters.Insert("ItemListColumnNames", New Structure());
	
	Parameters.Insert("HaveTaxList", False);
	Parameters.Insert("TaxListColumnNames", New Structure());
	Parameters.Insert("FieldsForLinkTaxListToItemList", New Structure("Key", "Key"));
	
	Parameters.Insert("HaveSpecialOffers", False);
	Parameters.Insert("SpecialOffersColumnNames", New Structure());
	Parameters.Insert("FieldsForLinkSpecialOffersToItemList", New Structure("Key", "Key"));
	
	Parameters.Insert("UnjoinFileds", Undefined);
	Return Parameters;
EndFunction

Function JoinDocumentsStructure(Parameters, ArrayOfTables) Export
	
	ItemList = Undefined;
	If Parameters.Property("HaveItemList") And Parameters.HaveItemList Then
		ItemList = CreateColumns(Parameters, "ItemListColumnNames");
		ArrayOfTablesToValueTable(ArrayOfTables, ItemList, "ItemList");
	EndIf;
	
	TaxList = Undefined;
	If Parameters.Property("HaveTaxList") And Parameters.HaveTaxList Then
		TaxList = CreateColumns(Parameters, "TaxListColumnNames");
		ArrayOfTablesToValueTable(ArrayOfTables, TaxList, "TaxList");
	EndIf;
	
	SpecialOffers = Undefined;
	If Parameters.Property("HaveSpecialOffers") And Parameters.SpecialOffers Then
		SpecialOffers = CreateColumns(Parameters, "SpecialOffersColumnNames");
		ArrayOfTablesToValueTable(ArrayOfTables, SpecialOffers, "SpecialOffers");
	EndIf;
	
	ArrayOfResults = New Array();
	If ItemList = Undefined Then
		Return ArrayOfResults;
	EndIf;
	
	ItemListCopy = ItemList.Copy();
	ItemListCopy.GroupBy(Parameters.UnjoinFileds);
	
	For Each Row In ItemListCopy Do
		Result = New Structure(Parameters.UnjoinFileds);
		FillPropertyValues(Result, Row);
		
		Result.Insert("ItemList", New Array());
		Result.Insert("TaxList", New Array());
		Result.Insert("SpecialOffers", New Array());
		
		Filter = New Structure(Parameters.UnjoinFileds);
		FillPropertyValues(Filter, Row);
		
		ArrayOfTaxListFilters = New Array();
		ArrayOfSpecialOffersFilters = New Array();
		
		ItemListFiltered = ItemList.Copy(Filter);
		For Each RowItemList In ItemListFiltered Do
			NewRowItemList = New Structure();
			
			For Each ColumnItemList In ItemListFiltered.Columns Do
				NewRowItemList.Insert(ColumnItemList.Name, RowItemList[ColumnItemList.Name]);
			EndDo;
			
			NewRowItemList.Key = New UUID(RowItemList.RowKey);
			
			ArrayOfTaxListFilters.Add(GetFiterForLinkTables(Parameters, 
															NewRowItemList,
															"FieldsForLinkSpecialOffersToItemList"));
			
			ArrayOfSpecialOffersFilters.Add(GetFiterForLinkTables(Parameters, 
																  NewRowItemList, 
																  "FieldsForLinkSpecialOffersToItemList"));
			Result.ItemList.Add(NewRowItemList);
		EndDo;
		
		If TaxList <> Undefined Then
			FillLinkedTable(ArrayOfTaxListFilters, TaxList, Result.TaxList);
		EndIf;
		
		If SpecialOffers <> Undefined Then
			FillLinkedTable(ArrayOfSpecialOffersFilters, SpecialOffers, Result.SpecialOffers);
		EndIf;
		
		ArrayOfResults.Add(Result);
	EndDo;	
	Return ArrayOfResults;
EndFunction

Function CreateColumns(Parameters, PropertyName)
	ValueTable = New ValueTable();
	If Parameters.Property(PropertyName) 
			And Parameters[PropertyName] <> Undefined Then
		For Each Column In Parameters[PropertyName] Do
			ValueTable.Columns.Add(Column.Key, Column.Value);
		EndDo;
	EndIf;
	Return ValueTable;
EndFunction

Procedure ArrayOfTablesToValueTable(ArrayOfTables, ValueTable, PropertyName)
	For Each ItemOfTables In ArrayOfTables Do
		For Each Row In ItemOfTables[PropertyName] Do
			FillPropertyValues(ValueTable.Add(), Row);
		EndDo;
	EndDo;
EndProcedure

Function GetFiterForLinkTables(Parameters, RowItemList, PropertyName)
	Filter = New Structure();
	If Parameters.Property(PropertyName) Then		
		For Each FilterField In Parameters[PropertyName] Do
			Filter.Insert(FilterField.Key, RowItemList[FilterField.Value]);
		EndDo;
	EndIf;
	Return Filter;
EndFunction

Procedure FillLinkedTable(ArrayOfFilters, ValueTable, ArrayOfResult)
	For Each Filter In ArrayOfFilters Do
		ValueTableFiltered = ValueTable.Copy(Filter);
		For Each Row In ValueTableFiltered Do
			NewRow = New Structure();
			For Each Column In ValueTableFiltered.Columns Do
				NewRow.Insert(Column.Name, Row[Column.Name]);
			EndDo;
			ArrayOfResult.Add(NewRow);
		EndDo;
	EndDo;
EndProcedure
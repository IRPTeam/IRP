Function CheckChequeBondsOfCurrency(ChequeBonds, Currency) Export
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	ChequeBonds.Ref
		|FROM
		|	Catalog.ChequeBonds AS ChequeBonds
		|WHERE
		|	ChequeBonds.Ref IN (&ChequeBonds)
		|	AND Not ChequeBonds.Currency = &Currency";
	
	Query.SetParameter("ChequeBonds", ChequeBonds);
	Query.SetParameter("Currency", Currency);
	
	QueryResult = Query.Execute();
	
	Return QueryResult.Unload().UnloadColumn("Ref");
	
EndFunction
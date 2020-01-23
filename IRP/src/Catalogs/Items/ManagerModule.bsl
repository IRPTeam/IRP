Function GetArrayOfItemKeysByItem(Item) Export
	Query = New Query(
			"SELECT ALLOWED
			|	ItemKeys.Ref
			|FROM
			|	Catalog.ItemKeys AS ItemKeys
			|WHERE
			|	ItemKeys.Item = &Item");
	Query.SetParameter("Item", Item);
	Return Query.Execute().Unload().UnloadColumn("Ref");
EndFunction

Function GetTableOfItemKeysInfoByItems(Items) Export
	Query = New Query;
	Query.Text = "SELECT
		|	ItemKeys.Ref AS ItemKey,
		|	CASE
		|		WHEN ItemKeys.Unit = VALUE(Catalog.Units.EmptyRef)
		|			THEN ItemKeys.Item.Unit
		|		ELSE ItemKeys.Unit
		|	END AS Unit,
		|	ItemKeys.Item,
		|	ItemKeys.AffectPricingMD5
		|FROM
		|	Catalog.ItemKeys AS ItemKeys
		|WHERE
		|	NOT ItemKeys.DeletionMark
		|	AND
		|	NOT ItemKeys.Item.DeletionMark
		|	AND ItemKeys.Item In (&Items)";
	
	Query.SetParameter("Items", Items);
	Return Query.Execute().Unload();
	
EndFunction
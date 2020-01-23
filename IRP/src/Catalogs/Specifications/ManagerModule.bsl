Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	If Not Parameters.Filter.Property("CustomFilterByItem") Then
		ChoiceData = New ValueList();
		Return;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT TOP 50
		|	Specifications.Ref
		|FROM
		|	Catalog.Specifications AS Specifications
		|WHERE
		|	Specifications.Ref IN (&ArrayOfRef)
		|	AND Specifications.Description_en LIKE ""%"" + &SearchString + ""%""
		|GROUP BY
		|	Specifications.Ref";
	
	Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text);
	Query.SetParameter("ArrayOfRef", GetAvailableSpecificationsByItem(Parameters.Filter.CustomFilterByItem));
	Query.SetParameter("SearchString", Parameters.SearchString);
	
	ChoiceData = New ValueList();
	ChoiceData.LoadValues(Query.Execute().Unload().UnloadColumn("Ref"));
EndProcedure

Function GetAvailableSpecificationsByItem(Item) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	SpecificationsDataSet.Ref
		|FROM
		|	Catalog.Specifications.DataSet AS SpecificationsDataSet
		|WHERE
		|	SpecificationsDataSet.Item = &ItemType
		|	AND SpecificationsDataSet.Ref.Type = Value(Enum.SpecificationType.Set)
		|GROUP BY
		|	SpecificationsDataSet.Ref
		|
		|UNION
		|
		|SELECT
		|	Specifications.Ref
		|FROM
		|	Catalog.Specifications AS Specifications
		|WHERE
		|	Specifications.Type = Value(Enum.SpecificationType.Bundle)
		|	AND Specifications.ItemBundle = &Item
		|GROUP BY
		|	Specifications.Ref";
	Query.SetParameter("ItemType", Item.ItemType);
	Query.SetParameter("Item", Item);
	
	QueryResult = Query.Execute();
	Return QueryResult.Unload().UnloadColumn("Ref");
EndFunction

Function FindOrCreateRefByProperties(TableOfItems, QuantityTable, ItemBundle, AddInfo = Undefined) Export
	ArrayOfRefs = GetRefsByProperies(TableOfItems, QuantityTable, ItemBundle, AddInfo);
	If ArrayOfRefs.Count() Then
		Return ArrayOfRefs;
	Else
		ArrayOfResults = New Array();
		ArrayOfResults.Add(CreateRefByProperties(TableOfItems, QuantityTable, ItemBundle, AddInfo));
		Return ArrayOfResults;
	EndIf;
EndFunction

Function CreateRefByProperties(TableOfItems, QuantityTable, ItemBundle, AddInfo = Undefined) Export
	NewObject = Catalogs.Specifications.CreateItem();
	NewObject.ItemBundle = ItemBundle;
	NewObject.Type = GetSpecificationType(TableOfItems, AddInfo);
	
	SetDescriptionbyTableOfItems(NewObject, TableOfItems, AddInfo);
	
	TableOfItemsCopy = TableOfItems.Copy();
	TableOfItemsCopy.GroupBy("Key");
	
	For Each ItemRow In TableOfItemsCopy Do
		RowFilter = New Structure("Key", ItemRow.Key);
		DataSet = TableOfItems.FindRows(RowFilter);
		
		For Each DataSetRow In DataSet Do
			NewRowDataSet = NewObject.DataSet.Add();
			NewRowDataSet.Key = ItemRow.Key;
			
			If NewObject.Type = Enums.SpecificationType.Bundle Then
				NewRowDataSet.Item = DataSetRow.Item;
			ElsIf NewObject.Type = Enums.SpecificationType.Set Then
				NewRowDataSet.Item = DataSetRow.Item.ItemType;
			Else
				NewRowDataSet.Item = Undefined;
			EndIf;
			
			NewRowDataSet.Attribute = DataSetRow.Attribute;
			NewRowDataSet.Value = DataSetRow.Value;
		EndDo;
		
		ArrayOfQuantity = QuantityTable.FindRows(RowFilter);
		
		NewRowDataQuantity = NewObject.DataQuantity.Add();
		NewRowDataQuantity.Key = ItemRow.Key;
		NewRowDataQuantity.Quantity = ?(ArrayOfQuantity.Count(), ArrayOfQuantity[0].Quantity, 0);
	EndDo;
	NewObject.Write();
	Return NewObject.Ref;
EndFunction

Function GetRefsByProperies(TableOfItems, QuantityTable, ItemBundle, AddInfo = Undefined) Export
	ArrayOfFoundedSpecifications = New Array();
	SpecificationType = GetSpecificationType(TableOfItems, AddInfo);
	For Each ItemRow In TableOfItems Do
		ArrayOfQuantity = QuantityTable.FindRows(New Structure("Key", ItemRow.Key));
		Quantity = ?(ArrayOfQuantity.Count(), ArrayOfQuantity[0].Quantity, 0);
		ArrayOfFoundedSpecifications = GetRefsByOneProperty(ArrayOfFoundedSpecifications
				, ItemBundle
				, SpecificationType
				, ItemRow.Item
				, ItemRow.Attribute
				, ItemRow.Value
				, Quantity);
		
		If Not ArrayOfFoundedSpecifications.Count() Then
			Break;
		EndIf;
	EndDo;
	
	If Not ArrayOfFoundedSpecifications.Count() Then
		Return ArrayOfFoundedSpecifications;
	EndIf;
	
	ArrayOfVerifiedSpecifications = New Array();
	For Each Specification In ArrayOfFoundedSpecifications Do
		If VerifySpecification(Specification, TableOfItems, SpecificationType) Then
			ArrayOfVerifiedSpecifications.Add(Specification);
		EndIf;
	EndDo;
	
	Return ArrayOfVerifiedSpecifications;
EndFunction

Function VerifySpecification(Specification, TableOfItem, SpecificationType)
	Query = New Query();
	Query.Text =
		"SELECT
		|	tmp.Item,
		|	tmp.Attribute,
		|	tmp.Value
		|INTO tmp
		|FROM
		|	&TableOfItem AS tmp
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecificationsDataSet.Item,
		|	SpecificationsDataSet.Attribute,
		|	SpecificationsDataSet.Value
		|INTO DataSet
		|FROM
		|	Catalog.Specifications.DataSet AS SpecificationsDataSet
		|WHERE
		|	SpecificationsDataSet.Ref = &Specification
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	DataSet.Item AS Item,
		|	DataSet.Attribute AS Attribute,
		|	DataSet.Value AS Value
		|FROM
		|	DataSet AS DataSet
		|		LEFT JOIN tmp AS tmp
		|		ON CASE
		|			WHEN &SpecificationType = VALUE(Enum.SpecificationType.Set)
		|				THEN DataSet.Item = tmp.Item.ItemType
		|			WHEN &SpecificationType = VALUE(Enum.SpecificationType.Bundle)
		|				THEN DataSet.Item = tmp.Item
		|			ELSE FALSE
		|		END
		|		AND DataSet.Attribute = tmp.Attribute
		|		AND DataSet.Value = tmp.Value
		|WHERE
		|	tmp.Item IS NULL
		|	AND tmp.Attribute IS NULL
		|	AND tmp.Value IS NULL";
	Query.SetParameter("TableOfItem", TableOfItem);
	Query.SetParameter("Specification", Specification);
	Query.SetParameter("SpecificationType", SpecificationType);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Return Not QuerySelection.Next();
EndFunction

Function GetRefsByOneProperty(ArrayOfFoundedSpecifications, 
                              ItemBundle, 
                              SpecificationType, 
                              Item, 
                              Attribute, 
                              Value, 
                              Quantity)
	Query = New Query();
	Query.Text =
		"SELECT
		|	SpecificationsDataSet.Ref
		|FROM
		|	Catalog.Specifications.DataSet AS SpecificationsDataSet
		|		INNER JOIN Catalog.Specifications.DataQuantity AS SpecificationsDataQuantity
		|		ON SpecificationsDataQuantity.Ref = SpecificationsDataSet.Ref
		|		AND SpecificationsDataQuantity.Key = SpecificationsDataSet.Key
		|		AND SpecificationsDataQuantity.Ref.ItemBundle = &ItemBundle
		|		AND SpecificationsDataQuantity.Ref.Type = &Type
		|		AND SpecificationsDataSet.Ref.ItemBundle = &ItemBundle
		|		AND SpecificationsDataSet.Ref.Type = &Type
		|		AND SpecificationsDataSet.Item = &Item
		|		AND SpecificationsDataSet.Attribute = &Attribute
		|		AND SpecificationsDataSet.Value = &Value
		|		AND SpecificationsDataQuantity.Quantity = &Quantity
		|		AND CASE
		|			WHEN &Filter_ArrayOfResults
		|				THEN SpecificationsDataQuantity.Ref IN (&ArrayOfResults)
		|				AND SpecificationsDataSet.Ref IN (&ArrayOfResults)
		|			ELSE TRUE
		|		END
		|GROUP BY
		|	SpecificationsDataSet.Ref";
	Query.SetParameter("ItemBundle", ItemBundle);
	Query.SetParameter("Type", SpecificationType);
	If SpecificationType = Enums.SpecificationType.Bundle Then
		Query.SetParameter("Item", Item);
	ElsIf SpecificationType = Enums.SpecificationType.Set Then
		Query.SetParameter("Item", Item.ItemType);
	Else
		Query.SetParameter("Item", Undefined);
	EndIf;
	Query.SetParameter("Attribute", Attribute);
	Query.SetParameter("Value", Value);
	Query.SetParameter("Quantity", Quantity);
	Query.SetParameter("Filter_ArrayOfResults", ArrayOfFoundedSpecifications.Count() <> 0);
	Query.SetParameter("ArrayOfResults", ArrayOfFoundedSpecifications);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable.UnloadColumn("Ref");
EndFunction

Function GetSpecificationType(TableOfItems, AddInfo = Undefined) Export
	TableOfItemsCopy = TableOfItems.Copy();
	TableOfItemsCopy.GroupBy("Item");
	Return ?(TableOfItemsCopy.Count() > 1, Enums.SpecificationType.Bundle, Enums.SpecificationType.Set);
EndFunction

Procedure SetDescriptionbyTableOfItems(NewObject, TableOfItems, AddInfo = Undefined)
	ArrayOfDescriptions = LocalizationReuse.AllDescription(AddInfo);
	
	TableOfItemsCopy = TableOfItems.Copy();
	TableOfItemsCopy.GroupBy("Item");
	
	For Each Desc In ArrayOfDescriptions Do
		LangCode = StrReplace(Desc, "Description_", "");
		ArrayOfItemDescriptions = New Array();
		For Each ItemRow In TableOfItemsCopy Do
			ArrayOfItemDescriptions.Add(
				LocalizationReuse.CatalogDescription(ItemRow.Item, LangCode, AddInfo));
		EndDo;
		NewObject[Desc] = StrConcat(ArrayOfItemDescriptions, "+");
	EndDo;
EndProcedure
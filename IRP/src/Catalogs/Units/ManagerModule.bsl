Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	
	FilterItem = Undefined;
	If Not Parameters.Filter.Property("Item", FilterItem) Then
		If Not Parameters.Filter.Property("ItemKey") Then
			ChoiceData = New ValueList();
			Return;
		Else
			FilterItem = ?(TypeOf(Parameters.Filter.ItemKey) = Type("CatalogRef.ItemKeys"),
					Parameters.Filter.ItemKey.Item,
					Undefined);
		EndIf;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT TOP 50
		|	Table.Ref
		|FROM
		|	Catalog.Units AS Table
		|WHERE
		|	(Table.Item = &Item
		|	OR Table.Item = VALUE(Catalog.Items.EmptyRef))
		|	AND Table.Description_en LIKE &SearchString";
	
	Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text);
	Query.SetParameter("Item", FilterItem);
	Query.SetParameter("SearchString", "%" + Parameters.SearchString + "%");
	
	ChoiceData = New ValueList();
	ChoiceData.LoadValues(Query.Execute().Unload().UnloadColumn("Ref"));
EndProcedure

Function GetUnitFactor(FromUnit, ToUnit = Undefined) Export
	If FromUnit = ToUnit Then
		Return ?(ToUnit = Undefined, 0, ToUnit.Quantity);
	EndIf;
	
	If ToUnit <> Undefined Then
		Result = New Array();
		GetUnitFactorRecursy(FromUnit, ToUnit, Result);
		Factor = 1;
		For Each Value In Result Do
			Factor = Factor * Value;
		EndDo;
		Return Factor;
	Else
		Return 0;
	EndIf;
EndFunction

Procedure GetUnitFactorRecursy(FromUnit, ToUnit, Result)
	If ValueIsFilled(FromUnit.BasisUnit) And FromUnit <> ToUnit Then
		Result.Add(FromUnit.Quantity);
		GetUnitFactorRecursy(FromUnit.BasisUnit, ToUnit, Result);
	EndIf;
EndProcedure


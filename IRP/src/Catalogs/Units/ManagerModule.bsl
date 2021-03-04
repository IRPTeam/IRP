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
	
	Filter = "
		|	AND (Table.Item = &Item
		|	OR Table.Item = VALUE(Catalog.Items.EmptyRef))
		|";

	Settings = New Structure;
	Settings.Insert("MetadataObject", Metadata.Catalogs.Units);
	Settings.Insert("Filter", Filter);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);

	Query = New Query(QueryBuilderText);
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
		GetUnitFactorRecursion(FromUnit, ToUnit, Result);
		Factor = 1;
		For Each Value In Result Do
			Factor = Factor * Value;
		EndDo;
		Return Factor;
	Else
		Return 0;
	EndIf;
EndFunction

Procedure GetUnitFactorRecursion(FromUnit, ToUnit, Result)
	If ValueIsFilled(FromUnit.BasisUnit) And FromUnit <> ToUnit Then
		Result.Add(FromUnit.Quantity);
		GetUnitFactorRecursion(FromUnit.BasisUnit, ToUnit, Result);
	EndIf;
EndProcedure

Function Convert(FromUnit, ToUnit, Quantity) Export
	If FromUnit = ToUnit Then
		Return Quantity;
	EndIf;
	
	// To unit
	Result = New Array();
	GetUnitFactorRecursion(ToUnit, FromUnit, Result);
	UnitFactorTo = 1;
	For Each Value In Result Do
		UnitFactorTo = UnitFactorTo * Value;
	EndDo;
	
	// From unit
	Result = New Array();
	GetUnitFactorRecursion(FromUnit, ToUnit, Result);
	UnitFactorFrom = 1;
	For Each Value In Result Do
		UnitFactorFrom = UnitFactorFrom * Value;
	EndDo;
	
	Return Quantity / UnitFactorTo * UnitFactorFrom;
EndFunction	

Function ConvertQuantityToQuantityInBaseUnit(ItemKey, Unit, Quantity) Export
	BasisUnit = GetBasisQuantity(ItemKey); 
	QuantityInBaseUnit =  Convert(Unit, BasisUnit, Quantity);
	Return New Structure("BasisUnit, QuantityInBaseUnit", BasisUnit, QuantityInBaseUnit);
EndFunction

Function GetBasisQuantity(ItemKey) Export
	If ValueIsFilled(ItemKey.Unit) Then
		Return ItemKey.Unit;
	Else
		Return ItemKey.Item.Unit;
	EndIf;
EndFunction

#Region LockAttributes

Function GetListLockedAttributes_IncludeObjects() Export
	Array = New Array;
	Return Array;
EndFunction

Function GetListLockedAttributes_ExcludeObjects() Export
	Array = New Array;
	Array.Add(Metadata.Catalogs.Items);
	Array.Add(Metadata.Catalogs.ItemKeys);
	Array.Add(Metadata.Catalogs.Units);
	Return Array;
EndFunction

Function GetListLockedAttributes_LockForOtherReason(Ref) Export
	Return False;
EndFunction
#EndRegion
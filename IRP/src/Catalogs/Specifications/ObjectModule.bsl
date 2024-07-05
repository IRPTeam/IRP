Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	// Checking uniqueness
	If Not Cancel And Not DeletionMark Then
		Query = New Query();
		Query.Text =
		"SELECT
		|	SpecificationsDataSet.Key AS Key,
		|	SpecificationsDataSet.Item AS Item,
		|	SpecificationsDataSet.Attribute AS Attribute,
		|	SpecificationsDataSet.Value AS Value
		|INTO tmp_DataSet
		|FROM
		|	&DataSet AS SpecificationsDataSet
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecificationsDataQuantity.Key AS Key,
		|	SpecificationsDataQuantity.Quantity AS Quantity
		|INTO tmp_DataQuantity
		|FROM
		|	&DataQuantity AS SpecificationsDataQuantity
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecificationItemList.Item AS Item,
		|	SpecificationItemList.ItemKey AS ItemKey,
		|	SpecificationItemList.Unit AS Unit,
		|	SpecificationItemList.Quantity AS Quantity
		|INTO tmp_ItemList
		|FROM
		|	&SpecificationItemList AS SpecificationItemList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_DataSet.Item AS Item,
		|	tmp_DataSet.Attribute AS Property,
		|	tmp_DataSet.Value AS Value,
		|	tmp_DataQuantity.Quantity AS Quantity,
		|	NULL AS Unit
		|FROM
		|	tmp_DataSet AS tmp_DataSet
		|		INNER JOIN tmp_DataQuantity AS tmp_DataQuantity
		|		ON tmp_DataSet.Key = tmp_DataQuantity.Key
		|
		|UNION ALL
		|
		|SELECT
		|	tmp_ItemList.Item,
		|	tmp_ItemList.ItemKey,
		|	NULL,
		|	tmp_ItemList.Quantity,
		|	tmp_ItemList.Unit
		|FROM
		|	tmp_ItemList AS tmp_ItemList";
		Query.SetParameter("DataSet", ThisObject.DataSet.Unload());
		Query.SetParameter("DataQuantity", ThisObject.DataQuantity.Unload());
		Query.SetParameter("SpecificationItemList", ThisObject.ItemList.Unload());
		QueryResult = Query.Execute();
		ThisObject.UniqueMD5 = AddAttributesAndPropertiesServer.GetMD5BySpecification(QueryResult.Unload());
		If ValueIsFilled(UniqueID.FindRefByUniqueMD5(ThisObject, ThisObject.UniqueMD5, True)) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_066);
		EndIf;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If Not (ThisObject.AdditionalProperties.Property("SynchronizeAffectPricingMD5")
		And Not ThisObject.AdditionalProperties.SynchronizeAffectPricingMD5) Then
		Catalogs.ItemKeys.SynchronizeAffectPricingMD5BySpecification(ThisObject.Ref);
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	UniqueMD5 = "";
EndProcedure

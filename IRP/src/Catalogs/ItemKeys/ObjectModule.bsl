
Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If ValueIsFilled(ThisObject.Specification) Then
		ThisObject.AddAttributes.Clear();
	EndIf;
	For Each Row In ThisObject.AddAttributes Do
		If TypeOf(Row.Value) = Type("Number") Then
			Row.SearchLiteral = String(Row.Value);
		EndIf;
	EndDo;

	ThisObject.SpecificationAffectPricingMD5.Clear();
	
	// Unique MD5
	If ValueIsFilled(ThisObject.Specification) Then
		ValueTable = New ValueTable();
		ValueTable.Columns.Add("SpecificationUniqueMD5");
		ValueTable.Columns.Add("Item");

		NewRow = ValueTable.Add();
		NewRow.SpecificationUniqueMD5 = ThisObject.Specification.UniqueMD5;
		NewRow.Item = String(ThisObject.Item.UUID());

		ThisObject.UniqueMD5 = CommonFunctionsServer.GetMD5(ValueTable);
		If ValueIsFilled(Catalogs.ItemKeys.FindRefByUniqueMD5(ThisObject, ThisObject.UniqueMD5)) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_065);
		EndIf;
	Else
		ValueTable = New ValueTable();
		ValueTable.Columns.Add("Property");
		ValueTable.Columns.Add("Value");
		ValueTable.Columns.Add("Item");

		If Not ThisObject.AddAttributes.Count() Then
			NewRow = ValueTable.Add();
			NewRow.Property = ChartsOfCharacteristicTypes.AddAttributeAndProperty.EmptyRef();
			NewRow.Value = Undefined;
			NewRow.Item = ThisObject.Item;
		Else
			For Each Row In ThisObject.AddAttributes Do
				NewRow = ValueTable.Add();
				NewRow.Property = Row.Property;
				NewRow.Value = Row.Value;
				NewRow.Item = ThisObject.Item;
			EndDo;
		EndIf;

		ThisObject.UniqueMD5 = AddAttributesAndPropertiesServer.GetMD5ByAddAttributes(ValueTable);
		If ValueIsFilled(Catalogs.ItemKeys.FindRefByUniqueMD5(ThisObject, ThisObject.UniqueMD5)) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_065);
		EndIf;
	EndIf;

	CheckResult = CheckDataPrivileged.CheckUnitForItemKey(ThisObject);
	If CheckResult.Error Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_138, 
			CheckResult.UnitFrom, CheckResult.UnitTo, CheckResult.Document));
	EndIf;

	If Cancel Then
		Return;
	EndIf;

	If AdditionalProperties.Property("SynchronizeAffectPricingMD5")
		And AdditionalProperties.SynchronizeAffectPricingMD5 Then

		If AdditionalProperties.Property("AffectPricingMD5") Then
			SetAffectPricingMD5(AdditionalProperties.AffectPricingMD5);
		EndIf;

		If AdditionalProperties.Property("TableOfAffectPricingMD5") Then
			SetSpecificationAffectPricingMD5(AdditionalProperties.TableOfAffectPricingMD5);
		EndIf;

	Else
		If ValueIsFilled(ThisObject.Item) And ValueIsFilled(ThisObject.Item.ItemType) Then
			If ValueIsFilled(ThisObject.Specification) Then
				
				// Set
				If ThisObject.Specification.Type = Enums.SpecificationType.Set Then
					SetSpecificationAffectPricingMD5(
						Catalogs.ItemKeys.CalculateMD5ForSet(ThisObject.Specification.DataQuantity.Unload(),
						ThisObject.Specification.DataSet.Unload(), ThisObject.Item, ThisObject.Item.ItemType));
				EndIf;
				
				// Bundle	
				If ThisObject.Specification.Type = Enums.SpecificationType.Bundle Then
					SetSpecificationAffectPricingMD5(
						Catalogs.ItemKeys.CalculateMD5ForBundle(ThisObject.Specification.DataQuantity.Unload(),
						ThisObject.Specification.DataSet.Unload(), ThisObject.Item, ThisObject.Item.ItemType));
				EndIf;

			Else
				
				// Regular
				SetAffectPricingMD5(
					AddAttributesAndPropertiesServer.GetAffectPricingMD5(ThisObject.Item, ThisObject.Item.ItemType,
					ThisObject.AddAttributes.Unload()));
			EndIf;
		EndIf;
	EndIf;

	Catalogs.ItemKeys.UpdateDescriptions(ThisObject);

EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	RefreshReusableValues();
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure SetAffectPricingMD5(AffectPricingMD5)
	ThisObject.AffectPricingMD5 = AffectPricingMD5;
EndProcedure

Procedure SetSpecificationAffectPricingMD5(TableOfAffectPricingMD5)
	ThisObject.SpecificationAffectPricingMD5.Load(TableOfAffectPricingMD5);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	CommissionTradeServer.FillCheckProcessing_ConsignorsInfo(Cancel, ThisObject);
	CheckDataPrivileged.FillCheckProcessing_Catalog_ItemKeys(Cancel, ThisObject);
EndProcedure

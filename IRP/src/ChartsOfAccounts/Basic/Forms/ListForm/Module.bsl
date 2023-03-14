
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText, "MasterExtraDimensions.ExtDimensionType");
	
	LedgerTypeVariants = AccountingServer.GetLedgerTypeVariants();
	ThisObject.Items.VariantFilter.ChoiceList.Add(Catalogs.LedgerTypeVariants.EmptyRef(), R().CLV_1);
	For Each Variant In LedgerTypeVariants Do
		ThisObject.Items.VariantFilter.ChoiceList.Add(Variant, String(Variant));
	EndDo;
	
	FilterIsSet = False;
	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "Variant" Then
			ThisObject.Variant = FilterItem.Value;
			Items.VariantFilter.Enabled = False;
			FilterIsSet = True;
		EndIf;
	EndDo;
	
	If Not FilterIsSet Then
		ThisObject.Variant = Catalogs.LedgerTypeVariants.EmptyRef();
	EndIf;
	
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "Variant", ThisObject.Variant,
		DataCompositionComparisonType.Equal, ValueIsFilled(ThisObject.Variant));	
EndProcedure

&AtClient
Procedure VariantFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "Variant", ThisObject.Variant,
		DataCompositionComparisonType.Equal, ValueIsFilled(ThisObject.Variant));
EndProcedure


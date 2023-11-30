
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText, "MasterExtraDimensions.ExtDimensionType");
	
	LedgerTypeVariants = AccountingServer.GetLedgerTypeVariants();
	ThisObject.Items.LedgerTypeVariantFilter.ChoiceList.Add(Catalogs.LedgerTypeVariants.EmptyRef(), R().CLV_1);
	For Each LedgerTypeVariant In LedgerTypeVariants Do
		ThisObject.Items.LedgerTypeVariantFilter.ChoiceList.Add(LedgerTypeVariant, String(LedgerTypeVariant));
	EndDo;
	
	FilterIsSet = False;
	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "LedgerTypeVariant" Then
			ThisObject.LedgerTypeVariant = FilterItem.Value;
			Items.LedgerTypeVariantFilter.Enabled = False;
			FilterIsSet = True;
		EndIf;
	EndDo;
	
	If Not FilterIsSet Then
		ThisObject.LedgerTypeVariant = Catalogs.LedgerTypeVariants.EmptyRef();
	EndIf;
	
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "LedgerTypeVariant", ThisObject.LedgerTypeVariant,
		DataCompositionComparisonType.Equal, ValueIsFilled(ThisObject.LedgerTypeVariant));	
EndProcedure

&AtClient
Procedure LedgerTypeVariantFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "LedgerTypeVariant", ThisObject.LedgerTypeVariant,
		DataCompositionComparisonType.Equal, ValueIsFilled(ThisObject.LedgerTypeVariant));
EndProcedure


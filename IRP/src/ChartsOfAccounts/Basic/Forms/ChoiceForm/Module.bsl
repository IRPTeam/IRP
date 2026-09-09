
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AccountingServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);

	LedgerTypeVariants = AccountingServer.GetLedgerTypeVariants();
	ThisObject.Items.LedgerTypeVariantFilter.ChoiceList.Add(Catalogs.LedgerTypeVariants.EmptyRef(), R().CLV_1);
	For Each LedgerTypeVariant In LedgerTypeVariants Do
		ThisObject.Items.LedgerTypeVariantFilter.ChoiceList.Add(LedgerTypeVariant, String(LedgerTypeVariant));
	EndDo;
	
	FilterIsSet = False;
	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "LedgerTypeVariant" Or FilterItem.Key = "LedgerType" Then
			
			FilterValueType = TypeOf(FilterItem.Value);
			
			If FilterValueType = Type("CatalogRef.LedgerTypeVariants") Then
				_LedgerTypeVariant = FilterItem.Value;
			ElsIf FilterValueType = Type("CatalogRef.LedgerTypes") Then
				_LedgerTypeVariant = FilterItem.Value.LedgerTypeVariant;
			Else
                                Raise StrTemplate(R().UnknownFilterType, FilterValueType);
			EndIf;
			
			ThisObject.LedgerTypeVariant = _LedgerTypeVariant;
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

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion
